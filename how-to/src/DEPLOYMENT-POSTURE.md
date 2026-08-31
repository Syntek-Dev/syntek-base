# Deployment Posture — What Is Live, And What That Costs

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>

Which surfaces of <%PROJECT_NAME%> are deployed, into which environments, and what a mistake
against each one destroys. **This project's posture is `<%DEPLOYMENT_POSTURE%>`.**

**The rules that posture triggers are not here.** They live in
[`.claude/CLAUDE.md`](../../.claude/CLAUDE.md) Section 0 — the three postures, what each obliges,
and the five sharpened rules that come into force beyond `development`. That section is the same in
every project generated from this template. **This file is the answer sheet, and it is yours.**

## The posture is an answer, not an edit

The value above is rendered from `DEPLOYMENT_POSTURE` in `.copier-answers.yml`, and that is the
only place it can be changed. Both files that display it ship and are re-rendered by
`copier update`.

**Hand-editing one does not fail loudly, which is exactly why it needs a rule.** Copier's three-way
merge keeps a local edit, so a posture typed straight into this file does not bounce back — it
simply stops matching the answer it is supposed to render, permanently, with nothing reporting the
disagreement. The answers file is what the next `copier update` renders from and what any later
gate reads; and on the day the template edits this line, the drift surfaces as a merge conflict in
the authoritative rules file.

**To change it**, per [`TEMPLATE-GUIDE/14-UPDATING.md`](TEMPLATE-GUIDE/14-UPDATING.md):

1. Branch. The re-render touches every file carrying the token.
2. Edit `DEPLOYMENT_POSTURE` in `.copier-answers.yml`.
3. Run `copier update` and review the diff.
4. Update the rows below in the same commit — the posture and its evidence move together.

It moves the same way `DATE` does, and for the same reason: an answered value survives an update,
a hand-edited one does not.

**One answer covers the whole project, and it records the _highest_ posture any surface has
reached.** The rules it triggers guard the shared database and the shared API, so a live web
deployable constrains a migration whatever the desktop build is doing. Per-surface nuance is the
table below; the trigger is deliberately blunt.

## How to read a row

| Column            | Meaning                                                                    |
| ----------------- | -------------------------------------------------------------------------- |
| **Surface**       | The deployable — web/API, mobile, desktop. Absent surfaces are absent rows |
| **Environment**   | `staging` or `production`. A surface with neither is not deployed          |
| **Posture**       | That surface's own posture, which may be lower than the project's          |
| **URL / channel** | Where it answers, or the store/release channel it ships through            |
| **Live since**    | `DD/MM/YYYY` the first real user reached it. Blank until that has happened |
| **Data it holds** | The worst-case class present — none, seeded, real non-PII, real PII        |
| **Recovery**      | The named, _tested_ path back. Not "there are backups"                     |

**A row is a claim that someone can be woken up about.** Write one when the surface is actually
deployed, not when it is planned — a planned surface belongs in `GAPS.md`, and a row written early
reads to every later session as a live system that must not be disturbed.

## Surfaces

| Surface   | Environment | Posture       | URL / channel | Live since | Data it holds | Recovery |
| --------- | ----------- | ------------- | ------------- | ---------- | ------------- | -------- |
| Web + API | —           | `development` | —             | —          | Seeded only   | —        |

**Nothing is deployed.** The only environment is the local dev stack, whose URL `server.sh up`
prints and whose data `code/src/scripts/database/seed-dev.sh` creates. Add a row per surface and
environment as each first ships, and raise `DEPLOYMENT_POSTURE` in the same change.

Two surfaces have no row because they are optional and absent unless the project was generated
with them: **mobile** (`code/src/mobile/`, ships through the App Store and Google Play, so its
"environment" is a release channel and its rollback is a phased-release halt) and **desktop**
(`code/src/rust/crates/desktop/`, which ships as a signed binary and cannot be rolled back at all
once a user has installed it).

## What a recovery path has to name

The **Recovery** column is the column that stops a bad migration becoming a bad week, so it is the
one written most carefully. It names three things or it is not filled in:

- **The artefact** — which backup, taken by what. `code/src/scripts/database/backup.sh` is the
  mechanism; the row records where its output lands and how long it is kept.
- **Its age at worst** — the maximum data loss a restore accepts, in minutes or hours. This is a
  number, not "recent".
- **The last time it was restored** — `code/src/scripts/database/restore.sh` against a scratch
  database, with a date. An untested backup is an unproven claim, and this column does not hold
  unproven claims.

`code/src/scripts/database/reset.sh` is never a recovery path. It is the thing recovery exists to
undo. Beyond `development` it must not be run — a rule `.claude/CLAUDE.md` Section 0 binds Claude
to, not yet a guard the script itself enforces (`GAPS.md`, 31/08/2026).

## What is deliberately not registered

- **Environment variables, secrets and host specs.** Those are the deploy repository's
  (`<%DEPLOY_REPO%>`) and `how-to/src/SERVER-ARCHITECTURE/`'s. This register says whether a thing is
  live, never how it is configured.
- **Capacity, sizing and headroom.** `how-to/src/SCALE-ARCHITECTURE/` owns those, maintained by
  `/scale-planning`. A production row here is an input to that work, not a summary of it.
- **Incidents and their postmortems.** `how-to/docs/INCIDENT-PRACTICE.md` owns the practice and
  `project-management/src/23-INCIDENTS/` holds the records. This register is why an incident is
  possible, not what happened during one.
- **Per-page or per-endpoint availability.** A surface is live or it is not. Partial rollouts are a
  release-process concern, not a posture.
