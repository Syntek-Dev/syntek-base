#!/usr/bin/env bash
#
# env-file.sh — read a docker-compose env file WITHOUT executing it.
#
#               Sourced, never invoked. Provides `env_value` (one key) and
#               `env_export` (every key, exported).
#
# WHY THIS EXISTS. Four scripts used `set -a; source "$ENV_FILE"; set +a`, which hands the
# file to bash as a script. Compose does not: it has its own `KEY=VALUE` parser, in which a
# value is a literal string. The two disagree the moment a value contains a shell
# metacharacter, and then bash aborts the source at that line — leaving every LATER
# assignment unset, because a partial source is silent about how far it got.
#
# It was not hypothetical. In this template `.env.dev` line 11 is
# `POSTGRES_USER=<%PROJECT_SLUG%>`, whose `<`, `%` and `>` are metacharacters, so
# `server.sh up` died at exit 2 under `set -euo pipefail` with the stack already running:
# the database password re-sync never ran, and the URL banner never printed. A generated
# project renders that token and escapes it — but a POSTGRES_PASSWORD containing `$`, a
# backtick, `#` or a space breaks it there too, and those are ordinary passwords.
#
# WHY NOT `grep | cut`. Because compose strips one layer of surrounding quotes and a naive
# cut does not — it bakes the quotes into the password, which is the bug the `source`
# approach was originally chosen to avoid (see seed-dev.sh's own note). The stripping below
# is what keeps that fix while dropping the execution.
#
# INTERPOLATION IS REFUSED, NOT GUESSED. Compose has a full grammar here — `$VAR`,
# `${VAR}`, `${VAR:-default}`, `$$` for a literal `$`, and single quotes that suppress all
# of it. Reimplementing that in bash and getting one case subtly wrong would hand
# `ALTER USER … PASSWORD` a string the database was never created with, which is the exact
# failure `_sync_db_password` exists to prevent — a silent disagreement is worse than the
# `source` this replaced, because it produces a plausible wrong answer instead of an error.
#
# So: `$$` is collapsed to a literal `$`, exactly as compose does, and that is the
# supported way to put a `$` in a value. Anything else containing a `$` is refused by name,
# loudly. No shipped `.env*.example` in this repository uses interpolation, so this is a
# guard against a future file rather than a limitation anyone meets today.

# Strip one layer of matching quotes, or an inline comment and trailing space from an
# unquoted value — the same shape compose's parser produces. Args 2 and 3 are the key and
# file, used only to name the offender in the interpolation error.
_env_strip() {
  local v="$1" key="${2:-?}" file="${3:-?}" literal=0
  case "$v" in
    '"'*'"')
      v="${v#\"}"
      v="${v%\"}"
      ;;
    "'"*"'")
      # Single quotes suppress interpolation in compose too, so this needs no check.
      v="${v#\'}"
      v="${v%\'}"
      literal=1
      ;;
    *)
      v="${v%%[[:space:]]#*}"
      v="${v%"${v##*[![:space:]]}"}"
      ;;
  esac

  if (( ! literal )); then
    # Remove the escaped pairs first; a `$` still standing is a real interpolation.
    if [[ "${v//\$\$/}" == *'$'* ]]; then
      printf 'env-file.sh error: %s in %s uses variable interpolation.\n' "$key" "$file" >&2
      printf '  This reader is literal by design and would disagree with docker compose.\n' >&2
      printf '  Write a literal dollar as $$, or single-quote the value to suppress it.\n' >&2
      return 2
    fi
    v="${v//\$\$/\$}"
  fi

  printf '%s' "$v"
}

# env_value KEY FILE — print one value, or nothing. Never fails: a missing file or a
# missing key is an absent value, which every caller already handles with a `:-` default.
env_value() {
  local key="$1" file="$2" line=""
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  line=$(grep -E "^[[:space:]]*(export[[:space:]]+)?${key}=" -- "$file" | tail -n 1) || line=""
  if [[ -z "$line" ]]; then
    return 0
  fi
  _env_strip "${line#*=}" "$key" "$file"
}

# env_export FILE — export every assignment in the file into the current shell.
# For the caller that needs the whole environment rather than two named keys.
env_export() {
  local file="$1" line key value
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  # `|| [[ -n "$line" ]]` so a final line with no trailing newline is still read.
  while IFS= read -r line || [[ -n "$line" ]]; do
    line="${line#"${line%%[![:space:]]*}"}"
    if [[ -z "$line" || "$line" == \#* ]]; then
      continue
    fi
    line="${line#export }"
    if [[ "$line" != *=* ]]; then
      continue
    fi
    key="${line%%=*}"
    key="${key%"${key##*[![:space:]]}"}"
    # Anything that is not a legal identifier is not an assignment compose would honour.
    if [[ ! "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
      continue
    fi
    value="$(_env_strip "${line#*=}" "$key" "$file")"
    declare -gx "$key=$value"
  done < "$file"
}
