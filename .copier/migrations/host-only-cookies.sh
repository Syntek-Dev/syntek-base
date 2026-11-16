#!/usr/bin/env bash
#
# host-only-cookies.sh — the one-time cutover notice for the __Host- cookie rename.
#
# PENDING. Its `_migrations:` entry ships DISABLED (`when: false`) and carries no version key.
# The release that ships this doctrine assigns the key, renames this file to
# v<RELEASE>-host-only-cookies.sh on the v3.0.0-self-authored-agents.sh convention, and
# replaces the false condition with the after-stage predicate — all in the release commit,
# which is then tagged. Until that commit nothing runs it. Its sibling
# cookie-domain-conflict.sh is the always-active, state-gated half.
#
# WHAT CHANGED. Staging and production now name the session cookie `__Host-sessionid` and
# the CSRF cookie `__Host-csrftoken`, set no cookie Domain, and base settings set
# CSRF_COOKIE_HTTPONLY = True. A browser holding the old plain-named cookies does not send
# them under the new names, so at the first deploy every live session and every open CSRF
# token is invalidated: users are logged out and any form open in a tab fails its first
# submit.
#
# WHY AN UPDATE CANNOT REPAIR IT. The invalidation happens in browsers, at deploy time, on
# servers Copier never sees. There is no file to fix — only a moment to choose.
#
# WHY IT ADVISES RATHER THAN ACTS. When to deploy, whether a rolling deploy can be swapped
# for a stop-start one, and what else matches these cookies by name are all operator
# decisions. It prints for every project crossing the release, whatever its settings say,
# because the invalidation is true of all of them — the reason this is a version-keyed
# entry and not a state-gated one.
#
# Runs automatically as a copier `_migrations` entry when an update crosses the release
# that activates it. Safe to run by hand; read-only, prints the same notice every time.
#
# Working directory is the project being updated.
#
# Exit codes:  0 = always (advisory)
#
set -euo pipefail

SETTINGS_DIR="code/src/django/config/settings"

[[ -d "$SETTINGS_DIR" ]] || exit 0

printf '\n▸ Host-only cookies — the session and CSRF cookies are renamed\n\n'
printf '  This release moves staging and production to __Host- cookie names, sets no cookie\n'
printf '  Domain, and makes the CSRF cookie httpOnly. Your next deploy is a cutover.\n'

cat <<'ADVICE'

  1. The first deploy invalidates every live session and every open CSRF token.
     Users are logged out; a form already open in a tab fails its first submit.
     WHEN you deploy is therefore a decision — pick a quiet window and say so.

  2. A rollback is not free. Rolling back restores the plain names and invalidates
     everything a second time.

  3. A rolling deploy is UNSAFE for this release. Old and new instances serve both
     names at once, so a load-balanced user is logged out repeatedly, and it surfaces
     as CSRF 403s on writes rather than a redirect to login. Stop-start, or drain to
     one version before serving traffic.

  4. Repoint anything that matches these cookies by name: an edge or WAF rule, a
     monitor or synthetic check, a test, a log filter. Any script that read the CSRF
     cookie from JavaScript is now blind to it (CSRF_COOKIE_HTTPONLY = True) — read
     the token from the page instead.

  Owner of the rule:  code/docs/security/CRYPTO-AND-DATA.md

  Prove it:  bash code/src/scripts/audits/negative-space.sh

  Nothing was changed.

ADVICE

exit 0
