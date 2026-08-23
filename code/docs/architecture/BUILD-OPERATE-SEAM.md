---
type: guide
skills: [planner, codebase-design, runbook]
model: fable
---

# The Build / Operate Seam

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** fable — where a fact lives when the code, the server contract and the deploy
repository each hold part of it

One fact about infrastructure is usually owned in three places at once. This document says which
part belongs where, and how each side points at the others so neither drifts.

---

## Three layers, not two sides

| Layer       | Owns                                                | Home                              | Audience                 |
| ----------- | --------------------------------------------------- | --------------------------------- | ------------------------ |
| **Build**   | The **why** — the rule, the reasoning, the standard | `code/docs/`                      | A developer writing code |
| **Operate** | **What the server must provide** — the contract     | `how-to/src/SERVER-ARCHITECTURE/` | Whoever provisions it    |
| **Deploy**  | The implementation                                  | `<%DEPLOY_REPO%>`                 | The deploy repository    |

The middle layer exists because the deploy repository needs **one document to implement
against**, rather than requirements scattered across guides, ADRs and config files. The
canonical statement of the split is already in the tree
([`code/docs/SECURITY.md`](../SECURITY.md)): _"this doc keeps owning the 'why', SERVER-ARCHITECTURE owns
'what the server provides'."_

**`SCALE-ARCHITECTURE/` is not on this chain.** It is reasoning about how the application scales
— analysis, not requirements another repository implements. It follows the build-side convention
below.

---

## Two shapes, assigned by what the file is

The two sides have different jobs, so they carry the bridge differently. This is not a style
preference: a guide is prose a developer reads, and a contract is a specification another
repository is implemented against.

### Build side — the ownership sentence

A guide that states something the server or edge must provide ends its cross-references with
**one line naming what each side owns**:

```markdown
> The consolidated header set is catalogued as the deploy contract in
> `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md`; this doc keeps owning the "why",
> SERVER-ARCHITECTURE owns "what the server provides".
```

It must name **both** halves. A bare link is not a bridge — it says two documents are related
without saying which one is wrong when they disagree.

### Operate side — the `**Source:**` field

Every section of a `SERVER-ARCHITECTURE/` file that states a requirement opens with a
`**Source:**` bullet naming where the requirement comes from:

```markdown
## 5. URL routing — the Django + Ninja path split

- **Source:** the project's URL-architecture ADR (prefix ownership table),
  `code/docs/URL-STRATEGY.md`; the live routing state is `code/src/docker/nginx/dev.conf`.
```

Rules:

- **Prose sources are legitimate.** "the project's URL-architecture ADR", "`GAPS.md`
  edge-coordination gap" — not every requirement originates in a file.
- **Any repository path it names must resolve.** That is the half a script can check.
- **Numbered sections always carry one.** A numbered section in a `SERVER-ARCHITECTURE/` file
  _is_ a requirement, by construction — that is what the numbering means.
- Descriptive sections (an index, a reading order, a worked derivation) do not need one.

---

## The rule for a change

**A build-side change that alters what the server must provide updates the operate-side contract
in the same change.** Not in a follow-up, not in the next story.

This generalises the only place the repository already enforces it — the definition-of-done
checklist in [`../mcp-server/MOUNTING.md`](../mcp-server/MOUNTING.md), which requires that
`SERVER-ARCHITECTURE/` names `/mcp/` with buffering off before a mount is considered done.

The failure this prevents is specific and quiet: the guide changes, the contract does not, the
deploy repository implements last quarter's requirement, and nothing anywhere reports an error.

---

## What the audit checks, and what it cannot

`bash code/src/scripts/audits/seam-contract.sh` checks two **mechanical** facts:

1. Every repository path named in a `**Source:**` field resolves.
2. Every numbered section in a `SERVER-ARCHITECTURE/` file carries a `**Source:**` field.

It cannot check the thing that matters most: a `**Source:**` pointing at a guide that still
exists but **no longer says what the contract claims it says**. That passes green. The
same-change rule above is the only defence against it, which is why the rule is not optional
just because an audit exists.

Contrast with [`PROVIDER-NEUTRALITY.md`](PROVIDER-NEUTRALITY.md), which ships **no** script: that
rule turns on a judgement (product named as a default versus in place of an interface) no grep
can make. This one turns on a field being present and a path existing. Where a rule is
mechanically decidable, it gets a gate; where it is not, saying so plainly beats a gate that
fails on taste.

---

## Applying it to a new guide

1. Ask whether the guide states anything the **server or edge** must provide. If not, there is
   no bridge to write.
2. If it does, add the ownership sentence to its cross-references, naming both halves.
3. Add or extend the matching `SERVER-ARCHITECTURE/` section, with a `**Source:**` pointing back.
4. Run the audit.

Steps 2 and 3 are one change, never two.

---

## Cross-references

- [`PROVIDER-NEUTRALITY.md`](PROVIDER-NEUTRALITY.md) — the sibling rule: interfaces, seams and
  substrate. Its register is the worked example of this split (rule build-side, register operate-side)
- [`../SECURITY.md`](../SECURITY.md) — the canonical ownership sentence
- [`../mcp-server/MOUNTING.md`](../mcp-server/MOUNTING.md) — the definition-of-done precedent
- [`how-to/src/SERVER-ARCHITECTURE/`](../../../how-to/src/SERVER-ARCHITECTURE/) — the contract
- [`how-to/src/SCALE-ARCHITECTURE/`](../../../how-to/src/SCALE-ARCHITECTURE/) — reasoning, not contract
- `.claude/skills/runbook/SKILL.md` · `how-to/workflows/09-write-operator-guide/` — operator-doc craft

_Part of the `code/docs/` documentation family._
