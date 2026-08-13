@./CONTEXT.md

# CLAUDE.md — workflows/05-mcp-server/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(purpose, when-to-use, key concepts, cross-references — imported above) → this file.

## Purpose (one line)

The procedure for building and changing the FastMCP tool surface at `/mcp/` — the second
adapter over the service layer, for LLM agent clients — from the gate question through
mounting, auth, tools, tests, and hardening.

## How to work here

- **Routing:** governance folder — follow the workflow, do not casually edit it. Tools →
  `backend` + `stack-fastmcp` (Opus); auth and the threat model → `security`; tests →
  `test-writer`. Read `CONTEXT.md` first. **Entered from
  `project-management/workflows/19-api-code/`**, never directly from a design gate. Hard
  gates before Step 1: `code/docs/mcp-server/TOOL-DESIGN.md` and
  `code/docs/mcp-server/AUTH-AND-THREATS.md`.
- **Grill first:** Step 1 is a grilling pass (`.claude/skills/grill-with-docs`), and its
  opening question is the workflow's own gate — is an agent genuinely the caller? Never skip
  it; a tool surface that mirrors the Ninja API is a second contract for no new capability.
- **Model:** Fable for the Step 1 design and tool-set shaping; Opus for everything built,
  tested, and audited, and for mechanical touches to these files.
- **Concrete steps:** design → mount (`config/asgi.py`, first mount only) → verifier → tools
  in `apps/<app>/mcp_tools.py` → in-process `Client` tests → instrument → harden. All test and
  syntax runs go through `code/src/scripts/**/*.sh` — **never raw `pytest`, `python`,
  `manage.py`, or `docker`.**
- **Definition of done:** the `CHECKLIST.md` is satisfied end to end; coverage floors met
  (75%, **90%** on the verifier and `current_user()`); `08-security-hardening` run before
  public exposure; touched `CONTEXT.md` files and the code-review-graph refreshed.
- **Routing frontmatter:** this folder's `STEPS.md` and `CHECKLIST.md` carry
  `workflow`/`phase`/`skills`/`model` frontmatter — read it first (`.claude/CLAUDE.md` §2.5).

## Guardrails

- **Identity comes from the verified token, never from a tool argument.** No `user_id`, no
  `on_behalf_of`. The caller is a language model; such a parameter _is_ the IDOR.
- **Every state-changing tool carries the same named Policy as its Ninja twin**, imported
  rather than re-implemented — the `.claude/CLAUDE.md` §6 non-negotiable is about the
  operation, not the transport.
- **Never assume Django's middleware runs.** The `/mcp/` mount sits beside Django, not inside
  it: no session, no `login_required`, no CSRF, no API rate limiting, no Sentry Django
  integration. Anything relied on from the request cycle must be arranged in FastMCP.
- **No business logic in a tool** — it authorises, delegates to `services.py`, and maps.
- **Do not generate tools from this project's own OpenAPI document** (`from_openapi()`); see
  `code/docs/mcp-server/TOOL-DESIGN.md` for the four reasons and the trigger to reconsider.
- Nothing is mounted at baseline and `fastmcp` is undeclared — Step 2 adds both, once.
- Editing these workflow `.md` files: keep each **≤ 300 code lines**.

## Output & naming

- **Hand-written:** `STEPS.md`, `CHECKLIST.md`, `CONTEXT.md` — the workflow itself.
- **Produced by following it:** `config/mcp.py`, the `config/asgi.py` composition,
  `apps/<app>/mcp_tools.py`, the verifier under `apps/core/`, and their tests. The
  implementation record is written by
  `project-management/workflows/21-implementation-documentation/`, not here.
- Numeric `NN-` folder prefix; documentation `SCREAMING-SNAKE-CASE.md`; tool modules
  `mcp_tools.py` beside the app's `api.py`.
