# shellcheck shell=bash
# negative-space-cookies.sh — the cookie doctrine half of audits/negative-space.sh (US008).
#
# Sourced by negative-space.sh, never run. It defines functions and constants only; nothing
# executes on source. It reads the caller's globals and helpers rather than taking its own:
#   SETTINGS_DIR (declared in the caller beside SETTINGS_FILE, repointed by point_scopes_at),
#   fail / skip, and under --self-test FIXTURES_DIR, TMP_FAIL, TMP_WARN, SKIP_NOTES,
#   BROKEN_BODY, point_scopes_at, run_all and st_fail.
#
# csrf-cookie-httponly-absent  base.py does not leave CSRF_COOKIE_HTTPONLY = True, or any
#                              module's last CSRF_COOKIE_HTTPONLY record is not True
# cookie-host-prefix-absent    a TLS module (staging.py, production.py — or staging/__init__.py,
#                              production/__init__.py when the module is a package — and any
#                              module that assigns SECURE_SSL_REDIRECT / *_COOKIE_SECURE = True)
#                              does not leave a __Host- SESSION_COOKIE_NAME or CSRF_COOKIE_NAME,
#                              or the SECURE = True line it depends on
# cookie-scope-widened         any *.py in the directory assigns a *_COOKIE_DOMAIN other than
#                              None, or a *_COOKIE_PATH other than "/"; and any *.py awk cannot
#                              read, which is "could not look", never clean
# Owner: code/docs/security/CRYPTO-AND-DATA.md, Browser Storage Policy. Scope: *.py under the
# directory, packages included (symlinks followed), never CONTEXT.md beside them.
#
# COOKIE_AWK reads one module and prints one record per occurrence of a cookie setting:
# `<line> <indented 0|1> <SETTING> <class>`, class one of true | none | root | host | aug |
# other | unrec. It reads the CODE part of each line (a trailing comment is cut, quote-aware;
# string contents, multi-line strings and docstrings included, are tracked across lines and
# ignored; a trailing CR is trimmed) and recognises plain, indented, annotated, chained and
# augmented assignments. It FAILS CLOSED: any other whole-token occurrence of a tracked name —
# a semicolon, unpacking, del, walrus, a loop or import target, a read — is an `unrec` record,
# which never satisfies presence and always counts as an override or a widened scope. There is
# no suppression annotation, by design. It never prints a value.
# TWIN: .copier/migrations/cookie-domain-conflict.sh carries this same program — change both.
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
    if (id !~ /^((SESSION|CSRF)_COOKIE_(DOMAIN|PATH|NAME|SECURE)|CSRF_COOKIE_HTTPONLY)$/) continue
    if (seen[id] > 0) seen[id]--; else print NR, ind, id, "unrec"
  }
}'
COOKIE_CLAUSES=(csrf-cookie-httponly-absent cookie-host-prefix-absent cookie-scope-widened)
# Scope-widening classes: a Domain other than None, a Path other than the root.
# shellcheck disable=SC2016  # awk, as above
COOKIE_WIDE='$3 ~ /_COOKIE_DOMAIN$/ && $4 != "none" || $3 ~ /_COOKIE_PATH$/ && $4 != "root"'

cookie_scan() { awk -v sq="'" "$COOKIE_AWK" "$1"; }
# Finding wording for a record that is not a recognised assignment.
COOKIE_UNREC="unrecognised occurrence (an assignment or a read the gate cannot evaluate)"
# cookie_state RECORDS SETTING CLASS — `ok` when the last record has CLASS and some column-0
# (unconditional) assignment has it too; `override:<line>` when the last does not, and
# `unrec:<line>` when that last record is an unrecognised occurrence; `absent` otherwise.
# The last record wins, at any indentation.
cookie_state() {
  awk -v n="$2" -v w="$3" '$3 == n { last = $1; cls = $4; if ($2 == 0 && $4 == w) root = 1 }
    END { if (last != "" && cls == "unrec") print "unrec:" last
          else if (last != "" && cls != w) print "override:" last
          else if (root) print "ok"; else print "absent" }' <<< "$1"
}

run_cookie_clauses() {
  local dir="$1" f kind missing st recs name want shown spec cls m
  local -a mods=() tls=()
  if [[ ! -d "$dir" ]]; then
    skip "csrf-cookie-httponly-absent: no $dir — reads base.py, and every *.py for overrides"
    skip "cookie-host-prefix-absent: no $dir — reads staging.py, production.py and any *.py turning on TLS"
    skip "cookie-scope-widened: no $dir — reads every *.py in it"
    return 0
  fi
  # A module awk cannot read is "could not look" (code/docs/GATE-REPORTING.md): a finding
  # naming it, never a silent pass, and it is read by no other clause.
  while IFS= read -r -d '' f; do
    if [[ -r "$f" ]] && cookie_scan "$f" > /dev/null 2>&1; then mods+=("$f")
    else fail cookie-scope-widened "$f — could not be read, so its cookie settings were not checked"; fi
  done < <(find -L "$dir" -type f -name '*.py' -print0 | sort -z)
  cookie_readable() { local x; for x in "${mods[@]}"; do [[ "$x" == "$1" ]] && return 0; done; return 1; }

  # HttpOnly: present unconditionally in base.py, and never left anything but True anywhere.
  f="$dir/base.py"
  if [[ ! -f "$f" ]]; then skip "csrf-cookie-httponly-absent: no $f — reads base.py for presence"
  elif cookie_readable "$f"; then
    st=$(cookie_state "$(cookie_scan "$f")" CSRF_COOKIE_HTTPONLY true)
    [[ "$st" != absent ]] || fail csrf-cookie-httponly-absent "$f — no CSRF_COOKIE_HTTPONLY = True assignment"
  fi
  for f in "${mods[@]}"; do
    st=""; cls=""; read -r st cls < <(awk '$3 == "CSRF_COOKIE_HTTPONLY" { l = $1; c = $4 } END { if (l != "" && c != "true") print l, c }' <<< "$(cookie_scan "$f")") || true
    [[ -n "$st" ]] || continue
    if [[ "$cls" == unrec ]]; then fail csrf-cookie-httponly-absent "$f:$st — the last CSRF_COOKIE_HTTPONLY record is an $COOKIE_UNREC"
    else fail csrf-cookie-httponly-absent "$f:$st — the last CSRF_COOKIE_HTTPONLY assignment is not True"; fi
  done

  # __Host- names and the SECURE lines they depend on, each in the SAME module, in every TLS
  # module. staging and production may be packages: <name>/__init__.py stands in for <name>.py.
  local -a named=()
  for m in staging production; do
    if [[ -f "$dir/$m.py" ]]; then f="$dir/$m.py"
    elif [[ -f "$dir/$m/__init__.py" ]]; then f="$dir/$m/__init__.py"
    else skip "cookie-host-prefix-absent: no $dir/$m.py (or $m/__init__.py) — reads staging.py, production.py and any *.py turning on TLS"; continue; fi
    named+=("$f"); cookie_readable "$f" && tls+=("$f")
  done
  for f in "${mods[@]}"; do
    [[ " ${named[*]} " == *" $f "* ]] && continue
    awk '$3 ~ /^(SECURE_SSL_REDIRECT|(SESSION|CSRF)_COOKIE_SECURE)$/ && $4 == "true" { hit = 1 } END { exit !hit }' \
      <<< "$(cookie_scan "$f")" && tls+=("$f")
  done
  for f in "${tls[@]}"; do
    recs=$(cookie_scan "$f"); missing=""
    for kind in SESSION CSRF; do
      for spec in "${kind}_COOKIE_NAME host __Host-*" "${kind}_COOKIE_SECURE true True"; do
        read -r name want shown <<< "$spec"
        st=$(cookie_state "$recs" "$name" "$want")
        case "$st" in
          absent) missing="$missing $name=$shown" ;;
          override:*) missing="$missing $name=$shown (overridden at line ${st#override:})" ;;
          unrec:*) missing="$missing $name=$shown (overridden by an $COOKIE_UNREC at line ${st#unrec:})" ;;
        esac
      done
    done
    [[ -z "$missing" ]] || fail cookie-host-prefix-absent "$f — does not leave, in this module (the last assignment wins):$missing"
  done

  # Absence: no Domain at all, and no Path other than "/". Names the setting, never its value.
  for f in "${mods[@]}"; do
    while read -r st name cls; do
      [[ -n "$st" ]] || continue
      if [[ "$cls" == unrec ]]; then
        fail cookie-scope-widened "$f:$st — an $COOKIE_UNREC of $name (host-only means no Domain, Path \"/\")"
      else
        fail cookie-scope-widened "$f:$st — assigns $name (host-only means no Domain, Path \"/\")"
      fi
    done < <(awk "$COOKIE_WIDE"' { print $1, $3, $4 }' <<< "$(cookie_scan "$f")")
  done
}

# The cookie half of --self-test, run after the broken/ and clean/ passes. CLEAN_SKIPS is the
# skip notes from the clean/ pass; BROKEN_BODY is the broken/ findings. Reports through st_fail.
cookie_self_test() {
  local clean_skips="$1" absent_body absent_skips pair clause module stray
  COOKIE_TMP=$(mktemp -d)

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

  cookie_self_test_bypasses
}

# ── The review bypasses (16/11/2026) ─────────────────────────────────────────
# Every expectation below names the MODULE and the SETTING, never the clause alone: a clause
# that still fires for one combination proves nothing about the next, which is how a loop
# narrowed to SESSION passed the original assertions. Variant trees are copies of
# clean/settings/ with one module rewritten, built in COOKIE_TMP (removed by the caller's
# EXIT trap), so each combination trips on its own. Values never reach a message.

# The findings of the cookie clauses alone over one settings directory.
cookie_findings() {
  : > "$TMP_FAIL"; SKIP_NOTES=""
  run_cookie_clauses "$1"
  cat "$TMP_FAIL"
}

# A copy of clean/settings/ under COOKIE_TMP/<case>/settings; prints its path.
cookie_variant() {
  local dir="$COOKIE_TMP/$1/settings"
  mkdir -p "$dir"
  cp -R "$FIXTURES_DIR/clean/settings/." "$dir/"
  printf '%s\n' "$dir"
}

# cookie_expect BODY CLAUSE MODULE SETTING LABEL — a CLAUSE finding of the shape
# `<path>/settings/MODULE[:line] — …SETTING…` must be in BODY.
cookie_expect() {
  local re
  re=$(printf '%s' "$3" | sed 's/[.[\*^$+?(){}|]/\\&/g')
  printf '%s\n' "$1" | grep -E "^$2: .*/settings/$re(:[0-9]+)? — " | grep -qF -- "$4" ||
    st_fail "$5: expected $2 naming $3 and $4"
}

# cookie_expect_none BODY MODULE LABEL — no finding of any clause names MODULE.
cookie_expect_none() {
  if printf '%s\n' "$1" | grep -qE -- "/settings/$2(:[0-9]+)? — "; then
    st_fail "$3: $2 was named, and it is not a finding"
  fi
}

cookie_self_test_bypasses() {
  local broken clean
  broken=$(cookie_findings "$FIXTURES_DIR/broken/settings")
  clean=$(cookie_findings "$FIXTURES_DIR/clean/settings")

  # QA-01: a trailing comment quoting a root Path hides neither a Domain nor a non-root Path.
  cookie_expect "$broken" cookie-scope-widened scope_comment.py SESSION_COOKIE_DOMAIN "QA-01 Domain line with a root-Path comment"
  cookie_expect "$broken" cookie-scope-widened scope_comment.py CSRF_COOKIE_PATH "QA-01 non-root Path line with a root-Path comment"
  # QA-03: all four scope combinations, each planted plainly in some module.
  cookie_expect "$broken" cookie-scope-widened production.py SESSION_COOKIE_DOMAIN "QA-03 SESSION_COOKIE_DOMAIN"
  cookie_expect "$broken" cookie-scope-widened dev.py CSRF_COOKIE_PATH "QA-03 CSRF_COOKIE_PATH non-root"
  cookie_expect "$broken" cookie-scope-widened scope_plain.py CSRF_COOKIE_DOMAIN "QA-03 CSRF_COOKIE_DOMAIN"
  cookie_expect "$broken" cookie-scope-widened scope_plain.py SESSION_COOKIE_PATH "QA-03 SESSION_COOKIE_PATH non-root"
  # R1 / QA-04: an indented (conditional) assignment widens the scope all the same.
  cookie_expect "$broken" cookie-scope-widened scope_indented.py CSRF_COOKIE_DOMAIN "R1 indented Domain"
  cookie_expect "$broken" cookie-scope-widened scope_indented.py SESSION_COOKIE_PATH "R1 indented non-root Path"
  # QA-05: annotated, chained and augmented assignments.
  cookie_expect "$broken" cookie-scope-widened scope_forms.py SESSION_COOKIE_DOMAIN "QA-05 annotated Domain"
  cookie_expect "$broken" cookie-scope-widened scope_forms.py CSRF_COOKIE_DOMAIN "QA-05 chained Domain"
  cookie_expect "$broken" cookie-scope-widened scope_forms.py SESSION_COOKIE_PATH "QA-05 augmented Path"
  # R3: a third module that turns on TLS-only settings is read by the presence clause.
  cookie_expect "$broken" cookie-host-prefix-absent uat.py SESSION_COOKIE_NAME "R3 uat.py (SECURE_SSL_REDIRECT) plain session name"
  cookie_expect "$broken" cookie-host-prefix-absent uat.py CSRF_COOKIE_NAME "R3 uat.py (SECURE_SSL_REDIRECT) plain CSRF name"
  # QA-06: Domain None and a raw-string root Path are host-only.
  cookie_expect_none "$clean" host_only.py "QA-06 SESSION_COOKIE_DOMAIN = None / SESSION_COOKIE_PATH = r\"/\""
  if printf '%s\n' "$broken" | grep -qF -- '.example.com'; then
    st_fail "a cookie finding printed a setting's value"
  fi

  cookie_self_test_variants
  cookie_self_test_fallback
  cookie_self_test_surfaces
  cookie_self_test_tls_discovery
  cookie_self_test_parity
}

# Variant trees: clean/settings/ with exactly one module rewritten (or added), so whatever is
# reported comes from that module alone. Only the cookie lines are under test.
cookie_self_test_variants() {
  local dir body
  local host='SESSION_COOKIE_SECURE = True\nCSRF_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "__Host-sessionid"\nCSRF_COOKIE_NAME = "__Host-csrftoken"\n'

  # QA-03: each presence combination in staging.py, the rest of the module compliant.
  dir=$(cookie_variant plain-csrf-name)
  printf 'SESSION_COOKIE_SECURE = True\nCSRF_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "__Host-sessionid"\nCSRF_COOKIE_NAME = "csrftoken"\n' > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py CSRF_COOKIE_NAME "QA-03 plain CSRF name"
  dir=$(cookie_variant no-csrf-secure)
  printf 'SESSION_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "__Host-sessionid"\nCSRF_COOKIE_NAME = "__Host-csrftoken"\n' > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py CSRF_COOKIE_SECURE "QA-03 missing CSRF_COOKIE_SECURE"
  dir=$(cookie_variant conditional-name)
  printf 'SESSION_COOKIE_SECURE = True\nCSRF_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "__Host-sessionid" if ON_TLS else "sessionid"\nCSRF_COOKIE_NAME = "__Host-csrftoken"\n' > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py SESSION_COOKIE_NAME "QA-03 conditional __Host- name"

  # QA-02 / R4: the last assignment wins, in any module and at any indentation.
  dir=$(cookie_variant httponly-override-base)
  printf '%s\n' 'CSRF_COOKIE_HTTPONLY = True' 'CSRF_COOKIE_HTTPONLY = False' > "$dir/base.py"
  cookie_expect "$(cookie_findings "$dir")" csrf-cookie-httponly-absent base.py CSRF_COOKIE_HTTPONLY "QA-02 later CSRF_COOKIE_HTTPONLY = False in base.py"
  dir=$(cookie_variant httponly-override-elsewhere)
  printf '%s\n' 'CSRF_COOKIE_HTTPONLY = False' >> "$dir/production.py"
  cookie_expect "$(cookie_findings "$dir")" csrf-cookie-httponly-absent production.py CSRF_COOKIE_HTTPONLY "QA-02 CSRF_COOKIE_HTTPONLY = False in another settings module"
  dir=$(cookie_variant name-override)
  printf '%bSESSION_COOKIE_NAME = "sessionid"\n' "$host" > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py SESSION_COOKIE_NAME "QA-02 later plain SESSION_COOKIE_NAME"
  dir=$(cookie_variant secure-override)
  printf '%bCSRF_COOKIE_SECURE = False\n' "$host" > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py CSRF_COOKIE_SECURE "QA-02 later CSRF_COOKIE_SECURE = False"
  dir=$(cookie_variant indented-override)
  printf '%bif ON_TLS:\n    SESSION_COOKIE_NAME = "sessionid"\n' "$host" > "$dir/production.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent production.py SESSION_COOKIE_NAME "R1 indented plain SESSION_COOKIE_NAME override"
  # ...and the guards on the other side: a later compliant line wins, an indented compliant
  # line alone is not unconditional presence.
  dir=$(cookie_variant compliant-last)
  printf 'SESSION_COOKIE_NAME = "sessionid"\n%b' "$host" > "$dir/staging.py"
  body=$(cookie_findings "$dir")
  cookie_expect_none "$body" staging.py "QA-02 an earlier plain name overridden by a later __Host- name"
  dir=$(cookie_variant indented-only)
  printf 'SESSION_COOKIE_SECURE = True\nCSRF_COOKIE_SECURE = True\nCSRF_COOKIE_NAME = "__Host-csrftoken"\nif ON_TLS:\n    SESSION_COOKIE_NAME = "__Host-sessionid"\n' > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py SESSION_COOKIE_NAME "R1 an indented __Host- name alone is not presence"

  # R3: a module turned TLS by SESSION_COOKIE_SECURE alone, with plain names.
  dir=$(cookie_variant tls-by-secure)
  printf 'SESSION_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "sessionid"\n' > "$dir/preview.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent preview.py SESSION_COOKIE_NAME "R3 preview.py (SESSION_COOKIE_SECURE) plain session name"

  # QA-05: a symlinked settings module, its target outside the directory.
  dir=$(cookie_variant symlinked)
  mkdir -p "$COOKIE_TMP/symlinked/shared"
  printf 'SESSION_COOKIE_DOMAIN = ".example.com"\n' > "$COOKIE_TMP/symlinked/shared/cookies.py"
  ln -s "$COOKIE_TMP/symlinked/shared/cookies.py" "$dir/linked.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-scope-widened linked.py SESSION_COOKIE_DOMAIN "QA-05 symlinked module"
  # QA-06: a colon in the module name still yields a `file — setting` finding.
  dir=$(cookie_variant colon-name)
  printf '\nCSRF_COOKIE_DOMAIN = ".example.com"\n' > "$dir/cookie:scope.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-scope-widened cookie:scope.py CSRF_COOKIE_DOMAIN "QA-06 module name with a colon"
}

# ── The delta review, round 2 (16/11/2026) ───────────────────────────────────
# QA2-01 / QA2-02: the scanner fails CLOSED. A tracked setting name in the code part of a
# line (comment cut, string contents ignored) that it did not read as a recognised
# assignment becomes an unrecognised (`other`) record, so a binding the parser cannot
# follow still trips the clause it would breach. A READ is such an occurrence too, and fires.
cookie_self_test_fallback() {
  local dir body clean pair module setting
  local host='SESSION_COOKIE_SECURE = True\nCSRF_COOKIE_SECURE = True\nSESSION_COOKIE_NAME = "__Host-sessionid"\nCSRF_COOKIE_NAME = "__Host-csrftoken"\n'

  dir=$(cookie_variant semicolon)
  printf '%s\n' 'DEBUG = False; CSRF_COOKIE_HTTPONLY = False' >> "$dir/base.py"
  cookie_expect "$(cookie_findings "$dir")" csrf-cookie-httponly-absent base.py CSRF_COOKIE_HTTPONLY "QA2-01 CSRF_COOKIE_HTTPONLY = False after a semicolon"
  dir=$(cookie_variant unpack-domain)
  printf '%s\n' 'SESSION_COOKIE_DOMAIN, X = ".example.com", 1' > "$dir/unpack.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-scope-widened unpack.py SESSION_COOKIE_DOMAIN "QA2-01 tuple-unpacked Domain"
  dir=$(cookie_variant unpack-name)
  printf '%bSESSION_COOKIE_NAME, _u = "sessionid", None\n' "$host" > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py SESSION_COOKIE_NAME "QA2-01 tuple-unpacked plain SESSION_COOKIE_NAME"
  dir=$(cookie_variant del-name)
  printf '%bdel CSRF_COOKIE_NAME\n' "$host" > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py CSRF_COOKIE_NAME "QA2-01 del CSRF_COOKIE_NAME after the __Host- name"
  # A read is an unrecognised occurrence, and fails closed (the rule as ruled, 16/11/2026).
  dir=$(cookie_variant read-secure)
  printf '%bX = SESSION_COOKIE_SECURE\n' "$host" > "$dir/staging.py"
  cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent staging.py SESSION_COOKIE_SECURE "QA2-01 a read of SESSION_COOKIE_SECURE after its assignment"
  dir=$(cookie_variant read-httponly)
  printf '%s\n' 'if CSRF_COOKIE_HTTPONLY:' '    pass' >> "$dir/base.py"
  cookie_expect "$(cookie_findings "$dir")" csrf-cookie-httponly-absent base.py CSRF_COOKIE_HTTPONLY "QA2-01 a read of CSRF_COOKIE_HTTPONLY in a condition"
  # ...and the guard: a name only inside a string (one line or several) or a comment, or
  # inside a longer identifier, is not an occurrence (clean/settings/mentions.py).
  clean=$(cookie_findings "$FIXTURES_DIR/clean/settings")
  cookie_expect_none "$clean" mentions.py "QA2-01 setting names only in strings, docstrings, comments and longer identifiers"

  # QA2-02: binding forms the assignment parser does not follow, one module each.
  dir=$(cookie_variant forms-round2)
  printf '%s\n' '(SESSION_COOKIE_DOMAIN := ".example.com")' > "$dir/walrus.py"
  printf '%s\n' '(SESSION_COOKIE_DOMAIN) = ".example.com"' > "$dir/paren.py"
  printf '%s\n' 'for SESSION_COOKIE_PATH in ["/app"]: pass' > "$dir/loop.py"
  printf '%s\n' 'from x import y as CSRF_COOKIE_DOMAIN' > "$dir/alias.py"
  printf '%s\n' 'd = {}' 'd["k"] = SESSION_COOKIE_DOMAIN = ".example.com"' > "$dir/subscript.py"
  printf '\f    SESSION_COOKIE_DOMAIN = ".example.com"\n' > "$dir/formfeed.py"
  body=$(cookie_findings "$dir")
  for pair in "walrus.py SESSION_COOKIE_DOMAIN" "paren.py SESSION_COOKIE_DOMAIN" \
              "loop.py SESSION_COOKIE_PATH" "alias.py CSRF_COOKIE_DOMAIN" \
              "subscript.py SESSION_COOKIE_DOMAIN" "formfeed.py SESSION_COOKIE_DOMAIN"; do
    read -r module setting <<< "$pair"
    cookie_expect "$body" cookie-scope-widened "$module" "$setting" "QA2-02 ${module%.py} binding"
  done

  # QA2-03 (b): the compliant spellings in clean/settings/spellings.py stay clean.
  cookie_expect_none "$clean" spellings.py "QA2-03 single quotes, trailing comments and a hash inside a string on compliant lines"
}

# QA2-04..06: module surfaces the scanner reads wrongly — unreadable, a package, CRLF.
cookie_self_test_surfaces() {
  local dir body proj out rc module
  local migration="$PWD/.copier/migrations/cookie-domain-conflict.sh"

  # QA2-04: an unreadable module is "could not look", never clean (code/docs/GATE-REPORTING.md).
  if [[ "$(id -u)" -eq 0 ]]; then
    printf '%s\n' "  · QA2-04: skipped — running as root, where chmod 000 cannot deny a read; an unreadable module was not measured"
  else
    dir=$(cookie_variant unreadable)
    printf '%s\n' 'SESSION_COOKIE_DOMAIN = ".example.com"' > "$dir/locked.py"
    chmod 000 "$dir/locked.py"
    body=$(cookie_findings "$dir" 2>/dev/null)
    printf '%s\n' "$body" | grep -E "^($(IFS='|'; printf '%s' "${COOKIE_CLAUSES[*]}")): .*/settings/locked\.py(:[0-9]+)? — " |
      grep -qiE 'could not (be )?read' ||
      st_fail "QA2-04 an unreadable settings module read as clean: expected a cookie finding naming locked.py that says it could not be read"
    if [[ -f "$migration" ]]; then
      proj="$COOKIE_TMP/unreadable-proj"
      mkdir -p "$proj/code/src/django/config/settings"
      cp -R "$FIXTURES_DIR/clean/settings/." "$proj/code/src/django/config/settings/"
      printf '%s\n' 'SESSION_COOKIE_DOMAIN = ".example.com"' > "$proj/code/src/django/config/settings/locked.py"
      chmod 000 "$proj/code/src/django/config/settings/locked.py"
      rc=0; out=$(cd "$proj" && bash "$migration" 2>&1) || rc=$?
      [[ "$rc" -eq 0 ]] || st_fail "QA2-04 the migration exited $rc over an unreadable module — it is advisory and must exit 0"
      printf '%s\n' "$out" | grep -iE 'could not (be )?read' | grep -qF -- "locked.py" ||
        st_fail "QA2-04 the migration was silent about an unreadable module: expected a line naming locked.py that says it could not be read"
    else
      printf '%s\n' "  · QA2-04 migration half: skipped — .copier/migrations/cookie-domain-conflict.sh is absent (a generated project)"
    fi
  fi

  # QA2-05: a staging/ or production/ PACKAGE is the TLS module when no staging.py is there.
  for module in staging production; do
    dir=$(cookie_variant "$module-package")
    rm -f "$dir/$module.py"; mkdir -p "$dir/$module"
    printf '%s\n' 'SESSION_COOKIE_NAME = "sessionid"' 'CSRF_COOKIE_NAME = "csrftoken"' > "$dir/$module/__init__.py"
    body=$(cookie_findings "$dir")
    cookie_expect "$body" cookie-host-prefix-absent "$module/__init__.py" SESSION_COOKIE_NAME "QA2-05 $module/__init__.py package, plain session name"
    cookie_expect "$body" cookie-host-prefix-absent "$module/__init__.py" CSRF_COOKIE_NAME "QA2-05 $module/__init__.py package, plain CSRF name"
  done

  # QA2-06: CRLF line endings on a compliant tree change nothing. Built here, never committed.
  dir=$(cookie_variant crlf)
  for module in "$dir"/*.py; do
    awk '{ printf "%s\r\n", $0 }' "$module" > "$module.crlf" && mv "$module.crlf" "$module"
  done
  body=$(cookie_findings "$dir")
  for module in base.py staging.py production.py host_only.py spellings.py; do
    cookie_expect_none "$body" "$module" "QA2-06 CRLF-terminated compliant $module"
  done
}

# ── The final review, round 3 (16/11/2026) ───────────────────────────────────
# QA3-01 (ruled 16/11/2026: fix, fail closed): TLS-module discovery must not need a
# RECOGNISED `= True`. Any unrecognised occurrence of SECURE_SSL_REDIRECT,
# SESSION_COOKIE_SECURE or CSRF_COOKIE_SECURE makes a module a TLS module, held to
# cookie-host-prefix-absent. R3-06: the augmented-assignment flag is pinned on a root-looking
# right-hand side, where only the flag stands between it and a pass.
cookie_self_test_tls_discovery() {
  local dir body pair module label
  local plain='SESSION_COOKIE_NAME = "sessionid"\nCSRF_COOKIE_NAME = "csrftoken"\n'

  # QA3-01: one variant per trigger form, each a third module with plain names.
  for pair in "semi-redirect|X = 1; SECURE_SSL_REDIRECT = True|SECURE_SSL_REDIRECT after a semicolon" \
              "semi-secure|X = 1; SESSION_COOKIE_SECURE = True|SESSION_COOKIE_SECURE after a semicolon" \
              "unpack-secure|SESSION_COOKIE_SECURE, CSRF_COOKIE_SECURE = True, True|tuple-unpacked *_COOKIE_SECURE" \
              "chain-redirect|A = SECURE_SSL_REDIRECT = (True)|chained SECURE_SSL_REDIRECT = (True)"; do
    IFS='|' read -r module body label <<< "$pair"
    dir=$(cookie_variant "tls-$module")
    printf '%s\n%b' "$body" "$plain" > "$dir/uat.py"
    cookie_expect "$(cookie_findings "$dir")" cookie-host-prefix-absent uat.py SESSION_COOKIE_NAME \
      "QA3-01 uat.py turned TLS by $label, plain session name"
  done
  # ...and the guard: no TLS trigger at all, or a recognised non-True SECURE line, is not TLS.
  dir=$(cookie_variant tls-none)
  printf 'DEBUG = True\n%b' "$plain" > "$dir/devlike.py"
  printf 'SESSION_COOKIE_SECURE = False\n%b' "$plain" > "$dir/devsecure.py"
  body=$(cookie_findings "$dir")
  cookie_expect_none "$body" devlike.py "QA3-01 guard: plain names with no TLS trigger"
  cookie_expect_none "$body" devsecure.py "QA3-01 guard: plain names beside a recognised SESSION_COOKIE_SECURE = False"

  # R3-06: augmented assignments are findings even when the operand looks compliant.
  dir=$(cookie_variant aug-root)
  printf '%s\n' 'SESSION_COOKIE_PATH += "/"' > "$dir/augpath.py"
  printf '%s\n' 'CSRF_COOKIE_HTTPONLY |= True' >> "$dir/base.py"
  body=$(cookie_findings "$dir")
  cookie_expect "$body" cookie-scope-widened augpath.py SESSION_COOKIE_PATH "R3-06 SESSION_COOKIE_PATH += a root Path"
  cookie_expect "$body" csrf-cookie-httponly-absent base.py CSRF_COOKIE_HTTPONLY "R3-06 CSRF_COOKIE_HTTPONLY |= True"
}

# The scanner's text in FILE: the COOKIE_AWK block (its opening line to the line `}'`) and the
# COOKIE_WIDE line. The gate and the migration must carry these byte-identical (QA2-03).
cookie_twin_text() {
  awk -v sq="'" 'index($0, "COOKIE_AWK=" sq) == 1 { on = 1 }
    on { print } on && $0 == "}" sq { on = 0 }
    index($0, "COOKIE_WIDE=") == 1 { print }' "$1"
}

# (module, setting) pairs, sorted, one per line: from the gate's scope findings, and from the
# copier migration's report.
cookie_gate_pairs() {
  printf '%s\n' "$1" | { grep -E '^cookie-scope-widened: ' || true; } | while IFS= read -r line; do
    local path="${line#cookie-scope-widened: }"; path="${path%% — *}"; path="${path%:[0-9]*}"
    printf '%s %s\n' "${path##*/}" "$(grep -oE '(SESSION|CSRF)_COOKIE_(DOMAIN|PATH)' <<< "${line#* — }" | head -1)"
  done | sort
}
cookie_migration_pairs() {
  sed -nE 's/^    (.*):[0-9]+  ((SESSION|CSRF)_COOKIE_(DOMAIN|PATH))$/\1 \2/p' <<< "$1" |
    while read -r path setting; do printf '%s %s\n' "${path##*/}" "$setting"; done | sort
}

# Parity (Q11): the copier migration reports exactly what cookie-scope-widened reports. It
# lives in .copier/, which generation removes — absent, the check is SKIPPED with a note.
cookie_self_test_parity() {
  local migration="$PWD/.copier/migrations/cookie-domain-conflict.sh" tree proj gate mig out rc
  if [[ ! -f "$migration" ]]; then
    printf '%s\n' "  · parity: skipped — .copier/migrations/cookie-domain-conflict.sh is absent (a generated project); gate/migration agreement was not measured"
    return 0
  fi
  # Text parity (QA2-03): behaviour on two fixture trees cannot see a twin that differs only
  # on input neither tree holds, so the program text itself is compared, byte for byte.
  gate=$(cookie_twin_text "${BASH_SOURCE[0]}"); mig=$(cookie_twin_text "$migration")
  if [[ -z "$gate" || -z "$mig" ]]; then
    st_fail "text parity: COOKIE_AWK/COOKIE_WIDE could not be extracted from the gate or the migration — the twins were not compared"
  elif [[ "$gate" != "$mig" ]]; then
    st_fail "text parity: COOKIE_AWK/COOKIE_WIDE differ between the gate and the migration (< gate, > migration)" \
      "$(diff <(printf '%s\n' "$gate") <(printf '%s\n' "$mig") | grep -E '^[<>]' | head -5 || true)"
  fi
  for tree in broken clean; do
    proj="$COOKIE_TMP/parity-$tree"
    mkdir -p "$proj/code/src/django/config/settings"
    cp -R "$FIXTURES_DIR/$tree/settings/." "$proj/code/src/django/config/settings/"
    gate=$(cookie_gate_pairs "$(cookie_findings "$proj/code/src/django/config/settings")")
    # QA3-05: the migration is advisory — exit 0 on the clean path and the findings path alike.
    rc=0; out=$(cd "$proj" && bash "$migration" 2>&1) || rc=$?
    [[ "$rc" -eq 0 ]] || st_fail "QA3-05 the migration exited $rc on $tree/settings — it is advisory and must exit 0"
    mig=$(cookie_migration_pairs "$out")
    if [[ "$gate" != "$mig" ]]; then
      st_fail "parity on $tree/settings: the migration and cookie-scope-widened disagree (< gate, > migration)" \
        "$(diff <(printf '%s\n' "$gate") <(printf '%s\n' "$mig") | grep -E '^[<>]' || true)"
    fi
    if [[ "$tree" == clean && -n "$mig" ]]; then
      st_fail "parity on clean/settings: the migration reported a setting" "$mig"
    fi
  done
}
