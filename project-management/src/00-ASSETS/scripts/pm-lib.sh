#!/usr/bin/env bash
# pm-lib.sh — The shared reader for the five PM status registers. SOURCED, NEVER INVOKED.
#
# pm-board.sh and pm-archive.sh both source this file and run the Python it defines,
# appending their own entry point:
#
#     source "$SCRIPT_DIR/pm-lib.sh"
#     PM_ROOT="$PROJECT_ROOT" python3 -I -c "$PM_LIB_PY"$'\n'"$MY_PY" "$@"
#
# Why a sourced .sh rather than a .py module: copier ships `00-ASSETS/scripts/*.sh` and
# nothing else from this folder, so a helper written as .py would never reach a generated
# project. The Python is stdlib only.
#
# WHAT IT OWNS — one definition of each, so the board, the archive command and the
# warnings can never disagree:
#
#   * The five registers: 01-FEATURE-MAPS, 02-STORIES, 03-SPRINTS, 16-SPRINT-PLANS,
#     17-STORY-PLANS, their instance filename patterns, and their status vocabularies in
#     board-column order. Templates (US000, SPRINT-00, MAP-000, 00-*-TEMPLATE) are never
#     instances.
#   * LOOKUP BY ID ACROSS THE FOLDER AND ITS archive/ — every reader resolves an item this
#     way, so archiving one never breaks a script.
#   * The status read: the first line beginning `**Status:**` (or the older `**Status**:`),
#     with `**`, backticks and a trailing HTML comment removed, cut at the first ` — `
#     (or ` · `) — the rest is a note — and trimmed. Never translated: a value outside the
#     vocabulary is reported as Unrecognised, not guessed at.
#   * The `## Status history` table (| Date | From | To | Note |), the `Customer review`
#     FLAGS row, a story's dependencies, a sprint's Story Summary and a map's Slices table.
#   * The acceptance clock: CUSTOMER_REVIEW_WEEKS and FEEDBACK_WEEKS, read from
#     .copier-answers.yml and defaulting to 2 and 4 where absent (always, in syntek-base,
#     whose answers file is a template rather than data).
#   * Eligibility for archive and the stale-status warnings.
#   * The Markdown table renderer, padded the way Prettier pads, so a generated table is
#     already format-stable when the pre-commit Prettier leg reads it.
#
# Test hook: PM_TODAY=DD/MM/YYYY overrides today's date for the clock.

# shellcheck disable=SC2034  # read by the sourcing script
PM_LIB_PY=$(cat <<'PYEOF'
import os, re, sys, json, subprocess, datetime, unicodedata
from pathlib import Path

ROOT = Path(os.environ.get("PM_ROOT") or ".").resolve()
SRC_REL = "project-management/src"
SRC = ROOT / SRC_REL

STORY_STATUSES = ["Open", "Pending", "In Progress", "In Review", "Accepted", "Customer Review",
                  "Customer Accepted", "Rejected", "Customer Rejected", "Blocked", "Completed",
                  "Closed"]
SPRINT_STATUSES = ["Planned", "In Progress", "Done", "Closed"]
MAP_STATUSES = ["Charting", "Resolving", "Blockers Clear", "Complete", "Closed"]
POST_ACCEPTED = {"Accepted", "Customer Review", "Customer Accepted", "Completed", "Closed"}

def slug(title):
    return re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")


class Kind:
    def __init__(self, key, folder, board, noun, plural, pattern, statuses, parent=None):
        self.key, self.folder, self.board = key, folder, board
        self.noun, self.plural = noun, plural
        self.pattern = re.compile(pattern)
        self.statuses, self.parent = statuses, parent

    @property
    def dir(self):
        return SRC / self.folder

    def board_md(self):
        return self.dir / f"{self.board}-BOARD.md"


KINDS = {
    "maps": Kind("maps", "01-FEATURE-MAPS", "FEATURE-MAPS", "feature map", "feature maps",
                 r"^(MAP-(?!000)[A-Z0-9][A-Z0-9-]*)\.md$", MAP_STATUSES),
    "stories": Kind("stories", "02-STORIES", "STORIES", "story", "stories",
                    r"^(US(?!000)\d{3})\.md$", STORY_STATUSES),
    "sprints": Kind("sprints", "03-SPRINTS", "SPRINTS", "sprint", "sprints",
                    r"^(SPRINT-(?!00)\d{2})\.md$", SPRINT_STATUSES),
    "sprint-plans": Kind("sprint-plans", "16-SPRINT-PLANS", "SPRINT-PLANS", "sprint plan",
                         "sprint plans", r"^(\d{2}-SPRINT-PLAN-(?!00)(\d{2}))\.md$",
                         SPRINT_STATUSES, parent="sprints"),
    "story-plans": Kind("story-plans", "17-STORY-PLANS", "STORY-PLANS", "story plan",
                        "story plans", r"^(\d{2}-STORY-PLAN-(US(?!000)\d{3}))(?:-[A-Z0-9-]+)?\.md$",
                        STORY_STATUSES, parent="stories"),
}
ORDER = ["maps", "stories", "sprints", "sprint-plans", "story-plans"]

def rel(p):
    return Path(p).resolve().relative_to(ROOT).as_posix()

# ── Reading one file ──────────────────────────────────────────────────────────

def read(path):
    try:
        return Path(path).read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError):
        return ""

def strip_comments(text):
    return re.sub(r"<!--.*?-->", "", text, flags=re.S)

STATUS_LINE = re.compile(r"^\*\*Status(?::\*\*|\*\*:)[ \t]*(.*)$", re.M)

def read_status(text):
    """(value, note) from the first status line, or (None, None) when there is none."""
    m = STATUS_LINE.search(text)
    if not m:
        return None, None
    raw = re.sub(r"<!--.*?(-->|$)", "", m.group(1)).replace("**", "").replace("`", "").strip()
    cut = [i for i in (raw.find(" — "), raw.find(" · ")) if i >= 0]
    if cut:
        return raw[:min(cut)].strip(), raw[min(cut) + 3:].strip()
    return raw, ""

def read_title(text, ident):
    m = re.search(r"^# +(.+?)\s*$", text, re.M)
    title = m.group(1).strip() if m else ""
    title = re.sub(r"^[A-Z0-9-]*" + re.escape(ident.split("-")[-1]) + r"\s+[—–-]\s+", "", title)
    if title in ("", ident):
        title = goal_summary(text) or title
    return title or ident

def goal_summary(text):
    """A sprint's H1 is its bare ID, so its board title is the `**Goal:**` paragraph's first
    clause: the wrapped lines joined up to the blank line, cut at the first ` — `, `; ` or `. `."""
    lines = text.splitlines()
    start = next((i for i, l in enumerate(lines) if l.startswith("**Goal:**")), None)
    if start is None:
        return ""
    para = [lines[start][len("**Goal:**"):].strip()]
    for l in lines[start + 1:]:
        if not l.strip() or l.startswith(("#", "**", "|", "-")):
            break
        para.append(l.strip())
    goal = " ".join(p for p in para if p)
    cuts = [i for i in (goal.find(" — "), goal.find(". "), goal.find("; ")) if i > 0]
    goal = goal[:min(cuts)] if cuts else goal
    return goal.rstrip(" .")

def section(text, heading):
    """Lines under `## heading` up to the next H2, comments removed."""
    out, on = [], False
    for line in strip_comments(text).splitlines():
        if re.match(r"^## +", line):
            if on:
                break
            on = line[3:].strip().lower() == heading.lower()
            continue
        if on:
            out.append(line)
    return out

def table_rows(lines):
    rows = []
    for line in lines:
        s = line.strip()
        if not s.startswith("|"):
            if rows:
                break
            continue
        cells = [c.strip() for c in re.split(r"(?<!\\)\|", s.strip("|"))]
        if all(re.fullmatch(r":?-+:?", c) for c in cells if c):
            continue
        rows.append(cells)
    return rows

def parse_date(s):
    try:
        return datetime.datetime.strptime(s.strip(), "%d/%m/%Y").date()
    except ValueError:
        return None

def history(text):
    """[(date, from, to, note)] from `## Status history`, header row dropped."""
    rows = table_rows(section(text, "Status history"))
    out = []
    for r in rows:
        if len(r) >= 3 and parse_date(r[0]):
            out.append((parse_date(r[0]), r[1], r[2], r[3] if len(r) > 3 else ""))
    return out

def last_entered(hist, status):
    dates = [d for d, _f, t, _n in hist if t == status]
    return max(dates) if dates else None

def customer_review_applies(text):
    m = re.search(r"^\|\s*Customer review\s*\|\s*([^|]*?)\s*\|", text, re.M | re.I)
    return not (m and m.group(1).replace("`", "").strip().upper() == "N/A")

DEP_EXPLICIT = re.compile(r"^-\s+(?:\*\*)?\s*(?:blocked by|depends on)\s+[`\[(]*(?:[\w./-]*/)?(US\d{3})\b",
                          re.I)
DEP_TEMPLATE = re.compile(r"^-\s+[`\[]*(US\d{3})(?:\.md)?[`\]]*(?:\([^)]*\))?\s+\(")

def dependencies(text, own):
    """The US### a story waits on. Two shapes only, so prose that merely names a story is never
    read as a dependency: the template's `- US### (title — reason)`, and an explicit
    `- Blocked by US###` / `- Depends on US###` (bold, backticks and a path prefix allowed)."""
    deps = []
    for line in section(text, "Dependencies"):
        m = DEP_EXPLICIT.match(line) or DEP_TEMPLATE.match(line)
        if m and m.group(1) != own and m.group(1) not in deps:
            deps.append(m.group(1))
    return deps

def sprint_members(text):
    return [r[0].replace("`", "") for r in table_rows(section(text, "Story Summary"))
            if re.fullmatch(r"US\d{3}", r[0].replace("`", ""))]

def map_slices(text):
    """[(slice, story_cell, cut?)] from the first table under `## Slices`. A slice id is `S-01`
    or `S1`; it is cut when its Story cell holds one or more US### and nothing else."""
    out = []
    for r in table_rows(section(text, "Slices")):
        sid = r[0].replace("`", "").strip()
        if re.fullmatch(r"S-?\d+", sid) and len(r) > 1:
            cell = r[1].replace("`", "").strip()
            cut = bool(re.fullmatch(r"US\d{3}(?:\s*(?:,|and|&)\s*US\d{3})*", cell))
            out.append((sid, cell, cut))
    return out

# ── The registers ─────────────────────────────────────────────────────────────

class Item:
    def __init__(self, kind, path, match):
        self.kind, self.path = kind, Path(path)
        self.id = match.group(1)
        self.archived = self.path.parent.name == "archive"
        self.text = read(self.path)
        self.parent_id = None
        if kind.key == "sprint-plans":
            self.parent_id = "SPRINT-" + match.group(2)
        elif kind.key == "story-plans":
            self.parent_id = match.group(2)
        self.title = read_title(self.text, self.id)
        if kind.parent:
            self.status, self.note = None, ""
        else:
            self.status, self.note = read_status(self.text)

    @property
    def rel(self):
        return rel(self.path)


def scan(kind):
    items = []
    for d in (kind.dir, kind.dir / "archive"):
        if not d.is_dir():
            continue
        for p in sorted(d.iterdir()):
            if not p.is_file() or "TEMPLATE" in p.name:
                continue
            m = kind.pattern.match(p.name)
            if m:
                items.append(Item(kind, p, m))
    return sorted(items, key=lambda i: (i.id, i.archived))

_CACHE = {}
def items(key):
    if key not in _CACHE:
        _CACHE[key] = scan(KINDS[key])
    return _CACHE[key]

def find(key, ident):
    """Resolve an ID across the folder AND its archive/ — the one lookup every reader uses."""
    for i in items(key):
        if i.id == ident:
            return i
    return None

def plans_of(parent_key, ident):
    key = "story-plans" if parent_key == "stories" else "sprint-plans"
    return [p for p in items(key) if p.parent_id == ident] if parent_key != "maps" else []

def effective_status(item):
    """The status a board files this item under: its own, or its parent's for a plan."""
    if item.kind.parent:
        parent = find(item.kind.parent, item.parent_id)
        return (parent.status, parent) if parent else (None, None)
    return item.status, item

def column_of(item):
    """(column title, warning-or-None)."""
    status, owner = effective_status(item)
    if item.archived or (owner is not None and owner.archived):
        if status != "Closed":
            return "Closed", f"{item.id} sits in archive/ but its status reads {status!r}, not 'Closed'"
        return "Closed", None
    if owner is None:
        return "Unrecognised", f"{item.id}: parent {item.parent_id} not found in its folder or archive/"
    if status in item.kind.statuses:
        return status, None
    return "Unrecognised", f"{item.id}: status {status!r} is not in the {item.kind.noun} vocabulary"

def kind_of_id(ident):
    if re.fullmatch(r"US\d{3}", ident):
        return "stories"
    if re.fullmatch(r"SPRINT-\d{2}", ident):
        return "sprints"
    if re.fullmatch(r"MAP-[A-Z0-9][A-Z0-9-]*", ident):
        return "maps"
    return None

# ── Clock, eligibility, warnings ──────────────────────────────────────────────

def answer(name, default):
    text = read(ROOT / ".copier-answers.yml")
    m = re.search(r"^" + name + r":[ \t]*['\"]?(\d+)['\"]?[ \t]*$", text, re.M)
    return int(m.group(1)) if m else default

def today():
    forced = os.environ.get("PM_TODAY", "").strip()
    if not forced:
        return datetime.date.today()
    d = parse_date(forced)
    if d is None:
        print(f"ERROR: PM_TODAY={forced!r} is not a DD/MM/YYYY date", file=sys.stderr)
        sys.exit(2)
    return d

def ready_for_completed(story):
    """Date the story may move to Completed, or None when the clock cannot be read."""
    cr, fb = answer("CUSTOMER_REVIEW_WEEKS", 2), answer("FEEDBACK_WEEKS", 4)
    hist = history(story.text)
    week = datetime.timedelta(weeks=1)
    if story.status == "Customer Accepted":
        a, r = last_entered(hist, "Customer Accepted"), last_entered(hist, "Customer Review")
        if not a:
            return None
        cands = [a + fb * week] + ([r + (cr + fb) * week] if r else [])
        return max(cands)
    if story.status == "Accepted" and not customer_review_applies(story.text):
        acc = last_entered(hist, "Accepted")
        return acc + fb * week if acc else None
    return None

def eligibility(item):
    """[] when the item may be archived, else the reasons it may not."""
    why = []
    if item.archived:
        return [f"{item.id} is already archived ({item.rel})"]
    k = item.kind.key
    if k == "stories" and item.status != "Completed":
        why.append(f"status is {item.status!r}; a story is archived only from 'Completed'")
    if k == "sprints":
        members = sprint_members(item.text)
        if not members:
            why.append("no US### rows found in its ## Story Summary table")
        for sid in members:
            s = find("stories", sid)
            if not s:
                why.append(f"member {sid} not found in 02-STORIES/ or its archive/")
            elif s.status != "Closed":
                why.append(f"member {sid} is {s.status!r}, not 'Closed'")
    if k == "maps":
        if item.status != "Complete":
            why.append(f"status is {item.status!r}; a map is archived only from 'Complete'")
        slices = map_slices(item.text)
        if not slices:
            why.append("no slice rows (S-01 or S1) found in its ## Slices table")
        for sid, cell, cut in slices:
            if not cut:
                why.append(f"slice {sid} is not cut into a story (Story cell reads {cell or 'empty'!r})")
    return why

def warnings():
    out = []
    now = today()
    for key in ORDER:
        for i in items(key):
            _col, w = column_of(i)
            if w:
                out.append(w)
    for s in items("stories"):
        if s.archived:
            continue
        if s.status == "Blocked":
            deps = dependencies(s.text, s.id)
            found = [find("stories", d) for d in deps]
            if deps and all(f and f.status in ("Completed", "Closed") for f in found):
                out.append(f"{s.id} is Blocked, but every dependency ({', '.join(deps)}) is "
                           "Completed or Closed — move it to Pending")
        if s.status in ("Customer Accepted", "Accepted"):
            due = ready_for_completed(s)
            if due and now >= due:
                out.append(f"{s.id} is {s.status} and its window closed {due:%d/%m/%Y} — "
                           "ready for Completed")
        if s.status == "Completed":
            out.append(f"{s.id} is Completed — ready to archive (pm-archive.sh {s.id})")
    for sp in items("sprints"):
        if sp.archived or sp.status == "Closed":
            continue
        found = [find("stories", m) for m in sprint_members(sp.text)]
        if found and all(f and f.status == "Closed" for f in found):
            out.append(f"{sp.id}: every story in it is Closed — set it Closed and archive it "
                       f"(pm-archive.sh {sp.id})")
    for m in items("maps"):
        if not m.archived and m.status == "Complete" and not eligibility(m):
            out.append(f"{m.id} is Complete and every slice is cut — ready to archive "
                       f"(pm-archive.sh {m.id})")
    return out

# ── Markdown tables, padded the way Prettier pads ────────────────────────────

def width(s):
    w = 0
    for ch in s:
        if unicodedata.combining(ch) or unicodedata.category(ch) in ("Mn", "Me", "Cf"):
            continue
        w += 2 if unicodedata.east_asian_width(ch) in ("W", "F") else 1
    return w

def cell(s):
    return str(s).replace("|", "\\|").replace("\n", " ").strip()

def render_table(header, rows):
    grid = [[cell(c) for c in header]] + [[cell(c) for c in r] for r in rows]
    widths = [max(3, *(width(r[i]) for r in grid)) for i in range(len(header))]
    def line(r):
        return "| " + " | ".join(c + " " * (widths[i] - width(c)) for i, c in enumerate(r)) + " |"
    out = [line(grid[0]), "| " + " | ".join("-" * w for w in widths) + " |"]
    return out + [line(r) for r in grid[1:]]

def append_history_row(text, date, frm, to, note):
    """Append one row to `## Status history`, creating the section at the end if absent."""
    row = [date, frm, to, note]
    lines = text.split("\n")
    start = next((i for i, l in enumerate(lines) if re.match(r"^## +Status history\s*$", l)), None)
    if start is None:
        body = text.rstrip("\n") + "\n\n## Status history\n\n"
        return body + "\n".join(render_table(["Date", "From", "To", "Note"], [row])) + "\n"
    i = start + 1
    while i < len(lines) and not lines[i].strip().startswith("|"):
        if re.match(r"^## ", lines[i]):
            break
        i += 1
    j = i
    while j < len(lines) and lines[j].strip().startswith("|"):
        j += 1
    rows = table_rows(lines[i:j])
    header = rows[0] if rows else ["Date", "From", "To", "Note"]
    body = [r + [""] * (len(header) - len(r)) for r in rows[1:]] + [row]
    table = render_table(header, body)
    if i == j:
        table = table + [""]
    return "\n".join(lines[:i] + table + lines[j:])

def set_status(text, value):
    """Rewrite the first status line to `**Status:** <value>` (its old note is dropped)."""
    return STATUS_LINE.sub(lambda m: f"**Status:** {value}", text, count=1)
PYEOF
)
