# ADR-US004: The citation gate asks the filename, not copier, whether a citer ships

**Status:** Accepted
**Date:** 02/09/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** —
**Superseded by:** —
**Related:** US004

---

## Context

Check 2 of `code/src/scripts/audits/doc-references.sh` bans a citation to a per-project instance
artefact — `US###`, `SPRINT-##`, `ADR-US###` and their siblings — on one stated reason: the reader
of a generated project has no such file. **That reason does not hold when the citing file does not
ship either.** `copier.yml` excludes `/project-management/src/**`, so a story citing a sprint
record, or an ADR citing the story that drove it, is two excluded files talking to each other and
no downstream reader is misled.

To act on that, Check 2 has to answer a question it has never asked: **does the citing file
ship?**

The script already holds a predicate for it — `is_template_only()`, over a set
`build_template_only()` derives from `copier.yml`'s `_exclude` list. Reaching for it is the
obvious move and it is the wrong one, for a reason this repository has already measured. The
builder opens with

```bash
raw="$(awk '/^_exclude:/{on=1; next} on && /^[A-Za-z_]+:/{exit} on' copier.yml 2>/dev/null || true)"
[ -n "$raw" ] || return 0
```

and `copier.yml` excludes **itself**, so in every generated project the file is absent, the set is
empty, and any exemption keyed on it evaporates without a word. `N-009` Q31 settled exactly this
question in exactly this script on 28/08/2026, choosing a hand-written glob over the derived set:

> A predicate that is correct-by-construction here and vacuous downstream is worse than a
> hand-written glob, because nothing reports its absence.

The obvious alternative fails in the opposite direction. **`project-management/src/` is not a
proxy for "does not ship":** `copier.yml:120-146` re-includes the `CONTEXT.md` and `CLAUDE.md`
pairs, every `*TEMPLATE*`, and a named allowlist of roughly twenty further files — the
`00-ASSETS/scripts/*.sh` tooling, `06-BRAND-GUIDE/guide-build/*`,
`07-COMPONENTS/component-build/*`, `08-WIREFRAMES/SHARED/wireframe.css`, six `09-GDPR/*.md`
registers, `18-TESTS/US000-*`, `23-INCIDENTS/INCIDENT-INDEX.md` and the `WALK-TESTS/` pair. Two of
those shipped files carry a genuine finding **today**:
`project-management/src/02-STORIES/CONTEXT.md:16` cites `US001.md` and
`project-management/src/03-SPRINTS/CONTEXT.md:17` cites `SPRINT-01.md`. A tree glob would silence
both.

Surfaced at `11-qa-checks` as AC-GAP-4 and AC-GAP-5 of
`project-management/src/11-QA/PLANNING/QA-PLAN-US004-CITATION-GATE-GIT-INDEX.md`.

## Options considered

### Option A — key the exemption on `is_template_only()`

- **Summary:** ask the existing predicate whether copier excludes the citing file.
- **Pros:** reads copier's real contract, so it cannot drift from it; no second list to maintain;
  one line.
- **Cons:** **inert in every generated project**, where the derived set is empty and the
  exemption silently never applies. Reproduces the defect `N-009` Q31 rejected, in the same
  script, four days later. Nothing reports the absence, so the failure is invisible on the only
  side that matters.

### Option B — key it on a `project-management/src/*` path glob

- **Summary:** exempt any citing file under the PM artefact tree.
- **Pros:** holds identically in both trees; needs no list beyond one glob.
- **Cons:** exempts roughly twenty shipped files copier re-includes, two of which carry live
  findings. Blinds the gate on a shipped file, which is the defect `N-009` was chartered to fix.
  Tightening the glob to reproduce the allowlist puts a hand-maintained copy of `copier.yml:120-146`
  in the script, which drifts the first time a row is added there.

### Option C — test whether the citing file is itself an instance artefact

- **Summary:** exempt a citer whose **filename** matches the instance forms — `US###`,
  `SPRINT-##`, `ADR-US###`, `QA-PLAN-US###`, `STORY-PLAN-US###`, `SPRINT-PLAN-##`, `REVIEW-US###`,
  `BUG-*` — with the `US000` and `*TEMPLATE*` forms excluded.
- **Pros:** a property of the citing file's own name, true in both trees and readable without
  opening `copier.yml`. Cannot reach a pair file, because a pair file is not instance-shaped —
  which makes the twenty-file allowlist irrelevant rather than merely handled. Reuses the
  alternation Check 2 already maintains for the cited side, so there is one list to keep current.
- **Cons:** introduces a second answer to "does this file ship" beside `is_template_only()`, and
  the two can disagree. A new per-story artefact class silently loses its exemption until someone
  adds it.

## Decision

**We will take Option C.** The deciding factor is that the question Check 2 needs answered is not
_"does copier exclude this file"_ but _"is this file a per-project instance"_ — and the second is
answerable from the filename alone, in both trees, without reading a file that does not travel.
Option A answers a proxy question correctly here and not at all downstream. Option B answers the
right question with the wrong instrument, and its cost is measured at twenty shipped files.

The `US000` and `*TEMPLATE*` exclusions are not decoration: they are the allowlist's only
instance-shaped entries, and without them the test would exempt the very templates the gate must
keep policing.

## Consequences

- **Positive:** the exemption behaves identically in `syntek-base` and in a generated project. The
  gate stops giving a different answer on the two sides of the copier seam for a reason no reader
  could see.
- **Positive:** the twenty-file allowlist becomes irrelevant to this clause rather than a list to
  mirror, so `copier.yml:120-146` growing a row costs this script nothing.
- **Negative / trade-off:** two predicates in one script now answer "does this ship". The boundary
  must be stated in the script's header and held: `is_template_only()` answers **what a citation
  points at**; the instance test answers **whether the citer is an instance**. A future reader who
  conflates them will reintroduce Option A.
- **Negative / trade-off:** the alternation is a hand-maintained list. A new per-story artefact
  class loses its exemption silently until added — the same maintenance burden the cited side
  already carries, now doubled in consequence rather than in length.
- **Follow-on:** the fixture pair added by US004 must cover `US000-MANUAL-TESTING.md` — instance-shaped,
  shipped, and therefore **not** exempt — because that is the case the two exclusions exist for.
- **Follow-on:** `project-management/src/15-DECISIONS/ADR-US003-CITATION-GATE-BASELINE-DIFF-02-09-2026.md`
  **retires by its own terms when US004 lands.** It is not superseded — its reasoning was correct
  and its stated condition is simply met — but a reader of that record would otherwise have no way
  to discover it had lapsed. Recorded here rather than by a status change.
- **Follow-on:** the wider question of a gate meaning the same thing downstream is
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md`'s. This record is one instance of it
  and claims none of its scope.
