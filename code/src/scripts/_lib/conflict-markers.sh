#!/usr/bin/env bash
#
# conflict-markers.sh — the one pattern for an unresolved git conflict marker.
#
# Sourced, never executed. Two callers: the repo-wide marker gate, and the
# template-update check over the copier scratch directory. They must not drift — two
# detectors for one defect class that disagree is how the defect below survived two releases.
#
# WHY THE OPEN AND THE CLOSE, AND NOT THE MIDDLE.
#
# A conflict writes three markers. Prettier reformats Markdown, and what it leaves behind was
# measured against the real incident — a mangled marker that sat committed and green for two
# releases:
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
# Measured across the tree: open 3 hits, close 1, mangled-close 0, all accounted for.
# `^={7}` would have added a false positive on day one.

# Open (raw or mangled), raw close, mangled close. Deliberately unanchored.
CONFLICT_MARKER_RE='(<{7})|(>{7})|((> ){6,}>)'

# TRANSCRIPT RESIDUE — the second class this gate holds, added 23/08/2026 (MAP-BASE-HEALTH
# N-039). Not a conflict marker, and it is here rather than in an audit of its own because it
# is the same SHAPE: a literal string that must never survive into a tracked file, in any file
# type. That is the reason the marker gate is its own audit rather than a clause inside a
# language-scoped one, and it is equally true of a leaked tool-call tag.
#
# The class: a model's tool-call envelope, written into a document by the session that authored
# it. Ten such tags sat in eight shipped guides for a fortnight and through 49 releases, and
# nothing looked — `template-slop.sh` and `copy-slop.sh` do not know the vocabulary, and
# `doc-references.sh` cannot see it because it is not a citation.
#
# ASSEMBLED FROM PARTS, exactly as the audit's own self-test assembles its specimens: written
# literally, this pattern would match the line it is written on and redden the gate on its own
# source. The names are the envelope's, not a guess — and the population was measured at ZERO
# before this shipped, so the clause was true before it was enforceable.
_LT='<'
RESIDUE_MARKER_RE="${_LT}"'/?(antml:)?(invoke|function_calls|function_results|parameter|content)([[:space:]/>]|$)'

# Suppression, following the house convention the other suppressible audits share: the
# directive is honoured on the line itself, on the line directly above it, or — because an HTML
# comment inside a fenced block would render as literal text to the reader — on the opening
# fence of the block the marker sits in.
CONFLICT_IGNORE_RE='conflict-markers:[[:space:]]*ignore'

# conflict_markers_scan FILE   ·   residue_markers_scan FILE
#   Emit "<lineno>:<line>" for every unsuppressed match. Return 0 always; the caller counts.
#   Both delegate to ONE implementation: two detectors that disagree is how the defect in the
#   header above survived two releases, and that argument does not weaken for a second class.
conflict_markers_scan() { _marker_scan "$1" "$CONFLICT_MARKER_RE"; }
residue_markers_scan()  { _marker_scan "$1" "$RESIDUE_MARKER_RE"; }

_marker_scan() {
  local file="$1" marker_re="$2"
  awk -v marker="$marker_re" -v ignore="$CONFLICT_IGNORE_RE" '
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
