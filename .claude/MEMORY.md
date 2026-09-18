# .claude/MEMORY.md — Project Memory

Read this at the start of every session. Write here instead of the global auto-memory system.

Sections: **Feedback** (<%DEVELOPER_NAME%>'s guidance on approach) · **Project Patterns** (conventions discovered
during work) · **Project State** (business/stack facts not derivable from the codebase)

To add an entry: append a subsection under the correct heading, titled
`### <what was learned> — DD/MM/YYYY`. Keep entries concise — one paragraph max. Update or
remove stale entries rather than appending contradictions.

**Do not write here:** active gaps, blockers, sprint dependencies → those go in `GAPS.md`.

> **This file is syntek-base's own, and copier excludes it.** A generated project is seeded a
> blank canvas from `.copier/MEMORY.md` instead, because Section 2.1 has every session read this file
> second and believe it — so the template's memory arriving as a project's own is read as
> authoritative. Write repo-specific state here freely; it never ships. Doctrine that every
> project needs is not memory and belongs in the `docs/` guide that owns it.
> Gate: `.github/scripts/shipped-memory.sh`. <!-- doc-references: template-only -->

---

## Feedback

_No entries yet._

---

## Project Patterns

- **syntek-base may author ADRs of its own** (31/08/2026, `MAP-PROGRESSIVE-ENHANCEMENT` N-026), <!-- doc-references: template-only -->
  reversing the 16/08/2026 decline whose stated reason — that `15-DECISIONS/` ships into every
  generated project — was measured false. **The exclusion is the permission**: `copier.yml` <!-- doc-references: template-only -->
  excludes `/project-management/src/**` and re-includes only `**/CONTEXT.md`, `**/CLAUDE.md` and
  `**/*TEMPLATE*`, so an ADR written here is tracked, syncs across devices, and was proved by
  probe not to travel. Only this repo-specific permission stays here: the doctrine it rests on —
  an ADR needs a driving `US###`, and a map reaches one only through the slice that becomes a
  story — is in `project-management/src/15-DECISIONS/CLAUDE.md` and the wayfinder graduation
  table. There is no non-shipping doc that could hold the permission itself.

---

## Project State

### The Playwright pin's value comes from this machine's Nix config — 18/09/2026

`audits/playwright-pin.sh` holds the eight in-repo declarations of the Playwright release in
step with each other, and deliberately never compares them to a host's browsers. On **this**
machine the browsers arrive as a Nix store bundle, so the release that matches it is reported by
`just check-playwright` in `~/Repos/personal/nix-config` (`justfile:210`) — that command is where
the number on `PLAYWRIGHT_PIN` comes from when the bundle bumps. It lives here rather than in a
shipped file because a generated project has no nix-config: the shipped half states only that the
bundle's owner reports the value (`render-slop.sh`, `15-TROUBLESHOOTING.md`). A bundle bump is the
one change the gate cannot start — it can only confirm every site followed.

### argon2-cffi and cryptography wait for syntek-modules — 01/09/2026

`argon2-cffi` and `cryptography` are declared in `pyproject.toml` but deliberately unwired —
no `PASSWORD_HASHERS` in `base.py`, so runtime hashes with Django's PBKDF2 default (measured
01/09/2026, `MAP-UPSTREAM-TRACKING.md` N-017 sitting). Sam: the **syntek-modules authentication
module** owns wiring Argon2 and the crypto setup; projects may choose their own hashing/crypto,
and the docs recommend the secure default. Not a gap — staging for that module; do not re-raise
it as one.
