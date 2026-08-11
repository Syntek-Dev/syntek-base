# Brand Voice — How <%ORG_NAME%> Writes

**Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%> | **Language**: British English (en_GB)

How every word this project shows a human is written: tone, the four registers, casing,
punctuation, and the machine-authored tells that are banned outright.

**Settle this before the first feature.** It is a prerequisite artefact, in the same class as the
project brief and the two architecture snapshots — and it comes **early** in that set, because the
other prerequisite documents are themselves written in this voice. A voice decided after ten
features is a voice retrofitted onto copy nobody will go back and rewrite.

> **This guide ships as a template.** § 1 and § 4 are the **portable core** — adopt them
> unchanged. § 3 and § 5 carry placeholders to fill with this project's own voice. The _shape_
> is portable; the _content_ is per-project. Same split as `code/docs/VISUAL-DESIGN.md`, which is
> this guide's visual half.

---

## 1. The mandate (portable)

Copy is not decoration applied after the design. It is the product's half of the conversation,
and it is where machine authorship is most obvious and least forgivable — a generic sentence
reads as generic in a way a generic margin does not.

The mandate, in one line: **write like a person who knows the reader's job, not like a system
describing itself.**

Two failure modes, equally bad:

- **Marketing voice on a product surface** — an error message that sells.
- **System voice on a marketing surface** — a hero paragraph that reads like a changelog.

Which one applies is decided by the **register** (§ 5), never by preference.

---

## 2. Use the voice — do not invent it

If a copy decision is not answered here, it is answered in the brand work under
`project-management/src/06-BRAND-GUIDE/`, not improvised in the template you happen to be
editing. Two writers inventing tone independently is how a product ends up sounding like two
products.

| You need                             | Read                                                          |
| ------------------------------------ | ------------------------------------------------------------- |
| Tone, register, mechanics            | This file                                                     |
| The visual half of the same doctrine | `code/docs/VISUAL-DESIGN.md`                                  |
| Per-story copy decisions             | `project-management/src/06-BRAND-GUIDE/`                      |
| Where copy is allowed to live        | `code/docs/RENDERING.md` · `code/docs/api-design/` for errors |
| **The shape of a page's body**       | `code/docs/discoverability/CONTENT-STRUCTURE.md`              |

**Shape is not voice.** Whether the answer comes first, and whether a heading is worded as a
question, is decided by `CONTENT-STRUCTURE.md`; the register that answer is written in is decided
here. Neither file restates the other.

---

## 3. The <%ORG_NAME%> voice — per-project

_Fill this section during first-time setup. The placeholders are deliberate: an unfilled voice
section is the same defect as an unedited project brief._

| Axis          | This project's setting                                                        |
| ------------- | ----------------------------------------------------------------------------- |
| **Tone**      | _TBD — e.g. plain, direct, quietly confident. Name three adjectives, no more_ |
| **Person**    | _TBD — "we" or the product's name; second person for the reader_              |
| **Formality** | _TBD — where it sits between contractions-always and contractions-never_      |
| **Reader**    | _TBD — the named user from the brief in the root `CONTEXT.md`_                |
| **Signature** | _TBD — the one habit that makes this project's copy recognisable_             |
| **Never**     | _TBD — the tone this project must never take, and why_                        |

**Vocabulary — say this, not that.** _Fill with the terms this domain gets wrong. One canonical
word per concept; the rejected synonyms belong in the nearest `CONTEXT.md` glossary
(`code/docs/data-structures/DOMAIN-MODELLING.md`)._

| Say   | Not   | Because |
| ----- | ----- | ------- |
| _TBD_ | _TBD_ | _TBD_   |

---

## 4. The machine-authored tells — banned (portable)

These are banned in **user-facing copy** on every surface. They are the prose equivalent of the
AI-look in `code/docs/VISUAL-DESIGN.md` § 4.

**Scope, stated precisely:** this section governs copy a **user reads** — marketing pages,
product UI, notifications, support articles, SEO metadata. It does **not** govern instructional
documentation, code comments, commit messages, or ADRs, which are written for engineers and use
ordinary technical prose. Applying § 4 to this repository's own guides would be a category error.

**Each clause carries its enforcement tier inline**, on the scheme `code/docs/VISUAL-DESIGN.md`
§ 6 defines — `[gate: fail]` blocks, `[gate: warn]` reports, `[judgement]` belongs to a reader and
no script decides it. The markers live here rather than in a second list, because a copy of a ban
list drifts from the doctrine it partitions and then fails correct work. Two scripts read them:
`copy-emdash.sh` owns the em dash, `copy-slop.sh` owns the rest of what a script can decide.

### Punctuation

- **No em dash (—) in user-facing copy.** **[gate: fail]** Reword: a comma, colon, full stop,
  parentheses, or a restructured clause. **Never substitute a spaced en dash** — that is the same
  tell wearing a hat. Numeric and day ranges (`Mon–Fri`, `9–5`) keep their en dash; those are
  correct typography, not prose. Enforced by `code/src/scripts/audits/copy-emdash.sh`.
- No triple-dot ellipsis for drama. **[gate: fail]** Loading states are the exception, and say so
  with a `slop-allow` comment. Only the ASCII `...` is gated; `…` is correct typography.
- No exclamation marks outside genuine celebration (one per surface, at most). **[gate: warn]**
  A count is not a verdict — the second one may be the genuine celebration.

### Sentence patterns

- **No "not just X, but Y."** **[gate: fail]** The single most recognisable machine cadence in
  English.
- **No tricolon by default** — "fast, simple, and secure". **[judgement]** Three-item lists are
  fine when there are genuinely three things; they are a tell when the third is filler, and only a
  reader knows which this is.
- **No "in today's fast-paced world"** or any scene-setting opener. **[gate: fail]** Start at the
  point.
- **No rhetorical question openers** — "Ever wondered why…?" **[gate: fail]** on the **named**
  openers (_ever wondered_, _have you ever_, _what if I told you_, _sound familiar_, _tired of_),
  in opener position; the category stays **[judgement]**, because "How do I reset my password?" is
  a correct support heading and "Ready to get started?" is a legitimate CTA. Same split as the
  scene-setting clause above: the phrase is gated, the category is not.
- **No "it's not about X. It's about Y."** **[gate: fail]**

### Vocabulary

- **No unearned superlatives** — _seamless, effortless, powerful, robust, cutting-edge,
  world-class, revolutionary, game-changing, unparalleled_. **[gate: warn]** If the claim is real,
  state the fact instead: not "blazingly fast", but the number. Warned rather than failed because
  the word is sometimes right: a robust seal really is robust, and only a reader knows whether the
  claim was earned or merely asserted.
- **No corporate verbs** — _leverage, utilise, empower, unlock, elevate, streamline, delve_.
  **[gate: warn]** Use, use, let, open, improve, simplify, look at. Warned for the same reason — an
  account really can be unlocked.
- **No hedging stacks** — "may potentially be able to". **[gate: warn]** Choose one modal or none.
  Two hedges inside a four-word window is the signal. The weakest tell in this section — stacked
  modals are a bad-writing signature more than a machine one, and cautious copy is occasionally
  the honest choice — so it warns and is freely annotated away.

### Structure

- No heading that restates the sentence beneath it. **[judgement]**
- No summary paragraph that repeats what the reader just read. **[judgement]**
- No bold applied to whole sentences. Bold the term, not the thought. **[gate: warn]** — and
  enforced by **`template-slop.sh`**, not the copy audit, because its input is markup
  (`<strong>`/`<b>`). A bolded lede is a real editorial device, so it warns.

**What the scripts reach, and what they do not.** `copy-slop.sh` implements every `[gate: fail]`
and `[gate: warn]` clause above except two that belong elsewhere by **input language**: the em
dash is `copy-emdash.sh`'s, and whole-sentence bold is `template-slop.sh`'s. Every `[judgement]`
clause needs the meaning of the surrounding copy, which no grep has — they belong to the writer
and the reviewer, and a clean audit run does not mean they were honoured.

**Silencing one you meant.** Both tiers are annotatable, on the offending line or the line above:

```text
slop-allow: ellipsis-triple-dot — a loading state, the one § 4 exception
slop-allow: superlative, corporate-verb — quoting the client's own product name
```

Name the clause. A bare `slop-allow` silences everything on that line, including a tell nobody
looked at. `exclamation-count` is decided across a whole file and so takes a file-scoped
annotation — the clause named, anywhere in the file. Full rule: `code/docs/VISUAL-DESIGN.md` § 6.

---

## 5. The four registers

One voice, four registers. The register is set by **where the words appear**, not by who writes
them, and getting it wrong is the most common copy defect in a shipped feature.

| Register         | Where                                                        | Sounds like                                                         | Owned by                          |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------------- | --------------------------------- |
| **Marketing**    | Public pages (`apps.marketing`), OG text                     | Confident, specific, benefit-first. Claims are checkable            | `frontend` · `seo`                |
| **Product**      | In-app UI: labels, buttons, empty states, validation, errors | Terse, literal, actionable. Says what happened and what to do next  | `frontend` · `mobile` · `desktop` |
| **Notification** | Email, SMS, push, in-app alerts                              | The product register, plus a reason it arrived and a way to stop it | `notifications`                   |
| **Support**      | Help articles, FAQs, troubleshooting, release notes          | Patient, procedural, assumes no context. Second person throughout   | `support-articles`                |

**Two things that are not a fifth register:**

- **SEO metadata** (`<title>`, meta description, JSON-LD text) is the **marketing register under
  hard constraints** — character limits, front-loaded, superlatives banned outright rather than
  merely discouraged. Owned by `seo`.
- **Microcopy** is the **product register at its shortest** — a button label, a field hint, an
  error. Rules that bite hardest here: no superlatives, no apology theatre ("Oops! Something went
  wrong."), and an error names the cause and the next action or it is not finished. Owned by
  `frontend`, `mobile`, `desktop`; `notifications` routes here for notification microcopy.

---

## 6. Mechanics

- **British English (en_GB)** in all copy and documentation. Application locale is <%LOCALE%>;
  where the two differ, copy follows the application locale and documentation stays en_GB.
- **Sentence case** for headings, buttons, labels, and navigation. Title Case is reserved for
  proper nouns and product names.
- **No Oxford comma** unless its absence creates ambiguity.
- **Dates** DD/MM/YYYY in copy; ISO 8601 in machine-readable output.
- **Numbers** — words below 10, numerals from 10, always numerals with units.
- **Currency** — <%CURRENCY%>, symbol before the figure, no space.
- **Contractions** are allowed in the marketing and support registers; the product register
  prefers the shorter form regardless.
- **Never use a placeholder in shipped copy** — no "Lorem ipsum", no "TODO: real copy". An empty
  string ships better than filler, because it is visibly wrong.

---

## 7. Pre-ship checklist

- [ ] Every user-facing string is in the register its surface demands (§ 5)
- [ ] No em dash in user-facing copy; no spaced en dash substituted
- [ ] No banned sentence pattern or superlative from § 4
- [ ] Headings and buttons in sentence case
- [ ] Every error names a cause and a next action
- [ ] Claims are checkable; numbers replace adjectives where a number exists
- [ ] British English spelling throughout
- [ ] `bash code/src/scripts/audits/copy-emdash.sh` passes
- [ ] `bash code/src/scripts/audits/copy-slop.sh` passes; its warnings read and answered, not
      merely seen — a warning is a question, and leaving it unanswered is how a gate stops meaning
      anything
- [ ] The `[judgement]` clauses checked by a human, because no script did

---

## Adopting this guide

§ 1 (the mandate) and § 4 (the banned tells) are the **portable core** — adopt them unchanged.
Fill § 3 (tone, person, formality, reader, signature, vocabulary) and the placeholders in § 5
with this project's own voice during first-time setup. Revisit § 3 when the brand work in
`project-management/src/06-BRAND-GUIDE/` produces a fuller answer; the two must not contradict.

## Cross-references

- `code/docs/VISUAL-DESIGN.md` — the visual half of this doctrine; § 4.1 there defers voice here, and
  its § 3 direction is settled at first-time setup Step 9, immediately after this file's § 3 (Step 8)
- `code/src/scripts/audits/copy-emdash.sh` — the em dash clause, enforced on its own
- `code/src/scripts/audits/copy-slop.sh` — every other § 4 clause a script can decide, at the
  tier each carries inline; the register entry is `code/src/scripts/audits/CONTEXT.md`
- `project-management/src/06-BRAND-GUIDE/` — the per-story brand work that refines § 3
- `code/docs/data-structures/DOMAIN-MODELLING.md` — where a canonical term is recorded
- `how-to/workflows/01-first-time-setup/` — the workflow that settles this before the first feature
- `DESIGN.md` — the design entry point that indexes this guide
