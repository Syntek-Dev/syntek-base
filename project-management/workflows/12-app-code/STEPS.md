# Mobile App Code — Steps

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Review Wireframes and Component Designs

Read the signed-off wireframes from `project-management/src/07-WIREFRAMES/` and the Figma
component designs for the feature area. Ensure mobile viewport variants are present:
360px, 390px, 430px, and 768px portrait as a minimum.

Before writing any code, read:
- `code/CONTEXT.md` — Expo conventions, Expo Router structure, mobile tooling rules
- `code/docs/CODING-PRINCIPLES.md` — component design rules, naming, single-responsibility
- `code/docs/ACCESSIBILITY.md` — WCAG 2.2 AA requirements for React Native
- `code/docs/RESPONSIVE-DESIGN.md` — mobile viewport tiers, NativeWind breakpoints, Maestro E2E minimum viewport set
- `code/docs/PERFORMANCE.md` — FlatList, memo, and image optimisation rules for React Native

Identify:

- Which screens and routes are needed
- Which components are new vs reused (check `code/src/mobile/src/components/` and `code/src/shared/` first)
- The data requirements (queries and mutations from the GraphQL API)

### Step 2 — Regenerate TypeScript Types

Ensure generated types reflect the current API schema:

```bash
bash code/src/scripts/development/codegen.sh
```

Confirm no type errors are introduced by the regeneration.

### Step 3 — Scaffold New Screens

Use the screen generator for each new Expo Router screen:

```bash
bash code/src/scripts/development/new-expo-screen.sh
```

Then follow `code/workflows/01-new-feature/` for the full-stack feature checklist (mobile layer).

```text
/syntek-dev-suite:frontend [describe the screens and routes to implement]
```

- All screens live under `code/src/mobile/app/` (Expo Router)
- Use Apollo Client hooks from `code/src/mobile/src/graphql/generated/`
- Follow the component hierarchy from the wireframes
- Prefer components from `code/src/shared/` before creating mobile-only alternatives

### Step 4 — Implement Components

Build each component against its Figma design. Read `code/docs/CODING-PRINCIPLES.md`
for component naming and structure rules.

- Apply design tokens via NativeWind utility classes — no raw hex values or hard-coded sizes
- Use the `useBreakpoint` hook to adapt layout across the mobile viewport tiers defined in `code/docs/RESPONSIVE-DESIGN.md`
- Implement all required states: default, pressed, focused, disabled, error, success, empty
- Match the annotated accessibility requirements from the component design

### Step 5 — Write Tests

Follow `code/workflows/02-tdd-cycle/` for the red-green-refactor steps.
Read `code/docs/TESTING.md` for RNTL + Jest conventions and Detox E2E setup.

```text
/syntek-dev-suite:test-writer [describe the screens and components to test]
```

Coverage floor: 75% minimum for unit tests.

Unit test cases must cover:

- Render with expected data
- Loading and error states
- User interactions (presses, swipes, form submissions)
- Accessibility — rendered ARIA roles and `accessibilityLabel` values

Add Detox E2E tests for any critical user flow introduced by the feature. Use
`code/src/scripts/tests/e2e.sh` to run the E2E suite.

### Step 6 — Run Tests and Enforce Coverage

```bash
bash code/src/scripts/tests/mobile-coverage.sh
```

Refer to `code/docs/TESTING.md` for the coverage floor (75%) and how to interpret the
coverage report.

### Step 7 — Accessibility Check

Verify WCAG 2.2 AA compliance on all interactive components using the checklist
in `code/docs/ACCESSIBILITY.md`:

- Colour contrast ratios
- Focus management and `accessibilityLabel` props
- Touch target size ≥ 44 × 44 pt (Apple HIG / Android Material guidance)

### Step 8 — Visual Verification

Start the dev server and verify the golden path and edge cases on a simulator or device:

```bash
bash code/src/scripts/development/server.sh up --service mobile
```

Test against the minimum portrait viewports from `code/docs/RESPONSIVE-DESIGN.md`:
360, 390, 430, and 768px. Add 932×430 landscape if the screen has a landscape-specific layout.

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
