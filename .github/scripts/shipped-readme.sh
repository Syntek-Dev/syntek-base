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
#                     Three against the tree's NESTED entries — the level checks 1–3
#                     never reach, and where the 09/08/2026 sweep found its drift:
#                      10. Every shipping .github/workflows/*.yml appears.
#                      11. Every shipping code/docs/*.md appears.
#                      12. Every shipping code/src/*/ appears.
#
#                     Numbers are stable identifiers — other documents cite them.
#                     Append, never renumber.
#
#                     What it CANNOT check: prose that is present but wrong — a tree entry
#                     whose description no longer matches, or a count stated in words.
#                     Only review defends against that.
#
# SELF-TEST. --self-test deletes one required row per tree check from a copy of the
#            README and asserts each check catches its own, then proves in_tree's
#            boundary rule directly. Unlike the fixture pairs under audits/, the
#            known-positives are DERIVED from the real README: a checked-in README
#            fixture would carry 28 CI workflows and 32 guides and go stale within
#            the week — the exact drift these checks exist to catch.
#
# Requirements: git, grep, awk. No network.
#
# Usage: shipped-readme.sh [--quiet] [--self-test] [--help]
#
# Exit codes:  0 = shipped docs match the repository
#              1 = drift found, or the self-test no longer separates
#              2 = script error (bad arguments, or a self-test that could not run)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

README="$PROJECT_ROOT/.copier/README.md"
TOKENS="$PROJECT_ROOT/how-to/src/TEMPLATE-TOKENS.md"
COPIER="$PROJECT_ROOT/copier.yml"

QUIET=false
SELF_TEST=false

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'shipped-readme.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
shipped-readme.sh — Verify the shipped README and token contract match the repository

Usage: shipped-readme.sh [--quiet] [--self-test] [--help]

  --quiet      Suppress progress output; print findings only
  --self-test  Prove the tree checks still fire: delete one required row per check
               from a copy of the README and assert each one is caught
  --help       Show this message

Exit codes: 0 = match  1 = drift found, or the self-test no longer separates  2 = script error
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --quiet|-q)  QUIET=true; shift ;;
    --self-test) SELF_TEST=true; shift ;;
    --help|-h)   usage; exit 0 ;;
    *)           die "unknown argument: $1" ;;
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

# A name must appear as a tree ROW, not merely somewhere in the tree text. Two ways a
# bare grep passes a check that should fail, both of them real:
#
#   incidental prose  DOCUMENTATION-PAIRING.md's description is "the CONTEXT.md /
#                     CLAUDE.md split" — it answers a search for CONTEXT.md from inside
#                     the very block that search is meant to police.
#   one row answering for another
#                     `── VERSION-HISTORY.md` contains the string `VERSION`, so the
#                     VERSION row could be deleted and never missed.
#
# So: the name must follow the `── ` connector every row carries and no description uses
# (descriptions use ← and —), and must END at that row — the next character is a space,
# a `/`, or the line's end. Done in awk to keep filenames literal; a regex would have to
# escape the dot in every one of them.
in_tree() { # $1 = a tree blob, $2 = the entry name as the tree writes it
  awk -v n="$2" '
    { i = index($0, "── " n)
      if (i > 0) {
        c = substr($0, i + length("── " n), 1)
        if (c == "" || c == " " || c == "/") { hit = 1; exit }
      } }
    END { exit !hit }' <<< "$1"
}

# How many rows carry this name, anywhere in the tree. Only the self-test needs it:
# it picks an unambiguous mutation target, so that deleting "the CONTEXT.md row"
# cannot silently delete a different one of the dozen that exist.
count_rows() { # $1 = a tree blob, $2 = the entry name
  awk -v n="$2" '
    { i = index($0, "── " n)
      if (i > 0) {
        c = substr($0, i + length("── " n), 1)
        if (c == "" || c == " " || c == "/") k++
      } }
    END { print k+0 }' <<< "$1"
}

tree_section() {    # $1 = the tree line the top-level section opens with
  awk -v s="$1" 'index($0,s)==1 {f=1;next} f && /^[├└]── /{f=0} f' <<< "$TREE"
}
tree_subsection() { # $1 = a section blob, $2 = the line the sub-section opens with
  awk -v s="$2" 'index($0,s)==1 {f=1;next} f && /^│   [├└]── /{f=0} f' <<< "$1"
}

# ── The README checks, as one re-pointable unit ───────────────────────────────
#
# Every scope below derives from $README, so --self-test can repoint that at a mutated
# copy and re-run the whole set. Checks 8 and 9 are deliberately NOT in here: they read
# the token contract and the shipping file list rather than the README, so no mutation
# of it can change their answer, and check 9's tree-wide grep is the slow one.
run_readme_checks() {
  FINDINGS=()

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

# ── 1. Root entries ───────────────────────────────────────────────────────────
for entry in $(ls -A | grep -vE '^(\.git|node_modules|\.venv|\.code-review-graph)$'); do
  is_excluded "$entry" && continue
  case "$entry" in .*) [[ "$entry" == ".claude" || "$entry" == ".agents" || "$entry" == ".mcp.json" || "$entry" == ".zed" ]] || continue ;; esac
  in_tree "$TREE" "$entry" || finding "Project Tree omits shipping root entry: $entry"
done

# ── 2. PM src/ folders ────────────────────────────────────────────────────────
for d in project-management/src/*/; do
  n=$(basename "$d"); is_excluded "$d" && continue
  in_tree "$TREE" "$n" || finding "Project Tree omits PM artefact folder: src/$n"
done

# ── 3. Workflow directories ───────────────────────────────────────────────────
for d in project-management/workflows/*/ code/workflows/*/ how-to/workflows/*/; do
  n=$(basename "$d"); is_excluded "${d%/}" && continue
  in_tree "$TREE" "$n" || finding "Project Tree omits workflow: ${d%/}"
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

# ── 10/11/12. Nested tree entries ─────────────────────────────────────────────
#
# Checks 1–3 reach the top level and the three folder families that are named as a
# set. Everything nested below that went unchecked, and that is exactly where the
# drift lived: a `.github/workflows/` block listing 11 of 28, a `code/docs/` block
# missing eight guides that ship everywhere, and a `code/src/` block missing a
# directory no surface gates.
#
# Each is scoped to its own sub-block before being searched, on the same principle
# as the registers above: `CONTEXT.md` appears a dozen times in this tree, so a
# whole-tree grep proves nothing about the one under `code/docs/`. Scoping alone is
# not enough either — hence in_tree, whose header explains what a bare grep lets past.
GH_BLOCK=$(tree_section '├── .github/')
CODE_BLOCK=$(tree_section '├── code/')
DOCS_BLOCK=$(tree_subsection "$CODE_BLOCK" '│   ├── docs/')
SRC_BLOCK=$(tree_subsection "$CODE_BLOCK" '│   ├── src/')

[[ -n "$GH_BLOCK"   ]] || die "no '.github/' block in the Project Tree"
[[ -n "$DOCS_BLOCK" ]] || die "no 'code/docs/' block in the Project Tree"
[[ -n "$SRC_BLOCK"  ]] || die "no 'code/src/' block in the Project Tree"

for f in .github/workflows/*.yml; do
  is_excluded "$f" && continue
  in_tree "$GH_BLOCK" "$(basename "$f")" || finding "Project Tree omits CI workflow: $f"
done

for f in code/docs/*.md; do
  is_excluded "$f" && continue
  in_tree "$DOCS_BLOCK" "$(basename "$f")" || finding "Project Tree omits code guide: $f"
done

for d in code/src/*/; do
  is_excluded "${d%/}" && continue
  in_tree "$SRC_BLOCK" "$(basename "$d")" || finding "Project Tree omits source directory: ${d%/}"
done
}

# ── Self-test ─────────────────────────────────────────────────────────────────
#
# The known-negative is the real README; the known-positives are generated FROM it,
# one row deleted per tree check. That is the one difference from the fixture pairs
# under audits/: a checked-in README fixture would have to carry 28 CI workflows and
# 32 guides and would rot the week after it was written — the exact staleness these
# checks exist to catch. Deriving the positives keeps the proof honest for free.
#
# Targets are chosen from the same globs the checks iterate, never hardcoded, and only
# names appearing on exactly ONE row are eligible, so a deletion is unambiguous.
#
# Part 1 is the piece no mutation can reach: the real README contains no prefix
# collision among required names, so in_tree's boundary rule is proved directly.
self_test() {
  local fails=0 probes=0 tmp target path name out

  bold "▸ shipped-readme.sh --self-test"
  log  ""
  command -v mktemp >/dev/null 2>&1 || die "mktemp unavailable — refusing to report a proof that never ran"

  # ── Part 1: the matching rule, in isolation ─────────────────────────────────
  local BLOB='├── VERSION-HISTORY.md                   ← full version bump history
├── audit-template-slop.yml              ← the AI-slop family, markup half
│   ├── DOCUMENTATION-PAIRING.md         ← the CONTEXT.md / CLAUDE.md split
├── eslint.config.mjs
├── docker/                              ← Dockerfiles and Compose files'
  local must_miss=(VERSION audit-template.yml CONTEXT.md CLAUDE.md)
  local must_hit=(VERSION-HISTORY.md audit-template-slop.yml eslint.config.mjs docker)
  for name in "${must_miss[@]}"; do
    probes=$((probes + 1))
    if in_tree "$BLOB" "$name"; then
      fails=$((fails + 1))
      printf '\033[31m  ✗ boundary: "%s" matched a row that only CONTAINS it\033[0m\n' "$name"
    fi
  done
  for name in "${must_hit[@]}"; do
    probes=$((probes + 1))
    if ! in_tree "$BLOB" "$name"; then
      fails=$((fails + 1))
      printf '\033[31m  ✗ boundary: "%s" is a real row and was not found\033[0m\n' "$name"
    fi
  done

  # ── Part 2: the known-negative — the real README must trip nothing ──────────
  run_readme_checks
  if [[ ${#FINDINGS[@]} -ne 0 ]]; then
    printf '\033[31m  ✗ the real README already fails — a mutation proof on a broken baseline means nothing\033[0m\n' >&2
    printf '    %s\n' "${FINDINGS[@]}" >&2
    exit 2
  fi

  # ── Part 3: one deleted row per tree check must produce exactly one finding ──
  local REAL_README="$README"
  tmp=$(mktemp) || die "could not create a temporary file"
  # shellcheck disable=SC2064
  trap "rm -f '$tmp'; README='$REAL_README'" RETURN

  local probe
  for probe in \
    "1|$TREE|$(printf '%s ' *.md *.yml *.json)" \
    "2|$TREE|$(printf '%s ' project-management/src/*/)" \
    "3|$TREE|$(printf '%s ' code/workflows/*/)" \
    "10|$GH_BLOCK|$(printf '%s ' .github/workflows/*.yml)" \
    "11|$DOCS_BLOCK|$(printf '%s ' code/docs/*.md)" \
    "12|$SRC_BLOCK|$(printf '%s ' code/src/*/)"
  do
    local num="${probe%%|*}" rest="${probe#*|}"
    local blob="${rest%%|*}" candidates="${rest#*|}"

    # shellcheck disable=SC2086
    target=$(first_required "$blob" $candidates) || {
      fails=$((fails + 1))
      printf '\033[31m  ✗ check %s: no unambiguous mutation target — the proof cannot run\033[0m\n' "$num"
      continue
    }
    path="${target%%	*}"; name="${target##*	}"

    drop_row "$REAL_README" "$name" > "$tmp"
    README="$tmp"
    run_readme_checks
    README="$REAL_README"
    probes=$((probes + 1))

    if [[ ${#FINDINGS[@]} -eq 1 ]] && [[ "${FINDINGS[0]}" == *"$path"* || "${FINDINGS[0]}" == *"$name"* ]]; then
      log "  ✓ check $num fires on a missing row — $path"
    else
      fails=$((fails + 1))
      out=$(printf '%s; ' "${FINDINGS[@]:-(none)}")
      printf '\033[31m  ✗ check %s: deleting %s produced %d finding(s): %s\033[0m\n' \
        "$num" "$path" "${#FINDINGS[@]}" "$out"
    fi
  done

  log ""
  if [[ "$fails" -eq 0 ]]; then
    bold "✓ Self-test passed — $probes probes: the boundary rule holds and all six tree checks fire."
    log ""
    return 0
  fi
  log "  the detector no longer separates a complete tree from a mutated one —"
  log "  fix the check, never the expectation."
  log ""
  return 1
}

# Pick a row the README is REQUIRED to carry AND that appears exactly once, so deleting
# it is both a genuine omission and an unambiguous edit. Derived from the check's own
# glob rather than a hardcoded name, so a rename cannot quietly rot the proof.
first_required() { # $1 = the blob the check searches, $2… = candidate paths
  local blob="$1"; shift
  local p q n
  for p in "$@"; do
    q="${p%/}"; [[ -e "$q" ]] || continue
    n=$(basename "$q")
    is_excluded "$q" && continue
    in_tree "$blob" "$n" || continue
    [[ "$(count_rows "$TREE" "$n")" == "1" ]] || continue
    printf '%s\t%s' "$q" "$n"
    return 0
  done
  return 1
}

# Delete the FIRST row carrying this name, by the same boundary rule the checks use.
drop_row() { # $1 = a README path, $2 = the entry name
  awk -v n="$2" '
    !gone { i = index($0, "── " n)
      if (i > 0) {
        c = substr($0, i + length("── " n), 1)
        if (c == "" || c == " " || c == "/") { gone = 1; next }
      } }
    { print }' "$1"
}

if $SELF_TEST; then
  self_test
  exit $?
fi

bold "▸ shipped-readme.sh"
log  "  checking .copier/README.md and TEMPLATE-TOKENS.md against the repository…"
log  ""

run_readme_checks

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
