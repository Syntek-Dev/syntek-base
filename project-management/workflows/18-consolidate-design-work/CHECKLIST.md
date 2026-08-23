---
workflow: 18-consolidate-design-work
phase: design
skills: [planner, global-workflow, codebase-design, domain-modelling]
model: fable
---

# Consolidate Design Work — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Every box must be ticked before `19-backend-code/` may begin.

---

## Entry conditions

- [ ] Every story in the cycle has a completed `STORY-PLAN-US###-*.md` in `src/17-STORY-PLANS/`
- [ ] Every sprint opened during planning has its `16-sprint-plans/` plan written
- [ ] Every in-scope story has `USER-STORY-IDEAS/` artefacts, or an explicit `N/A` with a reason
- [ ] `code/docs/DATABASE.md` and `code/docs/DESIGN-TOKENS.md` read
- [ ] Step 1 grilling pass complete and confirmed by <%DEVELOPER_NAME%>

## Inventory and findings

- [ ] An inventory table exists for every in-scope folder, built **before** any resolution
- [ ] Every duplicate, divergence, orphan, and contradiction is recorded with the stories on both sides
- [ ] If nothing was found, that is stated explicitly with the search that was run — not reported as a clean design

## Resolution

- [ ] `04-DATABASE` resolved first
- [ ] Every finding resolves to one canonical form, with the rejected alternative and the reason recorded
- [ ] Every hard-to-reverse resolution has an `ADR-###` in `src/15-DECISIONS/`, cited from the artefact
- [ ] Every capability gap discovered became a new `US###` — no scope added silently
- [ ] No unresolved duplicate remains in the consolidated set

## Schema (04-DATABASE)

- [ ] One canonical model per entity; no two stories' tables describe the same thing
- [ ] Data invariants are enforced **in the database** — FKs with explicit delete behaviour, `NOT NULL`, `UNIQUE`, `CHECK` on every bounded column
- [ ] Every scope column ships with the policy that reads it, its supporting index, and the middleware that sets its session variable
- [ ] Every PII column is flagged and classified for encryption
- [ ] The consolidated migration strategy is lock-safe (add-nullable → backfill → constrain; concurrent index builds)

## Design (04–07)

- [ ] Flows: one canonical journey per area; per-story flows carried as stubs, never duplicated
- [ ] Brand: one token set; every value DB-canonical, no raw literals
- [ ] Components: duplicates merged; every component has all states (default, hover, focus, disabled, error, success, empty)
- [ ] Components meet WCAG 2.2 AA (`code/docs/ACCESSIBILITY.md`)
- [ ] Wireframes: rebuilt on the consolidated component set, not the per-story ones
- [ ] `css-slop.sh`, `template-slop.sh` and `render-slop.sh` all exit 0 over the rebuilt set
- [ ] `render-slop.sh` actually **rendered** — a "no browser" note is a run that measured nothing, not a pass
- [ ] Every `[gate: warn]` is either fixed or annotated with `slop-allow` **naming the clause and the reason** — no bare marker, no raised threshold
- [ ] The Section 4.2 leg ran rather than skipping — a skip means an axis in `code/docs/VISUAL-DESIGN.md` Section 3 is still `TBD`
- [ ] The rebuilt set read **as a set** against Section 4.1's repetition tell and Section 4.2's rhythm clause — the two no diff-scoped review reaches. `render-slop.sh` now measures the geometry half; it counts equal boxes, and only a human can say whether the vocabulary that replaces one is right

## Generated deliverables

- [ ] `brand_guide.py --check` passes; `.py`, `.tex`, `.pdf` committed together
- [ ] `components.py --check` passes; `.py`, `section-*.tex`, `.tex`, `.pdf` committed together
- [ ] No generated file hand-edited

## Stage-1 integrity

- [ ] Every `USER-STORY-IDEAS/` file is byte-identical to before this pass — frozen, not rewritten
- [ ] Every consolidated artefact names the `US###` stories it supersedes
- [ ] Every stage-1 artefact is either carried forward or explicitly recorded as superseded

## Story-plan reconciliation

- [ ] Every `STORY-PLAN-US###-*.md` that assumed a changed shape has been corrected
- [ ] Each correction notes the consolidation that drove it
- [ ] No story plan asserts a superseded design

## Close-out

- [ ] Every touched `CONTEXT.md`/`CLAUDE.md` updated
- [ ] Code-review-graph refreshed (`code-review-graph update`)
- [ ] Instructional `.md` files still ≤ 300 code lines — `bash code/src/scripts/audits/docs-length.sh`
- [ ] British English throughout; dates DD/MM/YYYY
