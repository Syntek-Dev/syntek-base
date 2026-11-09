#!/usr/bin/env bash
#
# toolchain-pins.sh — Verify every pin of Node, Python, uv, pnpm and Rust names its source's version.
#
# A toolchain is pinned in many places at once, and no tool holds them in step. Moving
# `.nvmrc` does not move a CI job's `node-version`, a Dockerfile's `FROM python:`, the
# `engines` floor or the prerequisites table a new contributor reads — and every one left
# behind fails somewhere else, usually only in CI. how-to/workflows/07-dependency-updates
# Step 4 calls this "the matched-set failure"; this script is the gate it names.
#
# ONE SOURCE OF TRUTH PER TOOL, read, never restated here:
#   node    .nvmrc
#   python  .python-version
#   pnpm    package.json "packageManager"
#   rust    code/src/rust/rust-toolchain.toml  channel        (the compiler everyone builds with)
#   msrv    code/src/rust/Cargo.toml           rust-version   (the floor cargo RESOLVES against)
#   uv      .github/workflows/claude.yml       env UV_VERSION
#
# uv has no file of its own, so one was chosen: the UV_VERSION of the workflow carrying the
# required "[8/8] Security" gate, because that is the uv a pull request is judged by. When
# PIN S-01 (MAP-PIN-DETECT-MOVE) adds `[tool.uv] required-version`, that range becomes a
# compared site like any other; moving the source is a change to this header.
#
# The channel and the MSRV are compared SEPARATELY. They are not a matched set
# (code/docs/rust/SUPPLY-CHAIN.md), so a document's Rust claim is routed by its form: a floor
# (`1.92+`, `>=1.92`, `rust-version`) is an MSRV claim, an exact version is a channel claim.
#
# WHAT IS DISCOVERED — parsed, so a new site needs no edit here:
#   * .github/workflows/*.y*ml  env NODE_VERSION / PYTHON_VERSION / UV_VERSION / PNPM_VERSION;
#                               each setup-node, setup-python, setup-uv, pnpm/action-setup and
#                               rust-toolchain step's version input — or its absence
#   * Dockerfiles under code/src/docker  FROM python: / node: / rust:, the astral uv image tag,
#                               `npm install -g pnpm@` and `corepack prepare pnpm@`
#   * package.json at the root and under code/src/*  packageManager, engines.node, engines.pnpm
#   * pyproject.toml            requires-python, ruff target-version, (based)pyright
#                               pythonVersion, [tool.uv] required-version
#   * code/src/rust crate manifests  a literal rust-version
#   * any `uv run ... --python X` in code/src/scripts/**/*.sh or a workflow
#
# WHAT IS DECLARED — the DOCUMENT register below. No file anywhere says which documents
# state a toolchain, so the register is the source; a document added to it is scanned for
# every form at once. A stated version in a registered document that disagrees FAILS, the
# same as a CI pin does (Sam's ruling, 09/11/2026): a prerequisites table that says 0.11+
# while CI runs 0.12 sends a reader to install the wrong tool.
#
# HOW A CLAIM AGREES. Every stated component must equal the source's: `24`, `>=24`, `24+` and
# `24.x` all agree with `.nvmrc` 24. A floor states the pin, not merely a version it admits —
# a floor that only admits the pin is a stale floor, which is how "uv 0.11+" outlived the move
# to 0.12. A range is read by its lower bound. A claim coarser than the tool moves at
# (`3.x` for Python, `latest`, no version input at all) is UNPINNED: it floats, so it will
# disagree on the day upstream moves, and it is reported as its own class rather than passed.
#
# THE HELD TIER, and why it is not a suppression. Unpinned uv — the `uv:latest` image the
# django Dockerfiles copy from, and setup-uv steps with no version — is assigned to PIN S-01,
# a held story whose acceptance is exactly "every workflow step and every Dockerfile installs
# one uv version, and none installs latest". Failing on it would make this gate red for the
# life of that hold and teach everyone to read past it. Passing it silently would be the
# defect code/docs/GATE-REPORTING.md bans. So it is printed, every run, site by site, in a
# tier of its own naming its owner, and it does not change the exit code. The tier is a
# CLASS (tool + finding kind) declared once in HELD below — never a marker on a line, so a
# new held-class site is reported the moment it appears and nothing in the tree can hide one.
# When S-01 ships, HELD is emptied in the same change and the class fails like any other.
#
# ABSENT SURFACE. No code/src/rust means a project generated without Rust: Rust claims in the
# shipped documents are reported "not compared — no Rust surface" and are not findings. A
# source of truth that is absent while sites still name its tool IS a finding.
#
# Usage: toolchain-pins.sh [--output FORMAT] [--output-file PATH] [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = every pin agrees (held items printed)   1 = drift or unpinned   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"
FIXTURES_DIR="$SCRIPT_DIR/fixtures/toolchain-pins"

# The document register — paths relative to the scanned root, globs allowed.
DOC_REGISTER=(
  README.md
  .copier/README.md
  REFERENCES.md
  code/REFERENCES.md
  how-to/REFERENCES.md
  "how-to/docs/*.md"
  "how-to/src/TEMPLATE-GUIDE/*.md"
  "code/src/*/CONTEXT.md"
  "code/src/docker/*/CONTEXT.md"
  code/src/rust/CLAUDE.md
  .claude/CLAUDE.md
  ".claude/skills/stack-*/SKILL.md"
  .claude/hooks/pre-pr-check.sh
)

# Held classes: "tool:class|owner". Printed every run; never fails. See the header.
HELD=(
  "uv:unpinned|PIN S-01 (MAP-PIN-DETECT-MOVE) - builds run what they pin; held per D5, 09/11/2026"
)

# ── Defaults ──────────────────────────────────────────────────────────────────
OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
SELF_TEST=false
FAIL_COUNT=0
HELD_COUNT=0
SITE_COUNT=0
RESULTS=""
SOURCES=""

# ── Helpers ───────────────────────────────────────────────────────────────────
log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'toolchain-pins.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
toolchain-pins.sh — Verify every toolchain pin names its source's version

Node, Python, uv, pnpm and Rust are each pinned in many files no tool holds in step.
This compares every pin it can discover (CI, Dockerfiles, manifests) and every version
stated in the registered documents against one source of truth per tool.

Usage:
  toolchain-pins.sh                  Compare every pin
  toolchain-pins.sh --output md      Also write a report
  toolchain-pins.sh --self-test      Prove the detector separates agreement from drift

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                       (default: code/src/scripts/audits/reports/toolchain-pins-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --self-test          Run over fixtures/toolchain-pins/{agree,drift} and the odd-form probes
  --help               Show this help

Sources:  node .nvmrc · python .python-version · pnpm packageManager ·
          rust rust-toolchain.toml channel · msrv Cargo.toml rust-version ·
          uv .github/workflows/claude.yml UV_VERSION

Classes:  agree · derived (reads the source itself) · drift · unpinned (floats) ·
          reads-other (a version file that is not the source) · no-source ·
          held (an unpinned class assigned to a named story; printed, never fails)

There is no --path. The sites are a whole-repository fact; a scope would be a clean run
over a subset. Passing it exits 2.

Exit codes:
  0  every pin agrees (held items are printed and do not fail)
  1  drift, unpinned, reads-other or no-source
  2  script error
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
    --path)        die "--path is not accepted; this audit reads a whole-repository fact" ;;
    *)             die "unknown option: $1 (try --help)" ;;
  esac
done

[[ -n "$OUTPUT_FORMAT" ]] || ! $QUIET || die "--quiet requires --output"
case "${OUTPUT_FORMAT:-md}" in md|txt|json) ;; *) die "unknown format: $OUTPUT_FORMAT" ;; esac

# ── Sources of truth ──────────────────────────────────────────────────────────
# Prints "tool<TAB>value<TAB>where" for each source; value is empty when absent.
read_sources() {
  local root="$1" v
  v=""; [[ -f "$root/.nvmrc" ]] && v="$(tr -d '[:space:]' < "$root/.nvmrc")"
  printf 'node\t%s\t.nvmrc\n' "$v"
  v=""; [[ -f "$root/.python-version" ]] && v="$(head -1 "$root/.python-version" | tr -d '[:space:]')"
  printf 'python\t%s\t.python-version\n' "$v"
  v=""; [[ -f "$root/package.json" ]] &&
    v="$(sed -nE 's/^[[:space:]]*"packageManager"[[:space:]]*:[[:space:]]*"pnpm@([^"+]*).*/\1/p' "$root/package.json" | head -1)"
  printf 'pnpm\t%s\tpackage.json packageManager\n' "$v"
  v=""; [[ -f "$root/.github/workflows/claude.yml" ]] &&
    v="$(sed -nE 's/^[[:space:]]*UV_VERSION:[[:space:]]*"?([^"[:space:]]*)"?.*/\1/p' "$root/.github/workflows/claude.yml" | head -1)"
  printf 'uv\t%s\t.github/workflows/claude.yml UV_VERSION\n' "$v"
  if [[ -d "$root/code/src/rust" ]]; then
    v=""; [[ -f "$root/code/src/rust/rust-toolchain.toml" ]] &&
      v="$(sed -nE 's/^[[:space:]]*channel[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' "$root/code/src/rust/rust-toolchain.toml" | head -1)"
    printf 'rust\t%s\tcode/src/rust/rust-toolchain.toml channel\n' "$v"
    v=""; [[ -f "$root/code/src/rust/Cargo.toml" ]] &&
      v="$(sed -nE 's/^[[:space:]]*rust-version[[:space:]]*=[[:space:]]*"([^"]*)".*/\1/p' "$root/code/src/rust/Cargo.toml" | head -1)"
    printf 'msrv\t%s\tcode/src/rust/Cargo.toml rust-version\n' "$v"
  else
    printf 'rust\t__ABSENT__\tno code/src/rust\n'
    printf 'msrv\t__ABSENT__\tno code/src/rust\n'
  fi
}

# ── Site extractors ───────────────────────────────────────────────────────────
# Every extractor prints "tool<TAB>role<TAB>raw<TAB>file:line<TAB>note". Role is `value`
# (a stated version), `derived` (reads the source itself), `floating` (states none) or
# `readsother` (reads a version file that is not the source).

# GitHub Actions workflows: env keys, and the version input of each setup step.
extract_workflows() {
  local root="$1" f
  for f in "$root"/.github/workflows/*.yml "$root"/.github/workflows/*.yaml; do
    [[ -f "$f" ]] || continue
    awk -v rel="${f#"$root"/}" '
      function ind(s) { match(s, /^ */); return RLENGTH }
      function val(s) { sub(/^[^:]*:[ \t]*/, "", s); sub(/[ \t]+#.*$/, "", s); gsub(/^["\047]|["\047]$/, "", s); return s }
      function out(t, r, v, l, n) { printf "%s\t%s\t%s\t%s:%d\t%s\n", t, r, v, rel, l, n }
      function lit(v) { return v != "" && v !~ /\$\{\{/ }
      function reset() { uses = ""; ul = 0; ver = ""; vl = 0; nv = ""; nvl = 0; nvf = ""; nvfl = 0
                         pv = ""; pvl = 0; pvf = ""; pvfl = 0; tc = ""; tcl = 0 }
      function flush() {
        if (uses ~ /^actions\/setup-node@/) {
          if (nv != "") { if (lit(nv)) out("node", "value", nv, nvl, "setup-node node-version") }
          else if (nvf != "") out("node", nvf == ".nvmrc" ? "derived" : "readsother", nvf, nvfl, "setup-node node-version-file")
          else out("node", "floating", "", ul, "setup-node with no version input")
        } else if (uses ~ /^actions\/setup-python@/) {
          if (pv != "") { if (lit(pv)) out("python", "value", pv, pvl, "setup-python python-version") }
          else if (pvf != "") out("python", pvf == ".python-version" ? "derived" : "readsother", pvf, pvfl, "setup-python python-version-file")
          else out("python", "floating", "", ul, "setup-python with no version input")
        } else if (uses ~ /^astral-sh\/setup-uv@/) {
          if (ver != "") { if (lit(ver)) out("uv", "value", ver, vl, "setup-uv version") }
          else out("uv", "floating", "", ul, "setup-uv with no version input - installs the newest uv")
          if (lit(pv)) out("python", "value", pv, pvl, "setup-uv python-version")
        } else if (uses ~ /^pnpm\/action-setup@/) {
          if (ver != "") { if (lit(ver)) out("pnpm", "value", ver, vl, "pnpm/action-setup version") }
          else out("pnpm", "derived", "packageManager", ul, "pnpm/action-setup reads packageManager")
        } else if (uses ~ /rust-toolchain@|setup-rust-toolchain@/) {
          if (lit(tc)) out("rust", "value", tc, tcl, "rust toolchain input")
        }
        reset()
      }
      BEGIN { reset(); insteps = 0; si = -1 }
      {
        line = $0
        if (line ~ /^[ \t]*#/ || line ~ /^[ \t]*$/) next
        i = ind(line)
        if (line ~ /^ *(NODE_VERSION|PYTHON_VERSION|UV_VERSION|PNPM_VERSION):/) {
          k = line; sub(/^ */, "", k); sub(/:.*/, "", k); v = val(line)
          t = (k == "NODE_VERSION") ? "node" : (k == "PYTHON_VERSION") ? "python" : (k == "UV_VERSION") ? "uv" : "pnpm"
          if (lit(v)) out(t, "value", v, NR, "env " k)
        }
        if (line ~ /uv run/ && match(line, /--python[ =][^ ]+/)) {
          v = substr(line, RSTART + 9, RLENGTH - 9); gsub(/["\047]/, "", v)
          out("python", "value", v, NR, "uv run --python")
        }
        if (line ~ /^ *steps:[ \t]*$/) { flush(); insteps = 1; si = -1; next }
        if (!insteps) next
        if (line ~ /^ *- /) {
          if (si < 0) si = i
          if (i == si) { flush() } else if (i < si) { flush(); insteps = 0; next }
        } else if (i < si) { flush(); insteps = 0; next }
        s = line; sub(/^ *- /, "", s); sub(/^ */, "", s)
        if (s ~ /^uses:/) { uses = val(s); ul = NR }
        else if (s ~ /^version:/) { ver = val(s); vl = NR }
        else if (s ~ /^node-version:/) { nv = val(s); nvl = NR }
        else if (s ~ /^node-version-file:/) { nvf = val(s); nvfl = NR }
        else if (s ~ /^python-version:/) { pv = val(s); pvl = NR }
        else if (s ~ /^python-version-file:/) { pvf = val(s); pvfl = NR }
        else if (s ~ /^toolchain:/) { tc = val(s); tcl = NR }
      }
      END { flush() }
    ' "$f"
  done
}

# Dockerfiles: base images, the uv image tag, and global pnpm installs.
extract_dockerfiles() {
  local root="$1" f
  [[ -d "$root/code/src/docker" ]] || return 0
  while IFS= read -r f; do
    awk -v rel="${f#"$root"/}" '
      function out(t, r, v, n) { printf "%s\t%s\t%s\t%s:%d\t%s\n", t, r, v, rel, NR, n }
      function tag(s) { sub(/@sha256:.*/, "", s); sub(/-.*/, "", s); return s }
      /^[ \t]*#/ { next }
      toupper($1) == "FROM" {
        img = $2; if (img ~ /^--platform=/) img = $3
        if (img ~ /^(docker\.io\/)?(library\/)?python:/) { sub(/^.*python:/, "", img); out("python", "value", tag(img), "FROM python") }
        else if (img ~ /^(docker\.io\/)?(library\/)?node:/) { sub(/^.*node:/, "", img); out("node", "value", tag(img), "FROM node") }
        else if (img ~ /^(docker\.io\/)?(library\/)?rust:/) { sub(/^.*rust:/, "", img); out("rust", "value", tag(img), "FROM rust") }
      }
      match($0, /astral-sh\/uv:[^ \/@]+/) {
        v = substr($0, RSTART + 13, RLENGTH - 13)
        out("uv", (v == "latest") ? "floating" : "value", v, "astral uv image tag")
      }
      match($0, /(npm install -g|corepack prepare) pnpm@[^ ]+/) {
        v = substr($0, RSTART, RLENGTH); sub(/.*pnpm@/, "", v); out("pnpm", "value", v, "global pnpm install")
      }
    ' "$f"
  done < <(find "$root/code/src/docker" -type f -name 'Dockerfile*' 2>/dev/null | sort)
}

# package.json manifests: the root and each workspace member under code/src/*.
extract_manifests() {
  local root="$1" f
  for f in "$root/package.json" "$root"/code/src/*/package.json; do
    [[ -f "$f" ]] || continue
    awk -v rel="${f#"$root"/}" -v isroot="$([[ "$f" == "$root/package.json" ]] && echo 1 || echo 0)" '
      function out(t, v, n) { printf "%s\tvalue\t%s\t%s:%d\t%s\n", t, v, rel, NR, n }
      function str(s) { sub(/^[^:]*:[ \t]*"/, "", s); sub(/".*$/, "", s); return s }
      /"engines"[ \t]*:[ \t]*\{/ { eng = 1 }
      eng && /"node"[ \t]*:/ { out("node", str($0), "engines.node") }
      eng && /"pnpm"[ \t]*:/ { out("pnpm", str($0), "engines.pnpm") }
      eng && /\}/ { eng = 0 }
      !isroot && /"packageManager"[ \t]*:/ { v = str($0); sub(/^pnpm@/, "", v); out("pnpm", v, "packageManager") }
    ' "$f"
  done
}

# pyproject.toml: every setting that names the interpreter or the uv a project expects.
extract_pyproject() {
  local root="$1"
  [[ -f "$root/pyproject.toml" ]] || return 0
  awk -v rel="pyproject.toml" '
    function out(t, v, n) { printf "%s\tvalue\t%s\t%s:%d\t%s\n", t, v, rel, NR, n }
    function str(s) { sub(/^[^=]*=[ \t]*"/, "", s); sub(/".*$/, "", s); return s }
    /^[ \t]*#/ { next }
    /^[ \t]*requires-python[ \t]*=/ { out("python", str($0), "requires-python") }
    /^[ \t]*target-version[ \t]*=[ \t]*"py3[0-9]+"/ { v = str($0); out("python", "3." substr(v, 4), "ruff target-version") }
    /^[ \t]*pythonVersion[ \t]*=/ { out("python", str($0), "pyright pythonVersion") }
    /^[ \t]*required-version[ \t]*=/ { out("uv", str($0), "[tool.uv] required-version") }
  ' "$root/pyproject.toml"
}

# Crate manifests: a literal rust-version below the workspace root is a second MSRV.
extract_crates() {
  local root="$1" f
  [[ -d "$root/code/src/rust/crates" ]] || return 0
  while IFS= read -r f; do
    awk -v rel="${f#"$root"/}" '
      /^[ \t]*rust-version[ \t]*=[ \t]*"/ { v = $0; sub(/^[^"]*"/, "", v); sub(/".*$/, "", v)
        printf "msrv\tvalue\t%s\t%s:%d\tcrate rust-version\n", v, rel, NR }
    ' "$f"
  done < <(find "$root/code/src/rust/crates" -name Cargo.toml -not -path '*/target/*' 2>/dev/null | sort)
}

# Shell scripts: an explicit interpreter handed to `uv run`. Fixtures are test data, not pins.
extract_scripts() {
  local root="$1" f
  [[ -d "$root/code/src/scripts" ]] || return 0
  while IFS= read -r f; do
    awk -v rel="${f#"$root"/}" '
      /^[ \t]*#/ { next }
      /uv run/ && match($0, /--python[ =][^ ]+/) {
        v = substr($0, RSTART + 9, RLENGTH - 9); gsub(/["\047]/, "", v)
        printf "python\tvalue\t%s\t%s:%d\tuv run --python\n", v, rel, NR }
    ' "$f"
  done < <(find "$root/code/src/scripts" -name '*.sh' -not -path '*/fixtures/*' 2>/dev/null | sort)
}

# Registered documents: every form a person writes a toolchain version in.
extract_docs() {
  local root="$1" pat f
  shopt -s nullglob
  for pat in "${DOC_REGISTER[@]}"; do
    # shellcheck disable=SC2086  # the register holds globs; expansion is the point
    for f in "$root"/$pat; do
      [[ -f "$f" ]] || continue
      awk -v rel="${f#"$root"/}" '
        function out(t, v, n) {
          if (t == "rust" && (v ~ /\+$/ || v ~ /^>=/)) t = "msrv"
          printf "%s\tvalue\t%s\t%s:%d\t%s\n", t, v, rel, NR, n }
        function tool(s) { s = tolower(s)
          if (s == "node" || s == "node.js") return "node"
          if (s == "python" || s == "uv" || s == "pnpm" || s == "rust") return s
          return "" }
        BEGIN { prec["node"] = 1; prec["pnpm"] = 1; prec["python"] = 2; prec["uv"] = 2; prec["rust"] = 2 }
        /^[ \t]*(```|~~~)/ { fence = !fence; next }
        {
          line = $0
          # Inline: "Node 24", "Python 3.14", "uv 0.12+", "pnpm 11.25.0", "Rust 1.92+". Prose
          # only — never inside a fence, where "Python 2 syntax" is an example, not a pin — and
          # never coarser than the tool moves at: "Python 3" in a sentence names a language.
          rest = fence ? "" : line
          while (match(rest, /(^|[^A-Za-z0-9_.\/-])(Node\.js|Node|Python|uv|pnpm|Rust) v?[0-9]+(\.[0-9]+)*(\.x)?\+?/)) {
            m = substr(rest, RSTART, RLENGTH); sub(/^[^A-Za-z]/, "", m)
            split(m, p, " "); v = p[2]; sub(/^v/, "", v)
            d = v; sub(/\.x$/, "", d); sub(/\+$/, "", d)
            if (split(d, dc, ".") >= prec[tool(p[1])]) out(tool(p[1]), v, "stated in prose")
            rest = substr(rest, RSTART + RLENGTH)
          }
          # Table: a row whose first cell names the tool and whose next cell is a version.
          if (!fence && line ~ /^\|/) {
            n = split(line, c, "|")
            if (n >= 4) {
              name = c[2]; gsub(/[*`]/, "", name); sub(/\(.*\)/, "", name); gsub(/^[ \t]+|[ \t]+$/, "", name)
              cell = c[3]; gsub(/^[ \t]+|[ \t]+$/, "", cell)
              if (tool(name) != "" && cell ~ /^v?[0-9]+(\.[0-9]+)*(\.x)?\+?$/) out(tool(name), cell, "table row")
            }
          }
          # Documentation links that carry the version in the URL.
          if (match(line, /latest-v[0-9]+\.x/)) { v = substr(line, RSTART + 8, RLENGTH - 10); out("node", v, "Node docs link") }
          if (match(line, /docs\.python\.org\/3\.[0-9]+/)) { v = substr(line, RSTART + 16, RLENGTH - 16); out("python", v, "Python docs link") }
          # The source files quoted by value: "`.nvmrc` pins `24`".
          if (match(line, /`\.nvmrc` pins `[^`]+`/)) { v = substr(line, RSTART, RLENGTH); sub(/.*pins `/, "", v); sub(/`$/, "", v); out("node", v, "quoted .nvmrc") }
          if (match(line, /`\.python-version` pins `[^`]+`/)) { v = substr(line, RSTART, RLENGTH); sub(/.*pins `/, "", v); sub(/`$/, "", v); out("python", v, "quoted .python-version") }
          if (match(line, /pnpm@[0-9][0-9.]*[0-9]/)) { v = substr(line, RSTART + 5, RLENGTH - 5); out("pnpm", v, "quoted pnpm@") }
          if (match(line, /`rust-version` \([0-9.]+\)/)) { v = substr(line, RSTART, RLENGTH); sub(/.*\(/, "", v); sub(/\)$/, "", v); out("msrv", v, "quoted rust-version") }
          # The version-check comments: "node --version && pnpm --version  # 24+ / 11.25.0+".
          if (match(line, /(node|python3?) --version && (pnpm|uv) --version[ \t]*# *[^ ]+ *\/ *[^ ]+/)) {
            m = substr(line, RSTART, RLENGTH); a = m; sub(/ .*/, "", a); b = m; sub(/^.*&& */, "", b); sub(/ .*/, "", b)
            vs = m; sub(/^[^#]*# */, "", vs); split(vs, q, "/"); gsub(/[ \t]/, "", q[1]); gsub(/[ \t]/, "", q[2])
            out(a == "node" ? "node" : "python", q[1], "version-check comment"); out(b, q[2], "version-check comment")
          }
        }
      ' "$f"
    done
  done
  shopt -u nullglob
}

collect_sites() {
  local root="$1"
  extract_workflows "$root"
  extract_dockerfiles "$root"
  extract_manifests "$root"
  extract_pyproject "$root"
  extract_crates "$root"
  extract_scripts "$root"
  extract_docs "$root"
}

# ── Evaluation ────────────────────────────────────────────────────────────────
# Reads sources on fd 3 and sites on stdin; prints "class<TAB>tool<TAB>raw<TAB>where<TAB>note".
evaluate() {
  local held_spec
  held_spec="$(printf '%s\n' "${HELD[@]}" | sed 's/|.*//' | tr '\n' ' ')"
  awk -F '\t' -v held="$held_spec" '
    function norm(raw,   r, n, i, p, out) {
      r = raw; gsub(/["\047 ]/, "", r); sub(/,.*/, "", r)
      sub(/^(>=|<=|==|~=|=|>|~|\^)/, "", r); sub(/^v/, "", r); sub(/\+$/, "", r)
      n = split(r, p, "."); out = ""; NC = 0
      for (i = 1; i <= n; i++) { if (p[i] !~ /^[0-9]+$/) break; out = (out == "" ? p[i] : out "." p[i]); NC++ }
      return out
    }
    function agrees(a, b,   x, y, k, i) {
      split(a, x, "."); split(b, y, "."); k = (NA < NB) ? NA : NB
      for (i = 1; i <= k; i++) if (x[i] + 0 != y[i] + 0) return 0
      return 1
    }
    BEGIN {
      prec["node"] = 1; prec["pnpm"] = 1; prec["python"] = 2; prec["uv"] = 2; prec["rust"] = 2; prec["msrv"] = 2
      split(held, h, " "); for (i in h) if (h[i] != "") isheld[h[i]] = 1
      while ((getline l < "/dev/fd/3") > 0) { split(l, s, "\t"); src[s[1]] = s[2] }
    }
    {
      t = $1; role = $2; raw = $3; where = $4; note = $5
      if (src[t] == "__ABSENT__") { cls = "absent" }
      else if (role == "derived") { cls = "derived" }
      else if (role == "readsother") { cls = "readsother" }
      else if (src[t] == "") { cls = "nosource" }
      else {
        a = norm(raw); NA = NC
        if (role == "floating" || NA < prec[t]) cls = "unpinned"
        else { b = norm(src[t]); NB = NC; cls = agrees(a, b) ? "agree" : "drift" }
      }
      if ((cls == "unpinned") && ((t ":" cls) in isheld)) cls = "held"
      printf "%s\t%s\t%s\t%s\t%s\n", cls, t, raw, where, note
    }
  ' 3< <(printf '%s\n' "$SOURCES")
}

# Runs one root: sets SOURCES, RESULTS, SITE_COUNT, FAIL_COUNT, HELD_COUNT.
audit_root() {
  local root="$1" sites
  SOURCES="$(read_sources "$root")"
  sites="$(collect_sites "$root")"
  if [[ -z "$sites" ]]; then
    RESULTS=""
  else
    RESULTS="$(printf '%s\n' "$sites" | evaluate)"
  fi
  SITE_COUNT=$(printf '%s' "$RESULTS" | grep -c . || true)
  FAIL_COUNT=$(printf '%s\n' "$RESULTS" | grep -cE '^(drift|unpinned|readsother|nosource)'$'\t' || true)
  HELD_COUNT=$(printf '%s\n' "$RESULTS" | grep -c '^held'$'\t' || true)
}

# ── Self-test ─────────────────────────────────────────────────────────────────
# Two fixture trees, each carrying expected.txt — the "class tool file" lines the detector
# must report, held tier included. Then the odd-form probes, run through the same evaluator.
# Fix the detector, never the fixtures.
run_self_test() {
  local variant actual expected failed=0 probe
  for variant in agree drift; do
    [[ -f "$FIXTURES_DIR/$variant/expected.txt" ]] || die "self-test fixture missing: fixtures/toolchain-pins/$variant"
  done
  bold "▸ toolchain-pins.sh --self-test"
  for variant in agree drift; do
    audit_root "$FIXTURES_DIR/$variant"
    actual="$(printf '%s\n' "$RESULTS" | awk -F '\t' '$1 != "agree" && $1 != "derived" && $1 != "absent" { w = $4; sub(/:[0-9]+$/, "", w); print $1, $2, w }' | sort)"
    expected="$(grep -v '^#' "$FIXTURES_DIR/$variant/expected.txt" | grep . | sort || true)"
    log "  $variant: $SITE_COUNT site(s) read, $FAIL_COUNT failing, $HELD_COUNT held"
    if [[ "$actual" != "$expected" ]]; then
      failed=1
      log "  ✗ $variant reported something other than expected.txt:"
      diff <(printf '%s\n' "$expected") <(printf '%s\n' "$actual") | sed 's/^/      /' || true
    fi
  done
  # The agreeing tree must actually be READ: a silent extractor reports nothing, which on
  # that tree looks identical to agreement. Its site count is asserted, not just its findings.
  audit_root "$FIXTURES_DIR/agree"
  local want_sites
  want_sites="$(sed -nE 's/^# sites: ([0-9]+)$/\1/p' "$FIXTURES_DIR/agree/expected.txt")"
  if [[ "$SITE_COUNT" != "$want_sites" ]]; then
    failed=1; log "  ✗ agree tree: read $SITE_COUNT site(s), expected $want_sites — an extractor went silent"
  fi
  # Odd forms: "tool raw source expected-class".
  local probes=(
    "node >=24 24 agree" "node 24.x 24 agree" "node 24+ 24 agree" "node >=22 24 drift"
    "node latest 24 unpinned" "python 3.x 3.14 unpinned" "python 3 3.14 unpinned"
    "python >=3.14 3.14 agree" "python 3.14.8 3.14 agree" "python 3.13 3.14 drift"
    "uv 0.12.x 0.12.5 agree" "uv 0.11+ 0.12.5 drift" "uv >=0.12.22,<0.13 0.12.5 drift"
    "uv latest 0.12.5 held" "pnpm 11.x 11.25.0 agree" "pnpm >=11.25.0 11.25.0 agree"
    "pnpm ^11.2 11.25.0 drift" "rust 1.97 1.97.1 agree" "rust stable 1.97.1 unpinned"
  )
  for probe in "${probes[@]}"; do
    # shellcheck disable=SC2086  # word-split the probe into its four fields
    set -- $probe
    SOURCES="$(printf '%s\t%s\tprobe\n' "$1" "$3")"
    got="$(printf '%s\tvalue\t%s\tprobe:1\tprobe\n' "$1" "$2" | evaluate | cut -f1)"
    if [[ "$got" != "$4" ]]; then failed=1; log "  ✗ probe $1 '$2' against $3: got $got, expected $4"; fi
  done
  log "  probes: ${#probes[@]} odd form(s)"
  log ""
  if [[ $failed -eq 0 ]]; then
    bold "✓ Self-test passed — the detector separates agreement from drift, and holds only the held class."
    exit 0
  fi
  bold "✗ Self-test FAILED — fix the detector, never the fixtures."
  exit 1
}

# ── Run ───────────────────────────────────────────────────────────────────────
log ""
bold "▸ toolchain-pins.sh — $(date -u '+%Y-%m-%dT%H:%M:%SZ')"

$SELF_TEST && run_self_test

audit_root "$PROJECT_ROOT"

log ""
log "  Sources of truth:"
printf '%s\n' "$SOURCES" | while IFS=$'\t' read -r t v w; do
  case "$v" in
    __ABSENT__) log "    $(printf '%-7s' "$t") not compared — $w (no Rust surface)" ;;
    "")         log "    $(printf '%-7s' "$t") ABSENT — $w" ;;
    *)          log "    $(printf '%-7s' "$t") $v  ($w)" ;;
  esac
done
log ""
log "  Population: $SITE_COUNT site(s) across workflows, Dockerfiles, manifests, pyproject.toml,"
log "  crate manifests, scripts and ${#DOC_REGISTER[@]} registered document pattern(s)."
for t in node python uv pnpm rust msrv; do
  line="$(printf '%s\n' "$RESULTS" | awk -F '\t' -v t="$t" '$2 == t { n++; c[$1]++ } END {
    if (!n) { print "0 sites"; exit } s = n " site(s):"
    for (k in c) s = s " " c[k] " " k; print s }')"
  log "    $(printf '%-7s' "$t") $line"
done

print_class() {
  local cls="$1" title="$2" rows
  rows="$(printf '%s\n' "$RESULTS" | awk -F '\t' -v c="$cls" '$1 == c { printf "    %-7s %-14s %s  (%s)\n", $2, ($3 == "" ? "(none)" : $3), $4, $5 }')"
  [[ -n "$rows" ]] || return 0
  log ""
  log "  $title"
  log "$rows"
}
print_class drift      "[drift] states a version other than its source's:"
print_class unpinned   "[unpinned] states no version, or one coarser than the tool moves at:"
print_class readsother "[reads-other] reads a version file that is not the source:"
print_class nosource   "[no-source] names a tool whose source of truth is absent:"
if [[ $HELD_COUNT -gt 0 ]]; then
  for h in "${HELD[@]}"; do
    print_class held "[held - not failing] ${h%%|*} is assigned to ${h#*|}:"
  done
fi

# ── Report ────────────────────────────────────────────────────────────────────
if [[ -n "$OUTPUT_FORMAT" ]]; then
  mkdir -p "$REPORTS_DIR"
  target="${OUTPUT_FILE:-$REPORTS_DIR/toolchain-pins-report.$OUTPUT_FORMAT}"
  case "$OUTPUT_FORMAT" in
    json)
      {
        printf '{\n  "failing": %d,\n  "held": %d,\n  "sites_read": %d,\n  "sources": [\n' "$FAIL_COUNT" "$HELD_COUNT" "$SITE_COUNT"
        printf '%s\n' "$SOURCES" | awk -F '\t' '{ gsub(/"/, "\\\""); printf "%s    {\"tool\": \"%s\", \"value\": \"%s\", \"where\": \"%s\"}", (NR > 1 ? ",\n" : ""), $1, $2, $3 } END { print "" }'
        printf '  ],\n  "sites": [\n'
        printf '%s\n' "$RESULTS" | awk -F '\t' 'NF { gsub(/"/, "\\\""); printf "%s    {\"class\": \"%s\", \"tool\": \"%s\", \"value\": \"%s\", \"where\": \"%s\", \"note\": \"%s\"}", (n++ ? ",\n" : ""), $1, $2, $3, $4, $5 } END { print "" }'
        printf '  ]\n}\n'
      } > "$target"
      ;;
    md)
      {
        printf '# Toolchain pin audit\n\n'
        printf 'Does every pin of Node, Python, uv, pnpm and Rust name its source of truth'"'"'s version?\n'
        # shellcheck disable=SC2016  # literal Markdown backticks, nothing to expand
        printf 'Rule: `how-to/workflows/07-dependency-updates/STEPS.md` Step 4 - the matched set.\n\n'
        printf 'Failing: %d - held: %d - sites read: %d\n\n' "$FAIL_COUNT" "$HELD_COUNT" "$SITE_COUNT"
        printf '| Class | Tool | Value | Site | Note |\n| ----- | ---- | ----- | ---- | ---- |\n'
        printf '%s\n' "$RESULTS" | awk -F '\t' 'NF { printf "| %s | %s | `%s` | `%s` | %s |\n", $1, $2, $3, $4, $5 }'
      } > "$target"
      ;;
    txt)
      {
        printf 'Toolchain pin audit\n\nFailing: %d - held: %d - sites read: %d\n\n' "$FAIL_COUNT" "$HELD_COUNT" "$SITE_COUNT"
        printf '%s\n' "$RESULTS" | awk -F '\t' 'NF { printf "%-10s %-7s %-14s %s  (%s)\n", $1, $2, $3, $4, $5 }'
      } > "$target"
      ;;
  esac
  log ""
  log "  report: ${target#"$PROJECT_ROOT"/}"
fi

log ""
if [[ $FAIL_COUNT -eq 0 ]]; then
  if [[ $HELD_COUNT -gt 0 ]]; then
    bold "✓ Every pin agrees with its source — $HELD_COUNT held site(s) above are owned elsewhere, not clean."
  else
    bold "✓ Every pin agrees with its source."
  fi
  exit 0
fi

bold "✗ $FAIL_COUNT toolchain pin(s) disagree with their source of truth."
log ""
log "  Move every site to the source's version in one change, or move the source and"
log "  every site with it. A held site is not part of this count."
exit 1
