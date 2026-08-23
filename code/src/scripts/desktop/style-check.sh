#!/usr/bin/env bash
#
# style-check.sh: prove the desktop app chooses its Slint style deliberately.
#
#                  From Slint 1.16 the default style is Microsoft Fluent on EVERY
#                  platform, so an app that configures nothing ships a stock vendor
#                  look on macOS and Linux as well as Windows. That is the desktop
#                  expression of generic design, and the one clause this surface has:
#                  desktop slop is stock Fluent, and it fails a build rather than
#                  merely warning.
#
#                  This is a BUILD-CONFIG check, not a source scan. The style is
#                  fixed at compile time, so exactly one question is asked: does a
#                  committed build file choose one?
#
# Accepted evidence (comments stripped first, so a commented-out call never counts):
#   crates/desktop/build.rs             `with_style` or `SLINT_STYLE`
#   crates/desktop/.cargo/config.toml   `SLINT_STYLE` (an [env] entry)
#   rust/.cargo/config.toml             `SLINT_STYLE` (set workspace-wide)
#
#   ANY style value passes, Fluent included: the clause is that a choice was MADE,
#   not which one was made. An ambient SLINT_STYLE exported in a shell or set in a CI
#   job is deliberately NOT accepted. A look that depends on the environment of
#   whoever ran the build is the deferral this gate exists to stop.
#
# Two tiers in one run:
#   [gate: fail]  no style chosen in any committed build file       → exit 1
#   [gate: warn]  .slint markup imports std-widgets and references
#                 neither Palette nor StyleMetrics                  → printed, exit 0
#
#   The warn tier is advisory BY DESIGN. std-widgets is legitimate as structural
#   scaffolding beneath components that do drive Palette and StyleMetrics, and no
#   script can tell that apart from std-widgets carrying the brand unaided.
#
# Escape hatch: a `style-allow` comment in build.rs, with a reason, suppresses the
# [gate: fail] clause, for an app that genuinely ships the platform default on
# purpose. It does not apply to the warn tier, which fails nothing anyway.
#
# NO-OP WHEN ABSENT. The desktop surface is opt-in, so a project generated without
# crates/desktop exits 0 with a note rather than failing. That is what lets this run
# unconditionally. It deliberately does NOT source the helper the other desktop scripts
# share: that helper hard-fails when the crate is missing and requires cargo, whereas
# this reads three files and needs no toolchain at all.
#
# Usage: style-check.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                       [--path PATH] [--help]
#
# Exit codes:  0 = a style is chosen (or surface absent)   1 = no style chosen
#              2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

RUST_DIR="code/src/rust"
DESKTOP_DIR="$RUST_DIR/crates/desktop"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'style-check.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
style-check.sh: prove the desktop app chooses its Slint style deliberately

Usage:
  style-check.sh                   Check the desktop crate's build config
  style-check.sh --output md       Also write a report
  style-check.sh --path DIR        Treat DIR as the desktop crate root

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/style-check-report.<FORMAT>)
  --quiet              Suppress terminal output (requires --output)
  --path PATH          Treat PATH as the desktop crate root instead of
                         code/src/rust/crates/desktop
  --help               Show this help

A style counts as chosen when build.rs calls `with_style` (or sets SLINT_STYLE), or
when SLINT_STYLE appears in the crate's or the workspace's .cargo/config.toml. Any
style value passes: the clause is that a choice was made, not which one.

An app that ships the platform default on purpose may carry a `style-allow` comment,
with a reason, in build.rs.

Exit codes:  0 = a style is chosen (or surface absent)   1 = no style chosen
             2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)       require_arg "$@"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file)  require_arg "$@"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)        QUIET=true; shift ;;
    --path)         require_arg "$@"; TARGET_PATH="$2"; shift 2 ;;
    --help|-h)      usage; exit 0 ;;
    *)              die "Unknown option: $1. Use --help for usage." ;;
  esac
done

if $QUIET && [[ -z "$OUTPUT_FORMAT" ]]; then
  die "--quiet requires --output"
fi
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/style-check-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

if [[ -n "$TARGET_PATH" ]]; then
  DESKTOP_DIR="${TARGET_PATH%/}"
  # An explicit --path is an assertion, not a discovery: a typo must be an error
  # rather than a silent pass. Only the DEFAULT location self-guards below.
  [[ -d "$DESKTOP_DIR" ]] || die "--path '$DESKTOP_DIR' is not a directory"
fi

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

# ── No-op when the desktop surface is absent ──────────────────────────────────
if [[ ! -d "$DESKTOP_DIR" ]]; then
  log ""
  bold "▸ style-check.sh ($TIMESTAMP)"
  log "  $DESKTOP_DIR does not exist: this project has no desktop surface."
  log ""
  bold "✓ Nothing to check."
  log ""
  exit 0
fi

# ── Scanners ──────────────────────────────────────────────────────────────────
# Each strips comment bodies before matching and reports the FIRST match as
# "line:text", using the original line so the evidence reads as written.
scan_rust() {
  awk '{
    s = $0; sub(/\/\/.*$/, "", s)
    if (s ~ /with_style|SLINT_STYLE/) {
      t = $0; sub(/^[ \t]+/, "", t); printf "%d:%s\n", NR, t; exit
    }
  }' "$1"
}

scan_toml() {
  awk '{
    s = $0; sub(/#.*$/, "", s)
    if (s ~ /SLINT_STYLE/) {
      t = $0; sub(/^[ \t]+/, "", t); printf "%d:%s\n", NR, t; exit
    }
  }' "$1"
}

BUILD_RS="$DESKTOP_DIR/build.rs"
CARGO_CONFIGS=("$DESKTOP_DIR/.cargo/config.toml" "$RUST_DIR/.cargo/config.toml")

STYLE_SET=false
ALLOWED=false
EVIDENCE=""

if [[ -f "$BUILD_RS" ]]; then
  hit=$(scan_rust "$BUILD_RS")
  if [[ -n "$hit" ]]; then
    STYLE_SET=true
    EVIDENCE="$BUILD_RS:$hit"
  fi
  # The allow check reads the RAW file, because the annotation lives in a comment.
  if grep -q 'style-allow' "$BUILD_RS"; then
    ALLOWED=true
  fi
fi

if [[ $STYLE_SET == false ]]; then
  for cfg in "${CARGO_CONFIGS[@]}"; do
    [[ -f "$cfg" ]] || continue
    hit=$(scan_toml "$cfg")
    if [[ -n "$hit" ]]; then
      STYLE_SET=true
      EVIDENCE="$cfg:$hit"
      break
    fi
  done
fi

# ── Warn tier: bare std-widgets with no Palette/StyleMetrics ──────────────────
TMP_SLINT=$(mktemp)
trap 'rm -f "$TMP_SLINT"' EXIT

find "$DESKTOP_DIR" -type f -name '*.slint' -print0 > "$TMP_SLINT" || true
SLINT_COUNT=$(tr -cd '\0' < "$TMP_SLINT" | wc -c | tr -d ' ')

USES_STD_WIDGETS=0
USES_STYLE_GLOBALS=0
if [[ "$SLINT_COUNT" -gt 0 ]]; then
  # Slint identifiers may contain '-', so the boundary excludes it as well.
  read -r USES_STD_WIDGETS USES_STYLE_GLOBALS < <(
    xargs -0 awk '{
      s = $0; sub(/\/\/.*$/, "", s)
      if (s ~ /from[ \t]*"std-widgets\.slint"/) std = 1
      if (s ~ /(^|[^A-Za-z0-9_-])(Palette|StyleMetrics)([^A-Za-z0-9_-]|$)/) pal = 1
    } END { print std + 0, pal + 0 }' < "$TMP_SLINT"
  )
fi

WARN=false
if [[ "$USES_STD_WIDGETS" -eq 1 && "$USES_STYLE_GLOBALS" -eq 0 ]]; then
  WARN=true
fi

FAILED=false
if [[ $STYLE_SET == false && $ALLOWED == false ]]; then
  FAILED=true
fi

# ── Terminal output ───────────────────────────────────────────────────────────
log ""
bold "▸ style-check.sh ($TIMESTAMP)"
log "  crate:  $DESKTOP_DIR"
log "  markup: $SLINT_COUNT .slint file(s)"
log ""

if [[ $STYLE_SET == true ]]; then
  log "  style chosen in $EVIDENCE"
elif [[ $ALLOWED == true ]]; then
  log "  no style chosen, exempted by a style-allow annotation in $BUILD_RS"
elif ! $QUIET; then
  printf '\033[31m  ✗ [gate: fail] no Slint style is chosen in any committed build file\033[0m\n'
  printf '      checked: %s\n' "$BUILD_RS"
  for cfg in "${CARGO_CONFIGS[@]}"; do printf '               %s\n' "$cfg"; done
fi

if [[ $WARN == true && $QUIET == false ]]; then
  printf '\033[33m  ⚠ [gate: warn] .slint markup imports std-widgets and references neither Palette nor StyleMetrics\033[0m\n'
  printf '      Drive the look from those globals in your own components, or confirm std-widgets is scaffolding only.\n'
fi
log ""

# ── Report output ─────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  if [[ $FAILED == true ]]; then
    STATUS="✗ no style chosen"
  elif [[ $ALLOWED == true && $STYLE_SET == false ]]; then
    STATUS="✓ exempted by style-allow"
  else
    STATUS="✓ style chosen"
  fi
  DETAIL="${EVIDENCE:-none}"
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'desktop style-check (%s)\n' "$TIMESTAMP"
        printf 'crate=%s slint_files=%s\n' "$DESKTOP_DIR" "$SLINT_COUNT"
        printf 'style_set=%s allowed=%s warn=%s\n\n' "$STYLE_SET" "$ALLOWED" "$WARN"
        printf 'evidence: %s\n' "$DETAIL"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Desktop Slint Style Audit Report\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Crate** | %s |\n' "$DESKTOP_DIR"
        printf '| **Markup files** | %s |\n' "$SLINT_COUNT"
        printf '| **Style chosen** | %s |\n' "$STYLE_SET"
        printf '| **std-widgets warning** | %s |\n' "$WARN"
        printf '| **Status** | %s |\n\n' "$STATUS"
        printf '```text\nevidence: %s\n```\n' "$DETAIL"
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "desktop-style-check",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "crate": "%s",\n  "slint_files": %s,\n' "$DESKTOP_DIR" "$SLINT_COUNT"
        printf '  "style_set": %s,\n  "style_allow": %s,\n  "warn_std_widgets": %s,\n' \
          "$STYLE_SET" "$ALLOWED" "$WARN"
        printf '  "exit_code": %s\n}\n' "$([[ $FAILED == true ]] && echo 1 || echo 0)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

# ── Summary ───────────────────────────────────────────────────────────────────
if [[ $FAILED == true ]]; then
  bold "✗ No Slint style is chosen: the app ships stock Fluent on every platform."
  log "  Set one at compile time: swap slint_build::compile for compile_with_config with"
  log "  a CompilerConfiguration carrying with_style, or add SLINT_STYLE to an [env] table"
  log "  in .cargo/config.toml. Guide: code/docs/visual-design/DESKTOP.md."
  log ""
  exit 1
fi

if [[ $WARN == true ]]; then
  bold "⚠ Style chosen, but the markup leans on bare std-widgets."
  log "  Advisory only. This does not fail the gate."
else
  bold "✓ The desktop app chooses its Slint style deliberately."
fi
log ""
exit 0
