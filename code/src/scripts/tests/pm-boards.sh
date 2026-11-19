#!/usr/bin/env bash
# SC2016: the `bash -c '…' _ args` predicates expand their positional parameters in the child, by
# design. SC2329: predicates are invoked indirectly, through check(), which shellcheck cannot see.
# shellcheck disable=SC2016,SC2329
#
# pm-boards.sh — Probes for the PM board generator and the archive command, run on a fixture.
#
# Proves project-management/src/00-ASSETS/scripts/pm-board.sh, pm-archive.sh and the pm-lib.sh
# both source, for the three record registers — 15-DECISIONS (ADRs), 20-FINDINGS and 21-BUGS —
# beside the five status registers they already index. The probe body lives here, never in a
# workflow (.github/workflows/pm-boards.yml only calls this script).
#
# The fixture is SYNTHETIC: a `git init` in a `mktemp -d` directory holding the eight register
# folders, a handful of invented records, and COPIES of the three scripts (never a symlink), so
# pm-archive.sh's `git mv` and pm-board.sh's frozen-archive check run against a history of their
# own. Nothing in it is a path back into this checkout, and no `.env.*` file is read.
#
# What it asserts:
#   render     --write writes DECISIONS-BOARD.md, FINDINGS-BOARD.md and BUGS-BOARD.md; the
#              columns run in each vocabulary's lifecycle order; each board states its row
#              ordering in its opening line; titles come from the H1 with the record prefix cut.
#   instances  Every BUG-*.md bar BUG-US000-TEMPLATE.md is a row — the cross-cutting
#              BUG-<DESCRIPTOR>-DD-MM-YYYY.md fallback, and a name merely containing TEMPLATE,
#              included. The templates are excluded by their exact names.
#   tail       The decisions board carries Supersedes and Superseded by, read from each ADR's
#              own two lines; --warn names a supersession that is not cross-referenced back.
#   archive    pm-archive.sh <ID> archives an ADR only from Superseded or Deprecated, a findings
#              record only from Resolved, a bug only from Verified, and refuses any other status
#              with nothing moved; --check then passes, and fails on an edit to an archived file;
#              an ADR naming an archived ADR raises no back-link warning, archive/ being frozen.
#   chains     --warn names an ADR superseding itself, a supersession cycle, and a successor
#              named by an ADR whose status is not Superseded.
#   masked     A status or supersession line inside a fenced code block or an HTML comment is
#              never read: a decoy Deprecated above the real Accepted line leaves the board
#              filing Accepted, and pm-archive.sh --dry-run refusing.
#   staged     --boards-for names the record boards a status edit moves.
#   check      --check exits 1, naming the item, on a supersession chain that does not walk
#              and on a record register's Unrecognised row; --warn stays exit 0.
#   strays     --check fails on a .md (any case) in a boarded folder or its archive/ that is no
#              instance, template, CONTEXT.md/CLAUDE.md pair or board — 02-STORIES/CUT-PLAN.md
#              excepted — naming each, and on any .md in a subfolder other than archive/ itself.
#   successors --check fails on an ADR claiming to supersede an archived ADR that already names a
#              different successor.
#   frozen     --check fails on a bare archive/ or ../ added to an archived file's prose, and
#              still admits pm-archive.sh's rewrite of a path inside one.
#   templates  only the shipped template names (…-US000-TEMPLATE, …-000-TEMPLATE, …-00-TEMPLATE,
#              US000-TEMPLATE) are templates: a record whose descriptor holds TEMPLATE is a row,
#              and pm-archive.sh rewrites the paths it carries.
#
# Usage: pm-boards.sh [--keep] [--help]
#   --keep   Leave the fixture directory in place and print its path.
#
# Requires: bash, git, python3 (stdlib only). No network, no Docker.
# Exit codes: 0 = every probe passed  1 = a probe failed  2 = script error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PM_SCRIPTS="$PROJECT_ROOT/project-management/src/00-ASSETS/scripts"

KEEP=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --keep) KEEP=true; shift ;;
    --help|-h) sed -n '6,55p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) printf 'pm-boards.sh: unknown argument %s\n' "$1" >&2; exit 2 ;;
  esac
done
for tool in git python3; do
  command -v "$tool" >/dev/null 2>&1 || { echo "pm-boards.sh: $tool not found" >&2; exit 2; }
done

FX="$(mktemp -d)"
cleanup() { if $KEEP; then echo "fixture kept: $FX"; else rm -rf "$FX"; fi; }
trap cleanup EXIT
SRC="$FX/project-management/src"
FAILS=0
PASSES=0

pass() { PASSES=$((PASSES + 1)); printf '  \033[32m✓\033[0m %s\n' "$1"; }
fail() { FAILS=$((FAILS + 1)); printf '  \033[31m✗\033[0m %s\n' "$1"; }
check() { local label="$1"; shift; if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi; }
fgit() { git -C "$FX" -c user.name=probe -c user.email=probe@example.invalid -c core.hooksPath=/dev/null "$@"; }
board() { bash "$SRC/00-ASSETS/scripts/pm-board.sh" "$@"; }
archive() { bash "$SRC/00-ASSETS/scripts/pm-archive.sh" "$@"; }

# ── The fixture ───────────────────────────────────────────────────────────────

adr() {  # adr NAME TITLE STATUS SUPERSEDES SUPERSEDED_BY
  local sup="$4" by="$5" dir="project-management/src/15-DECISIONS"
  [[ "$sup" == None ]] || sup="\`$dir/$sup.md\`"
  [[ "$by" == None ]] || by="\`$dir/$by.md\`"
  printf '# %s: %s\n\n**Status:** %s\n**Status note:** fixture\n**Date:** 01/01/2026\n**Supersedes:** %s\n**Superseded by:** %s\n\n## Decision\n\nA fixture record.\n' \
    "$(cut -d- -f1-2 <<< "$1")" "$2" "$3" "$sup" "$by" > "$SRC/15-DECISIONS/$1.md"
}

finding() {  # finding NAME TITLE STATUS
  printf '# Findings — %s %s\n\n**Last Updated**: 01/01/2026 · **Story**: %s\n**Status:** %s\n\n## Findings\n' \
    "$(cut -d- -f2 <<< "$1")" "$2" "$(cut -d- -f2 <<< "$1")" "$3" > "$SRC/20-FINDINGS/$1.md"
}

bug() {  # bug NAME TITLE STATUS
  printf '# BUG: %s\n\n| Field | Value |\n| ----- | ----- |\n| **Severity** | Low |\n\n**Status:** %s\n\n## 1. Summary\n' \
    "$2" "$3" > "$SRC/21-BUGS/$1.md"
}

masked_adr() {  # masked_adr NAME FORM — a decoy Deprecated status inside FORM (fence|comment), then the real Accepted line
  local open close decoy="project-management/src/15-DECISIONS/ADR-US001-NEW-WAY-02-01-2026"
  if [[ "$2" == fence ]]; then open='```text'; close='```'; else open='<!--'; close='-->'; fi
  printf '# %s: A decision quoting another header\n\n%s\n**Status:** Deprecated\n**Superseded by:** `%s.md`\n%s\n\n**Status:** Accepted\n**Status note:** fixture\n**Date:** 01/01/2026\n**Supersedes:** None\n**Superseded by:** None\n\n## Decision\n\nA fixture record.\n' \
    "$(cut -d- -f1-2 <<< "$1")" "$open" "$decoy" "$close" > "$SRC/15-DECISIONS/$1.md"
}

build_fixture() {
  local d
  for d in 00-ASSETS/scripts 01-FEATURE-MAPS 02-STORIES 03-SPRINTS 15-DECISIONS 16-SPRINT-PLANS \
           17-STORY-PLANS 20-FINDINGS 21-BUGS; do
    mkdir -p "$SRC/$d"
  done
  cp "$PM_SCRIPTS/pm-board.sh" "$PM_SCRIPTS/pm-archive.sh" "$PM_SCRIPTS/pm-lib.sh" "$SRC/00-ASSETS/scripts/"
  adr ADR-US000-TEMPLATE "[Decision Title]" Proposed None None
  adr ADR-US001-OLD-WAY-01-01-2026 "The old way" Superseded None ADR-US001-NEW-WAY-02-01-2026
  adr ADR-US001-NEW-WAY-02-01-2026 "The new way" Accepted ADR-US001-OLD-WAY-01-01-2026 None
  adr ADR-US002-DRAFT-03-01-2026 "A draft decision" Proposed None None
  adr ADR-US003-RETIRED-04-01-2026 "A retired decision" Deprecated None None
  masked_adr ADR-US005-FENCED-STATUS-06-01-2026 fence
  masked_adr ADR-US006-COMMENTED-STATUS-07-01-2026 comment
  finding FINDING-US000-TEMPLATE "{STORY TITLE}" Open
  finding FINDING-US001-RESOLVED-01-01-2026 "The first record" Resolved
  finding FINDING-US002-OPEN-01-01-2026 "The second record" Open
  bug BUG-US000-TEMPLATE "US000 — {ONE-LINE DEFECT TITLE}" Open
  bug BUG-US001-TEMPLATE-RENDERS-BLANK-01-01-2026 "US001 — the template renders blank" Verified
  bug BUG-CROSS-CUTTING-FAULT-01-01-2026 "A fault no story owns" Open
  bug BUG-US002-FIXED-ONLY-01-01-2026 "US002 — fixed, not yet verified" Fixed
  git init -q "$FX"
  board --write --quiet --root "$FX"
  fgit add -A && fgit commit -q --allow-empty -m fixture
}

# ── Probes ────────────────────────────────────────────────────────────────────

lacks() { ! grep -qF -- "$2" "$1"; }
row() { grep -E "^\| $2 +\|" "$1"; }
in_order() {  # in_order FILE PATTERN... — each pattern's first line number rises
  local f="$1" last=0 n p; shift
  for p in "$@"; do
    n=$(grep -nF -- "$p" "$f" | head -1 | cut -d: -f1)
    [[ -n "$n" && "$n" -gt "$last" ]] || return 1
    last=$n
  done
}

probe_render() {
  local dec="$SRC/15-DECISIONS/DECISIONS-BOARD.md" fin="$SRC/20-FINDINGS/FINDINGS-BOARD.md"
  local bugs="$SRC/21-BUGS/BUGS-BOARD.md"
  echo "render"
  check "DECISIONS-BOARD.md is written" test -f "$dec"
  check "FINDINGS-BOARD.md is written" test -f "$fin"
  check "BUGS-BOARD.md is written" test -f "$bugs"
  check "the decisions columns run Proposed, Accepted, Superseded, Deprecated" \
    in_order "$dec" "## Proposed" "## Accepted" "## Superseded" "## Deprecated"
  check "the findings columns run Open, Resolved" in_order "$fin" "## Open" "## Resolved"
  check "the findings board has no Triaged column (the vocabulary is Open | Resolved)" lacks "$fin" "## Triaged"
  check "the bugs columns run Open, Fixed, Verified" in_order "$bugs" "## Open" "## Fixed" "## Verified"
  check "each board states its row ordering in its opening line" \
    bash -c 'for f; do grep -m1 "^One row per" "$f" | grep -qF "ID order" || exit 1; done' _ "$dec" "$fin" "$bugs"
  check "an ADR title is its H1 with the ADR-US### prefix cut" \
    bash -c 'grep -E "^\| ADR-US001-OLD-WAY-01-01-2026 +\| The old way +\|" "$1"' _ "$dec"
  check "a findings title is its H1 with the Findings — US### prefix cut" \
    bash -c 'grep -E "^\| FINDING-US001-RESOLVED-01-01-2026 +\| The first record +\|" "$1"' _ "$fin"
  check "no record lands in Unrecognised" \
    bash -c '! grep -q "^## Unrecognised" "$@"' _ "$dec" "$fin" "$bugs"
}

probe_instances() {
  local bugs="$SRC/21-BUGS/BUGS-BOARD.md"
  echo "instances"
  check "the cross-cutting BUG-<DESCRIPTOR>-DD-MM-YYYY.md fallback is a row" \
    row "$bugs" BUG-CROSS-CUTTING-FAULT-01-01-2026
  check "a bug whose name merely contains TEMPLATE is a row" row "$bugs" BUG-US001-TEMPLATE-RENDERS-BLANK-01-01-2026
  check "BUG-US000-TEMPLATE.md is not a row" lacks "$bugs" "BUG-US000-TEMPLATE"
  check "ADR-US000-TEMPLATE.md is not a row" lacks "$SRC/15-DECISIONS/DECISIONS-BOARD.md" "ADR-US000-TEMPLATE"
  check "FINDING-US000-TEMPLATE.md is not a row" lacks "$SRC/20-FINDINGS/FINDINGS-BOARD.md" "FINDING-US000-TEMPLATE"
  check "the bugs board counts its three instances" \
    bash -c '[[ $(grep -cE "^\| BUG-" "$1") -eq 3 ]]' _ "$bugs"
}

probe_tail() {
  local dec="$SRC/15-DECISIONS/DECISIONS-BOARD.md"
  echo "tail"
  check "the decisions header is ID, Title, Status, File, Supersedes, Superseded by" \
    bash -c 'grep -qE "^\| ID +\| Title +\| Status +\| File +\| Supersedes +\| Superseded by +\|$" "$1"' _ "$dec"
  check "a Superseded ADR shows its successor in Superseded by" \
    bash -c 'grep -E "^\| ADR-US001-OLD-WAY-01-01-2026 " "$1" | grep -qE "\| None +\| ADR-US001-NEW-WAY-02-01-2026 +\|$"' _ "$dec"
  check "its successor shows it in Supersedes" \
    bash -c 'grep -E "^\| ADR-US001-NEW-WAY-02-01-2026 " "$1" | grep -qE "\| ADR-US001-OLD-WAY-01-01-2026 +\| None +\|$"' _ "$dec"
  check "the findings and bugs boards carry no supersession columns" \
    bash -c '! grep -q "Superseded by" "$@"' _ "$SRC/20-FINDINGS/FINDINGS-BOARD.md" "$SRC/21-BUGS/BUGS-BOARD.md"
  adr ADR-US004-ORPHAN-05-01-2026 "An orphaned supersession" Superseded None ADR-US001-NEW-WAY-02-01-2026
  check "--warn names a supersession its successor does not name back" \
    bash -c 'bash "$1" --warn --root "$2" | grep -q "ADR-US004-ORPHAN-05-01-2026"' _ "$SRC/00-ASSETS/scripts/pm-board.sh" "$FX"
  rm -f "$SRC/15-DECISIONS/ADR-US004-ORPHAN-05-01-2026.md"
}

probe_masked() {
  local dec="$SRC/15-DECISIONS/DECISIONS-BOARD.md" id form
  echo "masked"
  for id in ADR-US005-FENCED-STATUS-06-01-2026 ADR-US006-COMMENTED-STATUS-07-01-2026; do
    form="a fenced code block"; [[ "$id" == *COMMENTED* ]] && form="an HTML comment"
    check "$id: a decoy status in $form is not read — the board files it Accepted" \
      bash -c 'grep -E "^\| $2 " "$1" | grep -qE "\| Accepted +\|"' _ "$dec" "$id"
    check "$id: a decoy Superseded by line there is not read either" \
      bash -c 'grep -E "^\| $2 " "$1" | grep -qE "\| None +\| None +\|$"' _ "$dec" "$id"
    check "$id: pm-archive.sh --dry-run refuses it (it is Accepted, not Deprecated)" \
      bash -c '! bash "$1" "$2" --dry-run' _ "$SRC/00-ASSETS/scripts/pm-archive.sh" "$id"
  done
}

probe_chains() {
  local out
  echo "chains"
  adr ADR-US007-SELF-08-01-2026 "A record that supersedes itself" Superseded ADR-US007-SELF-08-01-2026 ADR-US007-SELF-08-01-2026
  adr ADR-US008-CYCLE-A-09-01-2026 "One end of a cycle" Superseded ADR-US008-CYCLE-B-09-01-2026 ADR-US008-CYCLE-B-09-01-2026
  adr ADR-US008-CYCLE-B-09-01-2026 "The other end of a cycle" Superseded ADR-US008-CYCLE-A-09-01-2026 ADR-US008-CYCLE-A-09-01-2026
  adr ADR-US009-STILL-ACCEPTED-10-01-2026 "Accepted, yet naming a successor" Accepted None ADR-US009-SUCCESSOR-11-01-2026
  adr ADR-US009-SUCCESSOR-11-01-2026 "Its successor" Accepted ADR-US009-STILL-ACCEPTED-10-01-2026 None
  out="$(board --warn --root "$FX" 2>&1 || true)"
  check "--warn names an ADR that supersedes itself" grep -qE "ADR-US007-SELF-08-01-2026.*(itself)" <<< "$out"
  check "--warn names a supersession cycle" grep -qE "supersession cycle" <<< "$out"
  check "--warn names a successor on an ADR that is not Superseded" \
    grep -qE "ADR-US009-STILL-ACCEPTED-10-01-2026.*Accepted.*Superseded by|ADR-US009-STILL-ACCEPTED-10-01-2026.*not Superseded" <<< "$out"
  check "  and not the well-formed successor" bash -c '! grep -qE "^warning: ADR-US009-SUCCESSOR-11-01-2026" <<< "$1"' _ "$out"
  rm -f "$SRC"/15-DECISIONS/ADR-US00[789]-*.md
}

refused() {  # refused ID FILE — pm-archive.sh exits 1 and the file has not moved
  local rc=0
  archive "$1" >/dev/null 2>&1 || rc=$?
  [[ $rc -eq 1 && -f "$2" ]]
}

archived() {  # archived ID FOLDER — pm-archive.sh exits 0 and the file sits in archive/
  archive "$1" --date 01/02/2026 >/dev/null 2>&1 && test -f "$SRC/$2/archive/$1.md" && test ! -f "$SRC/$2/$1.md"
}

probe_archive() {
  echo "archive"
  check "an Accepted ADR is refused" refused ADR-US001-NEW-WAY-02-01-2026 "$SRC/15-DECISIONS/ADR-US001-NEW-WAY-02-01-2026.md"
  check "a Proposed ADR is refused" refused ADR-US002-DRAFT-03-01-2026 "$SRC/15-DECISIONS/ADR-US002-DRAFT-03-01-2026.md"
  check "an Open findings record is refused" refused FINDING-US002-OPEN-01-01-2026 "$SRC/20-FINDINGS/FINDING-US002-OPEN-01-01-2026.md"
  check "a Fixed bug is refused" refused BUG-US002-FIXED-ONLY-01-01-2026 "$SRC/21-BUGS/BUG-US002-FIXED-ONLY-01-01-2026.md"
  check "a refusal moves nothing" bash -c '[[ -z "$(git -C "$1" status --porcelain)" ]]' _ "$FX"
  check "a Superseded ADR is archived" archived ADR-US001-OLD-WAY-01-01-2026 15-DECISIONS
  check "a Deprecated ADR is archived" archived ADR-US003-RETIRED-04-01-2026 15-DECISIONS
  check "a Resolved findings record is archived" archived FINDING-US001-RESOLVED-01-01-2026 20-FINDINGS
  check "a Verified bug is archived" archived BUG-US001-TEMPLATE-RENDERS-BLANK-01-01-2026 21-BUGS
  check "an archived record keeps its end status" \
    grep -qx '\*\*Status:\*\* Superseded' "$SRC/15-DECISIONS/archive/ADR-US001-OLD-WAY-01-01-2026.md"
  check "a reference to the archived ADR is rewritten into archive/" \
    grep -qF "15-DECISIONS/archive/ADR-US001-OLD-WAY-01-01-2026.md" "$SRC/15-DECISIONS/ADR-US001-NEW-WAY-02-01-2026.md"
  check "the archived ADR is still a board row" row "$SRC/15-DECISIONS/DECISIONS-BOARD.md" ADR-US001-OLD-WAY-01-01-2026
  fgit add -A && fgit commit -q --allow-empty -m archive
  check "--check passes once the archive is committed" board --check --quiet --root "$FX"
  check "an archived record cannot be archived again" \
    refused ADR-US001-OLD-WAY-01-01-2026 "$SRC/15-DECISIONS/archive/ADR-US001-OLD-WAY-01-01-2026.md"
  local frozen="$SRC/21-BUGS/archive/BUG-US001-TEMPLATE-RENDERS-BLANK-01-01-2026.md"
  if [[ -f "$frozen" ]]; then
    printf '\nAn edit.\n' >> "$frozen"
    check "--check fails on an edit to an archived bug" \
      bash -c '! bash "$1" --check --quiet --root "$2"' _ "$SRC/00-ASSETS/scripts/pm-board.sh" "$FX"
  else
    fail "--check fails on an edit to an archived bug (no archived bug to edit)"
  fi
  fgit checkout -q -- .
  adr ADR-US010-REVIVED-12-01-2026 "Revives a retired decision" Accepted ADR-US003-RETIRED-04-01-2026 None
  check "an ADR naming an archived ADR in Supersedes raises no back-link warning (archive/ is frozen)" \
    bash -c '! bash "$1" --warn --root "$2" | grep -q "ADR-US010-REVIVED-12-01-2026.*does not name it back"' _ \
    "$SRC/00-ASSETS/scripts/pm-board.sh" "$FX"
  rm -f "$SRC/15-DECISIONS/ADR-US010-REVIVED-12-01-2026.md"
}

probe_staged() {
  local adr="project-management/src/15-DECISIONS/ADR-US002-DRAFT-03-01-2026.md" out
  echo "staged"
  sed -i 's/^\*\*Status:\*\* Proposed$/**Status:** Accepted/' "$FX/$adr"
  out="$(cd "$FX" && bash "$SRC/00-ASSETS/scripts/pm-board.sh" --boards-for "$adr" --quiet 2>/dev/null || true)"
  check "--boards-for names DECISIONS-BOARD.md for an ADR status edit" \
    grep -qx "project-management/src/15-DECISIONS/DECISIONS-BOARD.md" <<< "$out"
  fgit checkout -q -- .
}

probe_strays() {
  local out rc=0
  echo "strays"
  printf '# notes\n' > "$SRC/21-BUGS/BUG-US003-NOTES.MD"
  printf '# draft\n' > "$SRC/15-DECISIONS/adr-draft.md"
  printf '# cut plan\n' > "$SRC/02-STORIES/CUT-PLAN.md"
  out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "--check fails when a boarded folder holds a .md that is no instance, template or pair" test "$rc" -eq 1
  check "  and names a .MD stray in 21-BUGS/" grep -qF "21-BUGS/BUG-US003-NOTES.MD" <<< "$out"
  check "  and names a stray that fails the ADR pattern in 15-DECISIONS/" grep -qF "15-DECISIONS/adr-draft.md" <<< "$out"
  check "  but not 02-STORIES/CUT-PLAN.md, the cut plan the folder documents" bash -c '! grep -qF "CUT-PLAN.md" <<< "$1"' _ "$out"
  rm -f "$SRC/21-BUGS/BUG-US003-NOTES.MD" "$SRC/15-DECISIONS/adr-draft.md"
  check "--check passes again once the strays are gone" board --check --quiet --root "$FX"
  rm -f "$SRC/02-STORIES/CUT-PLAN.md"
}

probe_check_fails() {  # run on the committed fixture, where --check passes until a probe file lands
  local out rc
  echo "check"
  adr ADR-US004-ORPHAN-05-01-2026 "An orphaned supersession" Superseded None ADR-US001-NEW-WAY-02-01-2026
  board --write --quiet --root "$FX"
  rc=0; out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "--check exits 1 on a supersession chain that does not walk back, its board current" test "$rc" -eq 1
  check "  and names the chain" grep -qE "^✗ .*ADR-US004-ORPHAN-05-01-2026" <<< "$out"
  rm -f "$SRC/15-DECISIONS/ADR-US004-ORPHAN-05-01-2026.md"
  finding FINDING-US003-LEGACY-02-01-2026 "A legacy status" Triaged
  board --write --quiet --root "$FX"
  rc=0; out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "--check exits 1 on a findings record filed under Unrecognised, its board current" test "$rc" -eq 1
  check "  and names the record" grep -qE "^✗ .*FINDING-US003-LEGACY-02-01-2026" <<< "$out"
  rm -f "$SRC/20-FINDINGS/FINDING-US003-LEGACY-02-01-2026.md"
  board --write --quiet --root "$FX"
  check "--check passes again once both are gone" board --check --quiet --root "$FX"
  bug BUG-US003-READY-01-01-2026 "US003 — verified, not yet archived" Verified
  check "--warn stays advisory: it names a record ready to archive and exits 0" bash -c '
    out="$(bash "$1" --warn --root "$2")" && grep -q "BUG-US003-READY-01-01-2026 is Verified — ready to archive" <<< "$out"' _ \
    "$SRC/00-ASSETS/scripts/pm-board.sh" "$FX"
  rm -f "$SRC/21-BUGS/BUG-US003-READY-01-01-2026.md"
}

probe_round3() {  # run last, on the committed fixture with archived records in place
  local out rc pmb="$SRC/00-ASSETS/scripts/pm-board.sh" frozen="$SRC/21-BUGS/archive/BUG-US001-TEMPLATE-RENDERS-BLANK-01-01-2026.md"
  echo "successors"
  adr ADR-US011-ROGUE-12-01-2026 "A rogue successor" Accepted ADR-US001-OLD-WAY-01-01-2026 None
  board --write --quiet --root "$FX"
  rc=0; out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "--check fails when an ADR claims to supersede an archived ADR that names another successor" test "$rc" -eq 1
  check "  and names the claimant" grep -qF "ADR-US011-ROGUE-12-01-2026" <<< "$out"
  rm -f "$SRC/15-DECISIONS/ADR-US011-ROGUE-12-01-2026.md"
  board --write --quiet --root "$FX"
  check "--check passes once the claimant is gone" board --check --quiet --root "$FX"

  echo "subfolders"
  mkdir -p "$SRC/20-FINDINGS/old" "$SRC/21-BUGS/archive/older"
  board --write --quiet --root "$FX"
  finding FINDING-US099-LOST-19-11-2026 "A record in a subfolder" Open
  mv "$SRC/20-FINDINGS/FINDING-US099-LOST-19-11-2026.md" "$SRC/20-FINDINGS/old/"
  printf '# notes\n' > "$SRC/21-BUGS/archive/older/BUG-US098-OLDER-01-01-2026.md"
  rc=0; out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "--check fails on a .md in a subfolder of a boarded folder other than archive/" test "$rc" -eq 1
  check "  and names it" grep -qF "20-FINDINGS/old/FINDING-US099-LOST-19-11-2026.md" <<< "$out"
  check "  and one nested inside archive/" grep -qF "21-BUGS/archive/older/BUG-US098-OLDER-01-01-2026.md" <<< "$out"
  rm -rf "$SRC/20-FINDINGS/old" "$SRC/21-BUGS/archive/older"

  echo "frozen"
  sed -i 's/^## 1\. Summary$/## 1. archive\/Summary/' "$frozen"
  check "--check fails when a bare archive/ is added to an archived file's prose" \
    bash -c '! bash "$1" --check --quiet --root "$2"' _ "$pmb" "$FX"
  fgit checkout -q -- .
  sed -i 's/^## 1\. Summary$/## 1. ..\/Summary/' "$frozen"
  check "--check fails when a bare ../ is added to an archived file's prose" \
    bash -c '! bash "$1" --check --quiet --root "$2"' _ "$pmb" "$FX"
  fgit checkout -q -- .
  adr ADR-US014-NEWEST-15-01-2026 "The newest way" Accepted ADR-US001-NEW-WAY-02-01-2026 None
  sed -i 's/^\*\*Status:\*\* Accepted$/**Status:** Superseded/; s#^\*\*Superseded by:\*\* None$#**Superseded by:** `project-management/src/15-DECISIONS/ADR-US014-NEWEST-15-01-2026.md`#' \
    "$SRC/15-DECISIONS/ADR-US001-NEW-WAY-02-01-2026.md"
  fgit add -A && fgit commit -q -m newest
  check "archiving an ADR an archived ADR names succeeds" archived ADR-US001-NEW-WAY-02-01-2026 15-DECISIONS
  check "  and rewrites the frozen ADR's reference into archive/" \
    grep -qF "15-DECISIONS/archive/ADR-US001-NEW-WAY-02-01-2026.md" "$SRC/15-DECISIONS/archive/ADR-US001-OLD-WAY-01-01-2026.md"
  fgit add -A && fgit commit -q -m archive-new-way
  check "  and --check still admits that rewrite of a frozen file" board --check --quiet --root "$FX"

  echo "templates"
  adr ADR-US013-OLD-RULE-14-01-2026 "An old rule" Superseded None ADR-US012-SHIPPED-TEMPLATES-RULE-13-01-2026
  adr ADR-US012-SHIPPED-TEMPLATES-RULE-13-01-2026 "Shipped templates rule" Accepted ADR-US013-OLD-RULE-14-01-2026 None
  printf '# US012: A story\n\n**Status:** Open\n' > "$SRC/02-STORIES/US012.md"
  printf '# STORY-PLAN-US012 — template rows\n\nA plan whose descriptor says TEMPLATE.\n' \
    > "$SRC/17-STORY-PLANS/01-STORY-PLAN-US012-TEMPLATE-ROWS.md"
  printf '# template\n' > "$SRC/17-STORY-PLANS/00-STORY-PLAN-US000-TEMPLATE.md"
  printf '# template\n' > "$SRC/16-SPRINT-PLANS/00-SPRINT-PLAN-00-TEMPLATE.md"
  printf '# template\n' > "$SRC/01-FEATURE-MAPS/MAP-000-TEMPLATE.md"
  printf '# template\n' > "$SRC/03-SPRINTS/SPRINT-00-TEMPLATE.md"
  printf '# template\n' > "$SRC/02-STORIES/US000-TEMPLATE.md"
  board --write --quiet --root "$FX"
  check "a story plan whose descriptor holds TEMPLATE is a row" \
    row "$SRC/17-STORY-PLANS/STORY-PLANS-BOARD.md" 01-STORY-PLAN-US012
  rc=0; out="$(board --check --root "$FX" 2>&1)" || rc=$?
  check "  and the five shipped template names are neither rows nor strays" \
    bash -c '! grep -qE "00-STORY-PLAN-US000-TEMPLATE|00-SPRINT-PLAN-00-TEMPLATE|MAP-000-TEMPLATE|SPRINT-00-TEMPLATE|US000-TEMPLATE" <<< "$1" && ! grep -qE "^\| (US000|SPRINT-00|MAP-000)" "$2"/*/*-BOARD.md' _ "$out" "$SRC"
  fgit add -A && fgit commit -q -m templates
  check "archiving an ADR rewrites the Supersedes path of a successor whose name holds TEMPLATE" \
    bash -c 'bash "$1" ADR-US013-OLD-RULE-14-01-2026 --date 01/02/2026 >/dev/null 2>&1 && grep -qF "15-DECISIONS/archive/ADR-US013-OLD-RULE-14-01-2026.md" "$2"' _ \
    "$SRC/00-ASSETS/scripts/pm-archive.sh" "$SRC/15-DECISIONS/ADR-US012-SHIPPED-TEMPLATES-RULE-13-01-2026.md"
}

echo "pm-boards.sh — fixture at $FX"
if ! build_fixture >/dev/null 2>&1; then
  fail "the fixture could not be built (pm-board.sh --write or the first commit failed)"
else
  probe_render
  probe_instances
  probe_tail
  probe_masked
  probe_chains
  probe_archive
  probe_staged
  probe_strays
  probe_check_fails
  probe_round3
fi
echo ""
if [[ $FAILS -eq 0 ]]; then
  printf '\033[1m✓ pm-boards.sh: %d probes passed\033[0m\n' "$PASSES"
  exit 0
fi
printf '\033[1m✗ pm-boards.sh: %d of %d probes failed\033[0m\n' "$FAILS" "$((FAILS + PASSES))"
exit 1
