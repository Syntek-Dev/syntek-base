@./CONTEXT.md

# CLAUDE.md — how-to/src/SERVER-ARCHITECTURE/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/src/CONTEXT.md` →
this folder's `CONTEXT.md` (tree + glossary, imported above) → this file →
`OVERVIEW.md` for the pipeline before touching any other file here.

## Purpose (one line)

The deploy-facing server/edge contract — the consolidated edge-requirement catalogue
and the assigned-compute-plus-buffer allocation that `<%DEPLOY_REPO%>` implements,
maintained by the `scale-planning` skill via `/scale-planning`.

## How to work here

- **Routing:** substantive updates → the `scale-planning` skill (`/scale-planning`) —
  this directory is one of its two living snapshots (the other is the sibling
  `how-to/src/SCALE-ARCHITECTURE/`). Edge-security rows → `security` skill input;
  observability rows → `logging`; compute rows → `cicd`.
  Every substantial change opens with a grilling pass (`.claude/CLAUDE.md` Section 10).
- **Model:** Fable for reshaping the contract or the buffer policy (it is a sizing /
  architecture judgement); Opus for mechanical touches — status flips on a
  requirement row, citation fixes, re-verifying a `file:line` reference.
- **Concrete steps:** re-verify each claim against the LIVE codebase (the cited
  `file:line`) and the live deploy repo before editing → update the requirement's
  _Current status_ when either side moves (a `GAPS.md` gap closes, a NixOS module
  lands) → keep `COMPUTE-ALLOCATION.md` consistent with the sibling
  `SCALE-ARCHITECTURE/` envelope and the scaling ADR's gates → update this folder's
  `CONTEXT.md` tree if a file is added or removed.
- **Definition of done:** every requirement row carries source (`file:line`), current
  status, and the deploy-repo obligation; citations verified against the live tree;
  no contradiction with `GAPS.md`, the ADRs, or the deploy repo's actual modules;
  British English; DD/MM/YYYY dates; docs hard-gate satisfied before commit.

## Guardrails

- **Specify, never implement.** No Nix, no nginx.conf bodies, no Cloudflare rule
  exports here — state _what must hold_ and cite where the deploy repo implements it
  (the `HEALTH-CONTRACT.md` precedent). Working config belongs in
  `<%DEPLOY_REPO%>`.
- **A contract names the product; the heading rule does not bind here.** `code/docs/` leads with
  the interface, this directory does not — _"provision a metrics scraper"_ cannot be implemented
  (`code/docs/architecture/PROVIDER-NEUTRALITY.md`, exception 1). Name **the project's** product
  though, not the template's: use the token where a **prose-safe** one exists (`OBJECT_STORE`,
  `ERROR_TRACKING`, `LOG_AGGREGATOR`, `ANALYTICS_PROVIDER`). `OBSERVABILITY_STACK`,
  `HOSTING_PROVIDER` and `TRACING_BACKEND` resolve to a phrase and are **cell-only** — that is why
  Prometheus stays literal in Section 8, and Gatus stays literal because it has no token at all. Neither
  is an oversight; do not "fix" them.
- **Anti-forecast is a hard rule.** The Postgres horizontal-scaling ADR: scale on
  observable phase-gates — "do not pre-emptively add infrastructure". Compute here is
  current-tier envelope + buffer only. Never invent target-user figures: no ratified
  target exists in this repo; targets stay `TBD — set via /scale-planning grilling`
  until <%DEVELOPER_NAME%> settles them.
- **Do not duplicate the sources.** The scaling ADR's mechanics stay in that ADR /
  `code/docs/architecture/CORE-AND-SCALING.md`; provisioning steps stay in the
  deploy repo (`<%DEPLOY_REPO%>/how-to/`); health endpoint shapes
  stay in `HEALTH-CONTRACT.md`; the sizing envelope stays in
  `SCALE-ARCHITECTURE/`. This directory consolidates and references — a duplicated
  table is a future contradiction.
- **Buffer policy is locked** (owned and expressed here): assigned compute ≈
  current-tier peak × (1 + headroom), sized so normal peak stays under the scaling
  ADR's 70% CPU/IO gate triggers; a gate-trip means move up a tier. Do not restate it
  differently in any file.
- These are `**/src/*.md` operator guides — exempt from the 300-line instructional
  limit — but `CONTEXT.md` and this file stay within it regardless.
- No secrets, tokens, or real hostname credentials — values by env-var/secret _name_
  only (agenix secret names are fine; their contents never).

## Output & naming

- **Hand-written:** all five documents plus this file; nothing here is generated.
- Documentation files `SCREAMING-SNAKE-CASE.md`; requirement anchors keep their
  `GAPS.md` gap IDs (e.g. `GAP-<FEATURE>-EDGE-CSP`) so cross-references
  survive the gap's closure and tidy-pass removal.
- Dates DD/MM/YYYY; £ GBP; British English (en_GB).
