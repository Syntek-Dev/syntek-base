# SPRINT-PLAN-01 — The homes and the headroom wave 1 writes into

**Last Updated**: 02/09/2026 · **Version**: 0.1.0 · **Language**: British English (en_GB)
**Source sprint:** `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> · **Capacity:** 8 SP · **Stories:** 2

---

## Sprint Goal

> Cross-surface retry and idempotency doctrine gains one owning guide, and the audit register
> regains the room the next nine gates need to register themselves in.

---

> **Source Authority**
>
> The template's source-authority clause names `../04-DATABASE/` and `../05-USER-FLOW/` as the
> single sources of truth for schema and flows. **Neither exists for this sprint and neither is
> silently dropped:** both stories carry `DB: N/A` and `User Flow: N/A`, so there is no schema to
> defer to and no flow to follow. The authorities this sprint actually defers to are
> `code/docs/DOCUMENTATION-LENGTH.md` and `code/docs/DOCUMENTATION-PAIRING.md` for what a
> documentation file may weigh and which half of a pair a line belongs in, and
> `code/docs/GATE-REPORTING.md` for how a gate's result is reported. Where a story's wording and
> those guides differ, the guides win.

## Sprint Reference Documents

| Area               | Source                                                                                                                                                                                                                                                                               |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Sprint definition  | `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only -->                                                                                                                                                                                                                  |
| User stories       | `../02-STORIES/US001.md` <!-- doc-references: template-only --> · `../02-STORIES/US002.md`                                                                                                                                                                                           |
| Database           | **N/A** — both stories read `DB: N/A`; no model, migration or RLS policy in scope                                                                                                                                                                                                    |
| User flows         | **N/A** — both stories read `User Flow: N/A`; no user journey in scope                                                                                                                                                                                                               |
| Brand & components | **N/A** — both read `Brand: N/A` and `Components: N/A`; no rendered surface                                                                                                                                                                                                          |
| Wireframes         | **N/A** — both read `Wireframes: N/A`; no screen                                                                                                                                                                                                                                     |
| GDPR               | **N/A** — both read `GDPR: N/A`; no personal-data path                                                                                                                                                                                                                               |
| Security           | **N/A** — both read `Security: N/A`; no protected action and no new endpoint                                                                                                                                                                                                         |
| QA                 | `../11-QA/PLANNING/QA-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` · `../11-QA/PLANNING/QA-PLAN-US002-AUDITS-REGISTER-HEADROOM.md` — both **Signed off**                                                                                                                                 |
| SEO                | **N/A** — both read `SEO: N/A`; no public page                                                                                                                                                                                                                                       |
| API design         | **N/A** — both read `API: N/A`; no Django Ninja surface                                                                                                                                                                                                                              |
| Logging            | **N/A** — both read `Logging: N/A`; no log line                                                                                                                                                                                                                                      |
| Decisions          | `../15-DECISIONS/ADR-US001-INSTANCE-CITATION-UNVERIFIED-02-09-2026.md` <!-- doc-references: template-only --> · `ADR-US001-PROSE-DOCTRINE-VERIFICATION-02-09-2026.md` · `ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md` · `ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` |
| **Story plans**    | `../17-STORY-PLANS/` — **not yet written**; `17-story-plans` runs next and both are prerequisites of implementation                                                                                                                                                                  |

**Every `N/A` above is a flag reading `N/A` in both stories, not a gate anyone forgot** — the
distinction `code/docs/GATE-REPORTING.md` requires. Eleven of the thirteen flags are `N/A` in both
stories; only `QA` is live, and `Backend`/`Frontend` are `N/A` too, which is why the phase
breakdown below is mostly empty.

**One ADR in the set is not this sprint's.**
`../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md` was written for US003 in
SPRINT-02, and its Decision states it binds **every story in this backlog until the gate is
green**. US002 honours it; US001 predates it and is deliberately left as it stands, per that
record's own Consequences.

---

## Stories

### Must

| ID    | Title                                                                   | Phases touched           | SP  | Story plan                                                        | Git branch                        |
| ----- | ----------------------------------------------------------------------- | ------------------------ | --- | ----------------------------------------------------------------- | --------------------------------- |
| US002 | The audits register regains the headroom nine new gates need            | Docs only — no code lane | 3   | `../17-STORY-PLANS/STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`  | `us002/audits-register-headroom`  |
| US001 | Reliability doctrine gets an owning guide, and every pointer reaches it | Docs only — no code lane | 5   | `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` | `us001/reliability-doctrine-home` |

**Total: 8 SP against a capacity of 11.** The sprint is closed at two members by decision rather
than by fill — `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> → _Notes_ carries the reasoning.

### Should

_None. The sprint is closed._

### Could

_None._

### Won't (this sprint)

- **US003** — the absence guide, `../01-FEATURE-MAPS/MAP-ABSENCE.md` <!-- doc-references: template-only --> slice `S-01`. The third wave-0 Must, deferred to
  **SPRINT-02** on 02/09/2026 rather than admitted here: at roughly 5 SP it would have taken this
  sprint to the grace ceiling rather than its capacity, and grace exists for a story that would
  split badly, not as a routine allowance. Not a `DEFERRED.md` row — it is scheduled, not deferred.

---

## Build order — US002 before US001

**The two stories are independent.** US001 creates a new reliability family under `code/docs/`
and repoints three citations into it; US002 shrinks `code/src/scripts/audits/CONTEXT.md` and its sibling. They share
no file, so either order is correct and they may run in parallel.

**US002 goes first on blast radius**, the same tiebreak the cutting order uses. It unblocks **nine
audit registrations across eight slices and seven maps**; US001 unblocks three slices. Taking the
smaller story first also surfaces any friction in the implement tier at 3 SP rather than 5.

This is a recommendation with a stated reason, not a dependency. Nothing fails if the order is
reversed.

---

## Story Plans — the code master

Per-story implementation depth lives in `../17-STORY-PLANS/`, **not** here. Neither plan exists
yet; `17-story-plans` is the next gate and both plans are prerequisites of implementation.

| Story | Story plan (`../17-STORY-PLANS/`)                                 | Status      |
| ----- | ----------------------------------------------------------------- | ----------- |
| US002 | `../17-STORY-PLANS/STORY-PLAN-US002-AUDITS-REGISTER-HEADROOM.md`  | Not started |
| US001 | `../17-STORY-PLANS/STORY-PLAN-US001-RELIABILITY-DOCTRINE-HOME.md` | Not started |

---

## Phase Breakdown

The four-phase sequence is kept whole, with the three empty phases marked `N/A` and their reason
given rather than deleted. **The emptiness is the information**: this sprint touches no runtime
surface at all, and a reader comparing it with a later code sprint should see that at a glance.

### Phase 1 — Backend (`../../workflows/19-backend-code`)

**Stories:** none — **N/A**, both stories read `Backend: N/A`
**Key deliverables:** none. No model, service, migration or management command is in scope.

### Phase 2 — API (`../../workflows/20-api-code`)

**Stories:** none — **N/A**, both stories read `API: N/A`
**Key deliverables:** none. No Django Ninja router, endpoint or Schema, and no MCP tool.

### Phase 3 — Frontend (`../../workflows/21-frontend-code`)

**Stories:** none — **N/A**, both stories read `Frontend: N/A`
**Key deliverables:** none. No template, component, HTMX partial or Alpine behaviour.

### Phase 4 — PR & Review (`../../workflows/23-pr-and-review`)

**Stories:** US002, US001.
The only phase with content. Both stories are documentation changes verified by the audit suite
and by a recorded human read-across; there is no test suite to go green and no coverage figure to
report. Two of the four gates a story of this shape would normally name **cannot see this work** —
see _Sprint-wide Constraints_ below.

---

## Sprint-wide Constraints

### GDPR (`../09-GDPR/`)

- **None this sprint.** Both stories read `GDPR: N/A`; neither introduces a field, a store or a
  code path that could carry personal data.

### Security (`../10-SECURITY/`)

- **None this sprint.** Both read `Security: N/A`. No state-changing endpoint, no permission
  check, no user-supplied ID, so neither the OWASP A01 nor the IDOR rule has a surface to bind.

### QA & SEO

- **QA:** both stories have a signed-off plan in `../11-QA/PLANNING/` and **no unresolved
  `AC-GAP`** — US001 found six and resolved all six; US002 found eleven from 24 adversarially
  tested candidates and resolved all eleven.
- **SEO:** **N/A** — no public page in either story.

### Gate honesty — the constraint that is specific to this sprint

Two gates cannot decide what a naive checklist would claim of them, and **both stories must report
that rather than tick it**:

- **`doctrine-drift.sh` is blind to US002's files.** Its scan roots exclude `code/src/scripts/**`,
  so it cannot open either file US002 edits. Removed from that story's `QA` manifest and recorded
  `N/A` with its cause — `../15-DECISIONS/ADR-US002-BLIND-GATE-LEAVES-THE-FLAG-02-09-2026.md`.
  US001 keeps it, correctly: it reads US001's tree and was only ever blind to prose.
- **`doc-references.sh` is red before either story starts.** It is read as an **identity diff**
  against a baseline captured before the first edit, never as exit 0 —
  `../15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`. **US001's flat must-pass
  is inconsistent with this and is left standing deliberately**, per that record.

---

## Sprint Verification Checklist

Run before closing the sprint. Every command is a project script under
`code/src/scripts/**/*.sh` — never a raw `python`, `manage.py`, `pytest` or `docker` call.

```bash
bash code/src/scripts/audits/docs-length.sh
bash code/src/scripts/audits/docs-pairing.sh
bash code/src/scripts/audits/doc-references.sh
bash code/src/scripts/audits/doctrine-drift.sh
bash code/src/scripts/syntax/lint.sh --file-type markdown
bash code/src/scripts/syntax/format.sh --file-type markdown
```

<!-- The template's default block runs migrate.sh, tests/backend.sh and syntax/check.sh. They are
     replaced rather than kept-and-ticked: this sprint ships no Python, so running them would
     report a pass over an empty population. Marked N/A below with the reason, per
     code/docs/GATE-REPORTING.md. -->

- [ ] `docs-length.sh` — no file created or edited this sprint enters the warn tier without a
      dated allowance, and `code/src/scripts/audits/CONTEXT.md` has reached its target
- [ ] `docs-pairing.sh` — every new directory carries both halves, and neither half carries the
      other's headings
- [ ] `doc-references.sh` — **read as a diff**, not as exit 0; no new finding against each story's
      recorded baseline
- [ ] `doctrine-drift.sh` — run for US001; recorded `N/A` with its cause for US002
- [ ] Markdown lint and format pass
- [ ] `migrate.sh check` — **N/A**, no story here touches a model
- [ ] `tests/backend.sh` and `tests/all.sh --coverage` — **N/A**, no story here ships a code path
- [ ] `syntax/check.sh` — **N/A**, no Python or type-checked source is added or edited
- [ ] OpenAPI schema at `/api/docs` — **N/A**, no endpoint changed
- [ ] No secrets, debug flags or hardcoded IDs introduced
- [ ] Every story's GDPR, security and SEO criteria signed off — **N/A**, each flag reads `N/A`

---

## Sprint Definition of Done

- [ ] Both Must stories implemented, tested and reviewed — each story plan's own DoD complete
- [ ] No open Critical or High security findings
- [ ] GDPR constraints implemented and verified — **N/A**, the sprint's GDPR flag reads `N/A`
- [ ] All QA scenarios passing per `../11-QA/`, including the human read-acrosses that no gate
      can perform for either story
- [ ] All code merged to the integration branch; CI passing
- [ ] Sprint closed on the board; version bumped if this sprint produces a release
- [ ] Gaps found during the sprint recorded per `../09-GDPR/` / `../10-SECURITY/` where applicable
- [ ] `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> `**Status:**` moved to `Done` via the `completion` skill
- [ ] Retrospective notes captured in `../03-SPRINTS/SPRINT-01.md` <!-- doc-references: template-only --> (optional)

---

## Branch Naming Reference

| Story ID | Branch name                       | Pattern                                                            |
| -------- | --------------------------------- | ------------------------------------------------------------------ |
| US002    | `us002/audits-register-headroom`  | `us` + 3-digit ID + `/` + title lowercased, kebab-cased, ≤ 5 words |
| US001    | `us001/reliability-doctrine-home` | as above                                                           |

**Both branches are cut from `main`, and not yet** (decided 02/09/2026). Every planning artefact
these stories depend on — the stories, this plan, the QA plans, the ADRs and the sprint record —
is uncommitted on `pm/story-creation`, so a branch cut from `main` today could not see any of it.
**The sequence is: every story completes its planning workflows → `pm/story-creation` is raised as
a PR to `main` → the `us###/` branches are cut from `main` and the stories implemented.** A branch
cut earlier inherits a tree in which its own plan does not exist.

Full rules: `../../docs/GIT-GUIDE.md`.
