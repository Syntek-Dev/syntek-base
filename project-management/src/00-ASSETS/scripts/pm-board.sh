#!/usr/bin/env bash
# pm-board.sh — Generate, check and warn on the eight PM kanban boards.
#
# One board per register folder, built ONLY from each item's status line:
#
#   01-FEATURE-MAPS/  FEATURE-MAPS-BOARD.md  feature-maps-board.json  feature-maps-board.html
#   02-STORIES/       STORIES-BOARD.md       stories-board.json       stories-board.html
#   03-SPRINTS/       SPRINTS-BOARD.md       sprints-board.json       sprints-board.html
#   15-DECISIONS/     DECISIONS-BOARD.md     decisions-board.json     decisions-board.html
#   16-SPRINT-PLANS/  SPRINT-PLANS-BOARD.md  sprint-plans-board.json  sprint-plans-board.html
#   17-STORY-PLANS/   STORY-PLANS-BOARD.md   story-plans-board.json   story-plans-board.html
#   20-FINDINGS/      FINDINGS-BOARD.md      findings-board.json      findings-board.html
#   21-BUGS/          BUGS-BOARD.md          bugs-board.json          bugs-board.html
#
# The .md is COMMITTED — it is the register index (one row per instance: ID, title from
# the H1, status verbatim, link) grouped into the status columns in lifecycle order. The
# .json and .html are GITIGNORED local views. Plans carry no status of their own: a plan
# shows its parent's (story plan → US###, sprint plan → SPRINT-##, both from the filename).
# Items under archive/ sit under Closed — bar the three RECORD registers (decisions, findings,
# bugs), whose archived records stay under the end status they were archived from, and whose
# boards say so, with their row order (ID, i.e. filename, order), in their opening line. The
# decisions board adds two tail columns, Supersedes and Superseded by, read from each ADR's own
# two lines. Templates are never instances. A status outside
# the vocabulary lands in an "Unrecognised" column and raises a warning. The vocabulary,
# the parsing and the lookup live in pm-lib.sh, shared with pm-archive.sh.
#
# Usage: pm-board.sh --write [--staged] | --boards-for PATH... | --check | --warn
#                   [--root DIR] [--quiet] [--help]
#
#   --write    Regenerate all eight boards (.md, .json, .html); a folder that does not exist
#              is skipped.
#   --staged   With --write, for the lefthook pre-commit leg: do nothing unless a file in
#              one of the eight folders is staged. Renders the boards from the INDEX (what
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
#   --check    Exit 1 if any committed *-BOARD.md is stale or missing; if a boarded folder or
#              its archive/ holds a .md (any case) that is no instance, template, CONTEXT.md /
#              CLAUDE.md, board or documented extra (02-STORIES/CUT-PLAN.md); if an ADR,
#              findings record or bug sits under Unrecognised, or a supersession chain fails
#              any --warn chain test below (those two are failures here, not advice); or if the archive
#              frozen rule is breached. Under any */archive/ (its CONTEXT.md and CLAUDE.md aside):
#                · no committed deletion (a move back out reads as one), and no rename whose
#                  source is already there;
#                · each file, as its archiving commit left it (or the working tree, before that
#                  commit), equals the live copy it was moved from in the commit before, but for
#                  what pm-archive.sh rewrites: a status register's status line (to Closed) and a
#                  story's archive history row, every reference path's depth and folder, and a
#                  table row's padding (whitespace only). A file with no live copy before it, and
#                  a story or map not archived from Completed or Complete, also fail;
#                · after that commit it differs ONLY by the reference-path rewrites pm-archive.sh
#                  makes later (inserting `archive/`, adjusting `../` depth);
#                · no file archived at HEAD is gone from the working tree;
#                · each holds its kind's archive status — Closed, or the end state a record was
#                  archived from — a failure here, where --warn only advises.
#              Measured against git history, so CI must check out with full depth.
#   --warn     Print stale-status warnings and exit 0: a Blocked story whose dependencies
#              are all Completed/Closed; a Customer Accepted (or N/A-customer Accepted)
#              story past its window, ready for Completed; a Completed story, ready to
#              archive; a sprint whose stories are all Closed; a Complete map with every
#              slice cut; a Complete or Closed map whose Fog of war still lists an item
#              (a list item or table row; prose such as "_Empty._" lists nothing); a
#              record in an end state, ready to archive; a supersession chain that does
#              not walk both ways (a named ADR absent, or not naming this one back, or a
#              Superseded ADR naming no successor, an ADR naming itself, an ADR not
#              Superseded naming a successor, or a cycle); an unrecognised status. Windows: CUSTOMER_REVIEW_WEEKS and
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
    --help|-h) sed -n '2,85p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown argument: '$1'. Use --help for usage." ;;
  esac
done
[[ -n "$MODE" ]] || die "no mode given — pass --write, --boards-for, --check or --warn (see --help)"
[[ "$STAGED" == false || "$MODE" == write ]] || die "--staged only applies to --write"
command -v python3 >/dev/null 2>&1 || die "python3 not found on PATH"

# shellcheck source=pm-lib.sh
source "$SCRIPT_DIR/pm-lib.sh"

# git, read here, with no system or global configuration, no caller `-c` options, no external
# diff or pager, and the output-shaping keys pinned — the shell half of the freeze's GIT_ENV
# (round 5, 21/11/2026). The index is still the index git is committing (GIT_INDEX_FILE kept).
g() {
  env -u GIT_CONFIG_PARAMETERS -u GIT_CONFIG_COUNT -u GIT_EXTERNAL_DIFF -u GIT_PAGER -u GIT_ATTR_SOURCE \
    GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null \
    git --no-pager -c color.ui=false -c core.quotePath=true -c diff.relative=false \
      -c core.autocrlf=false -c core.eol=lf -c core.attributesFile=/dev/null "$@"
}

cd "$PROJECT_ROOT"

FOLDERS=(01-FEATURE-MAPS 02-STORIES 03-SPRINTS 15-DECISIONS 16-SPRINT-PLANS 17-STORY-PLANS
         20-FINDINGS 21-BUGS)
BOARDS=(FEATURE-MAPS STORIES SPRINTS DECISIONS SPRINT-PLANS STORY-PLANS FINDINGS BUGS)
FOLDER_RE="^project-management/src/($(IFS='|'; echo "${FOLDERS[*]}"))/"

if [[ "$MODE" == boards-for ]]; then
  # Expand the named pathspecs the way `git add` will — from the caller's directory, so a
  # directory, `.` or a glob covers what it covers there — into root-relative files: every
  # tracked or untracked-unignored file they match, and every tracked file they match that is
  # gone from the working tree (a deletion or move-away the author is about to stage).
  BOARDS_FOR="$(cd "$CALLER_DIR" && {
    g ls-files --full-name --cached --others --exclude-standard -- "${BOARDS_ARGS[@]}"
    g ls-files --full-name --deleted -- "${BOARDS_ARGS[@]}"
  } | sort -u)" || die "could not read the named paths through git"
  if ! grep -qE "$FOLDER_RE" \
      <<< "$BOARDS_FOR"$'\n'"$(g diff --cached --name-only --no-renames 2>/dev/null || true)"; then
    $QUIET || echo "pm-board: no named or staged file is in the eight board folders — nothing to stage" >&2
    exit 0
  fi
elif $STAGED; then
  staged="$(g diff --cached --name-only --no-renames 2>/dev/null || true)"
  if ! grep -qE "$FOLDER_RE" <<< "$staged"; then
    $QUIET || echo "pm-board: no file in the eight board folders is staged — nothing to do"
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
        if kind.tail:
            row["supersedes"] = tail_cell(it.supersedes)
            row["superseded_by"] = tail_cell(it.superseded_by)
        grouped[col].append(row)
    return kind, cols, grouped, warns

def tail_cell(ids):
    """A supersession column: the IDs named, `None`, or `—` for a missing or unreadable line."""
    if ids is None:
        return "—"
    return ", ".join(ids) if ids else "None"

def lede(kind, src):
    where = f"One row per {kind.noun} in `{kind.folder}/` and `{kind.folder}/archive/`, filed under {src}."
    if kind.archive_from:
        return (f"{where} Columns run in lifecycle order and the rows in each column in ID order, "
                "which is filename order; an archived record stays under the end status it was "
                "archived from.")
    return f"{where} Columns run in lifecycle order; archived items sit under Closed."

def record_rows(kind, rows):
    """The table for a register with no parent: ID, Title, Status, File, plus any tail columns."""
    header = ["ID", "Title", "Status", "File"] + (["Supersedes", "Superseded by"] if kind.tail else [])
    body = []
    for r in rows:
        cells = [r["id"], r["title"], r["status"] or "—", f"[{os.path.basename(r['path'])}]({r['href']})"]
        body.append(cells + ([r["supersedes"], r["superseded_by"]] if kind.tail else []))
    return render_table(header, body)

def render_md(kind, cols, grouped):
    title = kind.board.replace("-", " ").title().replace("Feature Maps", "Feature maps")
    title = title.replace("Sprint Plans", "Sprint plans").replace("Story Plans", "Story plans")
    src = "its parent's status line" if kind.parent else "its status line"
    out = [f"# {title} board", "",
           f"<!-- GENERATED by {SCRIPT} --write. Never hand-edit: regenerate it. The only source",
           f"     of truth is each item's status line; `pm-board.sh --check` fails when this file is stale. -->",
           "", lede(kind, src), "", "## Summary", ""]
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
            out += record_rows(kind, rows)
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

# The freeze reads git, so no configuration a caller carries in may change what git prints: no
# system or global file, no `-c` options passed down (GIT_CONFIG_PARAMETERS / GIT_CONFIG_COUNT), no
# external diff, no repository-location override, and the output-shaping keys pinned. It reads
# only --raw listings and `cat-file blob`, which no diff driver, textconv or colour reaches.
GIT_ENV = {k: v for k, v in os.environ.items()
           if not (k.startswith("GIT_CONFIG") or k in ("GIT_EXTERNAL_DIFF", "GIT_DIR", "GIT_WORK_TREE",
                   "GIT_INDEX_FILE", "GIT_OBJECT_DIRECTORY", "GIT_COMMON_DIR", "GIT_NAMESPACE",
                   "GIT_PAGER", "PAGER"))}
GIT_ENV.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull)
GIT_PIN = ["--no-pager", "-c", "core.quotePath=false", "-c", "log.showSignature=false",
           "-c", "color.ui=never", "-c", "core.attributesFile=" + os.devnull, "-c", "diff.renameLimit=0"]

def git(*args):
    try:
        r = subprocess.run(["git", *GIT_PIN, *args], cwd=ROOT, capture_output=True, text=True, env=GIT_ENV)
        return r.returncode, r.stdout
    except OSError:
        return 1, ""

def norm(text):
    """Erase exactly what pm-archive.sh may change in a frozen file, and only where it changes
    it: an `archive/` segment, and the `./` / `../` depth of a relative path, each only inside a
    path that ends at a `.md` filename. Collapsing `../` runs is not enough — a link rewritten
    one level deeper and later back to the bare filename must compare equal. A bare `archive/` or
    `../` in prose is not a path, so adding or removing one is an edit."""
    path = re.compile(r"(?<![\w./-])((?:\.\.?/)*)((?:[\w.-]+/)*?)((?:archive/)?)([\w.-]+\.md)(?![\w-])")
    def strip(m):
        segs = [s for s in m.group(2).split("/") if s and s != "archive"]
        return "/".join(segs + [m.group(4)])
    return path.sub(strip, text)

# Draws only on what pm-archive.sh may change while it moves a file in: the status line of a status
# register (to Closed) and a story's archive history row, every reference path's depth and folder
# (a path ending at a .md filename compares as that filename; a ./ or ../ prefix of a folder path
# is erased), and the padding of a table row pm-archive's rewrite unaligned.
DIR_DEPTH = re.compile(r"(?<![\w./-])(?:\.\.?/)+(?=(?:[\w.-]+/)+)")
MD_PATH = re.compile(r"(?<![\w./-])(?:[\w.-]*/)*([\w.-]+\.md)(?![\w-])")
TABLE_ROW = re.compile(r"^\s*\|.*\|\s*$")
ARCHIVE_ROW = re.compile(r"^\|[^|]*\|[^|]*\|Closed\|Archived by pm-archive\.sh\|$")
PRE_ARCHIVE = {"stories": "Completed", "maps": "Complete"}

def move_norm(text, kind):
    if not kind.archive_from:
        text = set_status(text, "⟨status⟩")
    text = DIR_DEPTH.sub("", MD_PATH.sub(lambda m: m.group(1), norm(text)))
    out = []
    for line in text.split("\n"):
        if TABLE_ROW.match(line):
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            line = "|" + "|".join("-" if re.fullmatch(r":?-+:?", c) else c for c in cells) + "|"
            if kind.key == "stories" and ARCHIVE_ROW.match(line):
                continue
        out.append(line)
    text = "\n".join(out).rstrip()
    if kind.key == "stories":   # a history section pm-archive.sh created holds only its header now
        text = re.sub(r"\n+## +Status history\n+\|Date\|From\|To\|Note\|\n\|-\|-\|-\|-\|$", "", text)
    return text

def archive_events(folders):
    """(commit, status, src, dst, src mode, dst mode) for every change under the archive folders,
    oldest first. `-m` diffs a merge commit against each of its parents, so a deletion, rename or
    move made inside a merge is an event like any other (a plain log shows a merge no diff)."""
    code, out = git("log", "--reverse", "-m", "-M", "--raw", "--no-abbrev", "--no-ext-diff",
                    "--no-textconv", "--no-color", "--format=@%H", "--", *folders)
    ev, c = [], None
    if code != 0:
        return ev
    for line in out.splitlines():
        if line.startswith("@"):
            c = line[1:]
        elif line.startswith(":"):
            meta, *paths = line.split("\t")
            f = meta[1:].split()
            if len(f) < 5 or not paths:
                continue
            ev.append((c, f[4][:1], paths[0], paths[-1], f[0], f[1]))
    return ev

REGULAR = "100644"

def lrel(p):
    """A path from the root WITHOUT resolving symlinks, so a link is named as itself."""
    return Path(os.path.abspath(p)).relative_to(Path(os.path.abspath(ROOT))).as_posix()

def frozen_breaches():
    out = []
    folders = [f"{SRC_REL}/{KINDS[k].folder}/archive/" for k in ORDER]
    def frozen(r):
        return any(r.startswith(f) for f in folders) and os.path.basename(r) not in PAIR
    # (a) and (b): a committed deletion under archive/, or a rename whose source is there. A path-
    # limited log reports a move out of archive/ as a deletion, and a move in from the live folder
    # as an addition, so these two cover every way an archived file can leave or change its name.
    # A merge commit appears once per parent, so one breach can be reported twice: keep the first.
    seen = set()
    def breach(msg):
        if msg not in seen:
            seen.add(msg); out.append(msg)
    for c, st, src, dst, m_src, m_dst in archive_events(folders):
        if st == "D" and frozen(src):
            breach(f"{src} was deleted from archive/ in {c[:9]} — archive/ is frozen (an "
                   "archived item is never deleted or moved back out)")
        elif st == "R" and frozen(src):
            breach(f"{src} was renamed to {dst} in {c[:9]} — archive/ is frozen (an archived "
                   "file is never renamed)")
        elif st == "T" and frozen(src):
            breach(f"{src} changed type (mode {m_src} to {m_dst}, a symlink or submodule swapped "
                   f"in) in {c[:9]} — archive/ is frozen (an archived file stays a regular file)")
        elif st == "M" and frozen(src) and m_src != m_dst:
            breach(f"{src} changed mode {m_src} to {m_dst} in {c[:9]} — archive/ is frozen (an "
                   "archived file stays a regular, non-executable file)")
        elif st in "ARC" and frozen(dst) and m_dst != REGULAR:
            breach(f"{dst} entered archive/ with mode {m_dst} in {c[:9]} — an archived file is a "
                   f"regular, non-executable file (mode {REGULAR})")
    # (c): each archived file against the live copy it was moved from, as the move commit left it,
    # and every later state against the move commit's.
    for key in ORDER:
        kind = KINDS[key]
        adir = kind.dir / "archive"
        if not adir.is_dir():
            continue
        for p in sorted(adir.iterdir()):
            if p.name in PAIR:
                continue
            if p.is_symlink():
                out.append(f"{lrel(p)} is a symlink in the working tree — archive/ is frozen (an "
                           "archived file stays the regular file pm-archive.sh moved in)")
                continue
            if not p.is_file():
                continue
            r, live = lrel(p), f"{SRC_REL}/{kind.folder}/{p.name}"
            if os.access(p, os.X_OK):
                out.append(f"{r} is executable in the working tree (mode changed) — archive/ is "
                           "frozen (an archived file stays a regular, non-executable file)")
            code, log = git("log", "--diff-filter=A", "--format=%H", "--", r)
            commits = log.split() if code == 0 else []
            root = False
            if commits:
                add, where = commits[-1], commits[-1][:9]
                _c, archived = git("cat-file", "blob", f"{add}:{r}")
                root = git("rev-parse", "-q", "--verify", f"{add}^")[0] != 0
                code, base = git("cat-file", "blob", f"{add}^:{live}")
            else:                       # moved in, not yet committed: against HEAD's live copy
                where, archived = "the working tree", read(p)
                code, base = git("cat-file", "blob", f"HEAD:{live}")
            if code != 0 and root:
                out.append(f"{r} was added in the root commit {where}, so no move into archive/ "
                           "can be read — a history imported in one commit (a squash) or a shallow "
                           "clone holds no live copy before it; --check needs the full history")
                continue
            if code != 0:
                out.append(f"{r} entered archive/ ({where}) with no live {kind.noun} at {live} "
                           "before it — only pm-archive.sh moves an item in, from its folder")
                continue
            if move_norm(base, kind) != move_norm(archived, kind):
                out.append(f"{r} was changed as it was archived ({where}) — the move may change "
                           "only what pm-archive.sh rewrites (its status to Closed, a story's "
                           "history row, reference paths, table padding)")
            pre = PRE_ARCHIVE.get(key)
            if pre and read_status(base)[0] != pre:
                out.append(f"{r} was archived ({where}) from status {read_status(base)[0]!r} — "
                           f"{article(kind.noun)} {kind.noun} is archived only from {pre!r}")
            if commits and norm(archived) != norm(read(p)):
                out.append(f"{r} has changed since it was archived in {where} — "
                           "archive/ is frozen (only pm-archive.sh's path rewrites are allowed)")
    # An archived file committed at HEAD must still be there: deleting one, or moving it back
    # out of archive/, is as much a breach as editing it.
    code, listing = git("ls-tree", "-r", "HEAD", "--", *folders)
    if code == 0:
        for line in listing.splitlines():
            meta, _t, r = line.partition("\t")
            if not r or os.path.basename(r) in PAIR:
                continue
            mode = meta.split()[0] if meta.split() else ""
            if mode != REGULAR:
                breach(f"{r} is committed at HEAD with mode {mode} — an archived file is a "
                       f"regular, non-executable file (mode {REGULAR})")
            if not os.path.lexists(ROOT / r):
                out.append(f"{r} was archived at HEAD and is gone from the working tree — "
                           "archive/ is frozen (an archived item is never deleted or moved back)")
    # (d): everything under archive/ holds its kind's archive status.
    for key in ORDER:
        for it in items(key):
            if it.archived:
                _col, w = column_of(it)
                if w and "sits in archive/" in w:
                    out.append(w)
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
    # A record register's index is only as good as its status lines and its chains, so both are
    # failures here and not advice: --warn keeps the readiness warnings advisory.
    for k in ("decisions", "findings", "bugs"):
        for it in items(k):
            col, w = column_of(it)
            if col == "Unrecognised":
                bad.append(w)
    bad += supersession_warnings()
    for k in ORDER:
        for r in strays(KINDS[k]):
            bad.append(f"{r} is in a boarded folder but is no {KINDS[k].noun}, template or pair "
                       "file — rename it to the folder's pattern or move it out (it is on no board)")
    for w in all_warns:
        say(f"warning: {w}")
    if bad:
        for b in bad:
            print(f"✗ {b}")
        sys.exit(1)
    say(f"✓ pm-board: all {len(ORDER)} boards are current and archive/ is untouched")
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
say(f"pm-board: wrote the {len(ORDER)} boards (.md committed, .json/.html gitignored)")
PYEOF
)

if ! $STAGED && [[ "$MODE" != boards-for ]]; then
  PM_ROOT="$PROJECT_ROOT" PM_MODE="$MODE" PM_QUIET="$QUIET" \
    python3 -I -c "$PM_LIB_PY"$'\n'"$BOARD_PY"
  exit $?
fi

# --staged and --boards-for both render from the INDEX. Materialise the staged copy of the eight
# folders (and the answers file the clock reads) into a scratch tree; --boards-for then lays
# the author's named paths over it from the working tree, so the render is exactly what the
# index will hold once those paths are staged. Each board that differs from its staged copy is
# copied into the working tree. Neither mode stages anything.
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT
paths=()
for f in "${FOLDERS[@]}"; do paths+=("project-management/src/$f"); done
# The index's blobs, byte for byte: `cat-file --batch` applies no filter, line-ending conversion
# or attribute, where `checkout-index` would apply every smudge filter and eol rule the
# repository or a caller configures (round 5, 21/11/2026). Regular files only.
g ls-files -s -z -- "${paths[@]}" .copier-answers.yml \
  | python3 -I -c '
import os, subprocess, sys
dest = sys.argv[1]
env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_CONFIG")}
env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull)
entries = []
for rec in sys.stdin.buffer.read().split(b"\0"):
    if not rec:
        continue
    meta, path = rec.split(b"\t", 1)
    mode, sha, _stage = meta.split()
    if mode in (b"100644", b"100755"):
        entries.append((path, sha))
cat = subprocess.Popen(["git", "cat-file", "--batch"], stdin=subprocess.PIPE, stdout=subprocess.PIPE, env=env)
for path, sha in entries:
    cat.stdin.write(sha + b"\n"); cat.stdin.flush()
    size = int(cat.stdout.readline().split()[2])
    data = cat.stdout.read(size); cat.stdout.read(1)
    out = os.path.join(dest.encode(), path)
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with open(out, "wb") as fh:
        fh.write(data)
cat.stdin.close()
sys.exit(cat.wait())
' "$SCRATCH" || die "could not copy the index into the scratch tree"
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
  if ! g cat-file blob ":$md" 2>/dev/null | cmp -s - "$SCRATCH/$md"; then
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
