# project-management/src/04-USER-FLOW/DIAGRAMS

Rendered user flow diagram images (PNG exports from a flow narrative's Mermaid source).
Empty in the base template — populated as flow narratives are authored.

## Directory Tree

```text
project-management/src/04-USER-FLOW/DIAGRAMS/
├── CONTEXT.md                 ← this file
├── CLAUDE.md                  ← operating rules for this folder
└── flow-<area>-<screen>.png   ← rendered flow diagram per screen (added per flow)
```

**Naming:** `flow-<area>-<screen>.png` — kebab-case (e.g. `flow-auth-login.png`).

Source diagrams live in the `USER-FLOW-<AREA>.md` narratives one level up (each screen's
Mermaid `flowchart` block). Re-export here when a flow changes — never edit a PNG directly.

**Last Updated**: <%DATE%>
