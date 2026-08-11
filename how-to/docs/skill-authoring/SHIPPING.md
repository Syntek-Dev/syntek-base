---
type: guide
agent: doc-writer
skills: [global-workflow, runbook]
model: opus
---

# Shipping a Skill — structure, routing, the gate, the checklist

**Version:** 0.1.0 **Maintained by:** <%ORG_NAME%> Developers **Language:** British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — what must be true of a skill before it is committed

---

## The hard constraints

- **Folder discovery.** A skill is a `kebab-case/` folder under `.claude/skills/` whose entry
  file is `SKILL.md`, and the folder name **is** the `name` field `[gate: fail]`.
- **≤ 300 code lines per file, on anything first-party** `[gate: fail — docs-length.sh]`
  (`cloc --include-lang=Markdown`; `.claude/CLAUDE.md` § 8). Vendored skills are exempt here too
  — `docs-length.sh` skips `.agents/*`, and one of them sits well past 300. The spec recommends
  under 500 raw lines, so this is stricter in practice, though the two metrics are not
  comparable: ours counts code lines, so blank lines and prose wrapping are free. A file that
  breaches the cap is disclosed — see `CRAFT.md` § 2 for the move.
- **British English** (en_GB) throughout, and every developer operation cites a script in
  `code/src/scripts/**/*.sh` — never a raw `pnpm`, `pytest`, `python`, or `docker` command.

## Routing — the `## Governing procedures` section

**Every skill this project authors carries a `## Governing procedures` section** `[gate: fail]`,
placed immediately before `## Cross-references` where the skill has one — the gate checks
presence, and the placement is a convention a reviewer holds. It names the procedures across all
three workflow layers — `project-management/workflows/`, `code/workflows/` and
`how-to/workflows/` — that the skill is loaded in service of, each with a one-line "when", and it
routes rather than restating them.

The reason is structural rather than stylistic: **no admitted frontmatter key carries routing.**
The four runtime keys say where a skill runs, not what it is loaded in service of, and
`allowed-tools` — the one field from which a reader could have inferred a skill's context — is
declined (`FRONTMATTER.md`). So there is nowhere else for routing to live but the body.

A skill that is a session or sandbox mechanic — `handoff`, `teach`, `msp-scp-documents` — **says
it has none** rather than leaving the absence ambiguous, because a missing section and an empty
one are indistinguishable to the next author. The cross-layer pairing map is
`REFERENCES.md` → _Cross-layer workflow pairing_.

## Registration

Adding the folder is not shipping it. A skill nobody has listed is a skill nobody finds:

1. `.claude/skills/CONTEXT.md` — the tree **and** the when-to-load table.
2. `.claude/CLAUDE.md` § 2.4 and _Skill Targets_ — only where something cites the skill by name.

## The gate

`bash code/src/scripts/audits/skill-conformance.sh` checks both halves of the standard, all
clauses `[gate: fail]` with no warn tier:

- **Spec clauses** — the frontmatter block is well formed; `name` and `description` are present;
  `name` matches its folder and satisfies the character rules; `description` is within the
  1024-character ceiling; and no key appears that neither the specification nor Claude Code
  defines.
- **House clauses** — no key this project declines on a first-party skill, whether a spec field
  or a documented runtime key; an explicit `agent:` and `background:` on anything forked; any
  `agent:` value, forked or not, naming one of the three built-in targets; and the
  `## Governing procedures` section.

Findings are reported `[spec N]`/`[house N]`; the reason the two are kept apart is
`FRONTMATTER.md` § _Three claims, kept apart_. Vendored skills are held to the spec clauses
only, and within those to the published six alone — no runtime key is admitted on one. Run it on
any skill you touch.

It does **not** check length — `docs-length.sh` owns the 300-line cap across all of `.claude/**`,
and a rule with two enforcers drifts the moment the number moves.

## Checklist before shipping a skill

- [ ] The **remit is named in a sentence**, and no entry in `.claude/skills/CONTEXT.md` already
      owns it — otherwise this is an edit to that entry, not a new folder.
- [ ] Folder is `kebab-case/` under `.claude/skills/`; entry file is `SKILL.md`; sub-documents
      are `SCREAMING-SNAKE-CASE.md` **flat beside it**, one level deep.
- [ ] `name` matches the folder exactly: 1–64 chars, `a-z0-9-`, no leading/trailing or doubled
      hyphen.
- [ ] `description` is non-empty and under 1024 characters, and earns every one of them.
- [ ] Frontmatter carries `name` + `description`, plus only the runtime keys the skill's own
      fork call needs; the four optional spec fields and every runtime key outside the admitted
      four are declined on anything first-party.
- [ ] The skill states whether it is **reference** or **task**, and the axis that produced its
      fork call.
- [ ] Anything forked names `agent:` explicitly, and its `background:` matches the write test —
      `Explore` + `true` for read-only, `general-purpose` + `false` for anything that writes.
- [ ] Invocation is deliberate: a rich "Load when…" description for model-auto-loading, or an
      "Invoke by typing `/name`" description for user-typed; the trade (context vs cognitive load)
      is the right one.
- [ ] Description front-loads the leading word, carries one trigger per branch, and repeats no
      identity already in the body.
- [ ] Description **discriminates against its named near-neighbours** — the change says which
      entries those are and how a reader tells them apart.
- [ ] A **task** skill names every **reference** skill it depends on in the `skills:` list that
      loads it — nothing fails when it is missing.
- [ ] Steps sit above reference; every step ends on a checkable (and where it matters, exhaustive)
      completion criterion.
- [ ] Every file is ≤ 300 code lines; anything longer is a thin index plus disclosed
      sub-documents.
- [ ] Reference that only some branches need sits behind a well-worded context pointer; related
      material is co-located under one heading.
- [ ] Facts are looked up, not asked; dev operations cite `code/src/scripts/**/*.sh`.
- [ ] Each meaning has a single source of truth; no duplication, sediment, sprawl, or no-op lines
      survive a pass.
- [ ] Steering is positive, not prohibition; British English throughout.
- [ ] `## Governing procedures` is present — naming the procedures, or saying there are none —
      and sits immediately before `## Cross-references` where the skill has one.
- [ ] Registered: `.claude/skills/CONTEXT.md` (tree + when-to-load), and `.claude/CLAUDE.md`
      § 2.4 and _Skill Targets_ if anything cites it by name.
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` and
      `bash code/src/scripts/audits/docs-length.sh --path .claude/skills` both exit 0.

_Part of the `how-to/docs/` documentation family._
