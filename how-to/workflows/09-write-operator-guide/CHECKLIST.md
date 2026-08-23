---
workflow: 09-write-operator-guide
phase: document
skills: [runbook, global-workflow]
model: opus
---

# Write an Operator Guide — Checklist

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

> **See** `how-to/REFERENCES.md` → **Context files** (`how-to/src/CONTEXT.md`, `how-to/docs/CONTEXT.md`) · **Reference guides** · **Cross-layer references** (`code/src/scripts/CONTEXT.md`).

## Placement

- [ ] Grilled first — reader, trigger, scope, and what is deliberately out of scope · _opus_
- [ ] Confirmed it does not duplicate an existing guide; extending one was considered · _opus_
- [ ] Home chosen deliberately: `how-to/docs/` (≤ 300 lines) or `how-to/src/` (exempt) · _opus_
- [ ] Boundary respected — server **provisioning** belongs to `<%DEPLOY_REPO%>`; this repo specifies the contract · _opus_

## Content

- [ ] Follows the runbook spine: purpose → prerequisites → steps → failure modes → rollback → verification · _opus_
- [ ] Every command is copy-pasteable; no placeholder the reader must guess · _opus_
- [ ] Every step states what success looks like, and what to do when it does not happen · _opus_
- [ ] Failure modes cover what actually went wrong when you ran it — not an imagined list · _opus_
- [ ] Rollback stated for anything destructive · _opus_
- [ ] British English, second person, no filler; headings skimmable under pressure · _opus_

## Script-first

- [ ] Every command resolves to `code/src/scripts/**/*.sh` · _opus_
- [ ] No raw `docker`, `pnpm`, `npm`, `npx`, `pip`, `uv`, or `python manage.py` presented as the sanctioned route · _opus_
- [ ] Any missing script written, or the gap recorded in `GAPS.md`, or the manual step stated plainly with its reason · _opus_

## Proven

- [ ] **Executed start to finish on an environment matching the stated prerequisites** · _opus_
- [ ] Every quoted output matches what the command actually printed · _opus_
- [ ] Anything you had to think about has been specified; anything you recovered from by instinct is in Failure modes · _opus_

## Wired in

- [ ] Listed in its folder `CONTEXT.md` tree and in `how-to/REFERENCES.md` · _opus_
- [ ] Cross-references resolve in both directions · _opus_
- [ ] `docs-length.sh` clean; oversized `docs/` guide split with a thin index · _opus_
- [ ] markdownlint and Prettier clean · _opus_

---

## Context

- [ ] Directory trees in relevant `CONTEXT.md` files reflect any new files or folders created during this workflow
- [ ] `**Last Updated**` date is current in any `CONTEXT.md` modified
- [ ] New constraints, patterns, or decisions are documented in the relevant `CONTEXT.md`
- [ ] Every new directory created during this workflow has a `CONTEXT.md` and a `CLAUDE.md` inside it
- [ ] The code-review-graph refreshed alongside the docs (`code-review-graph update`)

---

## Definition of Done

- [ ] The guide was **executed start to finish** on an environment matching its own stated
      prerequisites, and every quoted output is what the command actually printed · _opus_
- [ ] A reader with the stated prerequisites and no other context can follow it without
      guessing at a placeholder or inferring a missing step · _opus_
- [ ] Discoverable from both directions: listed in its folder `CONTEXT.md` tree and in
      `how-to/REFERENCES.md`, and the workflows that should route to it now do · _opus_
- [ ] `docs-length.sh`, markdownlint and Prettier clean; the code-review-graph refreshed
      alongside the docs · _opus_
