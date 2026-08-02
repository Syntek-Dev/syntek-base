#!/usr/bin/env bash
# export-design-docs.sh — Export all design-system HTML files to a single merged PDF.
#
# Usage: bash export-design-docs.sh [OUTPUT_NAME] [--help]
#
#   OUTPUT_NAME  Optional filename (with or without .pdf extension).
#                Saved into project-management/export/.
#                Defaults to DESIGN-DOCS.pdf if omitted.
#
# Examples:
#   bash export-design-docs.sh                        → DESIGN-DOCS.pdf
#   bash export-design-docs.sh DESIGN-DOCS-v2         → DESIGN-DOCS-v2.pdf
#   bash export-design-docs.sh "Brand Guide May 2026" → Brand-Guide-May-2026.pdf
#
# Requires:
#   - google-chrome (or chromium-browser) for HTML → PDF conversion
#   - gs (ghostscript) for page cropping
#   - One of: pdfunite (poppler-utils) | gs | python3+pypdf for merging
#
# Exit codes: 0 = success  1 = export/merge failed  2 = preflight error
set -euo pipefail

# ── Paths ─────────────────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

DESIGN_DIR="$PROJECT_ROOT/project-management/src/05-BRAND-GUIDE/DESIGN"
COMP_DESIGN_DIR="$PROJECT_ROOT/project-management/src/06-COMPONENTS/DESIGN"
OUTPUT_DIR="$PROJECT_ROOT/project-management/export"

# ── Helpers ───────────────────────────────────────────────────────────────────

bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '  %s\n' "$*"; }
die()  { printf '\033[31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

if [[ "${1:-}" == "--help" ]]; then
  bold "export-design-docs.sh"
  echo ""
  echo "  Exports all six <%PROJECT_NAME%> design-system HTML files to a single merged PDF."
  echo ""
  echo "  Usage: bash export-design-docs.sh [OUTPUT_NAME]"
  echo ""
  echo "  OUTPUT_NAME defaults to DESIGN-DOCS. Spaces are replaced with hyphens."
  echo "  Files are always saved into project-management/export/."
  echo ""
  echo "  Requires: google-chrome + gs (ghostscript) + one of pdfunite / python3+pypdf"
  exit 0
fi

# ── Resolve output filename ───────────────────────────────────────────────────

raw_name="${1:-DESIGN-DOCS}"
# Normalise: strip trailing .pdf, replace spaces with hyphens
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

# ── HTML source files (ordered) ───────────────────────────────────────────────

declare -a HTML_FILES=(
  "$DESIGN_DIR/Foundations.html"
  "$DESIGN_DIR/Foundations-Extended.html"
  "$COMP_DESIGN_DIR/Components.html"
  "$COMP_DESIGN_DIR/Components-App.html"
  "$COMP_DESIGN_DIR/Patterns.html"
  "$COMP_DESIGN_DIR/Patterns-App.html"
)

# ── Preflight: verify all source files exist ──────────────────────────────────

bold "Preflight checks …"
missing=0
for f in "${HTML_FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    log "MISSING: $f"
    missing=1
  fi
done
[[ "$missing" -eq 0 ]] || die "One or more source HTML files are missing. Aborting."
log "All 6 source files found."
log "Chrome: $CHROME"

# ── Temp directory (auto-cleaned on exit) ─────────────────────────────────────

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# ── Convert each HTML → PDF ───────────────────────────────────────────────────

bold "Converting HTML → PDF …"
declare -a PDF_FILES=()

for html_file in "${HTML_FILES[@]}"; do
  name="$(basename "$html_file" .html)"
  out_pdf="$TMP_DIR/${name}.pdf"
  log "  $name …"

  "$CHROME" \
    --headless \
    --disable-gpu \
    --no-sandbox \
    --disable-dev-shm-usage \
    --allow-file-access-from-files \
    --print-to-pdf="$out_pdf" \
    --no-pdf-header-footer \
    "file://$html_file" \
    2>/dev/null

  [[ -f "$out_pdf" ]] || die "Chrome produced no output for: $html_file"

  # ── Crop blank whitespace from the bottom of the tall page ──
  bbox_raw=$(gs -dNOPAUSE -dBATCH -sDEVICE=bbox -q "$out_pdf" 2>&1 \
    | grep "HiResBoundingBox:" | head -1)

  if [[ -n "$bbox_raw" ]]; then
    read -r _ x1 y1 x2 y2 <<< "$bbox_raw"
    margin=28      # ~0.5 cm in PDF points
    page_w=1050    # 1400 CSS px × 0.75 pt/px

    dy=$(python3     -c "print(round($margin - float('$y1')))")
    new_h=$(python3  -c "print(round(float('$y2') - float('$y1') + 2 * $margin))")

    cropped="${out_pdf%.pdf}_c.pdf"
    gs -dBATCH -dNOPAUSE -q \
      -sDEVICE=pdfwrite \
      -dFIXEDMEDIA \
      -dDEVICEWIDTHPOINTS="$page_w" \
      -dDEVICEHEIGHTPOINTS="$new_h" \
      -sOutputFile="$cropped" \
      -c "<</PageOffset [0 $dy]>> setpagedevice" \
      -f "$out_pdf" 2>/dev/null \
    && mv "$cropped" "$out_pdf"
  fi

  PDF_FILES+=("$out_pdf")
done

log "6 PDFs generated and cropped to content height."

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
log "Size   : $SIZE"
log ""
log "Document order:"
log "  1. Foundations"
log "  2. Foundations Extended"
log "  3. Components"
log "  4. Components — App"
log "  5. Patterns"
log "  6. Patterns — App"
