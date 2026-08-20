---
name: cicd
description: >-
  Own <%PROJECT_NAME%>'s pipeline and deployment plumbing — GitHub Actions workflows, the
  Docker and Compose environment config, the deploy, rollback and health-check scripts, CI
  secrets and environment gating, and the dependency set itself: adding, upgrading or removing
  one and keeping the manifest and lockfile in step. Load when the pipeline, a container build,
  the deploy automation or a dependency needs work. Not the application code flowing through it
  (`backend`, `frontend`, `test-writer`), not the version bump or the decision to release
  (`version`, `release`), and not sizing the deployment (`scale-planning`).
context: fork
agent: general-purpose
background: false
model: opus
metadata:
  skills: global-workflow grilling
---

# Pipeline, Deployment and Dependencies (<%PROJECT_NAME%>)

**Task skill, forked** (axis 3 — an executable task whose output is workflow, Compose, script or
manifest changes).

You own the **plumbing**, not the code that flows through it.

---

## The brief arrives settled

A fork cannot ask, so the brief must carry **the target environments**, **the secrets and
variables each stage needs by name**, **the rollback strategy**, and **the health checks that
gate promotion** — or, for dependency work, **which package and why**. Where those are open,
that is a `grilling` pass run inline first.

## The pipeline already exists — extend it, never replace it

**CI workflows** (`.github/workflows/`) group as syntax, tests, audits, and other. **Read the
directory before adding to it**; a workflow that duplicates an existing gate makes both of them
untrustworthy.

**Three environments**, driven by the Compose files in `code/src/docker/`: dev
(`docker-compose.dev.yml`, feature branches, local only) · staging
(`docker-compose.staging.yml`, the staging branch, deployed on merge) · production
(`docker-compose.prod.yml`, `main`, **manual approval**).

**`code/src/scripts/deployment/` is a scaffold placeholder** — `deploy.sh`, `rollback.sh` and
`health-check.sh` are planned, not present. **Confirm scope before authoring one; do not invent
behaviour its `CONTEXT.md` does not promise.**

## How to work

1. **Read the target first** — the workflow YAML or Compose file being changed, plus its
   directory's `CONTEXT.md`. Match the surrounding conventions before editing.
2. **New deploy automation is a `kebab-case.sh`** under `code/src/scripts/deployment/`, honouring
   the sibling conventions (`--output` / `--quiet` / `--help`, the exit codes, `reports/`
   output). **Never a one-off host command.** Update that folder's `CONTEXT.md` as it lands.
3. **A CI step invokes a project script** — `bash code/src/scripts/tests/*.sh`, `…/syntax/*.sh`,
   `…/audits/*.sh` — never a raw package manager, `pytest`, `manage.py` or `docker` call.
4. **Pin versions.** Actions to a SHA or a major tag; base images to an explicit version.
   **Never `latest` in staging or production.**
5. **Idempotent where sensible**, and containerised work stays containerised.

## Dependencies

A dependency change runs through `how-to/workflows/07-dependency-updates/` — **never a raw
`pip`, `uv`, `npm` or `pnpm` invocation.** The manifest and the lockfile move in the same
change; a manifest edited without its lock is a build that resolves differently on the next
machine. Clearing an advisory is the same procedure, not a shortcut around it.

## Non-negotiables — enforce them in every environment

- **Secrets via environment only** — Actions secrets or environment files, never hardcoded in a
  workflow, a Compose file, or a script. Never commit `.env`.
- `DEBUG=False` in staging and production.
- `CORS_ALLOWED_ORIGINS` an explicit allowlist — never `*` outside local.
- **Production deploy requires manual approval** through a GitHub Environment protection rule.
- **The container runs as a non-root user** and sensitive ports are never exposed externally.
- Django's own admin is never mounted at `/admin/` — verify any proxy or Nginx routing you
  touch preserves that.

## Definition of done

The change is self-consistent with the existing three-tier setup; CI steps call the project
scripts rather than raw tooling; secrets externalised, versions pinned, production gated on
approval; every new script and directory carries an updated `CONTEXT.md`; British English.

## Handoff

Report what changed, which environments it affects, and every new secret or variable **by name
only**. Then name what is owed: `qa-tester` to probe the failure modes, `security` for scanning
or a deploy-path audit, `backend` to confirm the build steps match the migration and API needs,
`logging` to wire the deploy health signals into their channels, `scale-planning` where a
worker or memory change should be reconciled into the sizing envelope, `doc-writer` once a new
procedure lands, and `git` to commit it.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `how-to/workflows/07-dependency-updates/` — adding, upgrading or removing a dependency
- `how-to/workflows/01-first-time-setup/` — the environment a pipeline has to reproduce
- `project-management/workflows/23-release/` — the release and deploy procedure it serves
- `project-management/workflows/22-pr-and-review/` — the PR gates CI enforces

## Cross-references

- `code/src/docker/CONTEXT.md` — the images, the environments, the proxy config
- `code/src/scripts/CONTEXT.md` — the script grouping, flag, exit-code and `reports/` conventions
- `how-to/docs/FEATURE-DEPLOY.md` — the manual-approval gate and the non-root rule in context
- `how-to/src/SERVER-ARCHITECTURE/` — the app→server contract the Compose and deploy must satisfy
- `code/docs/SECURITY.md` — the CORS, secrets and `DEBUG` gating rules
- `code/docs/GATE-REPORTING.md` — what a gate may claim it looked at: "could not look" is never reported as "looked, and it was clean", and the absent-tool vs absent-surface line that decides which
- `code/docs/FORWARD-VOICE.md` — the sibling rule: what a shipped document may claim about a tree it will be read in, the register and the `template-only` token that declare each direction
- `code/docs/LOGGING.md` — the deploy health signals, and why each names an interface
- `how-to/docs/CELERY-FIRST-RUN.md` — bringing the worker and beat up the first time
