---
type: guide
agent: frontend
skills: [stack-htmx-templates]
model: opus
---

# Accessibility

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — WCAG 2.2 AA rules, semantic HTML, ARIA patterns, contrast, testing

Accessibility is not optional and not a feature — it is a baseline requirement. All work targets
**WCAG 2.2 Level AA**. This covers the whole site, which is server-rendered by Django (templates +
django-components + HTMX + Alpine).

**The standard is not web-only.** WCAG 2.2 AA applies unchanged to the optional mobile surface —
one standard, two technique sets. The sub-documents below carry the web techniques (semantic HTML,
ARIA, HTMX focus management); `accessibility/MOBILE.md` carries the React Native ones.

## Sub-documents

| Document                                                                             | Covers                                                                                                                                         |
| ------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [`accessibility/HTML-AND-ARIA.md`](accessibility/HTML-AND-ARIA.md)                   | Standards, semantic HTML rules, ARIA patterns, colour/contrast, images/icons/media, typography, server-rendered (Django + HTMX) accessibility  |
| [`accessibility/INTERACTION.md`](accessibility/INTERACTION.md)                       | Keyboard navigation, focus management across HTMX swaps, focus trapping in dialogs, form accessibility, motion and animation                   |
| [`accessibility/TESTING-AND-COMPONENTS.md`](accessibility/TESTING-AND-COMPONENTS.md) | django-component patterns, dynamic-update announcements, `.sr-only` utility, touch targets, automated and manual testing, pre-submit checklist |
| [`accessibility/MOBILE.md`](accessibility/MOBILE.md)                                 | **Mobile-only.** React Native technique set — accessibility props, VoiceOver/TalkBack, touch targets, and why verification here is manual      |

_Part of the `code/docs/` documentation family._
