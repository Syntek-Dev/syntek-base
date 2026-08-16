#!/usr/bin/env bash
#
# doc-references.sh — Every citation in a shipped file must resolve in every project.
#
#                     Two checks, one rule. A file that ships is read in a project that is
#                     not this one, so it may cite only what that project is guaranteed to
#                     have: the LAYERING SYSTEM — CONTEXT.md, CLAUDE.md, docs/, workflows/,
#                     scripts, guides. It may never cite a PER-PROJECT INSTANCE — ADR-###,
#                     US###, SPRINT-##, MAP-*, PLAN-*, BUG-*, QA-* — because a generated
#                     project has different ones at those numbers, or none at all.
#
#                     Check 1 — dangling path.     A backticked repo path that does not exist.
#                     Check 2 — instance citation. A named instance artefact, cited as real.
#
#                     Naming PATTERNS are not citations and are not flagged: "take the next
#                     free `ADR-###` in `14-DECISIONS/`" names a format, not a document. The
#                     `*-TEMPLATE.md` files are real and citable for the same reason.
#
#                     What it CANNOT check is whether a resolving path is the RIGHT one, or
#                     whether a count stated in words is true. Both stay reviewer judgement.
#
# Scope scanned:  tracked AND untracked-but-not-ignored files — the file you just wrote is
#                 the one most needing the check, and it is not tracked yet.
#
# Exempt:         history (CHANGELOG/RELEASES/VERSION-HISTORY) records what was true then;
#                 how-to/src/TEMPLATE-GUIDE/ is copier-excluded AND must be able to name a
#                 broken citation in order to log it; handoffs/ and .copier/ are staging.
#
# Usage: doc-references.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                          [--path PATH] [--help]
#
# Exit codes:  0 = clean   1 = violation(s)   2 = script error
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
die()  { printf 'doc-references.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
doc-references.sh — Every citation in a shipped file must resolve in every project

Usage:
  doc-references.sh                 Check every eligible file
  doc-references.sh --output md     Also write a report to audits/reports/
  doc-references.sh --path DIR      Restrict the check to a directory or file
  doc-references.sh --quiet         Suppress progress output

Exit codes: 0 clean · 1 violations found · 2 script error
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --output)      OUTPUT_FORMAT="${2:-}"; shift 2 ;;
    --output-file) OUTPUT_FILE="${2:-}";   shift 2 ;;
    --path)        TARGET_PATH="${2:-}";   shift 2 ;;
    --quiet)       QUIET=true;             shift   ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "unknown argument: $1" ;;
  esac
done

cd "$PROJECT_ROOT" || die "cannot enter $PROJECT_ROOT"

# ── What we scan ─────────────────────────────────────────────────────────────
# Tracked plus untracked-but-not-ignored, deduplicated. Ignored files are absent
# by construction, which is how this repo's own throwaway handoffs and feature
# maps stay invisible to the check.
candidates() {
  { git ls-files -z; git ls-files -z --others --exclude-standard; } \
    | tr '\0' '\n' | sort -u | grep -E '\.(md|sh)$' || true
}

is_exempt() {
  case "$1" in
    CHANGELOG.md|RELEASES.md|VERSION-HISTORY.md)  return 0 ;;
    how-to/src/TEMPLATE-GUIDE/*)                  return 0 ;;
    handoffs/*|.copier/*)                         return 0 ;;
    code/docs/cloudinary/*)                       return 0 ;;  # vendored SDK docs
    .agents/*)                                    return 0 ;;  # vendored third-party skills
  esac
  return 1
}

# Paths copier seeds into place at generation exist in a generated project even
# though they are absent here. Parsed from copier.yml so a new seed needs no edit.
SEEDED="$(grep -oE 'mv \.copier/[^ ]+ ([^ ]+)' copier.yml 2>/dev/null | awk '{print $3}' || true)"

is_seeded() {
  [ -n "$SEEDED" ] && printf '%s\n' "$SEEDED" | grep -qxF "$1"
}

# Copier renders this file into every generated project, so the two delimiter pairs must
# never appear literally in it — Jinja would try to parse them and generation would die with
# TemplateSyntaxError. They are assembled here instead, which is also why the patterns below
# are variables rather than inline globs.
LT='<'
TOK_OPEN="${LT}%"
BLK_OPEN="${LT}:"

# A token with a template placeholder, a numeric pattern, or a glob is not a citation.
is_pattern() {
  case "$1" in
    *"$TOK_OPEN"*|*"$BLK_OPEN"*)                                     return 0 ;;
    *'{'*|*'###'*|*'##'*|*'<'*'>'*|*'*'*|*'…'*|*'NN'*)               return 0 ;;
    *'–'*|*'—'*)                                                     return 0 ;;  # en/em-dash range
    *-TEMPLATE.md|*-TEMPLATE)                                        return 0 ;;
    # The zero-index artefacts ARE the naming convention, not an instance of it.
    US000*|ADR-000*|MAP-000*|SPRINT-00*|SPRINT-PLAN-00*|*US000*)     return 0 ;;
  esac
  return 1
}

# ── Collect ──────────────────────────────────────────────────────────────────
violations=0
report=""

record() { # file line kind detail
  violations=$((violations + 1))
  report+="| \`$1\` | $2 | $3 | \`$4\` |"$'\n'
  log "  $1:$2  [$3]  $4"
}

FILES="$(candidates)"
[ -n "$TARGET_PATH" ] && FILES="$(printf '%s\n' "$FILES" | grep -E "^${TARGET_PATH%/}(/|$)" || true)"

bold "doc-references.sh — checking citations resolve"

while IFS= read -r file; do
  [ -n "$file" ] || continue
  [ -f "$file" ] || continue
  is_exempt "$file" && continue

  # Every backticked token in the file, with its line number.
  while IFS=: read -r lineno token; do
    [ -n "$token" ] || continue
    is_pattern "$token" && continue

    # An example marked as an example is not a citation. A naming table shows the pattern
    # in one column and a worked example in the next; prose writes "e.g." or "[EXAMPLE]".
    # In both, the token demonstrates a convention rather than pointing at a document, and
    # the marker is on the same line. Unmarked prose naming a specific story number is NOT
    # covered — that reads as a real story, and in a template that ships none it is exactly
    # the origin-project leakage this audit exists to catch.
    #
    # `doc-references: ignore` suppresses a line outright. It is for the one case neither
    # rule reaches: a document QUOTING a path in order to ban it, or naming a path that
    # belongs to another repository. Accepted on the line OR the line directly above it,
    # the same annotation convention the sibling audits already use.
    line="$(sed -n "${lineno}p" "$file" 2>/dev/null || true)"
    prev="$(sed -n "$((lineno > 1 ? lineno - 1 : 1))p" "$file" 2>/dev/null || true)"
    case "$prev" in *'doc-references: ignore'*) line="$line doc-references: ignore" ;; esac
    case "$line" in
      *'doc-references: ignore'*)              is_naming_row=true ;;
      *'###'*|*'-##'*|*'{###}'*)               is_naming_row=true ;;
      *'<DESCRIPTOR>'*|*'<TITLE>'*|*'<NNN>'*)  is_naming_row=true ;;
      *'e.g.'*|*'E.g.'*|*'for example'*)       is_naming_row=true ;;
      *'[EXAMPLE]'*|*'house style'*)           is_naming_row=true ;;
      *)                                       is_naming_row=false ;;
    esac

    # ── Check 2 — instance citation ─────────────────────────────────────────
    if [ "$is_naming_row" = false ] && printf '%s' "$token" \
       | grep -qE '^(ADR-[0-9]{3}|US[0-9]{3}|SPRINT-[0-9]{2}|SPRINT-PLAN-[0-9]{2}|MAP-[A-Z][A-Z0-9-]+|PLAN-US[0-9]{3}|STORY-PLAN-US[0-9]{3}|BUG-[A-Z]|QA-US[0-9]{3}|API-US[0-9]{3})'; then
      base="${token##*/}"
      if ! is_seeded "$token" && [ ! -e "$token" ] && [ ! -e "project-management/src/01-FEATURE/$base" ]; then
        record "$file" "$lineno" "instance citation" "$token"
        continue
      fi
    fi

    # ── Check 1 — dangling repo path ────────────────────────────────────────
    case "$token" in
      */*) ;;   # only tokens that look like a path
      *)   continue ;;
    esac
    case "$token" in
      http*|*@*|*' '*) continue ;;
    esac

    # Trailing backslashes survive from shell heredocs in the *.sh files.
    stripped="${token%\\}"
    stripped="${stripped%/}"

    # Resolve relatives against the CITING file's directory, not the repo root —
    # a ../SIBLING-FOLDER/ reference means something different in each file that
    # writes it, and resolving them all from the root invents failures.
    # A `./` prefix is written for the repo root in practice, so accept either
    # reading rather than pick one and generate a false positive from the other.
    case "$stripped" in
      ../*|./*) resolved="$(cd "$(dirname "$file")" 2>/dev/null && printf '%s' "$PWD")/$stripped"
                resolved="${resolved#"$PROJECT_ROOT"/}"
                [ -e "${stripped#./}" ] && continue ;;
      *)        resolved="$stripped" ;;
    esac

    # The house shorthand drops the leading directories, naming a script or a guide by
    # its group alone. It is CONTEXT-DEPENDENT: the same rust/ prefix means a sibling
    # folder in code/docs/ and a script group under code/src/scripts/. Try sibling first,
    # then the script root; only then treat it as unresolved. Without this, every
    # shorthand reference is invisible to the anchor below and the check silently passes.
    case "$resolved" in
      */*)
        case "$resolved" in
          # A bare name with no extension is prose (`database/postgres` is a service).
          *.sh|*.md|*.py|*.yml|*/) ;;
          *) resolved_skip=true ;;
        esac
        if [ "${resolved_skip:-false}" = false ] && [ ! -e "$resolved" ]; then
          sibling="$(dirname "$file")/$resolved"
          sibling="${sibling#./}"
          if [ -e "$sibling" ]; then
            resolved="$sibling"
          elif [ -e "code/src/scripts/$resolved" ]; then
            resolved="code/src/scripts/$resolved"
          else
            case "$resolved" in
              audits/*|tests/*|syntax/*|database/*|development/*|deployment/*|desktop/*|mobile/*|rust/*)
                resolved="code/src/scripts/$resolved" ;;
            esac
          fi
        fi
        resolved_skip=false ;;
    esac

    # Only paths the TEMPLATE owns are checkable. `code/src/django/components/` and
    # `project-management/src/02-STORIES/US001.md` are where a project's own work will
    # land — absent here by design, present once it is built. Flagging those would make
    # the gate permanently red, which is the same as having no gate.
    case "$resolved" in
      # Generated output. The folder appears when the script that fills it is run,
      # so its absence is the normal state, not a broken citation.
      */reports/*|*/coverage/*|*/staticfiles/*|.claude/worktrees/*|.claude/worktrees) continue ;;
      code/docs/*|code/workflows/*|code/src/scripts/*|code/CONTEXT.md|code/CLAUDE.md|code/REFERENCES.md) ;;
      how-to/docs/*|how-to/workflows/*|how-to/src/*) ;;
      project-management/docs/*|project-management/workflows/*) ;;
      .claude/*|.github/*) ;;
      *) continue ;;
    esac

    [ -e "$resolved" ] && continue
    is_seeded "$resolved" && continue
    [ "$is_naming_row" = true ] && continue
    record "$file" "$lineno" "dangling path" "$token"
  done < <(grep -noE '`[^`]+`' "$file" 2>/dev/null | sed 's/`//g' || true)
done <<< "$FILES"

# ── Report ───────────────────────────────────────────────────────────────────
if [ "$violations" -eq 0 ]; then
  bold "Clean — every citation resolves."
else
  bold "$violations citation(s) do not resolve."
  log ""
  log "Rule: a shipped file may cite layering-system artefacts only (CONTEXT.md,"
  log "CLAUDE.md, docs/, workflows/, scripts, guides) and never a per-project"
  log "instance (ADR-###, US###, SPRINT-##, MAP-*, PLAN-*). Drop the citation, or"
  log "point at the guide that carries the rule."
fi

if [ -n "$OUTPUT_FORMAT" ]; then
  mkdir -p "$REPORTS_DIR"
  out="${OUTPUT_FILE:-$REPORTS_DIR/doc-references.md}"
  {
    printf '# doc-references\n\n'
    printf 'Violations: %s\n\n' "$violations"
    if [ "$violations" -gt 0 ]; then
      printf '| File | Line | Kind | Citation |\n| --- | --- | --- | --- |\n%s' "$report"
    fi
  } > "$out"
  log "Report: $out"
fi

[ "$violations" -eq 0 ] || exit 1
