# DESIGN.md

**Project**: <%PROJECT_NAME%> Website | **Last Updated**: <%DATE%> | **Maintained By**: <%ORG_NAME%>
**Stack** (ADR-019): Django Templates + django-components · HTMX · Alpine.js · Vanilla CSS (design tokens). Server-rendered throughout — no client-side framework, no bundler.

This file is the **design-time** entry point for all design work — the quick context source when producing wireframes and component designs with the Figma MCP or Claude Design. It maps the relevant standards, guides, and workflows, and points those tools at the brand and component sources they should read.

**Design-time → code-time.** DESIGN.md governs the _design_ phase (produce the artefacts); its code-time counterpart is [`code/docs/VISUAL-DESIGN.md`](code/docs/VISUAL-DESIGN.md), which governs _implementing_ those artefacts against the live codebase. The two are one pipeline:

- **Design-time (here):** Figma MCP / Claude Design read [`project-management/src/06-BRAND-GUIDE/`](project-management/src/06-BRAND-GUIDE) (foundations — colour, type, motion, spacing, icons, logo) and [`project-management/src/07-COMPONENTS/`](project-management/src/07-COMPONENTS) (component designs, states, variants) to produce the wireframes in [`project-management/src/08-WIREFRAMES/`](project-management/src/08-WIREFRAMES).
- **Code-time ([VISUAL-DESIGN.md](code/docs/VISUAL-DESIGN.md)):** the `frontend` agent implements those artefacts — grounded in the live code, which drifts from planning — in the <%PROJECT_NAME%> visual signature.

---

## Design Standards

### Code Layer — Standards & Guides

| Guide                                                                      | Purpose                                                                                    |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [`code/docs/VISUAL-DESIGN.md`](code/docs/VISUAL-DESIGN.md)                 | <%PROJECT_NAME%> visual language — anti-generic layout, signature, design-artefact routing |
| [`code/docs/ACCESSIBILITY.md`](code/docs/ACCESSIBILITY.md)                 | WCAG 2.2 AA requirements for all interactive frontend components                           |
| [`code/docs/RESPONSIVE-DESIGN.md`](code/docs/RESPONSIVE-DESIGN.md)         | Breakpoints, fluid layouts, mobile-first patterns                                          |
| [`code/docs/ARCHITECTURE-PATTERNS.md`](code/docs/ARCHITECTURE-PATTERNS.md) | Component architecture, composition patterns, shared UI conventions                        |
| [`code/docs/CODING-PRINCIPLES.md`](code/docs/CODING-PRINCIPLES.md)         | Code quality standards that apply to UI components                                         |
| [`code/docs/PERFORMANCE.md`](code/docs/PERFORMANCE.md)                     | Rendering performance, animation budgets, image optimisation                               |
| [`code/docs/TESTING.md`](code/docs/TESTING.md)                             | Component testing standards — pytest through the Django test client                        |

### Project Management Layer — Standards & Guides

| Guide                                                                                                          | Purpose                                                                        |
| -------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| [`project-management/docs/RESPONSIVE-DESIGN.md`](project-management/docs/RESPONSIVE-DESIGN.md)                 | Responsive design decisions and rationale at the PM/design level               |
| [`project-management/docs/SEO-CHECKLIST.md`](project-management/docs/SEO-CHECKLIST.md)                         | SEO requirements for all public pages                                          |
| [`project-management/docs/GDPR-GUIDE.md`](project-management/docs/GDPR-GUIDE.md)                               | Consent UI, data collection forms, privacy notices                             |
| [`project-management/docs/QA-GUIDE.md`](project-management/docs/QA-GUIDE.md)                                   | QA expectations for frontend features                                          |
| [`project-management/src/06-BRAND-GUIDE/BRAND-VOICE.md`](project-management/src/06-BRAND-GUIDE/BRAND-VOICE.md) | Brand voice & copy — tone, registers, casing, cadence for all user-facing text |

---

## Design Workflows

### Project Management Layer — Design & Planning

| Workflow                                                                                                             | Purpose                                                     |
| -------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [`project-management/workflows/05-user-flow-design/`](project-management/workflows/05-user-flow-design/CONTEXT.md)   | Define user journeys before implementation begins           |
| [`project-management/workflows/06-brand-guides/`](project-management/workflows/06-brand-guides/CONTEXT.md)           | Establish colour, typography, spacing, and tone             |
| [`project-management/workflows/07-component-designs/`](project-management/workflows/07-component-designs/CONTEXT.md) | Design individual UI components with states and variants    |
| [`project-management/workflows/08-wireframes/`](project-management/workflows/08-wireframes/CONTEXT.md)               | Low- and mid-fidelity wireframes for layout decisions       |
| [`project-management/workflows/09-gdpr-compliance/`](project-management/workflows/09-gdpr-compliance/CONTEXT.md)     | GDPR-compliant UI patterns — consent, data forms, notices   |
| [`project-management/workflows/11-qa-checks/`](project-management/workflows/11-qa-checks/CONTEXT.md)                 | QA verification before a feature ships                      |
| [`project-management/workflows/20-frontend-code/`](project-management/workflows/20-frontend-code/CONTEXT.md)         | Translating designs into Django templates + components      |
| [`project-management/workflows/22-pr-and-review/`](project-management/workflows/22-pr-and-review/CONTEXT.md)         | PR review process including visual and accessibility checks |
| [`project-management/workflows/23-release/`](project-management/workflows/23-release/CONTEXT.md)                     | Cutting a release after all design and frontend work ships  |

### Code Layer — Implementation Workflows

| Workflow                                                                     | Purpose                                                   |
| ---------------------------------------------------------------------------- | --------------------------------------------------------- |
| [`code/workflows/01-new-feature/`](code/workflows/01-new-feature/CONTEXT.md) | Full cycle for implementing a new frontend feature        |
| [`code/workflows/02-tdd-cycle/`](code/workflows/02-tdd-cycle/CONTEXT.md)     | TDD for UI components — write tests first, then implement |
| [`code/workflows/07-review/`](code/workflows/07-review/CONTEXT.md)           | Code review checklist with UI-specific checks             |
| [`code/workflows/11-refactor/`](code/workflows/11-refactor/CONTEXT.md)       | Refactoring UI components without regressions             |

### Design Skills

| Skill                                                                    | When to use                                                                                      |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| [`.claude/skills/prototype/SKILL.md`](.claude/skills/prototype/SKILL.md) | A throwaway spike to answer one open design question before committing to a real build           |
| [`.claude/skills/wayfinder/SKILL.md`](.claude/skills/wayfinder/SKILL.md) | Chart a large, ambiguous epic into a decision map resolved across sessions before decomposing it |

---

## Key Source Paths

| Path                                     | Contents                                                       |
| ---------------------------------------- | -------------------------------------------------------------- |
| `code/src/django/apps/marketing/`        | Public page views + Django templates (SSR)                     |
| `code/src/django/components/`            | django-components server component library (`{% component %}`) |
| `code/src/django/static/css/tokens/`     | Design token CSS (consumed as `var(--token)`)                  |
| `project-management/src/06-BRAND-GUIDE/` | Brand foundations (canonical `DESIGN/Foundations*.html`)       |
| `project-management/src/07-COMPONENTS/`  | Component designs — states, variants, patterns                 |
| `project-management/src/08-WIREFRAMES/`  | Screen wireframes (`WF-###`)                                   |

---

## Figma MCP Patterns

These rules apply to all `use_figma` scripts run via the Figma MCP server.

### Never use an async IIFE

`(async () => { await ...; })()` returns a Promise immediately. The Figma MCP plugin commits changes at script end — before the Promise resolves — so all async work inside the IIFE is silently discarded.

**Always use top-level `await`:**

```javascript
// Correct — top-level await, all async work first
await Promise.all([figma.loadFontAsync({ family: "Inter", style: "Regular" })]);
const [comp] = await Promise.all([figma.importComponentByKeyAsync("abc123")]);

// All subsequent code is synchronous — committed at script end
for (const item of items) {
  const frame = figma.createFrame();
  // … populate frame …
}
```

### Appending to a non-current page

`pageNode.appendChild(frame)` works correctly even when the target page is not the currently active Figma page. Use `figma.root.children.find()` to get the page node, then append directly — no page switch needed:

```javascript
const homePage = figma.root.children.find((p) => p.name === "Home");
homePage.appendChild(frame); // persists correctly
```

`setCurrentPageAsync` does not persist across script runs — the MCP plugin's `figma.currentPage` is fixed to whichever page was active when the plugin first loaded.

### Reading children of a non-current page across script runs

`pageNode.children` consistently returns `[]` in a fresh script run for non-current pages, even when the page contains many nodes. Within the same script run, mutations are visible in `children`. Across runs, use `get_metadata` via the Figma MCP to read node IDs from non-current pages.

---

## Design Constraints

- **Accessibility**: WCAG 2.2 AA on all interactive components — see [`code/docs/ACCESSIBILITY.md`](code/docs/ACCESSIBILITY.md)
- **Responsive**: Mobile-first; breakpoints defined in [`code/docs/RESPONSIVE-DESIGN.md`](code/docs/RESPONSIVE-DESIGN.md)
- **SEO**: All public pages require meta, OG, and structured data — see [`project-management/docs/SEO-CHECKLIST.md`](project-management/docs/SEO-CHECKLIST.md)
- **GDPR**: Consent UI and data forms must follow [`project-management/docs/GDPR-GUIDE.md`](project-management/docs/GDPR-GUIDE.md)
- **Styling**: Vanilla CSS with design tokens (`var(--token)` only) — no inline styles, no utility frameworks, no Tailwind
- **Shared UI**: Prefer an existing `code/src/django/components/` component before creating a new one
- **Implementation fidelity**: Ground in the live code — it drifts from planning; reconcile the wireframe/design against the shipped components and tokens — see [`code/docs/VISUAL-DESIGN.md`](code/docs/VISUAL-DESIGN.md) and [`code/docs/FRONTEND-CODING-PRINCIPLES.md`](code/docs/FRONTEND-CODING-PRINCIPLES.md)
- **Tooling**: Run the project scripts before commit — `code/src/scripts/syntax/lint.sh`, `format.sh`, `check.sh`, plus `code/src/scripts/audits/css-tokens.sh` and `css-gradients.sh`
- **Language**: British English (en_GB) in all copy and labels
