# Framework-neutral foundation inventory

**Last Updated**: 09/10/2026

## Question

Which existing contracts require separation before syntek-base can guide and generate projects
without Django, web, Python, a database or Docker?

## Verdict

The documentation and planning foundation is reusable, but the generated baseline and generic
implementation routing require Django. Adding stack skills alone cannot produce independent
non-web projects: generation, dependencies, scripts, workflows and gates also need selected
capability contracts. This is a synthesis of the repository evidence below, not a settled design.

## Claims

| Area                 | Finding                                                                                                                                                        | Primary evidence                                                                                                                                                                                      |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Intent               | The template describes documentation, process, skills and gates as its principal reusable value, including after a framework replacement.                      | [Overview](../how-to/src/TEMPLATE-GUIDE/01-OVERVIEW.md), lines 17-28.                                                                                                                                 |
| Mandatory surface    | The source-root contract makes Django web always present; mobile, native and desktop are additions. Native means code loaded into Django.                      | [Source context](../code/src/CONTEXT.md), lines 99-120.                                                                                                                                               |
| Root rules           | Global rules name Ninja permission checks, Django admin routing, Django scaffolding scripts and a Django development host.                                     | [Manual](../.claude/CLAUDE.md), lines 264-292.                                                                                                                                                        |
| Generic task routing | Backend means models, services, Ninja and FastMCP; frontend means templates, components, HTMX and Alpine; story implementation includes these specific phases. | [Backend](../.claude/skills/backend/SKILL.md), lines 4-6; [frontend](../.claude/skills/frontend/SKILL.md), lines 4-5; [implementation](../.claude/skills/implement-story/SKILL.md), lines 4-5 and 51. |
| Workflow routing     | The story workflow declares Django/HTMX skills, requires Django admin/model work, and builds Ninja endpoints before optional mobile work.                      | [Story steps](../code/workflows/01-implement-story/STEPS.md), lines 4, 112-128, 146-159 and 208-209.                                                                                                  |
| Mobile               | The include option selects Expo React Native; the stack guide assumes that mobile consumes Django Ninja.                                                       | [Copier](../copier.yml), lines 694-715; [mobile skill](../.claude/skills/stack-react-native/SKILL.md), lines 65-69.                                                                                   |
| Native and desktop   | Rust authoring is tied to a PyO3 workspace and backend image stage. Desktop selection requires Rust and its guide assumes Django API consumption.              | [Copier](../copier.yml), lines 724-760; [desktop skill](../.claude/skills/stack-slint/SKILL.md), lines 74-85.                                                                                         |
| Operations           | Development and backend-test scripts resolve Compose files and invoke Docker; the backend test phases invoke pytest.                                           | [Development server](../code/src/scripts/development/server.sh), lines 19 and 109; [backend runner](../code/src/scripts/tests/backend.sh), lines 23-33 and 66-85.                                     |
| Dependencies         | The root manifest declares Django ecosystem dependencies, scopes lint/type checks to Django, and configures pytest paths for that tree.                        | [Python manifest](../pyproject.toml), lines 23-59, 109, 123, 184 and 219-221.                                                                                                                         |
| Generation tasks     | Manifest branding and uv locking run on generation and updates; project identity/history/register seeds are moved only on copy.                                | [Copier tasks](../copier.yml), lines 971-1047.                                                                                                                                                        |
| Database             | The stack guide classifies PostgreSQL as a required substrate rather than a replaceable provider.                                                              | [Stack guide](../how-to/src/TEMPLATE-GUIDE/02-STACK.md), lines 173-175.                                                                                                                               |
| Linux ownership      | Scaling specifies an application/server contract for a separate NixOS deployment repository and forbids writing server configuration here.                     | [Scaling skill](../.claude/skills/scale-planning/SKILL.md), lines 27-29, 155-156 and 193.                                                                                                             |
| CI and hooks         | Python CI resolves the dependency graph and invokes basedpyright. The test workflow has a backend pytest/Compose job; pre-commit type checking invokes uv.     | [Python CI](../.github/workflows/syntax-python.yml), lines 201-204; [test CI](../.github/workflows/test.yml), lines 26-34 and 108; [hooks](../lefthook.yml), lines 45-55.                             |

### Optional exclusion contract

- Optional source, scripts, specialised guides, workflows and stack skills are excluded before
  rendering through conditional `_exclude` entries. Rust and desktop include specialised CI
  exclusions; Wagtail removes governance but adds to the existing Django deployable rather than
  owning a separate source tree. [Copier](../copier.yml), lines 189-290.
- Shared files may retain presence guards: the mobile-token workflow reports success when its
  tree is absent, and the ClickUp pre-commit hook checks for its script. Removing optional source
  therefore does not necessarily remove every referring job or hook.
  [Mobile audit](../.github/workflows/audit-mobile-tokens.yml), lines 4-6;
  [hooks](../lefthook.yml), lines 247-250.
- The customisation guide permits flagged optional index references and requires matching
  exclusions for source and governance. That is an existing convention to evaluate, not proof
  that arbitrary profile combinations are supported.
  [Customisation](../how-to/src/TEMPLATE-GUIDE/11-CUSTOMISING.md), lines 92-123.

## Minimal independent-project contract to verify

These are proposed acceptance requirements derived from the coupling inventory, not current
capabilities or architectural decisions:

- **No web:** guidance and generation require no Django tree, routes, HTTP host, API adapter or
  browser test unless selected. Evidence motivating this boundary: source context and manual above.
- **No Python application:** generation does not create or mutate an application Python manifest
  or application uv lock, and CI does not resolve Django dependencies. Python used by Copier or
  governance tooling is a separate host prerequisite to decide explicitly; this inventory does
  not establish a Python-free generator. Evidence: Copier tasks and Python CI above.
- **No database:** database provisioning, migrations, row-security assumptions and persistence
  gates are absent unless selected. Evidence: the PostgreSQL substrate contract above.
- **No Docker:** a project's normal build, validation, tests and development commands work through
  its sanctioned scripts without requiring Compose. Evidence: development/backend runners above.
- **Selected governance:** a generated project's instructions, specialised skills, workflows,
  dependencies, hooks and CI agree with its capabilities; adding a capability has a documented
  update path. Evidence: optional exclusion and task contracts above.
- **Preserved project state:** updates preserve user-owned history, memory and registers, and
  preserve existing Django answers and behaviour unless a migration explicitly changes them.
  Evidence: copy-only seeds and update tasks in Copier above.

## Generator and update compatibility

- The migration register explicitly addresses developer-authored files that a template rename
  leaves behind. Existing migrations cover PM directory renumbering, feature/skill renames,
  manifest identity repair, guide-reference advisories and test-record relocation. A profile
  reorganisation crosses the same ownership boundary.
  [Copier migrations](../copier.yml), lines 808-820 and 833-956.
- Update staging cleanup is unconditional, while seed installation is copy-only. Profile-aware
  changes must preserve this distinction so an update cannot replace user-owned state with seeds.
  [Copier](../copier.yml), lines 958-967 and 971-1005.
- The update-preview script runs against a scratch copy, reports deleted/conflicted files and
  predicts stranded work and dependency drift before application. This is an existing interface
  to extend or reuse for profile transitions, not evidence that those transitions already work.
  [Update preview](../code/src/scripts/development/template-update.sh), lines 3-25, 134-179 and 191-239.
- A changed profile has a connected blast radius: selected source and manifests; locked
  dependencies; development/test scripts; specialised skills and instructions; guide/workflow
  routing; CI and pre-commit checks; generated answers; preserved developer artefacts. Evidence:
  the Claims table, optional exclusion contract and migrations above. This is the inventory's
  synthesis, not a prescribed profile storage format.

## Verification gaps

- The inspected generation workflow probes mobile false/true while checking that Python manifest
  and uv lock files exist. This does not establish independent non-web generation.
  [Template audit](../.github/workflows/audit-template.yml), lines 154-161 and 235-243.
- Manifest/parser probes provision uv and pnpm and assume Cargo/Docker on the runner. A maintained
  profile needs an explicit prerequisite and verification matrix; an absent toolchain and an
  absent capability must produce different evidence.
  [Template audit](../.github/workflows/audit-template.yml), lines 111-126.
- No generation, update, build, runtime or deployment probe was executed for this note. The
  inventory establishes coupling from files, not test pass status.
- The graph overview returned a build dated 17/09/2026 with `head_matches_build=false`; it was
  used only for orientation. Current file inspection owns the findings in this note.

## Sources

All primary sources are first-party repository files linked beside their claims. No external
sources or verbatim third-party quotations were used. Inspection date: 09/10/2026.

## Feeds

Research nodes **N-001** (coupling inventory) and **N-002** (generation/update compatibility) of
[MAP-FRAMEWORK-NEUTRAL-FOUNDATION](../project-management/src/01-FEATURE-MAPS/MAP-FRAMEWORK-NEUTRAL-FOUNDATION.md),
charted 09/10/2026.
This note is ready for destination-compatible profile and core decisions;
no ADR, story or plan has been authored, and research graduation remains pending.
