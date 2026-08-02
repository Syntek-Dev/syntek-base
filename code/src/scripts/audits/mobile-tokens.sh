#!/usr/bin/env bash
#
# mobile-tokens.sh — Enforce the token-first law on the MOBILE surface: no raw design
#                    values in StyleSheet code. The sibling of css-tokens.sh.
#
#                    Only ONE half of the law needs a script here. The web guard checks
#                    both "no raw literals" and "the name resolves"; on mobile the second
#                    half is free, because the emitted token module is TYPED — an
#                    unresolved token import does not compile, and typecheck.sh already
#                    fails the build. So this script checks raw literals only.
#
# Scope scanned (*.ts, *.tsx):
#   code/src/mobile        (the whole mobile surface)
#
# NO-OP WHEN ABSENT — a web-only project has no code/src/mobile, so the script exits 0
# with a note rather than failing. This mirrors the step-level guards in CI: a web-only
# project reports success, not "skipped".
#
# What counts as a violation:
#   colour literals   #rgb #rrggbb #rrggbbaa, rgb() rgba() hsl() hsla() hwb()
#   design numerics   fontSize, lineHeight, letterSpacing, padding*, margin*, gap*,
#                     borderRadius, borderWidth, elevation, shadowRadius, shadowOpacity,
#                     numeric fontWeight
#
# What does NOT count, deliberately: flex, opacity, zIndex, width, height, top/left/
# right/bottom, aspectRatio. These are LAYOUT, not design values — they have no token
# and never will, so flagging them would train people to ignore the gate.
#
# Escape hatch: put `token-allow` in a comment on the offending line or the line above,
# with a reason. Mirrors css-gradients.sh's `gradient-allow`. Use it for values that are
# genuinely structural, never to silence real debt.
#
# Usage: mobile-tokens.sh [--output FORMAT] [--output-file PATH] [--quiet] [--path PATH]
#                         [--help]
#
# Exit codes:  0 = clean (or surface absent)   1 = raw literals found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

SCOPE="code/src/mobile"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'mobile-tokens.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
mobile-tokens.sh — Enforce token-first styling on the mobile surface

Usage:
  mobile-tokens.sh                 Scan the whole mobile surface
  mobile-tokens.sh --output md     Also write a report
  mobile-tokens.sh --path app/     Restrict the scan to a file or directory

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/mobile-tokens-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the scan to a file or directory
  --help               Show this help

Annotate a genuinely structural value with `token-allow` in a comment on the same line
or the line above. Never use it to silence real design debt.

Exit codes:  0 = clean (or surface absent)   1 = raw literals found   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
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
  OUTPUT_FILE="$REPORTS_DIR/mobile-tokens-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# ── No-op when the mobile surface is absent ───────────────────────────────────
if [[ ! -d "$SCOPE" ]]; then
  log ""
  bold "▸ mobile-tokens.sh — $TIMESTAMP"
  log "  $SCOPE does not exist — this project has no mobile surface."
  log ""
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

SCAN_ROOT="${TARGET_PATH:-$SCOPE}"
[[ -e "$SCAN_ROOT" ]] || die "--path '$SCAN_ROOT' does not exist"

TMP_FILES=$(mktemp); TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_FILES" "$TMP_HITS"' EXIT

# Source files only — never the generated bundle, coverage output or dependencies.
find "$SCAN_ROOT" -type f \( -name '*.ts' -o -name '*.tsx' \) \
  -not -path '*/node_modules/*' \
  -not -path '*/.expo/*' \
  -not -path '*/.expo-bundle/*' \
  -not -path '*/coverage/*' \
  -not -name 'expo-env.d.ts' \
  -print0 > "$TMP_FILES" || true

FILE_COUNT=$(tr -cd '\0' < "$TMP_FILES" | wc -c | tr -d ' ')

log ""
bold "▸ mobile-tokens.sh — $TIMESTAMP"
log "  scope: $SCAN_ROOT"
log "  files: $FILE_COUNT"
log ""

# Regexes are POSIX ERE — awk supports neither \b nor PCRE escapes, and a bad pattern
# makes awk abort mid-file, which would report a FALSE CLEAN. Word boundaries are spelt
# out as (^|[^a-zA-Z0-9_]); no {n,m} intervals, for portability across awk implementations.
# Emit "file:line:kind:text" for every candidate, then drop annotated ones.
# A hit is exempt if `token-allow` appears on its own line or the line before.
: > "$TMP_HITS"
while IFS= read -r -d '' f; do
  awk -v FILE="$f" '
    { line[NR] = $0 }
    END {
      B = "(^|[^a-zA-Z0-9_])"
      CRE = "#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]|" B "(rgba|rgb|hsla|hsl|hwb)[ \t]*[(]"
      PROPS = "(fontSize|lineHeight|letterSpacing|borderRadius|borderWidth|elevation" \
              "|shadowRadius|shadowOpacity|padding|paddingTop|paddingBottom|paddingLeft" \
              "|paddingRight|paddingHorizontal|paddingVertical|margin|marginTop" \
              "|marginBottom|marginLeft|marginRight|marginHorizontal|marginVertical" \
              "|gap|rowGap|columnGap)"
      NRE = B PROPS "[ \t]*:[ \t]*-?[0-9]|" B "fontWeight[ \t]*:[ \t]*.?[0-9]"
      for (i = 1; i <= NR; i++) {
        s = line[i]
        # Strip // and /* */ comment bodies for MATCHING, but keep the raw line for the
        # allow check and the report, so a documented example never counts.
        m = s
        sub(/\/\/.*$/, "", m)
        gsub(/\/\*[^*]*\*\//, "", m)
        kind = ""
        if (m ~ CRE) kind = "colour"
        else if (m ~ NRE) kind = "numeric"
        if (kind == "") continue
        prev = (i > 1) ? line[i-1] : ""
        if (index(s, "token-allow") > 0 || index(prev, "token-allow") > 0) continue
        gsub(/^[[:space:]]+/, "", s)
        # TAB-separated: the source text contains colons, so a colon delimiter
        # would make the report unparseable.
        printf "%s\t%d\t%s\t%s\n", FILE, i, kind, s
      }
    }
  ' "$f" >> "$TMP_HITS" || die "awk failed scanning $f"
done < "$TMP_FILES"

HIT_COUNT=$(grep -c . "$TMP_HITS" 2>/dev/null || true)
HIT_COUNT=${HIT_COUNT:-0}
COLOUR_COUNT=$(awk -F'\t' '$3=="colour"' "$TMP_HITS" 2>/dev/null | grep -c . || true)
COLOUR_COUNT=${COLOUR_COUNT:-0}

BODY=""
if [[ "$HIT_COUNT" -gt 0 ]]; then
  BODY=$(awk -F'\t' '{ printf "%-44s %-8s %s\n", $1 ":" $2, $3, $4 }' "$TMP_HITS")
  if ! $QUIET; then
    printf '\033[31m  ✗ %d raw design value%s — must come from the token module\033[0m\n' \
      "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
    printf '%s\n' "$BODY" | sed 's/^/    /'
    printf '\n'
  fi
fi

# ── Report output ─────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$HIT_COUNT" -eq 0 ]] && echo '✓ no raw design values' || echo "✗ $HIT_COUNT raw design value(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'mobile-tokens audit — %s\n' "$TIMESTAMP"
        printf 'files=%s violations=%s colour=%s\n\n' "$FILE_COUNT" "$HIT_COUNT" "$COLOUR_COUNT"
        printf '%s\n' "${BODY:-No raw design values.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Mobile Token Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files scanned** | %s |\n' "$FILE_COUNT"
        printf '| **Violations** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_No raw design values — every styled value comes from the token module._\n'; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "mobile-tokens",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "files": %s,\n  "violations": %s,\n  "colour_violations": %s,\n' "$FILE_COUNT" "$HIT_COUNT" "$COLOUR_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ No raw design values — mobile styling is token-first."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT raw design value(s) — StyleSheet values must come from the token module."
  log "  Add the token in the design-token editor, import it, and reference it here."
  log "  A genuinely structural value may carry a 'token-allow' comment with a reason."
  log ""
  exit 1
fi
