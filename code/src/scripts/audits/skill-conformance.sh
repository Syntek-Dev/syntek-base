#!/usr/bin/env bash
#
# skill-conformance.sh — Verify every skill against the Agent Skills specification
#                        and this project's narrowing of it.
#
#                        Three separate facts, conflated once and kept apart here:
#                          - the published Agent Skills spec defines SIX fields;
#                          - Claude Code accepts its own documented extensions beyond them,
#                            so a key outside the six is not a validation error;
#                          - this project admits exactly FOUR of those extensions —
#                            `context`, `agent`, `background`, `model` — and declines every
#                            remaining extra BY CHOICE, not because it would be rejected.
#                        Both halves are checked, and reported apart — a spec breach and a
#                        house-rule breach are different problems.
#
#                        Eleven [gate: fail] clauses, no warn tier. Clause numbers are
#                        appended, never renumbered — they appear in reports:
#                          spec   1. frontmatter opens at byte 0 and is terminated
#                          spec   2. `name` and `description` are both present
#                          spec   3. `name` matches the parent directory
#                          spec   4. `name` is 1-64 chars, a-z0-9-, no edge or doubled hyphen
#                          spec   5. `description` is non-empty and <= 1024 characters
#                          spec   6. no key that neither the spec nor Claude Code defines
#                          house  7. no key this project declines on a first-party skill —
#                                    the four spec-optional fields, and any documented
#                                    Claude Code key outside the admitted four
#                          house  8. `context: fork` carries an explicit `agent:`
#                          house  9. `agent:` names a built-in fork target only
#                          house 10. `## Governing procedures` section present
#                          house 11. `context: fork` carries an explicit `background:`
#
#                        The tier is the point, not a label. A key nothing defines is a
#                        format problem; declining a key the runtime does document is a
#                        CHOICE, and the reader has to be able to tell which they may argue
#                        with (how-to/docs/skill-authoring/FRONTMATTER.md § Three claims).
#
#                        Clauses 8, 9 and 11 are what hold the fork policy in CODE: a forked
#                        skill states its target and its detachment rather than inheriting a
#                        version-dependent default, and that target is one of the three
#                        built-ins this project admits. The runtime also accepts a custom
#                        subagent there; it may return only on evidence that a named skill
#                        needs a durable capability no built-in provides — which is a
#                        decision, made in the doctrine, not something a convenient new file
#                        may assume.
#
#                        Vendored skills (a symlinked folder — the cloudinary set, refreshed
#                        from upstream via skills-lock.json) are held to the SPEC half only:
#                        the published six, with no extension admitted. Hand-editing one to
#                        satisfy a house rule is undone by the next refresh, so clauses 7-11
#                        do not apply to them.
#
#                        Length is NOT checked here — docs-length.sh owns the 300-line cap
#                        across all of .claude/**, and one rule with two enforcers drifts.
#
#                        Rule: how-to/docs/SKILL-AUTHORING.md
#                        Spec: https://agentskills.io/specification
#
# Scope scanned:  .claude/skills/*/SKILL.md
#                 The four code-review-graph cards (.claude/skills/*.md) are flat files, not
#                 folder-skills, and are auto-generated — they are not skills under the spec.
#
# Usage: skill-conformance.sh [--output FORMAT] [--output-file PATH] [--quiet]
#                             [--path PATH] [--help]
#
# Exit codes:  0 = every skill conforms   1 = violation(s) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

SCOPE_DIR=".claude/skills"
DESC_MAX=1024
NAME_MAX=64

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
TARGET_PATH=""

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'skill-conformance.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'EOF'
skill-conformance.sh — Verify skills against the Agent Skills specification

Usage:
  skill-conformance.sh               Check .claude/skills/*/SKILL.md
  skill-conformance.sh --output md   Also write a report
  skill-conformance.sh --path DIR    Restrict the check to one skill folder

Spec clauses (https://agentskills.io/specification):
  1. Frontmatter opens at byte 0 with --- and is terminated
  2. `name` and `description` are both present
  3. `name` matches the parent directory name
  4. `name` is 1-64 chars, a-z0-9-, no leading/trailing or doubled hyphen
  5. `description` is non-empty and at most 1024 characters
  6. No key that neither the spec nor Claude Code defines. The spec's six are
     name description license metadata compatibility allowed-tools; on a vendored
     skill those six are the whole admitted set

House clauses (how-to/docs/skill-authoring/FRONTMATTER.md):
  7. A first-party skill carries name + description + the four admitted runtime keys
     (context agent background model), and no key declined here — the four
     spec-optional fields, or a documented Claude Code key such as
     disable-model-invocation
  8. A skill with `context: fork` also carries an explicit `agent:`
  9. `agent:` names one of the three built-in fork targets this project admits:
     Explore | Plan | general-purpose
 10. A first-party skill carries a `## Governing procedures` section
 11. A skill with `context: fork` also carries an explicit `background:`

Vendored skills (symlinked folders, refreshed from upstream) are held to clauses 1-6 only,
and to the published six alone — no extension is admitted on one.
File length is docs-length.sh's, not this script's.

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
                         (default: code/src/scripts/audits/reports/skill-conformance-report.<FORMAT>)
  --quiet              Suppress terminal output — requires --output
  --path PATH          Restrict the check to one skill folder or SKILL.md
  --help               Show this help

Exit codes:  0 = clean   1 = violation(s) found   2 = script error
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
  OUTPUT_FILE="$REPORTS_DIR/skill-conformance-report.$OUTPUT_FORMAT"
fi

cd "$PROJECT_ROOT"

TMP_HITS=$(mktemp)
trap 'rm -f "$TMP_HITS"' EXIT
: > "$TMP_HITS"

TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')

log ""
bold "▸ skill-conformance.sh — $TIMESTAMP"

# Self-guarding: a project may legitimately carry no skills of its own. An absent surface
# reports success with a note, so this runs unconditionally in CI with no step-level guard.
if [[ -z "$TARGET_PATH" && ! -d "$SCOPE_DIR" ]]; then
  bold "✓ No $SCOPE_DIR/ — nothing to check."
  log ""
  exit 0
fi

# Enumerate skill folders. A skill is a DIRECTORY holding SKILL.md; the flat *.md cards
# beside them are code-review-graph output and are not skills under the spec.
collect_skills() {
  if [[ -n "$TARGET_PATH" ]]; then
    local t="${TARGET_PATH%/}"
    [[ -e "$t" ]] || die "--path '$t' does not exist"
    if [[ -f "$t" ]]; then printf '%s\0' "$(dirname "$t")"
    elif [[ -f "$t/SKILL.md" ]]; then printf '%s\0' "$t"
    else find "$t" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -print0 2>/dev/null | sort -z; fi
  else
    find "$SCOPE_DIR" -mindepth 1 -maxdepth 1 \( -type d -o -type l \) -print0 | sort -z
  fi
}

# Vendored = the skill folder is a SYMLINK. Detected by shape rather than by name, so a
# second vendored set needs no edit here.
#
# Symlink is the whole test, deliberately. A vendored skill is exempt from the house rules
# because editing it is futile — the next `skills-lock.json` refresh overwrites the file.
# That is true of a symlink into `.agents/` and false of a copy, which is authored content
# living here under someone else's name and is held to every clause.
is_vendored() { [[ -L "${1%/}" ]]; }

# Emit `key<TAB>value` for every TOP-LEVEL frontmatter key, with block scalars (>- | etc.)
# and continuation lines folded into one value. Indented lines are nested data, not keys.
#
# The key may be quoted, and the quotes are stripped before it is emitted: YAML reads
# `"allowed-tools": Read` and `allowed-tools: Read` as the same key, so a key check that
# matched only the bare form would be evadable with two characters — the runtime would act
# on the key and the gate would report the file clean.
parse_frontmatter() {
  awk -v Q="\"'" '
    NR == 1 && $0 != "---" { print "!!NOFM"; exit }
    NR == 1 { infm = 1; next }
    infm && $0 == "---" { flush(); infm = 0; exit }
    infm {
      if ($0 ~ "^[" Q "]?[A-Za-z_][A-Za-z0-9_-]*[" Q "]?[[:space:]]*:") {
        flush()
        key = $0; sub(/:.*/, "", key)
        sub("^[" Q "]", "", key); sub("[" Q "]$", "", key); sub(/[[:space:]]+$/, "", key)
        val = $0; sub(/^[^:]*:[[:space:]]*/, "", val)
        if (val == ">" || val == ">-" || val == "|" || val == "|-" || val == "") val = ""
        next
      }
      if (key != "") {
        line = $0; sub(/^[[:space:]]+/, "", line); sub(/[[:space:]]+$/, "", line)
        if (line != "") val = (val == "" ? line : val " " line)
      }
    }
    END { if (infm) print "!!UNTERMINATED"; else flush() }
    function flush() { if (key != "") { printf "%s\t%s\n", key, val; key = ""; val = "" } }
  ' "$1"
}

# Three lists, deliberately not merged. SPEC_KEYS stays a faithful copy of the PUBLISHED six,
# so the script never asserts something false about the spec and a vendored drop cannot smuggle
# a routing key past the only key check that applies to it. The admitted set is therefore
# tier-dependent: SPEC_KEYS on a vendored skill, SPEC_KEYS + EXT_KEYS on a first-party one.
#
# EXT_KEYS is Claude Code's own frontmatter, outside the spec and accepted by the runtime.
# Exactly four are admitted.
SPEC_KEYS=" name description license metadata compatibility allowed-tools "
EXT_KEYS=" context agent background model "

# Documented by Claude Code and declined here. Kept apart from the unknown-key case because
# the tiers differ: this is a house choice and negotiable, an undocumented key is not. A
# runtime key that appears later and is not listed here reports under clause 6 until it is.
DECLINED_EXT_KEYS=" disable-model-invocation "

# What a first-party skill may actually author: the two required spec fields plus the four
# admitted runtime keys. Everything else is declined by choice — the reasons are in
# how-to/docs/skill-authoring/FRONTMATTER.md § What is declined, and why.
HOUSE_KEYS=" name description context agent background model "

# The only fork targets this project admits. The runtime also accepts a custom subagent from
# .claude/agents/; that door is closed here by choice, with a reopening test recorded in
# how-to/docs/skill-authoring/FORK-DECISION.md § The custom-agent door.
FORK_AGENTS=" Explore Plan general-purpose "

# YAML permits a quoted scalar; compare the value, not its quoting.
unquote() {
  local v="$1"
  v="${v#\"}"; v="${v%\"}"
  v="${v#\'}"; v="${v%\'}"
  printf '%s' "$v"
}

SKILL_COUNT=0
VENDORED_COUNT=0

while IFS= read -r -d '' dir; do
  dir="${dir%/}"
  file="$dir/SKILL.md"
  [[ -f "$file" ]] || continue
  SKILL_COUNT=$((SKILL_COUNT + 1))

  folder="$(basename "$dir")"
  vendored=false
  if is_vendored "$dir"; then vendored=true; VENDORED_COUNT=$((VENDORED_COUNT + 1)); fi

  fm="$(parse_frontmatter "$file")"

  # --- Clause 1: frontmatter opens at byte 0 and is terminated -------------------
  if [[ "$fm" == "!!NOFM" ]]; then
    printf '%s: [spec 1] no YAML frontmatter — the file must open at byte 0 with `---`\n' \
      "$file" >> "$TMP_HITS"
    continue
  fi
  if [[ "$fm" == *"!!UNTERMINATED"* ]]; then
    printf '%s: [spec 1] frontmatter is never closed by a second `---`\n' "$file" >> "$TMP_HITS"
    continue
  fi

  name="$(printf '%s\n' "$fm" | awk -F'\t' '$1=="name"{print $2; exit}')"
  desc="$(printf '%s\n' "$fm" | awk -F'\t' '$1=="description"{print $2; exit}')"

  # --- Clause 2: both required fields present ------------------------------------
  [[ -n "$name" ]] || printf '%s: [spec 2] required field `name` is missing or empty\n' \
    "$file" >> "$TMP_HITS"
  [[ -n "$desc" ]] || printf '%s: [spec 2] required field `description` is missing or empty\n' \
    "$file" >> "$TMP_HITS"

  # --- Clause 3: name matches the parent directory -------------------------------
  if [[ -n "$name" && "$name" != "$folder" ]]; then
    printf '%s: [spec 3] `name: %s` does not match its folder `%s`\n' \
      "$file" "$name" "$folder" >> "$TMP_HITS"
  fi

  # --- Clause 4: name charset and length -----------------------------------------
  if [[ -n "$name" ]]; then
    if (( ${#name} > NAME_MAX )); then
      printf '%s: [spec 4] `name` is %d characters — the ceiling is %d\n' \
        "$file" "${#name}" "$NAME_MAX" >> "$TMP_HITS"
    fi
    [[ "$name" =~ ^[a-z0-9-]+$ ]] || printf '%s: [spec 4] `name: %s` — lowercase letters, digits and hyphens only\n' \
      "$file" "$name" >> "$TMP_HITS"
    case "$name" in
      -*|*-) printf '%s: [spec 4] `name: %s` must not start or end with a hyphen\n' \
               "$file" "$name" >> "$TMP_HITS" ;;
    esac
    case "$name" in
      *--*) printf '%s: [spec 4] `name: %s` must not contain consecutive hyphens\n' \
              "$file" "$name" >> "$TMP_HITS" ;;
    esac
  fi

  # --- Clause 5: description length ----------------------------------------------
  if [[ -n "$desc" ]] && (( ${#desc} > DESC_MAX )); then
    printf '%s: [spec 5] `description` is %d characters — the ceiling is %d\n' \
      "$file" "${#desc}" "$DESC_MAX" >> "$TMP_HITS"
  fi

  # --- Clauses 6 and 7: the key set ----------------------------------------------
  while IFS=$'\t' read -r key _; do
    [[ -n "$key" ]] || continue
    if [[ "$SPEC_KEYS" == *" $key "* ]]; then
      # A published spec field. Four of the six are declined here, on a first-party skill.
      if [[ $vendored == false && "$HOUSE_KEYS" != *" $key "* ]]; then
        printf '%s: [house 7] `%s:` is spec-valid but declined here — a first-party skill authors `name`, `description` and the four admitted runtime keys, nothing else\n' \
          "$file" "$key" >> "$TMP_HITS"
      fi
    elif [[ "$EXT_KEYS" == *" $key "* || "$DECLINED_EXT_KEYS" == *" $key "* ]]; then
      # A Claude Code key: authored here where admitted, never hand-added to someone else's
      # skill. Declining one of them is this project's call, so it reports as house, not spec.
      if [[ $vendored == true ]]; then
        printf '%s: [spec 6] `%s:` is a Claude Code extension, not an Agent Skills field — a vendored skill is held to the published six\n' \
          "$file" "$key" >> "$TMP_HITS"
      elif [[ "$EXT_KEYS" != *" $key "* ]]; then
        printf '%s: [house 7] `%s:` is documented by Claude Code and declined here — see how-to/docs/skill-authoring/FRONTMATTER.md § What is declined, and why\n' \
          "$file" "$key" >> "$TMP_HITS"
      fi
    else
      printf '%s: [spec 6] `%s:` is not one of the six fields the Agent Skills specification defines, and Claude Code documents no such key\n' \
        "$file" "$key" >> "$TMP_HITS"
    fi
  done <<< "$fm"

  context_val="$(unquote "$(printf '%s\n' "$fm" | awk -F'\t' '$1=="context"{print $2; exit}')")"
  agent_val="$(unquote "$(printf '%s\n' "$fm" | awk -F'\t' '$1=="agent"{print $2; exit}')")"
  background_val="$(unquote "$(printf '%s\n' "$fm" | awk -F'\t' '$1=="background"{print $2; exit}')")"

  # --- Clauses 8, 9 and 11: the fork call -----------------------------------------
  # `agent:` defaults to general-purpose when omitted, but that is version-dependent
  # behaviour on a young field — so a fork states both keys of the write test explicitly.
  # Clause 9 is unconditional on `context:`: an `agent:` value on an inline skill is either
  # a stray key or a fork that forgot to say so, and both are worth the finding.
  if [[ $vendored == false ]]; then
    if [[ "$context_val" == "fork" && -z "$agent_val" ]]; then
      printf '%s: [house 8] `context: fork` with no `agent:` — state the target explicitly rather than inheriting the default\n' \
        "$file" >> "$TMP_HITS"
    fi
    if [[ -n "$agent_val" && "$FORK_AGENTS" != *" $agent_val "* ]]; then
      printf '%s: [house 9] `agent: %s` is not one of the three built-in targets this project admits — a custom agent returns only on the reopening test in how-to/docs/skill-authoring/FORK-DECISION.md\n' \
        "$file" "$agent_val" >> "$TMP_HITS"
    fi
    if [[ "$context_val" == "fork" && -z "$background_val" ]]; then
      printf '%s: [house 11] `context: fork` with no `background:` — it answers the same write test as `agent:`, so it is stated alongside it\n' \
        "$file" >> "$TMP_HITS"
    fi
  fi

  # --- Clause 10: the routing section --------------------------------------------
  if [[ $vendored == false ]] && ! grep -q '^## Governing procedures' "$file"; then
    printf '%s: [house 10] no `## Governing procedures` section — the body carries the procedure this skill routes to\n' \
      "$file" >> "$TMP_HITS"
  fi
done < <(collect_skills)

if [[ "$SKILL_COUNT" -eq 0 ]]; then
  bold "✓ No skills found under $SCOPE_DIR/ — nothing to check."
  log ""
  [[ -n "$OUTPUT_FORMAT" ]] || exit 0
fi

HIT_COUNT=$(wc -l < "$TMP_HITS" | tr -d ' ')
BODY="$(cat "$TMP_HITS")"
FIRST_PARTY=$((SKILL_COUNT - VENDORED_COUNT))

log "  $SKILL_COUNT skill(s) — $FIRST_PARTY first-party, $VENDORED_COUNT vendored (spec clauses only)"
log ""

if [[ "$HIT_COUNT" -gt 0 && $QUIET == false ]]; then
  printf '\033[31m  ✗ %d conformance violation%s\033[0m\n' \
    "$HIT_COUNT" "$([[ "$HIT_COUNT" -ne 1 ]] && echo s)"
  printf '%s\n' "$BODY" | sed 's/^/    /'
  printf '\n'
fi

if [[ -n "$OUTPUT_FORMAT" ]]; then
  STATUS=$([[ "$HIT_COUNT" -eq 0 ]] && echo '✓ every skill conforms' || echo "✗ $HIT_COUNT violation(s)")
  case "$OUTPUT_FORMAT" in
    txt)
      { printf 'skill-conformance audit — %s\n' "$TIMESTAMP"
        printf 'skills=%s first_party=%s vendored=%s violations=%s\n\n' \
          "$SKILL_COUNT" "$FIRST_PARTY" "$VENDORED_COUNT" "$HIT_COUNT"
        printf '%s\n' "${BODY:-No violations.}"; } > "$OUTPUT_FILE" ;;
    md)
      { printf '# Skill Conformance Audit\n\n'
        printf '| | |\n|---|---|\n'
        printf '| **Generated** | %s |\n' "$TIMESTAMP"
        printf '| **Skills** | %s (%s first-party, %s vendored) |\n' \
          "$SKILL_COUNT" "$FIRST_PARTY" "$VENDORED_COUNT"
        printf '| **Violations** | %s |\n' "$HIT_COUNT"
        printf '| **Status** | %s |\n\n' "$STATUS"
        if [[ "$HIT_COUNT" -gt 0 ]]; then printf '```text\n%s\n```\n' "$BODY"
        else printf '_Every skill conforms to the Agent Skills specification and this project'"'"'s field set._\n'; fi
        printf '\nRule: `how-to/docs/SKILL-AUTHORING.md` · Spec: <https://agentskills.io/specification>\n'
      } > "$OUTPUT_FILE" ;;
    json)
      { printf '{\n  "script": "skill-conformance",\n  "timestamp": "%s",\n' "$TIMESTAMP"
        printf '  "skills": %s,\n  "first_party": %s,\n  "vendored": %s,\n' \
          "$SKILL_COUNT" "$FIRST_PARTY" "$VENDORED_COUNT"
        printf '  "violations": %s,\n' "$HIT_COUNT"
        printf '  "exit_code": %s\n}\n' "$([[ "$HIT_COUNT" -eq 0 ]] && echo 0 || echo 1)"
      } > "$OUTPUT_FILE" ;;
  esac
  log "  Report written → $OUTPUT_FILE"
  log ""
fi

if [[ "$HIT_COUNT" -eq 0 ]]; then
  bold "✓ Every skill conforms — spec fields valid, field set held, fork targets built-in."
  log ""
  exit 0
else
  bold "✗ $HIT_COUNT conformance violation(s) — see how-to/docs/SKILL-AUTHORING.md."
  log ""
  exit 1
fi
