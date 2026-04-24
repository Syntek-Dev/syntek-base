# code/src/scripts/development

Scripts for managing the local development Docker Compose stack. All scripts target the
`docker-compose.yml` at the project root and run on the host — no container exec required.

## Directory Tree

```text
code/src/scripts/development/
├── CONTEXT.md               ← this file
├── logs.sh                  ← tail / view service logs
├── server.sh                ← start, stop, restart, build, status
├── shell.sh                 ← interactive shell inside a service container
└── reports/                 ← reserved for future report output (gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script      | Purpose                                                                |
| ----------- | ---------------------------------------------------------------------- |
| `server.sh` | Manage the dev stack — `up`, `down`, `restart`, `build`, `status`      |
| `logs.sh`   | View and tail container logs with service/follow/tail/since filters    |
| `shell.sh`  | Open an interactive shell (`bash` / `sh`) inside any service container |

## Quick Reference

```bash
# Start the full stack
bash code/src/scripts/development/server.sh up

# Start with a fresh image build
bash code/src/scripts/development/server.sh up --build

# Tail all logs
bash code/src/scripts/development/logs.sh --follow

# Tail backend only
bash code/src/scripts/development/logs.sh --service backend --follow

# Shell into the backend container
bash code/src/scripts/development/shell.sh

# Shell into the frontend container
bash code/src/scripts/development/shell.sh --service frontend

# Stop the stack (keep volumes)
bash code/src/scripts/development/server.sh down

# Stop and wipe volumes (resets the database)
bash code/src/scripts/development/server.sh down --volumes

# Show container status
bash code/src/scripts/development/server.sh status
```

## Services

| Service    | Shell  | Notes                                                    |
| ---------- | ------ | -------------------------------------------------------- |
| `nginx`    | `sh`   | Reverse proxy — http://dev.projectname.com (port 80)     |
| `backend`  | `bash` | Django/Uvicorn — internal, hot-reload via `--reload`     |
| `frontend` | `sh`   | Next.js dev server — internal (port 3000)                |
| `db`       | `bash` | PostgreSQL 18 — internal only                            |
| `cache`    | `sh`   | Valkey 8 — internal only                                 |
| `maildev`  | `sh`   | Catches outbound email — http://dev.projectname.com:1080 |

## Routing

All traffic enters through the `nginx` service at `http://dev.projectname.com` (port 80).
Config: `code/src/docker/nginx/dev.conf`.

| Path prefix          | Proxied to                           |
| -------------------- | ------------------------------------ |
| `/graphql/`          | `backend` (Django/Strawberry — ASGI) |
| `/admin/`            | `backend` (Django admin)             |
| `/static/`           | `backend`                            |
| `/health/`           | `backend`                            |
| `/_next/webpack-hmr` | `frontend` (HMR WebSocket)           |
| `/`                  | `frontend` (Next.js dev server)      |

> **Media files are served by Cloudinary in all environments (dev, test, staging, prod).**
> There is no `/media/` nginx route. Django's `DEFAULT_FILE_STORAGE` uses Cloudinary storage
> in every environment — no local media volume is needed.

## Compose file

`code/src/docker/docker-compose.dev.yml`

All scripts resolve this path automatically. Run commands from any directory.

## Notes

- `server.sh down --volumes` wipes all named volumes including the PostgreSQL data.
  Use `database/reset.sh` for a targeted database reset that keeps volumes intact.
- Scripts use `exec docker compose …` for interactive commands (`shell.sh`, `logs --follow`)
  so Ctrl+C / Ctrl+D behave naturally.
- `maildev` captures all outgoing SMTP from Django — no real emails are sent in dev.
  Browse captured mail at http://dev.projectname.com:1080.
