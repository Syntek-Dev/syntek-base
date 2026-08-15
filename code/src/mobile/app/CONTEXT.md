# code/src/mobile/app — expo-router Routes

**Mobile-only.** Every file here is a **route**: expo-router maps the filename to the
navigation path, so adding a file adds a screen and renaming one is a breaking change to
navigation. That is the whole reason this directory is separated from `lib/` — a helper
dropped here would silently become a reachable screen.

**Last Updated**: <%DATE%>

## Directory Tree

```text
app/
├── _layout.tsx   ← the root layout every route renders inside
├── index.tsx     ← the one route the baseline ships — `/`
├── CONTEXT.md    ← this file
└── CLAUDE.md     ← operating rules
```

## What belongs here, and what does not

| Kind                                   | Home            |
| -------------------------------------- | --------------- |
| A screen the user can navigate to      | here            |
| A hook, helper, client, or error class | `../lib/`       |
| The test for either                    | `../__tests__/` |

`_layout.tsx` is expo-router's own convention rather than a route: it wraps every screen
below it, which makes it the one place a provider, a theme, or an error boundary reaches the
whole app.

## Cross-references

- `code/src/mobile/CONTEXT.md` — the mobile surface: layout, scripts, versioning
- `code/src/mobile/lib/CONTEXT.md` — the non-route half, and why the split exists
