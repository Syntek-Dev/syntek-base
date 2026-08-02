# Releases — mobile

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

Release notes for the React Native mobile application.

---

## v0.1.0 — 02/08/2026

**Status:** Baseline release — the optional mobile surface becomes bootable

### Summary

Establishes `code/src/mobile/` as the repository's second surface: a React Native application
built on Expo with Continuous Native Generation, present only in a project that opted in at
generation. It is a **peer of the Django project, not a layer on top of it** — it renders no
Django page, Django never bundles it, and it reaches the server through the same Django Ninja
API at `/api/` that any third-party client would.

The bundle ships one route, a root layout, a self-contained TypeScript and ESLint toolchain, and
a jest-expo suite at the same coverage floors as the backend. No feature code, no navigation
opinion, and no API client exist yet; that is deliberate, and matches the Django baseline.

### What's new

- **Expo with Continuous Native Generation** — `ios/` and `android/` are generated artefacts, rebuilt from `app.json`, never committed. This is what keeps the tree text-only and renderable by Copier
- **expo-router** — file-system routing with typed routes enabled; one placeholder screen at `/`
- **Self-contained toolchain** — TypeScript, `typescript-eslint` and ESLint 9 live in this workspace alone, so the repository root stays free of TypeScript and a web-only generation is unaffected
- **Testing at parity** — jest-expo plus React Native Testing Library, enforcing 75% lines and branches, the same numbers as the backend but enforced once per runtime, since coverage.py and Jest share no accumulator
- **Independent versioning** — this application moves on its own track and is never bumped as a side-effect of a root version bump. Store versions must increase monotonically, so coupling would force spurious releases or version gaps

### Known limitations

- **Two raw colour literals remain in `app/index.tsx`**, flagged in place. The generated token module they should consume does not exist yet — see the design-token bridge in `code/docs/DESIGN-TOKENS.md`
- **No binary assets.** `app.json` names no icon, splash image or favicon, so Expo falls back to its defaults. Branded assets are a per-project addition and need a matching template exclusion entry
- **Automated accessibility scanning has no counterpart here.** There is no React Native equivalent of `axe-core-python`, so WCAG 2.2 AA verification on this surface is manual — techniques in `code/docs/accessibility/MOBILE.md`
- **Native builds are not run in CI.** The pipeline stops at a JavaScript bundle export; native iOS and Android builds would require paid macOS runners on every pull request
