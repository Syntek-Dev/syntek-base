# Cold-read report — `syntek-base`

### Tool log

| # | Call | Target | Read? |
|---|---|---|---|
| 1 | Glob `*` | repo root | no — returned 118,690 paths, mostly `node_modules/`; **expensive, ~2.5k tokens wasted** |
| 2 | Glob `*/*` | repo root | no — depth-2 listing; this is what actually oriented me |
| 3 | Read | `CLAUDE.md` (root) | **no — file does not exist**, errored, no content returned |
| 4 | Glob `{README,CONTEXT,…}*` | repo root | no — recursive, dumped 100 `node_modules` READMEs; **wasted ~2.5k tokens** |
| 5 | **Read** | `.claude/CLAUDE.md` | **READ 1 — entry file** |
| 6 | Grep `DOCUMENTATION-LENGTH\|docs-length` | whole repo, content mode, limit 60 | no — 57 hits, not truncated |
| 7 | **Read** | `code/docs/DOCUMENTATION-LENGTH.md` | **READ 2** |

Third read never spent — not needed.

### The rule I picked

**Instructional file length: any `.md` that instructs Claude Code must not exceed 300 *code* lines (cloc), and from 270 may not grow without a dated `docs-length-allow` comment carrying an expiry.**

Found at `.claude/CLAUDE.md:268` (Section 8, one bullet that routes onward), owned in full by `code/docs/DOCUMENTATION-LENGTH.md`.

### The four questions

**1. Who cites this?** — **ANSWER**, provenance **POINTER + SEARCH**.

The rule file itself names four citers (`.claude/CLAUDE.md` §8, `DOCUMENTATION-PAIRING.md`, `VERSIONING-AND-DOCS.md`, the gate script) — that part is POINTER. Grep found ~18 more, in five classes:

- **Doctrine:** `code/REFERENCES.md:53` · `.claude/skills/global-workflow/VERSIONING-AND-DOCS.md:48,51` · `.copier/README.md:198,1217`
- **Skills that must obey it:** `doc-writer/SKILL.md:81,119` · `scaffold/SKILL.md:88,121` · `runbook/SKILL.md:61,69` · `.claude/skills/CLAUDE.md:33`
- **Enforcement wiring:** `lefthook.yml:97-103` · `.github/workflows/audit-docs-length.yml`
- **Operator/PM docs:** `how-to/docs/DEVELOPMENT.md:238` · `OPERATOR-DOC-CRAFT.md:41` · `SKILL-AUTHORING.md:44` · `how-to/src/TEMPLATE-GUIDE/07-REPO-TOUR.md:79` · `project-management/workflows/22-implementation-documentation/CHECKLIST.md:62` · three `01-FEATURE-MAPS/MAP-*.md`
- **Negative citations** — two sibling gates explicitly decline to check length and defer to it: `audit-skill-conformance.yml:16`, `audit-negative-space.yml:13`. Those are the strongest citations in the tree, because they encode *non*-duplication.

**2. What moves if I change this rule?** — **ANSWER**, provenance **POINTER (partly) + SEARCH**.

The file's own frontmatter declares its blast radius: `skills: [doc-writer, scaffold, global-workflow]`. Beyond that, the number `300` is **restated, not routed**, in at least eight places that would all go stale: `.claude/CLAUDE.md:268`, `VERSIONING-AND-DOCS.md:48`, `how-to/docs/DEVELOPMENT.md:238`, `.copier/README.md:161,198,1217`, `scaffold/SKILL.md:88`, `doc-writer/SKILL.md:81`, `MAP-NAVIGATION.md:172`, `CHECKLIST.md:62`. Mechanically: `docs-length.sh` plus **two** call sites with *deliberately different* baselines (lefthook `--since HEAD`, CI merge-base) — change the ratchet and both move together. Changing scope also moves the bound/exempt table (§2) and invalidates live allowances such as `stack-django/SKILL.md:367`, and the two deferring gates would need re-reading.

**3. Is this reachable from the entry file?** — **ANSWER: yes, one hop**, provenance **POINTER**.

`.claude/CLAUDE.md` self-declares as the entry (§2.1: "Read `.claude/CLAUDE.md` then `.claude/MEMORY.md` first — always"). Section 8 names the path `code/docs/DOCUMENTATION-LENGTH.md` literally, with the gate and an anti-pointer ("never `cloc.sh`"). The reference is bidirectional — the target's line 12 names `.claude/CLAUDE.md` Section 8 back. No inference needed at any step.

**4. Which directory owns this concept?** — **ANSWER**, provenance **POINTER + SEARCH**.

- **Stated:** `code/docs/` owns it. Line 12: "This guide owns the length rule." (POINTER)
- **Enforced:** `code/src/scripts/audits/docs-length.sh` (POINTER, line 80/102) — invoked from `lefthook.yml:97` pre-commit and `.github/workflows/audit-docs-length.yml` in CI, emitting `code/src/scripts/audits/reports/docs-length-report.txt` (SEARCH).

Ownership and enforcement sit in **the same top-level layer (`code/`) but different subtrees** — doctrine in `code/docs/`, teeth in `code/src/scripts/audits/`.

### Inbound direction

**ANSWER**, provenance **SEARCH** (the grep, not any document I read).

`code/docs/DOCUMENTATION-LENGTH.md` is well-fed from outside `code/docs/`: `code/REFERENCES.md:53` is the layer index and carries a full-sentence description, and `scaffold`, `doc-writer` and `global-workflow` each point in from `.claude/skills/`. Not an orphan.

**One finding, though.** `code/docs/CONTEXT.md` — the orientation half of the pair that the repo's own Section 8 rule mandates for every directory — **does not appear anywhere in the citation set.** Neither pattern matched a single line in it. A reader following the repo's *declared* read order (§2.1 step 3: "the target folder's `CONTEXT.md` … then its `CLAUDE.md`") walks into `code/docs/` and is not told this guide exists. The rule is reachable only via the root `CLAUDE.md` shortcut or `code/REFERENCES.md`, never via the layered chain the project says is the way in. That is the pairing convention failing on the guide that polices its sibling convention.

Caveat, stated rather than assumed: the grep was capped at 60 results and returned 57, so it was not truncated — but it matched only the two literal strings. A pointer phrased as prose ("the length limit") without the filename or script name would not have been caught.

### Which question broke

**None.** All four plus the inbound direction were answered inside the file-read budget — two reads of the three allowed, one spare unspent.

### Verdict

**FAIL — on the token ceiling, not the reads.**

The read budget held comfortably. The **2,000–8,000 token** ceiling did not: tool calls 1 and 4 were unguarded globs against a repo carrying a checked-in `node_modules/` with 118,690 files, and together they burned roughly 5k tokens returning nothing but vendor READMEs. The orienting information came from call 2 alone; calls 1 and 4 were pure waste, and call 4 was waste I should have predicted after seeing call 1 behave recursively.

The honest reading: the *answers* are clean and every one is POINTER- or SEARCH-backed, with nothing marked INFERENCE. The *walk* was not. Running out is the result, and the budget ran out on reconnaissance rather than on reading — which, for a stranger arriving at a root with no `README.md` and no root `CLAUDE.md`, is itself a fact about this repository's front door.