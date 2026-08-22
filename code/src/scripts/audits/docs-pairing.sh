#!/usr/bin/env bash
#
# docs-pairing.sh — Enforce the CONTEXT.md / CLAUDE.md split.
#
#                   CONTEXT.md says what is here and why it is here.
#                   CLAUDE.md says how to work here.
#
#                   The two drift in one direction: an operating rule gets written into
#                   an orientation file because it was useful on arrival, and the paired
#                   CLAUDE.md keeps its own copy in different words. Two wordings of one
#                   rule is one rule nobody can change safely.
#
#                   Checks the mechanical half of that standard. What it CANNOT check is
#                   whether the opening paragraph explains anything — a script proves a
#                   paragraph exists, only a reader can tell it says something. That row
#                   is deliberately reviewer judgement.
#
# Scope scanned:  every CONTEXT.md and CLAUDE.md tracked in the repository — bar
#                 .claude/CLAUDE.md, which pairs with nothing and is read by no clause — plus
#                 every directory under code/src for Check 10. --path narrows all three, and
#                 is normalised to the repo-relative form before anything is collected.
#
# THE COUNT LINE IS THE DENOMINATOR, AND IT IS NOT THE COLLECTION SIZE. The collection is the
# whole repository, because --path is applied per file by in_scope at the point of use. Until
# 22/08/2026 the count printed the size of that collection instead of the size of what was
# read, so every run said the same sentence: "checked 216 CONTEXT.md and 207 CLAUDE.md files"
# for --path learning, for --path code/docs, and — the guard below did not exist either — for
# --path does/not/exist. A denominator that does not move with the scope is worse than none.
# It is the one number a reader has for telling "looked, and it was clean" apart from "could
# not look", and this one stated a population no scoped run had ever opened. It now reports
# what the loops actually iterated. Rule: code/docs/GATE-REPORTING.md.
#
# A SCOPE HOLDING NONE OF THE THREE IS CLEAN, AND SAYS SO. That is the absent-surface row of
# GATE-REPORTING.md Section 2, not the absent-tool one: the population is legitimately empty
# rather than unexamined. The note is what makes the zero legible as "nothing of this kind
# here" instead of "nothing wrong here", and without it the two are the same success line.
#
# Usage: docs-pairing.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                        [--path PATH] [--help]
#
# Exit codes:  0 = clean (warnings do not fail), or nothing in scope to check
#              1 = violation(s)   2 = script error, --path among them
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'docs-pairing.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
docs-pairing.sh — Enforce the CONTEXT.md / CLAUDE.md split

Usage:
  docs-pairing.sh                Check every CONTEXT.md and CLAUDE.md
  docs-pairing.sh --output md    Also write a report
  docs-pairing.sh --path DIR     Restrict the check to a directory or file

Fail-tier checks:
  1. Pairing both ways — a CONTEXT.md has a CLAUDE.md beside it, and vice versa
  2. CLAUDE.md opens with @./CONTEXT.md (+ @./REFERENCES.md where one exists)
  3. CLAUDE.md carries a `Read order:` line
  4. CLAUDE.md carries exactly the four H2s, in order:
       Purpose (one line) · How to work here · Guardrails · Output & naming
  5. CLAUDE.md contains no directory tree — it is imported from the file that owns it
  6. CONTEXT.md carries a `## Directory Tree` fence
  7. CONTEXT.md carries no banned rule heading (DOCUMENTATION-PAIRING.md Section 5)
  8. CONTEXT.md carries no `**Claude Model:**` routing metadata
  9. Every top-level tree row is annotated, and no TODO placeholder is left behind
 10. A worked-in directory under code/src carries at least one of the two files

Warn-tier checks (reported, never fail the run):
  A. CONTEXT.md has no prose before its first heading — the "why" is probably missing

Two exceptions are honoured, not flagged (DOCUMENTATION-PAIRING.md Section 7):
  * the repository root — /CLAUDE.md is gitignored and generated
  * generated-output directories — reports/ folders under code/src/scripts/**

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/docs-pairing-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to a file or directory. Normalised to the
                         repo-relative form first, so `.`, a `./` prefix, an absolute path
                         and an interior `..` all name what they look like, and the root
                         itself means the unscoped run. A path that does not exist, or one
                         outside the repository, is a bad argument and exits 2, never a
                         clean run
  --help               Show this help

Every run names what it read — the CONTEXT.md and CLAUDE.md files checked and the
code/src directories walked — so a scope holding none of them is legible as empty.

Rule: code/docs/DOCUMENTATION-PAIRING.md

Exit codes:  0 = clean, or nothing in scope to check
             1 = violation(s) found
             2 = script error
EOF
}

require_arg() { [[ $# -gt 1 ]] || die "$1 requires a value"; }

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

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
if [[ -n "$OUTPUT_FORMAT" ]]; then
  case "$OUTPUT_FORMAT" in
    md|txt|json) ;;
    *) die "Invalid --output value '$OUTPUT_FORMAT'. Choose: md txt json" ;;
  esac
fi
if [[ -n "$OUTPUT_FORMAT" && -z "$OUTPUT_FILE" ]]; then
  mkdir -p "$REPORTS_DIR"
  OUTPUT_FILE="$REPORTS_DIR/docs-pairing-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

# --path is NORMALISED and validated HERE, at top level, before a single file is collected —
# never left to in_scope, which runs per candidate and would simply match nothing. Two argument
# faults share that shape, and neither may reach a success line:
#
#   a scope that does not exist   a typo, or a directory since renamed. Exit 2 — matching
#                                 nothing would be indistinguishable from a scope that
#                                 legitimately holds no pair.
#   a scope git never writes      `.`, a `./` prefix, an absolute path (what tab-completion
#                                 produces) or an interior `..`. All of them EXIST, so an -e
#                                 guard passes them, and all of them then match zero rows of
#                                 `git ls-files` output, which writes none of those forms. Until
#                                 22/08/2026 that printed the surface-absent note below over a
#                                 populated tree: `--path .` reported 0 CONTEXT.md and 0
#                                 CLAUDE.md files across a repository holding 216 and 206. That
#                                 is the scoping fault of GATE-REPORTING.md Section 5 wearing
#                                 the remedy for the reporting one.
#
# So the existence test and the prefix filter now read the SAME normalised, repo-relative
# value, and the repository root itself normalises to the unscoped run rather than to a scope
# matching nothing. Resolution is textual rather than `realpath`: it adds no dependency, needs
# no path to exist, and refuses a path outside the tree by naming what it resolved to. It does
# not follow symlinks, so a symlinked route into the tree is refused rather than accepted.
# Rule: code/docs/GATE-REPORTING.md.
normalise_scope() {   # prints the absolute path with . and .. resolved; empty means /
  local abs seg out=""
  case "$1" in /*) abs="$1" ;; *) abs="$PROJECT_ROOT/$1" ;; esac
  while [[ -n "$abs" ]]; do
    seg="${abs%%/*}"
    if [[ "$abs" == */* ]]; then abs="${abs#*/}"; else abs=""; fi
    case "$seg" in
      ''|.) ;;
      ..)   out="${out%/*}" ;;
      *)    out="$out/$seg" ;;
    esac
  done
  printf '%s' "$out"
}

RAW_PATH=""
if [[ -n "$TARGET_PATH" ]]; then
  RAW_PATH="$TARGET_PATH"
  ABS_PATH="$(normalise_scope "$RAW_PATH")"
  if [[ "$ABS_PATH" == "$PROJECT_ROOT" ]]; then
    TARGET_PATH=""                                   # the root: the whole repository, unscoped
  elif [[ "$ABS_PATH" == "$PROJECT_ROOT"/* ]]; then
    TARGET_PATH="${ABS_PATH#"$PROJECT_ROOT"/}"
  else
    die "--path '$RAW_PATH' resolves to '${ABS_PATH:-/}', outside $PROJECT_ROOT"
  fi
fi
READ_AS=""
[[ "$RAW_PATH" == "$TARGET_PATH" ]] || READ_AS=" (read as '$TARGET_PATH')"
[[ -z "$TARGET_PATH" || -e "$TARGET_PATH" ]] || die "--path '$RAW_PATH' does not exist$READ_AS"

TMP_FAIL=$(mktemp); TMP_WARN=$(mktemp)
trap 'rm -f "$TMP_FAIL" "$TMP_WARN"' EXIT
: > "$TMP_FAIL"; : > "$TMP_WARN"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ docs-pairing.sh — $TIMESTAMP"
if [[ -n "$TARGET_PATH" ]]; then
  log "  scope:  $TARGET_PATH"
fi

fail() { printf '%s\n' "$*" >> "$TMP_FAIL"; }
warn() { printf '%s\n' "$*" >> "$TMP_WARN"; }

# A generated-output directory carries a CONTEXT.md and no CLAUDE.md by design: its only
# operating rule is "generated, never hand-edit", which the CONTEXT.md already states.
is_exempt_dir() {
  case "$1" in
    .) return 0 ;;                                   # the root — /CLAUDE.md is generated
    code/src/scripts/*reports|code/src/scripts/*reports/*) return 0 ;;
    *) return 1 ;;
  esac
}

# Check 10 below enumerates DIRECTORIES rather than files, because a directory carrying neither
# file is invisible to a check driven by the files that exist. Two further classes are exempt
# from that check only — both are already oriented, so neither is a hole:
#
#   synthetic fixtures  the audits run against these trees, so a pair added inside one becomes
#                       live input to the audit reading it
#   single-purpose leaf one tracked file, no tracked sub-directory. The parent's pair annotates
#                       the row and there is no internal organisation left to describe. At two
#                       files there is a relationship between them, and the exemption lapses.
is_exempt_from_enumeration() {
  local dir="$1"
  is_exempt_dir "$dir" && return 0
  case "$dir" in
    code/src/scripts/audits/fixtures|code/src/scripts/audits/fixtures/*) return 0 ;;
  esac
  # Single-purpose leaf: exactly one tracked file at any depth beneath it means no sub-directory
  # holds tracked content either, so the one file is the whole directory.
  [[ "$(git ls-files "$dir" | wc -l)" -eq 1 ]] && return 0
  return 1
}

# TARGET_PATH is repo-relative and slash-free at both ends by the time it gets here, and
# `git ls-files` writes the same form, so the two are compared exactly as they stand. Nothing
# is re-normalised per candidate: one normalisation, above, or the two would drift.
in_scope() {
  [[ -z "$TARGET_PATH" ]] && return 0
  [[ "$1" == "$TARGET_PATH" || "$1" == "$TARGET_PATH"/* ]]
}

# ── Collect the files ─────────────────────────────────────────────────────────
# Tracked plus untracked-but-not-ignored: a pair added in the working tree is in scope
# before it is staged, which is when the author still has it open.
mapfile -t CONTEXTS < <({ git ls-files '*CONTEXT.md'
                          git ls-files --others --exclude-standard '*CONTEXT.md'; } | sort -u)
mapfile -t CLAUDES  < <({ git ls-files '*CLAUDE.md'
                          git ls-files --others --exclude-standard '*CLAUDE.md'; } | sort -u)

# The full collection is this guard's population and nothing else's: run from a directory git
# does not track and it comes back empty, which is a script error rather than a clean repo. A
# missing --path can no longer reach here — it is refused above — so this arm now means the one
# thing it always claimed to.
[[ ${#CONTEXTS[@]} -gt 0 ]] || die "no CONTEXT.md files found — is this the repository root?"

# Filter ONCE, here, and iterate the result everywhere below. The old shape — the full list
# iterated with in_scope skipping inside each loop — left no record of what survived the skip,
# which is how the count line came to report 216 and 207 over a scope holding two files.
#
# `.claude/CLAUDE.md` is dropped HERE rather than skipped inside each loop, because the count
# line below reports the files the clauses read. It is the root's operating-rules counterpart:
# it pairs with no CONTEXT.md and has no folder shape to check, so Check 1's second direction
# and Checks 2–5 all passed over it and always did. Counting it made `--path .claude` report
# four CLAUDE.md files checked where three were. Same policy as DIRS_WALKED below — a
# denominator that counts exclusions overstates the search exactly as the collection size did.
declare -a SCOPED_CONTEXTS=() SCOPED_CLAUDES=()
for f in "${CONTEXTS[@]}"; do
  if in_scope "$f"; then SCOPED_CONTEXTS+=("$f"); fi
done
for f in "${CLAUDES[@]}"; do
  [[ "$f" == ".claude/CLAUDE.md" ]] && continue
  if in_scope "$f"; then SCOPED_CLAUDES+=("$f"); fi
done
DIRS_WALKED=0

# ── Check 1: pairing, both directions ─────────────────────────────────────────
for ctx in "${SCOPED_CONTEXTS[@]}"; do
  d=$(dirname "$ctx")
  is_exempt_dir "$d" && continue
  [[ -f "$d/CLAUDE.md" ]] || fail "$ctx: no CLAUDE.md beside it — every orientation file is paired"
done

for cld in "${SCOPED_CLAUDES[@]}"; do
  d=$(dirname "$cld")
  [[ -f "$d/CONTEXT.md" ]] || fail "$cld: no CONTEXT.md beside it — operating rules with nothing to orient"
done

# ── Checks 2–5: the CLAUDE.md shape ───────────────────────────────────────────
H2_EXPECTED='Purpose (one line)|How to work here|Guardrails|Output & naming'

for cld in "${SCOPED_CLAUDES[@]}"; do
  d=$(dirname "$cld")

  first=$(grep -m1 '[^[:space:]]' "$cld" || true)
  [[ "$first" == "@./CONTEXT.md" ]] || \
    fail "$cld: does not open with \`@./CONTEXT.md\` — the tree must auto-load on navigation"

  if [[ -f "$d/REFERENCES.md" ]] && ! grep -q '^@\./REFERENCES\.md' "$cld"; then
    fail "$cld: a REFERENCES.md sits beside it but is not imported"
  fi

  grep -q '^Read order:' "$cld" || \
    fail "$cld: no \`Read order:\` line"

  actual=$(grep '^## ' "$cld" | sed 's/^## //' | paste -sd'|' -)
  [[ "$actual" == "$H2_EXPECTED" ]] || \
    fail "$cld: H2 sections are \`${actual:-none}\` — expected \`$H2_EXPECTED\`"

  grep -q '^```text' "$cld" && \
    fail "$cld: contains a directory tree — that belongs in CONTEXT.md and is imported from it"
done

# ── Checks 6–9 and the warn tier: the CONTEXT.md shape ────────────────────────
# Headings that are an instruction wearing an orientation heading. Each one moves to a
# named section of the paired CLAUDE.md, or to the guide that owns the rule.
BANNED='^#{2,3} +(Rules|Guardrails|Constraints|Global constraints|Requirements|Prerequisites|Quality gates|Hard gates|Standards|Conventions|Naming|Naming convention|Naming conventions|File naming|How to work here|Definition of done)\b'

for ctx in "${SCOPED_CONTEXTS[@]}"; do
  grep -q '^```text' "$ctx" || \
    fail "$ctx: no \`## Directory Tree\` fence — orientation without a tree"

  while IFS= read -r h; do
    fail "$ctx: banned heading \`${h#\#\# }\` — an operating rule (DOCUMENTATION-PAIRING.md Section 5)"
  done < <(grep -iE "$BANNED" "$ctx" || true)

  grep -q '^\*\*Claude Model:\*\*' "$ctx" && \
    fail "$ctx: carries \`**Claude Model:**\` routing metadata — model tier is an operating rule"

  # Every top-level row says what it is. A row with a bare name is accurate and is
  # still not orientation — it is what the tree generator inserts for a human to describe.
  while IFS= read -r r; do
    fail "$ctx: tree row \`$r\` has no description"
  done < <(awk '
    /^```text/ { inb = 1; next }
    inb && /^```/ { inb = 0 }
    inb && /^[├└]── / {
      row = $0
      sub(/^[├└]── /, "", row)
      name = row
      sub(/[[:space:]].*$/, "", name)
      rest = substr(row, length(name) + 1)
      gsub(/[[:space:]]/, "", rest)
      if (rest == "") print name
    }' "$ctx" || true)

  if grep -qE '[←→][[:space:]]*TODO' "$ctx"; then
    fail "$ctx: a tree row still carries a TODO annotation — describe it before committing"
  fi

  # Warn tier: prose before the first heading is where the "why" normally lives.
  # Between the H1 title and the first H2. The metadata header lines are not prose.
  awk '
    /^# /  { seen_h1 = 1; next }
    !seen_h1 { next }
    /^## / { exit }
    /^\*\*(Last Updated|Claude Model|MCP Servers|Version|Maintained By)/ { next }
    /[^[:space:]]/ { found = 1; exit }
    END { exit (found ? 0 : 1) }
  ' "$ctx" || warn "$ctx: no prose between the title and the first section — is the \"why\" recorded?"
done

# ── Check 10: a bound directory carrying NEITHER file ─────────────────────────
# The two loops above are driven by the CONTEXT.md and CLAUDE.md files that exist, so a
# directory holding neither is invisible to them — not overlooked, unreachable. This walks
# directories instead. Scoped to code/src, where "a directory someone works in" is decidable;
# outside it the exempt classes outnumber the bound ones and the check would be noise.
while read -r d; do
  [[ -z "$d" ]] && continue
  in_scope "$d" || continue
  is_exempt_from_enumeration "$d" && continue
  # Counted here rather than at the top of the loop: an exempt directory was excluded by rule,
  # not examined, and a denominator that counts exclusions overstates the search exactly as the
  # collection size did.
  DIRS_WALKED=$((DIRS_WALKED + 1))
  [[ -f "$d/CONTEXT.md" || -f "$d/CLAUDE.md" ]] && continue
  fail "$d: carries neither CONTEXT.md nor CLAUDE.md — a worked-in directory is oriented"
done < <(git ls-files 'code/src' | xargs -r -n1 dirname | sort -u)

# ── Report ────────────────────────────────────────────────────────────────────
FAIL_COUNT=$(grep -c . "$TMP_FAIL" || true); FAIL_COUNT=${FAIL_COUNT:-0}
WARN_COUNT=$(grep -c . "$TMP_WARN" || true); WARN_COUNT=${WARN_COUNT:-0}
FAIL_BODY="$(cat "$TMP_FAIL")"
WARN_BODY="$(cat "$TMP_WARN")"

CTX_CHECKED=${#SCOPED_CONTEXTS[@]}
CLD_CHECKED=${#SCOPED_CLAUDES[@]}
EXAMINED=$((CTX_CHECKED + CLD_CHECKED + DIRS_WALKED))

SURFACE_NOTE=""
if [[ "$EXAMINED" -eq 0 ]]; then
  SURFACE_NOTE="Surface absent: this audit's population is empty under ${TARGET_PATH:-the repository} — no CONTEXT.md and no CLAUDE.md it reads, and no bound code/src directory — so no clause could fire and this run is clean by definition rather than by inspection."
fi

log "  checked $CTX_CHECKED CONTEXT.md and $CLD_CHECKED CLAUDE.md files"
log "  walked  $DIRS_WALKED code/src director(ies) for Check 10"
[[ -n "$SURFACE_NOTE" ]] && log "  $SURFACE_NOTE"
log ""

if [[ "$FAIL_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[31m  ✗ %d violation(s)\033[0m\n' "$FAIL_COUNT"
  printf '%s\n\n' "$FAIL_BODY" | sed 's/^/    /'
fi
if [[ "$WARN_COUNT" -gt 0 ]] && ! $QUIET; then
  printf '\033[33m  ! %d warning(s)\033[0m\n' "$WARN_COUNT"
  printf '%s\n\n' "$WARN_BODY" | sed 's/^/    /'
fi

# The report carries the same denominator as the terminal line, and for the same reason: a
# consumer reading only the artefact has nothing else to tell a scoped run from a whole-repo one.
# Both new JSON fields carry caller-supplied text, so both go through the escaper.
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

if [[ -n "$OUTPUT_FORMAT" ]]; then
  if [[ "$FAIL_COUNT" -gt 0 ]]; then
    STATUS="✗ $FAIL_COUNT violation(s)"
  elif [[ "$EXAMINED" -eq 0 ]]; then
    STATUS='✓ nothing in scope to check'
  else
    STATUS='✓ split intact'
  fi
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'docs-pairing audit — %s\n' "$TIMESTAMP"
        printf 'scope=%s\n' "${TARGET_PATH:-(whole repository)}"
        printf 'context_files=%s claude_files=%s directories=%s\n' "$CTX_CHECKED" "$CLD_CHECKED" "$DIRS_WALKED"
        printf 'violations=%s warnings=%s\n' "$FAIL_COUNT" "$WARN_COUNT"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n' "$SURFACE_NOTE"
        printf '\n%s\n' "${FAIL_BODY:-No violations.}"
        printf '\n%s\n' "${WARN_BODY:-No warnings.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# CONTEXT.md / CLAUDE.md Pairing Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Scope** | %s |\n' "${TARGET_PATH:-the whole repository}"
        printf '| **Checked** | %s CONTEXT.md · %s CLAUDE.md · %s code/src director(ies) |\n' \
          "$CTX_CHECKED" "$CLD_CHECKED" "$DIRS_WALKED"
        printf '| **Violations** | %s |\n' "$FAIL_COUNT"
        printf '| **Warnings** | %s |\n' "$WARN_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        [[ -n "$SURFACE_NOTE" ]] && printf '%s\n\n' "$SURFACE_NOTE"
        if [[ "$FAIL_COUNT" -gt 0 ]]; then printf '## Violations\n\n```text\n%s\n```\n\n' "$FAIL_BODY"
        elif [[ "$EXAMINED" -gt 0 ]]; then printf '_Every pair is complete and correctly shaped._\n\n'; fi
        if [[ "$WARN_COUNT" -gt 0 ]]; then printf '## Warnings\n\n```text\n%s\n```\n' "$WARN_BODY"; fi
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "docs-pairing",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "scope": "%s",\n' "$(json_escape "${TARGET_PATH:-}")"
        printf '  "context_files": %s,\n  "claude_files": %s,\n' "$CTX_CHECKED" "$CLD_CHECKED"
        printf '  "directories": %s,\n' "$DIRS_WALKED"
        printf '  "surface_note": "%s",\n' "$(json_escape "$SURFACE_NOTE")"
        printf '  "violations": %s,\n  "warnings": %s,\n' "$FAIL_COUNT" "$WARN_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$FAIL_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$FAIL_COUNT" -eq 0 ]]; then
  # A run that read nothing gets its own verdict. "Split intact" over an empty scope asserts a
  # result about pairs this run never opened, which is the whole of GATE-REPORTING.md Section 1.
  if [[ "$EXAMINED" -eq 0 ]]; then
    bold "✓ Nothing to check."
    log ""
    exit 0
  fi
  SUFFIX=""
  [[ "$WARN_COUNT" -gt 0 ]] && SUFFIX=" — $WARN_COUNT warning(s) to answer"
  bold "✓ CONTEXT.md / CLAUDE.md split intact${SUFFIX}."
  log ""
  exit 0
else
  bold "✗ $FAIL_COUNT violation(s) — see code/docs/DOCUMENTATION-PAIRING.md."
  log ""
  exit 1
fi
