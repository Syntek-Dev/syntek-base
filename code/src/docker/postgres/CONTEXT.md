# code/src/docker/postgres

PostgreSQL Docker configuration for the development stack.

## Directory Tree

```text
code/src/docker/postgres/
├── CLAUDE.md              ← operating rules
├── CONTEXT.md             ← this file
└── postgresql.dev.conf    ← local tuning for the dev container only
```

Dev only: staging and production run a database the deploy repo provisions and tunes, so a
config file here would be a second, silently-diverging opinion about the same server.

## Files

| File                  | Purpose                              |
| --------------------- | ------------------------------------ |
| `postgresql.dev.conf` | PostgreSQL development configuration |
