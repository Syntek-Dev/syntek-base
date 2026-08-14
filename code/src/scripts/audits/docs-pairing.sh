#!/usr/bin/env bash
#
# docs-pairing.sh — Enforce the CONTEXT.md / CLAUDE.md split.
#
#                   CONTEXT.md says what is here and why it is here.
#                   CLAUDE.md says how to work here.
#
#                   The two drift in one direction: an operating rule gets written into
#                   an orientation file because it was useful on arrival, and the paired
#                   CLAUDE.md keeps its own copy in different words. Two wordings of one
#                   rule is one rule nobody can change safely.
#
#                   Checks the mechanical half of that standard. What it CANNOT check is
#                   whether the opening paragraph explains anything — a script proves a
#                   paragraph exists, only a reader can tell it says something. That row
#                   is deliberately reviewer judgement.
#
#                   Rule: code/docs/DOCUMENTATION-PAIRING.md
#
# Scope scanned:  every CONTEXT.md and CLAUDE.md tracked in the repository
#
# Usage: docs-pairing.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                        [--path PATH] [--help]
#
# Exit codes:  0 = clean (warnings do not fail)   1 = violation(s)   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'docs-pairing.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
docs-pairing.sh — Enforce the CONTEXT.md / CLAUDE.md split

Usage:
  docs-pairing.sh                Check every CONTEXT.md and CLAUDE.md
  docs-pairing.sh --output md    Also write a report
  docs-pairing.sh --path DIR     Restrict the check to a directory or file

Fail-tier checks:
  1. Pairing both ways — a CONTEXT.md has a CLAUDE.md beside it, and vice versa
  2. CLAUDE.md opens with @./CONTEXT.md (+ @./REFERENCES.md where one exists)
  3. CLAUDE.md carries a `Read order:` line
  4. CLAUDE.md carries exactly the four H2s, in order:
       Purpose (one line) · How to work here · Guardrails · Output & naming
  5. CLAUDE.md contains no directory tree — it is imported from the file that owns it
  6. CONTEXT.md carries a `## Directory Tree` fence
  7. CONTEXT.md carries no banned rule heading (DOCUMENTATION-PAIRING.md Section 5)
  8. CONTEXT.md carries no `**Claude Model:**` routing metadata
  9. Every top-level tree row is annotated, and no TODO placeholder is left behind

Warn-tier checks (reported, never fail the run):
  A. CONTEXT.md has no prose before its first heading — the "why" is probably missing

Two exceptions are honoured, not flagged (DOCUMENTATION-PAIRING.md Section 7):
  * the repository root — /CLAUDE.md is gitignored and generated
  * generated-output directories — reports/ folders under code/src/scripts/**

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/docs-pairing-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to a file or directory
  --help               Show this help

Rule: code/docs/DOCUMENTATION-PAIRING.md

Exit codes:  0 = clean   1 = violation(s) found   2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

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
  OUTPUT_FILE="$REPORTS_DIR/docs-pairing-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_FAIL=$(mktemp); TMP_WARN=$(mktemp)
trap 'rm -f "$TMP_FAIL" "$TMP_WARN"' EXIT
: > "$TMP_FAIL"; : > "$TMP_WARN"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ docs-pairing.sh — $TIMESTAMP"

fail() { printf '%s\n' "$*" >> "$TMP_FAIL"; }
warn() { printf '%s\n' "$*" >> "$TMP_WARN"; }

# A generated-output directory carries a CONTEXT.md and no CLAUDE.md by design: its only
# operating rule is "generated, never hand-edit", which the CONTEXT.md already states.
is_exempt_dir() {
  case "$1" in
    .) return 0 ;;                                   # the root — /CLAUDE.md is generated
    code/src/scripts/*reports|code/src/scripts/*reports/*) return 0 ;;
    *) return 1 ;;
  esac
}

in_scope() {
  [[ -z "$TARGET_PATH" ]] && return 0
  local p="${1#./}" t="${TARGET_PATH#./}"
  [[ "$p" == "$t" || "$p" == "${t%/}/"* ]]
}

# ── Collect the files ─────────────────────────────────────────────────────────
# Tracked plus untracked-but-not-ignored: a pair added in the working tree is in scope
# before it is staged, which is when the author still has it open.
mapfile -t CONTEXTS < <({ git ls-files '*CONTEXT.md'
                          git ls-files --others --exclude-standard '*CONTEXT.md'; } | sort -u)
mapfile -t CLAUDES  < <({ git ls-files '*CLAUDE.md'
                          git ls-files --others --exclude-standard '*CLAUDE.md'; } | sort -u)

[[ ${#CONTEXTS[@]} -gt 0 ]] || die "no CONTEXT.md files found — is this the repository root?"

# ── Check 1: pairing, both directions ─────────────────────────────────────────
for ctx in "${CONTEXTS[@]}"; do
  in_scope "$ctx" || continue
  d=$(dirname "$ctx")
  is_exempt_dir "$d" && continue
  [[ -f "$d/CLAUDE.md" ]] || fail "$ctx: no CLAUDE.md beside it — every orientation file is paired"
done

for cld in "${CLAUDES[@]}"; do
  in_scope "$cld" || continue
  d=$(dirname "$cld")
  [[ "$cld" == ".claude/CLAUDE.md" ]] && continue    # the root's operating-rules counterpart
  [[ -f "$d/CONTEXT.md" ]] || fail "$cld: no CONTEXT.md beside it — operating rules with nothing to orient"
done

# ── Checks 2–5: the CLAUDE.md shape ───────────────────────────────────────────
H2_EXPECTED='Purpose (one line)|How to work here|Guardrails|Output & naming'

for cld in "${CLAUDES[@]}"; do
  in_scope "$cld" || continue
  [[ "$cld" == ".claude/CLAUDE.md" ]] && continue    # the global file, not a folder pair
  d=$(dirname "$cld")

  first=$(grep -m1 '[^[:space:]]' "$cld" || true)
  [[ "$first" == "@./CONTEXT.md" ]] || \
    fail "$cld: does not open with \`@./CONTEXT.md\` — the tree must auto-load on navigation"

  if [[ -f "$d/REFERENCES.md" ]] && ! grep -q '^@\./REFERENCES\.md' "$cld"; then
    fail "$cld: a REFERENCES.md sits beside it but is not imported"
  fi

  grep -q '^Read order:' "$cld" || \
    fail "$cld: no \`Read order:\` line"

  actual=$(grep '^## ' "$cld" | sed 's/^## //' | paste -sd'|' -)
  [[ "$actual" == "$H2_EXPECTED" ]] || \
    fail "$cld: H2 sections are \`${actual:-none}\` — expected \`$H2_EXPECTED\`"

  grep -q '^```text' "$cld" && \
    fail "$cld: contains a directory tree — that belongs in CONTEXT.md and is imported from it"
done

# ── Checks 6–9 and the warn tier: the CONTEXT.md shape ────────────────────────
# Headings that are an instruction wearing an orientation heading. Mapping to the
# section each one moves to: code/docs/DOCUMENTATION-PAIRING.md Section 5.
BANNED='^#{2,3} +(Rules|Guardrails|Constraints|Global constraints|Requirements|Prerequisites|Quality gates|Hard gates|Standards|Conventions|Naming|Naming convention|Naming conventions|File naming|How to work here|Definition of done)\b'

for ctx in "${CONTEXTS[@]}"; do
  in_scope "$ctx" || continue

  grep -q '^```text' "$ctx" || \
    fail "$ctx: no \`## Directory Tree\` fence — orientation without a tree"

  while IFS= read -r h; do
    fail "$ctx: banned heading \`${h#\#\# }\` — an operating rule (DOCUMENTATION-PAIRING.md Section 5)"
  done < <(grep -iE "$BANNED" "$ctx" || true)

  grep -q '^\*\*Claude Model:\*\*' "$ctx" && \
    fail "$ctx: carries \`**Claude Model:**\` routing metadata — model tier is an operating rule"

  # Every top-level row says what it is. A row with a bare name is accurate and is
  # still not orientation — it is what sync-trees.sh inserts for a human to describe.
  while IFS= read -r r; do
    fail "$ctx: tree row \`$r\` has no description"
  done < <(awk '
    /^```text/ { inb = 1; next }
    inb && /^```/ { inb = 0 }
    inb && /^[├└]── / {
      row = $0
      sub(/^[├└]── /, "", row)
      name = row
      sub(/[[:space:]].*$/, "", name)
      rest = substr(row, length(name) + 1)
      gsub(/[[:space:]]/, "", rest)
      if (rest == "") print name
    }' "$ctx" || true)

  if grep -qE '[←→][[:space:]]*TODO' "$ctx"; then
    fail "$ctx: a tree row still carries a TODO annotation — describe it before committing"
  fi

  # Warn tier: prose before the first heading is where the "why" normally lives.
  # Between the H1 title and the first H2. The metadata header lines are not prose.
  awk '
    /^# /  { seen_h1 = 1; next }
    !seen_h1 { next }
    /^## / { exit }
    /^\*\*(Last Updated|Claude Model|MCP Servers|Version|Maintained By)/ { next }
    /[^[:space:]]/ { found = 1; exit }
    END { exit (found ? 0 : 1) }
  ' "$ctx" || warn "$ctx: no prose between the title and the first section — is the \"why\" recorded?"
done

# ── Report ────────────────────────────────────────────────────────────────────
FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(grep -c . "$TMP_WARN" || true); WARN_COUNT=${WARN_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
WARN_BODY="$(cat "$TMP_WARN")"

log "  checked ${#CONTEXTS[@]} CONTEXT.md and ${#CLAUDES[@]} CLAUDE.md files"
log ""

if [[ "$FAIL_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d violation(s)\033[0m\n' "$FAIL_COUNT"
  printf '%s\n\n' "$FAIL_BODY" | sed 's/^/    /'
fi
if [[ "$WARN_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[33m  ! %d warning(s)\033[0m\n' "$WARN_COUNT"
  printf '%s\n\n' "$WARN_BODY" | sed 's/^/    /'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$FAIL_COUNT" -eq 0 ]] && echo '✓ split intact' || echo "✗ $FAIL_COUNT violation(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'docs-pairing audit — %s\n' "$TIMESTAMP"
        printf 'violations=%s warnings=%s\n\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '%s\n' "${FAIL_BODY:-No violations.}"
        printf '\n%s\n' "${WARN_BODY:-No warnings.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# CONTEXT.md / CLAUDE.md Pairing Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Files** | %s CONTEXT.md · %s CLAUDE.md |\n' "${#CONTEXTS[@]}" "${#CLAUDES[@]}"
        printf '| **Violations** | %s |\n' "$FAIL_COUNT"
        printf '| **Warnings** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '## Violations\n\n```text\n%s\n```\n\n' "$FAIL_BODY"
        else printf '_Every pair is complete and correctly shaped._\n\n'; fi
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '## Warnings\n\n```text\n%s\n```\n' "$WARN_BODY"; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "docs-pairing",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "context_files": %s,\n  "claude_files": %s,\n' "${#CONTEXTS[@]}" "${#CLAUDES[@]}"
        printf '  "violations": %s,\n  "warnings": %s,\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$FAIL_COUNT" -eq 0 ]]; then
  SUFFIX=""
  [[ "$WARN_COUNT" -gt 0 ]] && SUFFIX=" — $WARN_COUNT warning(s) to answer"
  bold "✓ CONTEXT.md / CLAUDE.md split intact${SUFFIX}."
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT violation(s) — see code/docs/DOCUMENTATION-PAIRING.md."
  log ""
  exit 1
fi
