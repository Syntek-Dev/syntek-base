# code/src/mobile/lib — Non-Route Modules

**Mobile-only.** Everything the app needs that is **not** a screen. The directory exists
because expo-router treats every file under `app/` as a navigable route, so a helper placed
there would become a URL — `lib/` is where a module goes to stay a module.

At baseline it holds the mobile half of the correctness doctrine: the programmer-error type
and the classifier that decides which of the three error classes a failure belongs to.

**Last Updated**: <%DATE%>

## Directory Tree

```text
lib/
├── error-classes.ts  ← which of the three classes a failure is, and how often each is reported
├── invariant.ts      ← InvariantViolation + unreachable() — the exhaustiveness guard
├── CONTEXT.md        ← this file
└── CLAUDE.md         ← operating rules
```

## Why these two ship and nothing else does

Both are **provable without a design system**. The classifier decides a class; the guard
raises a keyed error. Neither needs a colour, a token, or a line of brand voice.

What is deliberately absent is the other half — the screen that renders a classified failure
to a user. It needs the generated token module and the project's settled voice, and a
template may not invent either. The half that can be proved at baseline ships; the half that
cannot does not.

## Cross-references

- `code/src/mobile/CONTEXT.md` — the mobile surface: layout, scripts, versioning
- `code/src/mobile/app/CONTEXT.md` — the route half, and why the split is load-bearing
