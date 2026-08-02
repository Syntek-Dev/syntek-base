---
type: guide
agent: code-reviewer
skills: [global-workflow]
model: opus
---

# Code Review Graph — Structural Playbooks

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — graph-first navigation for explore, debug, review, and refactor tasks

<%PROJECT_NAME%> runs a persistent **code-review-graph** MCP server. It parses the codebase with
Tree-sitter into a structural graph (nodes, edges, execution flows, communities) and exposes ~30
MCP tools that answer **callers-of / dependents-of / tests-for / blast-radius** questions directly.

**Graph-first is a project rule** (`.claude/CLAUDE.md` §3): reach for the graph tools **before**
Grep/Glob/Read for any structural question — it is faster, token-cheaper, and returns relationship
context that file scanning cannot. Fall back to Grep/Glob/Read only when the graph does not cover
what you need.

## Tandem with the layer system

The graph and the layered `CONTEXT.md`/`CLAUDE.md` docs are **two synchronised views of the same
codebase** — the graph is machine-derived structure (who calls what, which flows a change
touches); the layer docs are human-curated orientation (a folder's purpose, tree, and local
conventions). Neither is authoritative alone, and they are kept in lockstep:

- **Explore with both.** Open any unfamiliar area by reading its `CONTEXT.md` for orientation,
  then run the **explore playbook** for structure — the tree tells you _what is here and why_,
  the graph tells you _what connects to what_.
- **Update both together.** The `PostToolUse` hook already re-indexes the graph incrementally on
  every edit (`--skip-flows`), so file-level nodes and edges track your changes automatically.
  When you revise the layer docs at the documentation hard gate, run a flows-inclusive
  **`code-review-graph update`** (or the `build_or_update_graph_tool` MCP tool) so flows and
  communities reconcile too — the docs and the graph never drift apart.

## The four task playbooks

The `code-review-graph install` step generates four quick-reference cards under `.claude/skills/`.
They are **auto-generated and regenerate on every `install` run** — treat them like the generated
audit/coverage reports under `code/src/scripts/**/reports/`: **referenced by path, never
hand-edited**. This guide
is the canonical, hand-maintained companion; each agent and workflow below points here and at the
matching card.

| Task                  | Playbook card                        | Wired into                                  |
| --------------------- | ------------------------------------ | ------------------------------------------- |
| Explore / understand  | `.claude/skills/explore-codebase.md` | `planner`, feature recon · workflow `01`    |
| Debug / trace a fault | `.claude/skills/debug-issue.md`      | `debugger`, `bugfix` · workflows `09`, `10` |
| Review a change       | `.claude/skills/review-changes.md`   | `code-reviewer`, `review` · workflow `07`   |
| Refactor safely       | `.claude/skills/refactor-safely.md`  | `refactor` · workflow `11`                  |

## Shared discipline (every playbook)

- **Open with `get_minimal_context(task="<the task>")`** before any other graph tool — it scopes
  the graph to the work and seeds the ≤5-call budget below.
- Use **`detail_level="minimal"`** on every call; escalate to `standard` only when minimal is
  demonstrably insufficient.
- **Target ≤ 5 tool calls / ≤ 800 output tokens** for a single review, debug, or refactor pass.
- The graph indexes source (`python`, `typescript`, `tsx`, `javascript`, `bash`) — for the
  instructional `.md`/config layer (`.claude/**`, `**/docs/`), read the files directly.

## Explore playbook — understand structure

Card: `.claude/skills/explore-codebase.md`. Use when onboarding to an area or scoping a feature.

1. `get_minimal_context(task=…)` — scope the graph to the area.
2. `list_graph_stats` → `get_architecture_overview` — overall metrics and community structure.
3. `list_communities` → `get_community` — drill into a major module.
4. `semantic_search_nodes` — locate a specific function or class by name/keyword.
5. `query_graph` (`callers_of`, `callees_of`, `imports_of`) — trace relationships.
6. `list_flows` → `get_flow` — follow an end-to-end execution path.

Start broad (stats, architecture), then narrow. `find_large_functions` surfaces complexity.

## Debug playbook — trace a fault

Card: `.claude/skills/debug-issue.md`. The `debugger` agent's structural pass (workflow `10`
Step 2); `09-debugging-with-logs` pairs it with observability signals.

1. `get_minimal_context(task=…)`.
2. `semantic_search_nodes` — find code related to the symptom.
3. `query_graph` `callers_of` / `callees_of` — trace the call chain both directions.
4. `get_flow` — the full execution path through the suspected area.
5. `detect_changes` — recent changes are the most common source of new faults.
6. `get_impact_radius` on the suspected file — what else the fault reaches.

This informs the root cause; it does **not** license a fix. The failing regression test still
comes first (workflow `10`).

## Review playbook — assess a change

Card: `.claude/skills/review-changes.md`. The `review`/`code-reviewer` structural pass
(workflow `07` Steps 1–3), run alongside the two review axes (Standards, Spec).

1. `detect_changes` — risk-scored analysis of what changed.
2. `get_affected_flows` — which execution paths the change touches.
3. `query_graph` `tests_for` — coverage on each high-risk function.
4. `get_impact_radius` — the blast radius of the change.
5. For untested changes, suggest specific test cases.

Group findings by risk (high / medium / low) with a merge recommendation; feed them into the
`code-reviewer` output format, never replacing the Standards/Spec verdicts.

## Refactor playbook — restructure safely

Card: `.claude/skills/refactor-safely.md`. The `refactor` agent's impact pass (workflow `11`
Step 2), run before moving any code.

1. `refactor_tool` `mode="suggest"` — community-driven refactoring candidates.
2. `refactor_tool` `mode="dead_code"` — unreferenced code safe to remove.
3. `refactor_tool` `mode="rename"` — preview every affected location; `apply_refactor_tool` with
   the returned `refactor_id` to apply.
4. `get_impact_radius` + `get_affected_flows` before any major move — no critical path is broken.
5. `find_large_functions` — decomposition targets.
6. `detect_changes` after — verify the refactor's structural footprint.

Always preview before applying; behaviour must stay identical (workflow `11` golden rule).

## Maintenance — build, update, hooks

- The graph **auto-updates** via the `PostToolUse` hook (`code-review-graph update`) and reports
  stats on `SessionStart` (`.claude/settings.json`).
- Prefer **`code-review-graph update`** (incremental) for routine syncs. Reserve
  **`code-review-graph build`** (full rebuild) for a from-scratch index — and **stop other
  `code-review-graph serve` processes first**: a concurrent writer holds the SQLite lock and a
  full build fails with `database is locked`.
- **Run `code-review-graph update` alongside every documentation update** (the "update both
  together" half of the tandem discipline). It is the PATH-installed CLI used here and by the
  hook, and is what `uvx code-review-graph update` resolves to.
- **Git pre-commit stays lefthook-managed.** `code-review-graph install` appends its own check to
  `.git/hooks/pre-commit` after lefthook's, which silently makes the hook non-blocking; the graph's
  advisory `detect-changes` lives in `lefthook.yml` instead. After any `code-review-graph install`,
  run `lefthook install` to reclaim the hook so lint and format stay blocking.
- Tool config lives in `.mcp.json`; the graph store is `.code-review-graph/` (gitignored).
