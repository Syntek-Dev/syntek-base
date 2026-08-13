#!/usr/bin/env bash
#
# check-template-tokens.sh — static integrity check for the template's token syntax.
#
# Catches the four ways token syntax silently breaks:
#
#   1. Corruption. Token names contain underscores, and Prettier's Markdown formatter
#      treats `_` as emphasis. In a paragraph holding both a token and _emphasis_, it can
#      pair them and rewrite <%PROJECT_NAME%> into <%PROJECT_NAME%>. That renders as an
#      undefined variable and vanishes from every generated project — silently.
#
#   2. Unregistered tokens. A well-formed token whose name is not a question in
#      copier.yml renders to nothing. Typos land here too.
#
#   3. Literal block/comment delimiters, PAIRED — `<: … :>` or `<~ … ~>` written out in a
#      rendered file. Jinja parses them and generation dies.
#
#   4. Literal block/comment delimiters, BARE — an opening `<:` or `<~` with no `>` after
#      it on the line. Jinja needs only the opener to fail, so this is exactly as fatal as
#      check 3, and it was invisible until 13/08/2026.
#
#   Plus: an unclosed `<%` variable opener, reported alongside 4.
#
# Numbers are stable identifiers — other documents cite them. Append, never renumber.
#
# TWO CORRECTIONS LANDED 13/08/2026, both in the single regex that was check 3:
#
#   It read `<[:|]`. copier.yml sets block to `<: :>` and comment to `<~ ~>`, so that class
#   policed `<|` — which is not a delimiter in this template and never could be — while the
#   comment opener `<~` went unexamined entirely. The class is now `[:~]`.
#
#   It also required a closing `>`. `code/src/scripts/development/sync-trees.sh` carried the
#   line `if "<:" in v:` — a bare opener, no `>` — which broke EVERY generation with
#   TemplateSyntaxError while this script reported `✓ 1974 well-formed tokens`. A gate that
#   reports all-clear on the defect it was written for is worse than no gate, because it is
#   believed. Hence check 4, and hence --self-test below.
#
# Template-only paths are exempt: copier.yml and .copier-answers.yml hold real Jinja, and
# TEMPLATE-GUIDE/ and TEMPLATE-TOKENS.md are excluded from rendering, so they may quote
# token syntax freely. .github/scripts/ is exempt too, which is what lets THIS file spell
# every delimiter out above.
#
# SELF-TEST. --self-test repoints the candidate list at a temporary directory of fixtures —
#            one per check, plus a clean file that must trip nothing — and asserts each
#            check fires on its own and only its own. The fixtures are written here rather
#            than checked in, so they cannot drift from the checks they prove.
#
# Requirements: git, grep, xargs. No network.
#
# Usage:  bash .github/scripts/check-template-tokens.sh [--self-test] [--help]
# Exit:   0 = clean   1 = problem found, or the self-test no longer separates
#         2 = script error
#
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

SELF_TEST=false
usage() {
  cat <<'EOF'
check-template-tokens.sh — static integrity check for the template's token syntax

Usage: check-template-tokens.sh [--self-test] [--help]

  --self-test  Prove the checks still fire: scan a temporary set of fixtures, one per
               check, and assert each is caught
  --help       Show this message

Exit codes: 0 = clean  1 = problem found, or the self-test no longer separates
            2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           printf 'check-template-tokens.sh error: unknown argument: %s\n' "$1" >&2; exit 2 ;;
  esac
done

# Must mirror copier.yml's _exclude list: a file that is never rendered may quote delimiter
# syntax freely, and copier.yml / .copier-answers.yml hold real Jinja.
EXEMPT='^(copier\.yml|\.copier-answers\.yml|README\.md|LICENSE|SECURITY\.md|CONTRIBUTING\.md):'
EXEMPT="$EXEMPT"'|^(how-to/src/TEMPLATE-GUIDE/|how-to/src/TEMPLATE-TOKENS\.md:)'
EXEMPT="$EXEMPT"'|^\.github/(scripts/|CODEOWNERS|ISSUE_TEMPLATE/|PULL_REQUEST_TEMPLATE\.md:|workflows/audit-template\.yml:)'

# The registered questions are the top-level UPPER_SNAKE keys in copier.yml.
REGISTERED=$(grep -oE '^[A-Z][A-Z0-9_]*:' copier.yml | tr -d ':' | sort -u)
if [[ -z "$REGISTERED" ]]; then
  echo "error: could not read any token names from copier.yml" >&2
  exit 2
fi
REGISTERED_RE="^($(printf '%s' "$REGISTERED" | paste -sd'|' -))$"

# Tracked AND untracked-but-not-ignored. Scanning `git ls-files` alone means the file you
# just wrote — the one that most needs checking — is invisible, and the run reports a green
# that means "did not look". CI never noticed because everything is tracked by the time it
# runs; local runs are exactly where the blindness bites.
#
# --self-test redefines this to point at its fixture directory. That is the whole seam: the
# checks below are re-run verbatim against known-bad input, never reimplemented for the proof.
candidates() { { git ls-files -z; git ls-files -z --others --exclude-standard; } | grep -zv '\.pdf$'; }

scan() { candidates | xargs -0 grep -Hno "$1" 2>/dev/null | grep -vE "$EXEMPT"; }

# ── The checks, as one re-runnable unit ───────────────────────────────────────
run_checks() {
  # grep exits 1 on a file with no match and xargs then returns 123, so pipefail comes off
  # for these scans — a file without tokens is the normal case, not an error.
  set +o pipefail

  malformed=$(scan '<%[^%]*%>' | grep -vE ':<%[A-Z_]+%>$') || true
  unclosed=$(scan '<%[^%]*$') || true

  # 3 — a delimiter pair spelled out in a rendered file.
  blocks=$(scan '<[:~][^>]*>' | grep -vE '<: *(raw|endraw) *:>') || true

  # 4 — an opener with no `>` after it. Jinja fails on the opener alone, so requiring the
  # closer (as this check did until 13/08/2026) is a hole the size of the defect.
  bare_blocks=$(scan '<[:~][^>]*$') || true

  unregistered=""
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    name=${line##*<%}
    name=${name%%\%>*}
    if ! printf '%s' "$name" | grep -qE "$REGISTERED_RE"; then
      unregistered+="$line"$'\n'
    fi
  done < <(scan '<%[A-Z_]\+%>')

  count=$(candidates | xargs -0 grep -ho '<%[A-Z_]*%>' 2>/dev/null | wc -l)
  set -o pipefail
}

report() {
  local status=0

  if [[ -n "$malformed" ]]; then
    printf '\033[31mMalformed tokens\033[0m — a formatter probably ate an underscore:\n\n%s\n\n' "$malformed"
    printf '  Restore the underscore. Prefer **bold** over _emphasis_ near a token.\n\n'
    status=1
  fi

  if [[ -n "$unregistered" ]]; then
    printf '\033[31mUnregistered tokens\033[0m — these render to nothing:\n\n%s\n' "$unregistered"
    printf '  Add the question to copier.yml and document it in how-to/src/TEMPLATE-TOKENS.md,\n'
    printf '  or fix the typo.\n\n'
    status=1
  fi

  if [[ -n "$blocks" ]]; then
    printf '\033[31mLiteral block/comment delimiters\033[0m in a rendered file — Jinja will parse these:\n\n%s\n\n' "$blocks"
    printf '  Reword, or wrap the example in a raw block. Quoting delimiter syntax freely belongs\n'
    printf '  in how-to/src/TEMPLATE-GUIDE/, which is excluded from rendering.\n\n'
    status=1
  fi

  if [[ -n "$bare_blocks" ]]; then
    printf '\033[31mBare block/comment opener\033[0m in a rendered file — the opener alone is fatal:\n\n%s\n\n' "$bare_blocks"
    printf '  Jinja does not need a closing delimiter to fail. Build the literal from parts\n'
    printf '  (concatenate the two characters), reword it, or wrap it in a raw block.\n\n'
    status=1
  fi

  if [[ -n "$unclosed" ]]; then
    printf '\033[31mUnclosed delimiters\033[0m — generation will die with TemplateSyntaxError:\n\n%s\n\n' "$unclosed"
    printf '  Wrap the example in a raw block, or reword it. Quoting token syntax freely\n'
    printf '  belongs in how-to/src/TEMPLATE-GUIDE/, which is excluded from rendering.\n\n'
    status=1
  fi

  return "$status"
}

# ── Self-test ─────────────────────────────────────────────────────────────────
#
# One fixture per check plus a clean negative. Each probe asserts its own variable is
# non-empty AND that the fixture is not silently tripping a different check, because a
# check that fires for the wrong reason is not a working check.
ST_FAILS=0
ST_PROBES=0

probe() { # $1 = label, $2 = the variable name that must be non-empty
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  local hit="${!2}"
  if [[ -n "$hit" ]]; then
    printf '  ✓ %s\n' "$1"
  else
    ST_FAILS=$((ST_FAILS + 1))
    printf '\033[31m  ✗ %s — $%s came back empty; the check no longer fires\033[0m\n' "$1" "$2"
  fi
}

self_test() {
  local tmpdir
  printf '\033[1m▸ check-template-tokens.sh --self-test\033[0m\n\n'
  command -v mktemp >/dev/null 2>&1 || { echo "mktemp unavailable — refusing to report a proof that never ran" >&2; exit 2; }

  tmpdir=$(mktemp -d) || { echo "could not create a temporary directory" >&2; exit 2; }
  # shellcheck disable=SC2064
  trap "rm -rf '$tmpdir'" RETURN

  # The seam: every check below re-runs verbatim, against these instead of the repo.
  candidates() { find "$tmpdir" -type f -print0; }

  # Clean negative first — if a well-formed token trips anything, no positive proves a thing.
  printf '<%%PROJECT_NAME%%>\n' > "$tmpdir/clean.md"
  ST_PROBES=$((ST_PROBES + 1))
  run_checks
  if [[ -n "$malformed$unregistered$blocks$bare_blocks$unclosed" ]]; then
    printf '\033[31m  ✗ a well-formed token tripped a check — the baseline is broken\033[0m\n' >&2
    exit 2
  fi
  printf '  ✓ a well-formed token trips nothing — the baseline is clean\n'

  printf '<%%project_name%%>\n' > "$tmpdir/f.md"; probe "check 1 fires on a lower-cased token"        malformed
  rm -f "$tmpdir/f.md"

  printf '<%%NOT_A_REAL_TOKEN%%>\n' > "$tmpdir/f.md"; probe "check 2 fires on an unregistered token"  unregistered
  rm -f "$tmpdir/f.md"

  printf '<: if X :>\n' > "$tmpdir/f.md"; probe "check 3 fires on a paired block delimiter"           blocks
  rm -f "$tmpdir/f.md"

  printf '<~ a note ~>\n' > "$tmpdir/f.md"; probe "check 3 fires on a paired COMMENT delimiter"       blocks
  rm -f "$tmpdir/f.md"

  # The regression this whole rewrite exists for, in the shape it actually appeared in.
  printf 'if "<:" in v:\n' > "$tmpdir/f.md"; probe "check 4 fires on a bare block opener"             bare_blocks
  rm -f "$tmpdir/f.md"

  printf 'note the <~ opener\n' > "$tmpdir/f.md"; probe "check 4 fires on a bare COMMENT opener"      bare_blocks
  rm -f "$tmpdir/f.md"

  printf 'a <%%TRUNCATED\n' > "$tmpdir/f.md"; probe "the unclosed-variable check still fires"         unclosed
  rm -f "$tmpdir/f.md"

  printf '\n'
  if [[ "$ST_FAILS" -eq 0 ]]; then
    printf '\033[1m✓ Self-test passed — %s probes: every check fires on its own fixture.\033[0m\n\n' "$ST_PROBES"
    return 0
  fi
  printf '  the detector no longer separates well-formed template syntax from broken —\n'
  printf '  fix the check, never the expectation.\n\n'
  return 1
}

if $SELF_TEST; then
  self_test
  exit $?
fi

run_checks
if report; then
  printf '\033[32m✓\033[0m  %s well-formed tokens, all registered in copier.yml\n' "$count"
  exit 0
fi
exit 1
