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
# The search is a DENY-LIST of the phrasings these routes have been written in — the forms above,
# the map or register index named before CONTEXT.md, the index "for this register", a word between
# "no" and "board", an index deferred or postponed — never a parser of meaning: a phrasing outside
# it still reads 0 hits, and is added here, with a self-test probe, when it is found. A ROOT
# holding no .md at all is a script error (exit 2), because an empty render also reads 0 hits.
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
# Its --self-test runs under self-test-ledger.sh's crash guard (exit 2, never a red or a pass), and
# template-integrity.sh's pre-push leg runs it against every pushed commit, as CI does (21/11/2026).
#
# Requires: bash, find, perl. No network.
# Exit codes: 0 = no hit (or the self-test passed)  1 = a hit (or the self-test failed)
#             2 = script error
set -euo pipefail

PATTERN='index row.{0,80}CONTEXT\.md|CONTEXT\.md[^;.]{0,80}index row|CONTEXT\.md`?'"'"'?s (?:map |register )?index|CONTEXT\.md.{0,40}(?:map index|register index|is the index|as the index)|register'"'"'?s index.{0,40}CONTEXT\.md|CONTEXT\.md.{0,40}register'"'"'?s index|row to .{0,40}\d\d-[A-Z-]+/CONTEXT\.md|(?:map|register) index[^;.]{0,40}CONTEXT\.md|index for this (?:map|register)[^;.]{0,40}CONTEXT\.md|\bno (?:folder-level |in-tree )?index\b|\bno (?:[\w-]+ )?board\b|\bno generated index\b|index (?:is |was )?(?:deferred|postponed)|register-index work|holds no index|carries no index'
PM_PATTERN='row to .{0,40}CONTEXT\.md'
HIST='^\s*(?:doc-references:\s*template-only|(?:SUPERSEDED|UPDATED|CORRECTED|RENAMED|AMENDED)\b)'

die() { printf 'register-index-routes.sh: %s\n' "$*" >&2; exit 2; }
command -v perl >/dev/null 2>&1 || die "perl is required"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=self-test-ledger.sh
. "$SCRIPT_DIR/self-test-ledger.sh"
FX_DIR=""
# shellcheck disable=SC2329  # invoked through st_arm's EXIT guard
cleanup() { if [[ -n "$FX_DIR" ]]; then rm -rf "$FX_DIR"; fi; }
ST_FAILS=0
st_probe() { # LABEL OK — one probe's outcome, printed and recorded
  if [[ "$2" == true ]]; then printf '  ✓ %s\n' "$1"; st_record pass "$1"
  else printf '  ✗ %s\n' "$1"; st_record fail "$1"; ST_FAILS=$((ST_FAILS + 1)); fi
}

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
  local fx hits form n ok
  fx="$(mktemp -d)" || die "could not create a temporary directory"
  FX_DIR="$fx"
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
  ok=true; [[ $n -gt 0 ]] || ok=false
  st_probe "the planted fixture produces hits — 0 is never a pass" "$ok"
  for form in "[index row in \`CONTEXT.md]" "[CONTEXT.md\` as its index row]" "[CONTEXT.md\`'s index]" \
              "[register's index is this folder's \`CONTEXT.md]" "[no board]" "[row to its \`CONTEXT.md]" \
              "01/01/2026: the [index was deferred]" "updated: the [index was deferred]"; do
    ok=false; if grep -qF -- "$form" <<< "$hits"; then ok=true; fi
    st_probe "hits $form" "$ok"
  done
  ok=false; [[ $n -ne 8 ]] || ok=true
  st_probe "exactly the 8 intended forms hit: the UPDATED-marked comment and both false positives do not" "$ok"
  $ok || printf '%s hits:\n%s\n' "$n" "$hits"
  # Round 4: the plain phrasings the first forms missed, one file each so a probe reads only
  # whether its file hit, and a root holding no .md at all.
  local r4="$fx/r4" i rc
  mkdir -p "$r4/docs"
  printf '%s\n' '- The map index is this folder'"'"'s `CONTEXT.md`.' > "$r4/docs/f1.md"
  printf '%s\n' '- The register index lives in `CONTEXT.md`.' > "$r4/docs/f2.md"
  printf '%s\n' '- The index for this register is CONTEXT.md.' > "$r4/docs/f3.md"
  printf '%s\n' '- There is no kanban board for this register.' > "$r4/docs/f4.md"
  printf '%s\n' '- The index is postponed to a later story.' > "$r4/docs/f5.md"
  hits="$(search "$r4")"
  for i in "1|the map index named before CONTEXT.md" "2|the register index named before CONTEXT.md" \
           "3|the index for this register as CONTEXT.md" "4|no board with a word between" \
           "5|an index postponed"; do
    ok=false; if grep -q "^\./docs/f${i%%|*}\.md: " <<< "$hits"; then ok=true; fi
    st_probe "hits ${i#*|}" "$ok"
  done
  mkdir -p "$fx/empty-root"; rc=0
  bash "${BASH_SOURCE[0]}" "$fx/empty-root" >/dev/null 2>&1 || rc=$?
  ok=false; if [[ $rc -eq 2 ]]; then ok=true; fi
  st_probe "a root holding no .md is a script error (exit 2), never 0 hits" "$ok"
  if [[ $ST_FAILS -eq 0 ]]; then printf '✓ register-index-routes.sh --self-test passed\n'; return 0; fi
  printf '✗ register-index-routes.sh --self-test: %s failure(s) — fix the search, never the fixture\n' "$ST_FAILS"
  return 0
}

if [[ "${1:-}" == --self-test ]]; then
  st_arm cleanup
  self_test
  st_finish "$ST_FAILS"
fi
[[ $# -gt 0 ]] || die "usage: register-index-routes.sh [--self-test] ROOT..."
printf 'pattern (Perl, case-insensitive, over paragraphs): %s\n' "$PATTERN"
printf 'project-management/ only: %s\n' "$PM_PATTERN"
status=0
for root in "$@"; do
  [[ -d "$root" ]] || die "no such directory: $root"
  [[ -n "$(find "$root" -name .git -prune -o -type f -name '*.md' -print -quit)" ]] \
    || die "$root holds no .md file — an empty render is never 0 hits"
  hits="$(search "$root")"
  if [[ -n "$hits" ]]; then
    printf '::error::%s — a shipped instruction routes a register'"'"'s index to a CONTEXT.md\n%s\n' "$root" "$hits"
    status=1
  else
    printf '%s — 0 hits\n' "$root"
  fi
done
exit $status
