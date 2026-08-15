# code/src/mobile/**tests** — The Mobile Test Suite

**Mobile-only.** jest-expo plus React Native Testing Library, for both halves of the app —
the routes under `app/` and the modules under `lib/`.

The tests sit in one directory rather than beside their subjects for a reason specific to
this surface: expo-router turns every file under `app/` into a navigable route, so a test
co-located there would ship as a screen.

**Last Updated**: <%DATE%>

## Directory Tree

```text
__tests__/
├── app.test.tsx            ← the baseline route renders
├── error-classes.test.ts   ← each failure lands in the right class
├── invariant.test.ts       ← the guard raises, and the union is exhausted
├── CONTEXT.md              ← this file
└── CLAUDE.md               ← operating rules
```

## What is verified here, and what cannot be

Behaviour is testable; **accessibility is not scanned**. There is no axe-core equivalent for
React Native, so a query through React Native Testing Library proves an element is reachable
and labelled, and the rest is verified by hand on device with VoiceOver and TalkBack. A
mobile screen is never "scanned clean" — treat any claim that it was as untested.

## Cross-references

- `code/src/mobile/CONTEXT.md` — the mobile surface: layout, scripts, versioning
- `code/docs/TESTING.md` — coverage floors and test structure, shared with every surface
