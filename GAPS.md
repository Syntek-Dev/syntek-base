# GAPS.md — Active Gaps, Blockers & Sprint Dependencies

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Tracks active architectural gaps, blockers, and sprint dependencies for <%PROJECT_NAME%>.
**Not** a memory store — feedback, patterns, and observations go in `.claude/MEMORY.md`
instead. Deferred work goes in `DEFERRED.md`.

Resolved entries are marked `✅ CLOSED <date>` and removed on the next tidy pass. Permanent
architectural decisions are promoted to the doc that owns them — the promotion table is in
`.claude/CLAUDE.md` §10, which owns this workflow; it is not restated here.

## Format

Append a new entry at the top, newest first:

```text
## DD/MM/YYYY — <title>

**Type:** <Infrastructure gap | Planned feature | Sprint dependency | Active gap>
**Summary:** …
**Blocked by / Action:** …
```

---

_No active entries._
