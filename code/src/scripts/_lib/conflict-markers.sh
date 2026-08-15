#!/usr/bin/env bash
#
# conflict-markers.sh — the one pattern for an unresolved git conflict marker.
#
# Sourced, never executed. Two callers: audits/conflict-markers.sh (the repo-wide gate) and
# development/template-update.sh (the copier scratch directory). They must not drift — two
# detectors for one defect class that disagree is how the defect below survived two releases.
#
# WHY THE OPEN AND THE CLOSE, AND NOT THE MIDDLE.
#
# A conflict writes three markers. Prettier reformats Markdown, and what it leaves behind was
# measured against the real incident (`.claude/skills/stack-fastmcp/SKILL.md` at `3bd49e8`,
# committed and green for two releases):
#
#   <<<<<<< Updated upstream   ->   "  <<<<<<< …"   conflict-markers: ignore
#                                   indented as a list continuation. The literal survives;
#                                   the ^ anchor does not. NEVER anchor this one.
#
#   =======                    ->   (nothing)                       read as a setext H1
#                                                                   underline; the line above is
#                                                                   rewritten as `# ...` and the
#                                                                   marker is consumed entirely.
#
#   >>>>>>> Stashed changes    ->   "  > > > > > > > Stashed …"   conflict-markers: ignore
#                                   read as a nested blockquote.
#
# So the middle marker is undetectable once mangled — and it is also the only form with a
# measured false positive in this repository (`====`-style separator rules, e.g. a Django
# template comment). It is therefore not matched at all: every real conflict carries an open
# and a close, so nothing is lost, and the gate ships green instead of red.
#
# Measured 15/08/2026 across the tree: open 3 hits, close 1, mangled-close 0, all accounted
# for. `^={7}` would have added a false positive on day one.

# Open (raw or mangled), raw close, mangled close. Deliberately unanchored.
CONFLICT_MARKER_RE='(<{7})|(>{7})|((> ){6,}>)'

# Suppression, following the house convention (doc-references.sh, css-gradients.sh): the
# directive is honoured on the line itself, on the line directly above it, or — because an HTML
# comment inside a fenced block would render as literal text to the reader — on the opening
# fence of the block the marker sits in.
CONFLICT_IGNORE_RE='conflict-markers:[[:space:]]*ignore'

# conflict_markers_scan FILE
#   Emits "<lineno>:<line>" for every unsuppressed marker. Returns 0 always; the caller counts.
conflict_markers_scan() {
  local file="$1"
  awk -v marker="$CONFLICT_MARKER_RE" -v ignore="$CONFLICT_IGNORE_RE" '
    # Look upward for the directive, stepping over blank lines. Prettier puts a blank line
    # between an HTML comment and a fence, so "the line directly above" is not a rule a
    # formatted document can keep; "the nearest line with content above" is.
    function marked_above(i,   j) {
      for (j = i - 1; j >= 1; j--) {
        if (lines[j] ~ /^[[:space:]]*$/) continue
        return (lines[j] ~ ignore)
      }
      return 0
    }
    { lines[NR] = $0 }
    END {
      in_fence = 0
      fence_ignored = 0
      for (i = 1; i <= NR; i++) {
        line = lines[i]

        # Track fenced blocks, and whether this one was explicitly exempted.
        if (line ~ /^[[:space:]]*(```|~~~)/) {
          if (in_fence) {
            in_fence = 0; fence_ignored = 0
          } else {
            in_fence = 1
            fence_ignored = (line ~ ignore || marked_above(i)) ? 1 : 0
          }
          continue
        }

        if (line !~ marker) continue
        if (in_fence && fence_ignored) continue
        if (line ~ ignore) continue
        if (!in_fence && marked_above(i)) continue

        printf "%d:%s\n", i, line
      }
    }
  ' "$file" 2>/dev/null || true
}
