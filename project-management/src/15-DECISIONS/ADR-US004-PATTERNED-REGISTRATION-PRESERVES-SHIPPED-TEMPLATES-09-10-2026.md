# ADR-US004: Patterned registration preserves literal shipped-template presence

**Status:** Accepted
**Date:** 09/10/2026
**Deciders:** <%DEVELOPER_NAME%> — approved remediation in this conversation
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US004-REGISTER-ROWS-MAY-BIND-A-CLASS-AFTER-TESTS-SPLIT-30-09-2026.md` <!-- doc-references: template-only -->
**Superseded by:** —
**Related:** US004

---

## Context

The predecessor registers two per-story record classes using exactly three digits. That also
matches `000`, although the manual and automated `US000` templates are literal shipped files,
not future instance records. Excluding a template as a Check 2 citer says nothing about whether
Check 1 detects that template as a missing target. QA EC-01 requires both properties, but the
prior plan supplied only the citer proof and treated the target proof as covered by that fixture.

The user approved closing this gap on 09/10/2026. The accepted predecessor's decision text stays
immutable; only its Status and Superseded by metadata change. This successor states the full
registration contract and the template exception that US004 must implement.

## Options considered

### Option 1 — Literal template presence before registration

- **Summary:** Check required shipped templates as literal targets before seeded, registered or naming-row suppression; reject `US000` and `*TEMPLATE*` targets from patterned registration.
- **Pros:** Preserves the three-digit instance convention and separately proves target presence and citer policing.
- **Cons:** Adds a precedence obligation and distinct missing-target fixtures.

### Option 2 — Exclude `000` from patterned registration alone

- **Summary:** Keep exactly three digits but admit only non-zero story numbers to the record class.
- **Pros:** Prevents the class row from hiding either `US000` test template.
- **Cons:** Does not independently protect shipped templates from other suppression paths.

### Option 3 — Retain the predecessor unchanged

- **Summary:** Let every three-digit record name use class registration.
- **Pros:** No new matching rule.
- **Cons:** A missing shipped template can pass as a promised future record, contradicting EC-01.

## Decision

**Option 1 is accepted, 09/10/2026.** A register row may name a class of future per-story
instance records, using `###` translated to exactly three digit classes with the rest of the
path matched literally and as a whole. Four digits and letters never match. `US000` and
`*TEMPLATE*` targets are excluded from patterned registration: a required shipped template is
a literal presence obligation, never a forward reference. Check 1 checks that obligation before
seeded, registered or naming-row suppression; a missing target emits `[dangling path]` even
while the patterned record row is present. Existing templates remain valid targets.

US004 writes exactly two class rows in `how-to/src/PROJECT-PATHS.md`:
`project-management/src/18-TESTS/MANUAL/US###-MANUAL-TESTING.md` and
`project-management/src/18-TESTS/AUTOMATED/US###-TEST-STATUS.md`, naming their creators and
lifecycle stages. No story-plan class row is added. `code/docs/FORWARD-VOICE.md` Section 3 and
the register header own the pattern form, its template exception and the duty to add a row;
workflow checklists do not restate that duty.

Check 2's separate accepted filename-based citer rule remains in force, including its `US000`
and `*TEMPLATE*` exclusions. A shipped template citing an instance is still policed. Neither
that proof nor a green citer fixture substitutes for a missing-template-target proof.

## Consequences

- **Positive:** Future instance records remain citable without one literal register row per story; both shipped test templates must actually exist.
- **Trade-off:** Registration may still admit a future record whose story number is wrong; the corresponding story remains checkable by Check 1. Class registration does not prove story existence.
- **Follow-on:** The story, QA plan, story plan and manual guide distinguish missing-target fixtures from citer-exemption fixtures, retaining all result cells blank until execution.
- **Reporting:** Historical counts, including 16 to 38, are dated evidence. Current controlled comparisons record finding identities and composition rather than inherit numeric thresholds. The baseline-diff regime retires only under its existing terms when the gate is green; surviving findings are never reported as a pass.
