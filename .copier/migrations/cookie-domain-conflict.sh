#!/usr/bin/env bash
#
# cookie-domain-conflict.sh — report a cookie scope the __Host- prefix forbids.
#
# WHAT CHANGED. The template's staging and production settings name the session and CSRF
# cookies with the `__Host-` prefix, and no settings module sets a cookie Domain. A browser
# accepts a `__Host-` cookie only when it carries Secure, Path=/ and NO Domain attribute, and
# silently drops any other. So a settings module that still assigns SESSION_COOKIE_DOMAIN or
# CSRF_COOKIE_DOMAIN — or a SESSION/CSRF_COOKIE_PATH other than "/" — beside those names means
# the browser refuses the cookie: every login and every CSRF-protected write fails, behind an
# update that reported success. Owner of the rule: code/docs/security/CRYPTO-AND-DATA.md.
#
# WHY AN UPDATE CANNOT REPAIR IT. Copier merges the template's settings into yours. A line
# YOU added is not the template's, so the merge keeps it, raises no conflict, and the broken
# combination arrives clean.
#
# WHY IT ADVISES RATHER THAN ACTS. Some projects set a Domain on purpose — the N-005 case, a
# cookie deliberately shared with sibling subdomains. Whether that need outweighs the prefix
# is a judgement only the project can make, and a migration that deleted the line would make
# it silently. So this names the line and leaves it.
#
# WHY IT HAS NO VERSION KEY. The combination is wrong WHENEVER it holds, whatever release
# produced it, so the entry is gated on project state: it runs on every update and is SILENT
# when it finds nothing. A project that keeps a deliberate Domain line sees this report on
# every update until it removes the line — the advisory says so rather than deciding.
#
# SCOPE. Only `*.py` under code/src/django/config/settings/ — the modules Django reads its
# settings from. Never the whole project: a guide that DOCUMENTS these settings (the
# template's own register in how-to/src/TEMPLATE-GUIDE/06-GENERATION.md among them) is not a
# setting, and reporting it would tell the operator to edit prose.
#
# NEVER PRINTS A VALUE. It reports file, line and setting name only; the value may be a real
# hostname, and an update's output is pasted into tickets and CI logs.
#
# Runs automatically as an unversioned copier `_migrations` entry on every update. Safe to
# run by hand; read-only and idempotent.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = always (advisory)
#
set -euo pipefail

SETTINGS_DIR="code/src/django/config/settings"

[[ -d "$SETTINGS_DIR" ]] || exit 0

ASSIGN='^[[:space:]]*(SESSION|CSRF)_COOKIE_(DOMAIN|PATH)[[:space:]]*='
ROOT_PATH='_PATH[[:space:]]*=[[:space:]]*(["'"'"'])/\1[[:space:]]*(#.*)?$'

declare -a HITS=()
while IFS= read -r hit; do
  [[ -n "$hit" ]] || continue
  file="${hit%%:*}"
  rest="${hit#*:}"
  line="${rest%%:*}"
  code="${rest#*:}"
  # A Path of exactly "/" is what the prefix requires — not a finding.
  grep -qE -- "$ROOT_PATH" <<<"$code" && continue
  name="$(grep -oE '(SESSION|CSRF)_COOKIE_(DOMAIN|PATH)' <<<"$code" | head -1)"
  HITS+=("$(printf '%s:%s  %s' "$file" "$line" "$name")")
done < <(find "$SETTINGS_DIR" -type f -name '*.py' -exec grep -nHE -- "$ASSIGN" {} + 2>/dev/null | sort || true)

[[ ${#HITS[@]} -gt 0 ]] || exit 0

printf '\n▸ Cookie scope — %d setting(s) the __Host- prefix forbids\n\n' "${#HITS[@]}"
printf '  These settings modules assign a cookie Domain, or a Path other than "/":\n\n'
for h in "${HITS[@]}"; do printf '    %s\n' "$h"; done

cat <<'ADVICE'

  A browser drops a __Host- prefixed cookie that carries a Domain attribute or a Path
  other than "/". With these lines in place, logins and CSRF-protected writes fail on any
  environment whose settings name the cookies with that prefix (staging and production).

  1. To follow the template: delete each line above. Host-only scope is the rule; it
     needs no setting at all. Owner: code/docs/security/CRYPTO-AND-DATA.md.
  2. If you set it deliberately (a cookie shared across subdomains): that need and the
     __Host- names cannot coexist. Decide which wins, record why, and expect this report
     on every update until the line is gone — it reports and does not decide.

  Prove it:  bash code/src/scripts/audits/negative-space.sh

  Nothing was changed, and no setting's value is printed.

ADVICE

exit 0
