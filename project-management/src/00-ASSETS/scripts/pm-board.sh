#!/usr/bin/env bash
# pm-board.sh — Generate, check and warn on the five PM kanban boards.
#
# One board per register folder, built ONLY from each item's status line:
#
#   01-FEATURE-MAPS/  FEATURE-MAPS-BOARD.md  feature-maps-board.json  feature-maps-board.html
#   02-STORIES/       STORIES-BOARD.md       stories-board.json       stories-board.html
#   03-SPRINTS/       SPRINTS-BOARD.md       sprints-board.json       sprints-board.html
#   16-SPRINT-PLANS/  SPRINT-PLANS-BOARD.md  sprint-plans-board.json  sprint-plans-board.html
#   17-STORY-PLANS/   STORY-PLANS-BOARD.md   story-plans-board.json   story-plans-board.html
#
# The .md is COMMITTED — it is the register index (one row per instance: ID, title from
# the H1, status verbatim, link) grouped into the status columns in lifecycle order. The
# .json and .html are GITIGNORED local views. Plans carry no status of their own: a plan
# shows its parent's (story plan → US###, sprint plan → SPRINT-##, both from the filename).
# Items under archive/ sit under Closed. Templates are never instances. A status outside
# the vocabulary lands in an "Unrecognised" column and raises a warning. The vocabulary,
# the parsing and the lookup live in pm-lib.sh, shared with pm-archive.sh.
#
# Usage: pm-board.sh --write [--staged] | --boards-for PATH... | --check | --warn
#                   [--root DIR] [--quiet] [--help]
#
#   --write    Regenerate all five boards (.md, .json, .html).
#   --staged   With --write, for the lefthook pre-commit leg: do nothing unless a file in
#              one of the five folders is staged. Renders the boards from the INDEX (what
#              is about to be committed), never the working tree, so an unstaged status
#              edit can never leak into a committed board. Writes each *-BOARD.md whose
#              staged copy differs, RE-STAGES NOTHING, names it and exits 1, so the board is
#              staged deliberately and committed with the status edit that moved it. A
#              board left unstaged would otherwise pass here and fail --check in CI. (Unlike
#              sync-trees.sh, whose lefthook leg sets stage_fixed and fails only when it adds
#              a TODO row, this leg never stages: the author does.) The .json/.html views are
#              not refreshed by this mode; a plain --write refreshes them.
#   --boards-for PATH...
#              The author's half of --staged, run BEFORE the commit so the hook passes first
#              time. Renders from the index with the named paths (as they stand in the working
#              tree) laid over it — i.e. the index those paths are about to produce — writes
#              each *-BOARD.md that would change, prints ONLY their paths on stdout and exits 0.
#              It stages nothing: the author stages the boards in the same `git add`:
#                git add "${paths[@]}" $(bash …/pm-board.sh --boards-for "${paths[@]}")
#              Paths are pathspecs read from the current directory, exactly as `git add` reads
#              them (files, directories, `.`; `--` ends options); the boards are printed
#              relative to it. An unstaged status edit outside the named paths never reaches
#              a board, exactly as under --staged. Filenames holding a newline are unsupported.
#   --check    Exit 1 if any committed *-BOARD.md is stale or missing, or if the archive
#              frozen rule is breached: a file already under */archive/ may differ from
#              the version that first landed there ONLY by the reference-path rewrites
#              pm-archive.sh makes (inserting `archive/`, adjusting `../` depth), and no
#              archived file committed at HEAD may be deleted or moved back out. Measured
#              against git history, so CI must check out with full depth.
#   --warn     Print stale-status warnings and exit 0: a Blocked story whose dependencies
#              are all Completed/Closed; a Customer Accepted (or N/A-customer Accepted)
#              story past its window, ready for Completed; a Completed story, ready to
#              archive; a sprint whose stories are all Closed; a Complete map with every
#              slice cut; an unrecognised status. Windows: CUSTOMER_REVIEW_WEEKS and
#              FEEDBACK_WEEKS from .copier-answers.yml, default 2 and 4.
#   --root DIR Operate on another project root (used by .github/scripts/shipped-boards.sh
#              to render the boards a generated project is seeded with).
#
# Examples:
#   bash project-management/src/00-ASSETS/scripts/pm-board.sh --write
#   bash project-management/src/00-ASSETS/scripts/pm-board.sh --check
#   bash project-management/src/00-ASSETS/scripts/pm-board.sh --warn
#   s=project-management/src/02-STORIES/US###.md; git add "$s" $(bash project-management/src/00-ASSETS/scripts/pm-board.sh --boards-for "$s")
#
# Requires: python3 (stdlib only), git (for --staged, --boards-for and the frozen check).
# Exit codes: 0 = ok / nothing in scope  1 = stale board, frozen breach, or a board a
#             staged commit must pick up  2 = preflight or argument error
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 2; }

MODE=""
STAGED=false
BOARDS_FOR=""
BOARDS_ARGS=()
CALLER_DIR="$PWD"
QUIET=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --write|--check|--warn)
      [[ -z "$MODE" ]] || die "choose one of --write, --check, --warn, --boards-for"
      MODE="${1#--}"; shift ;;
    --staged) STAGED=true; shift ;;
    --boards-for)
      [[ -z "$MODE" ]] || die "choose one of --write, --check, --warn, --boards-for"
      MODE=boards-for; shift
      # Paths run to the next option; `--` ends options, so every later argument is a path.
      while [[ $# -gt 0 ]]; do
        if [[ "$1" == -- ]]; then shift; BOARDS_ARGS+=("$@"); shift $#; break; fi
        [[ "$1" == -* ]] && break
        BOARDS_ARGS+=("$1"); shift
      done
      [[ ${#BOARDS_ARGS[@]} -gt 0 ]] || die "--boards-for needs at least one path about to be staged" ;;
    --root)
      [[ -n "${2:-}" && -d "${2:-}" ]] || die "--root needs an existing directory"
      PROJECT_ROOT="$(cd "$2" && pwd)"; shift 2 ;;
    --quiet|-q) QUIET=true; shift ;;
    --help|-h) sed -n '2,68p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown argument: '$1'. Use --help for usage." ;;
  esac
done
[[ -n "$MODE" ]] || die "no mode given — pass --write, --boards-for, --check or --warn (see --help)"
[[ "$STAGED" == false || "$MODE" == write ]] || die "--staged only applies to --write"
command -v python3 >/dev/null 2>&1 || die "python3 not found on PATH"

# shellcheck source=pm-lib.sh
source "$SCRIPT_DIR/pm-lib.sh"

cd "$PROJECT_ROOT"

FOLDERS=(01-FEATURE-MAPS 02-STORIES 03-SPRINTS 16-SPRINT-PLANS 17-STORY-PLANS)
BOARDS=(FEATURE-MAPS STORIES SPRINTS SPRINT-PLANS STORY-PLANS)

if [[ "$MODE" == boards-for ]]; then
  # Expand the named pathspecs the way `git add` will — from the caller's directory, so a
  # directory, `.` or a glob covers what it covers there — into root-relative files: every
  # tracked or untracked-unignored file they match, and every tracked file they match that is
  # gone from the working tree (a deletion or move-away the author is about to stage).
  BOARDS_FOR="$(cd "$CALLER_DIR" && {
    git ls-files --full-name --cached --others --exclude-standard -- "${BOARDS_ARGS[@]}"
    git ls-files --full-name --deleted -- "${BOARDS_ARGS[@]}"
  } | sort -u)" || die "could not read the named paths through git"
  if ! grep -qE '^project-management/src/(01-FEATURE-MAPS|02-STORIES|03-SPRINTS|16-SPRINT-PLANS|17-STORY-PLANS)/' \
      <<< "$BOARDS_FOR$(git diff --cached --name-only 2>/dev/null || true)"; then
    $QUIET || echo "pm-board: no named or staged file is in the five board folders — nothing to stage" >&2
    exit 0
  fi
elif $STAGED; then
  staged="$(git diff --cached --name-only 2>/dev/null || true)"
  if ! grep -qE '^project-management/src/(01-FEATURE-MAPS|02-STORIES|03-SPRINTS|16-SPRINT-PLANS|17-STORY-PLANS)/' <<< "$staged"; then
    $QUIET || echo "pm-board: no file in the five board folders is staged — nothing to do"
    exit 0
  fi
fi

BOARD_PY=$(cat <<'PYEOF'
import html as H

MODE, QUIET = os.environ["PM_MODE"], os.environ["PM_QUIET"] == "true"
SCRIPT = "project-management/src/00-ASSETS/scripts/pm-board.sh"

def say(*a):
    if not QUIET:
        print(*a)

def link(target, from_dir):
    return os.path.relpath(target, from_dir).replace(os.sep, "/")

def build(key):
    kind = KINDS[key]
    cols = kind.statuses
    grouped = {c: [] for c in cols}
    grouped["Unrecognised"] = []
    warns = []
    for it in items(key):
        col, w = column_of(it)
        if w:
            warns.append(w)
        status, owner = effective_status(it)
        row = {"id": it.id, "title": it.title, "status": status if status is not None else "",
               "note": it.note or "", "path": it.rel, "archived": it.archived,
               "href": link(it.path, kind.dir)}
        if kind.parent:
            row["parent"] = it.parent_id
            row["parent_href"] = link(owner.path, kind.dir) if owner else ""
        grouped[col].append(row)
    return kind, cols, grouped, warns

def render_md(kind, cols, grouped):
    title = kind.board.replace("-", " ").title().replace("Feature Maps", "Feature maps")
    title = title.replace("Sprint Plans", "Sprint plans").replace("Story Plans", "Story plans")
    src = "its parent's status line" if kind.parent else "its status line"
    out = [f"# {title} board", "",
           f"<!-- GENERATED by {SCRIPT} --write. Never hand-edit: regenerate it. The only source",
           f"     of truth is each item's status line; `pm-board.sh --check` fails when this file is stale. -->",
           "",
           f"One row per {kind.noun} in `{kind.folder}/` and `{kind.folder}/archive/`, filed under "
           f"{src}. Columns run in lifecycle order; archived items sit under Closed.",
           "", "## Summary", ""]
    shown = cols + (["Unrecognised"] if grouped["Unrecognised"] else [])
    out += render_table(["Column", "Items"], [[c, str(len(grouped[c]))] for c in shown])
    for c in shown:
        out += ["", f"## {c}", ""]
        rows = grouped[c]
        if not rows:
            out.append("_None._")
            continue
        if kind.parent:
            noun = "Story" if kind.parent == "stories" else "Sprint"
            body = [[r["id"], f"[{r['parent']}]({r['parent_href']})" if r["parent_href"] else r["parent"],
                     r["title"], r["status"] or "—", f"[{os.path.basename(r['path'])}]({r['href']})"]
                    for r in rows]
            out += render_table(["Plan", noun, "Title", "Status", "File"], body)
        else:
            body = [[r["id"], r["title"], r["status"] or "—", f"[{os.path.basename(r['path'])}]({r['href']})"]
                    for r in rows]
            out += render_table(["ID", "Title", "Status", "File"], body)
    return "\n".join(out) + "\n"

CSS = """
/* A local PM view, generated and gitignored - NOT application CSS. The token-first rule
   (code/docs/DESIGN-TOKENS.md) governs the product's stylesheets; this throwaway report
   has no token layer to consume, so its literals are deliberate. */
body{font:14px/1.45 system-ui,sans-serif;margin:0;padding:1.5rem;background:#f4f5f7;color:#1d2125}
h1{font-size:1.4rem;margin:0 0 .25rem}p.lede{margin:0 0 1rem;color:#44546f}
.board{display:flex;gap:.75rem;overflow-x:auto;align-items:flex-start;padding-bottom:1rem}
.col{flex:0 0 17rem;background:#ebecf0;border-radius:6px;padding:.5rem}
.col h2{font-size:.85rem;text-transform:uppercase;letter-spacing:.04em;margin:.25rem .25rem .5rem;
display:flex;justify-content:space-between}.col h2 span{color:#44546f}
.col.unrecognised{background:#ffe9e9}ul{list-style:none;margin:0;padding:0}
.card{background:#fff;border-radius:4px;padding:.5rem .6rem;margin-bottom:.5rem;box-shadow:0 1px 1px #091e4240}
.card a{font-weight:600;color:#0c66e4;text-decoration:none}.card p{margin:.25rem 0}
.card small{color:#44546f}.archived{opacity:.7}.empty{color:#626f86;font-style:italic;margin:.25rem}
"""

def render_html(kind, cols, grouped):
    title = f"{kind.board.replace('-', ' ').title()} board"
    shown = cols + (["Unrecognised"] if grouped["Unrecognised"] else [])
    parts = []
    for c in shown:
        cards = []
        for r in grouped[c]:
            extra = f" · {H.escape(r['parent'])}" if kind.parent else ""
            cards.append(f'<li class="card{" archived" if r["archived"] else ""}">'
                         f'<a href="{H.escape(r["href"])}">{H.escape(r["id"])}</a>{extra}'
                         f'<p>{H.escape(r["title"])}</p><small>{H.escape(r["status"] or "—")}'
                         f'{" — " + H.escape(r["note"]) if r["note"] else ""}</small></li>')
        body = "\n".join(cards) or '<li class="empty">None</li>'
        parts.append(f'<section class="col {slug(c)}" aria-label="{H.escape(c)}">'
                     f'<h2>{H.escape(c)} <span>{len(grouped[c])}</span></h2><ul>\n{body}\n</ul></section>')
    return ("<!doctype html>\n<html lang=\"en-GB\">\n<head>\n<meta charset=\"utf-8\">\n"
            f"<title>{H.escape(title)}</title>\n<style>{CSS}</style>\n</head>\n<body>\n"
            f"<h1>{H.escape(title)}</h1>\n<p class=\"lede\">Generated by {SCRIPT} from the "
            f"status lines in {kind.folder}/. Local view only.</p>\n"
            f"<main class=\"board\">\n" + "\n".join(parts) + "\n</main>\n</body>\n</html>\n")

def render_json(kind, cols, grouped, warns):
    shown = cols + (["Unrecognised"] if grouped["Unrecognised"] else [])
    return json.dumps({"board": kind.key, "folder": kind.folder,
                       "columns": [{"id": slug(c), "title": c, "items": grouped[c]} for c in shown],
                       "warnings": warns}, indent=2, ensure_ascii=False) + "\n"

def git(*args):
    try:
        r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True, text=True)
        return r.returncode, r.stdout
    except OSError:
        return 1, ""

def norm(text):
    """Erase exactly what pm-archive.sh may change in a frozen file: `archive/` segments and
    the `./` / `../` depth of a relative path. Collapsing `../` runs is not enough — a link
    rewritten to `../US002.md` and later back to `US002.md` must compare equal."""
    text = text.replace("archive/", "")
    return re.sub(r"(?<![\w.])(?:\.\.?/)+", "", text)

def frozen_breaches():
    out = []
    for key in ORDER:
        adir = KINDS[key].dir / "archive"
        if not adir.is_dir():
            continue
        for p in sorted(adir.iterdir()):
            if not p.is_file() or p.name in ("CONTEXT.md", "CLAUDE.md"):
                continue
            r = rel(p)
            code, log = git("log", "--diff-filter=A", "--format=%H", "--", r)
            commits = log.split()
            if code != 0 or not commits:
                continue        # freshly archived, not yet committed: nothing to compare
            code, first = git("show", f"{commits[-1]}:{r}")
            if code != 0:
                continue
            if norm(first) != norm(read(p)):
                out.append(f"{r} has changed since it was archived in {commits[-1][:9]} — "
                           "archive/ is frozen (only pm-archive.sh's path rewrites are allowed)")
    # An archived file committed at HEAD must still be there: deleting one, or moving it back
    # out of archive/, is as much a breach as editing it.
    folders = [f"{SRC_REL}/{KINDS[k].folder}/archive/" for k in ORDER]
    code, listing = git("ls-tree", "-r", "--name-only", "HEAD", "--", *folders)
    if code == 0:
        for r in listing.splitlines():
            if os.path.basename(r) in ("CONTEXT.md", "CLAUDE.md"):
                continue
            if not (ROOT / r).is_file():
                out.append(f"{r} was archived at HEAD and is gone from the working tree — "
                           "archive/ is frozen (an archived item is never deleted or moved back)")
    return out

boards = [build(k) for k in ORDER]
all_warns = [w for b in boards for w in b[3]]

if MODE == "warn":
    ws = warnings()
    if not ws:
        say("pm-board: no stale statuses")
    for w in ws:
        print(f"warning: {w}")
    sys.exit(0)

if MODE == "check":
    bad = []
    for kind, cols, grouped, _w in boards:
        md = kind.board_md()
        if not md.exists():
            bad.append(f"{rel(md)} is missing — run {SCRIPT} --write")
        elif read(md) != render_md(kind, cols, grouped):
            bad.append(f"{rel(md)} is stale — run {SCRIPT} --write and commit it")
    bad += frozen_breaches()
    for w in all_warns:
        say(f"warning: {w}")
    if bad:
        for b in bad:
            print(f"✗ {b}")
        sys.exit(1)
    say("✓ pm-board: all five boards are current and archive/ is untouched")
    sys.exit(0)

for kind, cols, grouped, warns in boards:
    md = kind.board_md()
    if not kind.dir.is_dir():
        continue
    text = render_md(kind, cols, grouped)
    if read(md) != text:
        md.write_text(text, encoding="utf-8")
    stem = kind.board.lower() + "-board"
    (kind.dir / f"{stem}.json").write_text(render_json(kind, cols, grouped, warns), encoding="utf-8")
    (kind.dir / f"{stem}.html").write_text(render_html(kind, cols, grouped), encoding="utf-8")
for w in all_warns:
    say(f"warning: {w}")
say("pm-board: wrote the five boards (.md committed, .json/.html gitignored)")
PYEOF
)

if ! $STAGED && [[ "$MODE" != boards-for ]]; then
  PM_ROOT="$PROJECT_ROOT" PM_MODE="$MODE" PM_QUIET="$QUIET" \
    python3 -I -c "$PM_LIB_PY"$'\n'"$BOARD_PY"
  exit $?
fi

# --staged and --boards-for both render from the INDEX. Materialise the staged copy of the five
# folders (and the answers file the clock reads) into a scratch tree; --boards-for then lays
# the author's named paths over it from the working tree, so the render is exactly what the
# index will hold once those paths are staged. Each board that differs from its staged copy is
# copied into the working tree. Neither mode stages anything.
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
paths=()
for f in "${FOLDERS[@]}"; do paths+=("project-management/src/$f"); done
git ls-files -z -- "${paths[@]}" .copier-answers.yml \
  | git checkout-index -z --stdin --prefix="$SCRATCH/"
if [[ "$MODE" == boards-for ]]; then
  while IFS= read -r p; do
    [[ -n "$p" ]] || continue
    if [[ -f "$p" ]]; then
      mkdir -p "$SCRATCH/$(dirname "$p")"
      cp "$p" "$SCRATCH/$p"
    else
      rm -f "$SCRATCH/$p"   # a deletion or move-away the author is about to stage
    fi
  done <<< "$BOARDS_FOR"
fi
PM_ROOT="$SCRATCH" PM_MODE=write PM_QUIET=true \
  python3 -I -c "$PM_LIB_PY"$'\n'"$BOARD_PY"

changed=()
for i in "${!FOLDERS[@]}"; do
  md="project-management/src/${FOLDERS[$i]}/${BOARDS[$i]}-BOARD.md"
  [[ -f "$SCRATCH/$md" ]] || continue
  if ! git show ":$md" 2>/dev/null | cmp -s - "$SCRATCH/$md"; then
    cp "$SCRATCH/$md" "$PROJECT_ROOT/$md"
    changed+=("$md")
  fi
done

if [[ "$MODE" == boards-for ]]; then
  # stdout carries the board paths and nothing else, relative to the caller's directory, so
  # `git add` run there takes them directly. (Guarded: an empty array under `set -u` is an
  # unbound-variable error before bash 4.4.)
  if [[ ${#changed[@]} -gt 0 ]]; then
    python3 -I -c 'import os, sys
for c in sys.argv[3:]:
    print(os.path.relpath(os.path.join(sys.argv[1], c), sys.argv[2]))' \
      "$PROJECT_ROOT" "$CALLER_DIR" "${changed[@]}"
  fi
  $QUIET || echo "pm-board: ${#changed[@]} board(s) to stage with the named paths" >&2
  exit 0
fi

if [[ ${#changed[@]} -gt 0 ]]; then
  echo "pm-board: regenerated from the staged status edits — stage and commit again:"
  for c in "${changed[@]}"; do echo "  git add $c"; done
  echo "  (next time, stage with: git add <paths> \$(bash $0 --boards-for <paths>))"
  exit 1
fi
$QUIET || echo "pm-board: the staged boards match the staged status lines"
