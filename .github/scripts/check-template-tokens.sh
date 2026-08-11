#!/usr/bin/env bash
#
# check-template-tokens.sh — static integrity check for the template's token syntax.
#
# Catches the three ways token syntax silently breaks:
#
#   1. Corruption. Token names contain underscores, and Prettier's Markdown formatter
#      treats `_` as emphasis. In a paragraph holding both a token and _emphasis_, it can
#      pair them and rewrite <%PROJECT_NAME%> into <%PROJECT_NAME%>. That renders as an
#      undefined variable and vanishes from every generated project — silently.
#
#   2. Unregistered tokens. A well-formed token whose name is not a question in
#      copier.yml renders to nothing. Typos land here too.
#
#   3. Unclosed delimiters. A rendered file that opens `<%` without closing it makes
#      Jinja fail the whole generation with TemplateSyntaxError.
#
# Template-only paths are exempt: copier.yml and .copier-answers.yml hold real Jinja, and
# TEMPLATE-GUIDE/ and TEMPLATE-TOKENS.md are excluded from rendering, so they may quote
# token syntax freely.
#
# Usage:  bash .github/scripts/check-template-tokens.sh
# Exit:   0 = clean   1 = problem found
#
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# Must mirror copier.yml's _exclude list: a file that is never rendered may quote delimiter
# syntax freely, and copier.yml / .copier-answers.yml hold real Jinja.
EXEMPT='^(copier\.yml|\.copier-answers\.yml|README\.md|LICENSE|SECURITY\.md|CONTRIBUTING\.md):'
EXEMPT="$EXEMPT"'|^(how-to/src/TEMPLATE-GUIDE/|how-to/src/TEMPLATE-TOKENS\.md:)'
EXEMPT="$EXEMPT"'|^\.github/(scripts/|CODEOWNERS|ISSUE_TEMPLATE/|PULL_REQUEST_TEMPLATE\.md:|workflows/audit-template\.yml:)'

# The registered questions are the top-level UPPER_SNAKE keys in copier.yml.
REGISTERED=$(grep -oE '^[A-Z][A-Z0-9_]*:' copier.yml | tr -d ':' | sort -u)
if [[ -z "$REGISTERED" ]]; then
  echo "error: could not read any token names from copier.yml" >&2
  exit 1
fi
REGISTERED_RE="^($(printf '%s' "$REGISTERED" | paste -sd'|' -))$"

# grep exits 1 on a file with no match and xargs then returns 123, so pipefail comes off
# for these scans — a file without tokens is the normal case, not an error.
set +o pipefail

# Tracked AND untracked-but-not-ignored. Scanning `git ls-files` alone means the file you
# just wrote — the one that most needs checking — is invisible, and the run reports a green
# that means "did not look". CI never noticed because everything is tracked by the time it
# runs; local runs are exactly where the blindness bites.
candidates() { { git ls-files -z; git ls-files -z --others --exclude-standard; } | grep -zv '\.pdf$'; }

scan() { candidates | xargs -0 grep -Hno "$1" 2>/dev/null | grep -vE "$EXEMPT"; }

malformed=$(scan '<%[^%]*%>' | grep -vE ':<%[A-Z_]+%>$') || true
unclosed=$(scan '<%[^%]*$') || true

# Block and comment delimiters written literally in a rendered file are just as fatal as a
# broken variable — Jinja parses them and generation dies. Deliberate raw blocks are fine.
blocks=$(scan '<[:|][^>]*>' | grep -vE '<: *(raw|endraw) *:>') || true

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

status=0

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

if [[ -n "$unclosed" ]]; then
  printf '\033[31mUnclosed delimiters\033[0m — generation will die with TemplateSyntaxError:\n\n%s\n\n' "$unclosed"
  printf '  Wrap the example in a raw block, or reword it. Quoting token syntax freely\n'
  printf '  belongs in how-to/src/TEMPLATE-GUIDE/, which is excluded from rendering.\n\n'
  status=1
fi

if [[ "$status" -eq 0 ]]; then
  printf '\033[32m✓\033[0m  %s well-formed tokens, all registered in copier.yml\n' "$count"
fi

exit "$status"
