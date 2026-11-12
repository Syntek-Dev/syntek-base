---
type: guide
skills: [cicd, global-workflow]
model: opus
---

# Forward voice — what a shipped document may claim about the tree

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>

A file that ships is read in a project that is not this one. Every path it names is therefore a
claim about **two** trees — the one it was written in, and the one it will be read in — and the
two do not hold the same files. This guide owns the one rule that governs the gap, and
`code/src/scripts/audits/doc-references.sh` is what enforces the checkable half of it.

The sibling rule is `code/docs/GATE-REPORTING.md`: that one governs what a **check** may claim it
looked at, this one governs what a **document** may claim exists. Both exist because the reader
cannot tell a true statement from a confident one.

## 1. The rule

> **A shipped document may cite a path this repository does not hold only if it declares which
> way it speaks. Anything else that does not resolve is a false assertion, and is fixed rather
> than marked.**

"Fixed rather than marked" is the load-bearing half. A mechanism for recording exceptions becomes
a mechanism for recording mistakes within a week of existing, and the register that results is
worth nothing to the person reading it. **The default disposition of a dangling citation is
deletion or correction.** The two mechanisms below are for the citations that are genuinely
right and merely unprovable here.

## 2. The two directions

The tree here and the tree downstream diverge in both directions, and the direction decides the
mechanism. Neither is a suppression of the other's check.

| Direction | Shape                                                       | Example                       | Mechanism                                                                    |
| --------- | ----------------------------------------------------------- | ----------------------------- | ---------------------------------------------------------------------------- |
| **A**     | **Absent here, present downstream** — the project builds it | `code/src/django/components/` | Register: `how-to/src/PROJECT-PATHS.md`                                      |
| **B**     | **Present here, absent downstream** — copier excludes it    | `copier.yml`, `LICENSE`       | Per-line token: `doc-references: template-only` — mechanics only (Section 4) |

**Direction A is a promise, Direction B is a disclaimer.** A guide naming
`code/src/django/components/` is telling a developer where their components will go, and it is
right; a guide naming `copier.yml` is talking about the template itself, which its reader does <!-- doc-references: template-only -->
not have. The first is checked by naming what creates the path. The second cannot be checked
here at all, and says so on the line.

## 3. Direction A — the register

`how-to/src/PROJECT-PATHS.md` is the project's own answer sheet, on the same split as
`code/docs/NEGATIVE-SPACE.md` → `how-to/src/INVARIANTS.md` and
`code/docs/architecture/PROVIDER-NEUTRALITY.md` → `how-to/src/PLATFORM-PROVIDERS.md`: **the rule
is the same in every generated project and lives here; the answers are this project's and live
in `how-to/src/`.** The register ships, so a developer reading a promise can find out who keeps
it.

**A register entry is a path _and_ what creates it.** An entry that cannot name its creator is
not a promise, it is a wish, and it belongs in neither file:

| Column         | Meaning                                                                      |
| -------------- | ---------------------------------------------------------------------------- |
| **Path**       | The path a shipped document cites, absent from this repository               |
| **Created by** | The script, workflow or step that brings it into existence in a real project |
| **When**       | The point in a project's life at which that happens                          |

The creator column is what stops the register becoming a dumping ground, and **it enforces
itself at no cost**. Because a creator is written as a backticked path in a shipped file,
`doc-references.sh`'s ordinary dangling check already reads it: name a script that does not
exist and the gate reddens on the register itself. No second clause was written for this.

**Register a path, not a site.** One row covers every document citing that path — 40 of the
sites this rule was written against name `code/src/django/components/`. If two documents disagree
about what a path is for, that is a documentation defect to fix, not two rows.

**A row may be patterned.** Where every story creates its own copy of a record, one row binds the
class: `###` means exactly three digits, the rest matches literally and whole. The duty is the
same — a newly promised record class takes its row in the same change. **No row covers a shipped
template**: a zero-index or `-TEMPLATE.` file must exist here, and the gate tests its presence
before it consults the register.

## 4. Direction B — the `template-only` token

A citation of a path this repository **holds** but copier **excludes** resolves here and dangles
in every generated project. Nothing on this side of the seam can observe that failure, so the
declaration is made on the line:

```markdown
The template contract lives in `copier.yml`. <!-- doc-references: template-only -->
```

Accepted on the line itself or the line directly above it — the annotation convention every
sibling audit already uses. **`doc-references.sh` Check 3 enforces this as of 23/08/2026**: an
excluded path cited by a shipping file without one of the two markers is a finding, so the
declaration is no longer a convention a reviewer has to remember.

**The token covers template mechanics, never a template artefact (12/11/2026).** Copier excludes
two different kinds of file, and only one may be cited from a file that ships:

| Excluded file          | Examples                                                                                                         | A shipped file may                                                                  |
| ---------------------- | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| **Template mechanics** | `copier.yml`, `LICENSE`, `.github/scripts/`, `VERSION`, the render script                                        | Describe it, under the `template-only` token <!-- doc-references: template-only --> |
| **Template artefact**  | A decision, story, feature map, story or sprint plan, finding, review, bug; any research note, handoff or lesson | **Never cite it** — the token does not excuse it                                    |

An artefact is a **record of this repository's own work**, so a citation of it is dead in every
generated project, and declaring that it does not ship states the defect instead of excusing it.
The gate reports it as a `[template artefact]`, marked or not. **Remove the citation and summarise
the reasoning in place**, in the shipped file's own words. Which is which is **derived, never
listed**: an artefact is whatever `_exclude` leaves excluded inside a tree it empties with a `/**`
entry — `research/`, `handoffs/`, `learning/` and `project-management/src/` today — so the shipped
pairs, `-TEMPLATE.` files, zero-index test records, `00-ASSETS` scripts, build sources and GDPR
registers it re-includes stay citable. A real decision identifier is the same finding wherever it
is written, backticked or bare, and **real means it names a decision record that exists** among
those excluded records: a made-up worked example names none and stays silent, and the zero index,
the shipped decision template, never fires. In a generated project no record is excluded, so the
identifier half is silent there by the same decision as the path half.

**It is not a synonym for `doc-references: ignore`.** Both suppress a finding; they record
different judgements, and both are greppable so the distinction survives:

| Token                           | Means                                                                                                           |
| ------------------------------- | --------------------------------------------------------------------------------------------------------------- |
| `doc-references: ignore`        | Neither check applies — a path quoted in order to ban it, or another repo's                                     |
| `doc-references: template-only` | The check applies and the citation is deliberate — a mechanic that does not ship; **never** a template artefact |

Reach for `template-only` whenever the reason is "the reader of a generated project will not
have this" **and the path is template machinery**. Reach for `ignore` when the path is not really
being cited at all — never to quieten an artefact citation the token can no longer excuse.

## 5. What the gate cannot decide, stated plainly

Per `code/docs/GATE-REPORTING.md`, a check must not be read as having examined what it cannot
see. `doc-references.sh` enforces this guide **partially**, and the gaps are not defects to be
discovered later:

- **It derives Direction B, for unconditional exclusions only.** Check 3 parses
  `copier.yml`'s `_exclude`, subtracts the negations, the `_tasks` seeds and the regenerated <!-- doc-references: template-only -->
  `uv.lock`, then fires when a shipping file cites one of the forty paths left without either
  marker. A green run now means **both** "no path is missing here" and "every citation
  survives generation". The set is parsed rather than listed, so a new exclusion needs no edit
  to the script — and the run prints its size, because a parse that found nothing would
  otherwise report clean.
- **It does not mark the surface-gated exclusions, and that is a decision.** A path behind
  `INCLUDE_MOBILE`, `INCLUDE_RUST`, `INCLUDE_DESKTOP`, `INCLUDE_WAGTAIL` or `INCLUDE_CLICKUP` is
  absent only from a project that declined that surface, so `template-only` would be **false**
  in every project that took it. Those citations keep the prose `rust-only` / `mobile-only` flag
  their guides already carry, and no marker. **Since 09/11/2026 the gate reads the decline
  instead**: each gated `_exclude` entry is parsed into a `gated FLAG path` row of
  the shipping facts, and in a generated project an **absent** target under a gated path whose
  surface `.copier-answers.yml` declined is passed, not reported — and **counted per flag**, in
  the run's output and its verdict, because a green run must not read as "every cited file
  exists". It **fails closed**: a missing answers file, one copier did not write, a key not
  written once at top level, or a non-boolean answer exempts nothing, and the run says why. A taken surface's missing file is an
  ordinary finding; the template reads no answers, since it holds every gated path.
- **It cannot tell, downstream, whether a path under a declined gate is spelt right.** A
  misspelt file under the rust docs passes in a project that declined Rust, because nothing
  there can tell it from a correct one. Such a citation is judged only in the template run.
- **It cannot see whether a marker is _true_.** The token declares that a path does not survive
  generation; nothing proves the writer read `_exclude` before writing it. A marker on a path <!-- doc-references: template-only -->
  that ships is a lie this gate will believe, exactly as `ignore` always has been.
- **It sees a template artefact only by its path or its decision identifier.** A story, map or
  plan named in prose by its title, or a story number written without a path, is Check 2's
  instance rule or nobody's; the artefact class adds no reading of free text beyond the decision
  identifier, and that only where it names a record present in this tree.
- **It cannot tell whether a path that resolves is the _right_ one.** Unchanged from the
  script's own header, and the reason `Cannot tell` is written there.
- **It cannot judge a register row.** That a creator resolves does not mean it creates that
  path. Reviewer's judgement, on the `[judgement]` convention the audit guides use.

## 6. Direction is declared per claim, never per file

> **A disclaimer at the top of a document does not reach a claim in its body.** Direction is a
> property of the sentence, not of the file the sentence sits in.

A file-level note is read once, by the person who wrote it. Every later reader arrives through a
search, a cross-reference or a diff, lands mid-document, and takes the sentence in front of them at
face value. Worse, a reviewer who _has_ read the header credits it with a coverage it never had, so
the contradiction survives the one pass that could have caught it. The document opens with "nothing
here is built yet" and asserts a hundred lines down that a module exists, and neither statement
looks wrong to anybody reading only one of them.

The mechanism is per line for exactly the reason `template-only` is per line (Section 4): a
declaration that cannot be seen from the claim it governs is not a declaration.

Three specimens, measured 20/08/2026 and corrected in the same change as this section — recorded
because the shape recurs, not because those lines still read this way:

| Document                                              | Declared at the top                                  | Asserted in the body                                                                         |
| ----------------------------------------------------- | ---------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| `code/docs/api-design/WEBHOOKS.md`                    | `:17` "Nothing here need be built yet."              | `:159` "matches existing endpoints such as" a view module nothing in this project creates    |
| `how-to/src/SERVER-ARCHITECTURE/EDGE-REQUIREMENTS.md` | `:8` "Do not treat the placeholder values as real."  | `:33` a **Source:** field citing a header comment inside a template file that does not exist |
| `code/docs/design-tokens/EDITOR.md`                   | `:62` the heading "Extension points (not yet built)" | `:68` "The `preview` dry-run endpoint and the `/assets/tokens.css` view already exist"       |

**A heading is not a declaration either.** `EDITOR.md`'s "(not yet built)" sat six lines above the
row that contradicted it, and still did not carry, because the row is what gets quoted, linked and
believed on its own.

**What to do instead**, and the choice between the two is not a matter of taste:

- **The document is entirely forward** — then write each claim in forward voice. "Will be",
  "arrives with", "once X lands" costs three words per sentence and travels with the sentence when
  someone quotes it.
- **The document is mixed** — then mark the forward claims individually and leave the rest alone. A
  blanket header over a mixed document is the worst of the three states available: false for the
  built half, and invisible to the unbuilt half.

## 7. Where each half lives

| Fact                                             | Owner                                                                                       |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| The rule, the two directions, the token grammar  | This file                                                                                   |
| This project's registered paths and creators     | `how-to/src/PROJECT-PATHS.md`                                                               |
| The clauses, exemptions and the `--self-test`    | `code/src/scripts/audits/doc-references.sh`                                                 |
| Which paths are excluded, and conditionally      | `copier.yml` → `_exclude`, parsed and never restated <!-- doc-references: template-only --> |
| What copier seeds and lifts back out, downstream | `code/src/scripts/audits/doc-references-shipping.txt` — generated, never hand-edited        |
| What a gate may claim it looked at               | `code/docs/GATE-REPORTING.md`                                                               |
| The `CONTEXT.md` / `CLAUDE.md` split             | `code/docs/DOCUMENTATION-PAIRING.md`                                                        |

**One source for what ships, read in both trees.** Two facts decide whether a citing file ships:
what copier **seeds** from `.copier/`, and what its exclusion list **lifts back out** of an excluded
tree. A third decides whether a cited file may be absent: which paths a surface flag **gates**, and
what an unanswered flag means — read from the question's own default, since copier omits a question
its `when` skipped. The copier contract is the only place a human states any of them. It is excluded from every
generated project, so the gate cannot read it there — and until 06/11/2026 a project's own
`GAPS.md` and `.claude/MEMORY.md` were policed as shipped files for that reason. The facts are
therefore rendered from the contract into the shipped facts file above, by
`doc-references.sh --write-shipping`; the template's ordinary run reports `[shipping facts]` while
the two disagree, and a generated project reads the file. Check 3's excluded-path set is
deliberately **not** carried: downstream it is empty by decision. The contract counts as present
only where `.copier/` sits beside it, so a project that writes a contract file of its own still
reads the shipped facts.

## Cross-references

- `code/src/scripts/audits/CONTEXT.md` — the audit inventory row, flags and exit codes
- `code/docs/NEGATIVE-SPACE.md` · `how-to/src/INVARIANTS.md` — the first rule/register pair
- `code/docs/architecture/PROVIDER-NEUTRALITY.md` · `how-to/src/PLATFORM-PROVIDERS.md` — the second
