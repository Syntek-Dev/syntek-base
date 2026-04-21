# Mobile App Code — Checklist

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] `code/CONTEXT.md` read — Expo Router conventions applied
- [ ] `code/docs/CODING-PRINCIPLES.md` read — component naming and design rules applied
- [ ] `code/docs/ACCESSIBILITY.md` read — WCAG 2.2 AA requirements noted for all interactive components
- [ ] `code/docs/RESPONSIVE-DESIGN.md` read — mobile viewport tiers and NativeWind breakpoints understood
- [ ] `code/docs/PERFORMANCE.md` read — FlatList, memo, and image optimisation rules applied
- [ ] `code/workflows/01-new-feature/` followed — full-stack feature checklist completed
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Wireframes reviewed — mobile viewport variants (360, 390, 430, 768px portrait) present
- [ ] Component designs reviewed in Figma before implementation begins
- [ ] Existing components in `code/src/mobile/src/components/` and `code/src/shared/` checked before creating new ones
- [ ] TypeScript types regenerated from the current GraphQL schema
- [ ] Screens and routes implemented per the wireframes (Expo Router)
- [ ] Responsive behaviour implemented via `useBreakpoint` hook — no hard-coded sizes
- [ ] All components implement every required state (default, pressed, focused, disabled, error, success, empty)
- [ ] Design tokens applied via NativeWind — no raw hex values or hard-coded sizes
- [ ] Tests written with RNTL + Jest per `code/docs/TESTING.md`
- [ ] Unit test coverage ≥ 75%
- [ ] Render, loading, error, and interaction paths covered by tests
- [ ] Detox E2E tests added for any critical user flows
- [ ] `code/docs/ACCESSIBILITY.md` checklist completed — contrast, focus, ARIA labels, touch targets ≥ 44 × 44 pt
- [ ] Golden path verified visually on simulator or device
- [ ] Edge cases (empty states, error states, loading states) verified
- [ ] Minimum portrait viewports tested: 360, 390, 430, 768px
- [ ] Landscape tested at 932×430 if the screen has a landscape layout
- [ ] Lint passes — no lint errors
- [ ] Type-check passes — no type errors

---

## Definition of Done

- [ ] All acceptance criteria from the user story are covered by passing tests
- [ ] WCAG 2.2 AA compliance confirmed on all interactive components
- [ ] Code committed and pushed
- [ ] Ready for `13-pr-and-review/`
