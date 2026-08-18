# Guide to Skills — What Each One Does and How to Reach It

**Last Updated**: 14/08/2026

Sixty-four skills is a lot to meet at once. You do not have to. **Describe the work in plain
English and the right one loads itself** — that is the design, and for most of a working day it is
the whole story.

This page is for the other moments: when you want to know what exists, force a specific choice, or
find the command for something you only half remember.

> **This is the human index; it is not the routing table.** `.claude/skills/CONTEXT.md` is the
> canonical roster Claude reads, and it wins on any disagreement. That file answers _when does
> Claude load this_. This one answers _what do I type_.

---

## Three ways to reach a skill

| Way                      | When                                        | Example                             |
| ------------------------ | ------------------------------------------- | ----------------------------------- |
| **Describe the work**    | Almost always. Skills fire on a description | "Something's broken in checkout"    |
| **Type a slash command** | The thirteen that define one (marked below) | `/handoff`                          |
| **Name it**              | To force a choice, or override a bad match  | "Use the `refactor` skill for this" |

Naming a skill is an override, not the normal path. If you find yourself doing it constantly,
the description match is failing and that is worth reporting.

---

## Start here — the six that cover most days

| Skill             | Reach for it when                                                         |
| ----------------- | ------------------------------------------------------------------------- |
| `implement-story` | A new capability, end to end — plan, tests, backend, frontend, docs, ship |
| `bugfix`          | Something is broken. Reproduce, root-cause, regression-test, fix          |
| `review`          | A change needs checking before you propose it                             |
| `story`           | A requirement has to become a testable `US###`                            |
| `pr`              | A finished branch is ready to propose                                     |
| `release`         | A tested branch is ready to ship                                          |

Each **sequences the others itself.** `implement-story` dispatches `planner`, `test-writer`, `database`,
`backend`, `frontend`, `code-reviewer`, `qa-tester` and `git` across eleven phases, each as its
own fresh dispatch — so reach for the skill whose remit is the **whole arc**, not the individual
layers.

**One thing comes before `implement-story`, and it is the easiest to skip.** `implement-story` starts from a
story plan; it does not chart. Anything bigger than a single session is charted with
`/wayfinder` **first**, and the stories are cut from the resolved map. The two never call each
other — they meet at an artefact: wayfinder graduates a buildable slice into
`16-STORY-PLANS/`, and that plan is exactly what `implement-story` picks up. Reach straight for
`implement-story` only when you could already write the story yourself.

---

## Plan and decide

Design work runs on the **Fable** tier, because thinking is cheapest before code exists.

| Skill               | What it is for                                                      |
| ------------------- | ------------------------------------------------------------------- |
| `/wayfinder`        | Chart a whole epic's open decisions into a map, settle it over time |
| `/grill-with-docs`  | Interrogate one design and **record** each decision as it resolves  |
| `/grill-me`         | Same interview, **records nothing** — for thinking out loud         |
| `grilling`          | The interview engine itself. Design skills load it; you do not      |
| `planner`           | Turn a story into a phased, independently-testable plan             |
| `sprint`            | Slice written stories into a balanced, dependency-ordered sprint    |
| `completion`        | Record verified work as complete in the PM artefacts                |
| `/research`         | A primary-source-cited note that feeds a decision                   |
| `/prototype`        | A throwaway spike answering exactly one question                    |
| `/to-questionnaire` | The answer lives with a client or vendor, not in the session        |
| `/scale-planning`   | Size the deployment, prove it scales, feed the deploy repo          |

**Grilling or wayfinder?** Can you list the decisions? Grill them. If the honest answer is "I do
not yet know what I need to decide", that fog is what wayfinder is for. Full comparison:
`08-CLAUDE-CODE.md`.

## Build a story

| Skill            | What it is for                                                      |
| ---------------- | ------------------------------------------------------------------- |
| `backend`        | Models, migrations, the service layer, `/api/` and `/mcp/` surfaces |
| `frontend`       | Django templates, components, HTMX, Alpine, token CSS               |
| `database`       | The data layer itself — lock-safe migrations, RLS policies, PII     |
| `authentication` | Passwords, MFA, sessions, lockout, password reset                   |
| `notifications`  | Email, SMS, push, in-app — on one branded foundation                |
| `reporting`      | Role-scoped aggregates behind a report or dashboard                 |
| `export`         | Data out as a file — CSV, Excel, PDF, JSON                          |
| `seo`            | The head, JSON-LD, canonical URLs, robots and sitemap views         |
| `logging`        | Structured logging, and stopping sensitive data reaching a channel  |
| `setup`          | New structure — a Django app, a route, env templates                |
| `test-writer`    | The failing tests, written **before** the implementation            |

## Check it before it ships

**No skill reviews its own work** — each of these runs as a separate dispatch.

| Skill            | What it is for                                                  |
| ---------------- | --------------------------------------------------------------- |
| `code-reviewer`  | Read-only review on two axes: Standards and Spec                |
| `qa-tester`      | The hostile pass — IDOR, injection, races, empty states, WCAG   |
| `security`       | OWASP, NIST and Cyber Essentials audit, threat model, hardening |
| `gdpr-mechanics` | PII, consent, DSAR, erasure, retention, the audit trail         |
| `syntax`         | The tree will not parse, lint or typecheck. Behaviour unchanged |

## Ship it

| Skill                        | What it is for                                              |
| ---------------------------- | ----------------------------------------------------------- |
| `git`                        | Branches, commits, pull requests, tags                      |
| `version`                    | Pick the increment and move the whole version set together  |
| `cicd`                       | Pipelines, Docker and Compose, deploy scripts, dependencies |
| `/resolving-merge-conflicts` | A merge, rebase or `copier update` left conflict markers    |
| `pm-tool-sync`               | The external PM-tool integration                            |

## Understand and improve the codebase

| Skill                            | What it is for                                                |
| -------------------------------- | ------------------------------------------------------------- |
| `refactor`                       | The code is correct but its shape is wrong                    |
| `codebase-design`                | The deep-module vocabulary — depth, seams, the deletion test  |
| `domain-modelling`               | Record a new concept or a decision so it is not re-litigated  |
| `/improve-codebase-architecture` | Scan for deepening opportunities, report, then grill the pick |
| `data-analysis`                  | Answer a question from the project's own data                 |

Alongside these, four **graph playbooks** (`explore-codebase`, `debug-issue`, `review-changes`,
`refactor-safely`) drive the code-review-graph MCP server. They are **auto-generated** by
`code-review-graph install` and regenerate on every run — read them, never edit them. Guide:
`code/docs/CODE-REVIEW-GRAPH.md`.

## Write documentation

Which one depends on **who reads it**, and that also picks the length rule.

| Skill               | Audience                                           |
| ------------------- | -------------------------------------------------- |
| `doc-writer`        | Developers — docstrings, the pairs, `code/docs/`   |
| `runbook`           | An operator executing a procedure under pressure   |
| `support-articles`  | End users of the product                           |
| `scaffold`          | The structure itself — pairs, workflow folders     |
| `legal-documents`   | Someone outside the business — T&C, DPA, privacy   |
| `msp-scp-documents` | Internal governance — InfoSec, retention, incident |
| `wizard`            | A bash wizard for steps only a human can do        |

## Stack references

These state conventions rather than doing work. They load inline, never fork, and mostly load
themselves when you touch the relevant code.

| Skill                  | Covers                                                      |
| ---------------------- | ----------------------------------------------------------- |
| `stack-django`         | Django 6, Django Ninja, PostgreSQL, the service layer       |
| `stack-htmx-templates` | Templates, django-components, HTMX, Alpine, token CSS       |
| `stack-fastmcp`        | The MCP tool surface at `/mcp/` (available, not wired)      |
| `global-workflow`      | Branches, commits, PRs, versioning, docs, comments          |
| `cloudinary-*`         | Three skills: docs lookup, React SDK, transformation URLs   |
| `stack-react-native`   | **Mobile-only.** Expo, expo-router, the store listing       |
| `stack-rust`           | **Rust-only.** The Cargo workspace, PyO3, supply chain      |
| `stack-slint`          | **Desktop-only.** The native app and its licence obligation |

**The last three exist only if you opted into that surface.** A skill fires on description match
rather than on being named, so shipping an unusable one would let it compete for work it cannot
do — which is why the tree and its skill are excluded together (`11-CUSTOMISING.md`).

## Getting through a session

| Skill        | What it is for                                                           |
| ------------ | ------------------------------------------------------------------------ |
| `/handoff`   | Context is filling. Write a resumable document, then stop                |
| `/wait-what` | That reply did not land. Re-pitch it in plain language                   |
| `/teach`     | Learn or practise something in a sandbox that writes only to `learning/` |
| `/incident`  | Something is broken in staging or production and you need a scribe       |

**`/handoff` is not optional politeness.** Auto-compaction is disabled and intercepted, because
silent compaction loses decisions and a written handoff does not. Run it, `/clear`, and resume
from the file.

---

## Two rules that shape every result

1. **No skill reviews its own work.** Review and QA are always separate dispatches into a fresh
   context. A skill that graded its own homework would pass every time.
2. **Every task skill that ships code documents before it commits.** That is a hard gate, not a
   final tidy-up — `12-EXTENDING.md` has the checklist it enforces.

## When a skill does the wrong thing

| Symptom                         | What to do                                                       |
| ------------------------------- | ---------------------------------------------------------------- |
| Endless questions               | That is grilling, and it is deliberate. Say "this is mechanical" |
| The wrong skill loaded          | Name the one you want explicitly                                 |
| It ignored the conventions      | It has not read `.claude/CLAUDE.md`. Ask it to, then retry       |
| You cannot find one for the job | There may not be one — `12-EXTENDING.md` covers adding it        |

---

## Next

- How routing, models and hooks actually work → `08-CLAUDE-CODE.md`
- Add your own skill → `12-EXTENDING.md`
- The canonical roster Claude reads → `.claude/skills/CONTEXT.md`
- How to write one that behaves → `how-to/docs/SKILL-AUTHORING.md`
