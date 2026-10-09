# MAP-FRAMEWORK-NEUTRAL-FOUNDATION — Shared engineering guidance and composable project generation

**Charted**: 09/10/2026 · **Charted by**: Sam and Codex · **Workflow**: `01-feature-map`
**Status**: Charting
**Frontier open**: 32 · **Blocking open**: 20 · **Slices**: 9

This is syntek-base's own decision map. It is excluded from generated projects; the resulting
engineering guidance and generation capabilities are what projects inherit.

---

## Destination

Syntek-base supplies reusable engineering guidance and generates projects across web frameworks,
CLI, TUI, GUI, mobile, Linux configuration and cybersecurity work, with composable technical profiles.
Coverage is extensible; maintained profiles have explicit verification evidence and support bounds.

---

## Notes

| Field                    | Value                                                                                                                                                   |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Domain                   | Engineering standards, skills, project generation, application and configuration repositories                                                           |
| Skills to load           | `wayfinder`, `grill-with-docs`, `codebase-design`, `research`; downstream `scaffold`, `doc-writer`, `cicd`, `test-writer`, `review`                     |
| Confirmed scope          | Sam chose guidance **and** generation, and extensible coverage with tested maintained profiles, on 09/10/2026                                           |
| Standing preferences     | Framework-specific rules become selected guidance; standalone tools and configurations must not require a Django application                            |
| Umbrella ADRs            | None. Story-bound ADRs are authored by the slices' stories, through the existing PM workflow                                                            |
| Register entries triaged | 0 closes · 4 blocks · 17 unrelated = 21 entries; `DEFERRED.md` has no rows; SL-1 to SL-3 exempt                                                         |
| Research dispatched      | N-001 and N-002 returned [the repository inventory](../../../research/FRAMEWORK-NEUTRAL-FOUNDATION-INVENTORY.md); results inform later RESOLVE sessions |
| Scale baseline           | `how-to/src/SCALE-ARCHITECTURE/` contains application-oriented skeletons and unset targets; no hardware sizing or capacity claim is made here           |
| Evidence limitation      | The graph's 17/09/2026 build differs from current HEAD. Current file inspection supplies this chart's evidence                                          |

### Coverage axes to resolve

These are a scope inventory, not a settled schema or a supported-product catalogue.

| Concern                         | In-scope examples                                                              | Separation to preserve                                                                         |
| ------------------------------- | ------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| Language                        | Python, Rust, C, C++, Go, JavaScript/TypeScript; other languages when relevant | A language may serve several interfaces and frameworks                                         |
| Framework                       | Django, additional web frameworks, Slint, mobile frameworks                    | A framework does not imply a mandatory backend or database                                     |
| Interface                       | Web, API, CLI, TUI, desktop GUI, mobile, service                               | Standalone, offline and multi-surface projects are legitimate                                  |
| System tooling and distribution | Nix tooling, NixOS, Debian, Arch and other Linux distributions                 | Nix tooling and NixOS are distinct choices                                                     |
| Machine role                    | Server, PC/workstation, router, NAS and other devices                          | Distribution and role compose; hardware and deployment architecture remain explicit            |
| Domain                          | Applications, infrastructure, cybersecurity                                    | Security requirements apply broadly; specialist security work has its own mission and evidence |

### Existing owners and registration

- [MAP-INSTRUCTION-DELIVERY](MAP-INSTRUCTION-DELIVERY.md) owns the neutral AI instruction layer,
  host adapters, MCP declaration arrangement and instruction budgets. This map owns which
  project-specific technical guidance is selected, not a second host-delivery migration.
- [MAP-NATIVE-MOBILE-SURFACE](MAP-NATIVE-MOBILE-SURFACE.md) records Kotlin/Swift, retirement of
  React Native, and exclusion of KMP for that migration. N-017 reconciles the broader catalogue
  with those bounds; the new scope does not silently reverse them or select a new mobile stack.
- [MAP-BUN-TOPOLOGY](MAP-BUN-TOPOLOGY.md) owns its JavaScript toolchain migration. N-009 separates
  generation-host tooling from project tooling without selecting Bun, pnpm or another replacement.
- [MAP-NATIVE-DESIGN-TIER](MAP-NATIVE-DESIGN-TIER.md) owns its token-source, design-output and
  human-approval changes. Interface profiles consume or reconcile those outcomes; N-019 does not
  introduce a competing token source or approval mechanism.
- [MAP-GATE-PARITY](MAP-GATE-PARITY.md) owns equivalent gate meaning in template and generated
  trees. N-022 extends the measured population without redefining exemptions.
- [MAP-UPSTREAM-TRACKING](MAP-UPSTREAM-TRACKING.md) owns dependency watcher/trigger/owner
  conventions. Maintained profiles extend that contract; security advisories remain a distinct signal.
- `code/docs/architecture/PROVIDER-NEUTRALITY.md` owns provider seams versus substrate.
  Selecting a different framework is a project-generation choice, not proof that application code
  can swap frameworks. PostgreSQL-specific guarantees remain explicit where selected.
- `code/docs/architecture/BUILD-OPERATE-SEAM.md` owns application/deploy-repository contracts.
  N-014 decides how configuration projects fit that ownership; no machine configuration is edited here.
- **Index row withheld deliberately.** [MAP-REGISTER-INDEXES](MAP-REGISTER-INDEXES.md) N-001 and
  S-01/S-02, now carried by [US010](../02-STORIES/US010.md), own relocation/backfill into a
  non-shipping `MAP-INDEX.md`. It does not exist at charting. The existing ruling declines a
  per-project row in the shipped `CONTEXT.md`; this map follows that ruling and awaits backfill.

### Suggested RESOLVE batches

After reviewing N-001/N-002's evidence, start with **N-003, N-004 and N-007**: the shared core,
composition vocabulary and maintained-support contract share the same inventory. Then take
generation/compatibility, workflow applicability, and the interface/domain branches in dependency
order. These are suggested batches; their answers remain open.

---

## Register claimed

This chart closes no existing gap. Four are external prerequisites for downstream work, with their
existing owners retained. They do not prevent charting. The three loose entries under
`GAPS.md`'s **Still open, found on the way** count individually; the PE entry counts once and both
of its subitems are covered. The triage does not treat a historical release table as new entries.

| Register entry                                                                   | Verdict   | Relationship / existing owner                                                                           |
| -------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------------------------------------------- |
| 16/08/2026 loose item — coverage guide names undeclared pytest flags/xdist       | unrelated | Existing testing defect; profile verification must remeasure it if that runner is reused                |
| 16/08/2026 loose item — base dev stacks collide on `10.0.1.0/24`                 | unrelated | Existing environment defect; selecting network allocation is not this chart's deliverable               |
| 16/08/2026 loose item — `pnpm-update.sh` header names files it no longer updates | unrelated | Existing documentation repair                                                                           |
| 31/08/2026 — PE markup/prefix gate and CSS-check prerequisites                   | unrelated | Progressive-enhancement work; both subitems remain with their existing map                              |
| 31/08/2026 — htmx v4 migration waits on two triggers                             | unrelated | This chart does not choose an htmx upgrade                                                              |
| 01/09/2026 — unchanged Cargo lock hides new RUSTSEC advisories                   | unrelated | Existing Rust dependency-sweep defect; N-022 must account for it when promising maintained Rust support |
| 01/09/2026 — staging/production mail is discarded                                | unrelated | Existing Django mail implementation; N-020 does not promise to wire its absent relay                    |
| 01/09/2026 — story status has competing vocabularies                             | unrelated | [US007](../02-STORIES/US007.md) owns reconciliation; N-010 consumes the canonical outcome               |
| 01/09/2026 — shipped `CONTEXT.md` index-row instruction remains                  | blocks    | Registration prerequisite; [US010](../02-STORIES/US010.md) owns it; no index relocation in this map     |
| 02/09/2026 — citation gate applies shipped rules to unshipped trees              | blocks    | Documentation verification prerequisite for S-01/S-03; [US004](../02-STORIES/US004.md) owns it          |
| 09/09/2026 — duplicated Django security-settings block has drifted               | unrelated | Existing doctrine repair; extraction inventories it without claiming the repair                         |
| 09/09/2026 — Copier migration advisory disappears from preview                   | unrelated | Existing preview defect; N-002 records its effect before an update tracer relies on preview evidence    |
| 11/09/2026 — frontend installer supplies stray arguments to deletion             | unrelated | Existing bug explicitly routed to immediate bugfix; not delayed until this programme                    |
| 11/09/2026 — Bun tracers lack provisioned Bun                                    | unrelated | Only blocks that map's chosen Bun tracers; this map does not select Bun                                 |
| 16/09/2026 — MCP servers are declared twice                                      | unrelated | MAP-INSTRUCTION-DELIVERY owns its chosen mechanism; current parity continues meanwhile                  |
| 17/09/2026 — audit register lacks the believed headroom                          | blocks    | Extending audit registration in S-04 needs the split owned by [US002](../02-STORIES/US002.md)           |
| 17/09/2026 — three maps' prose disagrees with their tables                       | unrelated | Existing map maintenance; this chart checks its own counts and node coverage                            |
| 17/09/2026 — backlog register copies lack a drift gate                           | unrelated | Sprint-register ownership; no backlog maintenance is performed here                                     |
| 18/09/2026 — Codex instruction chains exceed budget                              | blocks    | S-01/S-09 cannot claim scalable instruction loading without MAP-INSTRUCTION-DELIVERY S-02/S-05 evidence |
| 09/10/2026 — Playwright pin differs from the currently rooted browser            | unrelated | Current browser prerequisite; relevant UI verification records unrun evidence until provisioned         |
| 09/10/2026 — human and agents share GitHub identity                              | unrelated | MAP-NATIVE-DESIGN-TIER owns its approval mechanism; new profiles do not fix account provisioning        |

Neither `GAPS.md` nor `DEFERRED.md` is edited by this chart. Any newly discovered build prerequisite
is routed to its owner before a slice is cut; an unrelated verdict does not declare a defect harmless.

---

## Resolved decisions

None. The confirmed destination is an input to this chart. Research results are evidence for later
resolution; no grilling, tracer or build node is settled during CHART.

| Node | Decision | Type | Settled | Became |
| ---- | -------- | ---- | ------- | ------ |
| —    | —        | —    | —       | —      |

---

## Slices

These are provisional buildable outcomes. Every story number remains unallocated. Flags use the
current 13-flag roster as first-pass gate routing; N-010 owns any change needed to express other
project types. A slice is cuttable only after every node it carries has resolved.

| Slice | Story | Title                                              | Nodes                                                                    | Acceptance                                                                                                                                                                                 | Flags                                                                                                                               |
| ----- | ----- | -------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| S-01  | —     | Shared engineering core and selected guidance      | N-001 ⛔ · N-003 ⛔ · N-005 ⛔ · N-021 ⛔ · N-024 ○                      | Shared rules have one owner; selected technical guidance loads without imposing Django; host-delivery ownership and instruction budgets remain measurable                                  | QA: instruction loading, reference integrity, manual; Security: selection conflicts and instruction provenance                      |
| S-02  | —     | Composable generation and compatible updates       | N-002 ⛔ · N-004 ⛔ · N-006 ⛔ · N-008 ⛔ · N-009 ⛔ · N-011 ○ · N-025 ○ | A standalone generated project carries only its selected runtime requirements; invalid combinations fail clearly; update probes preserve user-owned work under the agreed migration policy | QA: generation, update fixtures, manual; Security: generated commands and secret handling                                           |
| S-03  | —     | Applicable task skills and workflow gates          | N-010 ⛔ · N-020 ⛔ · N-026 ○                                            | Planning, building and review route through selected capabilities; absent database, web UI and API do not force invented artefacts or checks                                               | QA: workflow routing, applicable/absent capability fixtures; Security: permission/invariant obligations remain enforced             |
| S-04  | —     | Maintained support and verification evidence       | N-007 ⛔ · N-013 ⛔ · N-022 ⛔ · N-031 ○                                 | Maintained combinations have declared environments, owners, evidence and upgrade checks; unavailable or unsupported verification cannot report a clean result                              | QA: support matrix, CI fixtures, upgrade probes, manual; Security: dependency/advisory coverage and privileged checks               |
| S-05  | —     | Web, mobile and GUI profiles                       | N-012 ○ · N-017 ⛔ · N-019 ⛔ · N-027 ○                                  | Chosen interface profiles can generate and verify independently of Django; mobile reconciles existing decisions; accessibility, packaging and licence requirements are explicit            | User Flow: profile selection; QA: generation, builds, interface smoke checks, manual; Security: platform permissions                |
| S-06  | —     | Standalone language, CLI and TUI profiles          | N-018 ⛔ · N-028 ○                                                       | Chosen language/interface combinations build and verify without Python FFI or a web backend unless selected; terminal interaction and packaging have meaningful checks                     | QA: build, CLI/TUI behaviour, installation, manual; Security: process inputs, memory/FFI boundaries where applicable                |
| S-07  | —     | Linux distributions and machine-role configuration | N-014 ⛔ · N-015 ⛔ · N-023 ○ · N-029 ○                                  | Chosen distribution/role configurations have evaluation and recovery evidence appropriate to their target; server, PC, router and NAS obligations are distinguished                        | QA: evaluation/build, isolated role scenarios, recovery, manual; Security: privilege, network access and persistent-data protection |
| S-08  | —     | Cybersecurity project profiles                     | N-016 ⛔ · N-030 ○                                                       | Selected cybersecurity missions generate suitable project guidance, tools and verification; scope, assessment authorisation and sensitive evidence handling are explicit                   | QA: isolated scenarios, findings/evidence integrity, manual; Security: mission boundaries and sensitive evidence                    |
| S-09  | —     | Adding and maintaining profiles                    | N-032 ○                                                                  | A new profile can declare its dependencies, compatibility and evidence without copying the shared core; unsupported capabilities and retirement are visible                                | QA: extension fixtures, documentation loading, manual; Security: third-party profile trust                                          |

---

## Frontier

Dependencies are local links unless explicitly named as external. The four register prerequisites
above keep their existing owners; a build node never becomes a manual-unblocking task.

| Node                    | Decision / research / deliverable                                                                                                               | Type     | Blocked by                                                                                           | Blocking a story? |
| ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------- | ----------------- |
| <a id="n-001"></a>N-001 | Inventory framework assumptions across rules, skills, workflows, scripts, manifests, CI and optional surfaces                                   | research | none                                                                                                 | yes               |
| <a id="n-002"></a>N-002 | Measure generation/update compatibility, exclusions, seeds and migrations; identify the minimum standalone project contract                     | research | none                                                                                                 | yes               |
| <a id="n-003"></a>N-003 | Which rules belong in the shared engineering core, and which belong to a selected technical profile?                                            | grilling | [N-001](#n-001)                                                                                      | yes               |
| <a id="n-004"></a>N-004 | What composes: language, framework, interface, runtime capability, distribution, machine role and domain; what is their canonical vocabulary?   | grilling | [N-001](#n-001)                                                                                      | yes               |
| <a id="n-007"></a>N-007 | What evidence, owner and lifecycle distinguish a maintained profile from documented or locally supplied coverage?                               | grilling | [N-001](#n-001)                                                                                      | yes               |
| <a id="n-005"></a>N-005 | Where do core and profiles live, how are they distributed/versioned, and who owns their instructions?                                           | grilling | [N-003](#n-003), [N-004](#n-004); instruction-layer decisions remain with MAP-INSTRUCTION-DELIVERY   | yes               |
| <a id="n-006"></a>N-006 | How do selection, prerequisites, compatibility, precedence and conflicting rules resolve without silent fallback?                               | grilling | [N-003](#n-003), [N-004](#n-004)                                                                     | yes               |
| <a id="n-008"></a>N-008 | What migration/deprecation policy preserves existing answers, generated code and user artefacts when profiles or their composition change?      | grilling | [N-002](#n-002), [N-004](#n-004)                                                                     | yes               |
| <a id="n-009"></a>N-009 | Which tools belong to the generation host, development environment and project target; which environments can each require?                     | grilling | [N-003](#n-003), [N-004](#n-004)                                                                     | yes               |
| <a id="n-010"></a>N-010 | How do PM flags, task skills and build phases express applicable work for tools, configuration and security projects?                           | grilling | [N-003](#n-003), [N-006](#n-006)                                                                     | yes               |
| <a id="n-011"></a>N-011 | Probe generation and update of a standalone project without a web backend, database, Python runtime or Docker requirement                       | tracer   | [N-005](#n-005), [N-008](#n-008), [N-009](#n-009)                                                    | no                |
| <a id="n-012"></a>N-012 | Probe a second web framework against shared task routing, generation and verification to expose missing seams                                   | tracer   | [N-006](#n-006), [N-007](#n-007), [N-009](#n-009)                                                    | no                |
| <a id="n-014"></a>N-014 | How do Nix tooling, Linux distributions, machine roles and deploy-repository ownership compose for configuration projects?                      | grilling | [N-004](#n-004), [N-009](#n-009)                                                                     | yes               |
| <a id="n-015"></a>N-015 | What evaluation, isolation, rollout, rollback and access/data recovery evidence does each configuration target require?                         | grilling | [N-014](#n-014)                                                                                      | yes               |
| <a id="n-016"></a>N-016 | Which cybersecurity missions need distinct project contracts, assessment scope, privilege and evidence handling?                                | grilling | [N-003](#n-003), [N-004](#n-004)                                                                     | yes               |
| <a id="n-017"></a>N-017 | How does broad mobile extensibility coexist with the recorded Kotlin/Swift migration and its RN/KMP bounds?                                     | grilling | [N-004](#n-004), [N-007](#n-007); reconcile MAP-NATIVE-MOBILE-SURFACE's recorded scope               | yes               |
| <a id="n-018"></a>N-018 | Which correctness, build, packaging and interoperability requirements belong to C, C++, Go, Rust and other language profiles?                   | grilling | [N-004](#n-004), [N-007](#n-007), [N-009](#n-009)                                                    | yes               |
| <a id="n-019"></a>N-019 | Which interface requirements govern CLI, TUI, web, GUI and mobile, including accessibility, exit/error behaviour, threading and licensing?      | grilling | [N-004](#n-004), [N-007](#n-007)                                                                     | yes               |
| <a id="n-020"></a>N-020 | How are API, auth, persistence, notifications, logging and other runtime capabilities optional without weakening selected guarantees?           | grilling | [N-003](#n-003), [N-006](#n-006)                                                                     | yes               |
| <a id="n-021"></a>N-021 | How do selected profiles reach scoped instructions, skills, references and generated documentation through the existing host-delivery contract? | grilling | [N-003](#n-003), [N-005](#n-005), [N-006](#n-006); consume MAP-INSTRUCTION-DELIVERY                  | yes               |
| <a id="n-022"></a>N-022 | What declares check applicability, result scope, required environments and the supported combination matrix across CI and local commands?       | grilling | [N-006](#n-006), [N-007](#n-007), [N-009](#n-009), [N-010](#n-010)                                   | yes               |
| <a id="n-023"></a>N-023 | Probe one configuration target in isolation, including validation and recovery evidence, without changing a live machine                        | tracer   | [N-014](#n-014), [N-015](#n-015)                                                                     | no                |
| <a id="n-013"></a>N-013 | Which representative combinations become maintained first, and what proof admits subsequent ones?                                               | grilling | [N-007](#n-007), [N-011](#n-011), [N-012](#n-012)                                                    | yes               |
| <a id="n-024"></a>N-024 | Specify extraction of shared standards and selected guidance into S-01                                                                          | build    | [N-003](#n-003), [N-005](#n-005), [N-021](#n-021)                                                    | no                |
| <a id="n-025"></a>N-025 | Specify profile-aware generation, manifests, post-tasks and migrations into S-02                                                                | build    | [N-004](#n-004), [N-005](#n-005), [N-006](#n-006), [N-008](#n-008), [N-009](#n-009), [N-011](#n-011) | no                |
| <a id="n-026"></a>N-026 | Specify task-skill and PM applicability changes into S-03                                                                                       | build    | [N-010](#n-010), [N-018](#n-018), [N-019](#n-019), [N-020](#n-020), [N-021](#n-021)                  | no                |
| <a id="n-027"></a>N-027 | Specify chosen web/mobile/GUI generation and verification into S-05                                                                             | build    | [N-012](#n-012), [N-013](#n-013), [N-017](#n-017), [N-019](#n-019), [N-020](#n-020)                  | no                |
| <a id="n-028"></a>N-028 | Specify chosen standalone language/CLI/TUI generation and verification into S-06                                                                | build    | [N-013](#n-013), [N-018](#n-018), [N-019](#n-019)                                                    | no                |
| <a id="n-029"></a>N-029 | Specify chosen Linux distribution/role generation and verification into S-07                                                                    | build    | [N-013](#n-013), [N-014](#n-014), [N-015](#n-015), [N-023](#n-023)                                   | no                |
| <a id="n-030"></a>N-030 | Specify chosen cybersecurity project guidance, generation and verification into S-08                                                            | build    | [N-013](#n-013), [N-016](#n-016), [N-018](#n-018)                                                    | no                |
| <a id="n-031"></a>N-031 | Specify maintained-combination CI, local gates, dependency sweeps and upgrade probes into S-04                                                  | build    | [N-007](#n-007), [N-008](#n-008), [N-013](#n-013), [N-015](#n-015), [N-016](#n-016), [N-022](#n-022) | no                |
| <a id="n-032"></a>N-032 | Specify third-party/local profile onboarding, evidence, compatibility and retirement into S-09                                                  | build    | [N-005](#n-005), [N-006](#n-006), [N-007](#n-007), [N-022](#n-022)                                   | no                |

**Measured structure:** 32 open nodes = 2 research + 3 tracers + 18 grilling + 9 build.
20 block stories; every build node is non-blocking and every node belongs to a slice.
Slice order is an index, not a promised implementation sequence; cross-slice prerequisites apply.

**Research returned:** [FRAMEWORK-NEUTRAL-FOUNDATION-INVENTORY.md](../../../research/FRAMEWORK-NEUTRAL-FOUNDATION-INVENTORY.md)
supplies dated, per-claim repository evidence for N-001/N-002. Both nodes remain open until the
next RESOLVE session reviews the inventory against the shared-core and compatibility contracts.

---

## Fog of war

- The first maintained frameworks, mobile approaches, distributions, CPU architectures and language
  versions need a support contract and tracer evidence before a catalogue can be promised.
- Router/NAS scope may include specialised operating systems, firmware, appliance constraints,
  remote recovery and GUIs; examples do not yet define the target hardware or licensing.
- Multi-repository and mixed-language projects may expose composition or release needs beyond the
  first standalone and second-framework probes. The trace results determine additional nodes.
- Existing maps may constrain individual maintained choices. Broader extensibility does not decide
  whether any earlier project-specific choice should be reopened.
- External technical comparisons and normative security/accessibility claims require current primary
  sources when a RESOLVE batch selects its concrete targets; this chart does not assert them.

---

## Out of scope

| Ruled out                                                                                    | Why                                                                                                   |
| -------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| A tested starter for every framework, distro and mobile option immediately                   | Sam selected extensible coverage; maintained support requires bounded evidence                        |
| Switching all projects away from Django                                                      | Django remains a candidate maintained profile; migration policy is N-008                              |
| A universal runtime abstraction that makes existing application code framework-swappable     | Generation composition and runtime portability are different contracts                                |
| Live provisioning, firewall changes, installations, disk operations or deployment            | CHART records decisions and research; configuration implementation/rehearsal belongs to later stories |
| Implementing profiles, changing existing skills, writing stories or allocating their numbers | Build nodes are specified on slices and executed through the existing PM chain                        |
| Replacing the host-instruction, MCP, mobile or forge migrations from sibling maps            | Their ownership and decisions are reconciled explicitly, not duplicated                               |

---

## Session log

| Date       | Session | Outcome                                                                                                       | Frontier redrawn       |
| ---------- | ------- | ------------------------------------------------------------------------------------------------------------- | ---------------------- |
| 09/10/2026 | CHART   | Scope confirmed; register triaged; 32 nodes and 9 provisional slices charted; N-001/N-002 research dispatched | Initial frontier drawn |

---

## Gate to stories

- [x] Destination and bounds reflect the confirmed guidance/generation and extensible-support scope
- [x] All 21 open register entries triaged; standing limitations exempt; neither register edited
- [x] Every knowable decision is a typed node or in fog of war
- [x] Every node has dependencies and a slice; at least one node is unblocked
- [x] Every slice carries acceptance and a first-pass flag manifest; no story number reserved
- [ ] All blocking nodes resolved and graduated to their proper homes
- [ ] External prerequisites measured and satisfied for each slice being cut
- [ ] Index registration current — intentionally withheld under the existing US010 relocation ruling

CHART ends here. RESOLVE reviews the dispatched evidence and settles related batches; story creation
starts only when its prerequisites are satisfied. No build, tracer or grilling node was performed.
