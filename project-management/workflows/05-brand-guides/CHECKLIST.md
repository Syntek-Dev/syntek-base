# Brand Guides — Checklist

**Last Updated**: 21/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Execution Checklist

- [ ] Claude Design used to generate initial logo, colour, typography, and visual direction concepts
- [ ] Agreed brand decisions documented in `project-management/src/05-BRAND-GUIDE/` as `BRAND-<TOPIC>.md` files
- [ ] Brand principles (personality, tone, visual direction) documented
- [ ] Full colour palette defined with hex values and semantic roles
- [ ] All colour combinations pass WCAG 2.2 AA contrast ratios
- [ ] Typography defined: typefaces, scale, weights, line heights
- [ ] Spacing scale defined with named tokens
- [ ] Layout breakpoints documented (build-time only — not DB tokens; see `project-management/docs/RESPONSIVE-DESIGN.md`)
- [ ] Figma brand guide built from [team templates](https://www.figma.com/files/team/1593704150140722359/drafts?fuid=1593704145676751629) — colours, typography, spacing, and logo pages complete
- [ ] Figma variables set up for all colour, typography, and spacing tokens
- [ ] Token records created or updated via Django admin
- [ ] CSS variables generated and confirmed correct
- [ ] Tailwind v4 config picks up updated variables
- [ ] Token migration plan documented if existing tokens are changing

---

## Definition of Done

- [ ] Brand guide agreed and documented in `project-management/src/05-BRAND-GUIDE/`
- [ ] Figma brand guide complete and accessible to the team
- [ ] Design token system updated and verified
- [ ] Documents committed and pushed
