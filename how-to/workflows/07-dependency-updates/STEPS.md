---
workflow: 07-dependency-updates
phase: operate
skills: [cicd, global-workflow]
model: opus
---

# Dependency Updates — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                    |
| ---- | -------------------------------------------------------------------------- |
| 1    | **Operator guides** → `how-to/src/CONTRIBUTING.md` (licensing)             |
| 2    | **External — Tools & CLI** → uv, pnpm                                      |
| 3    | **Reference guides** → CLI-TOOLING.md (install scripts)                    |
| 4    | **Cross-layer references** → `code/src/docker/CONTEXT.md`                  |
| 5    | **Cross-layer references** → `project-management/docs/VERSIONING-GUIDE.md` |

---

## Step 1 — Justify it before you add it

> **Model:** opus

Three checks, in order, before touching a manifest:

1. **Is it already in the register?** The root `pyproject.toml` lists packages
   deliberately _not_ declared, each with its trigger condition. If yours is there, confirm
   the trigger has genuinely fired — and remove the register line in the same change.
2. **Is the licence compatible?** Per `how-to/src/CONTRIBUTING.md`, GPL/AGPL needs prior
   written approval where this project's licence is commercial or proprietary.
3. **Does it earn its transitive tree?** A dependency is a permanent maintenance and
   advisory surface. A dozen lines of your own code often beats a package that brings forty.

For anything load-bearing, record the decision as an ADR
(`project-management/workflows/14-decisions/`).

---

## Step 2 — Change the manifest, then refresh the lockfile

> **↳ New dispatch:** `general-purpose` · **Skill:** `cicd` · **Model:** opus

Edit the manifest, then re-resolve through the script. **Prefer the narrowest upgrade that
solves the problem** — `--package` exists for exactly that:

```bash
bash code/src/scripts/dependencies/update.sh                                  # what is out of date
bash code/src/scripts/dependencies/update.sh --apply --package <name>         # one package
bash code/src/scripts/dependencies/update.sh --apply --ecosystem python       # one ecosystem
bash code/src/scripts/dependencies/update.sh --apply                          # everything
```

One script covers Python (`uv`), JavaScript (`pnpm`) and Rust (`cargo`), because the three
disagree about what "update" means and the differences are not worth carrying in your head.

**A floor is not a pin.** Raising `redis>=5.0.0` to `redis>=6.0` forbids redis 5; it does not
install redis 6. And latest is bounded by the rest of the graph, never by the registry —
`celery[redis]` excludes `redis>=6.5`, so a floor of `redis>=8` does not fail loudly, it drags
celery back three minors to satisfy itself. Raise a floor deliberately, say why beside it, and
re-resolve in the same change.

For an advisory fix, pin the patched version in `pnpm-workspace.yaml` `overrides` (with
`minimumReleaseAgeExclude` where the sweep's guidance calls for it) rather than loosening a
range — the repo already carries narrow overrides for exactly this, and they are scoped
deliberately.

> In **this template** `uv.lock` is absent by design, so the Python lock step produces a
> file you must not commit here. Manifest and register changes still apply; the lock lands
> in a generated project.

---

## Step 3 — Reinstall and rebuild

> **Model:** opus

```bash
bash code/src/scripts/development/install.sh
bash code/src/scripts/development/server.sh rebuild
```

An upgrade is not real until the image builds. Every Dockerfile uses `uv sync --frozen`,
so a stale lockfile fails the build rather than quietly resolving something else — which is
the behaviour you want, and the reason not to skip this step.

For a pnpm self-update, use the script that pins the new version everywhere it is
recorded, rather than upgrading in place:

```bash
bash code/src/scripts/development/pnpm-update.sh
bash code/src/scripts/development/pnpm-update.sh --pin X.Y.Z
```

---

## Step 4 — Verify against the full gate

> **Model:** opus

```bash
bash code/src/scripts/audits/security.sh
bash code/src/scripts/tests/all.sh --coverage
bash .claude/hooks/pre-pr-check.sh
```

A dependency change is exactly the kind that passes unit tests and breaks a build, a type
signature, or a runtime import. Run the whole gate (workflow `06-quality-gates`), not just
the suite covering the code you touched.

**Expect the matched-set failure.** A toolchain bump usually needs several pins moved
together — `.nvmrc`, `.python-version`, `package.json`, and the `env:` blocks in
`.github/workflows/*.yml`. A version moved in one place and not the others fails only in CI.

---

## Step 5 — Record it

> **Model:** opus

- **Commit the manifest and the lockfile together**, in a commit of their own. A lockfile
  diff buried in a feature commit is unreviewable.
- **Closing a tracking issue?** Reference it, and confirm the advisory is genuinely
  resolved rather than merely quieter.
- **Version bump:** a dependency change alone is usually a patch; a change that alters
  behaviour or adds a capability is a minor. Rules in
  `project-management/docs/VERSIONING-GUIDE.md`.
- **Removed the last consumer of a package?** Remove the package too, and put it back in
  the "deliberately NOT declared" register with the trigger that would bring it back.
