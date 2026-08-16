#!/usr/bin/env bash
#
# static-analysis.sh: pattern and taint static analysis over the Django surface,
#                      using Opengrep against this project's own rule files.
#
#   What this closes that nothing else does:
#     · Django TEMPLATE issues. Ruff cannot see a .html file at all, so `{% autoescape
#       off %}`, `|safe`, and a template variable interpolated into an Alpine expression
#       or an inline script are unscanned today.
#     · Cross-file taint. Ruff's "S" ruleset (flake8-bandit) is already enabled and runs
#       per file in the lint step. A per-file linter flags a bare eval(); it cannot see
#       that the argument came off request.GET two modules away.
#
#   It does NOT duplicate the dependency CVE audit, which reads no source at all —
#   pip-audit and pnpm audit over the dependency tree.
#
#   ENGINE AND LICENCE (settled by grilling; do not change without re-grilling):
#     · Engine: Opengrep, plain LGPL-2.1, no Commons Clause. Running it over this
#       codebase propagates nothing to the scanned code.
#     · Rules: written in-house, in rules/, from this repository's own guides. No rule
#       text is vendored, copied, adapted or paraphrased from opengrep-rules
#       (LGPL-2.1 plus a Commons Clause, which would propagate into every generated
#       project), from semgrep-rules (Semgrep Rules License v1.0, internal use only and
#       non-distributable, which this template would breach by redistributing into
#       client projects), or from any CC-BY-SA source.
#     · The scan therefore runs with --config pointed at the local rules directory.
#       Never --config p/... : that fetches the registry rulesets this decision rejects.
#
#   OPTIONAL ON A LAPTOP, MANDATORY IN CI (settled by grilling). The engine is declared
#   in no install script and no dependency manifest here, so an ordinary local run still prints how to get
#   it, writes its report, and exits 0 — a developer who has not installed an optional
#   engine is not a build failure. That contract is only defensible because CI carries
#   the other half: the job that owns this audit installs the pinned engine, verifies its
#   signature, runs --self-test, and fails if any of that does not happen. Without that
#   job this script was a gate nobody had ever watched run, and an audit that cannot run
#   where it ships is one nobody ever sees fail.
#
#   OPTIONAL IS NOT THE SAME AS UNREACHABLE, and for a while it was. There was no local
#   route to the engine at all: the instruction here said pick an asset, chmod +x it and
#   put it on PATH — an unverified binary, by hand, contradicting the CI job's own stated
#   policy that this is the first downloaded binary in the toolchain and does not arrive
#   unverified. So a rule could be written, committed and released without its author ever
#   watching it run, and the only thing standing between a broken rule and a green CI was
#   a fixture nobody could exercise. The signature-verifying installer named in the hint
#   below is that route, and it checks the same signature against the same pinned identity
#   CI does.
#
#   VERSION PIN. The engine version lives in the root .opengrep-version, read here and
#   by the CI job, so there is one source of truth. It is this repository's fourth
#   toolchain pin, beside the Node, Python and Rust ones.
#
#   SELF-TEST. --self-test scans fixtures/static-analysis/{broken,clean} and asserts the
#   rules separate them: broken/ must trip every rule id, clean/ must trip none. It
#   exits 2 without the engine where the ordinary scan exits 0 — the precedent the
#   rendered-slop audit set, and for its reason: a proof that cannot fail is worse
#   than no proof, because its green result is believed.
#
# Usage: static-analysis.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                           [--path PATH] [--self-test] [--help]
#
# Exit codes:  0 = clean, or nothing to scan, or engine absent
#              1 = finding(s), the gate failed; or the self-test no longer separates
#                  the fixtures
#              2 = script error (bad arguments, missing rules, engine failure; or a
#                  --self-test with the engine or the fixtures absent)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
RULES_DIR="$SCRIPT_DIR/rules"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/static-analysis"
PIN_FILE="$PROJECT_ROOT/.opengrep-version"

# The pinned engine version, read rather than restated. CI installs exactly this build;
# a laptop may carry another, which is noted and never failed — the pin exists so the
# gate is reproducible, not so a developer is locked to one binary.
PINNED_VERSION=""
[[ -f "$PIN_FILE" ]] && PINNED_VERSION="$(tr -d '[:space:]' < "$PIN_FILE")"

# The surface Opengrep can say something useful about: server-rendered templates and
# the Python behind them. Both live under the single Django deployable.
SCOPES=(
  "code/src/django"
)

INSTALL_HINT='Install the pinned engine:
    bash code/src/scripts/development/install-opengrep.sh
  It reads the root .opengrep-version, picks the signed asset for your platform, and
  verifies its Sigstore signature against the release-workflow identity before anything
  is made executable. cosign is required and there is no path in it that installs an
  unverified binary.
  Opengrep stays deliberately optional: it is not declared in install.sh, pyproject.toml
  or package.json, and a local run never fails without it. CI installs the same pinned
  build and verifies the same signature, which is where this gate actually bites.'

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

FINDING_COUNT=0
FILE_COUNT=0
EXIT_CODE=0
STATUS=""
NOTE=""
BODY=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'static-analysis.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
static-analysis.sh: Opengrep scan of the Django surface against in-house rules

Closes the two gaps the existing tooling leaves: Django template issues (ruff cannot
read a .html file) and cross-file taint (a per-file linter cannot follow request data
into a sink). Dependency CVEs are security.sh; per-file Python lint is syntax/lint.sh.

Usage:
  static-analysis.sh                 Scan the default Django scope
  static-analysis.sh --output md     Also write a report
  static-analysis.sh --path DIR      Restrict the scan to a file or directory
  static-analysis.sh --self-test     Prove the rules still separate the fixtures

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/static-analysis-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Restrict the scan to a file or directory
  --self-test          Scan fixtures/static-analysis/{broken,clean} and assert every
                         rule id fires on broken/ and none fires on clean/
  --help               Show this help

Rules (all written in-house, in code/src/scripts/audits/rules/):
  django-template-xss.yml      Template data reaching a JavaScript or raw-HTML sink,
                               and auto-escaping disabled from Python
  django-safe-filter.yml       The |safe filter, and mark_safe() on non-constant input
  django-autoescape-off.yml    {% autoescape off %} blocks
  request-to-sink-taint.yml    Request data reaching raw SQL, an interpreter, a shell,
                               or a redirect target
  secrets-in-source.yml        Hard-coded credentials, connection URIs and key material

Engine:
  Opengrep (LGPL-2.1, no Commons Clause), pinned in the root .opengrep-version.
  Optional locally: when it is not installed this script prints install instructions,
  writes its report, and exits 0. Mandatory in CI, where the pinned build is installed
  and signature-verified before this runs.
  The scan always runs with --config pointed at the local rules directory, never at a
  registry ruleset, because the registry rules carry licences this project rejected.

Exit codes:  0 = clean / nothing to scan / engine absent
             1 = finding(s) / the self-test no longer separates the fixtures
             2 = script error / --self-test without the engine or the fixtures
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --self-test)    SELF_TEST=true; shift ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/static-analysis-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

[[ -d "$RULES_DIR" ]] || die "rules directory not found: $RULES_DIR"
RULE_FILES=$(find "$RULES_DIR" -maxdepth 1 -type f -name '*.yml' | sort)
[[ -n "$RULE_FILES" ]] || die "no *.yml rule files in $RULES_DIR"
RULE_FILE_COUNT=$(printf '%s\n' "$RULE_FILES" | wc -l | tr -d ' ')

# ── Engine availability ───────────────────────────────────────────────────────
# Hoisted above both paths: --self-test needs the answer before anything else runs,
# and the ordinary scan needs the same answer further down.
ENGINE_AVAILABLE=false
command -v opengrep >/dev/null 2>&1 && ENGINE_AVAILABLE=true

INSTALLED_VERSION=""
if $ENGINE_AVAILABLE; then
  INSTALLED_VERSION="$(opengrep --version 2>/dev/null | tr -d '[:space:]' || true)"
fi

# Opengrep mirrors the `scan` subcommand; fall back to the bare form if a build does
# not carry it, rather than reporting a script error for a CLI difference.
declare -a ENGINE_CMD=(opengrep)
if $ENGINE_AVAILABLE && opengrep scan --help >/dev/null 2>&1; then
  ENGINE_CMD=(opengrep scan)
fi

# ── Self-test ─────────────────────────────────────────────────────────────────
# Scans the fixture pair and asserts the rules separate it. Exits 2 rather than 0 when
# it cannot run, which is the opposite of the ordinary scan's contract and deliberate:
# an unrunnable proof reports green and is believed.
if $SELF_TEST; then
  ST_TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  log ""
  bold "▸ static-analysis.sh --self-test  $ST_TIMESTAMP"
  log "  engine: ${INSTALLED_VERSION:-(absent)}  ·  pinned: ${PINNED_VERSION:-(no pin file)}"
  log ""

  $ENGINE_AVAILABLE || die "opengrep is not installed, so the self-test cannot run.
  The ordinary scan exits 0 without the engine; this deliberately does not.
  $INSTALL_HINT"

  command -v python3 >/dev/null 2>&1 ||
    die "python3 is required to read the engine's JSON output under --self-test"

  [[ -d "$FIXTURES_DIR/broken" && -d "$FIXTURES_DIR/clean" ]] ||
    die "fixtures missing at ${FIXTURES_DIR#"$PROJECT_ROOT"/} — refusing to report a proof that never ran"

  # Every rule id, read out of the rule files rather than restated here. A rule added
  # without a matching fixture fails this, which is the only thing keeping the pair
  # honest as rules/ grows.
  EXPECTED=$(grep -hE '^[[:space:]]*- id:' "$RULES_DIR"/*.yml | sed 's/.*- id:[[:space:]]*//' | sort -u)
  EXPECTED_COUNT=$(printf '%s\n' "$EXPECTED" | grep -c . || true)

  # Returns one rule id per line, then a sentinel. Without the sentinel an engine that
  # errored and an engine that found nothing are indistinguishable, and the clean/ leg
  # would pass on the strength of a crash.
  scan_ids() {
    local target="$1" tmp rc
    tmp=$(mktemp)
    set +e
    "${ENGINE_CMD[@]}" --config "$RULES_DIR" --json --quiet "$target" >"$tmp" 2>/dev/null
    rc=$?
    set -e
    if [[ ! -s "$tmp" ]]; then
      rm -f "$tmp"
      die "opengrep produced no output scanning $target (exit $rc)"
    fi
    python3 -c '
import json, sys

with open(sys.argv[1]) as handle:
    data = json.load(handle)

for item in data.get("results", []):
    print(str(item.get("check_id", "")).rsplit(".", 1)[-1])
print("__SCANNED__")
' "$tmp" || die "opengrep output was not readable JSON scanning $target"
    rm -f "$tmp"
  }

  BROKEN_RAW=$(scan_ids "$FIXTURES_DIR/broken")
  CLEAN_RAW=$(scan_ids "$FIXTURES_DIR/clean")
  for leg in "$BROKEN_RAW" "$CLEAN_RAW"; do
    printf '%s\n' "$leg" | grep -qx '__SCANNED__' || die "a fixture leg did not complete"
  done
  BROKEN_IDS=$(printf '%s\n' "$BROKEN_RAW" | grep -vx '__SCANNED__' | sort -u || true)
  CLEAN_IDS=$(printf '%s\n' "$CLEAN_RAW" | grep -vx '__SCANNED__' | sort || true)

  MISSING=""
  while IFS= read -r rule_id; do
    [[ -n "$rule_id" ]] || continue
    printf '%s\n' "$BROKEN_IDS" | grep -qx -- "$rule_id" || MISSING="$MISSING $rule_id"
  done <<< "$EXPECTED"

  ST_FAIL=0
  if [[ -n "$MISSING" ]]; then
    ST_FAIL=1
    printf '\033[31m  ✗ broken/ did not trip:%s\033[0m\n' "$MISSING"
    log "    fix the rule or add the fixture — never delete the expectation"
  fi
  if [[ -n "${CLEAN_IDS//[$'\n\t ']/}" ]]; then
    ST_FAIL=1
    printf '\033[31m  ✗ clean/ produced findings — false positives:\033[0m\n'
    printf '%s\n' "$CLEAN_IDS" | sed 's/^/    /'
  fi

  log ""
  if [[ "$ST_FAIL" -eq 0 ]]; then
    bold "✓ Self-test passed — broken/ trips all $EXPECTED_COUNT rule(s), clean/ trips none."
    log ""
    exit 0
  fi
  bold "✗ Self-test failed — see code/src/scripts/audits/rules/CLAUDE.md."
  log ""
  exit 1
fi

declare -a ROOTS=()
if [[ -n "$TARGET_PATH" ]]; then
  [[ -e "$TARGET_PATH" ]] || die "--path '$TARGET_PATH' does not exist"
  ROOTS=("$TARGET_PATH")
else
  for scope in "${SCOPES[@]}"; do
    [[ -e "$scope" ]] && ROOTS+=("$scope")
  done
fi

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ static-analysis.sh  $TIMESTAMP"
log "  engine: opengrep ${INSTALLED_VERSION:-(absent)} · pinned ${PINNED_VERSION:-(none)}"
log "  rules:  $RULE_FILE_COUNT file(s) in ${RULES_DIR#"$PROJECT_ROOT"/}"
log "  scopes: ${ROOTS[*]:-(none present)}"
log ""

# ── Count the scannable surface ───────────────────────────────────────────────
# Self-guarding: a baseline project has no templates and almost no Python, so there
# is routinely nothing here to scan. That is a success, not a failure.
if [[ ${#ROOTS[@]} -gt 0 ]]; then
  FILE_COUNT=$(
    find "${ROOTS[@]}" \
      \( -path '*/__pycache__/*' -o -path '*/.venv/*' -o -path '*/node_modules/*' \
         -o -path '*/staticfiles/*' -o -path '*/static/vendor/*' \) -prune \
      -o -type f \( -name '*.py' -o -name '*.html' \) -print 2>/dev/null \
      | wc -l | tr -d ' '
  )
fi

# ── Decide which path we are on ───────────────────────────────────────────────
SKIP=false
if [[ "$FILE_COUNT" -eq 0 ]]; then
  SKIP=true
  STATUS="skipped: nothing to scan"
  NOTE="No *.py or *.html files under the scan scope, so there is nothing for Opengrep to read. A baseline project does NOT reach this path: it ships 19 Python files and the engine-absent branch is the one it takes. This branch is reached by pointing --path at a directory with no scannable source."
elif ! $ENGINE_AVAILABLE; then
  SKIP=true
  STATUS="skipped: engine not installed"
  NOTE="Opengrep is not on PATH. It is an optional tool and this audit never fails a build for its absence. Install it from https://github.com/opengrep/opengrep to make this gate meaningful."
fi

if $SKIP; then
  BODY="(no scan performed)"
  bold "▸ $STATUS"
  log "  $NOTE"
  if ! $ENGINE_AVAILABLE; then
    log ""
    log "  $INSTALL_HINT"
  fi
  log ""
else
  # ── Scan ────────────────────────────────────────────────────────────────────
  SCAN_JSON=$(mktemp)
  SCAN_ERR=$(mktemp)
  trap 'rm -f "$SCAN_JSON" "$SCAN_ERR"' EXIT

  set +e
  "${ENGINE_CMD[@]}" --config "$RULES_DIR" --json --quiet "${ROOTS[@]}" \
    >"$SCAN_JSON" 2>"$SCAN_ERR"
  SCAN_RC=$?
  set -e

  if [[ ! -s "$SCAN_JSON" ]]; then
    printf 'static-analysis.sh error: opengrep produced no output (exit %d)\n' "$SCAN_RC" >&2
    sed 's/^/  /' "$SCAN_ERR" >&2 || true
    exit 2
  fi

  # Render findings. python3 is present in this stack (it runs Django), but the
  # count degrades to grep rather than erroring if it ever is not.
  FORMATTED=""
  if command -v python3 >/dev/null 2>&1; then
    FORMATTED=$(python3 - "$SCAN_JSON" <<'PY' 2>/dev/null || true
import json, sys

with open(sys.argv[1]) as handle:
    data = json.load(handle)

results = data.get("results", [])
for item in results:
    extra = item.get("extra", {})
    line = item.get("start", {}).get("line", "?")
    message = " ".join(str(extra.get("message", "")).split())
    print("{}:{}: [{}] {}".format(
        item.get("path", "?"), line,
        extra.get("severity", "INFO"), item.get("check_id", "?")))
    print("    {}".format(message))

for err in data.get("errors", []):
    print("engine-error: {}".format(err.get("message", err)))

print("__COUNT__={}".format(len(results)))
PY
    )
  fi

  if [[ "$FORMATTED" == *"__COUNT__="* ]]; then
    FINDING_COUNT=${FORMATTED##*__COUNT__=}
    BODY=${FORMATTED%__COUNT__=*}
  else
    FINDING_COUNT=$(grep -o '"check_id"' "$SCAN_JSON" | wc -l | tr -d ' ')
    BODY=$(cat "$SCAN_JSON")
  fi
  [[ -n "${BODY//[$'\n\t ']/}" ]] || BODY="(no findings)"

  if [[ "$SCAN_RC" -ge 2 && "$FINDING_COUNT" -eq 0 ]]; then
    printf 'static-analysis.sh error: opengrep failed (exit %d)\n' "$SCAN_RC" >&2
    sed 's/^/  /' "$SCAN_ERR" >&2 || true
    exit 2
  fi

  if [[ "$FINDING_COUNT" -gt 0 ]]; then
    EXIT_CODE=1
    STATUS="$FINDING_COUNT finding(s)"
    $QUIET || {
      printf '\033[31m  ✗ %s\033[0m\n' "$STATUS"
      printf '%s\n' "$BODY" | sed 's/^/    /'
      printf '\n'
    }
  else
    STATUS="clean"
  fi
fi

# ── Report ────────────────────────────────────────────────────────────────────
# Written on every path, including both no-op paths. A consumer told to collect
# reports/static-analysis-report.<fmt> must always find the file there.
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    txt)
      {
        printf 'static-analysis audit: %s\n' "$TIMESTAMP"
        printf 'engine=opengrep engine_available=%s\n' "$ENGINE_AVAILABLE"
        printf 'rule_files=%s scanned_files=%s findings=%s\n' \
          "$RULE_FILE_COUNT" "$FILE_COUNT" "$FINDING_COUNT"
        printf 'status=%s\n' "$STATUS"
        [[ -n "$NOTE" ]] && printf 'note=%s\n' "$NOTE"
        printf '\n%s\n' "$BODY"
      } > "$OUTPUT_FILE" ;;

    md)
      {
        printf '# Static-Analysis Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Engine** | Opengrep (optional, LGPL-2.1) |\n'
        printf '| **Engine available** | %s |\n' "$ENGINE_AVAILABLE"
        printf '| **Rule files** | %s (in-house, `code/src/scripts/audits/rules/`) |\n' "$RULE_FILE_COUNT"
        printf '| **Files in scope** | %s |\n' "$FILE_COUNT"
        printf '| **Findings** | %s |\n' "$FINDING_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ -n "$NOTE" ]]; then printf '> %s\n\n' "$NOTE"; fi
        printf '```text\n%s\n```\n' "$BODY"
      } > "$OUTPUT_FILE" ;;

    json)
      NOTE_JSON=$(printf '%s' "$NOTE" | sed 's/\\/\\\\/g; s/"/\\"/g')
      STATUS_JSON=$(printf '%s' "$STATUS" | sed 's/\\/\\\\/g; s/"/\\"/g')
      {
        printf '{\n'
        printf '  "script": "static-analysis",\n'
        printf '  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "engine": "opengrep",\n'
        printf '  "engine_available": %s,\n' "$ENGINE_AVAILABLE"
        printf '  "rule_files": %s,\n' "$RULE_FILE_COUNT"
        printf '  "scanned_files": %s,\n' "$FILE_COUNT"
        printf '  "findings": %s,\n' "$FINDING_COUNT"
        printf '  "status": "%s",\n' "$STATUS_JSON"
        printf '  "note": "%s",\n' "$NOTE_JSON"
        printf '  "exit_code": %s\n' "$EXIT_CODE"
        printf '}\n'
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$EXIT_CODE" -eq 0 ]]; then
  if $SKIP; then
    bold "✓ static-analysis skipped, nothing failed."
  else
    bold "✓ No static-analysis findings across $FILE_COUNT file(s)."
  fi
else
  bold "✗ $FINDING_COUNT static-analysis finding(s)."
  log "  Each message names the guide it comes from. Fix the code, never the rule."
fi
log ""

exit "$EXIT_CODE"
