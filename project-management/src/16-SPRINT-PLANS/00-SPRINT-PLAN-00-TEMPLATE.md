# SPRINT-PLAN-{##} — {Sprint Goal Summary}

_Template — copy to `{exec-order}-SPRINT-PLAN-{sprint-number}.md` (both segments 2-digit
zero-padded), then replace every `{PLACEHOLDER}` and delete the `[EXAMPLE]` rows.
A sprint plan is **sprint-level orchestration**: it fixes the goal, the story set, the
priority, and the build sequence, then hands each story to its **story plan** in
`../17-STORY-PLANS/` — the master a developer actually codes from. Do **not** duplicate
per-story implementation detail (models, endpoints, components, field-level GDPR) here;
that lives in the story plan._

**Last Updated**: {DD/MM/YYYY} · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-{##}.md` · **Capacity:** {N} SP · **Stories:** {count}

---

## Sprint Goal

> {One sentence: what this sprint delivers and why it matters.}

---

> **Source Authority**
>
> `../04-DATABASE/` is the single source of truth for all table definitions, field names,
> encryption markers, and RLS policies. `../05-USER-FLOW/` is the single source of truth
> for all user interaction flows. Field names and flow steps in `../02-STORIES/` and
> `../03-SPRINTS/` reflect the design at story-writing time and **may not match the final
> schema or flows** — where they differ, this plan and all implementation follow
> `../04-DATABASE/` and `../05-USER-FLOW/`.

## Sprint Reference Documents

The specs in scope for this sprint. Each story's **story plan** (`../17-STORY-PLANS/`)
resolves these to the specific files it touches; list here only what applies sprint-wide.

| Area               | Source (fill in the specific files for this sprint)                                           |
| ------------------ | --------------------------------------------------------------------------------------------- |
| Sprint definition  | `../03-SPRINTS/SPRINT-{##}.md`                                                                |
| User stories       | `../02-STORIES/US{###}.md` (one per story)                                                    |
| Database           | `../04-DATABASE/` — `SCHEMA-*.md` · `ERD-*.md` · `ENCRYPTION-*.md` · `MIGRATION-NOTES-RLS.md` |
| User flows         | `../05-USER-FLOW/USER-FLOW-{AREA}.md` (list the flows this sprint touches)                    |
| Brand & components | `../06-BRAND-GUIDE/` · `../07-COMPONENTS/` (frontend stories only)                            |
| Wireframes         | `../08-WIREFRAMES/CONSOLIDATED-IDEAS/WF-{###}-*.html` (frontend stories only)                 |
| GDPR               | `../09-GDPR/PLANNING/GDPR-PLAN-US{###}-*.md` (per story that touches PII)                     |
| Security           | `../10-SECURITY/{CATEGORY}/PLANNING/{TYPE}-PLAN-US{###}-*.md`                                 |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US{###}-*.md` (per story)                                          |
| SEO                | `../12-SEO/PLANNING/SEO-PLAN-US{###}-*.md` (public-page stories only)                         |
| API design         | `../13-API-DESIGN/PLANNING/API-PLAN-US{###}-*.md` (per story with a Django Ninja surface)     |
| Decisions          | `../15-DECISIONS/ADR-{###}-{TITLE}.md` (ADRs this sprint must honour)                         |
| **Story plans**    | `../17-STORY-PLANS/STORY-PLAN-US{###}-*.md` — **the code master for each story**              |

---

## Stories

Prioritise with MoSCoW (see `../../docs/PLANNING-GUIDE.md`). Reserve capacity for
every **Must**; **Should**/**Could** are stretch and drop first. Avoid an all-Must sprint.

### Must

| ID                | Title                    | Phases touched           | SP  | Story plan                             | Git branch                   |
| ----------------- | ------------------------ | ------------------------ | --- | -------------------------------------- | ---------------------------- |
| US{###}           | {Story title}            | Backend / API / Frontend | {N} | `STORY-PLAN-US{###}-{DESC}.md`         | `us{###}/{short-kebab-desc}` |
| _[EXAMPLE] US001_ | _Restrict admin surface_ | _Backend_                | _3_ | _`STORY-PLAN-US001-RESTRICT-ADMIN.md`_ | _`us001/restrict-admin`_     |

### Should

| ID      | Title         | Phases touched | SP  | Story plan                     | Git branch                   |
| ------- | ------------- | -------------- | --- | ------------------------------ | ---------------------------- |
| US{###} | {Story title} | {phases}       | {N} | `STORY-PLAN-US{###}-{DESC}.md` | `us{###}/{short-kebab-desc}` |

### Could

| ID      | Title         | Phases touched | SP  | Story plan                     | Git branch                   |
| ------- | ------------- | -------------- | --- | ------------------------------ | ---------------------------- |
| US{###} | {Story title} | {phases}       | {N} | `STORY-PLAN-US{###}-{DESC}.md` | `us{###}/{short-kebab-desc}` |

### Won't (this sprint)

- US{###} — {title} — deferred because: {reason} (record in `DEFERRED.md` if it names a future story)

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** in this plan. Before
a story enters a development phase its story plan must exist and be complete. This sprint
plan sets the _what_ and _when_; each story plan sets the _how_.

| Story   | Story plan (`../17-STORY-PLANS/`) | Status ({Draft / Ready / In Progress / Done}) |
| ------- | --------------------------------- | --------------------------------------------- |
| US{###} | `STORY-PLAN-US{###}-{DESC}.md`    | {status}                                      |

---

## Phase Breakdown

Each sprint runs the same four-phase sequence; a story touches only the phases its layers
require. Tests are written **alongside** each phase, never after.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**Stories:** US{###}, US{###}
**Key deliverables:** {models / services / migrations to land — one line each, no code}

### Phase 2 — API (`../../workflows/20-api-code`)

**Stories:** US{###}
**Key deliverables:** {Ninja Schema models, endpoints, per-endpoint permission checks}

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**Stories:** US{###}
**Key deliverables:** {pages, components, data wiring — frontend stories only}

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

All stories. PR opened to the integration branch; CI must pass; QA sign-off required
before merge.

---

## Sprint-wide Constraints

Summaries only — the field-level detail lives in each story plan and the spec it cites.

### GDPR (`../09-GDPR/`)

- {e.g. new PII fields use the encrypted-field pattern; erase/export handlers extended — or "None this sprint"}

### Security (`../10-SECURITY/`)

- {e.g. permission check before business logic on every state-changing Django Ninja endpoint; user-supplied IDs verified against the caller (IDOR); rate limits — or "None this sprint"}

### QA & SEO

- QA: every Must/Should story has a QA plan in `../11-QA/PLANNING/`; no unresolved `AC-GAP` entries.
- SEO: {public-page stories meet the `../12-SEO/PLANNING/` targets — or "N/A, no public pages this sprint"}

---

## Sprint Verification Checklist

Run before closing the sprint. All must pass. (Scripts are the base-repo canonical
commands — adjust to the project's `code/src/scripts/` layout if it differs.)

```bash
bash code/src/scripts/database/migrate.sh check
bash code/src/scripts/tests/backend.sh
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

- [ ] Migrations applied and `check` reports no unapplied model changes
- [ ] Backend and frontend tests pass; coverage at or above the project floor for every module touched
- [ ] Lint and type-check pass in both layers
- [ ] OpenAPI schema at `/api/docs` regenerated and committed after any endpoint change
- [ ] No secrets, debug flags, or hardcoded IDs introduced
- [ ] Every story's GDPR, security, and SEO acceptance criteria signed off where applicable

---

## Sprint Definition of Done

- [ ] All Must stories implemented, tested, and reviewed (each story plan's own DoD complete)
- [ ] No open Critical or High security findings
- [ ] GDPR constraints implemented and verified per `../09-GDPR/`
- [ ] All QA scenarios passing (automated and manual) per `../11-QA/`
- [ ] All code merged to the integration branch; CI passing
- [ ] Sprint closed on the board; version bumped if this sprint produces a release
- [ ] Gaps found during the sprint recorded in `../09-GDPR/` / `../10-SECURITY/` as applicable
- [ ] Retrospective notes captured in the matching `../03-SPRINTS/SPRINT-{##}.md` (optional)

---

## Branch Naming Reference

| Story ID | Branch name                  | Pattern                                                            |
| -------- | ---------------------------- | ------------------------------------------------------------------ |
| US{###}  | `us{###}/{short-kebab-desc}` | `us` + 3-digit ID + `/` + title lowercased, kebab-cased, ≤ 5 words |

_[EXAMPLE] US001 → `us001/restrict-admin` · US043 → `us043/custom-user-model`_

Full rules: `../../docs/GIT-GUIDE.md`.
