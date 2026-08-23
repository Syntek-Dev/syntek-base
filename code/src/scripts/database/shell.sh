#!/usr/bin/env bash
#
# shell.sh — Open a database shell via Docker (Django dbshell or direct psql).
#
# Usage: shell.sh [--psql] [--help]
#
# --psql:  Direct psql session in the db container. This is the mode that works on the
#          images this template ships, because postgres:18-alpine carries the psql binary.
# Default: Django dbshell (python manage.py dbshell) in the django container. Django does not
#          implement a shell — its postgresql DatabaseClient sets executable_name = "psql" and
#          execs it — and Dockerfile.dev installs libpq-dev, which is the client *library* and
#          its headers, never the psql *binary* that comes with postgresql-client. So this mode
#          works only in a project that has added postgresql-client to that image. Guarded below
#          rather than removed, because that project is a legitimate one.
#
# NEITHER MODE IS READ-ONLY, AND NEITHER IS UNPRIVILEGED. Both arrive as POSTGRES_USER, which
# the db image creates with `initdb --username="$POSTGRES_USER"` — the cluster's bootstrap
# superuser. Measured against the running dev stack: rolsuper = t, rolbypassrls = t,
# default_transaction_read_only = off. Every write is permitted and every row-level-security
# policy is bypassed, so what this session sees is not what a scoped application user sees.
#
# Exit codes:  0 = the session ended normally
#              2 = a prerequisite the caller must fix — an unknown option, a container that
#                  is not running, no psql binary in the django container, or a probe that
#                  returned no verdict. Every one of them is the single `die` below.
#              * = anything else is the session's own code, passed straight through by
#                  `exec`. Measured: a psql script error under ON_ERROR_STOP arrives as 3.
#
# No separate code marks "could not look". This script publishes no verdict about the
# database, so it has no clean/unclean axis for GATE-REPORTING's code 3 to sit on, and 3 is
# already reachable as the exec'd session's own. The two refusals are told apart by their
# message: one states psql is absent, the other states that nothing was established.
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
COMPOSE_FILE="$PROJECT_ROOT/code/src/docker/docker-compose.dev.yml"
ENV_FILE="$PROJECT_ROOT/code/src/docker/.env.dev"

# shellcheck source=code/src/scripts/_lib/worktree-detect.sh
source "$SCRIPT_DIR/../_lib/worktree-detect.sh"
# shellcheck source=code/src/scripts/_lib/env-file.sh
source "$SCRIPT_DIR/../_lib/env-file.sh"
DC=(docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" \
    ${OVERRIDE_DEV_FILE:+-f "$OVERRIDE_DEV_FILE"})

# Read POSTGRES_USER / POSTGRES_DB out of the env file — `--env-file` injects them into
# the compose process, not into this shell. Parsed rather than sourced: a value carrying a
# shell metacharacter aborts a `source` partway and silently leaves the rest unset
# (_lib/env-file.sh).
DB_NAME="$(env_value POSTGRES_DB "$ENV_FILE")"
DB_USER="$(env_value POSTGRES_USER "$ENV_FILE")"
DB_NAME="${DB_NAME:-<%PROJECT_SLUG%>_dev}"
DB_USER="${DB_USER:-<%PROJECT_SLUG%>}"

# ── Defaults ──────────────────────────────────────────────────────────────────
USE_PSQL=false

# ── Helpers ───────────────────────────────────────────────────────────────────
die()  { printf 'shell.sh error: %s\n' "$*" >&2; exit 2; }
bold() { printf '\033[1m%s\033[0m\n' "$*"; }
log()  { printf '%s\n' "$*"; }

usage() {
  cat <<'EOF'
shell.sh — Open a database shell via Docker

Usage:
  shell.sh --psql    Direct psql session in the db container — works on the shipped images
  shell.sh           Django dbshell (python manage.py dbshell) — default; needs psql in the
                     django image, which the shipped one does not have

Options:
  --psql     Open psql directly in the db container instead of Django dbshell

psql connects as POSTGRES_USER to POSTGRES_DB (env vars, defaults: <%PROJECT_SLUG%> / <%PROJECT_SLUG%>_dev).

Django dbshell connects using the DATABASE_URL / DATABASES setting from Django config, then
execs a psql binary the shipped dev image does not carry: libpq-dev is the client library,
postgresql-client is the binary. Add postgresql-client to code/src/docker/django/Dockerfile.dev
to use this mode; until then it exits 2 naming the cause.

Neither mode is read-only and neither is unprivileged — POSTGRES_USER is the cluster superuser,
so every write is permitted and every RLS policy is bypassed.

Exit codes:  0 = the session ended normally
             2 = a prerequisite you must fix — an unknown option, a container that is not
                 running, or no psql binary in the django container
             * = the session's own exit code, passed through (psql returns 3 for a script
                 error under ON_ERROR_STOP)
EOF
}

# ── Argument parsing ──────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --psql)     USE_PSQL=true; shift ;;
    --help|-h)  usage; exit 0 ;;
    *)          die "Unknown option '$1'. Use --help for usage." ;;
  esac
done

cd "$PROJECT_ROOT"

if $USE_PSQL; then
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "db" \
    || die "db container is not running. Start with: bash code/src/scripts/development/server.sh up"
  bold "▸ shell.sh — psql ($DB_USER @ $DB_NAME)"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec "${DC[@]}" exec db \
    psql -U "$DB_USER" -d "$DB_NAME"
else
  "${DC[@]}" ps --services --status running 2>/dev/null | grep -qx "django" \
    || die "django container is not running. Start with: bash code/src/scripts/development/server.sh up"

  # Probe for the binary Django is about to exec, BEFORE printing the banner. Without this the
  # branch reaches `manage.py dbshell`, Django's runshell() hands "psql" to subprocess.run, the
  # FileNotFoundError becomes `CommandError: You appear not to have the 'psql' program installed
  # or on your path.` and the script exits 1 (Django's CommandError defaults to returncode=1).
  # The table above assigns 1 to nothing of its own, so that code is indistinguishable from the
  # session's, and the one fact worth reading off it — a healthy container missing a binary — is
  # the one the caller cannot. Sending the reader to restart a stack that is already up is the
  # defect, and it is the reporting one: code/docs/GATE-REPORTING.md gives the syntax family 2
  # for "a prerequisite the caller must fix", and the table above adopts that meaning here.
  #
  # Probed rather than assumed, because the answer is per project — add postgresql-client to
  # Dockerfile.dev and this branch works as documented, with no further change here.
  #
  # The probe prints a marker and is judged on the marker, NEVER on the exit code of
  # `command -v`. That code is not portable: /bin/sh in this image is dash, whose `command -v`
  # exits 127 for an absent name where bash exits 1 — so an exit-code test written against bash
  # reads a real "it is absent" answer as "the probe would not run", and a caller who then
  # believed the opposite reading would have this script asserting a presence nobody checked.
  # Marker present or marker absent is the same sentence in every shell.
  set +e
  PSQL_PROBE=$("${DC[@]}" exec -T django \
    sh -c 'if command -v psql >/dev/null 2>&1; then echo PSQL_PRESENT; else echo PSQL_ABSENT; fi' 2>/dev/null)
  PROBE_RAN=$?
  set -e
  # Three outcomes, not two. Absent is a result; a probe that could not run is not, and
  # reporting the second as the first would be this script telling the same lie in miniature —
  # "could not look" printed as "looked, and it is not there". Rule: code/docs/GATE-REPORTING.md.
  case "$PROBE_RAN:${PSQL_PROBE//[$'\r\n']/}" in
    0:PSQL_PRESENT) : ;;
    0:PSQL_ABSENT)
      die "django container has no psql binary, so 'manage.py dbshell' cannot open a session.
       Use instead:  bash code/src/scripts/database/shell.sh --psql
       psql lives in the db container; the django image installs libpq-dev (the client
       library), not postgresql-client (the binary)." ;;
    *)
      die "could not determine whether psql is present in the django container.
       The probe returned no verdict, so nothing has been established either way and this run
       reports no result rather than guessing. Try:  bash code/src/scripts/database/shell.sh --psql" ;;
  esac

  bold "▸ shell.sh — Django dbshell"
  log "  Type \\q or press Ctrl+D to exit."
  log ""
  exec "${DC[@]}" exec -w /workspace/code/src/django django python manage.py dbshell
fi
