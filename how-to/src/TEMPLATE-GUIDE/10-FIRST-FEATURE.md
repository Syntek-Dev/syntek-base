# Your First Feature — Idea to Merged PR

**Last Updated**: 14/08/2026

A walk through the whole process once, so the numbered workflows stop being abstract. Assumes a
generated project with the stack running (`04-QUICKSTART.md`), and that you have read
`09-PROJECT-MANAGEMENT.md` for what the folders are.

---

## The shape

```text
chart (01)  →  specify (02–14)  →  decide & plan (15–17)  →  consolidate (18)  →  implement (19–21)  →  record & ship (22–24)
```

Three properties make this work, and all three are easy to get wrong:

- **Work starts with a feature, not a story.** `01-feature-map` charts the decision frontier and
  settles it. Stories are then _cut from_ the resolved map, which is why they stop rediscovering
  the same cross-cutting questions.
- **Specify is a per-story loop, not a batch.** One story goes all the way from `02` to
  `15-decisions` before the next begins, so each is planned against everything the previous ones
  settled.
- **Sprint planning fires on fill, not per story.** Each finished story is slotted into the open
  sprint record; when it reaches the point ceiling, `16-sprint-plans` and `17-story-plans` run for
  that sprint's stories, then planning resumes.

The rule underneath it all: **a code workflow is never entered directly from a design gate.**
Implementation is reached only through the PM build phases `19`–`21`, themselves gated on
`18-consolidate-design-work` having run.

If that is too much for what you are doing — a spike, a proof of concept, a question you want
answered in an hour — use `/prototype` instead. It exists so the process is not the only option.

---

## Before any of it — four passes, once per project

Four passes run **once per project**, upstream of the numbering above. They are
`how-to/workflows/01-first-time-setup/` Steps 7 to 10, and they run in that order because each
depends on the one before: the brief names the reader, the voice is written for that reader, the
visual direction is the same doctrine in composition rather than copy, and the sizing is done for
that project. They are the easiest things to skip and the most expensive to retrofit.

### Describe what this actually is

`CONTEXT.md` opens with the answer you gave to `PROJECT_DESCRIPTION` at generation. Expand it
into a real brief and confirm it:

- **What it does** — the capability, not the technology.
- **Who it is for** — the actual user, named.
- **What it replaces** — the process, tool, or spreadsheet being displaced.
- **What it deliberately is not** — the nearest thing it will be mistaken for.

That paragraph is the first thing every agent reads in every session, because
`.claude/CLAUDE.md` imports `CONTEXT.md`. Every scope argument you will have — is this in the
feature or not, is this story a Must or a Could — resolves against it. Leave it as a
generation-time one-liner and those arguments resolve against nothing.

### Settle how it speaks, and how it looks

`how-to/src/BRAND-VOICE.md` Section 3 settles the voice — tone, person, formality, the reader, the
never-this line, the say-this-not-that vocabulary. `code/docs/VISUAL-DESIGN.md` Section 3 settles the
visual direction and pins its six axes: alignment, rhythm, contrast, ornament, density, motion.

They are one decision expressed twice, in copy and in composition, and both are read by gates
downstream. Every skill that writes a user-facing string loads the first; every wireframe
(`08-WIREFRAMES/`), every component (`07-COMPONENTS/`) and every page is composed in the second.

**The visual one is the less obvious and the more load-bearing.** Naming a direction is what
makes `VISUAL-DESIGN.md` Section 4.2's ban list decidable — a centred hero is a defect under
`editorial` and correct under `classical-symmetric`. Leave it unnamed and there is nothing to
judge a screen against, which is the vacuum the generic AI look fills.

Settled after ten screens, both are retrofits onto work nobody will go back and redo.

### Size it before you build it

```text
/scale-planning
```

Regenerates `how-to/src/SCALE-ARCHITECTURE/` and `how-to/src/SERVER-ARCHITECTURE/`, which ship
as skeletons full of `TBD — regenerate via /scale-planning`.

The point is not the server tier. It is that this pass asks — while everything is still cheap to
change — how many users, what the read/write mix is, which scaling phase-gate the design must
not foreclose, and what the server and edge have to provide.

**And it is where "not required" gets written down.** The repo is deliberately anti-forecast:
you are not authorised to provision for a million users because you hope for a million users.
What you get instead is a trajectory the architecture must stay _able_ to follow, and an
explicit list of what that means you are **not** building now. That list is what stops the first
feature carrying machinery it will never use — and what stops the fifth one being cornered by a
schema decision made in week one.

Do it after ten features and you are not planning; you are auditing choices already made.

---

## 0. Chart the feature

```text
/wayfinder chart <feature>
```

Produces `project-management/src/01-FEATURE-MAPS/MAP-<FEATURE>.md` via
`project-management/workflows/01-feature-map/` — the open decisions in dependency order, each tagged
research / tracer / grilling / task.

Charting is **one session and settles nothing** beyond research nodes. You then run
`/wayfinder resolve` once per later session: take an unblocked node, settle it by its type,
graduate the answer to an ADR or a `GAPS.md` entry, and redraw the frontier.

Stories may start once every node marked **blocking** is resolved. Fog of war may stay open — a
feature that must be fully known before any story is written is a feature that never starts.

**Skip this only for a single, well-understood story.** If you cannot yet list the decisions the
work depends on, that _is_ the signal to chart it.

## 1. Write the story

Cut from the map — not from a conversation.

```text
Use the `story` skill to write a user story for <what you want>.
```

Produces `project-management/src/02-STORIES/US001.md` via
`project-management/workflows/02-story-creation/`.

The `story` skill opens with a **grilling pass** — in rounds, each carrying a recommended
answer. Expect to be asked about the specific role, the measurable benefit, the edge cases, and
the MoSCoW split. Answer properly; everything downstream inherits these decisions.

A finished story has: role, goal, benefit, MoSCoW priority, Gherkin acceptance criteria, tasks,
an estimate, and a status.

## 2. Slot it into the open sprint

`project-management/workflows/03-sprint-planning/` → `src/03-SPRINTS/SPRINT-01.md`.

A running ledger, not a plan: the sprint goal, and each story added with its points as it clears
`15-decisions`. When the total reaches the capacity ceiling the sprint is **full**, and that is
what triggers `16-sprint-plans`.

For your first story the sprint will not be full — so you carry straight on to the design gates,
and come back to `16`/`17` later.

## 3. Work the design gates

Only the ones your story actually touches:

| Gate            | Workflow                | Needed when                                           |
| --------------- | ----------------------- | ----------------------------------------------------- |
| Database schema | `04-database-schema/`   | New models or a schema change                         |
| User flow       | `05-user-flow-design/`  | A multi-step journey                                  |
| Brand tokens    | `06-brand-guides/`      | A token is needed — usually "reused existing"         |
| Components      | `07-component-designs/` | A component is needed — usually "reused existing"     |
| Wireframes      | `08-wireframes/`        | New UI — **no frontend work starts without sign-off** |
| GDPR            | `09-gdpr-compliance/`   | Any personal data                                     |
| Security        | `10-security-checks/`   | Auth, permissions, or sensitive data                  |
| QA              | `11-qa-checks/`         | Always — test scenarios written before code           |
| SEO             | `12-seo-checks/`        | New public pages                                      |
| API design      | `13-api-design/`        | New or changed Ninja endpoints                        |

Each writes its artefact under the matching numbered `src/` folder, tied to US001.

These run on **Fable** — the reasoning tier. Specification is where thinking is cheapest.

## 4. Decide and plan

**ADRs** (`15-decisions/`) capture choices with consequences, so they are not re-litigated in
review six weeks later.

**Sprint plan** (`16-sprint-plans/`) — the definitive assignments and per-phase breakdown, written
_after_ the gates because they constrain it.

**Story plan** (`17-story-plans/`) — `STORY-PLAN-US001-*.md`. **This is what you code from.** It
references the sprint plan, the decisions, and every specification above it.

## 5. Branch

```bash
git switch -c us001/short-description
```

Branch naming is enforced: `us###/<short-desc>` for story work, `pm/<short-desc>` for process and
documentation. Full rules in `project-management/docs/GIT-GUIDE.md`.

## 6. Build

Three PM phases drive the code workflows:

| Phase               | Drives                                                                                                                                            |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `19-backend-code/`  | `code/workflows/01-implement-story/` **entered here**, plus `02-tdd-cycle/`, `03-database-migration/`, and `12-rust-extension/` on a Rust project |
| `20-api-code/`      | The same `01` pass continues — `04-api-design/`, `02-tdd-cycle/`, `08-security-hardening/`, and `05-mcp-server/` for an agent-facing surface      |
| `21-frontend-code/` | The same `01` pass closes here — `02-tdd-cycle/`, and `13-desktop-app/` on a desktop project                                                      |

**`01-implement-story` wraps all three; it does not sit under one of them.** Its own procedure runs
plan → red tests → models and migration → services → endpoints → frontend as one sequence, so it is
entered once at `19` and closed at `21`, never re-run per phase. The canonical map of which PM
workflow pairs with which code workflow is the cross-layer table in the root `REFERENCES.md` —
neither layer restates it.

Test-first throughout — Red, Green, Refactor:

```bash
bash code/src/scripts/tests/backend.sh            # full suite
bash code/src/scripts/tests/backend.sh -k test_x  # one test
bash code/src/scripts/tests/all.sh --coverage     # enforce the floor
```

Migrations:

```bash
bash code/src/scripts/database/migrate.sh make --app <app>
bash code/src/scripts/database/migrate.sh run
```

Coverage floors are 75 % line and branch, 90 % on auth. Stubs written to reach the floor are not
acceptable — the stub audit catches them.

## 7. Review

```text
Run a review pass on this branch before I raise a PR.
```

`code/workflows/07-review/` — OWASP coverage, coding principles, coverage floors. A separate
dispatch from the one that wrote the code.

For anything touching auth, permissions or personal data, also load the `security` skill.

## 8. Document — the hard gate

**Nothing commits until this is done.** `project-management/workflows/22-implementation-documentation/`
owns it:

- update the directory tree in every affected `CONTEXT.md`
- create `CONTEXT.md` + `CLAUDE.md` in every new directory
- write the implementation records — GDPR, security, QA, SEO, API, review, tests
- route findings: `20-FINDINGS/`, bugs to `21-BUGS/`, refactors to `22-REFACTORING/`
- update `GAPS.md` and `DEFERRED.md`
- refresh the code-review-graph

## 9. Raise the PR

```text
Raise a PR for this branch.
```

`project-management/workflows/23-pr-and-review/`. The `pre-pr-check.sh` hook fires before
`gh pr create` and runs eight gates — format, lint, typecheck, tests, security, stubs, cloc,
lockfiles. It blocks the PR rather than letting CI find it later.

Feature branches always target `testing`, never `dev`, `staging` or `main` directly:

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

## 10. Close the story

The `completion` skill flips the status once the work is verified, and updates the story index and
sprint record.

---

## What this feels like the first time

Slow. You will write more specification than code, and the grilling passes will ask questions you
would rather have skipped.

The payoff is on the fifth story, not the first: the decisions are recorded, the agents have real
context to work from, and a review can check the code against something other than the reviewer's
memory of a conversation.

If it is genuinely too heavy for a given piece of work, that is what `/prototype` and
`/teach` are for. Reach for them rather than doing the process badly.

---

## Next

- Take it to a server → `13-DEPLOYMENT.md`
- Something went wrong → `15-TROUBLESHOOTING.md`
