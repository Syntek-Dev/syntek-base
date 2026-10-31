#!/usr/bin/env bash
# pm-archive.sh — Archive one finished story, sprint or feature map, and its plans.
#
# The ONLY sanctioned writer of a */archive/ folder. An archived item is frozen: after
# this command, `pm-board.sh --check` fails on any change to it beyond the reference-path
# rewrites this command itself makes when a later item is archived.
#
# What it does, in order:
#   1. Resolves the ID across the folder and its archive/ (pm-lib.sh's one lookup).
#   2. Verifies eligibility, and REFUSES (exit 1, every reason listed) unless:
#        US###      the story's status is Completed;
#        SPRINT-##  every story in its ## Story Summary is Closed;
#        MAP-NAME   the map is Complete and every row of its ## Slices table is cut
#                   into a story (no `—`, no `US###` placeholder).
#   3. Sets the status line to `**Status:** Closed`; a story also gets a row appended to
#      its `## Status history` table (Completed → Closed), the section being created at
#      the end of the file if it does not exist yet.
#   4. `git mv`s the item AND its plans into the folder's archive/ subfolder —
#        a story's NN-STORY-PLAN-US###-*.md → 17-STORY-PLANS/archive/,
#        a sprint's NN-SPRINT-PLAN-##.md    → 16-SPRINT-PLANS/archive/;
#      maps have no plans. Untracked files are moved with a plain rename instead.
#   5. Re-points the relative links INSIDE the moved files, which now sit one level deeper;
#      then rewrites references to a moved path in the PM INSTANCE ARTEFACTS only — every
#      file under project-management/src/ bar the CONTEXT.md/CLAUDE.md pairs, the templates
#      and the generated *-BOARD.md — plus the live registers GAPS.md and DEFERRED.md.
#      Repo-root paths, folder-relative paths and `../` links are rewritten anywhere in
#      those files; a bare same-folder name only inside a Markdown link target `](…)`.
#      Guides, skills, the template guide, CHANGELOG/RELEASES/VERSION-HISTORY, handoffs and
#      .copier/ are never touched: there a story path is an example or a dated record.
#   6. Regenerates the five boards (pm-board.sh --write).
#
# It never stages content and never commits: review the result, then commit it yourself.
#
# Usage: pm-archive.sh <US###|SPRINT-##|MAP-NAME> [--dry-run] [--date DD/MM/YYYY] [--help]
#
#   --dry-run   Check eligibility and print the plan; change nothing. Still exits 1 when
#               the item is not eligible.
#   --date D    The date written into the status-history row (default: today); must be a
#               real DD/MM/YYYY date.
#
# Examples:
#   bash project-management/src/00-ASSETS/scripts/pm-archive.sh US001 --dry-run
#   bash project-management/src/00-ASSETS/scripts/pm-archive.sh SPRINT-03
#   bash project-management/src/00-ASSETS/scripts/pm-archive.sh MAP-NAVIGATION
#
# Requires: python3 (stdlib only), git.
# Exit codes: 0 = archived (or eligible, with --dry-run)  1 = not found, already archived,
#             or not eligible  2 = preflight or argument error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

die() { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 2; }

ID=""
DRY=false
DATE="$(date +%d/%m/%Y)"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h) sed -n '2,44p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    --dry-run) DRY=true; shift ;;
    --date)
      [[ "${2:-}" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]] || die "--date needs DD/MM/YYYY"
      DATE="$2"; shift 2 ;;
    US[0-9][0-9][0-9]|SPRINT-[0-9][0-9]|MAP-[A-Z0-9]*)
      [[ -z "$ID" ]] || die "one ID at a time"
      ID="$1"; shift ;;
    -*) die "unknown flag: '$1'. Use --help for usage." ;;
    *) die "unexpected argument: '$1' — pass US###, SPRINT-## or MAP-NAME" ;;
  esac
done
[[ -n "$ID" ]] || die "no ID given — pass US###, SPRINT-## or MAP-NAME (see --help)"
command -v python3 >/dev/null 2>&1 || die "python3 not found on PATH"
command -v git >/dev/null 2>&1 || die "git not found on PATH"

# shellcheck source=pm-lib.sh
source "$SCRIPT_DIR/pm-lib.sh"
cd "$PROJECT_ROOT"

ARCHIVE_PY=$(cat <<'PYEOF'
import shutil

ident, DRY, DATE = os.environ["PM_ID"], os.environ["PM_DRY"] == "true", os.environ["PM_DATE"]
if parse_date(DATE) is None:
    print(f"ERROR: --date {DATE!r} is not a real DD/MM/YYYY date", file=sys.stderr)
    sys.exit(2)
key = kind_of_id(ident)
item = find(key, ident) if key else None
if item is None:
    print(f"✗ {ident}: not found in {KINDS[key].folder}/ or its archive/" if key
          else f"✗ {ident}: not a US###, SPRINT-## or MAP-NAME id")
    sys.exit(1)

why = eligibility(item)
if why:
    print(f"✗ {ident} is not eligible for archive:")
    for w in why:
        print(f"  · {w}")
    sys.exit(1)

moving = [item] + [p for p in plans_of(key, ident) if not p.archived]
moves = {m.rel: rel(m.path.parent / "archive" / m.path.name) for m in moving}
print(f"{ident} ({item.rel}) is eligible. Plan:")
print(f"  · status → Closed" + ("; status-history row Completed → Closed" if key == "stories" else ""))
for old, new in moves.items():
    print(f"  · move {old} → {new}")
# Validate every move before writing anything: an archived file is frozen, so a destination
# that already exists is refused outright, never overwritten.
clash = [new for new in moves.values() if (ROOT / new).exists()]
if clash:
    print(f"✗ {ident}: refusing — already present in archive/, which is frozen:")
    for c in clash:
        print(f"  · {c}")
    sys.exit(1)
if DRY:
    print("dry run: nothing changed")
    sys.exit(0)

# 1. Status, and the history row for a story.
text = set_status(item.text, "Closed")
if key == "stories":
    text = append_history_row(text, DATE, item.status, "Closed", "Archived by pm-archive.sh")
item.path.write_text(text, encoding="utf-8")

# 2. Move.
for old, new in moves.items():
    (ROOT / new).parent.mkdir(exist_ok=True)
    r = subprocess.run(["git", "mv", old, new], cwd=ROOT, capture_output=True, text=True)
    if r.returncode != 0:
        if (ROOT / new).exists():
            print(f"✗ {new} appeared during the move; stopping. {r.stderr.strip()}")
            sys.exit(1)
        shutil.move(str(ROOT / old), str(ROOT / new))

# 3. Relative links inside the moved files, which now sit one level deeper.
def fix_relative(tok, old_dir, new_dir):
    if re.match(r"^[a-z][a-z0-9+.-]*:|^#|^/", tok):
        return tok
    path, _, frag = tok.partition("#")
    resolved = os.path.normpath(os.path.join(old_dir, path))
    resolved = moves.get(resolved, resolved)
    if not (ROOT / resolved).exists():
        return tok
    return os.path.relpath(resolved, new_dir) + ("#" + frag if frag else "")

for old, new in moves.items():
    od, nd = os.path.dirname(old), os.path.dirname(new)
    t = read(ROOT / new)
    t2 = re.sub(r"(?<![\w./-])((?:\.\.?/)+[\w./-]*[\w-])", lambda m: fix_relative(m.group(1), od, nd), t)
    t2 = re.sub(r"(\]\()([^).\s/][^)\s]*)(\))",
                lambda m: m.group(1) + fix_relative(m.group(2), od, nd) + m.group(3), t2)
    if t2 != t:
        (ROOT / new).write_text(t2, encoding="utf-8")

# 4. References to a moved path, in the PM instance artefacts and the live registers only.
#    Everything else that names a story path is an example or a dated record (guides,
#    skills, the template guide, the changelog, handoffs, .copier/ seeds); rewriting those
#    corrupts them, and in a generated project turns a guide into a copier-update conflict.
REGISTERS = {"GAPS.md", "DEFERRED.md"}

def candidates():
    r = subprocess.run(["git", "ls-files", "-co", "--exclude-standard"], cwd=ROOT,
                       capture_output=True, text=True)
    for f in r.stdout.splitlines():
        name = os.path.basename(f)
        if f in REGISTERS:
            pass
        elif not f.startswith(SRC_REL + "/") or f.startswith(SRC_REL + "/00-ASSETS/"):
            continue
        elif (name in ("CONTEXT.md", "CLAUDE.md") or "TEMPLATE" in name
              or name.endswith("-BOARD.md") or not name.endswith(".md")):
            continue
        if (ROOT / f).is_file():
            yield f

def rewrite(f, text):
    fdir = os.path.dirname(f)
    for old, new in moves.items():
        base = os.path.basename(old)
        if base not in text:
            continue
        pat = re.compile(r"(?<![\w.-])((?:[\w.-]+/)*)" + re.escape(base) + r"(?![\w-])")
        def rep(m):
            cand = m.group(1) + base
            if cand.startswith(("../", "./")):
                res = os.path.normpath(os.path.join(fdir, cand))
                return os.path.relpath(new, fdir) if res == old else m.group(0)
            if "/" in cand:
                if cand == old or old.endswith("/" + cand):
                    return new[len(old) - len(cand):]
                if cand.endswith("/" + old):
                    return cand[:-len(old)] + new
                return m.group(0)
            return m.group(0)       # a bare name: only rewritten as a link target, below
        text = pat.sub(rep, text)
        if fdir == os.path.dirname(old):
            link = re.compile(r"(\]\()" + re.escape(base) + r"((?:#[^)\s]*)?\))")
            text = link.sub(lambda m: m.group(1) + os.path.relpath(new, fdir) + m.group(2), text)
    return text

touched = []
for f in candidates():
    p = ROOT / f
    try:
        t = p.read_text(encoding="utf-8")
    except (UnicodeDecodeError, OSError):
        continue
    t2 = rewrite(f, t)
    if t2 != t:
        try:
            p.write_text(t2, encoding="utf-8")
            touched.append(f)
        except OSError as e:
            print(f"  ! could not rewrite {f}: {e}")
print(f"✓ {ident} archived; references rewritten in {len(touched)} file(s)")
for f in touched:
    print(f"  · {f}")
PYEOF
)

PM_ROOT="$PROJECT_ROOT" PM_ID="$ID" PM_DRY="$DRY" PM_DATE="$DATE" \
  python3 -I -c "$PM_LIB_PY"$'\n'"$ARCHIVE_PY"
$DRY && exit 0

bash "$SCRIPT_DIR/pm-board.sh" --write --root "$PROJECT_ROOT"
echo "Review the moves and rewrites, then commit them yourself — nothing is staged by this command beyond git mv."
