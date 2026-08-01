@./CONTEXT.md

# CLAUDE.md — scripts/audits/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(script inventory, flags, exit codes — imported above) → this file → `reports/`.

## Purpose (one line)

Host-run codebase-health audits — `cloc.sh` (line-count enforcement), `stubs.sh`
(stub detection), `css-tokens.sh` (phantom-token guard), and `security.sh`
(dependency CVE audit) — each mirroring a CI gate so a clean local run predicts a
clean CI run.

## How to work here

- **Routing:** run these before raising a PR; they back the `06-review` workflow and
  the pre-PR quality gates. `cloc.sh`/`stubs.sh`/`css-tokens.sh` run on the host with
  no Docker; `security.sh` runs on the host by default, `--docker` to audit inside
  the running dev containers.
- **Model:** Opus to change audit logic (thresholds, patterns, exit codes)
  and to run an audit.
- **Concrete steps:** invoke the audit → fix real findings in source, **never** by
  loosening a threshold to pass → re-run until clean → keep `security.sh` at
  `pip-audit` for CI parity (`uv audit` is a different, experimental tool).
- **Definition of done:** exit `0`; the 750-warn/800-fail line limit respected; every
  `var(--x)` resolves to a defined token; no hard stubs outside a declared TDD red
  phase.

## Guardrails

- **`css-tokens.sh` enforces token-first CSS** — a `var(--x)` that resolves to no
  defined token fails the run; add the token in the token layer, never silence the
  audit.
- **Line limit is a hard gate:** ≥ 800 lines fails — split the file, do not raise the
  ceiling.
- TDD/BDD red phase is the _only_ sanctioned stub bypass, via `STUBS_TDD_RED=1`;
  never disable `stubs.sh` any other way.
- Markdown is deliberately exempt from stub and line-limit checks — do not extend
  these audits to `*.md`.

## Output & naming

- **Hand-written:** the four `*.sh` audit scripts.
- **Generated / gitignored:** report files under `reports/`
  (`stubs-report.*`, `cloc-report.*`) via `--output <FORMAT>`.
- Scripts `kebab-case.sh`; report formats `md` / `txt` / `json` / `html`.
