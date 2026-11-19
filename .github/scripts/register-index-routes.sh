#!/usr/bin/env bash
# SC2016: the Perl program and the fixture lines are single-quoted on purpose — nothing in them is
# for the shell to expand.
# shellcheck disable=SC2016
#
# register-index-routes.sh — No shipped instruction may route a register's index to a CONTEXT.md.
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd. audit-template.yml [3/4] runs it over each
# rendered project, after --self-test.
#
# A register's index is its generated *-BOARD.md, so no instruction in a generated project may
# still name a CONTEXT.md as a register's index, nor say a register has no index, no board, or
# that its index is deferred. The text is read as PARAGRAPHS, not lines, because the phrases this
# hunts wrap across line breaks in the prose that carries them. Both orders are hunted — "index
# row in CONTEXT.md" and "CONTEXT.md as its index row" — and the possessives ("CONTEXT.md's
# index", "the register's index is … CONTEXT.md"). The bare "row to … CONTEXT.md", with no
# numbered-folder prefix, is a second pattern read only under project-management/: outside it the
# same words are the ordinary "add the script's row to CONTEXT.md" of a script or tag registry.
#
# A dated HTML comment is skipped only when it marks itself historical: its text OPENS with
# `doc-references: template-only` or one of SUPERSEDED, UPDATED, CORRECTED, RENAMED or AMENDED,
# in capitals. A marker word anywhere else in the comment exempts nothing (narrowed 19/11/2026:
# a live instruction could hide in any dated comment that happened to say "updated").
#
# --self-test plants every intended form, a marked dated comment and the recorded false positives
# in a fixture tree, and requires exactly the intended forms to hit — 0 hits on the planted
# fixture is a failure, never a pass, because a broken pattern also finds nothing.
#
# Usage: register-index-routes.sh [--self-test] ROOT...
#
# Requires: bash, find, perl. No network.
# Exit codes: 0 = no hit (or the self-test passed)  1 = a hit (or the self-test failed)
#             2 = script error
set -euo pipefail

PATTERN='index row.{0,80}CONTEXT\.md|CONTEXT\.md[^;.]{0,80}index row|CONTEXT\.md`?'"'"'?s (?:map |register )?index|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|register'"'"'?s index.{0,40}CONTEXT\.md|CONTEXT\.md.{0,40}register'"'"'?s index|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|\bno (?:board|generated index)\b|index (?:is |was )?deferred|register-index work|holds no index|carries no index'
PM_PATTERN='row to .{0,40}CONTEXT\.md'
HIST='^\s*(?:doc-references:\s*template-only|(?:SUPERSEDED|UPDATED|CORRECTED|RENAMED|AMENDED)\b)'

die() { printf 'register-index-routes.sh: %s\n' "$*" >&2; exit 2; }
command -v perl >/dev/null 2>&1 || die "perl is required"

# search ROOT — print one line per hit, `<file>: ...<context>[<match>]`, paths relative to ROOT.
search() {
  (cd "$1" && find . -name .git -prune -o -type f -name '*.md' -print0 | sort -z |
    xargs -0 -r perl -e '
      my $re = shift @ARGV; $re = qr/$re/i;
      my $pm = shift @ARGV; $pm = qr/$pm/i;
      my $hist = shift @ARGV; $hist = qr/$hist/;
      for my $f (@ARGV) {
        open my $fh, "<", $f or next; local $/; my $t = <$fh>; close $fh;
        $t =~ s{(<!--(.*?)-->)}{ my ($all, $in) = ($1, $2); ($in =~ m{\b\d\d/\d\d/\d{4}\b} && $in =~ $hist) ? "" : $all }gse;
        my $in_pm = $f =~ m{(?:^|/)project-management/};
        for my $p (split /\n[ \t]*\n/, $t) {
          (my $j = $p) =~ s/\s*\n\s*/ /g;
          while ($j =~ /(.{0,80})($re)/g) { print "$f: ...$1\[$2]\n"; }
          next unless $in_pm;
          while ($j =~ /(.{0,80})($pm)/g) { print "$f: ...$1\[$2]\n"; }
        }
      }' "$PATTERN" "$PM_PATTERN" "$HIST")
}

self_test() {
  local fx fails=0 hits form n
  fx="$(mktemp -d)" || die "could not create a temporary directory"
  # shellcheck disable=SC2064
  trap "rm -rf '$fx'" EXIT
  mkdir -p "$fx/project-management/src/01-FEATURE-MAPS" "$fx/code/src/scripts/audits" "$fx/.claude/skills"
  # The intended forms, one paragraph each, every one of which must hit.
  cat > "$fx/project-management/src/01-FEATURE-MAPS/CLAUDE.md" <<'EOF'
- Charting a map: give it an index row in `CONTEXT.md` before it is saved.

- Charting a map: add the map to `CONTEXT.md` as its index row.

- Then the `CONTEXT.md`'s index carries the map.

- The register's index is this folder's `CONTEXT.md`.

- There is no board for this register.

- Add the map's row to its `CONTEXT.md`.

<!-- 01/01/2026: the index was deferred to a later story. -->

<!-- 01/01/2026, updated: the index was deferred. -->

<!-- UPDATED 01/01/2026: the index was deferred until a board existed; it is a board now. -->
EOF
  # The recorded false positives, which must not hit.
  printf '%s\n' '- Adding a script: add the row to `CONTEXT.md` beside it.' \
    > "$fx/code/src/scripts/audits/CLAUDE.md"
  printf '%s\n' '- Each skill takes an index row in the roster table.' > "$fx/.claude/skills/CONTEXT.md"

  hits="$(search "$fx")"
  n=0; [[ -z "$hits" ]] || n="$(grep -c . <<< "$hits")"
  if [[ $n -eq 0 ]]; then
    printf '  ✗ the planted fixture produced 0 hits — the pattern is broken, and 0 is never a pass\n'
    fails=$((fails + 1))
  fi
  for form in "[index row in \`CONTEXT.md]" "[CONTEXT.md\` as its index row]" "[CONTEXT.md\`'s index]" \
              "[register's index is this folder's \`CONTEXT.md]" "[no board]" "[row to its \`CONTEXT.md]" \
              "01/01/2026: the [index was deferred]" "updated: the [index was deferred]"; do
    if grep -qF -- "$form" <<< "$hits"; then printf '  ✓ hits %s\n' "$form"
    else printf '  ✗ misses %s\n' "$form"; fails=$((fails + 1)); fi
  done
  if [[ $n -ne 8 ]]; then
    printf '  ✗ %s hits, not the 8 intended forms — a marked comment or a false positive hit:\n%s\n' "$n" "$hits"
    fails=$((fails + 1))
  else
    printf '  ✓ exactly the 8 intended forms hit: the UPDATED-marked comment and both false positives do not\n'
  fi
  if [[ $fails -eq 0 ]]; then printf '✓ register-index-routes.sh --self-test passed\n'; return 0; fi
  printf '✗ register-index-routes.sh --self-test: %s failure(s) — fix the search, never the fixture\n' "$fails"
  return 1
}

if [[ "${1:-}" == --self-test ]]; then
  self_test
  exit $?
fi
[[ $# -gt 0 ]] || die "usage: register-index-routes.sh [--self-test] ROOT..."
printf 'pattern (Perl, case-insensitive, over paragraphs): %s\n' "$PATTERN"
printf 'project-management/ only: %s\n' "$PM_PATTERN"
status=0
for root in "$@"; do
  [[ -d "$root" ]] || die "no such directory: $root"
  hits="$(search "$root")"
  if [[ -n "$hits" ]]; then
    printf '::error::%s — a shipped instruction routes a register'"'"'s index to a CONTEXT.md\n%s\n' "$root" "$hits"
    status=1
  else
    printf '%s — 0 hits\n' "$root"
  fi
done
exit $status
