# Changelog — mobile

**Last Updated**: <%DATE%> **Version**: 0.2.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

All notable changes to the React Native mobile application are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this package adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.2.0] - 09/11/2026

### Changed

- Expo SDK 57 to SDK 58, moved as one matched set: `expo` ~58.0.23, `expo-router` ~58.0.30, `expo-constants` ~58.0.15, `expo-linking` ~58.0.16, `expo-status-bar` ~58.0.4, `react` 19.3.0, `react-native` 0.88.1, `react-native-safe-area-context` ~5.11.1, `react-native-screens` ~4.30.1, `@types/react` ~19.3.0. The store Expo Go app now serves SDK 58 only, so an SDK 57 app no longer opened in it.
- Test toolchain: `jest-expo` ~58.0.14, `jest` ~30.5.2, `@types/jest` ^30.0.0 and React Native Testing Library ^14.1.0, which expo-router 58 requires as its testing peer. RNTL 14 renders asynchronously, so `__tests__/app.test.tsx` now awaits `renderRouter`, and its comment no longer claims RNTL 14 dropped `screen` (it did not).
- Lint toolchain: `eslint-config-expo` ~58.0.4 and `typescript-eslint` ^8.72.1. ESLint stays on 9 here (eslint-plugin-react and eslint-plugin-import cap their peer at ^9), and TypeScript stays on ~6.0.3, the line SDK 58 pins.

### Security

- Three audit exceptions retired with the SDK: the zod 3.x advisory (`@expo/cli` 58 has no zod) and both decode-uri-component advisories together with the in-place patch that answered them (expo-router 58 no longer depends on `query-string@7`).
- `node-forge` 1.4.2 to 1.4.3, a lockfile refresh inside `@expo/cli`'s and `@expo/code-signing-certificates`' existing ranges, clearing four advisories published after the sweep began (GHSA-w4xr-hqv8-ch44, GHSA-6cv4-p8m7-4r25, GHSA-j8rw-jp99-435v, GHSA-6889-vf6x-f3g5). A fix was available, so none of them was ignored.

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
