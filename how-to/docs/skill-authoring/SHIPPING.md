---
type: guide
skills: [doc-writer, global-workflow, runbook]
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
  (`cloc --include-lang=Markdown`; `.claude/CLAUDE.md` Section 8). Vendored skills are exempt here too
  — `docs-length.sh` skips `.agents/*`, and one of them sits well past 300. The spec recommends
  under 500 raw lines, so this is stricter in practice, though the two metrics are not
  comparable: ours counts code lines, so blank lines and prose wrapping are free. A file that
  breaches the cap is disclosed — see `CRAFT.md` Section 2 for the move.
- **British English** (en_GB) throughout, and every developer operation cites a script in
  `code/src/scripts/**/*.sh` — never a raw `pnpm`, `pytest`, `python`, or `docker` command.

## Routing — the `## Governing procedures` section

**Every skill this project authors carries a `## Governing procedures` section** `[gate: fail]`,
placed immediately before `## Cross-references` where the skill has one — the gate checks
presence, and the placement is a convention a reviewer holds. It names the procedures across all
three workflow layers — `project-management/workflows/`, `code/workflows/` and
`how-to/workflows/` — that the skill is loaded in service of, each with a one-line "when", and it
routes rather than restating them.

The reason is structural rather than stylistic: **no admitted frontmatter key names a procedure.**
The four runtime keys say where a skill runs, not what it is loaded in service of;
`metadata.skills` registers the reference skills this one depends on, which is a different
question; and `allowed-tools` — the one field from which a reader could have inferred a skill's
context — is declined (`FRONTMATTER.md`). So there is nowhere else for routing to live but the
body.

A skill that is a session or sandbox mechanic — `handoff`, `teach`, `msp-scp-documents` — **says
it has none** rather than leaving the absence ambiguous, because a missing section and an empty
one are indistinguishable to the next author. The cross-layer pairing map is
`REFERENCES.md` → _Cross-layer workflow pairing_.

## Registration

Adding the folder is not shipping it. A skill nobody has listed is a skill nobody finds:

1. `.claude/skills/CONTEXT.md` — the tree **and** the when-to-load table. This is the roster,
   and it is the only one: `.claude/CLAUDE.md` routes to it rather than restating it, so a
   second registration step no longer exists to forget.
2. `.copier/README.md` — the register row, which `.github/scripts/shipped-readme.sh` enforces <!-- doc-references: template-only -->
   in CI.

## The gate

`bash code/src/scripts/audits/skill-conformance.sh` checks both halves of the standard, all
clauses `[gate: fail]` with no warn tier:

- **Spec clauses** — the frontmatter block is well formed; `name` and `description` are present;
  `name` matches its folder and satisfies the character rules; `description` is within the
  1024-character ceiling; and no key appears that neither the specification nor Claude Code
  defines.
- **House clauses** — no key this project declines on a first-party skill, whether a spec field
  or a documented runtime key; an explicit `agent:` and `background:` on anything forked; any
  `agent:` value, forked or not, naming one of the three built-in targets; the
  `## Governing procedures` section; and a `metadata:` map carrying `skills` and no other child,
  every name in it resolving to a skill directory.

Findings are reported `[spec N]`/`[house N]`; the reason the two are kept apart is
`FRONTMATTER.md` Section _Three claims, kept apart_. Vendored skills are held to the spec clauses
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
      fork call needs; `compatibility`, `allowed-tools`, `license` and every runtime key outside
      the admitted four are declined on anything first-party.
- [ ] The skill states whether it is **reference** or **task**, and the axis that produced its
      fork call.
- [ ] Anything forked names `agent: general-purpose` and `background: false` explicitly — any
      other pair needs the reopening test in `FORK-DECISION.md`, not a judgement call.
- [ ] Invocation is deliberate: a rich "Load when…" description so the skill fires unaided, or an
      "Invoke by typing `/name`" description so it waits for a human; the trade (context vs
      cognitive load) is the right one. Typing `/name` works either way and is never the question.
- [ ] Description front-loads the leading word, carries one trigger per branch, and repeats no
      identity already in the body.
- [ ] Description **discriminates against its named near-neighbours** — the change says which
      entries those are and how a reader tells them apart.
- [ ] A **task** skill names every **reference** skill it depends on in `metadata.skills` — and
      names no task skill there, which fires on its own description.
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
- [ ] Every **top-level guide naming this skill** in its routing frontmatter is cited back in the
      body — by path, or by a directory glob covering it.
- [ ] Registered: `.claude/skills/CONTEXT.md` (tree + when-to-load) and the `.copier/README.md`
      register row.
- [ ] `bash code/src/scripts/audits/skill-conformance.sh` and
      `bash code/src/scripts/audits/docs-length.sh --path .claude/skills` both exit 0.

_Part of the `how-to/docs/` documentation family._
