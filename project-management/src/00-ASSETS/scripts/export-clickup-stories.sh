#!/usr/bin/env bash
# export-clickup-stories.sh — Generate client-friendly, ClickUp-ready Markdown per story.
#
# For every US###.md in 01-STORIES, emits a stripped US###-CLIENT.md into
# project-management/export/clickup/ containing ONLY the client-facing fields:
#
#   - Title          (h1)
#   - Status         (board status — mirrors the ClickUp status field)
#   - MoSCoW         (priority)
#   - Story Points   (headline SP)
#   - Client Summary (the ## Client Summary section)
#   - User Story     (the ## User Story section)
#
# Acceptance Criteria, Tasks, Dependencies, DB, etc. are deliberately omitted —
# those are internal-only and never leave for ClickUp.
#
# The generated US###-CLIENT.md files are written read-only (0444): this script is
# the only sanctioned writer. To change one, edit the SOURCE story in 01-STORIES/
# and re-run. A lefthook pre-commit hook regenerates them on commit.
#
# Usage: bash export-clickup-stories.sh [US###] [--help]
#
#   US###   Optional single story to (re)generate, e.g. US014. Omit for all stories.
#
# Examples:
#   bash export-clickup-stories.sh           → regenerate every story
#   bash export-clickup-stories.sh US014     → regenerate only US014-CLIENT.md
#
# Requires: python3 (stdlib only — no external packages).
# Exit codes: 0 = success  1 = generation failed  2 = preflight error
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
STORIES_DIR="$PROJECT_ROOT/project-management/src/01-STORIES"
OUTPUT_DIR="$PROJECT_ROOT/project-management/export/clickup"

# ── Helpers ───────────────────────────────────────────────────────────────────

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 2; }

# ── Argument parsing ──────────────────────────────────────────────────────────

ONLY=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      bold "export-clickup-stories.sh"
      echo ""
      echo "  Generate client-friendly, ClickUp-ready Markdown per story."
      echo "  Keeps: title, Status, MoSCoW, Story Points, Client Summary, User Story."
      echo "  Omits: Acceptance Criteria, Tasks, Dependencies, DB — internal only."
      echo ""
      echo "  Usage: bash export-clickup-stories.sh [US###]"
      echo ""
      echo "  Examples:"
      echo "    bash export-clickup-stories.sh         → regenerate every story"
      echo "    bash export-clickup-stories.sh US014   → regenerate only US014"
      exit 0
      ;;
    US[0-9]*)
      ONLY="$1"
      shift
      ;;
    -*)
      die "Unknown flag: '$1'. Use --help for usage."
      ;;
    *)
      die "Unexpected argument: '$1'. Pass a story id like US014, or --help."
      ;;
  esac
done

# ── Preflight ─────────────────────────────────────────────────────────────────

[[ -d "$STORIES_DIR" ]] || die "Stories directory not found: $STORIES_DIR"
command -v python3 >/dev/null 2>&1 || die "python3 not found on PATH."
mkdir -p "$OUTPUT_DIR"

bold "Generating ClickUp story exports …"
log "Source : $STORIES_DIR"
log "Output : $OUTPUT_DIR"
[[ -n "$ONLY" ]] && log "Scope  : $ONLY only" || log "Scope  : all stories"

# ── Extract & emit (pure Python stdlib) ───────────────────────────────────────

python3 - "$STORIES_DIR" "$OUTPUT_DIR" "$ONLY" << 'PYEOF'
import sys, os, re, pathlib

stories_dir = pathlib.Path(sys.argv[1])
out_dir     = pathlib.Path(sys.argv[2])
only        = sys.argv[3].strip()

def clean_status(raw):
    """Status value, stripped of any ' — note' or ' (parenthetical)' suffix."""
    s = re.sub(r'\*\*', '', raw).strip()
    s = re.split(r'\s+[—–-]\s+', s)[0]   # cut em/en/hyphen-dash note
    s = re.split(r'\s*\(', s)[0]         # cut '(merged via PR …)'
    return s.strip()

def field_first_line(lines, heading):
    """First non-blank line under a '## heading' section."""
    pat = re.compile(r'^##\s+' + re.escape(heading) + r'\s*$')
    for i, line in enumerate(lines):
        if pat.match(line):
            j = i + 1
            while j < len(lines) and lines[j].strip() == '':
                j += 1
            return lines[j].strip() if j < len(lines) else ''
    return ''

def section_body(lines, heading):
    """Lines under '## heading' until the next '## ' or a '---' rule."""
    pat = re.compile(r'^##\s+' + re.escape(heading) + r'\s*$')
    out, capturing = [], False
    for line in lines:
        if capturing:
            if re.match(r'^##\s+', line):
                break
            if re.match(r'^---+\s*$', line.strip()):
                break
            out.append(line)
        elif pat.match(line):
            capturing = True
    return '\n'.join(out).strip()

def extract(content):
    content = re.sub(r'<!--.*?-->', '', content, flags=re.DOTALL)
    lines = content.replace('\r\n', '\n').replace('\r', '\n').split('\n')

    tm = re.search(r'^#\s+(.+)$', content, re.M)
    title = tm.group(1).strip() if tm else '(untitled)'

    sm = re.search(r'^\*\*Status:\*\*\s*(.+)$', content, re.M)
    status = clean_status(sm.group(1)) if sm else ''

    mraw = field_first_line(lines, 'MoSCoW Priority')
    mm = re.search(r"(Must|Should|Could|Won['’]?t)\s+Have", mraw)
    moscow = mm.group(0) if mm else re.sub(r'\*\*', '', mraw).strip()

    sraw = field_first_line(lines, 'Story Points')
    spm = re.search(r'\d+', sraw)
    sp = spm.group(0) if spm else re.sub(r'\*\*', '', sraw).strip()

    return {
        'title':   title,
        'status':  status or '—',
        'moscow':  moscow or '—',
        'sp':      sp or '—',
        'summary': section_body(lines, 'Client Summary') or '_No client summary provided._',
        'story':   section_body(lines, 'User Story') or '_No user story provided._',
    }

def render(d):
    return (
        f"# {d['title']}\n\n"
        "| Status | MoSCoW | Story Points |\n"
        "| --- | --- | --- |\n"
        f"| {d['status']} | {d['moscow']} | {d['sp']} |\n\n"
        "## Client Summary\n\n"
        f"{d['summary']}\n\n"
        "## User Story\n\n"
        f"{d['story']}\n"
    )

# Gather source stories (US###.md, number > 0, exclude template).
def us_num(p):
    m = re.search(r'US(\d+)', p.name)
    return int(m.group(1)) if m else -1

sources = sorted(
    [p for p in stories_dir.glob('US[0-9]*.md')
     if '-TEMPLATE' not in p.name and us_num(p) > 0],
    key=us_num,
)
if only:
    sources = [p for p in sources if p.stem == only]
    if not sources:
        print(f"ERROR: story '{only}' not found in {stories_dir}", file=sys.stderr)
        sys.exit(2)

# Clean stale per-story exports only when doing a full run (preserve CONTEXT/CLAUDE).
if not only:
    for old in out_dir.glob('US[0-9]*-CLIENT.md'):
        old.unlink()

count = 0
for src in sources:
    data = extract(src.read_text(encoding='utf-8'))
    dest = out_dir / f"{src.stem}-CLIENT.md"
    if dest.exists():
        dest.chmod(0o644)          # flip a previously read-only file back to writable
    dest.write_text(render(data), encoding='utf-8')
    dest.chmod(0o444)              # read-only: this script is the only sanctioned writer
    count += 1

print(f"  Wrote {count} client export file(s) (read-only 0444).")
PYEOF

bold "Done."
log "Files  : $(find "$OUTPUT_DIR" -name 'US[0-9]*-CLIENT.md' | wc -l) in $OUTPUT_DIR"
