# Frontend Code — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Review Wireframes and Component Designs

Read the signed-off wireframes from `project-management/src/07-WIREFRAMES/` and the Figma
component designs for the feature area.

Before writing any code, read:
- `code/CONTEXT.md` — Next.js conventions, App Router structure, frontend tooling rules
- `code/docs/CODING-PRINCIPLES.md` — component design rules, naming, single-responsibility
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements for all interactive components
- `code/docs/RESPONSIVE-DESIGN.md` — breakpoint tokens, media vs container query guidance, and the web viewport test set
- `code/docs/PERFORMANCE.md` — lazy loading, bundle size, and Core Web Vitals rules

Identify:

- Which pages and routes are needed
- Which components are new vs reused (check `code/src/frontend/src/components/` first)
- The data requirements (queries and mutations from the GraphQL API)

### Step 2 — Regenerate TypeScript Types

Ensure generated types reflect the current API schema:

```bash
bash code/src/scripts/development/codegen.sh
```

Confirm no type errors are introduced by the regeneration.

### Step 3 — Implement Pages and Routes

Follow `code/workflows/01-new-feature/` for the full-stack feature checklist.

```text
/syntek-dev-suite:frontend [describe the pages and routes to implement]
```

- All pages live under `code/src/frontend/src/app/` (Next.js App Router)
- Use Apollo Client hooks from `code/src/frontend/src/graphql/generated/`
- Follow the component hierarchy from the wireframes

### Step 4 — Implement Components

Build each component against its Figma design:

- Apply design tokens via CSS variables and Tailwind utility classes — no raw hex values
- Implement all required states (default, hover, focus, disabled, error, success, empty)
- Match the annotated accessibility requirements from the component design
- Follow naming and structure conventions in `code/docs/CODING-PRINCIPLES.md`

### Step 5 — Write Tests

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.

```text
/syntek-dev-suite:test-writer [describe the components and pages to test]
```

Refer to `code/docs/TESTING.md` for Vitest + React Testing Library conventions.
Coverage floor: 70% minimum.

Test cases must cover:

- Render with expected data
- Loading and error states
- User interactions (clicks, form submissions, keyboard navigation)
- Accessibility — rendered ARIA roles and focus management

### Step 6 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/frontend-coverage.sh
```

### Step 7 — Accessibility Check

Verify WCAG 2.2 AA compliance on all interactive components using the full checklist
in `code/docs/ACCESSIBILITY.md`:

- Colour contrast ratios
- Keyboard navigability and focus order
- Screen reader labels (ARIA)

### Step 8 — Visual Verification

Start the dev server and verify the golden path and edge cases in the browser:

```bash
bash code/src/scripts/development/server.sh up --service frontend
```

Use `mcp__claude-in-chrome__*` for automated visual verification where applicable.

### Step 9 — Lint and Type-Check

```bash
bash code/src/scripts/syntax/lint.sh
bash code/src/scripts/syntax/check.sh
```

### Step 10 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
