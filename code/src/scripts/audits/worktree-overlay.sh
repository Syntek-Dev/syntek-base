#!/usr/bin/env bash
#
# worktree-overlay.sh — Verify the worktree dev overlay trusts its own published origins.
#
# A per-story dev stack is published on 127.0.0.NNN:3080 and advertised as
# http://dev-usNNN.<slug>.localhost:3080. Dev nginx forwards Host without the port, so
# Django's same-origin check never matches there and every form POST is refused with CSRF
# 403 unless both origins are trusted. The overlay supplies them through
# DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA, which config/settings/dev.py appends to the :81
# defaults (BUG-US008, F-006).
#
# Mechanical checks:
#   1. The overlay example's `django` service sets DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA under
#      `environment:`.
#   2. That value names both the advertised :3080 origin and the 127.0.0.NNN:3080 origin.
#   3. code/src/docker/.env.dev.example names the variable.
#
# FAILS CLOSED: a missing overlay example or .env.dev.example exits 2, never 0 — the file
# this check reads is not an optional surface, so its absence is an error, not a no-op.
#
# What it CANNOT check: that a copied overlay had NNN replaced (story number without
# leading zeros in IPs and subnets), or that a running stack received the value. The
# settings tests in code/src/django/config/tests/ own the parsing.
#
# The test image copies only code/src/django/, so the overlay is unreachable from pytest;
# this check runs on the host with no Docker.
#
# Usage: worktree-overlay.sh [--output FORMAT] [--output-file PATH] [--quiet] [--help]
#
# Exit codes:  0 = overlay trusts its origins   1 = violation(s) found   2 = script error
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
REPORTS_DIR="$PROJECT_ROOT/code/src/scripts/audits/reports"

OVERLAY_REL="code/src/docker/docker-compose.usXXX.dev.yml.example"
ENV_EXAMPLE_REL="code/src/docker/.env.dev.example"
VAR="DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA"
# Copier renders the slug token, so match the origin around it rather than spelling it.
NAME_ORIGIN_RE='http://dev-usNNN\.[^,"]*\.localhost:3080'
IP_ORIGIN='http://127.0.0.NNN:3080'

OUTPUT_FORMAT=""
OUTPUT_FILE=""
QUIET=false
ERROR=""
declare -a FINDINGS=()

log()  { $QUIET || printf '%s\n' "$*"; }
die()  { printf 'worktree-overlay.sh error: %s\n' "$*" >&2; exit 2; }
bold() { $QUIET || printf '\033[1m%s\033[0m\n' "$*"; }

usage() {
  cat <<'USAGE'
worktree-overlay.sh — Verify the worktree dev overlay trusts its own published origins

Checks code/src/docker/docker-compose.usXXX.dev.yml.example sets
DJANGO_CSRF_TRUSTED_ORIGINS_EXTRA on the django service, naming both the advertised
http://dev-usNNN.<slug>.localhost:3080 origin and http://127.0.0.NNN:3080, and that
code/src/docker/.env.dev.example names the variable.

Usage:
  worktree-overlay.sh                    Check and print the result
  worktree-overlay.sh --output md        Write a report

Options:
  --output FORMAT      Write a report: md | txt | json
  --output-file PATH   Override the default report path
  --quiet              Suppress terminal output — requires --output
  --help, -h           Show this help

There is no --path: two files at fixed, repository-relative paths are not a scope.
Passing it exits 2.

Exit codes:
  0  the overlay trusts both published origins
  1  a check failed — a worktree stack would refuse every form POST
  2  script error, including a missing overlay or env example (fails closed)

Fixing a finding: restore the variable in the overlay example or the env example.
Never relax a pattern here to make the run pass.
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)      [[ $# -ge 2 ]] || die "--output needs a format"; OUTPUT_FORMAT="$2"; shift 2 ;;
    --output-file) [[ $# -ge 2 ]] || die "--output-file needs a path"; OUTPUT_FILE="$2"; shift 2 ;;
    --quiet)       QUIET=true; shift ;;
    --path)        die "--path is not supported: this audit reads two fixed files" ;;
    --help|-h)     usage; exit 0 ;;
    *)             die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

$QUIET && [[ -z "$OUTPUT_FORMAT" ]] && die "--quiet requires --output"
case "$OUTPUT_FORMAT" in
  ""|md|txt|json) ;;
  *) die "Unknown output format: $OUTPUT_FORMAT (use md, txt or json)" ;;
esac

json_str() {
  local s="$1"
  s="${s//\\/\\\\}"; s="${s//\"/\\\"}"
  printf '"%s"' "$s"
}

# Written on every path that reaches a verdict, including the fail-closed error.
write_report() {
  [[ -n "$OUTPUT_FORMAT" ]] || return 0
  mkdir -p "$REPORTS_DIR"
  [[ -n "$OUTPUT_FILE" ]] || OUTPUT_FILE="$REPORTS_DIR/worktree-overlay-report.$OUTPUT_FORMAT"
  local f first=true
  {
    case "$OUTPUT_FORMAT" in
      json)
        printf '{"findings": ['
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do
          $first || printf ', '; first=false; json_str "$f"
        done
        printf '], "error": '
        if [[ -n "$ERROR" ]]; then json_str "$ERROR"; else printf 'null'; fi
        printf '}\n'
        ;;
      md)
        printf '# worktree-overlay\n\n'
        if [[ -n "$ERROR" ]]; then
          printf 'Error (exit 2): %s\n' "$ERROR"
        elif (( ${#FINDINGS[@]} == 0 )); then
          printf 'The overlay trusts both published origins.\n'
        fi
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf -- '- %s\n' "$f"; done
        ;;
      txt)
        [[ -n "$ERROR" ]] && printf 'ERROR %s\n' "$ERROR"
        for f in "${FINDINGS[@]+"${FINDINGS[@]}"}"; do printf '%s\n' "$f"; done
        ;;
    esac
  } >"$OUTPUT_FILE"
  log "  report: ${OUTPUT_FILE#"$PROJECT_ROOT"/}"
}

fail_closed() { ERROR="$*"; write_report; die "$ERROR"; }

bold "▸ worktree-overlay.sh"
log "  checking $OVERLAY_REL and $ENV_EXAMPLE_REL…"
log ""

OVERLAY="$PROJECT_ROOT/$OVERLAY_REL"
ENV_EXAMPLE="$PROJECT_ROOT/$ENV_EXAMPLE_REL"
[[ -f "$OVERLAY" ]] || fail_closed "missing $OVERLAY_REL"
[[ -f "$ENV_EXAMPLE" ]] || fail_closed "missing $ENV_EXAMPLE_REL"

# The value assigned to $VAR inside services.django.environment, or nothing. Handles both
# the mapping form (VAR: value) and the list form (- VAR=value); indentation decides scope.
value="$(awk -v var="$VAR" '
  function indent(s) { match(s, /^ */); return RLENGTH }
  /^[[:space:]]*(#|$)/ { next }
  {
    i = indent($0)
    if (i == 0) { in_services = ($0 ~ /^services:/); svc = ""; in_env = 0; next }
    if (!in_services) next
    if (i == 2) { svc = $0; sub(/^ +/, "", svc); sub(/:.*/, "", svc); in_env = 0; next }
    if (svc != "django") next
    if (i == 4) { in_env = ($0 ~ /^ +environment:/); next }
    if (in_env && i > 4) {
      line = $0; sub(/^ +(- +)?/, "", line)
      if (index(line, var ":") == 1 || index(line, var "=") == 1) {
        v = substr(line, length(var) + 2); sub(/^ +/, "", v); gsub(/"|\x27/, "", v)
        print v; exit
      }
    }
  }
' "$OVERLAY")" || fail_closed "could not parse $OVERLAY_REL"

if [[ -z "$value" ]]; then
  FINDINGS+=("$OVERLAY_REL: the django service sets no $VAR under environment:")
else
  log "  found $VAR=$value"
  [[ "$value" =~ $NAME_ORIGIN_RE ]] \
    || FINDINGS+=("$OVERLAY_REL: $VAR omits the advertised origin http://dev-usNNN.<slug>.localhost:3080")
  [[ ",$value," == *",$IP_ORIGIN,"* ]] \
    || FINDINGS+=("$OVERLAY_REL: $VAR omits the published origin $IP_ORIGIN")
fi

grep -q "$VAR" "$ENV_EXAMPLE" \
  || FINDINGS+=("$ENV_EXAMPLE_REL: does not name $VAR")

if (( ${#FINDINGS[@]} == 0 )); then
  log "  the overlay trusts both published origins"
else
  for f in "${FINDINGS[@]}"; do log "  ✗ $f"; done
fi
log ""

write_report

if (( ${#FINDINGS[@]} > 0 )); then
  printf '\033[31m✗ %s violation(s) — a worktree stack would refuse every form POST\033[0m\n' "${#FINDINGS[@]}"
  exit 1
fi
bold "✓ worktree-overlay clean"
