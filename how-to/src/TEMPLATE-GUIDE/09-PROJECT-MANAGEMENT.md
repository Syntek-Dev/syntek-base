# The PM Layer — Using `project-management/src/`

**Last Updated**: 14/08/2026

Twenty-four numbered folders is a lot to meet at once. This explains what each is for, which ones
you will actually touch, and the two patterns that govern them — so the layer reads as a system
rather than a filing cabinet.

Read this before `10-FIRST-FEATURE.md`, which walks one feature through it end to end.

---

## The one thing to understand first

**`src/` is the living state of the project, not an archive.**

Every folder is written by a numbered workflow, and every story closes by recording not just what
was planned but **what actually shipped and where it diverged**. That makes `src/` the honest
answer to "what is this project?" — better than the plans alone, which lose the drift, and better
than the codebase alone, which loses the reasoning.

This is why `01-feature-map` reads the whole of `src/` before charting anything new: a feature mapped
against what was really built is mapped against reality.

---

## The five tiers

| Tier              | Folders | What happens                                                                |
| ----------------- | ------- | --------------------------------------------------------------------------- |
| **Reference**     | `00`    | Logos and export scripts. Not a workflow stage.                             |
| **Discover**      | `01`    | Chart the feature's decision frontier. Once per feature.                    |
| **Specify**       | `02–14` | Story, schema, flows, design, GDPR, security, QA, SEO, API. **Per story.**  |
| **Decide & plan** | `15–17` | ADRs, then the sprint plan, then the story plan.                            |
| **Record**        | `18–22` | Tests, reviews, findings, bugs, refactors. After code ships. **Per story.** |
| **Record**        | `23`    | Declared incidents. **Not** per story, and no workflow — see below.         |

```text
00-ASSETS      reference
01-FEATURE-MAPS     ← chart it (once per feature)
02-STORIES     ┐
03-SPRINTS     │
04-DATABASE    │
05-USER-FLOW   │
06-BRAND-GUIDE │
07-COMPONENTS  ├─ specify: one story at a time, 02 → 14
08-WIREFRAMES  │
09-GDPR        │
10-SECURITY    │
11-QA          │
12-SEO         │
13-API-DESIGN  │
14-LOGGING     ┘
15-DECISIONS   ← ADRs; end of the per-story loop
16-SPRINT-PLANS┐
17-STORY-PLANS ┘ ← fire when the sprint fills
18-TESTS       ┐
19-REVIEWS     │
20-FINDINGS    ├─ records, written after the code ships
21-BUGS        │
22-REFACTORING ┘
23-INCIDENTS   ← the incident register; no story, no workflow, no PII
```

**`23-INCIDENTS/` breaks both rules on this page, on purpose.** Every other folder is entered
from a numbered workflow and anchored to a `US###`; this one is entered from a guide
(`how-to/docs/INCIDENT-PRACTICE.md`) and the `/incident` skill, because an incident is
**unplanned** — there is no gate to schedule it through — and it is not caused by, scoped to, or
owned by a story. It is also **PII-free by rule**: the row says an incident happened and how it
ended, while log excerpts, identifiers and any postmortem touching personal data go to the
tracker you named at generation time. Do not go looking for `workflows/23-incidents/`.

**Workflow numbers mirror `src/` numbers through `17`.** `workflows/04-database-schema` writes
`src/04-DATABASE`, and that holds all the way to `workflows/17-story-plans` → `src/17-STORY-PLANS`.
**After `17` the two sequences stop lining up**, and reading them as though they still do is the
usual way to look for a folder that does not exist: `workflows/18-consolidate-design-work` writes
into the design folders `04`–`08` rather than into a `src/18`, and `src/18-TESTS` … `src/22-REFACTORING`
are written by the build and record phases (`19`–`22`) rather than by the workflow sharing each
number. `src/23-INCIDENTS` has no workflow at all, and `workflows/23-pr-and-review` and
`24-release` have no `src/` folder.

---

## The cadence, in one paragraph

Chart the feature (`01`). Then take **one story** all the way from `02` to `15` before starting
the next — so each story is planned against everything the previous ones settled. Each finished
story is slotted into the open sprint record with its points; when that hits the capacity ceiling,
`16-sprint-plans` and `17-story-plans` run for that sprint and then planning resumes. Once every
story is planned, `18-consolidate-design-work` unifies the design work. Only then does code start.

Full rules: `project-management/docs/PLANNING-GUIDE.md`.

---

## Two folder patterns

Most folders tie their artefacts to a story at both ends. The design folders carry an extra stage,
because design fragments across stories in a way compliance does not.

### Three-stage — `04-DATABASE` … `08-WIREFRAMES`

```text
USER-STORY-IDEAS/  →  CONSOLIDATED-IDEAS/  →  IMPLEMENTATION/
  per story             workflow 18              what shipped
  frozen once 18 runs   ← this is what gets built
```

Planning per story means each story designs the tables, flows, tokens, components, and screens it
needs **in isolation**. That is deliberate — it keeps each story thinking end-to-end — but it
guarantees drift: two stories will model the same entity differently or invent the same button
twice. `18-consolidate-design-work` reconciles it before any code.

Each of these folders also keeps one **cumulative** asset outside the stages — `ERD-DIAGRAMS/`,
`DIAGRAMS/`, `guide-build/`, `component-build/`, `SHARED/wireframe.css`. The brand and component
PDFs are regenerated **once**, at consolidation, not per story.

Two rules people get wrong:

- **Stage 1 is frozen, never deleted.** It records what each story asked for and why — the
  evidence when a consolidated decision is questioned later.
- **Build from `CONSOLIDATED-IDEAS/`.** A migration written from a stage-1 design reintroduces
  exactly the fragmentation consolidation removed.

### Two-stage — `09-GDPR` … `13-API-DESIGN`

```text
PLANNING/  →  IMPLEMENTATION/
```

A lawful basis or an API contract is genuinely per story and does not fragment a shared system, so
these need no consolidation pass. `PLANNING/` before code; `IMPLEMENTATION/` closes it with
evidence afterwards.

---

## Which folders will I actually touch?

For a normal story, most of them are `N/A` — and recording that is the correct outcome, not a
shortcut.

| Folder            | You write here when…                                      |
| ----------------- | --------------------------------------------------------- |
| `01-FEATURE-MAPS` | Starting anything bigger than one story                   |
| `02-STORIES`      | Always                                                    |
| `03-SPRINTS`      | Always — the record accumulates stories until it fills    |
| `04-DATABASE`     | The story touches the schema                              |
| `05-USER-FLOW`    | It introduces or changes a user journey                   |
| `06-BRAND-GUIDE`  | It needs a token — usually "reused existing", in 3 lines  |
| `07-COMPONENTS`   | It needs a component — usually "reused existing"          |
| `08-WIREFRAMES`   | It introduces a screen                                    |
| `09-GDPR`         | It touches personal data                                  |
| `10-SECURITY`     | It ships a security surface                               |
| `11-QA`           | Always                                                    |
| `12-SEO`          | It adds a public URL — otherwise `SEO: N/A` with a reason |
| `13-API-DESIGN`   | It adds or changes Django Ninja surface                   |
| `14-LOGGING`      | It emits anything worth an operator seeing                |
| `15-DECISIONS`    | A choice is hard to reverse                               |
| `16`, `17`        | When the sprint fills                                     |
| `18`–`22`         | After the code ships                                      |
| `23-INCIDENTS`    | Something broke in staging or production — never a story  |

---

## Templates, everywhere

Every folder ships a `US000`/`000` template. **Copy it; never start from a blank file.** The
templates carry the sections that later gates check for — a hand-rolled artefact passes review and
then fails at the gate that needed the section you did not know about.

Naming is fixed per folder and documented in each `CONTEXT.md`. Descriptors are
`SCREAMING-KEBAB-CASE`; story numbers are zero-padded three digits; dates are `DD-MM-YYYY` in
filenames and `DD/MM/YYYY` in prose.

---

## Four mistakes worth avoiding

1. **Batching a gate across the backlog.** Writing all the stories, then all the schemas, throws
   away the compounding the per-story loop exists for — and turns consolidation into a ten-way
   collision instead of a two-way one.
2. **Editing stage 1 after consolidation.** It is the audit trail. Corrections go to
   `CONSOLIDATED-IDEAS/`.
3. **Skipping a folder silently.** "No SEO here" is a legitimate answer, recorded as `SEO: N/A`
   with a reason. An absent record is indistinguishable from an overlooked one.
4. **Treating records as paperwork.** `20-FINDINGS` is what makes the next story better, and the
   `IMPLEMENTATION/` records are what make `src/` trustworthy for the next feature's map. Skip
   them and the layer degrades into a plan nobody believes.

---

## Next

- Walk one feature through all of it → `10-FIRST-FEATURE.md`
- The layer's own entry point → `project-management/CONTEXT.md`
- Cadence, stories, sprints → `project-management/docs/PLANNING-GUIDE.md`
- Skills that drive these workflows → `08-CLAUDE-CODE.md`
