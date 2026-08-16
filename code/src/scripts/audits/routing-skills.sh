#!/usr/bin/env bash
#
# routing-skills.sh — Every skill named in routing frontmatter must exist.
#
#                     Routing frontmatter tells an agent which skills to load for a
#                     piece of work. Nothing validated the names. A `skills: [bugfix]`
#                     naming a directory that does not exist was green in every audit,
#                     in lefthook, and in CI — the skill simply never arrived, and the
#                     work proceeded without the conventions it was supposed to carry.
#                     Silence is the whole failure mode.
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
# Scope scanned:  tracked AND untracked-but-not-ignored *.md — the file you just wrote is
#                 the one most needing the check.
#                 Only the leading `---` frontmatter block is read; a `skills:` line in
#                 prose or inside a fenced example is never a routing declaration.
#
#                 THE KEY IS READ BY _lib/frontmatter-skills.sh, NOT HERE. This script
#                 used to select with /^skills:[[:space:]]*\[/, which needs the opening
#                 bracket on the SAME LINE as the key — so a Prettier-wrapped array was
#                 skipped whole and its names were never validated, while the run reported
#                 a confident count of everything else. Both selectors below (the scan and
#                 the co-variance file list) now go through the shared reader, which is the
#                 one that already handled the wrapped form.
#
# SELF-TEST. --self-test runs the resolve clause over fixtures/routing-skills/{broken,clean}
#            and asserts it separates them, with each fixture pair written in BOTH the
#            inline and the wrapped form — a parser that reads one and skips the other
#            fails it. It also asserts the co-variance clause's file selector sees a gated
#            name in the wrapped form, because that selector was the defect's second half.
#            It does NOT exercise the co-variance verdict itself: that reads copier.yml's
#            own _exclude and when: clauses, and a fixture copier.yml would drift against
#            the real one. Named in the summary rather than left for a reader to discover.
#
# Usage: routing-skills.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--path PATH] [--self-test] [--help]
#
# Exit codes:  0 = clean   1 = violation(s), or the self-test no longer separates
#              2 = script error (bad arguments, or --self-test with the fixtures missing)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
SKILLS_DIR="$PROJECT_ROOT/.claude/skills"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/routing-skills"

# shellcheck source=../_lib/frontmatter-skills.sh
source "$SCRIPT_DIR/../_lib/frontmatter-skills.sh"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""
SELF_TEST=false

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
  routing-skills.sh --self-test     Prove the parser still reads both array forms

Exit codes: 0 clean · 1 violations found (or the self-test no longer separates) · 2 script error
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --output)      OUTPUT_FORMAT="${2:-}"; shift 2 ;;
    --output-file) OUTPUT_FILE="${2:-}";   shift 2 ;;
    --path)        TARGET_PATH="${2:-}";   shift 2 ;;
    --quiet)       QUIET=true;             shift   ;;
    --self-test)   SELF_TEST=true;         shift   ;;
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
#
# The audit fixtures are excluded, as the documentation-pairing audit excludes its own: this script runs
# against the whole tree, so a fixture carrying a deliberately unresolvable name would
# fail the ordinary run rather than prove anything. They are reached only through
# --self-test, which points the same collection at them on purpose.
candidates() {
  { git ls-files -z; git ls-files -z --others --exclude-standard; } \
    | tr '\0' '\n' | sort -u | grep -E '\.md$' \
    | grep -v '^code/src/scripts/audits/fixtures/' || true
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

# Every name in a newline-separated file list, through the shared reader. Factored out
# so --self-test drives the identical code path over the fixtures rather than a second
# implementation of it — a proof of a different loop proves nothing about this one.
collect() { # $1 = newline-separated file list
  local file names_out lineno name
  violations=0
  report=""
  checked_files=0
  checked_names=0

  while IFS= read -r file; do
    [ -n "$file" ] || continue
    [ -f "$file" ] || continue

    names_out="$(frontmatter_skills "$file")"
    [ -n "$names_out" ] || continue

    checked_files=$((checked_files + 1))
    while IFS=$'\t' read -r lineno name; do
      [ -n "$name" ] || continue
      checked_names=$((checked_names + 1))
      resolves "$name" || record "$file" "$lineno" "$name"
    done <<< "$names_out"
  done <<< "$1"
}

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
# receive the line reading `when: "True"`. The template-token check is what catches it.
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

# Which files name this skill in their routing frontmatter — through the SAME shared
# reader the resolve clause uses.
#
# THIS SELECTOR WAS THE SECOND HALF OF THE WRAPPED-ARRAY BLIND SPOT DESCRIBED ABOVE, and
# only the first half was noticed. It read `head -20 | grep -E "^skills:.*<name>"`, so it was blind twice over:
# the name had to sit on the key's own line, which a Prettier-wrapped array guarantees it
# does not, and the frontmatter had to fit in twenty lines, which nothing promises. A
# gated skill named inside a wrapped array was therefore exempt from the co-variance
# clause by accident — the clause that exists precisely so this audit needs no allowlist.
#
# No pipeline into `grep -q` here, deliberately: `grep -q` exits on its first match and
# SIGPIPEs whatever feeds it, and with `pipefail` on that reads as a failed pipeline. The
# match would be discarded exactly when it was found.
files_naming_skill() { # skill [file-list] → paths, one per line
  local skill="$1" list="${2:-$FILES}" c n
  while IFS= read -r c; do
    [ -n "$c" ] || continue
    [ -f "$c" ] || continue
    while IFS=$'\t' read -r _ n; do
      if [ "$n" = "$skill" ]; then
        printf '%s\n' "$c"
        break
      fi
    done < <(frontmatter_skills "$c")
  done <<< "$list"
  return 0
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
  done < <(files_naming_skill "$skill")
}

# ── Self-test ────────────────────────────────────────────────────────────────
#
# Every probe drives collect() and files_naming_skill() — the same functions the ordinary
# run uses — over fixtures/routing-skills/. A proof of a reimplementation would prove
# nothing about the code that ships.
#
# Each fixture pair is written TWICE, once inline and once wrapped, and that is the whole
# design: a parser that reads one form and skips the other passes an inline-only proof
# with nothing to show for it. The clean pair is asserted on its NAME COUNT as well as on
# its finding count, because a skipped file and a correct file both report zero findings —
# indistinguishable from the outside, and that indistinguishability is the defect class.
#
# WHAT THIS DOES NOT COVER, stated rather than left to be discovered: the co-variance
# clause's verdict. That reads copier.yml's own _exclude list and when: chain, and a
# fixture copier.yml would be a second contract drifting against the real one. Only the
# clause's FILE SELECTOR is proved here — the half whose blindness went unnoticed.
ST_FAILS=0
ST_PROBES=0

st_fail() { ST_FAILS=$((ST_FAILS + 1)); printf '\033[31m  ✗ %s\033[0m\n' "$*" >&2; }

st_probe() { # label file expected-violations expected-name expected-names-checked
  local label="$1" file="$2" want_v="$3" want_name="$4" want_n="$5"
  ST_PROBES=$((ST_PROBES + 1))

  collect "$PROJECT_ROOT/$file"

  if [ "$violations" -ne "$want_v" ]; then
    st_fail "$label: expected $want_v finding(s), got $violations"
    return
  fi
  if [ "$checked_names" -ne "$want_n" ]; then
    st_fail "$label: read $checked_names name(s), expected $want_n — the file was parsed only in part, or skipped"
    return
  fi
  if [ -n "$want_name" ] && [[ "$report" != *"$want_name"* ]]; then
    st_fail "$label: the finding does not name \`$want_name\`"
    return
  fi
  log "  ✓ $label"
}

self_test() {
  local f wrapped_key
  bold ""
  bold "▸ routing-skills.sh --self-test"
  log ""

  [ -d "$FIXTURES_DIR/broken" ] && [ -d "$FIXTURES_DIR/clean" ] ||
    die "fixtures missing at ${FIXTURES_DIR#"$PROJECT_ROOT"/} — refusing to report a proof that never ran"

  # The wrapped fixtures only test the wrapped form for as long as they stay wrapped.
  # Prettier keeps them so because eight names exceed its print width — but that is a
  # property of the current config, not a promise, so it is asserted rather than assumed.
  for f in clean/wrapped.md broken/wrapped.md; do
    ST_PROBES=$((ST_PROBES + 1))
    wrapped_key="$(awk 'NR==1{next} /^---[[:space:]]*$/{exit} /^skills:/{print; exit}' "$FIXTURES_DIR/$f")"
    if [ "$wrapped_key" != "skills:" ]; then
      st_fail "$f is no longer wrapped (its key line reads '$wrapped_key') — a reformat has collapsed it and this proof now tests the inline form twice"
    else
      log "  ✓ $f is still wrapped across lines"
    fi
  done

  # The resolve clause, one probe per form so a failure names which one broke.
  st_probe "clean/inline.md   trips nothing"    "${FIXTURES_DIR#"$PROJECT_ROOT"/}/clean/inline.md"    0 ""                      2
  st_probe "clean/wrapped.md  trips nothing"    "${FIXTURES_DIR#"$PROJECT_ROOT"/}/clean/wrapped.md"   0 ""                      8
  st_probe "broken/inline.md  trips one"        "${FIXTURES_DIR#"$PROJECT_ROOT"/}/broken/inline.md"   1 "no-such-skill-inline"  2
  st_probe "broken/wrapped.md trips one"        "${FIXTURES_DIR#"$PROJECT_ROOT"/}/broken/wrapped.md"  1 "no-such-skill-wrapped" 8

  # The co-variance clause's file selector — the parser defect's second half.
  # clean/wrapped.md names a copier-gated skill inside a wrapped array; the selector has
  # to find it there.
  ST_PROBES=$((ST_PROBES + 1))
  f="${FIXTURES_DIR#"$PROJECT_ROOT"/}/clean/wrapped.md"
  if [ "$(files_naming_skill stack-rust "$PROJECT_ROOT/$f")" = "$PROJECT_ROOT/$f" ]; then
    log "  ✓ the co-variance selector sees a gated name inside a wrapped array"
  else
    st_fail "the co-variance selector missed \`stack-rust\` in $f — the clause that removes this audit's need for an allowlist is blind again"
  fi

  log ""
  if [ "$ST_FAILS" -eq 0 ]; then
    bold "✓ Self-test passed — $ST_PROBES probes over both array forms."
    log "  Not covered: the co-variance verdict (copier.yml's _exclude and when: chain), only its file selector."
    log ""
    return 0
  fi
  log "  the detector no longer separates the fixtures — fix the detector, never the fixtures."
  log ""
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

# ── Run ──────────────────────────────────────────────────────────────────────
collect "$FILES"
log "  checked $checked_names skill name(s) across $checked_files file(s) with routing frontmatter"

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
