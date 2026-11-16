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
#                              module's last CSRF_COOKIE_HTTPONLY assignment is not True
# cookie-host-prefix-absent    a TLS module (staging.py, production.py, and any module that
#                              assigns SECURE_SSL_REDIRECT / *_COOKIE_SECURE = True) does not
#                              leave a __Host- SESSION_COOKIE_NAME or CSRF_COOKIE_NAME, or the
#                              SECURE = True line it depends on
# cookie-scope-widened         any *.py in the directory assigns a *_COOKIE_DOMAIN other than
#                              None, or a *_COOKIE_PATH other than "/"
# Owner: code/docs/security/CRYPTO-AND-DATA.md, Browser Storage Policy. Scope: *.py in the
# directory (symlinks followed), never CONTEXT.md beside them.
#
# COOKIE_AWK reads one module and prints one record per assignment of a cookie setting:
# `<line> <indented 0|1> <SETTING> <class>`, class one of true | none | root | host | aug |
# other. It reads the CODE part of the line (a trailing comment is cut, quote-aware), and sees
# plain, indented, annotated, chained and augmented assignments. It never prints a value.
# TWIN: .copier/migrations/cookie-domain-conflict.sh carries this same program — change both.
# shellcheck disable=SC2016  # an awk program: its $ fields are awk's, never the shell's
COOKIE_AWK='
function strip(s,   i, c, q, out) {
  q = ""; out = ""
  for (i = 1; i <= length(s); i++) {
    c = substr(s, i, 1)
    if (q != "") { if (c == "\\") { out = out c substr(s, i + 1, 1); i++; continue } if (c == q) q = "" }
    else if (c == "#") break
    else if (c == "\"" || c == sq) q = c
    out = out c
  }
  return out
}
function classify(v) {
  if (v == "True") return "true"
  if (v == "None") return "none"
  if (v ~ ("^[rRuU]?(\"/\"|" sq "/" sq ")$")) return "root"
  if (v ~ ("^[rRuU]?(\"__Host-[^\"" sq "]*\"|" sq "__Host-[^\"" sq "]*" sq ")$")) return "host"
  return "other"
}
{
  s = strip($0); ind = (s ~ /^[ \t]/) ? 1 : 0; sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s)
  n = 0; aug = 0
  while (match(s, /^[A-Za-z_][A-Za-z0-9_]*/)) {
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
    if (t[i] ~ /^((SESSION|CSRF)_COOKIE_(DOMAIN|PATH|NAME|SECURE|HTTPONLY)|SECURE_SSL_REDIRECT)$/)
      print NR, ind, t[i], cls
}'
COOKIE_CLAUSES=(csrf-cookie-httponly-absent cookie-host-prefix-absent cookie-scope-widened)
# Scope-widening classes: a Domain other than None, a Path other than the root.
# shellcheck disable=SC2016  # awk, as above
COOKIE_WIDE='$3 ~ /_COOKIE_DOMAIN$/ && $4 != "none" || $3 ~ /_COOKIE_PATH$/ && $4 != "root"'

cookie_scan() { awk -v sq="'" "$COOKIE_AWK" "$1"; }
# cookie_state RECORDS SETTING CLASS — `ok` when the last assignment has CLASS and some
# column-0 (unconditional) assignment has it too; `override:<line>` when the last does not;
# `absent` otherwise. The last assignment wins, at any indentation.
cookie_state() {
  awk -v n="$2" -v w="$3" '$3 == n { last = $1; cls = $4; if ($2 == 0 && $4 == w) root = 1 }
    END { if (last != "" && cls != w) print "override:" last; else if (root) print "ok"; else print "absent" }' <<< "$1"
}

run_cookie_clauses() {
  local dir="$1" f kind missing st recs name want shown spec
  local -a mods=() tls=()
  if [[ ! -d "$dir" ]]; then
    skip "csrf-cookie-httponly-absent: no $dir — reads base.py, and every *.py for overrides"
    skip "cookie-host-prefix-absent: no $dir — reads staging.py, production.py and any *.py turning on TLS"
    skip "cookie-scope-widened: no $dir — reads every *.py in it"
    return 0
  fi
  while IFS= read -r -d '' f; do mods+=("$f"); done < <(find -L "$dir" -type f -name '*.py' -print0 | sort -z)

  # HttpOnly: present unconditionally in base.py, and never left anything but True anywhere.
  f="$dir/base.py"
  if [[ ! -f "$f" ]]; then skip "csrf-cookie-httponly-absent: no $f — reads base.py for presence"
  else
    st=$(cookie_state "$(cookie_scan "$f")" CSRF_COOKIE_HTTPONLY true)
    [[ "$st" != absent ]] || fail csrf-cookie-httponly-absent "$f — no CSRF_COOKIE_HTTPONLY = True assignment"
  fi
  for f in "${mods[@]}"; do
    st=$(awk '$3 == "CSRF_COOKIE_HTTPONLY" { l = $1; c = $4 } END { if (l != "" && c != "true") print l }' <<< "$(cookie_scan "$f")")
    [[ -z "$st" ]] || fail csrf-cookie-httponly-absent "$f:$st — the last CSRF_COOKIE_HTTPONLY assignment is not True"
  done

  # __Host- names and the SECURE lines they depend on, each in the SAME module, in every TLS module.
  for f in "$dir/staging.py" "$dir/production.py"; do
    if [[ -f "$f" ]]; then tls+=("$f"); else skip "cookie-host-prefix-absent: no $f — reads staging.py, production.py and any *.py turning on TLS"; fi
  done
  for f in "${mods[@]}"; do
    [[ "$f" == "$dir/staging.py" || "$f" == "$dir/production.py" ]] && continue
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
        esac
      done
    done
    [[ -z "$missing" ]] || fail cookie-host-prefix-absent "$f — does not leave, in this module (the last assignment wins):$missing"
  done

  # Absence: no Domain at all, and no Path other than "/". Names the setting, never its value.
  for f in "${mods[@]}"; do
    while read -r st name; do
      [[ -n "$st" ]] || continue
      fail cookie-scope-widened "$f:$st — assigns $name (host-only means no Domain, Path \"/\")"
    done < <(awk "$COOKIE_WIDE"' { print $1, $3 }' <<< "$(cookie_scan "$f")")
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
  local migration="$PWD/.copier/migrations/cookie-domain-conflict.sh" tree proj gate mig
  if [[ ! -f "$migration" ]]; then
    printf '%s\n' "  · parity: skipped — .copier/migrations/cookie-domain-conflict.sh is absent (a generated project); gate/migration agreement was not measured"
    return 0
  fi
  for tree in broken clean; do
    proj="$COOKIE_TMP/parity-$tree"
    mkdir -p "$proj/code/src/django/config/settings"
    cp -R "$FIXTURES_DIR/$tree/settings/." "$proj/code/src/django/config/settings/"
    gate=$(cookie_gate_pairs "$(cookie_findings "$proj/code/src/django/config/settings")")
    mig=$(cookie_migration_pairs "$(cd "$proj" && bash "$migration" 2>&1)")
    if [[ "$gate" != "$mig" ]]; then
      st_fail "parity on $tree/settings: the migration and cookie-scope-widened disagree (< gate, > migration)" \
        "$(diff <(printf '%s\n' "$gate") <(printf '%s\n' "$mig") | grep -E '^[<>]' || true)"
    fi
    if [[ "$tree" == clean && -n "$mig" ]]; then
      st_fail "parity on clean/settings: the migration reported a setting" "$mig"
    fi
  done
}
