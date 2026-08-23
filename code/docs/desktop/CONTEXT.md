# code/docs/desktop

Sub-documents of [`code/docs/DESKTOP.md`](../DESKTOP.md), split out because the index would
otherwise exceed the 300-line instructional limit. Present only in a project generated with the
desktop surface (`INCLUDE_DESKTOP`).

## Directory Tree

```text
code/docs/desktop/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules
├── LICENSING.md      ← the Slint Royalty-free obligation and its two exclusions
└── UI-AND-STATE.md   ← markup, the generated-code lint boundary, threading, accessibility
```

## Which document, when

| Document          | Read before                                                                                                      |
| ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| `LICENSING.md`    | Shipping, selling, restructuring the About dialog, or porting to anything that is not a general-purpose computer |
| `UI-AND-STATE.md` | Writing any `.slint` markup or Rust that touches the window — the lint boundary, callbacks, threads              |

## The obligation these exist to protect

The app ships under Slint's **Royalty-free** licence: free for proprietary and commercially sold
desktop applications, in exchange for **disclosing the use of Slint**. The `AboutSlint` widget is
that disclosure, and `code/src/scripts/desktop/package.sh` refuses a release build without it.

## Cross-references

- `code/docs/DESKTOP.md` — the index these belong to
- `code/src/rust/CONTEXT.md` — the workspace the desktop crate is a member of
- `code/docs/rust/SUPPLY-CHAIN.md` — the audit policy and how an advisory may be suppressed

**Last Updated**: <%DATE%>
