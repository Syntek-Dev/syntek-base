#!/usr/bin/env bash
#
# playwright-pin.sh — Verify every declaration of the Playwright pin names one version.
#
# Playwright ties each release to an exact Chromium REVISION. A host that supplies its
# browsers as a bundle — a distribution package, a container layer, a Nix store path —
# ships one set of revisions, so only the Playwright release whose revisions match that
# bundle can launch. Every other release fails at runtime with
# `Executable doesn't exist at .../chromium-<rev>`.
#
# That makes the release a fact this repository must state ONCE. It cannot: `UV_CONSTRAINT`
# is read by `uv tool run`, `uv pip *` and `uv add`, but NOT by `uv run`, `uv sync`,
# `uv lock` or `uv export`. So the pin is declared at five sites across four files that no
# tool holds in step, and this script is the one that does.
#
# WHAT THIS BINDS — that the declarations agree WITH EACH OTHER:
#   * pyproject.toml            [tool.uv] constraint-dependencies
#   * uv.lock                   the [manifest] constraint
#   * uv.lock                   the RESOLVED [[package]] version — a relock can move this
#                               without touching the constraint above it
#   * audits/render-slop.sh     PLAYWRIGHT_PIN, read by the detector and its operator strings
#   * audit-render-slop.yml     the CI install step
#
# WHAT IT DELIBERATELY DOES NOT BIND — whether that version matches the host's bundle.
# That is a HOST fact and it is not knowable from this tree: CI runners install their own
# browsers and have no bundle at all, so a check against one would fail everywhere the
# repository is portable. The host owns detecting its own drift. This script owns the
# failure that actually happens — someone bumps one site and not the other four.
#
# ABSENT SURFACE vs FINDING. A project whose hosts run `playwright install` freely needs no
# pin, and `pyproject.toml`'s own comment invites deleting the block. So NO site declaring a
# pin is a clean run over nothing, reported as such (`code/docs/GATE-REPORTING.md`). SOME
# sites declaring it and others not is the finding — that is a half-removed pin, which is
# how the silent version of this fault begins.
#
# Usage: playwright-pin.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--self-test] [--help]
#
# Exit codes:  0 = one version everywhere (or no pin at all)   1 = disagreement   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false
FINDING_COUNT=0
SURFACE_NOTE=""
declare -a SITES=()

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'playwright-pin.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
playwright-pin.sh — Verify every declaration of the Playwright pin names one version

Playwright ties each release to an exact Chromium revision, so a host supplying its
browsers as a bundle can only run the release whose revisions match it. That release is
declared in four files no tool holds in step. This script is the one that does.

Usage:
  playwright-pin.sh                  Compare every declaration
  playwright-pin.sh --output md      Write a report
  playwright-pin.sh --self-test      Prove the detector separates agreement from drift

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                       (default: code/src/scripts/audits/reports/playwright-pin-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --self-test          Run the detector over a generated pair and assert it separates them
  --help               Show this help

Compared:     that every site naming a Playwright version names the SAME one.
Not compared: whether that version matches the host's browser bundle. That is a host
              fact, unknowable from this tree, and CI runners have no bundle at all.
              The host owns its own drift check.

There is no --path. The sites are at fixed, repository-root paths; a scope would either
be ignored or produce a clean run over nothing. Passing it exits 2.

Exit codes:
  0  every site agrees, or no site declares a pin
  1  sites disagree, or the pin is half-removed
  2  script error

Fixing a disagreement:
  Move every site to the one version the host's bundle supports. Removing the pin
  entirely is also valid — but remove it from ALL of them.
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --self-test)   SELF_TEST=true; shift ;;
    --help|-h)     usage; exit 0 ;;
    --path)        die "--path is not accepted; this audit reads fixed repository-root paths" ;;
    *)             die "unknown option: $1 (try --help)" ;;
  esac
done

[[ -n "$OUTPUT_FORMAT" ]] || ! $QUIET || die "--quiet requires --output"
case "${OUTPUT_FORMAT:-md}" in md|txt|json) ;; *) die "unknown format: $OUTPUT_FORMAT" ;; esac

# ── Extractors ────────────────────────────────────────────────────────────────
# Each returns the bare version, or nothing when the site declares no pin. A site that
# does not EXIST is not the same as one that declares nothing, and the caller separates
# them — an absent uv.lock in a tree that has a pyproject pin is itself a finding.

# `playwright==1.61.0` in any form: a constraint list, a --with argument, a shell constant.
extract_spec() {
  [[ -f "$1" ]] || { printf '__MISSING__'; return 0; }
  grep -oE 'playwright[[:space:]]*==[[:space:]]*[0-9][0-9A-Za-z.+-]*' "$1" 2>/dev/null |
    head -1 | sed -E 's/.*==[[:space:]]*//' || true
}

# uv.lock's [manifest] block: constraints = [{ name = "playwright", specifier = "==1.61.0" }]
extract_lock_constraint() {
  [[ -f "$1" ]] || { printf '__MISSING__'; return 0; }
  grep -oE 'name[[:space:]]*=[[:space:]]*"playwright"[^}]*specifier[[:space:]]*=[[:space:]]*"==[0-9][0-9A-Za-z.+-]*"' "$1" 2>/dev/null |
    head -1 | grep -oE '==[0-9][0-9A-Za-z.+-]*' | sed 's/^==//' || true
}

# uv.lock's resolved package. A relock can move this while the constraint above it holds,
# which is the drift a reader of the constraint alone would never see.
extract_lock_resolved() {
  [[ -f "$1" ]] || { printf '__MISSING__'; return 0; }
  awk '
    /^\[\[package\]\]/       { inpkg = 1; isplay = 0; next }
    inpkg && /^name = /      { isplay = ($0 == "name = \"playwright\"") }
    inpkg && isplay && /^version = / {
      gsub(/^version = "|"$/, ""); print; exit
    }
    /^\[/ && !/^\[\[package\]\]/ { inpkg = 0 }
  ' "$1" 2>/dev/null || true
}

# ── Collect ───────────────────────────────────────────────────────────────────
collect_sites() {
  local root="$1"
  SITES=()
  SITES+=("pyproject.toml [tool.uv] constraint-dependencies|$(extract_spec "$root/pyproject.toml")")
  SITES+=("uv.lock [manifest] constraint|$(extract_lock_constraint "$root/uv.lock")")
  SITES+=("uv.lock resolved package version|$(extract_lock_resolved "$root/uv.lock")")
  SITES+=("audits/render-slop.sh PLAYWRIGHT_PIN|$(extract_spec "$root/code/src/scripts/audits/render-slop.sh")")
  SITES+=("workflows/audit-render-slop.yml install step|$(extract_spec "$root/.github/workflows/audit-render-slop.yml")")
}

# Sets FINDING_COUNT and SURFACE_NOTE from the collected sites. Kept separate from
# reporting so --self-test can call it against a generated tree.
evaluate_sites() {
  local declared=0 silent=0 missing=0 label version
  local -a versions=()
  FINDING_COUNT=0
  SURFACE_NOTE=""

  for entry in "${SITES[@]}"; do
    version="${entry#*|}"
    case "$version" in
      __MISSING__) missing=$((missing + 1)) ;;
      "")          silent=$((silent + 1)) ;;
      *)           declared=$((declared + 1)); versions+=("$version") ;;
    esac
  done

  if [[ $declared -eq 0 ]]; then
    SURFACE_NOTE="No site declares a Playwright pin — nothing to compare."
    return 0
  fi

  # Distinct versions across every site that named one.
  local distinct
  distinct=$(printf '%s\n' "${versions[@]}" | sort -u | wc -l)
  [[ $distinct -gt 1 ]] && FINDING_COUNT=$((FINDING_COUNT + 1))

  # A pin present in some sites and absent from others is half-removed, not absent.
  [[ $silent -gt 0 ]] && FINDING_COUNT=$((FINDING_COUNT + 1))
  [[ $missing -gt 0 ]] && FINDING_COUNT=$((FINDING_COUNT + 1))

  return 0
}

render_rows() {
  local fmt="$1" label version shown
  for entry in "${SITES[@]}"; do
    label="${entry%%|*}"; version="${entry#*|}"
    case "$version" in
      __MISSING__) shown="file absent" ;;
      "")          shown="no pin declared" ;;
      *)           shown="$version" ;;
    esac
    case "$fmt" in
      md)  printf '| `%s` | %s |\n' "$label" "$shown" ;;
      txt) printf '%-52s %s\n' "$label" "$shown" ;;
    esac
  done
}

# ── Self-test ─────────────────────────────────────────────────────────────────
# Generated rather than committed: the pair is five short files, and fixtures under
# `audits/fixtures/` owe rows in a register already under length pressure.
run_self_test() {
  local tmp agree_findings drift_findings
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  for variant in agree drift; do
    local d="$tmp/$variant"
    mkdir -p "$d/code/src/scripts/audits" "$d/.github/workflows"
    local other="1.61.0"
    [[ "$variant" == drift ]] && other="1.62.0"

    printf 'constraint-dependencies = ["playwright==1.61.0"]\n' > "$d/pyproject.toml"
    printf 'constraints = [{ name = "playwright", specifier = "==1.61.0" }]\n\n' > "$d/uv.lock"
    printf '[[package]]\nname = "playwright"\nversion = "1.61.0"\n' >> "$d/uv.lock"
    printf 'PLAYWRIGHT_PIN="playwright==1.61.0"\n' > "$d/code/src/scripts/audits/render-slop.sh"
    printf "        run: uv run --with 'playwright==%s' playwright install\n" "$other" \
      > "$d/.github/workflows/audit-render-slop.yml"
  done

  collect_sites "$tmp/agree"; evaluate_sites; agree_findings=$FINDING_COUNT
  collect_sites "$tmp/drift"; evaluate_sites; drift_findings=$FINDING_COUNT

  log ""
  log "  self-test: agreeing=$agree_findings finding(s), drifting=$drift_findings finding(s)"
  log ""

  if [[ $agree_findings -eq 0 && $drift_findings -gt 0 ]]; then
    bold "✓ Self-test passed — the detector separates agreement from drift."
    log "  Five agreeing sites stayed clean; one moved site was caught."
    exit 0
  fi

  bold "✗ Self-test FAILED — the detector does not separate the pair."
  log "  Expected 0 findings on the agreeing tree and >0 on the drifting one."
  exit 1
}

# ── Run ───────────────────────────────────────────────────────────────────────
log ""
bold "▸ playwright-pin.sh — $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

$SELF_TEST && run_self_test

collect_sites "$PROJECT_ROOT"
evaluate_sites

log "  sites: ${#SITES[@]}"
log ""
render_rows txt | while IFS= read -r line; do log "  $line"; done

# ── Report ────────────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  target="${OUTPUT_FILE:-$REPORTS_DIR/playwright-pin-report.$OUTPUT_FORMAT}"
  case "$OUTPUT_FORMAT" in
    json)
      {
        printf '{\n  "findings": %d,\n  "surface_note": "%s",\n  "sites": [\n' \
          "$FINDING_COUNT" "$SURFACE_NOTE"
        for i in "${!SITES[@]}"; do
          l="${SITES[$i]%%|*}"; v="${SITES[$i]#*|}"
          sep=","; [[ $i -eq $((${#SITES[@]} - 1)) ]] && sep=""
          printf '    {"site": "%s", "version": "%s"}%s\n' "$l" "$v" "$sep"
        done
        printf '  ]\n}\n'
      } > "$target"
      ;;
    md)
      {
        printf '# Playwright pin audit\n\n'
        printf 'Does every declaration of the Playwright pin name the same version?\n'
        printf 'Rule: `.claude/CLAUDE.md` Section 3.1 — the browser-backed tiers are host-dependent.\n\n'
        printf '| Site | Version |\n| ---- | ------- |\n'
        render_rows md
        printf '\n'
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
      } > "$target"
      ;;
    txt)
      {
        printf 'Playwright pin audit\n\n'
        render_rows txt
        printf '\n'
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
      } > "$target"
      ;;
  esac
  log ""
  log "  report: ${target#"$PROJECT_ROOT"/}"
fi

log ""
if [[ $FINDING_COUNT -eq 0 ]]; then
  if [[ -n "$SURFACE_NOTE" ]]; then
    bold "✓ No Playwright pin declared — nothing compared."
  else
    bold "✓ Every declaration of the Playwright pin names one version."
  fi
  exit 0
fi

bold "✗ $FINDING_COUNT disagreement(s) across the Playwright pin's declarations."
log ""
log "  No tool holds these files in step, so this drift is invisible until a browser"
log "  refuses to launch - in CI, or in whichever tier reached for it first."
log ""
log "  Move every site to one version, or remove the pin from all of them."
exit 1
