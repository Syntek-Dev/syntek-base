# Fixture — live file-relative link targets, and what a link target is not (US004 GAPS-REL, GUARD)

Fixture for the doc-references self-test. Never read as documentation.

[sibling](anchors.md) · [nested](MANUAL/relative-class.md) · [dotted](./tokens.md) ·
[climbing](../broken/anchors.md) · [fragment](anchors.md#fixture) · ![image](MANUAL/relative-class.md) ·
[titled](anchors.md "a title")

[web](https://example.com/NO-SUCH.md) · [mail](mailto:nobody@example.com) · [in-page](#top) ·
[pattern]({name}.md) · [outside](../../../../../../../../../../NO-SUCH-OUTSIDE.md)

A bare backticked token whose leading folder sits beside this file, present: `MANUAL/relative-class.md`

[quoted dead link](NO-SUCH-FIXTURE-ONLY-QUOTED.md) <!-- doc-references: ignore -->

## Not a link target, though it reads like one (US004 REV-02 / H-02)

A dead link inside a fence is an example:

```text
[gone](NO-SUCH-FIXTURE-ONLY-FENCED.md)
```

A dead link inside a code span is an example: `[gone](NO-SUCH-FIXTURE-ONLY-SPAN.md)`

<!-- prettier-ignore -->
So is one inside a double-backtick span: ``[gone](NO-SUCH-FIXTURE-ONLY-DOUBLE.md)``

A longer fence is not closed by a shorter one inside it:

````markdown
```text
[gone](NO-SUCH-FIXTURE-ONLY-NESTED-FENCE.md)
```

[gone](NO-SUCH-FIXTURE-ONLY-STILL-FENCED.md)
````

<!-- [gone](NO-SUCH-FIXTURE-ONLY-COMMENT.md) -->

<!--
[gone](NO-SUCH-FIXTURE-ONLY-MULTILINE-COMMENT.md)
-->

\[not a link\](NO-SUCH-FIXTURE-ONLY-ESCAPED.md)

<!-- prettier-ignore -->
A target holding one level of parentheses: [paren](MANUAL/PRESENT-(FIXTURE-ONLY).md)

## Present, seeded or registered (US004 REV-02)

A registered class member: [status](../../../../../../../project-management/src/18-TESTS/AUTOMATED/US042-TEST-STATUS.md)

A root-anchored spelling whose leading folder would otherwise match beside this file: `/NO-SUCH-FIXTURE-ONLY.md`
