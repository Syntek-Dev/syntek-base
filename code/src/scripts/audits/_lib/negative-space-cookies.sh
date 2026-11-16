# shellcheck shell=bash
# negative-space-cookies.sh — the cookie doctrine half of audits/negative-space.sh (US008).
#
# Sourced by negative-space.sh, never run. It defines functions and constants only; nothing
# executes on source. It reads the caller's globals and helpers rather than taking its own:
#   SETTINGS_DIR (declared in the caller beside SETTINGS_FILE, repointed by point_scopes_at),
#   fail / skip, and under --self-test FIXTURES_DIR, TMP_FAIL, TMP_WARN, SKIP_NOTES,
#   BROKEN_BODY, point_scopes_at, run_all and st_fail.
#
# csrf-cookie-httponly-absent  base.py does not assign CSRF_COOKIE_HTTPONLY = True
# cookie-host-prefix-absent    staging.py / production.py lack a __Host- SESSION_COOKIE_NAME
#                              or CSRF_COOKIE_NAME, or the SECURE = True line it depends on
# cookie-scope-widened         any *.py in the directory assigns a *_COOKIE_DOMAIN, or a
#                              *_COOKIE_PATH other than "/"
# Owner: code/docs/security/CRYPTO-AND-DATA.md, Browser Storage Policy. Scope: *.py in the
# directory, never CONTEXT.md beside them. Every match is anchored to an assignment at the
# start of a line, so a comment or a commented-out assignment neither fires nor passes.
COOKIE_SET='[[:space:]]*=[[:space:]]*'
COOKIE_EOL='[[:space:]]*(#.*)?$'   # the value ends the line, so a docstring line never matches
COOKIE_TRUE="True$COOKIE_EOL"
COOKIE_CLAUSES=(csrf-cookie-httponly-absent cookie-host-prefix-absent cookie-scope-widened)
cookie_has() { grep -qE "^$2$COOKIE_SET$3" "$1"; }

run_cookie_clauses() {
  local dir="$1" f kind missing hit
  if [[ ! -d "$dir" ]]; then
    skip "csrf-cookie-httponly-absent: no $dir — reads base.py only"
    skip "cookie-host-prefix-absent: no $dir — reads staging.py and production.py only"
    skip "cookie-scope-widened: no $dir — reads every *.py in it"
    return 0
  fi
  f="$dir/base.py"
  if [[ ! -f "$f" ]]; then skip "csrf-cookie-httponly-absent: no $f — reads base.py only"
  elif ! cookie_has "$f" CSRF_COOKIE_HTTPONLY "$COOKIE_TRUE"; then
    fail csrf-cookie-httponly-absent "$f — no CSRF_COOKIE_HTTPONLY = True assignment"
  fi
  # Each __Host- name and the SECURE line it depends on, in the SAME module.
  for f in "$dir/staging.py" "$dir/production.py"; do
    [[ -f "$f" ]] || { skip "cookie-host-prefix-absent: no $f — reads staging.py and production.py only"; continue; }
    missing=""
    for kind in SESSION CSRF; do
      cookie_has "$f" "${kind}_COOKIE_NAME" "([\"'])__Host-[^\"']*\\1$COOKIE_EOL" || missing="$missing ${kind}_COOKIE_NAME=__Host-*"
      cookie_has "$f" "${kind}_COOKIE_SECURE" "$COOKIE_TRUE" || missing="$missing ${kind}_COOKIE_SECURE=True"
    done
    [[ -z "$missing" ]] || fail cookie-host-prefix-absent "$f — does not assign, in this module:$missing"
  done
  # Absence: no Domain at all, and no Path other than "/". Names the setting, never its value.
  while IFS= read -r hit; do
    [[ -n "$hit" ]] || continue
    fail cookie-scope-widened "${hit%%:*}:$(cut -d: -f2 <<< "$hit") — assigns $(cut -d: -f3- <<< "$hit" | grep -oE '^[A-Z_]+') (host-only means no Domain, Path \"/\")"
  done < <(find "$dir" -type f -name '*.py' -exec grep -nHE "^(SESSION|CSRF)_COOKIE_(DOMAIN|PATH)$COOKIE_SET" {} + |
    grep -vE "_PATH$COOKIE_SET([\"'])/\\1$COOKIE_EOL" | sort || true)
}

# The cookie half of --self-test, run after the broken/ and clean/ passes. CLEAN_SKIPS is the
# skip notes from the clean/ pass; BROKEN_BODY is the broken/ findings. Reports through st_fail.
cookie_self_test() {
  local clean_skips="$1" absent_body absent_skips pair clause module stray

  # Absent surface: the same tree with the settings directory pointed at nothing. Every
  # cookie clause must SKIP with a note naming what it read — never pass as clean, never fire.
  point_scopes_at "$FIXTURES_DIR/clean"
  # shellcheck disable=SC2034  # the caller's scope, read by run_all
  SETTINGS_DIR="$FIXTURES_DIR/clean/settings-absent"
  : > "$TMP_FAIL"; : > "$TMP_WARN"; SKIP_NOTES=""
  run_all
  absent_body="$(cat "$TMP_FAIL")"
  absent_skips="$SKIP_NOTES"

  # Each broken/settings/ module trips the clause it was written for, and is NAMED in that
  # finding: base.py (HttpOnly commented out), staging.py (a plain session name), production.py
  # (a __Host- name without its SECURE line, and a Domain), dev.py (a Path other than "/").
  for pair in "csrf-cookie-httponly-absent base.py" \
              "cookie-host-prefix-absent staging.py" \
              "cookie-host-prefix-absent production.py" \
              "cookie-scope-widened production.py" \
              "cookie-scope-widened dev.py"; do
    clause=${pair%% *}; module=${pair##* }
    printf '%s\n' "$BROKEN_BODY" | grep -E "^$clause: " | grep -qF -- "/settings/$module" ||
      st_fail "broken/settings/$module did not trip $clause, or the finding does not name it"
  done
  # test.py carries no cookie setting and must never be named, either way.
  if printf '%s\n' "$BROKEN_BODY" | grep -qF -- "/settings/test.py"; then
    st_fail "broken/settings/test.py was named — it carries no cookie setting"
  fi

  # Inertness: the new fixtures are input to every clause that walks *.py, so the eleven
  # pre-existing clauses must not name anything under settings/ (AC-GAP-9).
  stray=$(printf '%s\n' "$BROKEN_BODY" |
    grep -vE "^($(IFS='|'; printf '%s' "${COOKIE_CLAUSES[*]}")): " | grep -F -- "/settings/" || true)
  if [[ -n "$stray" ]]; then
    st_fail "settings/ fixtures tripped a clause they were not written for:" "$stray"
  fi

  for clause in "${COOKIE_CLAUSES[@]}"; do
    # On clean/ every cookie clause RAN — a skip there would make "trips none" vacuous.
    if printf '%s' "$clean_skips" | grep -qF -- "$clause"; then
      st_fail "$clause skipped on clean/ — it must run there, not report nothing"
    fi
    # With the directory absent it SKIPS, with a note, and finds nothing.
    printf '%s' "$absent_skips" | grep -qF -- "$clause" ||
      st_fail "$clause did not skip with a note when the settings directory is absent"
    if printf '%s\n' "$absent_body" | grep -qE "^$clause: "; then
      st_fail "$clause reported a finding over an absent settings directory"
    fi
  done
  # The presence clauses name the modules they read, so a third TLS module is visibly
  # unchecked rather than silently passing (AC-GAP-5).
  for pair in "csrf-cookie-httponly-absent base.py" \
              "cookie-host-prefix-absent staging.py" \
              "cookie-host-prefix-absent production.py"; do
    clause=${pair%% *}; module=${pair##* }
    printf '%s' "$absent_skips" | grep -F -- "$clause" | grep -qF -- "$module" ||
      st_fail "$clause's skip note does not name $module"
  done
}
