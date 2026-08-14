@./CONTEXT.md

# CLAUDE.md — scripts/mobile/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `code/src/scripts/CONTEXT.md` → this
folder's `CONTEXT.md` (script table, host-execution rationale, Metro ports — imported above) →
this file.

## Purpose (one line)

The sanctioned entry point for every mobile-surface operation — install, Metro, lint, typecheck,
test, bundle — each running on the host rather than in Docker.

## How to work here

- **Routing:** these scripts are the routing target for anything touching
  `code/src/mobile/`. **Never invoke `pnpm`, `expo`, `tsc` or `jest` directly.** The
  `stack-react-native` skill targets them.
- **Model:** Opus to author or change a script and to run one.
- **Concrete steps:** `install.sh` once → `server.sh` to develop against Expo Go → `lint.sh`,
  `typecheck.sh`, `test.sh --coverage` before a PR → `bundle.sh` last, because it is the CI gate.
- **Definition of done:** the script is idempotent where sensible, honours the shared
  `--help`/`--fix`/`--path` conventions, exits `0`/`1`/`2` per the house contract, and
  `CONTEXT.md` lists it.

## Guardrails

- **Host execution is deliberate — do not "fix" it into Docker.** A physical device running Expo
  Go cannot reach a `127.0.0.N` loopback alias; Metro has to be on the LAN. Containerising it
  breaks the day-one dev loop that ADR-level reasoning chose.
- **Never hardcode a Metro port.** Derive it from `_common.sh`, which joins the story's existing
  reserved block — hardcoding reintroduces the worktree collisions the scheme prevents.
- **`_common.sh` is sourced, never executed**, and it hard-fails when `code/src/mobile/` is
  absent. That failure is the intended behaviour: these scripts should not exist on a web-only
  project, so reaching them there means something has gone wrong.
- **Aggregates delegate here; they never reimplement.** If a new operation is added, wire it into
  `syntax/check.sh` or `tests/all.sh` behind the same directory-existence guard rather than
  duplicating the logic.
- **Do not add a mobile step to a root `package.json` script.** Root tooling stays web-only, which
  is what keeps a web-only generation byte-identical.
- Shell scripts are exempt from the 750-line source limit but stay focused.

## Output & naming

- **Hand-written:** every `*.sh` here plus this pair.
- **Generated / gitignored:** `code/src/mobile/.expo-bundle/` and `coverage/` — never committed.
- Scripts `kebab-case.sh`; the sourced helper is `_common.sh` (underscore prefix, sourced never
  called); documentation `SCREAMING-SNAKE-CASE.md`.
