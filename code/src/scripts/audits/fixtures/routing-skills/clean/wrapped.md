---
type: guide
skills:
  [
    planner,
    stack-django,
    stack-htmx-templates,
    code-reviewer,
    qa-tester,
    security,
    refactor,
    stack-rust,
  ]
model: fable
---

# Clean fixture — the wrapped flow sequence

Fixture for routing-skills.sh --self-test. Never read as documentation.

Every name here resolves, so this file must produce no finding — and the self-test asserts
it produced eight checked names rather than none, because a parser that skips the file
whole also produces no finding. That silence was N-030: the audit reported a confident
count across every other file and never opened this form at all.

**The wrapping is load-bearing and is not a style choice.** Written on one line these eight
names run past Prettier's 100-column print width, so Prettier breaks them exactly like
this — the same reason code/docs/NEGATIVE-SPACE.md carries the form in the real tree. The
self-test asserts the array is still wrapped, so if a future reformat collapses it the
proof fails loudly instead of quietly testing the inline form twice.

The list also names a copier-gated skill on purpose. The co-variance clause has its own
file selector, and that selector was blind to this form as well.
