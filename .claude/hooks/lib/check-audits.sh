# check-audits.sh — the template's own gate: every audit, plus the shipped-file checks.
#
# TEMPLATE MODE ONLY. In a generated project the eight application checks are the
# gate and this one does not run; in syntek-base itself the application checks
# have no subject and THIS is the substantive gate —
# the template's product is its structure, its routing and its documentation, and
# that is exactly what these scripts read.
#
# ── Two scopes, each a directory minus a declared, self-verifying exclusion ────
#
# Each scope is a directory. A few scripts are named out of each, and the case arm
# that used to do it silently is now a declared list with a guard, because the
# doctrine beside it and the code under it said different things and only one of
# them could be true.
#
# What that doctrine actually bans is a list deciding what RUNS. It does not ban
# recording what is deliberately left out, and the two drift in opposite
# directions:
#
#   An INCLUSION list drifts silently and dangerously — a script added tomorrow
#   is absent from it, never runs, and a gate that never ran is indistinguishable
#   from a gate that passed.
#
#   An EXCLUSION list drifts safely — a script added tomorrow is not named in it,
#   so it runs, and if it should not have it fails loudly on its first pass. A
#   new script therefore behaves correctly by default, which is the property being
#   bought.
#
# That leaves an exclusion list exactly one silent failure mode: an entry that no
# longer matches anything, or one whose stated owner has been deleted or has
# stopped invoking it. All three are checked below, before either loop runs,
# because an exclusion nobody can justify is a scan this gate skipped while
# reporting the run clean — the defect code/docs/GATE-REPORTING.md exists to
# name. A stale entry fails this check; it does not quietly widen the scope,
# because a gate that fails loudly claims nothing false, and re-running a script
# the maintainer is mid-way through moving would report one defect as two.
#
# ── Scope 1: code/src/scripts/audits/, minus three ────────────────────────────
#
# Two are excluded because a dedicated check already owns them, and running them
# twice would report one defect as two. The owning check is named beside each,
# and its absence makes the exclusion stale rather than a saving:
#
#   cloc.sh      → lib/check-cloc.sh      (gate [1/8] cloc)
#   security.sh  → lib/check-security.sh  (gate [8/8] security)
#
# One is excluded because it is not a repo-state audit at all:
#
#   dependency-drift.sh  → a `copier update` helper, not a scan
#
# Every other script here answers "is this tree correct" from the tree alone.
# dependency-drift.sh answers "what would an update change", which needs an
# incoming tree to compare against: `--incoming DIR` is required and it dies
# without one. There is no bare invocation that can pass, so running it here
# tests nothing and fails always. That is a mis-shelved script rather than a
# defect the gate should report.
#
# Every audit is expected to self-skip when its surface is absent (mobile, rust,
# desktop, CSS). One that fails for want of a surface is a bug in that audit, and
# surfacing it here is correct rather than something to filter out.
#
# ── Scope 2: .github/scripts/, minus one ──────────────────────────────────────
#
# The template-integrity checks, CI-enforced and template-only: they prove that
# what a generated project receives still matches this repository, and that it can
# be generated at all. Nothing in the eight application checks looks at them.
#
# This loop once read `shipped-*.sh` — an inclusion list wearing a wildcard so it
# looked like a scope. At 16/08/2026 it covered two of the four scripts then in
# that directory and silently excluded check-template-tokens.sh and
# check-template-parsers.sh, which are the two that answer "can this template still
# generate at all". That is what it cost: token syntax broke generation outright
# and this gate went on reporting every audit clean.
#
# Widening it to the directory fixed that and broke the gate the other way, because
# one of the scripts there takes a required argument:
#
#   shipped-artefacts.sh → .github/workflows/audit-template.yml
#                          (job "[3/4] Template Generation")
#
# It asserts on a tree `copier copy` produced, and bare it exits 2 —
# "no generated project directory given" — before it reads anything, so the whole
# check could not pass. Producing that tree is the CI job's work and costs a
# generation, which makes this the same shape as dependency-drift.sh above: a
# script with no bare invocation that can pass. Its owner is a CI job rather than
# a lib check, so the guard below opens the workflow and requires it to still name
# the script — an exclusion resting on "CI runs it" is worth exactly as much as
# that sentence being true.
#
# Not --self-test here, and that is a scope decision rather than an oversight. Proving
# a detector still discriminates already has two homes — the `template-integrity`
# pre-commit leg and the template-audit CI jobs, both of which run the self-test
# before the check. A third copy at this gate would buy nothing and cost the run
# twice over.
#
# ── A scope that ran nothing is never clean ───────────────────────────────────
#
# Both loops glob a directory, and a glob over a directory that is missing, or that
# holds only excluded scripts, yields zero iterations and no failures — reaching the
# same verdict as a full clean run. That is the shape code/docs/GATE-REPORTING.md
# Section 1 bans, and at its worst here: the population is the whole template, and
# nothing opened it. Each loop counts what it ran, and a count of zero is a finding
# of this check rather than a footnote in its output.
#
# Sourced by the pre-PR gate runner, never executed directly.
# Uses:    PROJECT_ROOT, CHECK_PASS, CHECK_SUMMARY, CHECK_OUTPUT
# Defines: _AUDIT_SKIP, _AUDIT_SKIP_OWNER, _AUDIT_SKIP_WHY, _INTEGRITY_SKIP,
#          _INTEGRITY_SKIP_OWNER, _INTEGRITY_SKIP_WHY, _in_list, _check_audits —
#          all file scope, and so in the caller's namespace once sourced.

# The exclusion sets as data, so the guard above can be executed rather than
# merely asserted. Parallel arrays: entry N of each _*_SKIP is excluded for reason
# N of _*_SKIP_WHY, and _*_SKIP_OWNER names what covers it instead — a lib check
# for an audit, a repo-relative workflow for an integrity check — or `-` where
# nothing does and the reason stands on its own.
_AUDIT_SKIP=(cloc.sh security.sh dependency-drift.sh)
_AUDIT_SKIP_OWNER=(check-cloc.sh check-security.sh -)
_AUDIT_SKIP_WHY=(
  'owned by gate [1/8] cloc'
  'owned by gate [8/8] security'
  'a `copier update` helper, not a scan — it requires --incoming DIR'
)

_INTEGRITY_SKIP=(shipped-artefacts.sh)
_INTEGRITY_SKIP_OWNER=(.github/workflows/audit-template.yml)
_INTEGRITY_SKIP_WHY=(
  'it requires a generated project directory and exits 2 bare'
)

# True when $1 appears among the remaining arguments.
_in_list() {
  local needle="$1" item
  shift
  for item in "$@"; do
    [[ "$item" == "$needle" ]] && return 0
  done
  return 1
}

_check_audits() {
  local failed=() stale=() unrun=() out="" name rc i owner
  local audits_ran=0 integrity_ran=0
  local audit_dir="$PROJECT_ROOT/code/src/scripts/audits"
  local integrity_dir="$PROJECT_ROOT/.github/scripts"
  local lib_dir="$PROJECT_ROOT/.claude/hooks/lib"

  # An exclusion is a claim that something is covered without being run here.
  # Verify the claim before honouring it, on all three legs: a name matching no
  # script means the list has outlived its subject; an owner that has been deleted
  # means the audit is now running nowhere at all while this gate steps over it;
  # and an owner that still exists but no longer NAMES the audit covers it no more
  # than a deleted one does — the third leg is the one a rename defeats, and it is
  # why this side carries it as well as the integrity side below.
  for i in "${!_AUDIT_SKIP[@]}"; do
    [[ -f "$audit_dir/${_AUDIT_SKIP[$i]}" ]] ||
      stale+=("${_AUDIT_SKIP[$i]} — excluded, but no such audit exists")
    if [[ "${_AUDIT_SKIP_OWNER[$i]}" != "-" ]]; then
      if [[ ! -f "$lib_dir/${_AUDIT_SKIP_OWNER[$i]}" ]]; then
        stale+=("${_AUDIT_SKIP[$i]} — excluded as ${_AUDIT_SKIP_WHY[$i]}, but ${_AUDIT_SKIP_OWNER[$i]} is gone")
      elif ! grep -qF "${_AUDIT_SKIP[$i]}" "$lib_dir/${_AUDIT_SKIP_OWNER[$i]}"; then
        stale+=("${_AUDIT_SKIP[$i]} — excluded because ${_AUDIT_SKIP_OWNER[$i]} runs it, and that file no longer names it")
      fi
    fi
  done

  # The same three legs on the integrity side, where the owner is a CI workflow
  # rather than a lib check.
  for i in "${!_INTEGRITY_SKIP[@]}"; do
    [[ -f "$integrity_dir/${_INTEGRITY_SKIP[$i]}" ]] ||
      stale+=("${_INTEGRITY_SKIP[$i]} — excluded, but no such integrity check exists")
    owner="$PROJECT_ROOT/${_INTEGRITY_SKIP_OWNER[$i]}"
    if [[ ! -f "$owner" ]]; then
      stale+=("${_INTEGRITY_SKIP[$i]} — excluded as ${_INTEGRITY_SKIP_WHY[$i]}, but ${_INTEGRITY_SKIP_OWNER[$i]} is gone")
    elif ! grep -qF "${_INTEGRITY_SKIP[$i]}" "$owner"; then
      stale+=("${_INTEGRITY_SKIP[$i]} — excluded because ${_INTEGRITY_SKIP_OWNER[$i]} runs it, and that file no longer names it")
    fi
  done

  for script in "$audit_dir"/*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    _in_list "$name" "${_AUDIT_SKIP[@]}" && continue
    audits_ran=$((audits_ran + 1))
    local script_out
    script_out=$(bash "$script" 2>&1)
    rc=$?
    if [[ $rc -ne 0 ]]; then
      failed+=("$name")
      out+=$(printf '\n── %s (exit %s) ───────────────────────────────\n%s\n' \
        "$name" "$rc" "$(printf '%s' "$script_out" | tail -25)")
    fi
  done

  for script in "$integrity_dir"/*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    _in_list "$name" "${_INTEGRITY_SKIP[@]}" && continue
    integrity_ran=$((integrity_ran + 1))
    local script_out
    script_out=$(bash "$script" 2>&1)
    rc=$?
    if [[ $rc -ne 0 ]]; then
      failed+=("$name")
      out+=$(printf '\n── %s (exit %s) ───────────────────────────────\n%s\n' \
        "$name" "$rc" "$(printf '%s' "$script_out" | tail -25)")
    fi
  done

  # Nothing ran is a finding, not a pass. Report the directory and the reason
  # separately, because "the folder is gone" and "the folder holds only the
  # scripts we step over" are different repairs.
  if [[ ! -d "$audit_dir" ]]; then
    unrun+=("code/src/scripts/audits/ does not exist — no audit was run")
  elif [[ $audits_ran -eq 0 ]]; then
    unrun+=("code/src/scripts/audits/ holds no audit this gate runs — the whole audit surface went unexamined")
  fi
  if [[ ! -d "$integrity_dir" ]]; then
    unrun+=(".github/scripts/ does not exist — no template-integrity check was run")
  elif [[ $integrity_ran -eq 0 ]]; then
    unrun+=(".github/scripts/ holds no check this gate runs — nothing proved the template can be generated")
  fi

  # A stale exclusion is a finding of this check, not a footnote in its output —
  # nothing else reads this list, so an unreported stale entry is never seen again.
  if [[ ${#stale[@]} -gt 0 ]]; then
    failed+=("exclusion-set")
    out+=$(printf '\n── exclusion-set (stale) ───────────────────────────────\n%s\n' \
      "$(printf '  %s\n' "${stale[@]}")")
  fi

  if [[ ${#unrun[@]} -gt 0 ]]; then
    failed+=("empty-scope")
    out+=$(printf '\n── empty-scope (nothing examined) ──────────────────────\n%s\n' \
      "$(printf '  %s\n' "${unrun[@]}")")
  fi

  # Name what ran to earn the verdict, and name what did not run at all. The
  # single figure this line replaced — "26 audit(s) clean" — counted the
  # integrity checks as audits and said nothing about the scripts stepped over,
  # so the one number a reader had could not be squared with the directory
  # (code/docs/GATE-REPORTING.md).
  local ran_line skip_list
  printf -v skip_list '%s, ' "${_AUDIT_SKIP[@]}" "${_INTEGRITY_SKIP[@]}"
  ran_line="${audits_ran} audit(s) + ${integrity_ran} integrity check(s) run; \
${#_AUDIT_SKIP[@]} audit(s) + ${#_INTEGRITY_SKIP[@]} integrity check(s) not run here: ${skip_list%, }"

  # The clean output carries the counts, so the detail block on its own can be
  # traced to an execution rather than read as a bare reassurance.
  CHECK_OUTPUT["audits"]="${out:-${ran_line} — every one clean}"

  if [[ ${#failed[@]} -eq 0 ]]; then
    CHECK_PASS["audits"]="true"
    CHECK_SUMMARY["audits"]="${ran_line} — all clean"
  else
    CHECK_PASS["audits"]="false"
    CHECK_SUMMARY["audits"]="${#failed[@]} failed: $(
      IFS=', '
      echo "${failed[*]}"
    ) [${ran_line}]"
  fi
}
