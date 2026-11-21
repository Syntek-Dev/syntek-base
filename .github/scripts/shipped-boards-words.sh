#!/usr/bin/env bash
# shipped-boards-words.sh — check 2's word reading, sourced by shipped-boards.sh (never run).
#
# TEMPLATE-ONLY: .github/scripts/ is copier _exclude'd. Split out of shipped-boards.sh on
# 21/11/2026 (round 9) to hold that script inside the 750-line source limit; the functions are
# moved unchanged but for the brace cap. seed_word reads one word as a path; seed_any reads a word
# and the spans a separator bounds through it. Pattern matching only: nothing is expanded or run.

# The most `{` brace spans one word may hold and still be read for a seed (round 9, 21/11/2026).
BRACE_CAP=8

# seed_word WORD BOARD — WORD, read as a path the shell resolves, names the .copier directory
# itself or .copier/BOARD. `//` and `/./` collapse and a `..` cancels the component before it, so a
# path spelt the long way round reads as the short one. A component names .copier when it matches
# it as a glob (`.cop?er`, `.c*r`, `.[c]opier`) — only one that opens with a literal `.` or an
# alternation, because sh never matches a leading dot by a wildcard — and a `{A,B}` brace
# expansion is read as either alternative. What follows it must then be nothing (the directory)
# or one component matching BOARD as a glob. Pattern matching only: nothing is expanded or run.
seed_word() {
  local w="$1" board="$2" inner comp i parts=() out=() rest=()
  # No `.` and no brace: no component can open with `.` or `@(`, so nothing here names .copier.
  [[ "$w" == *.* || "$w" == *\{* ]] || return 1
  while [[ "$w" =~ \{([^{}]*)\} ]]; do
    inner="${BASH_REMATCH[1]}"; w="${w/"{$inner}"/"@(${inner//,/|})"}"
  done
  IFS=/ read -ra parts <<< "$w"
  for comp in "${parts[@]}"; do
    case "$comp" in
      ''|.) ;;
      ..) if [[ ${#out[@]} -gt 0 && "${out[-1]}" != .. ]]; then unset 'out[-1]'; out=("${out[@]}"); else out+=(..); fi ;;
      *) out+=("$comp") ;;
    esac
  done
  for i in "${!out[@]}"; do
    comp="${out[$i]}"
    [[ "$comp" == .* || "$comp" == @\(* ]] || continue
    # shellcheck disable=SC2053  # $comp is a glob on purpose: a pattern matching .copier names it
    [[ .copier == $comp ]] || continue
    rest=("${out[@]:i+1}")
    [[ ${#rest[@]} -eq 0 ]] && return 0
    # shellcheck disable=SC2053  # the same, for the board name
    [[ ${#rest[@]} -eq 1 && "$board" == ${rest[0]} ]] && return 0
  done
  return 1
}

# seed_any WORD BOARD — seed_word over WORD and over the spans of it that a separator bounds, so
# a path behind an assignment or an `=value` (`F=.copier/…`, `if=.copier/…`, `--dir=.copier`), or
# inside a comma or colon list, is read as the path it is (round 7, 21/11/2026). The separators are
# `=`, `,` and `:`, read wherever they sit — quoted ones included, since the quotes are gone by
# now — so the reading errs towards a finding, never away from one. A word opening with a single
# `-` is also read from each `.` after its first two characters, for a short option with its value
# glued on (`-C.copier`, `-xC.copier`). Each start is read to three ends (round 8, 21/11/2026):
# the next separator, the next one outside a `{…}` brace or `[…]` bracket (a brace's or a
# bracket's own `,` or `:` is part of the path), and the word's end: three spans per separator,
# where round 7 read every pair of them (13 s at 150). Each span is still read along its length,
# so the cost grows with the square of a word's length, not linearly (round 9, 21/11/2026) — and
# a brace span re-reads it once more, so a word holding more than BRACE_CAP of them is skipped
# here and reported by run_checks. Measured 21/11/2026, at the cap: 0.5 s for a 2 KB word, 1.6 s
# for 4 KB; uncapped, 300 `.{a,b}=` took 45 s.
seed_any() {
  local w="$1" board="$2" n=${#1} i c depth=0 inbr=false starts=(0) seps=() tops=() a=0 b=0
  c="${w//[^\{]/}"
  [[ ${#c} -le $BRACE_CAP ]] || return 1   # over the cap: run_checks reports it (round 9)
  for ((i = 0; i < n; i++)); do
    c="${w:i:1}"
    case "$c" in
      [=,:]) starts+=("$((i + 1))"); seps+=("$i"); [[ $depth -eq 0 ]] && ! $inbr && tops+=("$i") ;;
      .) [[ "$w" == -[!-]* && $i -ge 2 ]] && starts+=("$i") ;;
      '{') $inbr || depth=$((depth + 1)) ;;
      '}') $inbr || { [[ $depth -gt 0 ]] && depth=$((depth - 1)); } ;;
      '[') inbr=true ;;
      ']') inbr=false ;;
    esac
  done
  seps+=("$n"); tops+=("$n")
  for i in "${starts[@]}"; do
    while [[ ${seps[a]} -lt $i ]]; do a=$((a + 1)); done
    while [[ ${tops[b]} -lt $i ]]; do b=$((b + 1)); done
    [[ $i -lt $n ]] || continue
    if [[ ${seps[a]} -gt $i ]]; then seed_word "${w:i:seps[a]-i}" "$board" && return 0; fi
    if [[ ${tops[b]} -gt ${seps[a]} && ${tops[b]} -lt $n ]]; then
      seed_word "${w:i:tops[b]-i}" "$board" && return 0
    fi
    if [[ ${seps[a]} -lt $n ]]; then seed_word "${w:i}" "$board" && return 0; fi
  done
  return 1
}
