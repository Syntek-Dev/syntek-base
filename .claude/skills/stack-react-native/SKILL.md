---
name: stack-react-native
description: Mobile stack reference for <%PROJECT_NAME%> — Expo (Continuous Native Generation) + React Native + TypeScript + expo-router, styled with StyleSheet over a generated token module. Load when building or reviewing the mobile surface, or when a test, QA, or review agent needs React Native conventions without owning them. MOBILE-ONLY — present only in a project generated with the mobile surface.
---

Reference for the **mobile surface** of <%PROJECT_NAME%> — `code/src/mobile/`. The `mobile` agent
loads this for stack idioms; `test-writer`, `qa-tester`, and `code-reviewer` cite it at the mobile
boundary without owning React Native conventions themselves. Aligns with
`project-management/workflows/20-frontend-code/` (its mobile-flagged steps) and
`code/src/mobile/CLAUDE.md`.

**This skill is mobile-only.** A project generated without the mobile surface has neither this
skill nor the tree it describes. The `frontend` agent is Django-templates-only and never loads it.

The **visual** language is `code/docs/VISUAL-DESIGN.md` — §3 names this project's **direction** and
its six axes, §4.1 the universal tells, §5 the motion numbers. Its mobile expression is
`code/docs/visual-design/MOBILE.md`, which owns **platform conformance** and **adaptivity**: mobile
slop is a web-shaped screen wearing a native shell, and the web's layout-composition rules have no
analogue here.

British English throughout (<%LOCALE%> · <%TIMEZONE%> · <%CURRENCY%>).

---

## The surface model (read this first)

A **surface** is one delivery target with its own runtime, toolchain and release cycle. The
repository has at most two, and they are **peers, not layers**:

| Surface    | Lives in           | Runtime                       |
| ---------- | ------------------ | ----------------------------- |
| **Web**    | `code/src/django/` | Django ASGI — pages + `/api/` |
| **Mobile** | `code/src/mobile/` | React Native (Expo) on device |

The mobile app consumes the Django Ninja API exactly as a third-party client would. It **never**
renders a Django page and Django **never** bundles it. Every web doctrine — "no client-side
build", "no fourth row" in `code/docs/RENDERING.md`, the three-tier interaction rule — is scoped
to the web surface and is neither weakened nor extended by this one. Canonical definition:
`code/src/CONTEXT.md` → _Surfaces_.

---

## Architecture

| Layer     | Technology                                                                       |
| --------- | -------------------------------------------------------------------------------- |
| Framework | **Expo** with Continuous Native Generation — `ios/` and `android/` are generated |
| Language  | **TypeScript**, strict, self-contained in this workspace                         |
| Routing   | **expo-router** — file-system routes under `app/`                                |
| Styling   | **`StyleSheet.create`** over a generated token module — no styling library       |
| Testing   | **jest-expo** + React Native Testing Library                                     |
| Dev loop  | **Expo Go**, Metro on the host                                                   |

**The pins are a matched set, not independent choices.** Expo pins TypeScript, jest-expo pins the
Jest line, expo-router pins the testing-library major, and `eslint-config-expo` pins ESLint. Take
versions from Expo's published `expo-template-default` and verify by running the toolchain —
never bump one in isolation.

---

## Everything runs through the scripts

Never invoke `pnpm`, `expo`, `tsc` or `jest` directly:

| Task            | Script                                 |
| --------------- | -------------------------------------- |
| Install         | `code/src/scripts/mobile/install.sh`   |
| Metro / Expo Go | `code/src/scripts/mobile/server.sh`    |
| Lint            | `code/src/scripts/mobile/lint.sh`      |
| Type-check      | `code/src/scripts/mobile/typecheck.sh` |
| Test            | `code/src/scripts/mobile/test.sh`      |
| Bundle          | `code/src/scripts/mobile/bundle.sh`    |

**Metro runs on the host, not in Docker** — the one dev operation that is not containerised. Expo
Go runs on a physical device, and a device cannot reach a `127.0.0.N` loopback alias, so Metro
must be on the LAN. Its port joins the story's existing reserved block (`8081 + story number`).

---

## Routing pattern

`app/` is **routes only**. A route is a default-exported component; `_layout.tsx` wraps them.

```tsx
// app/settings.tsx — reachable at /settings
import { View } from "react-native";

export default function Settings() {
  return <View />;
}
```

**Tests never live under `app/`.** expo-router treats every file there as a route, so a
co-located `*.test.tsx` pulls the testing library into the **production bundle** and
`bundle.sh` fails. Mobile tests go in `code/src/mobile/__tests__/`.

---

## Styling: token-first, exactly as on the web

Component styles consume the generated token module — never a raw literal:

```tsx
import { StyleSheet } from "react-native";
import { tokens } from "@/tokens";

const styles = StyleSheet.create({
  card: {
    backgroundColor: tokens.colour.surface, // never "#ffffff"
    padding: tokens.space.md, // never 16
  },
});
```

Colours arrive as **8-digit hex** (`#rrggbbaa`) — fixed length, always-explicit alpha, widest
parse compatibility. OKLCH is canonical in the database and gamut-mapped per CSS Color 4 on the
way out, so web and mobile stay visually aligned. Three preference axes (`contrast`,
`forced_colors`, `data_saver`) have no React Native equivalent and collapse to BASE.

The "name resolves" half of the token-first law is free here — an unresolved token import does
not compile. The no-raw-literals half is checked by `code/src/scripts/audits/mobile-tokens.sh`.

**Consequence to state plainly:** the design system's no-rebuild promise is **web-only**. A token
change reaches an installed app only through a rebuild and a store release.

---

## Theming and accessibility

Theme from `useColorScheme()`; respect `AccessibilityInfo` for reduced motion.

**WCAG 2.2 AA applies unchanged** — one standard, two technique sets. On this surface that means
`accessibilityLabel`, `accessibilityRole`, `accessibilityState`, VoiceOver and TalkBack
behaviour, and platform touch-target sizing. Techniques: `code/docs/accessibility/MOBILE.md`.

**There is no `axe-core` equivalent for React Native**, so mobile accessibility verification is
more manual than web. Do not assume parity of tooling.

---

## Testing

```tsx
import { renderRouter } from "expo-router/testing-library";

const app = renderRouter("./app", { initialUrl: "/" });
expect(await app.findByRole("header")).toBeOnTheScreen();
```

Mount the **real router** rather than a screen in isolation — a layout that renders nothing is a
real failure mode that isolated route tests hide. Query from `renderRouter`'s return value, not a
global `screen`.

Coverage floors are the **same numbers as the backend, enforced once per runtime**: 75% lines and
branches globally, 90% on auth-adjacent code. coverage.py and Jest share no accumulator, so a
single combined percentage was never achievable. A per-glob threshold matching nothing **fails**
the run, so the 90% entry is added with the first auth screen, not before.

---

## Guardrails recap

- **Never commit `ios/` or `android/`** — generated, and they contain binaries this repository's
  template cannot render.
- **No binary assets in the tree**, for the same reason. Icons are a per-project addition.
- **Stay self-contained** — TypeScript, eslint and their config live in `code/src/mobile/` only.
  Adding a TypeScript dependency to the repository root breaks the one-mechanism opt-in rule.
- **The Expo SDK bump is a template release**, propagated by `copier update` — not a routine
  dependency bump.
- Source files ≤ 750 lines (800 grace).

## Governing procedures (route here — do not restate at length)

- `project-management/workflows/20-frontend-code/` — the build phase; its mobile-flagged steps
- `code/workflows/01-new-feature/` · `02-tdd-cycle/` — the feature and TDD procedures
- `code/src/mobile/CLAUDE.md` — the operating rules for the tree itself
