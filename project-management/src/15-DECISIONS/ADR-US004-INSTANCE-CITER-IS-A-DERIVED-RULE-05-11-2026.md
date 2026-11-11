# ADR-US004: The citation gate derives whether a citer is an instance from its name, not from a list of forms

**Status:** Superseded
**Date:** 05/11/2026
**Deciders:** <%DEVELOPER_NAME%>
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md`
**Superseded by:** `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-CITER-ADMITS-STORYLESS-DATED-RECORDS-06-11-2026.md`
**Related:** US004

---

## Context

`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md`
(restating `project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-02-09-2026.md`)
decided two things about Check 2 of `code/src/scripts/audits/doc-references.sh`:

1. **Whether a citing file is a per-project instance is read from its own filename**, never from
   `is_template_only()` and never from a `project-management/src/*` path glob.
2. **The filename is tested against a closed list of eight instance forms** — `US###`,
   `SPRINT-##`, `ADR-US###`, `QA-PLAN-US###`, `STORY-PLAN-US###`, `SPRINT-PLAN-##`,
   `REVIEW-US###`, `BUG-*` — minus the `US000` and template forms.

**This record keeps the first and replaces the second.** The reasoning for the first — why
`is_template_only()` is vacuous in a generated project (`copier.yml` excludes itself, `N-009` Q31)
and why a tree glob blinds the gate on roughly twenty shipped files — is the superseded record's
_Context_ and _Decision_
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md:12-151`),
and it is cited, not re-argued.

**The risk the superseded record named has materialised.** Its own Consequences recorded that "a
new per-story artefact class loses its exemption silently until added"
(`project-management/src/15-DECISIONS/ADR-US004-INSTANCE-ARTEFACT-CITER-TEST-AFTER-TESTS-SPLIT-30-09-2026.md:172-173`).
The green phase shipped the list as `INSTANCE_CITER_RE`
(`code/src/scripts/audits/doc-references.sh:612`), and the per-story instance forms on disk on
05/11/2026 already outnumber it. Each of these folders holds per-story files named with `US###`
that none of the eight forms matches (listed 05/11/2026; the `US000-TEMPLATE` files excluded):

| Form                      | Folder                                                      | Instances on disk |
| ------------------------- | ----------------------------------------------------------- | ----------------- |
| `THREAT-MODEL-PLAN-US###` | `project-management/src/10-SECURITY/THREAT-MODEL/PLANNING/` | 6                 |
| `ASSESSMENT-PLAN-US###`   | `project-management/src/10-SECURITY/ASSESSMENTS/PLANNING/`  | 6                 |
| `LOGGING-PLAN-US###`      | `project-management/src/14-LOGGING/PLANNING/`               | 1                 |
| `GDPR-PLAN-US###`         | `project-management/src/09-GDPR/PLANNING/`                  | 1                 |
| `QA-IMPL-US###`           | `project-management/src/11-QA/IMPLEMENTATION/`              | 4                 |
| `FINDING-US###`           | `project-management/src/20-FINDINGS/`                       | 4                 |

The rest of the classes the grilling named exist today only as their shipped templates, waiting
for a first story to instantiate them: `SEO-PLAN-US###` and `API-PLAN-US###`, every other
`<TYPE>-IMPL-US###` (database, user flow, brand, components, wireframes, GDPR, SEO, API, security
assessment and audit), and `REFACTORING-US###`. Each would lose its exemption the day its first
instance is written, without the gate saying so.

**Measured cost.** Run on the green-phase script with `--path project-management/src` on
05/11/2026, Check 2 reports **47 instance citations**. **45** sit in three instance forms the
list omits — 24 in `LOGGING-PLAN-US###`, 15 in `ASSESSMENT-PLAN-US###`, 6 in
`THREAT-MODEL-PLAN-US###` — and are false positives by the superseded record's own reasoning: two
excluded files talking to each other. The other **2** are genuine findings in shipped files,
`project-management/src/00-ASSETS/scripts/pm-board.sh:260` and
`project-management/src/15-DECISIONS/CONTEXT.md:17`, and must survive any fix.

**Why no shipped file is affected today.** Under `project-management/src/` copier excludes the
tree (`copier.yml:157`) and re-includes the documentation pairs (`copier.yml:160-161`), every
`*-TEMPLATE.*` (`copier.yml:167`), and a named allowlist (`copier.yml:169-191`). Read on
05/11/2026, the only allowlist entries whose basename carries `US###` or `SPRINT-##` are the two
test-record templates at `copier.yml:188-189` — both `US000` — and none starts `BUG-`. So every
instance-shaped basename that ships from this tree is a `US000` or a `-TEMPLATE.` one, which are
the two exclusions.

Surfaced at US004's green round and settled by <%DEVELOPER_NAME%> on 05/11/2026, build grilling
round 2 Q1 (`project-management/src/17-STORY-PLANS/05-STORY-PLAN-US004-CITATION-GATE-GIT-INDEX.md`,
_Key Decisions_, row "Citer test shape, 05/11/2026").

## Options considered

Numbered, so they cannot be read as the 02/09/2026 record's Options A to C, whose choice of
Option C (read the citer's filename) stands.

### Option 1 — a derived rule over the citer's basename

- **Summary:** a citing file is an instance artefact when its basename carries `US[0-9]{3}` or
  `SPRINT-[0-9]{2}`, or starts `BUG-` — excluding any name carrying `US000` and any `-TEMPLATE.`
  name.
- **Pros:** reads the property every per-story artefact shares — the naming convention binds a
  story or sprint number into the name — rather than enumerating the artefacts. A new per-story
  class is exempt on the day its first instance is written, with no edit to the script. Clears the
  45 false positives and leaves the 2 shipped findings standing, once the sprint-plan form below
  is held. One short rule replaces a second
  alternation the script would otherwise keep beside `INSTANCE_CITED_RE`.
- **Cons:** broader by construction — any non-template file named with a story number is exempt,
  wherever it lives. Safe only while copier ships no such file (Consequences).

### Option 2 — extend the list by the seven forms

- **Summary:** add `THREAT-MODEL-PLAN-US###`, `ASSESSMENT-PLAN-US###`, `LOGGING-PLAN-US###`, the
  GDPR, SEO and API planning forms, `<TYPE>-IMPL-US###`, `FINDING-US###` and `REFACTORING-US###`
  to `INSTANCE_CITER_RE`.
- **Pros:** exact — exempts precisely the named forms; the narrowest change to shipped code.
- **Cons:** keeps the defect, not the symptom. The list missed seven live classes before it
  shipped; every new per-story artefact type re-opens it, and the failure is a silent false
  positive found only when someone reads the report.

### Option 3 — keep the eight forms and carry the 45 as survivors

- **Summary:** change nothing; name the false positives as known survivors.
- **Pros:** no change to the script or the fixtures.
- **Cons:** a survivor list grows with every story, and buries the two genuine findings in noise
  the gate itself generates. Contradicts the superseded record's own reasoning that these
  citations mislead no one.

## Decision

**We will take Option 1.** Check 2 exempts a citer whose **basename** carries `US[0-9]{3}` or
`SPRINT-(PLAN-)?[0-9]{2}`, or starts `BUG-`, unless the basename carries `US000` or `-TEMPLATE.` — the
copier spelling, mirroring `copier.yml:167`, decided the same day (story plan _Key Decisions_,
row "Template spelling, 05/11/2026"). The test still reads the citer's filename and never calls
`is_template_only()`; that half of the superseded decision stands unchanged, with the reasoning it
cites.

The deciding factor is drift. The superseded record chose a filename test so the question "is
this file a per-project instance" would be answerable without a list that drifts from
`copier.yml`; keying it on a closed list of forms rebuilt that drift one level down, and measured
seven omitted classes before the list shipped. Every per-story artefact's name carries its story
or sprint number by convention, so the derived rule tracks the convention rather than a copy of
it.

`BUG-` is matched by prefix because a bug record need not name a story: `21-BUGS/` holds
`BUG-LINT-READS-GITIGNORED-GRAPHIFY-OUT-02-11-2026.md` and
`BUG-TEST-RECORD-CLAIMS-PROJECT-COVERAGE-FOR-UNTESTED-STORY-02-11-2026.md` beside the
`BUG-US###` ones.

**The numbers are bounded.** A story number is exactly three digits and a sprint number exactly
two, so a digit run is not read as one when another digit follows it: a name carrying "US1234"
is not an instance citer, at the start of the name or in the middle. The anchored list read the
first three digits of "US1234-…" and exempted it; the derived rule must not inherit that, nor
widen it to the mid-name case.

**Settled at sign-off — the sprint-plan form.** As first drafted, the rule did not match a
sprint plan: `##-SPRINT-PLAN-##.md` carries "SPRINT-PLAN-07", never "SPRINT-" followed by two
digits. The eight-form list exempted it through `([0-9]{2}-)?SPRINT-PLAN-[0-9]{2}`, and the
green-phase P3 proof pins the exemption on the fixture
`code/src/scripts/audits/fixtures/doc-references/clean/07-SPRINT-PLAN-07.md`. A probe copy carrying
the first-draft clause failed that proof and reported **36** instance citations on the PM tree
rather than 2 — the 2 shipped findings and 34 in five sprint plans (05/11/2026). The sprint clause
is therefore widened to `SPRINT-(PLAN-)?[0-9]{2}`: one clause per artefact family, the same
coverage the list gave, still a derived property of the naming convention (settled 05/11/2026,
US004 build grilling round 3 Q1, option 2 of 3 — a separate fourth clause and leaving sprint plans
out were the others).

## Consequences

- **Positive:** a new per-story artefact class is exempt from its first instance; the citer side
  stops needing a hand-maintained alternation, and the drift the superseded record accepted as a
  trade-off is removed rather than managed.
- **Positive:** with the sprint clause widened, Check 2's PM-tree report falls from the 47 of
  05/11/2026 to the 2 shipped findings, so what it reports there is what a generated project
  would read. Without the widening, the probe measured 36 (_Decision_, _Settled at sign-off_).
- **Negative / trade-off — a shipped file named with a story number would be wrongly exempt.**
  If copier ever re-included a non-template file whose basename carries `US###` or `SPRINT-##` or
  starts `BUG-`, its instance citations would pass Check 2 although a generated project reads
  them. Copier makes that impossible from `project-management/src/` today: the allowlist's only
  such entries are the `US000` test records (`copier.yml:188-189`), and every other re-include is
  a pair file, a `-TEMPLATE.` file or a basename with no story number. **The guard is a review
  duty on `copier.yml`:** a new re-include with a story number in its name re-opens this record.
- **Negative / trade-off — outside `project-management/src/`, the rule's reach is wider than the
  list's.** `handoffs/HANDOFF-US###-*` gains the exemption; copier excludes `handoffs/**`
  (`copier.yml:149`), so it ships nowhere. The ClickUp exports `US###-CLIENT.md` under
  `project-management/export/clickup/` do ship when `INCLUDE_CLICKUP` is true
  (`copier.yml:312`), but the eight-form list's `US###` form already exempted them, so this
  decision changes nothing there.
- **Negative / trade-off — two predicates still answer "does this ship".** Unchanged from the
  superseded record: `is_template_only()` answers what a citation points at; the instance test
  answers whether the citer is an instance. The boundary stays stated in the script's header.
- **Follow-on:** `INSTANCE_CITER_RE` and `is_instance_citer()`
  (`code/src/scripts/audits/doc-references.sh:612-618`) are replaced by the derived rule in
  US004's green round; `INSTANCE_CITED_RE`, the cited side, is untouched.
- **Follow-on:** the round-2 fixtures in `code/src/scripts/audits/fixtures/doc-references/` pin
  the rule (the self-test's R2.1 block). Clean probes, one per live class the eight forms
  omitted — threat-model plan, assessment plan, logging plan, QA implementation record, finding,
  refactoring record — prove the exemption; guard probes prove it does not over-reach: a
  four-digit "US1234" at the start or mid-name, a "USabc" name, a zero-index finding, a
  `-TEMPLATE.` threat-model plan and a plain guide all stay reported. Together with the P3 proofs
  they are this record's executable statement, and they are written red first.
- **Follow-on:** carried forward unchanged from the superseded record — the
  `project-management/src/18-TESTS/MANUAL/US000-MANUAL-TESTING.md` fixture case (instance-shaped,
  shipped, not exempt); the retirement of the US003 baseline-diff decision when US004 lands; and
  `project-management/src/01-FEATURE-MAPS/MAP-GATE-PARITY.md` owning the wider parity question.
- **Follow-on:** US004's implementation reads this record, not the superseded one, for Check 2's
  citer exemption; the driving story's _Decisions_ list gains it at acceptance.
