# ANTI-SLOP-RULE-SOURCES

**Written**: 04/08/2026 · **Skill**: `research` · **Feeds**: `MAP-DOCTRINE-UPGRADE.md` nodes
N-003, N-004, N-011, N-015, N-018

---

## Question

The AI-slop skill ecosystem is large, free, and almost entirely web/React/Tailwind-shaped. Two
questions must be answered before any of it is internalised into this template:

1. **What concrete, checkable rules do the leading skills actually enforce** — and how much of that
   is deterministic rather than model judgement?
2. **Does any of it cover a non-web surface** (React Native, native desktop), and on what licence
   terms can rule text be carried into a template that is redistributed to client projects?

---

## Verdict

**Rules: derive, do not port.** Six of the eight sources surveyed are licensed permissively
(MIT/Apache-2.0), and every one of those six requires attribution to be retained on
redistribution — and this template is redistributed into every generated project by Copier. The
other two, `anthropics/skills` and `vercel-labs/agent-skills`, carry **no LICENCE file at all**,
which grants no reuse rights whatsoever: they may be read for ideas and never quoted. Deriving our
own rule text from the research and citing sources in `REFERENCES.md` leaves no licence obligation
attached to a client's repository. Verbatim rule text does. Full table: _Licences_, below.

**Cross-surface: only one source has it, and it reframes the problem.** Impeccable is the only
researched skill shipping a native rule set, and its native taxonomy is _not_ the web one
translated — the mobile failure mode is **"web-shaped UI on a native surface"**, which is a
different defect from the web's "centred hero and three equal cards". There is **no off-the-shelf
anti-slop rule set for native desktop at all**; the Slint clause must be authored from the Slint
primary docs. This means the "portable core + per-surface clause" shape is not a convenience — the
surfaces genuinely disagree about what slop _is_.

---

## Claims

### Web rule floor is concrete and numeric

Impeccable's quality floor publishes hard values rather than principles: body measure 65–75ch;
display type max 6rem; letter-spacing floor -0.04em; body/placeholder contrast ≥4.5:1 and large
text ≥3:1; card radius 12–16px; elevation declared as **border or shadow, never both**. Absolute
bans include gradient text, nested cards, "ghost cards" (a 1px border under a wide soft shadow),
same-size icon+heading+text cards used as page structure, sketch-style SVG and `feTurbulence`
grain, and mixed icon stroke weights.
[craft-floor.md](https://raw.githubusercontent.com/pbakaus/impeccable/main/.agents/skills/impeccable/reference/craft-floor.md)

> **Conflict to resolve, not inherit.** Impeccable bans kickers/eyebrows above headings
> _absolutely_. `code/docs/VISUAL-DESIGN.md` §4.1 deliberately permits them for real taxonomy
> (blog topics, case-study categories) and bans only the stamped-on-every-heading case. Ours is
> the more considered rule; the conflict is recorded here so a later reviewer does not "fix" our
> version to match an upstream we did not adopt.
>
> **Resolved by N-013/N-003 (04/08/2026).** The taxonomy rule is **direction-independent**, so it
> sits in §4.1 (universal) rather than §4.2 (direction deviations), with the visual treatment in
> `code/docs/visual-design/WEB.md`. There is nothing left to disagree about: a direction may change
> how a pill _looks_, never license one that labels nothing.

### The native rule set is a different taxonomy, not a translation

Impeccable's native audit checks five dimensions against platform references: accessibility
(VoiceOver/TalkBack semantics, Dynamic Type vs fixed point sizes, touch targets under 44pt iOS /
48dp Android, reduce-motion alternatives); performance (unvirtualised lists, main-thread blocking
in gesture paths, dropped frames, unnecessary re-renders); appearance (hard-coded hex instead of
semantic system colours or tokens, missing dark-mode variants); **platform conformance** —
web-shaped buttons, hover-dependent affordances, non-native navigation, content under the
notch/Dynamic Island/home indicator, hijacked edge-swipe-back and predictive Back, mixed icon sets
instead of SF Symbols / Material Symbols; and adaptivity (size classes, landscape, IME occlusion,
Split View, foldable hinge posture).
[audit.native.md](https://raw.githubusercontent.com/pbakaus/impeccable/main/.agents/skills/impeccable/reference/audit.native.md)

Platform conformance has no web analogue, and the web's layout-composition rules have no native
analogue. The two rule sets overlap only on colour tokens, contrast, and motion.

### Motion rules are fully numeric and portable

The strictest published motion standard is frequency-first: an action performed 100+ times a day
gets **no animation ever** (keyboard-initiated actions named explicitly); tens of times a day gets
it reduced. Durations by element: button press 100–160ms, tooltips 125–200ms, dropdowns 150–250ms,
modals/drawers 200–500ms, with UI animation **under 300ms** as the ceiling. Easing is a decision
hierarchy — enter/exit `ease-out`, move/morph `ease-in-out`, hover `ease`, constant `linear` — and
**`ease-in` is prohibited on UI**. Entry scales start at 0.9–0.97 and never 0; press feedback is
`scale(0.97)` at 160ms; stagger is 30–80ms. Only `transform` and `opacity` are animated. Reduced
motion means _fewer and gentler_, not zero — keep opacity and colour, drop transform motion.
[review-animations/STANDARDS.md](https://raw.githubusercontent.com/emilkowalski/skills/main/skills/review-animations/STANDARDS.md)

These are surface-agnostic in substance; only the expression differs (CSS transitions, Reanimated,
Slint `animate`).

### Prose slop is a structural taxonomy, largely greppable

The prose tells are structural, not vocabulary: binary contrasts ("It's not X. It's Y."), negative
listing, dramatic fragmentation ("X. That's it."), rhetorical setups ("What if…?", "Here's what I
mean:"), false agency ("the decision emerges"), narrator-from-a-distance, passive voice, wh-
sentence starters, three-item list rhythm, lazy extremes (every/always/never), and adverbs. Applied
with a five-dimension rubric — directness, rhythm, trust, authenticity, density — revising below
35/50.
[structures.md](https://raw.githubusercontent.com/hardikpandya/stop-slop/main/references/structures.md)
· [stop-slop README](https://raw.githubusercontent.com/hardikpandya/stop-slop/main/README.md)

This project already enforces exactly one of these (the em dash, via
`code/src/scripts/audits/copy-emdash.sh`). Most of the rest are grep-shaped; the rubric is not.

### A Slint app that chooses nothing ships Microsoft Fluent

From **Slint 1.16, Fluent is the default style on all platforms**, and the other built-in styles
(Cupertino, Material, Qt, Native) receive fewer updates and are being deprecated; the stated reason
is the cost of maintaining five parallel widget implementations.
[Slint blog — default style change](https://slint.dev/blog/default-native-style-change)
Style is fixed at **compile time** via the `SLINT_STYLE` environment variable or
`slint_build::compile_with_config()`; the documented route to a custom look is consuming the
`Palette` and `StyleMetrics` globals in your own components rather than leaning on `std-widgets`.
[Slint — widget styles](https://docs.slint.dev/latest/docs/slint/reference/std-widgets/style/)

This repository pins Slint **1.17** (`REFERENCES.md`), so the desktop slop tell is precise and
verifiable: **an app that sets no style and composes from bare `std-widgets` ships as stock
Fluent** — the desktop equivalent of untouched shadcn.

### The living-brief format is already a de-facto standard

The widely-copied `DESIGN.md` brief format is nine sections: Visual Theme & Atmosphere · Colour
Palette & Roles · Typography Rules · Component Stylings · Layout Principles · Depth & Elevation ·
Do's and Don'ts · Responsive Behaviour · Agent Prompt Guide.
[awesome-claude-design](https://raw.githubusercontent.com/VoltAgent/awesome-claude-design/main/README.md)
Named visual directions ship as separate skills — brutalist, minimalist, soft, high-end visual.
[taste-skill](https://github.com/Leonxlnx/taste-skill)

Our root `DESIGN.md` currently carries none of these nine — it is a routing index of guides,
workflows, and Figma MCP patterns. The nine-section shape is what makes a brief _consumable_ by
Claude Design and the Figma MCP as a brief rather than a table of contents.

### Licences, verified against the GitHub API on 04/08/2026

| Source                                 | Stars  | Licence             | Obligation if text is carried                   |
| -------------------------------------- | ------ | ------------------- | ----------------------------------------------- |
| `pbakaus/impeccable`                   | 54.8k  | Apache-2.0          | Attribution + NOTICE retained on redistribution |
| `Leonxlnx/taste-skill`                 | 71.5k  | MIT                 | Copyright + permission notice retained          |
| `emilkowalski/skills`                  | 24.6k  | MIT                 | Copyright + permission notice retained          |
| `hardikpandya/stop-slop`               | 15.0k  | MIT                 | Copyright + permission notice retained          |
| `Nutlope/hallmark`                     | 21.4k  | MIT                 | Copyright + permission notice retained          |
| `nextlevelbuilder/ui-ux-pro-max-skill` | 113.3k | MIT                 | Copyright + permission notice retained          |
| `anthropics/skills`                    | 166.2k | **no LICENSE file** | Unlicensed — do not copy text                   |
| `vercel-labs/agent-skills`             | 29.7k  | **no LICENSE file** | Unlicensed — do not copy text                   |

Every obligation above propagates through Copier into each generated client project. Deriving our
own rule text avoids all of them; the two unlicensed sources may be read for ideas but never
quoted.

---

## Sources

- Impeccable craft floor — <https://raw.githubusercontent.com/pbakaus/impeccable/main/.agents/skills/impeccable/reference/craft-floor.md>
- Impeccable native audit — <https://raw.githubusercontent.com/pbakaus/impeccable/main/.agents/skills/impeccable/reference/audit.native.md>
- Animation standards — <https://raw.githubusercontent.com/emilkowalski/skills/main/skills/review-animations/STANDARDS.md>
- Prose structures — <https://raw.githubusercontent.com/hardikpandya/stop-slop/main/references/structures.md>
- Slint default style change — <https://slint.dev/blog/default-native-style-change>
- Slint widget styles — <https://docs.slint.dev/latest/docs/slint/reference/std-widgets/style/>
- DESIGN.md brief format — <https://raw.githubusercontent.com/VoltAgent/awesome-claude-design/main/README.md>
- Licence and star data — GitHub REST API, `repos/{owner}/{repo}`, retrieved 04/08/2026
