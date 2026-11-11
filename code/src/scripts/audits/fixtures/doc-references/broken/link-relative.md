# Fixture — dead file-relative link targets and a bare file-relative token (US004 GAPS-REL)

Fixture for the doc-references self-test. Never read as documentation.

A bare link target beside this file: [gone](NO-SUCH-FIXTURE-ONLY-LINK.md)

A bare link target under a folder beside this file: [gone](rel/NO-SUCH-FIXTURE-ONLY-LINK.md)

A climbing link target: [gone](../clean/NO-SUCH-FIXTURE-ONLY-LINK.md)

A bare backticked token whose leading folder sits beside this file: `rel/NO-SUCH-FIXTURE-ONLY-BARE.md`

<!-- prettier-ignore -->
A dead target holding parentheses is reported whole: [gone](NO-SUCH-(FIXTURE-ONLY).md)

````markdown
```text
an inner fence does not close the outer one
```
````

A dead link after that fence closes is read: [gone](NO-SUCH-FIXTURE-ONLY-AFTER-FENCE.md)

<!-- markdownlint-disable MD029 -->

10. A list item whose content sits four columns in.

    [gone](NO-SUCH-FIXTURE-ONLY-LIST-CONTINUATION.md) continues the item, and is no code block.

<!-- markdownlint-enable MD029 -->

One dead target written as a token and as a link is one finding:
[`rel/NO-SUCH-FIXTURE-ONLY-DUP.md`](rel/NO-SUCH-FIXTURE-ONLY-DUP.md)

So is one whose two populations resolve to different paths, the token as a script-group shorthand:
[`audits/NO-SUCH-FIXTURE-ONLY-SHORTHAND.md`](audits/NO-SUCH-FIXTURE-ONLY-SHORTHAND.md)
