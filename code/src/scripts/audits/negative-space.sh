#!/usr/bin/env bash
#
# negative-space.sh — Verify the enforcement-point register against the code.
#
#                     how-to/src/INVARIANTS.md names every invariant this project holds,
#                     the ONE place each is enforced, and the key its guard raises.
#                     This audit correlates that file with the code, by name, in both
#                     directions and on both surfaces.
#
#                     Twelve [gate: fail] clauses and one [gate: warn]:
#                       constraint-unregistered        a Meta.constraints entry with no row
#                       constraint-absent              a row naming a constraint no model declares
#                       key-unraised                   a row whose Key nothing raises
#                       key-unregistered               a key raised in code with no row
#                       key-duplicated                 one key raised at two sites
#                       register-absent                the register gone, with things to register
#                       htmx-handler-absent            hx- in a template, no global beforeSwap
#                       request-id-middleware-absent   RequestIDMiddleware not in MIDDLEWARE
#                       ts-flags-loosened              a negative-space TypeScript flag not true
#                       mcp-error-middleware-absent    tools exist, no on_call_tool middleware
#                       mcp-masking-off                tools exist, mask_error_details not True
#                       mcp-request-id-absent          tools exist, the router mints no request id
#                       worked-row-stale        [warn]  the teaching example beside real rows
#
#                     What it CANNOT decide, and does not pretend to — both are marked
#                     [judgement] in the rule and belong to the reviewer:
#                       * whether an enforcement point guards the RIGHT thing. This matches
#                         names; a row can point at a function guarding something else.
#                       * whether an invariant is missing altogether. Nothing greps for a
#                         rule nobody wrote down.
#
#                     Two rules are deliberately NOT re-enforced here, because each already
#                     has a real analyser and two enforcers of one rule drift:
#                       * `assert` outside tests  → ruff S101
#                       * `from ninja import Schema` → ruff TID251
#
#                     Register: how-to/src/INVARIANTS.md
#
# SELF-TEST. --self-test runs every clause over the fixture pair in
# fixtures/negative-space/ and asserts it separates them: `broken/` must trip every fail
# clause, `clean/` must trip none. The fixtures are NOT a scan scope. This is what proves
# the gate in a repository where seven of the twelve clauses are no-ops: apps/ carries no
# models, no template uses hx-, and the MCP surface is unwired, so an ordinary run here is
# green having measured almost nothing.
#
# NO --path, AND THAT IS A DECISION. This audit is a two-way reconciliation between one
# register file and the whole tree, so a narrowed source scan does not narrow the question —
# it corrupts it, and the thirteen clauses break three ways under one.
#   TWO INVERT. `constraint-absent` and `key-unraised` read the register and ask the code to
#   answer, so a narrowed source scan turns a row that IS backed outside the path into a
#   finding that it is backed nowhere — a manufactured failure, not a missed one.
#   THREE UNDER-REPORT. `constraint-unregistered`, `key-unregistered` and `key-duplicated` run
#   the other way, code to register, and lose real findings instead: a key raised at a second
#   site outside the path simply stops being a duplicate.
#   FIVE NEVER MOVED AT ALL — `request-id-middleware-absent` (settings/base.py),
#   `ts-flags-loosened` (mobile/tsconfig.json), and the three MCP clauses (config/mcp.py twice,
#   config/asgi.py). The deleted block repointed four source scopes and left every config path
#   and the register itself where they were.
# The flag was accepted and then ignored — a bare run, `--path learning` and `--path code/docs`
# printed identical output but for the timestamp, including the line naming three surfaces it
# had not looked at. Accepting a scope and honouring none of it is the defect in
# code/docs/GATE-REPORTING.md
# Section 5, so it is refused at the parser instead, the way dependency-drift.sh, doctrine-drift.sh
# and security.sh refuse it. Narrow the run with --self-test, which repoints EVERY scope
# coherently, or read the whole tree.
#
# Usage: negative-space.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--self-test] [--help]
#
# Exit codes:  0 = clean, or warnings only, or the surface is absent
#              1 = fail-tier finding(s), or the self-test no longer separates the fixtures
#              2 = script error (bad arguments, or missing fixtures under --self-test)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="code/src/scripts/audits/fixtures/negative-space"

DOCTRINE="code/docs/NEGATIVE-SPACE.md"

# ── Scopes ────────────────────────────────────────────────────────────────────
# Every scope is a variable so --self-test can repoint the whole set at a fixture
# tree. Nothing below hard-codes a path.
REGISTER_FILE="how-to/src/INVARIANTS.md"
MODELS_DIR="code/src/django/apps"
PY_DIR="code/src/django"
TS_DIR="code/src/mobile"
TEMPLATES_DIR="code/src/django"
STATIC_DIR="code/src/django/static"
SETTINGS_FILE="code/src/django/config/settings/base.py"
TSCONFIG_FILE="code/src/mobile/tsconfig.json"
MCP_TOOLS_DIR="code/src/django/apps"
MCP_CONFIG_FILE="code/src/django/config/mcp.py"
ASGI_FILE="code/src/django/config/asgi.py"

# The four TypeScript flags this project's mobile coding standard requires. Each bans a
# state; `strict` implies none of them and expo/tsconfig.base sets none, so removing one
# is silent — tsc still exits 0.
TS_FLAGS=(noUncheckedIndexedAccess exactOptionalPropertyTypes noImplicitReturns noFallthroughCasesInSwitch)

MIDDLEWARE_CLASS="apps.core.middleware.RequestIDMiddleware"

# The MCP surface's three configs. Keyed on FastMCP's own hook name and on a class this
# project owns, never on a path — the same choice htmx-handler-absent makes, so moving or
# renaming the module is not a CI failure.
MCP_ERROR_HOOK="on_call_tool"
MCP_MASK_SETTING="mask_error_details"
REQUEST_ID_ASGI_CLASS="RequestIDASGIMiddleware"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false

FAIL_COUNT=0
WARN_COUNT=0
SKIP_NOTES=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'negative-space.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
negative-space.sh — verify the enforcement-point register against the code

Usage:
  negative-space.sh                Check the register, both surfaces, and the two configs
  negative-space.sh --output md    Also write a report
  negative-space.sh --self-test    Prove the clauses still separate the fixtures

There is no --path. This reconciles one register against the whole tree in BOTH
directions, so narrowing the source scan does not narrow the question — it makes a
register row backed outside the narrowed path report as backed nowhere, and hides the
findings that run the other way. --self-test is the only scope change, and it repoints
every scope together.

Clauses — twelve [gate: fail], one [gate: warn]:
  constraint-unregistered       a Meta.constraints entry with no register row
  constraint-absent             a row naming a constraint no model declares
  key-unraised                  a row whose Key nothing raises
  key-unregistered              a key raised in code with no register row
  key-duplicated                one key raised at two sites — the second call site
  register-absent               the register is gone and there is something to register
  htmx-handler-absent           a template uses hx-, no global htmx:beforeSwap listener
  request-id-middleware-absent  RequestIDMiddleware is not in MIDDLEWARE
  ts-flags-loosened             one of the four TypeScript flags is not true
  mcp-error-middleware-absent   tools exist, config/mcp.py has no on_call_tool middleware
  mcp-masking-off               tools exist, mask_error_details is not True
  mcp-request-id-absent         tools exist, the ASGI router mints no request id
  worked-row-stale      [warn]  the worked-row example still sits beside real rows

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/negative-space-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --self-test          Run every clause over fixtures/negative-space/{broken,clean}
  --help               Show this help

There is no silencing annotation, deliberately: a comment suppressing a finding here is
itself a finding, on the same reasoning that makes a `# noqa: S101` one.

Rule: code/docs/NEGATIVE-SPACE.md   Register: how-to/src/INVARIANTS.md

Exit codes:  0 = clean or warnings only   1 = fail-tier finding(s)   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    # Named rather than left to the catch-all, because it USED to be accepted. A reader
    # who ran it yesterday needs the reason, not "Unknown option" — see the header note.
    --path)         die "--path is not accepted: this reconciles how-to/src/INVARIANTS.md against the whole tree in both directions, and a narrowed source scan reports rows as backed nowhere that are backed outside it. Use --self-test, or run unscoped." ;;
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
  OUTPUT_FILE="$REPORTS_DIR/negative-space-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_FAIL=$(mktemp); TMP_WARN=$(mktemp); TMP_ROWS=$(mktemp)
TMP_CONSTRAINTS=$(mktemp); TMP_KEYS=$(mktemp)
trap 'rm -f "$TMP_FAIL" "$TMP_WARN" "$TMP_ROWS" "$TMP_CONSTRAINTS" "$TMP_KEYS"' EXIT

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

fail() { printf '%s: %s\n' "$1" "$2" >> "$TMP_FAIL"; }
warn() { printf '%s: %s\n' "$1" "$2" >> "$TMP_WARN"; }
skip() { SKIP_NOTES="${SKIP_NOTES}  · $1"$'\n'; }

# ── Register parsing — SECTION-AWARE, not a line grep ─────────────────────────
# Only the three real tables are read. `## A worked row, for shape only` is teaching
# content naming enforcement points that deliberately do not exist; reading it would
# fail every project on day one. Placeholder rows (_None yet — …_) are not findings.
#
# Emits TSV: mechanism <TAB> key <TAB> enforcement-point
parse_register() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  awk -F'|' '
    function clean(s) {
      gsub(/`/, "", s); gsub(/\*\*/, "", s)
      gsub(/^[ \t]+|[ \t]+$/, "", s)
      return s
    }
    /^##[ \t]/ {
      inscope = ($0 ~ /^##[ \t]+(Database|Service|Client)-enforced/) ? 1 : 0
      next
    }
    !inscope { next }
    /^\|/ {
      inv = clean($2); key = clean($3); mech = clean($4); point = clean($5)
      if (inv ~ /^-+$/ || inv == "Invariant") next        # separator and header
      if (inv ~ /^_None yet/ || inv == "") next           # placeholder
      printf "%s\t%s\t%s\n", mech, key, point
    }
  ' "$file"
}

# ── Constraint names declared in models ───────────────────────────────────────
# A `name=` is a constraint name only inside a *Constraint(...) call. The window is
# what keeps Meta.indexes out: models.Index(name="idx_…") is an index, not an invariant,
# and demanding a register row for one would be wrong.
#
# Limit, stated because it decides what a green run is worth: a constraint whose name is
# built at runtime rather than written as a literal is invisible here.
collect_constraints() {
  local dir="$1"
  [[ -d "$dir" ]] || return 0
  find "$dir" -type f -name '*.py' ! -path '*/tests/*' ! -path '*/migrations/*' -print0 |
    xargs -0 -r awk '
      /Constraint\(/ { win = 8 }
      /Index\(/      { win = 0 }
      win > 0 {
        line = $0
        while (match(line, /(^|[^_[:alnum:]])name[ \t]*=[ \t]*"[a-z][a-z0-9_]*"/)) {
          hit = substr(line, RSTART, RLENGTH)
          sub(/^[^"]*"/, "", hit); sub(/"$/, "", hit)
          print FILENAME ":" FNR "\t" hit
          line = substr(line, RSTART + RLENGTH)
        }
        win--
      }
    '
}

# ── Keys raised in code, both surfaces ────────────────────────────────────────
# Test code is exempt on both, exactly as ruff S101 exempts it: testing a guard is the
# coverage this doctrine wants, and the mobile guard's own suite raises real keys.
#
# Limit: a key passed as a variable rather than a literal is invisible to both patterns.
collect_keys() {
  local py_dir="$1" ts_dir="$2"

  if [[ -d "$py_dir" ]]; then
    find "$py_dir" -type f -name '*.py' ! -path '*/tests/*' ! -name 'conftest.py' -print0 |
      xargs -0 -r grep -noE 'InvariantViolation\([ \t]*"[^"]+"' 2>/dev/null |
      sed -E 's/:InvariantViolation\([ \t]*"/\t/; s/"$//' || true
  fi

  if [[ -d "$ts_dir" ]]; then
    find "$ts_dir" -type f \( -name '*.ts' -o -name '*.tsx' \) \
      ! -path '*/__tests__/*' ! -name '*.test.ts' ! -name '*.test.tsx' \
      ! -path '*/node_modules/*' -print0 |
      xargs -0 -r grep -noE 'InvariantViolation\([ \t]*"[^"]+"|unreachable\([^,]*,[ \t]*"[^"]+"' 2>/dev/null |
      sed -E 's/:(InvariantViolation|unreachable)\(([^,]*,)?[ \t]*"/\t/; s/"$//' || true
  fi
}

# ── Clause runners ────────────────────────────────────────────────────────────
run_register_clauses() {
  local register="$1" models_dir="$2" py_dir="$3" ts_dir="$4"

  parse_register "$register" > "$TMP_ROWS"
  collect_constraints "$models_dir" > "$TMP_CONSTRAINTS"
  collect_keys "$py_dir" "$ts_dir" > "$TMP_KEYS"

  local have_constraints have_keys
  have_constraints=$(grep -c . "$TMP_CONSTRAINTS" || true)
  have_keys=$(grep -c . "$TMP_KEYS" || true)

  # register-absent — the register gone while there is something to register turns
  # every clause below into a silent no-op, which is worse than having no gate.
  if [[ ! -f "$register" ]]; then
    if [[ "${have_constraints:-0}" -gt 0 || "${have_keys:-0}" -gt 0 ]]; then
      fail register-absent "$register is missing, but the code declares constraints or raises keys"
    else
      skip "register-absent: no $register and nothing to register"
    fi
    return 0
  fi

  # constraint-unregistered — every declared constraint has a row naming it.
  local loc cname
  while IFS=$'\t' read -r loc cname; do
    [[ -n "$cname" ]] || continue
    # -F -w, not -x: a `both` row's Enforcement point holds the constraint name AND the
    # function, so the name is a word inside the cell rather than the whole cell.
    if ! cut -f3 "$TMP_ROWS" | grep -qFw -- "$cname"; then
      fail constraint-unregistered "$loc — constraint \`$cname\` has no row in $register"
    fi
  done < "$TMP_CONSTRAINTS"

  # constraint-absent — every db-constraint / both row names a constraint that exists.
  # A Django class name identifies nothing (a table can carry twenty CheckConstraints),
  # so it is not accepted as a constraint name.
  local mech key point
  while IFS=$'\t' read -r mech key point; do
    case "$mech" in db-constraint|both) ;; *) continue ;; esac
    local token found=false
    for token in $(printf '%s\n' "$point" | tr -cs 'A-Za-z0-9_' '\n'); do
      case "$token" in
        UniqueConstraint|CheckConstraint|ExclusionConstraint|Constraint|Q|F) continue ;;
      esac
      printf '%s' "$token" | grep -qE '^[a-z][a-z0-9_]*$' || continue
      if cut -f2 "$TMP_CONSTRAINTS" | grep -qFx -- "$token"; then found=true; break; fi
    done
    $found || fail constraint-absent \
      "$register — \`$mech\` row names no constraint any model declares: \`$point\`"
  done < "$TMP_ROWS"

  # key-unraised — a row's Key is raised somewhere.
  while IFS=$'\t' read -r mech key point; do
    case "$mech" in service-guard|client-guard|both) ;; *) continue ;; esac
    [[ -n "$key" && "$key" != "—" && "$key" != "-" ]] || {
      fail key-unraised "$register — \`$mech\` row has no Key: \`$point\`"; continue; }
    if ! cut -f2 "$TMP_KEYS" | grep -qFx -- "$key"; then
      fail key-unraised "$register — key \`$key\` is raised nowhere"
    fi
  done < "$TMP_ROWS"

  # key-unregistered — every key raised in code has a row.
  # key-duplicated — and it is raised at exactly one site. The second call site is a
  # finding by doctrine, not a judgement call.
  local seen
  seen=$(cut -f2 "$TMP_KEYS" | sort -u)
  local k
  for k in $seen; do
    [[ -n "$k" ]] || continue
    if ! cut -f2 "$TMP_ROWS" | grep -qFx -- "$k"; then
      fail key-unregistered "key \`$k\` is raised in code with no row in $register"
    fi
    local n
    n=$(cut -f2 "$TMP_KEYS" | grep -cFx -- "$k" || true)
    if [[ "${n:-0}" -gt 1 ]]; then
      local sites
      sites=$(awk -F'\t' -v k="$k" '$2 == k { print $1 }' "$TMP_KEYS" | paste -sd' ' -)
      fail key-duplicated "key \`$k\` is raised at $n sites — $sites"
    fi
  done

  # worked-row-stale [warn] — the teaching example beside real rows.
  if grep -qE '^##[ \t]+A worked row' "$register" && [[ -s "$TMP_ROWS" ]]; then
    warn worked-row-stale "$register still carries the worked-row example alongside real rows"
  fi
}

run_htmx_clause() {
  local templates_dir="$1" static_dir="$2"
  [[ -d "$templates_dir" ]] || { skip "htmx-handler-absent: no $templates_dir"; return 0; }

  local users
  users=$(find "$templates_dir" -type f -name '*.html' ! -path '*/node_modules/*' -print0 2>/dev/null |
    xargs -0 -r grep -lE '\bhx-(get|post|put|patch|delete|trigger|target|swap)' 2>/dev/null || true)
  [[ -n "$users" ]] || { skip "htmx-handler-absent: no template uses hx-"; return 0; }

  # Keyed on the listener, never on a path: the rule is "one global handler, never per
  # element", so moving the script is not a failure. Limit: this proves a listener
  # exists, never that it handles 500 and 503 correctly.
  local handler=""
  if [[ -d "$static_dir" ]]; then
    handler=$(find "$static_dir" -type f -name '*.js' -print0 2>/dev/null |
      xargs -0 -r grep -lE 'body[ \t]*\.[ \t]*addEventListener\([ \t]*["'"'"']htmx:beforeSwap' 2>/dev/null || true)
  fi
  if [[ -z "$handler" ]]; then
    local first
    first=$(printf '%s\n' "$users" | head -1)
    fail htmx-handler-absent \
      "$first uses hx- but no global document.body htmx:beforeSwap listener exists under $static_dir"
  fi
}

run_middleware_clause() {
  local settings="$1"
  [[ -f "$settings" ]] || { skip "request-id-middleware-absent: no $settings"; return 0; }
  # Bounded to the MIDDLEWARE list: a mention in a comment elsewhere is not the wiring.
  awk -v cls="$MIDDLEWARE_CLASS" '
    /^MIDDLEWARE[ \t]*=/ { inlist = 1 }
    inlist && index($0, cls) { found = 1 }
    inlist && /^\]/ { inlist = 0 }
    END { exit found ? 0 : 1 }
  ' "$settings" || fail request-id-middleware-absent \
    "$settings — $MIDDLEWARE_CLASS is not in MIDDLEWARE; every response loses X-Request-ID"
}

run_ts_flags_clause() {
  local tsconfig="$1"
  [[ -f "$tsconfig" ]] || { skip "ts-flags-loosened: no mobile surface"; return 0; }
  local flag
  for flag in "${TS_FLAGS[@]}"; do
    grep -qE "\"$flag\"[ \t]*:[ \t]*true" "$tsconfig" ||
      fail ts-flags-loosened "$tsconfig — \`$flag\` is not \`true\`"
  done
}

# ── The MCP tool surface ──────────────────────────────────────────────────────
# All three clauses are gated on a tool module existing, exactly as htmx-handler-absent is
# gated on a template using hx-: the surface is unwired at baseline and demanding its
# configuration from a project that has no tools would fail correct work.
#
# Limits, stated because they decide what a green run is worth: the first clause proves a
# middleware with a tool hook is registered, never that it classifies correctly; the third
# proves the router names the class, never that the class does the right thing.
run_mcp_clauses() {
  local tools_dir="$1" mcp_config="$2" asgi="$3"
  [[ -d "$tools_dir" ]] || { skip "mcp-*: no $tools_dir"; return 0; }

  local tools
  tools=$(find "$tools_dir" -type f -name 'mcp_tools.py' ! -path '*/tests/*' -print 2>/dev/null | head -1)
  [[ -n "$tools" ]] || { skip "mcp-*: no mcp_tools.py — the MCP surface is unwired"; return 0; }

  # mcp-error-middleware-absent — one on_call_tool boundary, never one try/except per tool.
  if [[ ! -f "$mcp_config" ]] || ! grep -q -- "$MCP_ERROR_HOOK" "$mcp_config"; then
    fail mcp-error-middleware-absent \
      "$tools defines tools but $mcp_config registers no \`$MCP_ERROR_HOOK\` middleware"
  fi

  # mcp-masking-off — the flag plus the exception type IS the rule. FastMCP's default is
  # False, which sends an InvariantViolation's register key and detail to the model verbatim.
  if [[ ! -f "$mcp_config" ]] || ! grep -qE "$MCP_MASK_SETTING[ \t]*=[ \t]*True" "$mcp_config"; then
    fail mcp-masking-off \
      "$mcp_config — \`$MCP_MASK_SETTING=True\` is not set; internals reach the model"
  fi

  # mcp-request-id-absent — minted above both mounts, or a tool call and a page are two
  # records joined by timestamp.
  if [[ ! -f "$asgi" ]] || ! grep -q -- "$REQUEST_ID_ASGI_CLASS" "$asgi"; then
    fail mcp-request-id-absent \
      "$asgi — the router does not register $REQUEST_ID_ASGI_CLASS; /mcp/ has no correlation"
  fi
}

run_all() {
  run_register_clauses "$REGISTER_FILE" "$MODELS_DIR" "$PY_DIR" "$TS_DIR"
  run_htmx_clause "$TEMPLATES_DIR" "$STATIC_DIR"
  run_middleware_clause "$SETTINGS_FILE"
  run_ts_flags_clause "$TSCONFIG_FILE"
  run_mcp_clauses "$MCP_TOOLS_DIR" "$MCP_CONFIG_FILE" "$ASGI_FILE"
}

point_scopes_at() {
  local root="$1"
  REGISTER_FILE="$root/INVARIANTS.md"
  MODELS_DIR="$root"
  PY_DIR="$root"
  TS_DIR="$root"
  TEMPLATES_DIR="$root"
  STATIC_DIR="$root"
  SETTINGS_FILE="$root/settings.py"
  TSCONFIG_FILE="$root/tsconfig.json"
  MCP_TOOLS_DIR="$root"
  MCP_CONFIG_FILE="$root/mcp.py"
  ASGI_FILE="$root/asgi.py"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
if $SELF_TEST; then
  log ""
  bold "▸ negative-space.sh --self-test — $TIMESTAMP"
  [[ -d "$FIXTURES_DIR/broken" && -d "$FIXTURES_DIR/clean" ]] ||
    die "fixtures missing at $FIXTURES_DIR — refusing to report a proof that never ran"

  point_scopes_at "$FIXTURES_DIR/broken"
  : > "$TMP_FAIL"; : > "$TMP_WARN"; SKIP_NOTES=""
  run_all
  BROKEN_CLAUSES=$(cut -d: -f1 "$TMP_FAIL" | sort -u)
  BROKEN_BODY="$(cat "$TMP_FAIL")"

  point_scopes_at "$FIXTURES_DIR/clean"
  : > "$TMP_FAIL"; : > "$TMP_WARN"; SKIP_NOTES=""
  run_all
  CLEAN_BODY="$(cat "$TMP_FAIL")"

  EXPECTED=(constraint-unregistered constraint-absent key-unraised key-unregistered
            key-duplicated htmx-handler-absent request-id-middleware-absent ts-flags-loosened
            mcp-error-middleware-absent mcp-masking-off mcp-request-id-absent)
  MISSING=""
  for clause in "${EXPECTED[@]}"; do
    printf '%s\n' "$BROKEN_CLAUSES" | grep -qx -- "$clause" || MISSING="$MISSING $clause"
  done

  ST_FAIL=0
  if [[ -n "$MISSING" ]]; then
    ST_FAIL=1
    log ""
    printf '\033[31m  ✗ broken/ did not trip:%s\033[0m\n' "$MISSING"
    log "    the detector no longer separates the fixtures — fix the detector, not the fixtures"
  fi
  if [[ -n "$CLEAN_BODY" ]]; then
    ST_FAIL=1
    log ""
    printf '\033[31m  ✗ clean/ produced findings — false positives:\033[0m\n'
    printf '%s\n' "$CLEAN_BODY" | sed 's/^/    /'
  fi

  log ""
  if [[ "$ST_FAIL" -eq 0 ]]; then
    bold "✓ Self-test passed — broken/ trips ${#EXPECTED[@]} clauses, clean/ trips none."
    log ""
    exit 0
  fi
  log "  broken/ findings were:"
  printf '%s\n' "$BROKEN_BODY" | sed 's/^/    /'
  log ""
  bold "✗ Self-test failed — see $DOCTRINE."
  exit 1
fi

# ── Ordinary run ──────────────────────────────────────────────────────────────
log ""
bold "▸ negative-space.sh — $TIMESTAMP"

# The scopes are whatever the declarations at the top of this file say, always. Nothing
# repoints them here: the only sanctioned repoint is point_scopes_at() under --self-test,
# which moves the whole set at once so the register and the code it is checked against
# stay the same tree. A partial repoint — four source scopes moved and the register left
# where it was — is what the deleted --path block did, and it is the one shape of this
# script that can print a verdict about a correlation it never performed.
run_all

FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(grep -c . "$TMP_WARN" || true); WARN_COUNT=${WARN_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
WARN_BODY="$(cat "$TMP_WARN")"

log "  register: $REGISTER_FILE · surfaces: django + mcp + mobile · 12 fail, 1 warn"
log ""

if [[ -n "$SKIP_NOTES" ]] && ! $QUIET; then
  printf '\033[2m  clauses with nothing to measure:\033[0m\n'
  printf '%s' "$SKIP_NOTES"
  printf '\n'
fi

if [[ "$FAIL_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d finding%s\033[0m\n' "$FAIL_COUNT" "$([[ "$FAIL_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n\n' "$FAIL_BODY" | sed 's/^/    /'
fi
if [[ "$WARN_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[33m  ! %d warning%s\033[0m\n' "$WARN_COUNT" "$([[ "$WARN_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n\n' "$WARN_BODY" | sed 's/^/    /'
fi

# A report is written on every path, including the no-op one: a CI job told to collect
# the artefact must always find it.
if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$FAIL_COUNT" -eq 0 ]] && echo '✓ register and code agree' || echo "✗ $FAIL_COUNT finding(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'negative-space audit — %s\n' "$TIMESTAMP"
        printf 'findings=%s warnings=%s\n\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '%s\n' "${FAIL_BODY:-No findings.}"
        printf '\n%s\n' "${WARN_BODY:-No warnings.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Negative-Space Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Register** | `%s` |\n' "$REGISTER_FILE"
        printf '| **Findings** `[gate: fail]` | %s |\n' "$FAIL_COUNT"
        printf '| **Warnings** `[gate: warn]` | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '## Findings\n\n```text\n%s\n```\n\n' "$FAIL_BODY"
        else printf '_No findings._\n\n'; fi
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '## Warnings\n\n```text\n%s\n```\n\n' "$WARN_BODY"; fi
        if [[ -n "$SKIP_NOTES" ]]; then printf '## Nothing to measure\n\n```text\n%s```\n\n' "$SKIP_NOTES"; fi
        printf '_Two clauses are `[judgement]` and no script decides them: whether an enforcement\n'
        printf 'point guards the right thing, and whether an invariant is missing altogether._\n'
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "negative-space",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "register": "%s",\n' "$REGISTER_FILE"
        printf '  "findings": %s,\n  "warnings": %s,\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$FAIL_COUNT" -eq 0 ]]; then
  if [[ "$WARN_COUNT" -gt 0 ]]; then
    bold "✓ No findings — $WARN_COUNT warning(s), which do not fail the run."
  else
    bold "✓ Register and code agree."
  fi
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT negative-space finding(s) — see $DOCTRINE."
  log ""
  exit 1
fi
