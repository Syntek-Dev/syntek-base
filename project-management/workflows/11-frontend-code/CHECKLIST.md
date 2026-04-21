# Frontend Code — Checklist

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] `code/CONTEXT.md` read — Next.js App Router conventions applied
- [ ] `code/docs/CODING-PRINCIPLES.md` read — component naming and design rules applied
- [ ] `code/docs/ACCESSIBILITY.md` read — WCAG 2.2 AA requirements noted for all interactive components
- [ ] `code/docs/PERFORMANCE.md` read — lazy loading and bundle size rules applied
- [ ] `code/workflows/01-new-feature/` followed — full-stack feature checklist completed
- [ ] `code/workflows/02-tdd-cycle/` followed — tests written before implementation (no stubs)
- [ ] Wireframes and component designs reviewed before implementation begins
- [ ] Existing components in `code/src/frontend/src/components/` checked before creating new ones
- [ ] TypeScript types regenerated from the current GraphQL schema
- [ ] Pages and routes implemented per the wireframes
- [ ] All components implement every required state (default, hover, focus, disabled, error, success, empty)
- [ ] Design tokens applied via CSS variables and Tailwind — no raw hex values or hard-coded sizes
- [ ] Tests written with Vitest and React Testing Library per `code/docs/TESTING.md`
- [ ] Test coverage ≥ 70%
- [ ] Render, loading, error, and interaction paths covered by tests
- [ ] `code/docs/ACCESSIBILITY.md` checklist completed — colour contrast, focus, ARIA, touch targets
- [ ] Golden path verified visually in the browser
- [ ] Edge cases (empty states, error states, loading states) verified in the browser
- [ ] `pnpm lint` passes — no lint errors
- [ ] `pnpm tsc --noEmit` passes — no type errors

---

## Definition of Done

- [ ] All acceptance criteria from the user story are covered by passing tests
- [ ] WCAG 2.2 AA compliance confirmed on all interactive components
- [ ] Code committed and pushed
- [ ] Ready for `13-pr-and-review/`
