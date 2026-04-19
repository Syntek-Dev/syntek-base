# code/src/mobile/assets — Static Assets

Static files bundled by Metro at build time.

## Expected files

| File | Purpose |
|---|---|
| `icon.png` | App icon (1024×1024 px, no transparency) |
| `splash-icon.png` | Splash screen image |
| `adaptive-icon.png` | Android adaptive icon foreground (1024×1024 px) |
| `favicon.png` | Web favicon (used when running as PWA via Expo Web) |

## Rules

- Source files only — no generated or build artefacts
- Keep file sizes reasonable; large assets slow cold-start time
- Use lossless PNG for icons; JPEG or WebP for photographs

## Cross-references

- `code/src/mobile/app.json` — references these files by relative path
