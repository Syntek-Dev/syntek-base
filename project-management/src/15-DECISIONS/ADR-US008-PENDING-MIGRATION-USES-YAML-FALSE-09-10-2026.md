# ADR-US008: Disable the pending migration with a YAML boolean

**Status:** Accepted
**Date:** 09/10/2026
**Deciders:** <%DEVELOPER_NAME%> — authorised adversarial remediation
**Supersedes:** `project-management/src/15-DECISIONS/ADR-US008-REPORT-COMPLETENESS-AND-PENDING-KEY-INACTIVITY-09-10-2026.md`
**Superseded by:** —
**Related:** US008

## Context

The predecessor requires a disabled pending migration, but spells its condition with default
Jinja delimiters. `copier.yml` replaces the default variable delimiters with its own pair, so
the predecessor's string does not express the intended false condition in this repository. The
pair is not spelled here because `.github/scripts/check-template-tokens.sh` scans this folder.

## Options considered

- **YAML `when: false`:** explicit boolean, independent of template delimiters.
- **`when:` with `false` wrapped in the configured delimiter pair:** works, but adds unnecessary
  rendering.

## Decision

Use YAML `when: false` on the pending cutover entry. This corrects the syntax of the already
approved inactivity requirement. All other decisions and consequences in the predecessor remain
binding: complete preview output, independent state advisory, atomic versioned release activation,
no executable placeholders and disposable-fixture release proof. Replace the false condition
with the normal after-stage predicate only in that activation commit.

## Consequences

- The pending entry is disabled without relying on template expression evaluation.
- The pending-update fixture must prove the cutover notice is absent; a successful parse alone
  does not prove inactivity.
- Align the final plan with this syntax. Runtime results remain unmeasured.
