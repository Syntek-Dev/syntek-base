#!/usr/bin/env bash
# export-wireframes.sh — Export all WF-*.html wireframe screens to a single merged PDF.
#
# Usage: bash export-wireframes.sh [OUTPUT_NAME] [--help]
#
#   OUTPUT_NAME  Optional filename (with or without .pdf extension).
#                Saved into project-management/export/.
#                Defaults to WIREFRAMES.pdf if omitted.
#
# Examples:
#   bash export-wireframes.sh                        → WIREFRAMES.pdf
#   bash export-wireframes.sh WIREFRAMES-v2          → WIREFRAMES-v2.pdf
#   bash export-wireframes.sh "Wireframes May 2026"  → Wireframes-May-2026.pdf
#
# Requires:
#   - google-chrome (or chromium-browser) for HTML → PDF conversion
#   - python3 (stdlib only) for the local HTTP server the pages are served from
#   - gs (ghostscript) for page cropping
#   - One of: pdfunite (poppler-utils) | gs | python3+pypdf for merging
#   - No internet access: the wireframes are self-contained (system fonts,
#     inline SVG, and SHARED/wireframe.css — no CDN, no JS framework)
#
# Why a local HTTP server?
#   The screens are plain HTML and open fine over file://, but serving them
#   over a real HTTP origin keeps Chrome's headless printing consistent —
#   relative asset paths, same-origin CSS, and the virtual-time budget below
#   all behave the same way they would in the served site.
#
# Exit codes: 0 = success  1 = export/merge failed  2 = preflight error
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

SCREENS_DIR="$PROJECT_ROOT/project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS"
OUTPUT_DIR="$PROJECT_ROOT/project-management/export"

# Relative path from project root to SCREENS dir — used to build HTTP URLs.
SCREENS_REL="project-management/src/08-WIREFRAMES/CONSOLIDATED-IDEAS"

# ── Helpers ───────────────────────────────────────────────────────────────────

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

if [[ "${1:-}" == "--help" ]]; then
  bold "export-wireframes.sh"
  echo ""
  echo "  Exports all WF-*.html wireframe screens to a single merged PDF."
  echo ""
  echo "  Usage: bash export-wireframes.sh [OUTPUT_NAME]"
  echo ""
  echo "  OUTPUT_NAME defaults to WIREFRAMES. Spaces are replaced with hyphens."
  echo "  Files are always saved into project-management/export/."
  echo ""
  echo "  Requires: google-chrome + python3 + gs + one of pdfunite / python3+pypdf"
  echo "  No internet access needed — the wireframes are self-contained."
  exit 0
fi

# ── Resolve output filename ───────────────────────────────────────────────────

raw_name="${1:-WIREFRAMES}"
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

# ── Collect WF files (numeric sort by WF-NNN prefix) ─────────────────────────

mapfile -t HTML_FILES < <(
  find "$SCREENS_DIR" -maxdepth 1 -name "WF-*.html" \
    | sort -t'-' -k2,2n
)

[[ ${#HTML_FILES[@]} -gt 0 ]] || die "No WF-*.html files found in: $SCREENS_DIR"

# ── Temp directory (auto-cleaned on exit) ─────────────────────────────────────

TMP_DIR="$(mktemp -d)"

# ── Local HTTP server ─────────────────────────────────────────────────────────
# Pick a free port, start python3's built-in server rooted at the project root,
# and clean up both the server and the temp dir on exit.

SERVER_PORT=$(python3 -c "
import socket
s = socket.socket()
s.bind(('127.0.0.1', 0))
print(s.getsockname()[1])
s.close()
")

python3 -m http.server "$SERVER_PORT" \
  --bind 127.0.0.1 \
  --directory "$PROJECT_ROOT" \
  &>/dev/null &
SERVER_PID=$!

trap 'kill "$SERVER_PID" 2>/dev/null; rm -rf "$TMP_DIR"' EXIT

# Wait until the server is actually accepting connections (up to 5 s).
for _i in $(seq 1 25); do
  python3 -c "
import socket, sys
s = socket.socket()
s.settimeout(0.2)
try:
    s.connect(('127.0.0.1', $SERVER_PORT))
    s.close()
    sys.exit(0)
except Exception:
    sys.exit(1)
" 2>/dev/null && break
  sleep 0.2
done

python3 -c "
import socket, sys
s = socket.socket()
s.settimeout(1)
try:
    s.connect(('127.0.0.1', $SERVER_PORT))
    s.close()
except Exception:
    print('ERROR: local HTTP server did not start on port $SERVER_PORT', file=sys.stderr)
    sys.exit(1)
" || die "Local HTTP server failed to start."

# ── Preflight ─────────────────────────────────────────────────────────────────

bold "Preflight checks …"
log "Source  : $SCREENS_DIR"
log "Files   : ${#HTML_FILES[@]} WF-*.html files"
log "Chrome  : $CHROME"
log "Server  : http://127.0.0.1:$SERVER_PORT"
log "Output  : $OUTPUT_PDF"

# ── Convert each HTML → PDF ───────────────────────────────────────────────────

bold "Converting HTML → PDF …"
declare -a PDF_FILES=()
declare -a SKIPPED_FILES=()

for html_file in "${HTML_FILES[@]}"; do
  name="$(basename "$html_file" .html)"
  out_pdf="$TMP_DIR/${name}.pdf"
  url="http://127.0.0.1:$SERVER_PORT/$SCREENS_REL/${name}.html"
  log "$name …"

  # --window-size:           viewport wide enough for 1920 px artboards.
  # --virtual-time-budget:   Chrome advances virtual time once the page's own
  #                          requests (the shared stylesheet, inline SVG) settle,
  #                          so layout and web-safe fonts are final before the
  #                          print snapshot is taken.
  # || true: don't let a non-zero Chrome exit kill the whole run.
  "$CHROME" \
    --headless \
    --disable-gpu \
    --no-sandbox \
    --disable-dev-shm-usage \
    --window-size=2100,1080 \
    --virtual-time-budget=8000 \
    --print-to-pdf="$out_pdf" \
    --no-pdf-header-footer \
    "$url" \
    2>/dev/null || true

  if [[ ! -f "$out_pdf" ]]; then
    log "  WARNING: Chrome produced no output — skipping $name"
    SKIPPED_FILES+=("$name")
    continue
  fi

  # ── Crop to actual content bounding box ──────────────────────────────────
  # Each WF file renders as one tall page (@page size 2100×100000 px).
  # gs detects the real content bounds and re-renders a tightly cropped page.
  bbox_raw=$(gs -dNOPAUSE -dBATCH -sDEVICE=bbox -q "$out_pdf" 2>&1 \
    | grep "HiResBoundingBox:" | head -1) || true

  if [[ -n "$bbox_raw" ]]; then
    read -r _ x1 y1 x2 y2 <<< "$bbox_raw"
    margin=28  # ~0.5 cm in PDF points

    dx=$(python3 -c "print(round($margin - float('$x1')))")
    dy=$(python3 -c "print(round($margin - float('$y1')))")
    new_w=$(python3 -c "print(round(float('$x2') - float('$x1') + 2 * $margin))")
    new_h=$(python3 -c "print(round(float('$y2') - float('$y1') + 2 * $margin))")

    cropped="${out_pdf%.pdf}_c.pdf"
    gs -dBATCH -dNOPAUSE -q \
      -sDEVICE=pdfwrite \
      -dFIXEDMEDIA \
      -dDEVICEWIDTHPOINTS="$new_w" \
      -dDEVICEHEIGHTPOINTS="$new_h" \
      -sOutputFile="$cropped" \
      -c "<</PageOffset [$dx $dy]>> setpagedevice" \
      -f "$out_pdf" 2>/dev/null \
    && mv "$cropped" "$out_pdf" || true
  fi

  PDF_FILES+=("$out_pdf")
done

if [[ ${#SKIPPED_FILES[@]} -gt 0 ]]; then
  log "WARNING: ${#SKIPPED_FILES[@]} file(s) skipped (Chrome produced no output):"
  for s in "${SKIPPED_FILES[@]}"; do log "  — $s"; done
fi

[[ ${#PDF_FILES[@]} -gt 0 ]] || die "No PDFs were generated. Check that Chrome can render the screens headlessly."

log "${#PDF_FILES[@]} PDFs generated and cropped to content height."

# ── Create output directory ───────────────────────────────────────────────────

mkdir -p "$OUTPUT_DIR"

# ── Merge PDFs ────────────────────────────────────────────────────────────────

bold "Merging PDFs …"

if command -v pdfunite >/dev/null 2>&1; then
  log "Using pdfunite …"
  pdfunite "${PDF_FILES[@]}" "$OUTPUT_PDF"

elif command -v gs >/dev/null 2>&1; then
  log "Using ghostscript …"
  gs \
    -dBATCH -dNOPAUSE -q \
    -sDEVICE=pdfwrite \
    -sOutputFile="$OUTPUT_PDF" \
    "${PDF_FILES[@]}"

elif command -v python3 >/dev/null 2>&1; then
  log "Using python3 …"
  python3 - "${PDF_FILES[@]}" "$OUTPUT_PDF" << 'PYEOF'
import sys

files  = sys.argv[1:-1]
output = sys.argv[-1]

try:
    from pypdf import PdfWriter
    writer = PdfWriter()
    for f in files:
        writer.append(f)
    with open(output, "wb") as fh:
        writer.write(fh)
except ImportError:
    pass
else:
    sys.exit(0)

try:
    from PyPDF2 import PdfMerger
    merger = PdfMerger()
    for f in files:
        merger.append(f)
    with open(output, "wb") as fh:
        merger.write(fh)
    merger.close()
except ImportError:
    print("ERROR: No PDF merge library found. Install pypdf: pip install pypdf", file=sys.stderr)
    sys.exit(1)
PYEOF

else
  die "No PDF merge tool found. Install poppler-utils (pdfunite) or ghostscript (gs)."
fi

# ── Verify and report ─────────────────────────────────────────────────────────

[[ -f "$OUTPUT_PDF" ]] || die "Merge completed but output file not found: $OUTPUT_PDF"

SIZE="$(du -sh "$OUTPUT_PDF" | cut -f1)"
bold "Done."
log ""
log "Output : $OUTPUT_PDF"
log "Pages  : ${#PDF_FILES[@]}"
log "Size   : $SIZE"
log ""
log "Document order:"
for i in "${!HTML_FILES[@]}"; do
  log "  $((i + 1)). $(basename "${HTML_FILES[$i]}" .html)"
done
