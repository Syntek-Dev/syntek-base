---
type: guide
skills: [stack-rust]
model: opus
---

# Rust Supply Chain

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB)

Why a Rust dependency carries more risk than a Python one, what `deny.toml` enforces, and how a
crate is added. Index: [`../RUST.md`](../RUST.md).

---

## Why this is stricter than the Python side

A PyO3 extension is loaded into the **same process** as Django and runs with **the same
privileges**. There is no sandbox, no separate interpreter, and no permission boundary between a
crate's `build.rs` and your environment variables.

Three properties compound:

- **crates.io has no review process.** Publishing is open to anyone; name-squatting and
  typosquatting both occur.
- **`build.rs` executes arbitrary code at build time**, on a developer laptop and in CI, before
  any of your tests run.
- **Transitive depth is high.** A single convenience crate routinely pulls in dozens of others,
  each with the two properties above.

A malicious or merely compromised crate reaches the database credentials, the encryption keys, and
the signing secrets directly. That is why `audit.sh` is a gate rather than a report, and why the
gate question in [`../RUST.md`](../RUST.md) asks whether the work needs Rust at all.

## What `deny.toml` enforces

`code/src/rust/deny.toml` is the policy; `code/src/scripts/rust/audit.sh` runs it.

| Section      | Setting                           | Why                                                                                       |
| ------------ | --------------------------------- | ----------------------------------------------------------------------------------------- |
| `advisories` | `yanked = "deny"`, empty `ignore` | Any filed RUSTSEC advisory fails the build. An empty ignore list is the default state     |
| `licenses`   | Permissive allow-list only        | A copyleft dependency propagates to everything linking the crate                          |
| `bans`       | `wildcards = "deny"`              | A `*` version means the next publish silently changes what you compile                    |
| `bans`       | `multiple-versions = "warn"`      | Usually a lagging transitive dep — but for a crypto crate it can mean two implementations |
| `sources`    | crates.io only; git denied        | A git dependency is a moving target with no signed release                                |

`multiple-versions` is a warning rather than an error because it is often outside your control.
It is never noise: read it every time, and escalate it when the duplicated crate is security
relevant.

## Adding a dependency

Follow `code/workflows/12-rust-extension/`. The short form:

1. **Justify it against the gate.** Which of the two grounds does it serve? A convenience crate
   that saves twenty lines is not a justification.
2. **Look at it.** Downloads and recent releases are weak signals; a named maintainer, a public
   repository, a populated `SECURITY.md`, and a shallow dependency tree are stronger ones.
3. **Prefer the smaller tree.** Between two crates that do the job, take the one with fewer
   transitive dependencies. Depth is the risk multiplier.
4. **Pin it in `[workspace.dependencies]`**, never per-crate — a shared pin means a patch is
   applied in exactly one place.
5. **Run `audit.sh`.** If the licence is outside the allow-list, stop: widening it is an ADR, not
   a config change.

Never vendor a crate to dodge the audit.

## For anything cryptographic

Do not implement a primitive. Use an audited implementation, and prefer one from the RustCrypto
organisation or a crate with a published third-party audit.

"Rust is memory-safe" says nothing about whether your construction is sound. Memory safety does
not give you a correct nonce discipline, constant-time arithmetic, or a sound KDF parameter
choice. Route the design through the `security` skill and
`code/workflows/08-security-hardening/`.

## Toolchain pinning

`code/src/rust/rust-toolchain.toml` pins the compiler; rustup reads it automatically, so a
developer laptop, CI and the image's build stage all compile with the same version.

The pin and `Cargo.toml`'s `rust-version` are **not** a matched set, and treating them as one was
a mistake corrected at 3.1.0. They answer different questions:

| File                  | Field          | Answers                                                          |
| --------------------- | -------------- | ---------------------------------------------------------------- |
| `rust-toolchain.toml` | `channel`      | Which compiler everyone actually builds with                     |
| `Cargo.toml`          | `rust-version` | Which dependency versions cargo may **resolve** — the MSRV floor |

A channel bump is still a template release rather than a routine dependency change: it can alter
lint behaviour across every crate at once, because new clippy lints arrive denied.

**The MSRV is a resolution input, and this guide said otherwise until 16/08/2026.** It read
_"dragging the MSRV up buys nothing, since the toolchain is pinned anyway"_ — true when
`rust-version` was only a promise to whoever compiles your source, and false under
`resolver = "3"`, which is MSRV-aware. Cargo picks the newest dependency version compatible with
the floor, so a floor left behind the channel holds the entire graph back while the pin says
nothing is wrong. Measured: at `rust-version = "1.85"` an update logged _"Locking 57 packages to
latest Rust 1.85 compatible versions"_ and **downgraded** `zbus` 5.18 → 5.14 along with
`zvariant`, `zbus_names` and `zvariant_utils`, each of which requires 1.87.

**Move `rust-version` when the graph needs it, not only when our own source does** — and say
which crate forced it, because that is the evidence the next reader needs.

### The gate's own version is pinned too

`code/src/rust/.cargo-deny-version` pins cargo-deny itself, read by both
`code/src/scripts/rust/audit.sh` and the CI job so there is one source of truth.

`cargo install --locked cargo-deny` was the previous form, and `--locked` is the part that
misleads: it pins cargo-deny's **own dependency tree**, not cargo-deny. The installed version
therefore floated, so the gate was a different tool on every run — and since a cargo-deny release
can add checks, change a default or alter how an advisory is graded, that is the one thing a
supply-chain gate must not be. A gate whose verdict moves without the code moving cannot be
trusted in either direction: a new failure looks like a regression, and a disappearing failure
looks like a fix.

Bumping it is a deliberate change, reviewed like a channel bump, because the same release can
turn a clean tree red. The pin joins the repository's other three — `.nvmrc`,
`.python-version`, and `rust-toolchain.toml` above — and the pattern behind all four is recorded
in `project-management/docs/git/PR-AND-REQUIRED-CHECKS.md` → Toolchain pins.

## Suppressing an advisory

Only in `deny.toml`, and only with a dated comment:

```toml
[advisories]
ignore = [
  # RUSTSEC-2026-0001 — the affected code path parses untrusted TIFF, which this
  # project never does. Re-check 2026-11-01 when upstream 2.x lands. — 02/08/2026
  "RUSTSEC-2026-0001",
]
```

Three rules: never suppress in CI configuration instead of here; never suppress without a re-check
date; never skip the gate to unblock a merge. An advisory you cannot justify ignoring is a
dependency you must replace or remove.

## Cross-references

- [`PYO3-BOUNDARY.md`](PYO3-BOUNDARY.md) — the boundary a compromised crate would sit behind
- `code/docs/SECURITY.md` — the OWASP controls, including `A03:2025` software supply chain failures
- `code/workflows/08-security-hardening/` — the audit any crypto crate must pass
- `how-to/workflows/07-dependency-updates/` — the cadence bumps follow

_Part of the `code/docs/rust/` sub-document family._
