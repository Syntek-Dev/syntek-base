# AI host configuration conventions

**Read**: 09/10/2026 · **Hosts**: Claude Code 2.1.296 · Codex 0.160.1 · Antigravity (`agy` 1.3.0;
docs at 2.22.0) · OpenCode v2.0.18 · **Backends**: llama.cpp (v0.6.0 and pre-release b11530) ·
vLLM 0.31.0

## Question

How do Claude Code, OpenAI Codex, Google Antigravity and OpenCode discover project instructions,
skills, MCP servers, hooks and settings today — and what can a canonical `.ai/` directory reach in
each of them, with llama.cpp and vLLM as inference backends?

## Verdict

**No host discovers `.ai/` by name, so every route into it is an adapter.** Claude Code reaches it
through `@import` lines in `CLAUDE.md`, and a nested `CLAUDE.md` that loads lazily expands its
imports — measured below. Codex, OpenCode v2 and Antigravity all read `AGENTS.md` at every
directory level, but none of them expands a Claude-style import, so their adapter has to carry the
text itself. `AGENTS.md` is the one filename all four read, yet Claude Code reads it only where no
`CLAUDE.md` exists, under a setting a repository cannot commit.

Skills are the closest thing to portable: all four accept the Agent Skills folder format, and three
of them read `.agents/skills/`. MCP, hooks and settings stay per host — four MCP schemas with three
spellings of an environment reference and one with none, four hook models of which one is code
only, and settings that are JSON, TOML, or user-level only. Instruction budgets differ by an order
of magnitude and are silent when exceeded: Codex truncates at a 32 KiB chain, Antigravity at 24,000
bytes per rule file.

Local backends read no project files at all. Whether an agent can use one depends on the API it
speaks: Codex needs the Responses API, and Claude Code needs Anthropic's Messages API — and
Anthropic does not support non-Claude models behind it.

## Method

Five readers — one per host and one for the two backends — read each source with the scrapling
`get` tool and recorded a URL and a passage for every claim. Five further readers re-opened every
cited page and tried to refute every claim. Of 221 claims, 208 were confirmed, 13 corrected and none
refuted, and the refuters added 84 facts the first pass had missed; the corrections are applied
below. One behaviour was measured rather than read: Claude Code's handling of nested imports.

**Every statement here is re-authored.** The vendor documentation grants no licence, so nothing is
quoted (`research/CLAUDE.md` → _Never quote a source that grants no licence_). The facts are cited
to the page they were read from.

---

## 1. Claude Code

- Four instruction scopes load broadest first: managed policy, user `~/.claude/CLAUDE.md`, project
  `./CLAUDE.md` or `./.claude/CLAUDE.md`, and `./CLAUDE.local.md`. Ancestors of the working
  directory load at launch; a subdirectory's file loads when a file there is read, written or
  edited. All are concatenated — none overrides another. [cc-memory]
- The guidance is under 200 lines per file; files over 4 MiB are skipped. [cc-memory]
- `AGENTS.md` is read natively from v2.1.277, but by default only where no `CLAUDE.md`,
  `.claude/CLAUDE.md` or `CLAUDE.local.md` exists in the working directory or above. A "Project
  instructions" setting chooses `CLAUDE.md`, `AGENTS.md` or both, and is honoured only from user,
  `--settings` or managed configuration — a repository cannot commit it. Nothing under `.agents/` is
  read as instructions. [cc-memory]
- No setting reads an arbitrary instruction filename or a path under `.ai/`. [cc-memory]
- `@path` imports resolve against the importing file, nest up to four hops, are ignored inside code
  spans and fences, and need one-time approval when they resolve outside the working directory.
  [cc-memory]
- `.claude/rules/*.md` with a `paths` list load lazily when a matching file is touched; `paths` is
  the only frontmatter field; symlinked rule files are followed; nested `.claude/rules/` load on
  demand. [cc-memory]
- Block-level HTML comments are stripped before a `CLAUDE.md` is injected, and after `/compact` only
  the project-root file is re-injected — nested files and scoped rules reload on demand.
  [cc-memory]
- Skills come from managed, personal and project `.claude/skills/` (the working directory and each
  parent up to the repository root), lazily from nested `<dir>/.claude/skills/`, from `--add-dir`
  and from plugins. A skill folder may be a symlink and is deduplicated by target. `.agents/skills/`
  is not a Claude Code location. [cc-skills]
- `SKILL.md` accepts 20 frontmatter fields and ignores unknown ones silently; the Agent Skills
  specification defines six (`name`, `description`, `license`, `compatibility`, `metadata`,
  `allowed-tools`). The guidance keeps `SKILL.md` under 500 lines. [cc-skills] [agentskills]
- Settings are strict JSON, with precedence managed → `--settings` → `.claude/settings.local.json`
  → `.claude/settings.json` → user. `settings.local.json` joins git's global excludes only when
  Claude Code itself writes the file; one created by hand must be ignored by the repository.
  Project settings are read from the primary working directory only. [cc-settings] [cc-large]
- `autoCompactEnabled`, `enabledMcpjsonServers`, `enableAllProjectMcpServers`,
  `claudeMdExcludes`, `effortLevel` and `outputStyle` are all documented keys. [cc-settings-ref]
- There are 33 hook events and five handler types (`command`, `http`, `mcp_tool`, `prompt`,
  `agent`); exit code 2 blocks. Hooks are declared only in settings files, plugins, and skill or
  subagent frontmatter — there is no standalone hooks file, in YAML or otherwise. Injected hook text
  is capped at 10,000 characters per string, and interactive sessions hold settings hooks back until
  the workspace is trusted. [cc-hooks]
- Project MCP is `.mcp.json` at the repository root only, with `stdio`, `http`, `sse` and `ws`
  types; `${VAR}` and `${VAR:-default}` expand in `command`, `args`, `env`, `url` and `headers`.
  A file at any other path loads only through `--mcp-config` on each launch. [cc-mcp]
- Behind `ANTHROPIC_BASE_URL`, Claude Code needs an Anthropic Messages endpoint (`/v1/messages`,
  optionally `count_tokens`) streamed through to the end. Anthropic does not support routing it to
  non-Claude models, and an unrecognised model ID is treated as a current Claude model, so it may be
  sent fields a non-Anthropic backend rejects. [cc-gateway] [cc-gateway-protocol]

### Measured: nested imports load lazily and expand

Claude Code 2.1.296, 09/10/2026, in a scratch git repository with an `InstructionsLoaded` hook
logging every load:

| Layout                                                                              | Logged                                                                                 |
| ----------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `.claude/CLAUDE.md` importing `@../.ai/INSTRUCTIONS.md` and `@../.ai/CONTEXT.md`    | Both loaded at session start as `include`                                              |
| `sub/CLAUDE.md` importing `@.ai/INSTRUCTIONS.md` and `@.ai/CONTEXT.md`              | Adapter loaded by `nested_traversal` when `sub/data.txt` was read; both imports loaded |
| The same adapter two levels down                                                    | Same result                                                                            |
| `sub2/CLAUDE.md` as a symlink to `.ai/INSTRUCTIONS.md`, which imports `@CONTEXT.md` | The import resolved against the **target's** directory, not the link's                 |

**To re-measure:** build the same layout, register an `InstructionsLoaded` command hook in
`.claude/settings.json` that appends its stdin to a log, and run `claude -p` with
`--allowedTools Read`, telling it to read the data files and nothing else.

---

## 2. Codex

- Global instructions come from `CODEX_HOME` (default `~/.codex`), with `AGENTS.override.md` before
  `AGENTS.md`. [cdx-agents]
- The project chain walks from the root (the nearest `.git` by default) down to the working
  directory, one file per directory: `AGENTS.override.md`, then `AGENTS.md`, then each
  `project_doc_fallback_filenames` entry; the nearest file comes last. [cdx-agents] [cdx-cfg-adv]
- `project_doc_max_bytes` defaults to 32 KiB across the whole chain. In the 0.160.1 source, the file
  that crosses the limit is truncated, and the only signal is a log warning. [cdx-agents]
  [cdx-agents-src]
- The loader never reads files below the working directory; the base prompt asks the model to look
  for `AGENTS.md` itself when it works deeper. [cdx-agents-src] [cdx-prompt]
- A fallback entry containing `/` is discarded, so `.ai/INSTRUCTIONS.md` cannot be a fallback; a bare
  name matches only `<dir>/<name>`. An `AGENTS.md` may be a symlink. Neither fact is documented;
  both are in the source. [cdx-agents-src]
- `AGENTS.md` has no import or include syntax. [cdx-agents]
- A project `.codex/config.toml` loads only for a trusted project (`projects.<path>.trust_level`),
  and an untrusted project skips its `AGENTS.md` too. Project configuration cannot set model
  providers, `notify`, profiles or telemetry — those keys are ignored with a warning.
  [cdx-cfg-basic] [cdx-cfg-adv] [cdx-agents-src]
- MCP servers sit under `mcp_servers.<id>`: `command`, `args`, `env`, `env_vars` and `cwd` for
  stdio; `url`, `bearer_token_env_var` and `http_headers` for HTTP; and `startup_timeout_sec`,
  `tool_timeout_sec`, `enabled`, `enabled_tools` and `disabled_tools` for both. [cdx-mcp]
- `wire_api` accepts only `responses`; Chat Completions support has been removed, from February
  2026 per the maintainers. `--oss` supports only Ollama and LM Studio, and `model_context_window`
  declares a local model's window. [cdx-cfg-ref] [cdx-models] [cdx-7782]
- Repository skills are read from `.agents/skills/` in every directory from the working directory up
  to the repository root; symlinked skill folders are followed; `name` and `description` are
  required and `agents/openai.yaml` is optional metadata. The initial skill list is capped at 2% of
  the context window. [cdx-skills]
- Lifecycle hooks exist, in `hooks.json` or an inline `[hooks]` table per configuration layer.
  Project hooks need a trusted project and a per-hook review recorded against the hook's hash.
  A `SessionStart` hook's output is injected, at about 2,500 tokens by default. [cdx-hooks]
- `/import` converts a Claude Code setup — instructions, settings, MCP, hooks, commands and
  subagents. Its coverage in the CLI is not documented. [cdx-import]

---

## 3. Antigravity

- When a file is read or edited, Antigravity loads `AGENTS.md`, `GEMINI.md`, `.agents/AGENTS.md`,
  `.agents/GEMINI.md` and `.agents/rules/*.md` from every directory between that file and the
  workspace root. Scopes combine, and the more specific wins a conflict. `.agent/rules/` is the
  legacy name. [ag-rules]
- `AGENTS.md` and `GEMINI.md` take no frontmatter and are always on for their scope. A file in
  `.agents/rules/` must declare a `trigger` (`always_on`, `model_decision`, `glob` or `manual`); one
  with a missing or invalid trigger is dropped without an error. [ag-rules]
- `@[label](path)` inlines a file relative to the rule's own directory. The rules page says a bare
  `@filename` does not inline; changelog 2.11.0 says `@path` does. The two disagree, and runtime
  behaviour is unmeasured. [ag-rules] [ag-changelog]
- Each rule file is truncated at 24,000 bytes after includes are expanded, and always-on rules share
  a 20,000-token budget. [ag-rules]
- Workflows are deprecated and stop working on 19/10/2026; `/migrate-workflows` converts them into
  skills. [ag-workflows] [ag-wf-migration]
- Workspace skills default to `.agents/skills/` (`.agent/skills/` is still read) and follow the Agent
  Skills format, with only `description` required. How symlinks are handled is not documented.
  [ag-skills]
- MCP configuration is `mcp_config.json`, both global and per workspace (`.agents/mcp_config.json`):
  `mcpServers` entries with `command` or `serverUrl`, plus `args`, `env`, `headers`, `disabled` and
  `disabledTools`. No environment-variable substitution is documented. [ag-mcp]
- Hooks live in `.agents/hooks.json`, keyed by hook name and then by event; there are five events
  and `command` is the only handler. [ag-hooks]
- CLI permissions and settings are user-level (`~/.gemini/antigravity-cli/settings.json`).
  Per-repository customisation moved to `/.gemini/config.json` in 2.17.0, with an undocumented
  schema. [ag-permissions] [ag-settings] [ag-changelog]
- Plugins go in `.agents/plugins/`, each with a `plugin.json`. [ag-plugins]
- Only the Python SDK documents a local OpenAI-compatible server; the CLI's endpoint override
  accepts a Gemini-compatible API only. [ag-sdk-local] [ag-cli-install]

---

## 4. OpenCode v2

- Project configuration is `opencode.json(c)` or `.opencode/opencode.json(c)`, merged from every
  ancestor down to the working directory. The `$schema` is `https://opencode.ai/config.json`, which
  is still V1-shaped and rejects unknown keys. [oc2-config] [oc-schema]
- Only `AGENTS.md` is read — the global file, then each ancestor, then nested files lazily when a
  file is read or a directory listed. V2 has no `CLAUDE.md` fallback, and the `instructions` array
  is accepted but resolves nothing. [oc2-instructions]
- Skills are read from `.opencode/skills`, `.claude/skills` and `.agents/skills` at every level up
  to the root. Loose `*.md` files at a skills root register as skills, symlinks are followed (in the
  source), and a duplicate ID resolves to the later source. [oc2-skills] [oc-skills-src]
- Permissions are an ordered array of `{action, resource, effect}`. The base policy allows
  everything except external directories and `.env` reads, which ask. [oc2-permissions]
- MCP servers sit under `mcp.servers.<name>` in V2 (`type: local`, a `command` array, and
  `environment` using `{env:NAME}`); V1's flat `mcp.<name>` still works. [oc2-mcp] [oc2-migrate]
- Providers can be declared per project. vLLM, Ollama and LM Studio are discovered automatically,
  and any OpenAI-compatible server works through a custom provider with a `baseURL`, a key by
  `{env:...}` and declared context limits. The V1 docs carry the only llama.cpp example.
  [oc2-providers] [oc1-providers]
- Hooks exist only as plugin code. [oc2-plugins]

---

## 5. llama.cpp and vLLM

- llama-server serves `/v1/chat/completions`, `/v1/completions`, `/v1/models`, `/v1/responses` and
  an Anthropic-style `/v1/messages`. It binds to loopback by default, takes `--api-key` or
  `LLAMA_API_KEY`, reports the model ID set by `--alias`, and needs `--jinja` (now the default) for
  tool calls. [lc-server]
- Its default port moved from 8080 to 9931 on 09/10/2026, from pre-release b11530 onwards; the
  v0.6.0 release and the official Docker image still use 8080. [lc-server] [lc-b11530] [lc-docker]
- Aggressive KV-cache quantisation degrades tool calling. [lc-fc]
- vLLM serves Completions, Chat Completions, Responses and Anthropic Messages on port 8000, with the
  model ID set by `--served-model-name`. `--api-key` protects only some path prefixes, and automatic
  tool choice needs `--enable-auto-tool-choice` with a `--tool-call-parser`. [vl-serving]
  [vl-serve-cli] [vl-security]
- With `--host` unset, the source binds every interface, contrary to the quickstart's "localhost".
  [vl-launcher] [vl-quickstart]
- vLLM documents integrations for Claude Code (`ANTHROPIC_BASE_URL`) and for Codex (a user-level
  `model_providers` entry with `wire_api = "responses"`). [vl-cc] [vl-codex]
- Neither backend reads project instruction files; each takes configuration only from explicit
  paths and flags. [lc-server] [vl-serving]

---

## What only a run can settle

- Whether OpenCode v2 and Antigravity follow a symlinked `AGENTS.md`.
- Whether Antigravity hands the inherited environment to a stdio MCP server
  (`MAP-INSTRUCTION-DELIVERY` N-024).
- How OpenCode v2 presents one skill reached through two compatibility roots (N-025).
- Whether llama-server's `/v1/responses` satisfies Codex end to end.
- Whether vLLM's `/v1/messages` streams the way Claude Code requires.

---

## Sources

- **Claude Code** — [memory][cc-memory] · [skills][cc-skills] · [settings][cc-settings] ·
  [settings reference][cc-settings-ref] · [large codebases][cc-large] · [hooks][cc-hooks] ·
  [MCP][cc-mcp] · [LLM gateway][cc-gateway] · [gateway protocol][cc-gateway-protocol]
- **Agent Skills** — [specification][agentskills]
- **Codex** — [AGENTS.md][cdx-agents] · [basic config][cdx-cfg-basic] ·
  [advanced config][cdx-cfg-adv] · [config reference][cdx-cfg-ref] · [MCP][cdx-mcp] ·
  [models][cdx-models] · [skills][cdx-skills] · [hooks][cdx-hooks] ·
  [developer commands][cdx-import] · [`agents_md.rs` at 0.160.1][cdx-agents-src] ·
  [base prompt at 0.160.1][cdx-prompt] · [Chat Completions removal][cdx-7782]
- **Antigravity** — [rules][ag-rules] · [skills][ag-skills] · [MCP][ag-mcp] · [hooks][ag-hooks] ·
  [workflows][ag-workflows] · [workflows to skills][ag-wf-migration] ·
  [permissions][ag-permissions] · [settings][ag-settings] · [plugins][ag-plugins] ·
  [SDK local models][ag-sdk-local] · [CLI install][ag-cli-install] · [changelog][ag-changelog]
- **OpenCode** — [V2 config][oc2-config] · [config schema][oc-schema] ·
  [V2 instructions][oc2-instructions] · [V2 skills][oc2-skills] ·
  [V2 permissions][oc2-permissions] · [V2 MCP servers][oc2-mcp] · [V2 providers][oc2-providers] ·
  [V2 plugins][oc2-plugins] · [migrating from V1][oc2-migrate] · [V1 providers][oc1-providers] ·
  [skill discovery at v2.0.18][oc-skills-src]
- **llama.cpp** — [server README][lc-server] · [server README at b11530][lc-b11530] ·
  [CPU Dockerfile][lc-docker] · [function calling][lc-fc]
- **vLLM** — [quickstart][vl-quickstart] · [online serving][vl-serving] · [`vllm serve`][vl-serve-cli] ·
  [security][vl-security] · [launcher source][vl-launcher] · [Claude Code integration][vl-cc] ·
  [Codex integration][vl-codex]

## Feeds

`project-management/src/01-FEATURE-MAPS/MAP-INSTRUCTION-DELIVERY.md` — nodes N-001, N-006 and
N-011, resolved 09/10/2026, and slices S-01, S-02, S-04, S-10, S-12 and S-13, whose stories cite
this note from their ADRs and story plans. **Re-measure before leaning on it:** every host here
shipped a behaviour change in the month before it was written.

[cc-memory]: https://code.claude.com/docs/en/memory.md
[cc-skills]: https://code.claude.com/docs/en/skills.md
[cc-settings]: https://code.claude.com/docs/en/settings.md
[cc-settings-ref]: https://code.claude.com/docs/en/settings-reference.md
[cc-large]: https://code.claude.com/docs/en/large-codebases.md
[cc-hooks]: https://code.claude.com/docs/en/hooks.md
[cc-mcp]: https://code.claude.com/docs/en/mcp.md
[cc-gateway]: https://code.claude.com/docs/en/llm-gateway
[cc-gateway-protocol]: https://code.claude.com/docs/en/llm-gateway-protocol.md
[agentskills]: https://agentskills.io/specification
[cdx-agents]: https://learn.chatgpt.com/docs/agent-configuration/agents-md
[cdx-cfg-basic]: https://learn.chatgpt.com/docs/config-file/config-basic
[cdx-cfg-adv]: https://learn.chatgpt.com/docs/config-file/config-advanced
[cdx-cfg-ref]: https://learn.chatgpt.com/docs/config-file/config-reference
[cdx-mcp]: https://learn.chatgpt.com/docs/extend/mcp
[cdx-models]: https://learn.chatgpt.com/docs/models
[cdx-skills]: https://learn.chatgpt.com/docs/build-skills
[cdx-hooks]: https://learn.chatgpt.com/docs/hooks
[cdx-import]: https://learn.chatgpt.com/docs/developer-commands
[cdx-agents-src]: https://github.com/openai/codex/blob/rust-v0.160.1/codex-rs/core/src/agents_md.rs
[cdx-prompt]: https://github.com/openai/codex/blob/rust-v0.160.1/codex-rs/protocol/src/prompts/base_instructions/default.md
[cdx-7782]: https://github.com/openai/codex/discussions/7782
[ag-rules]: https://antigravity.google/docs/rules
[ag-skills]: https://antigravity.google/docs/skills
[ag-mcp]: https://antigravity.google/docs/mcp
[ag-hooks]: https://antigravity.google/docs/hooks
[ag-workflows]: https://antigravity.google/docs/ide/workflows
[ag-wf-migration]: https://antigravity.google/docs/migration/workflows-to-skills
[ag-permissions]: https://antigravity.google/docs/permissions
[ag-settings]: https://antigravity.google/docs/settings
[ag-plugins]: https://antigravity.google/docs/plugins
[ag-sdk-local]: https://antigravity.google/docs/sdk/local-models
[ag-cli-install]: https://antigravity.google/docs/cli/install
[ag-changelog]: https://antigravity.google/docs/changelog
[oc2-config]: https://opencode.ai/v2/docs/config/
[oc-schema]: https://opencode.ai/config.json
[oc2-instructions]: https://opencode.ai/v2/docs/instructions/
[oc2-skills]: https://opencode.ai/v2/docs/skills/
[oc2-permissions]: https://opencode.ai/v2/docs/permissions/
[oc2-mcp]: https://opencode.ai/v2/docs/mcp-servers/
[oc2-providers]: https://opencode.ai/v2/docs/providers/
[oc2-plugins]: https://opencode.ai/v2/docs/plugins/
[oc2-migrate]: https://opencode.ai/v2/docs/migrate-v1/
[oc1-providers]: https://opencode.ai/docs/providers/
[oc-skills-src]: https://raw.githubusercontent.com/anomalyco/opencode/v2.0.18/packages/core/src/config/plugin/compatibility.ts
[lc-server]: https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md
[lc-b11530]: https://github.com/ggml-org/llama.cpp/blob/b11530/tools/server/README.md
[lc-docker]: https://github.com/ggml-org/llama.cpp/blob/master/.devops/cpu.Dockerfile
[lc-fc]: https://github.com/ggml-org/llama.cpp/blob/master/docs/function-calling.md
[vl-quickstart]: https://docs.vllm.ai/en/latest/getting_started/quickstart/
[vl-serving]: https://docs.vllm.ai/en/latest/serving/online_serving/
[vl-serve-cli]: https://docs.vllm.ai/en/latest/cli/serve/
[vl-security]: https://docs.vllm.ai/en/latest/usage/security/
[vl-launcher]: https://github.com/vllm-project/vllm/blob/main/vllm/entrypoints/launchers/launcher.py
[vl-cc]: https://docs.vllm.ai/en/latest/serving/integrations/claude_code/
[vl-codex]: https://docs.vllm.ai/en/latest/serving/integrations/codex/
