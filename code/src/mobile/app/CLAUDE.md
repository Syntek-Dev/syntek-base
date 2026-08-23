@./CONTEXT.md

# CLAUDE.md — code/src/mobile/app/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is a route and what is not — imported above) → this file →
`code/docs/MOBILE-CODING-PRINCIPLES.md`.

## Purpose (one line)

The expo-router route tree — one file per navigable screen, plus the layout every screen
renders inside.

## How to work here

- **Routing:** `stack-react-native` skill (Opus). Screens consume the JSON API this
  repository serves; they never reach a database or import Django anything.
- **Model:** Opus for screens, styles, and mechanical touches.
- **Concrete steps:** add the route file → style with `StyleSheet` over the generated token
  module, never a raw literal → add its test under `../__tests__/` → run the mobile scripts
  under `code/src/scripts/mobile/`.
- **Definition of done:** the screen is reachable, accessible on VoiceOver and TalkBack,
  tested, and the tree in `CONTEXT.md` matches disk.

## Guardrails

- **A file here is a URL.** Never place a helper, hook, client, or type module in this
  directory — it becomes a navigable screen. Those go to `../lib/`.
- **Never run `expo`, `npx`, `pnpm` or `jest` directly** — use `code/src/scripts/mobile/*.sh`.
- **No raw design values.** Colour, spacing, radius and type come from the generated token
  module; a literal here is the drift the web surface's token gate exists to stop.
- Accessibility is verified on device, never scanned — there is no axe equivalent here.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** every `.tsx` route and `_layout.tsx`.
- **Generated (never hand-edit):** nothing here; native projects are generated outside this
  tree by Continuous Native Generation.
- Route files `kebab-case.tsx`; expo-router's own conventions (`_layout`, `index`,
  `[param]`, `(group)`) take precedence over house naming where they collide.
