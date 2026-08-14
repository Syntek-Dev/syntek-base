#!/usr/bin/env bash
#
# routing-skills.sh — Every skill named in routing frontmatter must exist.
#
#                     Routing frontmatter (.claude/CLAUDE.md § 2.5) tells an agent which
#                     skills to load for a piece of work. Nothing validated the names.
#                     A `skills: [bugfix]` naming a directory that does not exist was
#                     green in every audit, in lefthook, and in CI — the skill simply
#                     never arrived, and the work proceeded without the conventions it
#                     was supposed to carry. Silence is the whole failure mode.
#
#                     One check, one rule: every name in a frontmatter `skills:` list
#                     resolves to a .claude/skills/<name>/ directory.
#
#                     STRICT BY DESIGN — no allowlist. The three copier-gated stack
#                     skills (stack-react-native, stack-rust, stack-slint) need no
#                     exemption because every file naming one is excluded on the SAME
#                     copier flag as the skill: measured exceptionless, and asserted by
#                     the gated-covariance check below so it stays that way. An audit
#                     carrying three permanent exemptions stops proving anything.
#
#                     What it CANNOT check is whether a resolving skill is the RIGHT one
#                     for that work, or whether a needed skill was omitted. Both stay
#                     reviewer judgement.
#
# Scope scanned:  tracked AND untracked-but-not-ignored *.md, matching doc-references.sh —
#                 the file you just wrote is the one most needing the check.
#                 Only the leading `---` frontmatter block is read; a `skills:` line in
#                 prose or inside a fenced example is never a routing declaration.
#
# Usage: routing-skills.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--path PATH] [--help]
#
# Exit codes:  0 = clean   1 = violation(s)   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'routing-skills.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
routing-skills.sh — Every skill named in routing frontmatter must exist

Usage:
  routing-skills.sh                 Check every eligible file
  routing-skills.sh --output md     Also write a report to audits/reports/
  routing-skills.sh --path DIR      Restrict the check to a directory or file
  routing-skills.sh --quiet         Suppress progress output

Exit codes: 0 clean · 1 violations found · 2 script error
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --output)      OUTPUT_FORMAT="${2:-}"; shift 2 ;;
    --output-file) OUTPUT_FILE="${2:-}";   shift 2 ;;
    --path)        TARGET_PATH="${2:-}";   shift 2 ;;
    --quiet)       QUIET=true;             shift   ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT" || die "cannot enter $PROJECT_ROOT"

bold ""
bold "▸ routing-skills.sh — $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Self-guarding: no skills tree means nothing to resolve against, and failing every
# file would be noise rather than signal.
if [ ! -d "$SKILLS_DIR" ]; then
  bold "✓ No .claude/skills/ directory — nothing to check."
  exit 0
fi

# ── What we scan ─────────────────────────────────────────────────────────────
candidates() {
  { git ls-files -z; git ls-files -z --others --exclude-standard; } \
    | tr '\0' '\n' | sort -u | grep -E '\.md$' || true
}

FILES="$(candidates)"
if [ -n "$TARGET_PATH" ]; then
  FILES="$(printf '%s\n' "$FILES" | grep -E "^${TARGET_PATH%/}(/|$)" || true)"
fi

# ── Collect ──────────────────────────────────────────────────────────────────
violations=0
report=""
checked_files=0
checked_names=0

record() { # file line skill
  violations=$((violations + 1))
  report+="| \`$1\` | $2 | \`$3\` |"$'\n'
  log "  $1:$2  skills: names \`$3\` — no .claude/skills/$3/"
}

# A skill resolves when .claude/skills/<name>/ is a directory. The vendored
# cloudinary-* entries are symlinked directories and resolve through -d, which is
# correct: they are loadable skills like any other.
resolves() { [ -d "$SKILLS_DIR/$1" ]; }

while IFS= read -r file; do
  [ -n "$file" ] || continue
  [ -f "$file" ] || continue

  # Frontmatter only: byte 0 must open the block, and we stop at its terminator.
  IFS= read -r first < "$file" || continue
  [ "$first" = "---" ] || continue

  line="$(awk '
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    /^skills:[[:space:]]*\[/ { print NR ":" $0; exit }
  ' "$file" 2>/dev/null || true)"

  [ -n "$line" ] || continue
  lineno="${line%%:*}"
  value="${line#*:}"

  # skills: [a, b, c] → a b c
  names="$(printf '%s\n' "$value" \
    | sed -e 's/^[^[]*\[//' -e 's/\].*$//' -e 's/,/ /g' -e "s/[\"']//g")"

  checked_files=$((checked_files + 1))
  for name in $names; do
    [ -n "$name" ] || continue
    checked_names=$((checked_names + 1))
    resolves "$name" || record "$file" "$lineno" "$name"
  done
done <<< "$FILES"

log "  checked $checked_names skill name(s) across $checked_files file(s) with routing frontmatter"

# ── Gated co-variance ────────────────────────────────────────────────────────
# The reason this audit needs no allowlist. A file naming a copier-gated skill must
# itself be excluded on the same flag, or a generated project without that surface
# ships an unresolvable routing name and this gate fires downstream — on a developer's
# machine, where it is nobody's build to fix.
covariance=0

# One flag can GUARANTEE another, and the guarantee is parsed from copier.yml rather
# than hardcoded here: INCLUDE_DESKTOP's question carries a `when:` clause conditional
# on INCLUDE_RUST, so the question is never even asked without Rust and a DESKTOP-gated
# file cannot exist in a project lacking stack-rust. Deriving it means a change to the
# gating is picked up instead of silently contradicting a constant in this script.
#
# That clause is DESCRIBED here, never quoted. This script ships, and copier renders
# every shipped file (`_templates_suffix` is empty), so a literal token written in this
# comment is not an example — it is a substitution, and a generated project would
# receive the line reading `when: "True"`. check-template-tokens.sh is what catches it.
when_flag() { # flag → the flag its question is conditional on, or empty
  awk -v q="$1:" '
    $0 ~ "^" q "[[:space:]]*$" { inq = 1; next }
    inq && /^[A-Za-z_]+:/ { exit }
    inq && /^[[:space:]]*when:/ {
      if (match($0, /INCLUDE_[A-Z_]+/)) print substr($0, RSTART, RLENGTH)
      exit
    }
  ' copier.yml 2>/dev/null || true
}

implies() { # gate want → does being gated on `gate` guarantee `want` is on?
  local g="$1" want="$2" hops=0
  while [ -n "$g" ] && [ "$hops" -lt 8 ]; do
    [ "$g" = "$want" ] && return 0
    g="$(when_flag "$g")"
    hops=$((hops + 1))
  done
  return 1
}

# Which INCLUDE_* flags exclude this path — testing the file, then each parent, because
# copier gates whole directories (`/code/workflows/13-desktop-app`) as readily as files.
gate_flags_for() { # path → flags, one per line
  local p="$1" esc
  while [ "$p" != "." ] && [ "$p" != "/" ]; do
    esc="$(printf '%s' "$p" | sed 's/[][\.*^$/]/\\&/g')"
    grep -oE "if not INCLUDE_[A-Z_]+ :>/$esc[<]" copier.yml 2>/dev/null \
      | grep -oE 'INCLUDE_[A-Z_]+' || true
    p="$(dirname "$p")"
  done | sort -u
}

check_gated() { # skill flag
  local skill="$1" flag="$2" f gf covered
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    covered=false
    while IFS= read -r gf; do
      [ -n "$gf" ] || continue
      implies "$gf" "$flag" && { covered=true; break; }
    done < <(gate_flags_for "$f")

    if [ "$covered" = false ]; then
      covariance=$((covariance + 1))
      report+="| \`$f\` | — | names \`$skill\` (**$flag**-gated) but no _exclude entry guarantees that flag |"$'\n'
      log "  $f  names \`$skill\` ($flag-gated) but carries no matching _exclude entry"
    fi
  done < <(printf '%s\n' "$FILES" | while IFS= read -r c; do
      [ -f "$c" ] || continue
      head -20 "$c" 2>/dev/null | grep -qE "^skills:.*[][, ]$skill[],[:space:]]" && printf '%s\n' "$c"
    done)
}

check_gated stack-react-native INCLUDE_MOBILE
check_gated stack-rust         INCLUDE_RUST
check_gated stack-slint        INCLUDE_DESKTOP

# ── Report ───────────────────────────────────────────────────────────────────
total=$((violations + covariance))
bold ""
if [ "$total" -eq 0 ]; then
  bold "✓ Every routing skill resolves, and every gated name co-varies with its flag."
else
  bold "✗ $total routing-skill problem(s)."
  log ""
  log "Rule: every name in a frontmatter skills: list resolves to .claude/skills/<name>/."
  log "Fix the name, create the skill, or drop it — never widen this audit. A gated"
  log "skill needs its file excluded on the same copier flag, not an exemption here."
fi

if [ -n "$OUTPUT_FORMAT" ]; then
  mkdir -p "$REPORTS_DIR"
  out="${OUTPUT_FILE:-$REPORTS_DIR/routing-skills.md}"
  {
    printf '# routing-skills\n\n'
    printf 'Unresolved names: %s\n' "$violations"
    printf 'Gated co-variance breaches: %s\n\n' "$covariance"
    if [ "$total" -gt 0 ]; then
      printf '| File | Line | Problem |\n| --- | --- | --- |\n%s' "$report"
    fi
  } > "$out"
  log "Report: $out"
fi

[ "$total" -eq 0 ] || exit 1
