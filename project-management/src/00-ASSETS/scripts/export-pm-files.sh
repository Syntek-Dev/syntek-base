#!/usr/bin/env bash
# export-pm-files.sh — Convert project-management Markdown docs to a paginated PDF.
#
# Usage: bash export-pm-files.sh [--type TYPE] [OUTPUT_NAME] [--help]
#
#   --type TYPE  Document type to export. Omit to export ALL types at once.
#                  stories      User stories (US*.md) — 01-STORIES, numeric sort
#                  sprints      Sprint summaries — 02-SPRINTS, numeric sort
#                  database     Schema, ERDs, migrations — 03-DATABASE
#                  user-flow    User flow diagrams & docs — 04-USER-FLOW
#                  gdpr         GDPR compliance docs — 08-GDPR
#                  security     Threat models, audits, assessments — 09-SECURITY
#                  qa           QA reports and test plans — 10-QA
#                  seo          SEO reports and planning — 11-SEO
#                  api-design   API design specs — 12-API-DESIGN
#                  sprint-plans Sprint planning docs — 14-SPRINT-PLANS
#
#   OUTPUT_NAME  Optional filename (with or without .pdf extension).
#                Saved into project-management/export/.
#                Defaults to the type's standard name if omitted.
#                Ignored when exporting all types (each uses its default name).
#
# Examples:
#   bash export-pm-files.sh                              → all types exported
#   bash export-pm-files.sh --type stories "Stories v2" → Stories-v2.pdf
#   bash export-pm-files.sh --type sprints              → SPRINTS.pdf
#   bash export-pm-files.sh --type qa "Sprint 09 QA"   → Sprint-09-QA.pdf
#   bash export-pm-files.sh --type api-design v3        → v3.pdf
#
# Requires:
#   - google-chrome (or chromium-browser) for HTML → PDF conversion
#   - python3 (stdlib only — no external packages needed)
#
# Exit codes: 0 = success  1 = export failed  2 = preflight error
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
PM_SRC="$PROJECT_ROOT/project-management/src"
OUTPUT_DIR="$PROJECT_ROOT/project-management/export"

# ── Helpers ───────────────────────────────────────────────────────────────────

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# ── Argument parsing ──────────────────────────────────────────────────────────

DOC_TYPE=""
raw_name=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --help|-h)
      bold "export-pm-files.sh"
      echo ""
      echo "  Convert project-management Markdown docs to a paginated A4 PDF."
      echo ""
      echo "  Usage: bash export-pm-files.sh [--type TYPE] [OUTPUT_NAME]"
      echo ""
      echo "  Omit --type to export ALL document types at once (each uses its default name)."
      echo ""
      echo "  --type TYPE  Document type to export"
      printf "    %-14s %s\n" \
        "stories"      "User stories (US*.md) — 01-STORIES, numeric sort" \
        "sprints"      "Sprint summaries — 02-SPRINTS, numeric sort" \
        "database"     "Schema, ERDs, migrations — 03-DATABASE" \
        "user-flow"    "User flow diagrams & docs — 04-USER-FLOW" \
        "gdpr"         "GDPR compliance docs — 08-GDPR" \
        "security"     "Threat models, audits, assessments — 09-SECURITY" \
        "qa"           "QA reports and test plans — 10-QA" \
        "seo"          "SEO reports and planning — 11-SEO" \
        "api-design"   "API design specs — 12-API-DESIGN" \
        "sprint-plans"    "Sprint planning docs — 14-SPRINT-PLANS" \
        "client-approval" "Stories + user flows stripped to client-readable content"
      echo ""
      echo "  OUTPUT_NAME  Saved into project-management/export/."
      echo "               Defaults to the type's standard name. Spaces → hyphens."
      echo ""
      echo "  Note: --type client-approval is NOT included in the bulk export (no --type)."
      echo "        It is a manual export intended for client sign-off."
      echo ""
      echo "  Examples:"
      echo "    bash export-pm-files.sh                                  → all types exported"
      echo "    bash export-pm-files.sh --type stories                   → USER-STORIES.pdf"
      echo "    bash export-pm-files.sh --type sprints                   → SPRINTS.pdf"
      echo "    bash export-pm-files.sh --type qa 'Sprint 09 QA'        → Sprint-09-QA.pdf"
      echo "    bash export-pm-files.sh --type client-approval           → CLIENT-APPROVAL.pdf"
      echo "    bash export-pm-files.sh --type client-approval 'Sprint 10 Review' → Sprint-10-Review.pdf"
      echo ""
      echo "  Requires: google-chrome (or chromium-browser) + python3 (stdlib)"
      exit 0
      ;;
    --type=*)
      DOC_TYPE="${1#--type=}"
      shift
      ;;
    --type)
      [[ $# -ge 2 ]] || die "--type requires a value."
      DOC_TYPE="$2"
      shift 2
      ;;
    -*)
      die "Unknown flag: '$1'. Use --help for usage."
      ;;
    *)
      raw_name="$1"
      shift
      ;;
  esac
done

# ── Run all types when no --type given ───────────────────────────────────────

ALL_TYPES=(stories sprints database user-flow gdpr security qa seo api-design sprint-plans)

if [[ -z "$DOC_TYPE" ]]; then
  bold "Exporting all document types …"
  echo ""
  failed=()
  for t in "${ALL_TYPES[@]}"; do
    bold "→ $t"
    if bash "$0" --type "$t"; then
      echo ""
    else
      failed+=("$t")
      echo ""
    fi
  done
  if [[ ${#failed[@]} -gt 0 ]]; then
    printf '\033[31mERROR:\033[0m Failed types: %s\n' "${failed[*]}" >&2
    exit 1
  fi
  bold "All exports complete."
  exit 0
fi

# ── Type configuration ────────────────────────────────────────────────────────

case "$DOC_TYPE" in
  stories)
    SRC_DIR="$PM_SRC/01-STORIES"
    SORT_TYPE="numeric-us"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="USER-STORIES"
    DOC_TITLE="<%PROJECT_NAME%> — User Stories"
    ;;
  sprints)
    SRC_DIR="$PM_SRC/02-SPRINTS"
    SORT_TYPE="numeric-sprint"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="SPRINTS"
    DOC_TITLE="<%PROJECT_NAME%> — Sprints"
    ;;
  database)
    SRC_DIR="$PM_SRC/03-DATABASE"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="DATABASE"
    DOC_TITLE="<%PROJECT_NAME%> — Database"
    ;;
  user-flow)
    SRC_DIR="$PM_SRC/04-USER-FLOW"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="USER-FLOWS"
    DOC_TITLE="<%PROJECT_NAME%> — User Flows"
    ;;
  gdpr)
    SRC_DIR="$PM_SRC/08-GDPR"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="GDPR"
    DOC_TITLE="<%PROJECT_NAME%> — GDPR"
    ;;
  security)
    SRC_DIR="$PM_SRC/09-SECURITY"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="SECURITY"
    DOC_TITLE="<%PROJECT_NAME%> — Security"
    ;;
  qa)
    SRC_DIR="$PM_SRC/10-QA"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="QA"
    DOC_TITLE="<%PROJECT_NAME%> — QA"
    ;;
  seo)
    SRC_DIR="$PM_SRC/11-SEO"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="SEO"
    DOC_TITLE="<%PROJECT_NAME%> — SEO"
    ;;
  api-design)
    SRC_DIR="$PM_SRC/12-API-DESIGN"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="API-DESIGN"
    DOC_TITLE="<%PROJECT_NAME%> — API Design"
    ;;
  sprint-plans)
    SRC_DIR="$PM_SRC/14-SPRINT-PLANS"
    SORT_TYPE="alpha"
    EXCLUDE_NAMES="CONTEXT.md"
    DEFAULT_NAME="SPRINT-PLANS"
    DOC_TITLE="<%PROJECT_NAME%> — Sprint Plans"
    ;;
  client-approval)
    SRC_DIR="$PM_SRC"
    SORT_TYPE="client-approval"
    EXCLUDE_NAMES="CONTEXT.md,US000-TEMPLATE.md"
    DEFAULT_NAME="CLIENT-APPROVAL"
    DOC_TITLE="<%PROJECT_NAME%> — Client Approval Pack"
    ;;
  *)
    die "Unknown type: '$DOC_TYPE'. Valid types: stories sprints database user-flow gdpr security qa seo api-design sprint-plans client-approval. Omit --type to export all."
    ;;
esac

# ── Resolve output filename ───────────────────────────────────────────────────

[[ -n "$raw_name" ]] || raw_name="$DEFAULT_NAME"
clean_name="${raw_name%.pdf}"
clean_name="${clean_name// /-}"
OUTPUT_PDF="$OUTPUT_DIR/${clean_name}.pdf"

# ── Locate Chrome ─────────────────────────────────────────────────────────────

CHROME=""
for candidate in /usr/bin/google-chrome /usr/bin/chromium-browser /snap/bin/chromium; do
  if [[ -x "$candidate" ]]; then
    CHROME="$candidate"
    break
  fi
done
[[ -n "$CHROME" ]] || die "Chrome/Chromium not found. Install google-chrome or chromium-browser."

# ── Preflight ─────────────────────────────────────────────────────────────────

if [[ "$DOC_TYPE" == "client-approval" ]]; then
  _s=$(find "$PM_SRC/01-STORIES" -name "US[0-9]*.md" 2>/dev/null | wc -l)
  _f=$(find "$PM_SRC/04-USER-FLOW" -name "USER-FLOW-*.md" 2>/dev/null | wc -l)
  file_count=$((_s + _f))
else
  file_count=$(find "$SRC_DIR" -name "*.md" ! -name "CONTEXT.md" 2>/dev/null | wc -l)
fi
[[ "$file_count" -gt 0 ]] || die "No content files found in: $SRC_DIR"

bold "Preflight checks …"
log "Type    : $DOC_TYPE"
if [[ "$DOC_TYPE" == "client-approval" ]]; then
  log "Source  : 01-STORIES + 04-USER-FLOW"
else
  log "Source  : $SRC_DIR"
fi
log "Files   : ~$file_count .md files"
log "Chrome  : $CHROME"
log "Output  : $OUTPUT_PDF"

# ── Temp directory ────────────────────────────────────────────────────────────

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT
TEMP_HTML="$TMP_DIR/docs.html"

# ── Convert MD → HTML (pure Python stdlib) ────────────────────────────────────

bold "Converting Markdown → HTML …"

python3 - "$SRC_DIR" "$TEMP_HTML" "$SORT_TYPE" "$EXCLUDE_NAMES" "$DOC_TITLE" << 'PYEOF'
import sys, os, re
import html as html_module
import pathlib

src_dir     = sys.argv[1]
output_html = sys.argv[2]
sort_type   = sys.argv[3]
exclude_raw = sys.argv[4]
doc_title   = sys.argv[5]

exclude_names = set(n.strip() for n in exclude_raw.split(',') if n.strip())

# ── Inline escaping & formatting ─────────────────────────────────────────────

def esc(text):
    return html_module.escape(str(text))

def inline(text, base_dir=None):
    def _img(m):
        alt = m.group(1)
        src = m.group(2)
        if base_dir and not src.startswith(('http://', 'https://', 'file://', '/', 'data:')):
            abs_path = (pathlib.Path(base_dir) / src).resolve()
            if abs_path.exists():
                src = abs_path.as_uri()
        return (
            f'<img src="{src}" alt="{alt}" '
            f'style="max-width:100%;height:auto;display:block;margin:0.75em 0;">'
        )
    parts = re.split(r'(`[^`]+`)', text)
    out = []
    for part in parts:
        if part.startswith('`') and part.endswith('`') and len(part) > 1:
            out.append(f'<code>{esc(part[1:-1])}</code>')
        else:
            p = esc(part)
            p = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', p)
            p = re.sub(r'\*(.+?)\*',     r'<em>\1</em>',         p)
            p = re.sub(r'~~(.+?)~~',     r'<del>\1</del>',        p)
            p = re.sub(r'!\[([^\]]*)\]\(([^)]+)\)', _img, p)
            p = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', p)
            out.append(p)
    return ''.join(out)

# ── Table parser ──────────────────────────────────────────────────────────────

def parse_table(lines, start, base_dir=None):
    raw_rows = []
    i = start
    while i < len(lines):
        s = lines[i].strip()
        if s.startswith('|') and s.endswith('|'):
            cells = [c.strip() for c in s[1:-1].split('|')]
            raw_rows.append(cells)
            i += 1
        else:
            break

    sep = -1
    for ri, row in enumerate(raw_rows):
        if row and all(re.match(r'^[-:]+$', c) for c in row if c):
            sep = ri
            break

    html = ['<table>']
    if sep >= 1:
        html.append('<thead>')
        for row in raw_rows[:sep]:
            html.append('<tr>' + ''.join(f'<th>{inline(c, base_dir)}</th>' for c in row) + '</tr>')
        html.append('</thead><tbody>')
        for row in raw_rows[sep + 1:]:
            html.append('<tr>' + ''.join(f'<td>{inline(c, base_dir)}</td>' for c in row) + '</tr>')
    else:
        html.append('<tbody>')
        for row in raw_rows:
            html.append('<tr>' + ''.join(f'<td>{inline(c, base_dir)}</td>' for c in row) + '</tr>')
    html.append('</tbody></table>')
    return '\n'.join(html), i

# ── Block converter ───────────────────────────────────────────────────────────

def convert(md_text, base_dir=None):
    lines = md_text.replace('\r\n', '\n').replace('\r', '\n').split('\n')
    out   = []
    para  = []
    i     = 0

    def flush_para():
        if para:
            out.append(f'<p>{" ".join(para)}</p>')
            para.clear()

    while i < len(lines):
        line     = lines[i]
        stripped = line.strip()

        # ── Fenced code block ─────────────────────────────────────────────
        if stripped.startswith('```'):
            flush_para()
            lang = stripped[3:].strip()
            code_lines = []
            i += 1
            while i < len(lines) and not lines[i].strip().startswith('```'):
                code_lines.append(esc(lines[i]))
                i += 1
            lang_attr = f' class="{esc(lang)}"' if lang else ''
            out.append(f'<pre><code{lang_attr}>' + '\n'.join(code_lines) + '</code></pre>')
            i += 1
            continue

        # ── Blank line ────────────────────────────────────────────────────
        if not stripped:
            flush_para()
            i += 1
            continue

        # ── Table ─────────────────────────────────────────────────────────
        if stripped.startswith('|') and stripped.endswith('|'):
            flush_para()
            tbl_html, i = parse_table(lines, i, base_dir)
            out.append(tbl_html)
            continue

        # ── Horizontal rule ───────────────────────────────────────────────
        if re.match(r'^[-*_]{3,}\s*$', stripped):
            flush_para()
            out.append('<hr>')
            i += 1
            continue

        # ── Blockquote ────────────────────────────────────────────────────
        if stripped.startswith('>'):
            flush_para()
            bq_lines = []
            while i < len(lines) and lines[i].strip().startswith('>'):
                bq_lines.append(inline(lines[i].strip().lstrip('>').lstrip(), base_dir))
                i += 1
            inner = '</p><p>'.join(bq_lines)
            out.append(f'<blockquote><p>{inner}</p></blockquote>')
            continue

        # ── ATX headers ───────────────────────────────────────────────────
        m = re.match(r'^(#{1,6})\s+(.+)$', line)
        if m:
            flush_para()
            lvl  = len(m.group(1))
            text = inline(m.group(2), base_dir)
            out.append(f'<h{lvl}>{text}</h{lvl}>')
            i += 1
            continue

        # ── Unordered list (incl. checkboxes) ────────────────────────────
        m = re.match(r'^(\s*)[-*+]\s+(.+)$', line)
        if m:
            flush_para()
            indent0 = len(m.group(1))
            items = []
            while i < len(lines):
                lm = re.match(r'^(\s*)[-*+]\s+(.+)$', lines[i])
                if not lm or len(lm.group(1)) < indent0:
                    break
                text = lm.group(2)
                if re.match(r'^\[ \]\s', text):
                    items.append(f'<li class="task">&#9744; {inline(text[3:].lstrip(), base_dir)}')
                elif re.match(r'^\[x\]\s', text, re.IGNORECASE):
                    items.append(f'<li class="task done">&#9745; {inline(text[3:].lstrip(), base_dir)}')
                else:
                    items.append(f'<li>{inline(text, base_dir)}')
                i += 1
            out.append('<ul>' + '</li>'.join(items) + '</li></ul>')
            continue

        # ── Ordered list ──────────────────────────────────────────────────
        m = re.match(r'^(\s*)\d+[.)]\s+(.+)$', line)
        if m:
            flush_para()
            indent0 = len(m.group(1))
            items = []
            while i < len(lines):
                lm = re.match(r'^(\s*)\d+[.)]\s+(.+)$', lines[i])
                if not lm or len(lm.group(1)) < indent0:
                    break
                items.append(f'<li>{inline(lm.group(2), base_dir)}')
                i += 1
            out.append('<ol>' + '</li>'.join(items) + '</li></ol>')
            continue

        # ── Paragraph (continuation) ──────────────────────────────────────
        para.append(inline(stripped, base_dir))
        i += 1

    flush_para()
    return '\n'.join(out)

# ── Client-approval content extractors ───────────────────────────────────────

_STORY_KEEP = {'client summary', 'user story', 'moscow priority'}
_FLOW_STRIP = {
    'api design', 'security mitigations', 'security planning notes',
    'gdpr considerations', 'seo considerations',
}

def extract_story_for_client(md):
    """Keep only h1 title, Client Summary, User Story, and MoSCoW Priority."""
    lines = md.replace('\r\n', '\n').replace('\r', '\n').split('\n')
    result, in_keep, past_h2 = [], False, False
    for line in lines:
        if re.match(r'^#\s+[^#]', line):
            result.append(line)
            in_keep = False
            continue
        m = re.match(r'^##\s+(.+)$', line)
        if m:
            past_h2 = True
            in_keep = any(k in m.group(1).strip().lower() for k in _STORY_KEEP)
            if in_keep:
                result.append(line)
            continue
        if past_h2 and in_keep:
            result.append(line)
    return '\n'.join(result)

def extract_flow_for_client(md):
    """Keep numbered flow sections + their images; strip Mermaid code and technical appendix sections."""
    lines = md.replace('\r\n', '\n').replace('\r', '\n').split('\n')
    result, in_keep, in_mermaid = [], True, False
    for line in lines:
        stripped = line.strip()
        if stripped.startswith('```mermaid'):
            in_mermaid = True
            continue
        if in_mermaid:
            if stripped == '```':
                in_mermaid = False
            continue
        m = re.match(r'^##\s+(.+)$', line)
        if m:
            in_keep = not any(t in m.group(1).strip().lower() for t in _FLOW_STRIP)
            if in_keep:
                result.append(line)
            continue
        if in_keep:
            result.append(line)
    return '\n'.join(result)

# ── Gather & sort files ───────────────────────────────────────────────────────

src_path  = pathlib.Path(src_dir)
all_files = [f for f in src_path.rglob('*.md') if f.name not in exclude_names and '-TEMPLATE' not in f.name]

if sort_type == 'numeric-us':
    md_files = sorted(
        [f for f in all_files
         if re.search(r'US(\d+)', f.name)
         and int(re.search(r'US(\d+)', f.name).group(1)) > 0],
        key=lambda f: int(re.search(r'US(\d+)', f.name).group(1))
    )
elif sort_type == 'numeric-sprint':
    def sprint_key(f):
        m = re.search(r'(\d+)', f.name)
        return int(m.group(1)) if m else 0
    md_files = sorted(
        [f for f in all_files if sprint_key(f) > 0],
        key=sprint_key
    )
elif sort_type == 'client-approval':
    stories = sorted(
        [f for f in all_files
         if '01-STORIES' in str(f)
         and re.search(r'US(\d+)', f.name)
         and int(re.search(r'US(\d+)', f.name).group(1)) > 0],
        key=lambda f: int(re.search(r'US(\d+)', f.name).group(1))
    )
    flows = sorted(
        [f for f in all_files if '04-USER-FLOW' in str(f)],
        key=lambda f: f.name.lower()
    )
    md_files = stories + flows
else:  # alpha
    md_files = sorted(all_files, key=lambda f: f.name.lower())

if not md_files:
    print(f'ERROR: No content files found after filtering in {src_dir}', file=sys.stderr)
    sys.exit(2)

# ── Convert ───────────────────────────────────────────────────────────────────

body_parts = []
for md_file in md_files:
    with open(md_file, encoding='utf-8') as fh:
        raw = fh.read()
    raw = re.sub(r'<!--.*?-->', '', raw, flags=re.DOTALL)
    if sort_type == 'client-approval':
        if '01-STORIES' in str(md_file):
            raw = extract_story_for_client(raw)
        else:
            raw = extract_flow_for_client(raw)
    body_parts.append(convert(raw, base_dir=str(md_file.parent)))

body = '\n'.join(body_parts)

# ── HTML document ─────────────────────────────────────────────────────────────

html_doc = (
    '<!DOCTYPE html>\n'
    '<html lang="en-GB">\n'
    '<head>\n'
    '<meta charset="UTF-8">\n'
    '<title>' + esc(doc_title) + '</title>\n'
    '<style>\n'
    '\n'
    '@page { size: A4 portrait; margin: 2cm; }\n'
    '\n'
    '*, *::before, *::after { box-sizing: border-box; }\n'
    '\n'
    'body {\n'
    '  font-family: "Inter", "Helvetica Neue", system-ui, sans-serif;\n'
    '  font-size: 10.5pt;\n'
    '  line-height: 1.65;\n'
    '  color: #1a1a2e;\n'
    '  background: white;\n'
    '}\n'
    '\n'
    'h1 {\n'
    '  font-size: 17pt;\n'
    '  font-weight: 800;\n'
    '  color: #03283C;\n'
    '  margin: 0 0 0.5em;\n'
    '  break-before: page;\n'
    '  padding-top: 0.5em;\n'
    '}\n'
    'h1:first-of-type { break-before: avoid; padding-top: 0; }\n'
    '\n'
    'h2 {\n'
    '  font-size: 12pt;\n'
    '  font-weight: 700;\n'
    '  color: #03283C;\n'
    '  margin: 1.5em 0 0.4em;\n'
    '  border-bottom: 1px solid #d0d5dd;\n'
    '  padding-bottom: 0.2em;\n'
    '  break-after: avoid;\n'
    '}\n'
    '\n'
    'h3 {\n'
    '  font-size: 10.5pt;\n'
    '  font-weight: 700;\n'
    '  color: #04374F;\n'
    '  margin: 1.2em 0 0.3em;\n'
    '  break-after: avoid;\n'
    '}\n'
    '\n'
    'p { margin: 0.4em 0; }\n'
    '\n'
    'table {\n'
    '  border-collapse: collapse;\n'
    '  width: 100%;\n'
    '  font-size: 9.5pt;\n'
    '  margin: 0.75em 0;\n'
    '  break-inside: avoid;\n'
    '}\n'
    'th, td {\n'
    '  border: 1px solid #d0d5dd;\n'
    '  padding: 4px 8px;\n'
    '  text-align: left;\n'
    '  vertical-align: top;\n'
    '}\n'
    'th {\n'
    '  background: #f0f4f8;\n'
    '  font-weight: 600;\n'
    '  color: #03283C;\n'
    '}\n'
    '\n'
    'pre {\n'
    '  background: #f8fafc;\n'
    '  border: 1px solid #d0d5dd;\n'
    '  border-radius: 4px;\n'
    '  padding: 0.75em 1em;\n'
    '  font-size: 8.5pt;\n'
    '  line-height: 1.5;\n'
    '  break-inside: avoid;\n'
    '  white-space: pre-wrap;\n'
    '  word-break: break-word;\n'
    '}\n'
    '\n'
    'code {\n'
    '  font-family: "SF Mono", ui-monospace, Menlo, Consolas, monospace;\n'
    '  font-size: 0.875em;\n'
    '  background: #f0f4f8;\n'
    '  padding: 0.1em 0.35em;\n'
    '  border-radius: 3px;\n'
    '}\n'
    'pre code { background: none; padding: 0; font-size: inherit; }\n'
    '\n'
    'blockquote {\n'
    '  border-left: 3px solid #1A8CBA;\n'
    '  margin: 0.75em 0;\n'
    '  padding: 0.4em 1em;\n'
    '  color: #4a5568;\n'
    '  background: #f7fafc;\n'
    '  border-radius: 0 4px 4px 0;\n'
    '}\n'
    'blockquote p { margin: 0; }\n'
    '\n'
    'ul, ol { margin: 0.4em 0; padding-left: 1.5em; }\n'
    'li { margin: 0.2em 0; }\n'
    '\n'
    'li.task      { list-style: none; margin-left: -1.5em; padding-left: 0.25em; }\n'
    'li.task.done { color: #6b7280; text-decoration: line-through; }\n'
    '\n'
    'hr {\n'
    '  border: none;\n'
    '  border-top: 1px solid #e5e7eb;\n'
    '  margin: 1.25em 0;\n'
    '}\n'
    '\n'
    'img  { max-width: 100%; height: auto; display: block; margin: 0.75em 0; break-inside: avoid; }\n'
    'a    { color: #006D99; }\n'
    'del  { text-decoration: line-through; color: #6b7280; }\n'
    '\n'
    '</style>\n'
    '</head>\n'
    '<body>\n'
    + body +
    '\n</body>\n</html>'
)

with open(output_html, 'w', encoding='utf-8') as fh:
    fh.write(html_doc)

print(f'  Converted {len(md_files)} files → {os.path.basename(output_html)}')
PYEOF

# ── Print HTML → PDF ──────────────────────────────────────────────────────────

mkdir -p "$OUTPUT_DIR"

bold "Printing HTML → PDF …"

"$CHROME" \
  --headless \
  --disable-gpu \
  --no-sandbox \
  --disable-dev-shm-usage \
  --allow-file-access-from-files \
  --print-to-pdf="$OUTPUT_PDF" \
  --no-pdf-header-footer \
  "file://$TEMP_HTML" \
  2>/dev/null

[[ -f "$OUTPUT_PDF" ]] || die "Chrome produced no output."

SIZE="$(du -sh "$OUTPUT_PDF" | cut -f1)"
PAGES="$(pdfinfo "$OUTPUT_PDF" 2>/dev/null | awk '/^Pages:/{print $2}' || echo "unknown")"

bold "Done."
log ""
log "Output : $OUTPUT_PDF"
log "Pages  : $PAGES"
log "Size   : $SIZE"
