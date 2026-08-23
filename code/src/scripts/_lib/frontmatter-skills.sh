#!/usr/bin/env bash
#
# frontmatter-skills.sh — the one reader for a routing `skills:` list.
#
# Sourced, never executed. Two audits ask opposite questions of the same routing key:
#
#   the outbound one   does every name RESOLVE to a skill directory
#   the inbound one    does the named skill CITE the guide back
#
# WHY IT IS SHARED, AND WHAT THE TWO COPIES COST. They had already drifted, and in the
# direction that matters: the inbound reader read the multi-line form, the outbound one
# selected with /^skills:[[:space:]]*\[/ and needed the opening bracket on the SAME LINE
# as the key. Prettier wraps a long array across lines at its print width, so one shipped
# guide writes one — and that file was skipped whole. Its eight names had never been
# validated, while the audit reported "541 skill name(s) across 235 file(s) ... Every
# routing skill resolves". The count is the tell: honest about what it checked, silent
# about what it never opened. Proven by inserting a fictional name into that array and
# watching the run stay green.
#
# So this is the third parser deleted rather than the third parser written: a pattern with
# two enforcers belongs here, and the weaker copy is always the one running where it
# matters.
#
# WHAT COUNTS AS A ROUTING DECLARATION. The leading frontmatter block only — byte 0 must
# open it, and reading stops at its terminator. A `skills:` line in prose or inside a
# fenced example is never a routing declaration, and neither is one in a second document
# concatenated below.
#
# THREE FORMS, because YAML admits three and a reader that knows one is how this defect
# happened:
#
#   skills: [planner, backend]        inline flow sequence — 246 of the 247 files today
#   skills:                           wrapped flow sequence — what Prettier produces
#     [planner, backend]              past its print width
#   skills:                           block sequence — used by nothing here yet, and
#     - planner                       admitted anyway, because "used by nothing yet" is
#     - backend                       exactly what was true of the wrapped form
#
# Sourcing is side-effect-free: this file defines a function and does nothing else, so a
# script may source it twice.

# frontmatter_skills FILE
#   Emits "<lineno><TAB><name>", one line per name, where lineno is the line of the
#   `skills:` key itself (what a finding cites). Emits nothing when the file has no
#   leading frontmatter or no skills key. Always returns 0 — the caller counts.
frontmatter_skills() {
  local file="$1"
  [ -f "$file" ] || return 0

  awk '
    # Byte 0 opens the block, or there is no frontmatter and nothing to read.
    NR == 1 && $0 != "---" { exit }
    NR == 1 { next }

    # The terminator wins over everything below it.
    /^---[[:space:]]*$/ { exit }

    # The key. Whatever follows it on the same line seeds the buffer, so the inline
    # form completes in one step and the two wrapped forms start empty.
    !seen && /^skills:/ {
      seen = 1; key = NR
      buf = $0; sub(/^skills:/, "", buf)
      if (buf ~ /\[/) inbr = 1
      if (inbr && buf ~ /\]/) exit
      next
    }

    seen {
      # A sibling top-level key ends a block sequence. It cannot end a flow sequence:
      # `model: fable` never appears inside brackets, and a value that contains a colon
      # legitimately can.
      if (!inbr && /^[A-Za-z_][A-Za-z0-9_-]*:/) exit
      buf = buf " " $0
      if (buf ~ /\[/) inbr = 1
      if (inbr && buf ~ /\]/) exit
    }

    END {
      if (!seen) exit

      if (inbr) {
        sub(/^[^[]*\[/, "", buf)   # drop everything up to and including the first [
        sub(/\][^]]*$/, "", buf)   # drop the last ] and any trailing comment
      } else {
        # Block sequence: strip the leading dash of each item. The dash must be
        # preceded by whitespace or the line start and followed by whitespace, so an
        # internal hyphen (stack-django) is never touched.
        gsub(/(^|[[:space:]])-[[:space:]]+/, " ", buf)
      }

      gsub(/[",'"'"']/, " ", buf)
      n = split(buf, name, /[[:space:]]+/)
      for (i = 1; i <= n; i++)
        if (name[i] != "" && name[i] != "-") printf "%d\t%s\n", key, name[i]
    }
  ' "$file" 2>/dev/null || true
}
