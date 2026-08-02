# Your First Story — Specification to Merged PR

**Last Updated**: 02/08/2026

A walk through the whole process once, so the numbered workflows stop being abstract. Assumes a
generated project with the stack running (`04-QUICKSTART.md`).

---

## The shape

```text
specify (01–12)  →  decide & plan (13–15)  →  implement (16–18)  →  record & ship (19–21)
```

The rule that makes it work: **a code workflow is never entered directly from a design gate.**
Implementation is reached only through the PM build phases, which are themselves gated on the
specification being complete.

If that is too much for what you are doing — a spike, a proof of concept, a question you want
answered in an hour — use `/prototype` instead. It exists so the process is not the only option.

**If it is too _big_ rather than too small** — several stories' worth, and you cannot yet list the
decisions it depends on — do not start with a story. Chart it first:

```text
/wayfinder chart <epic>
```

That produces a `MAP-<EPIC>.md` of open decisions in dependency order, which you then settle one
per session with `/wayfinder resolve`. Each resolved node graduates into exactly the artefacts
below — an ADR, or a story plus its plan. See `08-CLAUDE-CODE.md` for grilling vs wayfinder.

---

## 1. Write the story

```text
Use the story orchestrator to write a user story for <what you want>.
```

Produces `project-management/src/01-STORIES/US001.md` via
`project-management/workflows/01-story-creation/`.

The agent opens with a **grilling pass** — one question at a time, each with a recommended
answer. Expect to be asked about the specific role, the measurable benefit, the edge cases, and
the MoSCoW split. Answer properly; everything downstream inherits these decisions.

A finished story has: role, goal, benefit, MoSCoW priority, Gherkin acceptance criteria, tasks,
an estimate, and a status.

## 2. Plan the sprint

`project-management/workflows/02-sprint-planning/` → `src/02-SPRINTS/SPRINT-01.md`.

A high-level record: the sprint goal and its candidate stories. The _detailed_ plan comes later,
after the design gates, because those gates change what is realistic.

## 3. Work the design gates

Only the ones your story actually touches:

| Gate            | Workflow               | Needed when                                           |
| --------------- | ---------------------- | ----------------------------------------------------- |
| Database schema | `03-database-schema/`  | New models or a schema change                         |
| User flow       | `04-user-flow-design/` | A multi-step journey                                  |
| Wireframes      | `07-wireframes/`       | New UI — **no frontend work starts without sign-off** |
| GDPR            | `08-gdpr-compliance/`  | Any personal data                                     |
| Security        | `09-security-checks/`  | Auth, permissions, or sensitive data                  |
| QA              | `10-qa-checks/`        | Always — test scenarios written before code           |
| SEO             | `11-seo-checks/`       | New public pages                                      |
| API design      | `12-api-design/`       | New or changed Ninja endpoints                        |

Each writes its artefact under the matching numbered `src/` folder, tied to `US001`.

These run on **Fable** — the reasoning tier. Specification is where thinking is cheapest.

## 4. Decide and plan

**ADRs** (`13-decisions/`) capture choices with consequences, so they are not re-litigated in
review six weeks later.

**Sprint plan** (`14-sprint-plans/`) — the definitive assignments and per-phase breakdown, written
_after_ the gates because they constrain it.

**Story plan** (`15-story-plans/`) — `STORY-PLAN-US001-*.md`. **This is what you code from.** It
references the sprint plan, the decisions, and every specification above it.

## 5. Branch

```bash
git switch -c us001/short-description
```

Branch naming is enforced: `us###/<short-desc>` for story work, `pm/<short-desc>` for process and
documentation. Full rules in `project-management/docs/GIT-GUIDE.md`.

## 6. Build

Three PM phases drive the code workflows:

| Phase               | Drives                                                      |
| ------------------- | ----------------------------------------------------------- |
| `16-backend-code/`  | `code/workflows/02-tdd-cycle/`, `09-database-migration/`    |
| `17-api-code/`      | `04-api-design/`, `02-tdd-cycle/`, `03-security-hardening/` |
| `18-frontend-code/` | `01-new-feature/`, `02-tdd-cycle/`                          |

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

`code/workflows/06-review/` — OWASP coverage, coding principles, coverage floors. A different
agent than the one that wrote the code.

For anything touching auth, permissions or personal data, also run the `security` orchestrator.

## 8. Document — the hard gate

**Nothing commits until this is done.** `project-management/workflows/19-implementation-documentation/`
owns it:

- update the directory tree in every affected `CONTEXT.md`
- create `CONTEXT.md` + `CLAUDE.md` in every new directory
- write the implementation records — GDPR, security, QA, SEO, API, review, tests
- route findings: `18-FINDINGS/`, bugs to `19-BUGS/`, refactors to `20-REFACTORING/`
- update `GAPS.md` and `DEFERRED.md`
- refresh the code-review-graph

## 9. Raise the PR

```text
Raise a PR for this branch.
```

`project-management/workflows/20-pr-and-review/`. The `pre-pr-check.sh` hook fires before
`gh pr create` and runs eight gates — format, lint, typecheck, tests, security, stubs, cloc,
lockfiles. It blocks the PR rather than letting CI find it later.

Feature branches always target `testing`, never `dev`, `staging` or `main` directly:

```text
us###/feature  →  testing  →  dev  →  staging  →  main
```

## 10. Close the story

The `completion` agent flips the status once the work is verified, and updates the story index and
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

- Take it to a server → `12-DEPLOYMENT.md`
- Something went wrong → `14-TROUBLESHOOTING.md`
