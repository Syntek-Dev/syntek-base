@./CONTEXT.md

# CLAUDE.md — code/src/mobile/**tests**/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md`
(what is verified and what cannot be — imported above) → this file →
`code/docs/TESTING.md`.

## Purpose (one line)

The mobile surface's test suite — jest-expo and React Native Testing Library over both the
routes and the non-route modules.

## How to work here

- **Routing:** `test-writer` skill for the Red phase, `stack-react-native` for the subject
  under test. Opus throughout.
- **Model:** Opus.
- **Concrete steps:** write the failing test first → run it through
  `code/src/scripts/mobile/test.sh` → implement under `../app/` or `../lib/` → re-run.
- **Definition of done:** the test failed before the implementation existed; coverage floor
  met; no accessibility claim rests on an automated check.

## Guardrails

- **Query the way a user finds it** — by role, label, and visible text, never by test ID
  where an accessible query exists. A test that passes on a test ID proves the element is in
  the tree, not that anyone can reach it.
- **Never claim a screen is accessible because the suite is green.** There is no axe for
  React Native; VoiceOver and TalkBack on device are the verification.
- **Never run `jest`, `expo`, `npx` or `pnpm` directly** — use `code/src/scripts/mobile/*.sh`.
- **No test file under `../app/`** — expo-router would publish it as a route.
- Files ≤ 750 lines (800 grace).

## Output & naming

- **Hand-written:** every test file here.
- **Generated (never hand-edit):** coverage output under `../coverage/`.
- Tests `<subject>.test.ts` / `<subject>.test.tsx`, named for the module or route they cover.
