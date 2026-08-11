#!/usr/bin/env bash
#
# shipped-readme.sh — Verify the documentation a generated project receives still
#                     describes the template that generated it.
#
#                     Two documents drift silently, because nothing consuming them is
#                     ever run by the template's own CI:
#
#                       .copier/README.md          the README a generated project GETS
#                                                  (copier.yml excludes /README.md and
#                                                  _tasks renames this one into its place)
#                       how-to/src/TEMPLATE-TOKENS.md
#                                                  the prose token contract copier.yml
#                                                  implements
#
#                     Neither has a consumer that fails when it goes stale. A developer
#                     opening a generated project reads a tree missing four directories
#                     and an audit table listing four scripts of thirteen, and has no way
#                     to know. That is what this catches.
#
#                     Seven checks against the shipped README:
#                       1. Every shipping root entry appears in the Project Tree.
#                       2. Every project-management/src/NN-… folder appears.
#                       3. Every workflow directory appears (surface-gated ones exempt).
#                       4. Every audits/*.sh appears in the audit-script register.
#                       5. Every .claude/skills/*/ appears in the skills register.
#                       6. No link resolves to a path copier excludes — it would be dead
#                          on arrival in a generated project.
#                       7. Every local .md path it links to exists.
#
#                     Two against the token contract:
#                       8. Every copier.yml question is documented.
#                       9. Every token actually used in a shipped file is documented.
#
#                     What it CANNOT check: prose that is present but wrong — a tree entry
#                     whose description no longer matches, or a count stated in words.
#                     Only review defends against that.
#
# Requirements: git, grep, awk. No network.
#
# Usage: shipped-readme.sh [--quiet] [--help]
#
# Exit codes:  0 = shipped docs match the repository   1 = drift found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

README="$PROJECT_ROOT/.copier/README.md"
TOKENS="$PROJECT_ROOT/how-to/src/TEMPLATE-TOKENS.md"
COPIER="$PROJECT_ROOT/copier.yml"

QUIET=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-readme.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
shipped-readme.sh — Verify the shipped README and token contract match the repository

Usage: shipped-readme.sh [--quiet] [--help]

  --quiet   Suppress progress output; print findings only
  --help    Show this message

Exit codes: 0 = match  1 = drift found  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q) QUIET=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT"
[[ -f "$README" ]] || die "missing $README"
[[ -f "$TOKENS" ]] || die "missing $TOKENS"
[[ -f "$COPIER" ]] || die "missing $COPIER"

FINDINGS=()
finding() { FINDINGS+=("$1"); }

# ── The copier exclusion set ──────────────────────────────────────────────────
#
# Unconditional entries never reach a generated project, so the README must NOT be
# required to list them — and must not link to them either. Conditional entries
# (`<: if not INCLUDE_X :>…<: endif :>`) are the optional surfaces: absent from the
# README is correct for the default generation, so they are exempt rather than required.
EXCLUDED_FIXED=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
  | grep -v '<:' | sed 's/^[[:space:]]*-[[:space:]]*//' | sed 's#^/##' | sed 's/^"//;s/"$//' | grep -v '^$' || true)
EXCLUDED_GATED=$(awk '/^_exclude:/{f=1;next} /^[a-zA-Z_]+:/{f=0} f && /^[[:space:]]*-/' "$COPIER" \
  | grep '<:' | grep -oE '>/[^<]+<' | sed 's/^>\///;s/<$//' || true)

is_excluded() {
  local p="${1#./}"
  while read -r e; do [[ -z "$e" ]] && continue; [[ "$p" == "$e" || "$p" == "$e"/* ]] && return 0; done <<< "$EXCLUDED_FIXED"
  while read -r e; do [[ -z "$e" ]] && continue; [[ "$p" == "$e" || "$p" == "$e"/* ]] && return 0; done <<< "$EXCLUDED_GATED"
  return 1
}

# Each register is isolated to its own section before being searched. Scoping is the
# whole game here: the attribution tables name every skill in backticks, and the prose
# says "an interactive bash wizard" — either satisfies a naive whole-file grep while the
# register row it is meant to prove is missing.
TREE=$(awk '/^## Project Tree/{f=1} f; /^## Prerequisites/{f=0}' "$README")
SKILLS_REG=$(awk '/^### Skills/{f=1;next} /^### /{f=0} f' "$README")
AUDIT_REG=$(awk '/^### Audit scripts/{f=1;next} /^### /{f=0} f' "$README")

[[ -n "$TREE"       ]] || die "no '## Project Tree' section in $README"
[[ -n "$SKILLS_REG" ]] || die "no '### Skills' section in $README"
[[ -n "$AUDIT_REG"  ]] || die "no '### Audit scripts' section in $README"

bold "▸ shipped-readme.sh"
log  "  checking .copier/README.md and TEMPLATE-TOKENS.md against the repository…"
log  ""

# ── 1. Root entries ───────────────────────────────────────────────────────────
for entry in $(ls -A | grep -vE '^(\.git|node_modules|\.venv|\.code-review-graph)$'); do
  is_excluded "$entry" && continue
  case "$entry" in .*) [[ "$entry" == ".claude" || "$entry" == ".agents" || "$entry" == ".mcp.json" || "$entry" == ".zed" ]] || continue ;; esac
  grep -qF "$entry" <<< "$TREE" || finding "Project Tree omits shipping root entry: $entry"
done

# ── 2. PM src/ folders ────────────────────────────────────────────────────────
for d in project-management/src/*/; do
  n=$(basename "$d"); is_excluded "$d" && continue
  grep -qF "$n" <<< "$TREE" || finding "Project Tree omits PM artefact folder: src/$n"
done

# ── 3. Workflow directories ───────────────────────────────────────────────────
for d in project-management/workflows/*/ code/workflows/*/ how-to/workflows/*/; do
  n=$(basename "$d"); is_excluded "${d%/}" && continue
  grep -qF "$n" <<< "$TREE" || finding "Project Tree omits workflow: ${d%/}"
done

# ── 4. Audit scripts ──────────────────────────────────────────────────────────
for s in code/src/scripts/audits/*.sh; do
  n=$(basename "$s"); is_excluded "$s" && continue
  grep -qF "\`$n\`" <<< "$AUDIT_REG" || finding "Audit-script register omits: $n"
done

# ── 5. Skills ─────────────────────────────────────────────────────────────────
for d in .claude/skills/*/; do
  n=$(basename "$d"); is_excluded "${d%/}" && continue
  # cloudinary-* are covered by a single wildcard row
  [[ "$n" == cloudinary-* ]] && { grep -qF '`cloudinary-*`' <<< "$SKILLS_REG" || finding "Skills register omits the cloudinary-* row"; continue; }
  # Backticked, as the register writes it — a bare name matches incidental prose
  # ("authoring an interactive bash wizard") and would pass a missing row.
  grep -qF "\`$n\`" <<< "$SKILLS_REG" || finding "Skills register omits: $n"
done

# ── 6/7. Links ────────────────────────────────────────────────────────────────
while read -r target; do
  [[ -z "$target" ]] && continue
  if is_excluded "$target"; then
    finding "Link is dead in a generated project (copier excludes it): $target"
  elif [[ "$target" == *.md && ! -e "$target" ]]; then
    finding "Link target does not exist: $target"
  fi
done < <(grep -oE '\]\([A-Za-z0-9_./-]+\)' "$README" | sed 's/](//;s/)//' | grep -v '^http' | sort -u)

# ── 8. Every copier question is documented ────────────────────────────────────
while read -r q; do
  [[ -z "$q" ]] && continue
  grep -qF "<%$q%>" "$TOKENS" || finding "TEMPLATE-TOKENS.md does not document copier question: $q"
done < <(grep -E '^[A-Z_]+:' "$COPIER" | sed 's/:$//' | sort -u)

# ── 9. Every token used in a SHIPPING file is documented ──────────────────────
#
# Scoped to files that actually reach a generated project. A token appearing only in
# an excluded file is prose about the template — TEMPLATE-GUIDE's troubleshooting entry
# for a placeholder that survived generation — not a token the contract owes an entry for.
SHIPPING_FILES=$(git ls-files | grep -v '\.pdf$' | while read -r f; do is_excluded "$f" || printf '%s\n' "$f"; done)
while read -r tok; do
  [[ -z "$tok" ]] && continue
  grep -qF "<%$tok%>" "$TOKENS" || finding "TEMPLATE-TOKENS.md does not document token in use: <%$tok%>"
done < <(printf '%s\n' "$SHIPPING_FILES" | tr '\n' '\0' | xargs -0 -r grep -ho '<%[A-Z_]*%>' 2>/dev/null | tr -d '<%>' | sort -u)

# ── Report ────────────────────────────────────────────────────────────────────
if [[ ${#FINDINGS[@]} -eq 0 ]]; then
  log ""
  bold "✓ Shipped README and token contract match the repository."
  exit 0
fi

log ""
bold "✗ ${#FINDINGS[@]} drift finding(s):"
printf '  · %s\n' "${FINDINGS[@]}"
log ""
log "  .copier/README.md is the README a generated project receives — fix it there,"
log "  not in the root README.md, which copier.yml excludes."
exit 1
