# Changelog — mobile

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to the React Native mobile application are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this package adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.1.0] - 02/08/2026

### Added

- Initial scaffold from the base template — Expo (Continuous Native Generation) · React Native · TypeScript · expo-router · StyleSheet over design tokens · jest-expo.
- `app/` — the expo-router route tree: `_layout.tsx` (root `Stack`) and `index.tsx`, a single placeholder screen. Routes only; expo-router treats every file here as a route.
- `__tests__/app.test.tsx` — jest-expo and React Native Testing Library, mounting the real router via `renderRouter` so the root layout is covered alongside the route.
- `app.json` — the Expo config carrying the app name, slug, scheme, and the iOS bundle identifier and Android package, all from template tokens.
- `package.json`, `tsconfig.json`, `eslint.config.mjs`, and `jest.config.js` — a self-contained toolchain: TypeScript, `typescript-eslint` and the coverage thresholds live in this tree and nowhere else.
- `.gitignore` — `ios/` and `android/` are Expo-generated and never committed; a Gradle wrapper JAR and launcher PNGs would break Copier generation, which cannot render binaries.

### Changed

- Established as the repository's second versioned sub-package on its own independent semver track, alongside `code/src/django/`. `app.json` and `package.json` carry the same number and move together — two files, one version.

### Security

- No binary assets and no committed native directories, so nothing in this tree escapes review as an opaque blob.
