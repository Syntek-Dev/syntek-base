---
type: guide
skills: [frontend, stack-htmx-templates]
model: opus
---

# Visual Design Language

**Last Updated:** <%DATE%>
**Version:** 0.1.0
**Maintained By:** <%ORG_NAME%>
**Language:** British English (en_GB)
**Status:** Template. Codifies the visual-design discipline across every surface the project ships.

This file is the **index and the cross-surface core**: the mandate, the project's **visual
direction**, and the ban list. Each surface expresses that core in its own stack, in a sub-document
below.

| Sub-document                                           | Surface                                                              |
| ------------------------------------------------------ | -------------------------------------------------------------------- |
| [`visual-design/WEB.md`](visual-design/WEB.md)         | Django templates + django-components + HTMX + Alpine + token CSS     |
| [`visual-design/MOBILE.md`](visual-design/MOBILE.md)   | **Mobile-only.** React Native — platform conformance and adaptivity  |
| [`visual-design/DESKTOP.md`](visual-design/DESKTOP.md) | **Desktop-only.** Slint — the stock-Fluent tell and the style choice |

> **Scope note (template).** Section 1 (the mandate) and **Section 4.1 (the universal tells)** are the generic,
> portable core — they travel to any project unchanged. **Section 4.2 reads against the direction Section 3
> pins**, so it is portable in _shape_ but not in _verdict_. Section 2 (artefact locations), Section 3's direction
> block, and every surface sub-document carry `<%ORG_NAME%>`-level placeholders and generic token
> roles: fill them with the project's real brand system, component vocabulary, and design-artefact
> locations. See [Adopting this guide](#adopting-this-guide).

---

## 1. The mandate (portable)

Every page must be **unmistakably <%ORG_NAME%>**. The default failure mode of machine-authored UI is
the "AI-look": a symmetrical centred hero, one flat background, a single row of three equal cards,
rounded-everything with a soft drop shadow, and no vertical rhythm. It is competent, generic, and
forgettable — and it is a **review gate defect**, peer to the WCAG and HTMX-indicator gates.

The mandate, in one line: **never ship generic, undesigned UI — implement the design that was
already decided, in the direction this project committed to.** You are not inventing a layout; you
are building one.

---

## 2. Implement the design — do not invent it

A page's design is decided **upstream**, at _design-time_ — the PM/design skills run the grilling
interview and produce the artefacts (via Figma MCP / Claude Design; that flow is rooted in the
repo's `DESIGN.md`). Your job is _code-time_: build that intent against the live codebase. Before
writing any template, component, or stylesheet, load the design artefacts for the screen:

| Load                            | For                                                                     |
| ------------------------------- | ----------------------------------------------------------------------- |
| the screen's **wireframe**      | the screen's layout, sections, and content order                        |
| the **component/pattern** specs | each component's states, variants, and composition patterns             |
| the **brand guide**             | the foundations — colour, type, motion, elevation, spacing, icons, logo |

In this repo the artefacts live under `project-management/src/` — wireframes in `08-WIREFRAMES/`,
components in `07-COMPONENTS/`, the brand guide in `06-BRAND-GUIDE/`; adjust to the host project's
own artefact locations.

- **The artefacts are intent; the live code is the built truth.** A project's code drifts from its
  planning once written — the shipped components, styles, tokens, and page structure are the reality
  you extend. Reconcile the wireframe/design against what is actually there: reuse the real
  components and match established conventions; where the code has moved on from the artefact, follow
  the code (and surface the drift), do **not** re-apply a stale design. (Discipline:
  `FRONTEND-CODING-PRINCIPLES.md`.)
- The brand guide's **canonical foundations** (its rendered source of truth) win over any derived
  `.md` spec on conflict.
- **No artefact _and_ no established code pattern?** Then neither the design phase nor the code
  decides it — flag it (route back through the design-artefact workflows, or open a grilling pass);
  do not improvise a generic layout.

---

## 3. The direction — per-project, settled once

**A project commits to a named visual direction before its first wireframe.** Every surface
sub-document expresses that direction, and Section 4.2 reads its bans off the axes below. A direction left
unnamed is not neutrality — it is the vacuum the AI-look fills, which is the failure mode Section 1 exists
to close.

The **name** is free text: the set of viable directions is longer than any list this template could
ship. The **axes** are the closed part — a direction is only committed once every axis carries a
setting, because the axes are what Section 4.2 and the design-time gates bind to.

### This project's direction

**Fill this table at first-time setup (Step 9).** It is the canonical commitment: Section 4.2's verdicts,
every wireframe, `06-brand-guides`, and the slop audit's Section 4.2 leg all read it. A `TBD` left here
is not a neutral default — it is the vacuum described above, and the audit will say so rather than
assume one.

| Field         | Setting                                     |
| ------------- | ------------------------------------------- |
| **Name**      | _TBD — free text, e.g. `editorial`_         |
| **Alignment** | _TBD — `start` … `centred`_                 |
| **Rhythm**    | _TBD — `banded` … `continuous`_             |
| **Contrast**  | _TBD — `quiet` … `loud`_                    |
| **Ornament**  | _TBD — `none` … `restrained` … `rich`_      |
| **Density**   | _TBD — `sparse` … `medium` … `dense`_       |
| **Motion**    | _TBD — `still` … `restrained` … `animated`_ |

### The axes, and two worked directions

| Axis          | Range               | `editorial` (default)   | `classical-symmetric` (alternate) |
| ------------- | ------------------- | ----------------------- | --------------------------------- |
| **Alignment** | start ↔ centred     | start                   | centred                           |
| **Rhythm**    | banded ↔ continuous | banded                  | continuous                        |
| **Contrast**  | quiet ↔ loud        | loud (h1 800 extrabold) | quiet (h1 400, wide tracking)     |
| **Ornament**  | none ↔ rich         | restrained              | rich (rules, frames, drop caps)   |
| **Density**   | sparse ↔ dense      | medium                  | sparse                            |
| **Motion**    | still ↔ animated    | restrained              | still                             |

**`editorial` is the shipped default, not the only answer.** It is what every surface sub-document
is written in, and a project that keeps it changes nothing. A project that does not **must** restate
each sub-document's colour, typography and layout clauses to match its own axes — those clauses are
the default direction made concrete, not house law.

**One direction, expressed three ways.** The direction is committed **here**, once, and never
per-surface: a project is not `editorial` on the web and something else on mobile. What differs
between surfaces is the _expression_, which is why the axes live in this index and the concrete
moves live in the sub-documents.

**Motion is a level here only.** The numeric standard — durations, the easing hierarchy, the
frequency rule and the reduced-motion contract — is **Section 5**, and is not a per-direction choice. The
axis shapes what sits above those floors; it never lifts one.

**`classical-symmetric` — the proven alternate.** It exists to prove the slot is real, and it is
deliberately the inversion of the clause Section 4 used to get wrong: centred, symmetric, quiet, ornamented
— formal rather than journalistic. Under it a centred hero, one continuous background, and a
regular card lattice are all **correct**, and Section 4.2 must not object to any of them. What does _not_
change: every Section 4.1 tell, the token-first law, WCAG 2.2 AA, the focus ring, and the reduced-motion
contract. A direction changes composition; it never buys an exemption from the universal tells or
from accessibility.

_Fill the direction during first-time setup. An unnamed direction is the same defect as an unedited
project brief or a `TBD` brand voice._

**The signature — the direction made concrete** — lives in the surface sub-documents: colour,
typography, layout, eyebrows and pills, elevation, icons and logo. Web:
[`visual-design/WEB.md`](visual-design/WEB.md).

**The signature is an expression of the direction above, never a constant.** Any file outside this
guide that names it — a skill, a workflow step, a checklist — states the direction it is
conditional on, the way `.claude/skills/stack-htmx-templates/SKILL.md` does. A file that asserts
`editorial` composition as universal is a defect: it fails correct work the moment a project picks a
different direction, which is the error Section 4 itself carried until the Section 4.1/Section 4.2 split.

---

## 4. The AI-look — banned patterns

If a page does any of these, it is off-brand — fix it before hand-off.

**The list is in two halves, and the difference matters.** Section 4.1 holds the machine-authored tells:
they are wrong on _every_ direction and _every_ surface, and they travel to any project unchanged.
Section 4.2 holds the deviations, which are only defects **relative to the direction Section 3 pins** — a centred
hero is a defect under `editorial` and correct under `classical-symmetric`. Judging a page against
Section 4.2 without first reading Section 3 produces a verdict on the wrong brand.

### 4.1 Universal tells — banned on every direction (portable)

- **Inline or generic gradients.** **[gate: fail]** A raw `linear-gradient(…)` composed in component styles, a
  purple/violet/indigo or blue→purple ramp, a rainbow mesh, or any colour outside the palette. Brand
  gradients are delivered as `--gradient-*` / `--sector-tone-*` tokens only, in-palette; enforced by
  `code/src/scripts/audits/css-gradients.sh`.
- **Em dashes in body copy.** **[gate: prose]** An em dash (—) in user-facing prose is a machine-authored tell. Reword
  with a comma, colon, full stop, or parentheses; **never** substitute a spaced en dash. (Numeric/day
  ranges like `Mon–Fri` keep their en dash.) See the project brand-voice guide; enforced by
  `code/src/scripts/audits/copy-emdash.sh`.
- **A pill/eyebrow above every heading.** **[gate: warn]** Pills label taxonomy (blog topics, case studies,
  testimonials); a pill on a plain section is filler. The taxonomy rule is direction-independent —
  a direction may change how a pill _looks_, never license one that labels nothing.
- **Emoji in headings or UI chrome.** **[gate: fail]** Icons come from the project's single icon set.
- **Rounded-everything + a soft drop shadow on every element.** **[gate: warn]** Radius and elevation are scaled and
  purposeful, not a default coat. The **uniformity** is the tell, not the value — a direction may
  legitimately sit at zero radius or at a heavy one, but never applies either as a blanket.
- **Undifferentiated buttons** — **[gate: warn]** no primary/secondary hierarchy; ghost buttons everywhere.
- **Filler copy** **[gate: prose]** ("Lorem ipsum", "Empower your business", "Seamless solutions"). Copy is real and
  follows the brand-voice guide — substantiate or cut. The prose leg is
  `code/src/scripts/audits/copy-slop.sh`, which reads the tier markers in
  `how-to/src/BRAND-VOICE.md` Section 4; the em dash above stays `copy-emdash.sh`'s.
- **One device repeated — down a page, or across the screen set** — **[gate: warn]** most often the
  three-equal-card grid. Monotony is the tell on any direction; **which** vocabulary replaces it is
  supplied by Section 3 and the surface sub-document, not by this list. **Deciding it needs a viewport**,
  because the same markup is a one-, two- or three-column device depending on width — so the gate is
  `audits/render-slop.sh` at 1280 px, **web only**: mobile and desktop have no browser to drive.

### 4.2 Direction deviations — banned against the direction Section 3 pins

Each clause below names the axis it reads. Under a direction whose axis sits at the other end, the
clause **does not apply** — and saying so is not a loophole, it is the whole point of naming a
direction.

- **Centred everything** — **[gate: warn]** reads the **alignment** axis. Centred hero headline + subtitle + two pill
  buttons, centred section headings, centred body. A defect where alignment is `start`; **correct**
  where alignment is `centred`.
- **One flat background** for the whole page, no rhythm — **[gate: warn]** reads the **rhythm** axis. A defect where
  rhythm is `banded`; **correct** where rhythm is `continuous`, which achieves separation through
  spacing, rules, or type rather than through bands.

_Under this template's default direction (`editorial`: alignment `start`, rhythm `banded`) both
clauses are live, and the web pre-ship checklist ([`visual-design/WEB.md`](visual-design/WEB.md))
assumes them._

---

## 5. Motion — the numeric standard (portable)

Motion is the one part of this doctrine that is **numeric and surface-agnostic in substance**. The
numbers below hold on every surface; only the _expression_ differs — CSS transitions on the web,
Reanimated on mobile, `animate` blocks in Slint. Each surface sub-document states its expression
and nothing more; the numbers are stated once, here.

These values are what the `motion` token category is populated from — it already carries `base` and
`reduce` axes and the `duration` / `easing` value kinds (`design-tokens/MODEL.md`). Consume the
tokens; never hard-code a duration in a component. **[gate: fail]**

### Standards floor, axes shape

**A standard sets a floor; a direction's axes shape what sits above it.** An `animated` direction
buys more motion in the space the standards leave — it never lifts a floor. This generalises what
Section 3 states case by case: WCAG 2.2 AA, the token-first law, the focus ring, the reduced-motion
contract and the frequency rule below all sit **outside** the axes, and no direction may weaken
them. When an axis and a standard disagree, the standard wins and the axis applies to the
remainder.

### Frequency first — the rule that changes decisions

Duration tables are a lookup; frequency is the decision.

- **An action performed 100+ times a day gets no animation, ever.** **[judgement]** Keyboard-initiated actions are
  named explicitly: they are the high-frequency case by construction.
- **An action performed tens of times a day gets reduced motion** — shorter, smaller, or opacity
  only.
- Everything else may use the full table below.

This is a **floor**, not a preference: it holds under the `animated` end of the motion axis. A
transition a user sees a hundred times a day stops being feedback and becomes latency.

### Durations

| Element                 | Duration  |
| ----------------------- | --------- |
| Button / control press  | 100–160ms |
| Tooltips                | 125–200ms |
| Dropdowns, popovers     | 150–250ms |
| Modals, drawers, sheets | 200–500ms |

**UI animation stays under 300ms.** Modals, drawers and sheets are the named exception, and the
reason is worth keeping: under 300ms is the ceiling for a **response to an input**, whereas a modal
or drawer _introduces a surface_ rather than answering an action. Do not "correct" the table to
remove the overlap.

### Easing — a hierarchy, not a preference

| Motion               | Easing        |
| -------------------- | ------------- |
| Enter / exit         | `ease-out`    |
| Move / morph         | `ease-in-out` |
| Hover                | `ease`        |
| Constant / recurring | `linear`      |

**`ease-in` is prohibited on UI.** **[gate: fail]** It begins slowly, which reads as lag on anything a user is
waiting for.

### What animates, and by how much

- **Only `transform` and `opacity`.** **[gate: fail]** Everything else forces layout or paint.
- **Entry scales start at 0.9–0.97, never 0.** **[gate: warn]** Scaling from nothing reads as a pop, not an arrival.
- **Press feedback is `scale(0.97)` at 160ms.** **[gate: warn]**
- **Stagger is 30–80ms** **[gate: warn]** between siblings. Beyond that a list reads as slow rather than sequenced.

### Reduced motion means fewer and gentler — not none

**Keep opacity and colour transitions; drop transform motion.** Removing every transition is its
own accessibility failure: state changes become instantaneous and unexplained, which is harder to
follow, not easier. The `reduce` axis on the `motion` token category is what carries this — it is a
second set of values, not an off switch.

This is the whole contract, on every surface, non-negotiable and outside the axes.

---

## 6. What a script can decide (portable)

Part of this doctrine is machine-checkable and part is not. Pretending otherwise produces either an
audit that fails correct work or a gate nobody trusts, so **every clause in Section 4 and Section 5 — and every
surface-specific clause in the sub-documents — carries an inline marker naming its tier**. This
section is the rule. It is deliberately **not** a second copy of the clause list: a copy drifts from
the doctrine it partitions.

| Marker              | Behaviour                                                                           |
| ------------------- | ----------------------------------------------------------------------------------- |
| **`[gate: fail]`**  | An unambiguous match. The audit exits 1 and blocks.                                 |
| **`[gate: warn]`**  | Needs a threshold or a ratio. Reported; the audit exits 0.                          |
| **`[judgement]`**   | No script decides it. It belongs to the reviewer, and the audit says so.            |
| **`[gate: prose]`** | A copy tell, owned by `how-to/src/BRAND-VOICE.md` Section 4 — not this audit's leg. |

**Why two gate tiers.** A threshold on composition fails correct work: a taxonomy page legitimately
carries a pill on every section, and a directory page legitimately repeats one card. Warnings keep
that signal visible without a script overruling a designer. Precedent:
`code/src/scripts/audits/cloc.sh` warns at 750 and fails at 800 in one run.

**Section 4.2 reads Section 3, and skips when it cannot.** The direction deviations have no fixed verdict — they
read the axis table in Section 3. If any axis is still `TBD`, the Section 4.2 leg **skips with a warning naming
first-time-setup Step 9**, rather than guessing. An audit that assumed `editorial` would fail every
correct page on a project that chose otherwise.

**The escape hatch is an annotation** — `slop-allow`, as elsewhere in this repo
(`gradient-allow`, `token-allow`) — and what scopes it is **whether the finding has a line**, not
which tier it sits in:

| Finding                                     | Annotate                                    |
| ------------------------------------------- | ------------------------------------------- |
| Has a line (either tier)                    | that line, or the line above                |
| A ratio or a count, decided across a file   | anywhere in the file, **naming the clause** |
| Geometry, decided across the **screen set** | anywhere in **any one member screen**       |

A **rendered** finding has no line at all — geometry is not text — so both of `render-slop.sh`'s
clauses take the file form, and the set clause extends it one step to the set. The honest cost of
that last row: the silence is invisible to someone reading any of the other screens.

**Name the clause: `slop-allow: motion-ease-in — matching a third-party widget's curve`.** A bare
`slop-allow` silences every clause on the line, including one nobody looked at; a qualified one
silences what was argued for and lets the next tell through. Both forms work — bare shipped
first — but bare is the blunt instrument.

**Warnings are annotatable too, and that is the point.** A warning exists because the word or the
ratio is sometimes correct; a writer who earned "a robust seal" should be able to say so once,
in the diff, rather than re-deciding it on every run. What a bare marker deliberately cannot reach
is a file-scoped finding: "this line is fine" is not the same claim as "this page is a taxonomy
index", so the wider claim has to be made explicitly.

**Scope the scan narrowly.** `audits/seam-contract.sh` flagged 34 issues on its first draft, 33 of
them false; the fix was narrowing what it looked at, never softening what it concluded.

The scripts themselves are not specified here — that is the audit register
(`code/src/scripts/audits/CONTEXT.md`) and the workflow that builds them.

---

## Adopting this guide

This guide ships as a template. Section 1 (the mandate) and Section 4.1 (the universal tells) are the portable
core — adopt them unchanged. Section 4.2 is portable in shape but reads its verdict off Section 3, so it is
adopted _with_ the direction, never independently of it.

**Settle the direction first** (Section 3 — first-time setup), then fill the placeholders in Section 2 (the
artefact locations) and in each surface sub-document (the signature and the component catalogue)
with the host project's own brand system, component vocabulary, and design-artefact paths. A project
that keeps `editorial` changes nothing below the direction block; a project that does not **must**
restate each sub-document's colour, typography and layout clauses against its own axes, because
those clauses are the default direction made concrete.

The _shape_ of the guide is the portable part; the _content_ is per-project.

---

## Cross-references

- [`visual-design/CONTEXT.md`](visual-design/CONTEXT.md) — the surface sub-document index
- `DESIGN-TOKENS.md` — the token catalogue and the `var(--token)`-only law
- `ACCESSIBILITY.md` — WCAG 2.2 AA, non-negotiable on every direction and every surface
- `how-to/src/BRAND-VOICE.md` — the copy half of this doctrine; Section 4.1 defers voice there
- `how-to/workflows/01-first-time-setup/` — Step 9 settles Section 3
- `DESIGN.md` (repo root) — the design-time entry point this guide is the code-time counterpart to
