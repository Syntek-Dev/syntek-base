# project-management/src

**Last Updated**: <%DATE%> · **Language**: British English (en_GB)

Source artefacts for project management, planning, and compliance — a base-repo
scaffold. The numbered folders run in **three tiers**: _specify_ (01–12), _decide &
plan_ (13–15), then _implement & record_ (16–20). `00-ASSETS` is pre-workflow reference.
Each design/compliance folder (08–15) carries per-story `PLANNING/` + `IMPLEMENTATION/`
templates, mirroring the 08-GDPR pattern.

**The stack these artefacts specify.** Every template here is written against one
server-rendered stack: **Django** (+ **Gunicorn**/**Uvicorn**) · **Django Ninja** for the
JSON API at `/api/` · **Django templates** + **django-components** · **HTMX** and
**Alpine** for interactivity · **vanilla token CSS** · **PostgreSQL** · **Valkey** ·
**Celery** for background and scheduled work. On the **web surface** there is no client-side
framework and no build step — an artefact that assumes one is wrong. A project that opted into
the optional React Native **mobile surface** has a second delivery target with its own
toolchain; artefacts covering it must say so explicitly, because silence still means the web
surface. Interaction tiers and the page-vs-API split: `code/docs/RENDERING.md` ·
`code/docs/api-design/CLIENT-PATTERNS.md`.

---

## The three tiers

| Tier                   | Folders | What happens                                                                                                                                                      |
| ---------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Specify**            | 01–12   | Write the story, organise sprints, and produce every design & compliance spec — DB, user flow, brand, components, wireframes, GDPR, security, QA, SEO, API design |
| **Decide & plan**      | 13–15   | Make the architectural decisions (ADRs), then plan each sprint, then plan each story — all **before any code**                                                    |
| **Implement & record** | 16–20   | After code ships: record tests, reviews, findings, bugs, and refactoring, **per story**                                                                           |

The **story plan (15) is the master reference the developer codes from** — it points
back up to its sprint plan (14), the decisions (13), and every 01–12 spec. Sprint plans
(14) feed the story plans; the sprint plan sets the goal, story set, and sequence.

---

## Full Directory Tree

```text
project-management/src/
├── 00-ASSETS/          ← logos, brand assets, export scripts (pre-workflow reference)
│
│   ── Specify (01–12) ──
├── 01-STORIES/         ← US###.md (+ US000-TEMPLATE.md)
├── 02-SPRINTS/         ← SPRINT-##.md — backlog → sprint organisation (high-level)
├── 03-DATABASE/        ← SCHEMA-*.md, ERD-*.md, migration notes
├── 04-USER-FLOW/       ← USER-FLOW-TEMPLATE.md + DIAGRAMS/
├── 05-BRAND-GUIDE/     ← guide-build/ (Python → LaTeX → PDF brand guide)
├── 06-COMPONENTS/      ← component-build/ (Python → LaTeX → PDF component sheet)
├── 07-WIREFRAMES/      ← SCREENS/ (WF-###-*.html) + SHARED/wireframe.css
├── 08-GDPR/            ← 6 register skeletons + PLANNING/ + IMPLEMENTATION/ (per story)
├── 09-SECURITY/        ← THREAT-MODEL/ ASSESSMENTS/ AUDITS/ VULNERABILITIES/
│                          (each PLANNING/ + IMPLEMENTATION/, per story)
├── 10-QA/              ← PLANNING/ + IMPLEMENTATION/ (per story)
├── 11-SEO/             ← PLANNING/ + IMPLEMENTATION/ (per story)
├── 12-API-DESIGN/      ← PLANNING/ + IMPLEMENTATION/ (per story)
│
│   ── Decide & plan (13–15) ──
├── 13-DECISIONS/       ← ADR-###-<TITLE>.md (architectural decision records)
├── 14-SPRINT-PLANS/    ← detailed sprint execution plans
├── 15-STORY-PLANS/     ← per-story implementation plan (the code master reference)
│
│   ── Implement & record (16–20) ──
├── 16-TESTS/           ← US###-TEST-STATUS.md, US###-MANUAL-TESTING.md
├── 17-REVIEWS/         ← REVIEW-US###-<DESCRIPTOR>.md
├── 18-FINDINGS/        ← FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
├── 19-BUGS/            ← BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md
└── 20-REFACTORING/     ← REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md
```

Every folder carries a `CONTEXT.md` + `CLAUDE.md`; the 08–15 folders scaffold their
`PLANNING/` and `IMPLEMENTATION/` sub-folders with per-story `US000-TEMPLATE.md` files.

---

## Naming Conventions

| Pattern                                             | Directory                                                                                            |
| --------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `US###.md`                                          | `01-STORIES/`                                                                                        |
| `SPRINT-##.md`                                      | `02-SPRINTS/`                                                                                        |
| `USER-FLOW-<AREA>.md`                               | `04-USER-FLOW/`                                                                                      |
| `WF-###-<Screen-Name>.html`                         | `07-WIREFRAMES/SCREENS/`                                                                             |
| `GDPR-PLAN-US###-*.md` · `GDPR-IMPL-US###-*.md`     | `08-GDPR/PLANNING` · `/IMPLEMENTATION`                                                               |
| `<TYPE>-PLAN-US###-*.md` · `<TYPE>-IMPL-US###-*.md` | `09-SECURITY/<CATEGORY>/PLANNING` · `/IMPLEMENTATION` (TYPE ∈ THREAT-MODEL, ASSESSMENT, AUDIT, VULN) |
| `QA-PLAN-US###-*.md` · `QA-IMPL-US###-*.md`         | `10-QA/PLANNING` · `/IMPLEMENTATION`                                                                 |
| `SEO-PLAN-US###-*.md` · `SEO-IMPL-US###-*.md`       | `11-SEO/PLANNING` · `/IMPLEMENTATION`                                                                |
| `API-PLAN-US###-*.md` · `API-IMPL-US###-*.md`       | `12-API-DESIGN/PLANNING` · `/IMPLEMENTATION`                                                         |
| `ADR-###-<TITLE>.md`                                | `13-DECISIONS/`                                                                                      |
| `##-SPRINT-PLAN-##.md`                              | `14-SPRINT-PLANS/`                                                                                   |
| `STORY-PLAN-US###-<DESCRIPTOR>.md`                  | `15-STORY-PLANS/`                                                                                    |
| `US###-TEST-STATUS.md` · `US###-MANUAL-TESTING.md`  | `16-TESTS/`                                                                                          |
| `REVIEW-US###-<DESCRIPTOR>.md`                      | `17-REVIEWS/`                                                                                        |
| `FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`          | `18-FINDINGS/`                                                                                       |
| `BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`              | `19-BUGS/`                                                                                           |
| `REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`      | `20-REFACTORING/`                                                                                    |

Descriptors in `SCREAMING-KEBAB-CASE`; dates DD/MM/YYYY; story numbers zero-padded (`US043`).

---

## PLANNING / IMPLEMENTATION Pattern

Folders 08–15 tie their artefacts to a **user story at both ends**:

| Sub-folder        | When to write                         | Holds                                                      |
| ----------------- | ------------------------------------- | ---------------------------------------------------------- |
| `PLANNING/`       | Pre-implementation, before code       | the per-story plan/design/spec                             |
| `IMPLEMENTATION/` | Post-implementation, during PR review | the per-story verification, closing the plan with evidence |

Applies to `08-GDPR/`, `09-SECURITY/` (each of its four categories), `10-QA/`, `11-SEO/`,
and `12-API-DESIGN/`. There is no cross-cutting by-scope report folder — the per-story
plans serve that role.

---

## Cross-references

- `project-management/CONTEXT.md` — full PM layer overview and workflow gates
- `project-management/docs/VERSIONING-GUIDE.md` — semantic versioning rules
- `project-management/docs/GIT-GUIDE.md` — branch naming and PR conventions
