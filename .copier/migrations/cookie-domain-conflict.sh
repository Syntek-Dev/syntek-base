#!/usr/bin/env bash
#
# cookie-domain-conflict.sh — report a cookie scope the __Host- prefix forbids.
#
# WHAT CHANGED. The template's staging and production settings name the session and CSRF
# cookies with the `__Host-` prefix, and no settings module sets a cookie Domain. A browser
# accepts a `__Host-` cookie only when it carries Secure, Path=/ and NO Domain attribute, and
# silently drops any other. So a settings module that still assigns SESSION_COOKIE_DOMAIN or
# CSRF_COOKIE_DOMAIN (other than None) — or a SESSION/CSRF_COOKIE_PATH other than "/" — beside those names means
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
# Exit codes:  0 = always (advisory), an unreadable module included
#
set -euo pipefail

SETTINGS_DIR="code/src/django/config/settings"

[[ -d "$SETTINGS_DIR" ]] || exit 0

# The same detector as cookie-scope-widened in audits/negative-space.sh, so the two report the
# same (module, setting) pairs. It reads the CODE part of each line (a trailing comment is
# cut; string contents, multi-line strings included, are ignored; a trailing CR is trimmed)
# and sees plain, indented, annotated, chained and augmented assignments; a Domain of None and
# a Path of exactly "/" are host-only, not findings. It fails closed: any other occurrence of
# a Domain or Path name in code (unpacking, del, a read) is reported too. A module it cannot
# read is named as such, never passed. Records carry no value.
# TWIN: code/src/scripts/audits/_lib/negative-space-cookies.sh carries this same program and
# pattern (COOKIE_AWK, COOKIE_WIDE) — change both. Self-contained: the lib is not shipped here.
# shellcheck disable=SC2016  # an awk program: its $ fields are awk's, never the shell's
COOKIE_AWK='
function scan(s,   i, c, d, n) {
  code = ""; mask = ""; n = length(s)
  for (i = 1; i <= n; i++) {
    c = substr(s, i, 1)
    if (q != "") {
      if (c == "\\") { code = code c substr(s, i + 1, 1); i++; continue }
      d = (length(q) == 3) ? substr(s, i, 3) : c
      if (d == q) { code = code d; mask = mask d; i += length(q) - 1; q = ""; continue }
      code = code c; continue
    }
    if (c == "#") break
    if (c == "\"" || c == sq) {
      d = substr(s, i, 3); q = (d == c c c) ? d : c
      code = code q; mask = mask q; i += length(q) - 1; continue
    }
    code = code c; mask = mask c
  }
  if (length(q) == 1 && substr(s, n, 1) != "\\") q = ""
}
function classify(v) {
  if (v == "True") return "true"
  if (v == "False") return "false"
  if (v == "None") return "none"
  if (v ~ ("^[rRuU]?(\"/\"|" sq "/" sq ")$")) return "root"
  if (v ~ ("^[rRuU]?(\"__Host-[^\"" sq "]*\"|" sq "__Host-[^\"" sq "]*" sq ")$")) return "host"
  return "other"
}
{
  sub(/\r$/, ""); open = (q != ""); scan($0)
  s = code; ind = (s ~ /^[ \t]/) ? 1 : 0; sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s)
  n = 0; aug = 0; split("", seen)
  while (!open && match(s, /^[A-Za-z_][A-Za-z0-9_]*/)) {
    id = substr(s, 1, RLENGTH); r = substr(s, RLENGTH + 1); sub(/^[ \t]+/, "", r)
    if (r ~ /^:[^=]/ || r == ":") { p = index(r, "="); if (!p || substr(r, p + 1, 1) == "=") break; r = substr(r, p + 1) }
    else if (match(r, /^(\*\*|\/\/|<<|>>|[-+*\/%@&|^])=/)) { r = substr(r, RLENGTH + 1); aug = 1 }
    else if (r ~ /^=/ && r !~ /^==/) r = substr(r, 2)
    else break
    t[++n] = id; sub(/^[ \t]+/, "", r); s = r
    if (aug) break
  }
  cls = aug ? "aug" : classify(s)
  for (i = 1; i <= n; i++)
    if (t[i] ~ /^((SESSION|CSRF)_COOKIE_(DOMAIN|PATH|NAME|SECURE|HTTPONLY)|SECURE_SSL_REDIRECT)$/) {
      print NR, ind, t[i], cls; seen[t[i]]++
    }
  m = mask
  while (match(m, /[A-Za-z_][A-Za-z0-9_]*/)) {
    id = substr(m, RSTART, RLENGTH); m = substr(m, RSTART + RLENGTH)
    if (id !~ /^((SESSION|CSRF)_COOKIE_(DOMAIN|PATH|NAME|SECURE)|CSRF_COOKIE_HTTPONLY|SECURE_SSL_REDIRECT)$/) continue
    if (seen[id] > 0) seen[id]--; else print NR, ind, id, "unrec"
  }
}'
# shellcheck disable=SC2016  # awk, as above
COOKIE_WIDE='$3 ~ /_COOKIE_DOMAIN$/ && $4 != "none" || $3 ~ /_COOKIE_PATH$/ && $4 != "root"'

declare -a HITS=() UNREAD=()
while IFS= read -r -d '' file; do
  # A module awk cannot read is named, never passed as clean (code/docs/GATE-REPORTING.md).
  if [[ ! -r "$file" ]] || ! awk -v sq="'" "$COOKIE_AWK" "$file" > /dev/null 2>&1; then
    UNREAD+=("$file"); continue
  fi
  while read -r line name; do
    [[ -n "$line" ]] || continue
    HITS+=("$(printf '%s:%s  %s' "$file" "$line" "$name")")
  done < <(awk -v sq="'" "$COOKIE_AWK" "$file" 2>/dev/null | awk "$COOKIE_WIDE"' { print $1, $3 }' || true)
done < <(find -L "$SETTINGS_DIR" -type f -name '*.py' -print0 2>/dev/null | sort -z || true)

[[ ${#HITS[@]} -gt 0 || ${#UNREAD[@]} -gt 0 ]] || exit 0

if [[ ${#UNREAD[@]} -gt 0 ]]; then
  printf '\n▸ Cookie scope — %d settings module(s) could not be read\n\n' "${#UNREAD[@]}"
  for u in "${UNREAD[@]}"; do printf '    %s could not be read — its cookie settings were not checked\n' "$u"; done
  printf '\n  Make each readable and run this check again:  bash code/src/scripts/audits/negative-space.sh\n'
fi

[[ ${#HITS[@]} -gt 0 ]] || { printf '\n'; exit 0; }

printf '\n▸ Cookie scope — %d setting(s) the __Host- prefix forbids\n\n' "${#HITS[@]}"
printf '  These settings modules assign a cookie Domain, or a Path other than "/" — or name\n'
printf '  one in a way this check cannot evaluate (unpacking, del, a read), which counts too:\n\n'
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
