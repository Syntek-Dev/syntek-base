# code/src/scripts/development

Scripts for managing the local development Docker Compose stack. They resolve
`code/src/docker/docker-compose.dev.yml` automatically and mostly drive Compose from the
host; the two scaffolders (`new-django-app.sh`) and the installers are the exceptions —
the first runs `manage.py startapp` inside the `django` container, the latter two run
`uv` / `pnpm` on the host.

## Directory Tree

```text
code/src/scripts/development/
├── CLAUDE.md                ← operating rules
├── CONTEXT.md               ← this file
├── hosts-story-add.sh       ← add /etc/hosts entries for a us### worktree stack
├── hosts-story-remove.sh    ← remove those /etc/hosts entries
├── install.sh               ← thin forwarder to install-frontend.sh
├── install-backend.sh       ← regenerate uv.lock / sync the Python .venv
├── install-frontend.sh      ← regenerate pnpm-lock.yaml / sync repo JS tooling
├── logs.sh                  ← tail / view service logs
├── new-django-app.sh        ← scaffold a new Django app with standard boilerplate
├── new-django-view.sh       ← scaffold a marketing page: Django view + template + urls entry
├── pnpm-update.sh           ← self-update pnpm and pin the version across the project
├── server.sh                ← start, stop, restart, build, status
├── shell.sh                 ← interactive shell inside a service container
├── sync-trees.sh            ← reconcile every CONTEXT.md Directory Tree against disk
├── template-update.sh       ← preview a `copier update` (changes, deletions, orphans) before applying
└── reports/                 ← reserved for future report output (gitignored)
    ├── CONTEXT.md
    ├── .gitignore
    └── .gitkeep
```

## Scripts

| Script                  | Purpose                                                                      |
| ----------------------- | ---------------------------------------------------------------------------- |
| `server.sh`             | Manage the dev stack — `up [--seed]`, `down`, `restart`, `build`, `status`   |
| `logs.sh`               | View and tail container logs with service/follow/tail/since filters          |
| `shell.sh`              | Open an interactive shell (`bash` / `sh`) inside any service container       |
| `install.sh`            | Backwards-compatible forwarder to `install-frontend.sh`                      |
| `install-backend.sh`    | Regenerate `uv.lock`; `--sync` installs into `.venv`, `--check` verifies     |
| `install-frontend.sh`   | Regenerate `pnpm-lock.yaml` for the repo tooling (no client-side build)      |
| `pnpm-update.sh`        | `pnpm self-update`, then pin the version in `package.json` + Dockerfiles     |
| `new-django-app.sh`     | Scaffold a new Django app with standard boilerplate                          |
| `new-django-view.sh`    | Add a public marketing page to an **existing** `apps.marketing`              |
| `hosts-story-add.sh`    | Add the `/etc/hosts` entries a `us###` worktree stack needs (sudo)           |
| `hosts-story-remove.sh` | Remove those entries when the worktree is torn down (sudo)                   |
| `template-update.sh`    | Dry-run a `copier update` on a throwaway copy — preview only until `--apply` |
| `sync-trees.sh`         | Reconcile the `## Directory Tree` block in every `CONTEXT.md` against disk   |

> `new-django-view.sh` extends a marketing app; it does not create one. At baseline
> `apps/marketing` does not exist, so the script exits `1` and names what is missing.

## Quick Reference

```bash
# Start the full stack
bash code/src/scripts/development/server.sh up

# Start with a fresh image build
bash code/src/scripts/development/server.sh up --build

# Start, then seed dev users (+ any SEED_COMMANDS from .env.dev)
bash code/src/scripts/development/server.sh up --seed

# Tail all logs
bash code/src/scripts/development/logs.sh --follow

# Tail Django only
bash code/src/scripts/development/logs.sh --service django --follow

# Shell into the Django container
bash code/src/scripts/development/shell.sh

# Shell into the database container
bash code/src/scripts/development/shell.sh --service db

# Stop the stack (keep volumes)
bash code/src/scripts/development/server.sh down

# Stop and wipe volumes (resets the database)
bash code/src/scripts/development/server.sh down --volumes

# Show container status
bash code/src/scripts/development/server.sh status
```

## Services

| Service  | Shell  | Notes                                                                |
| -------- | ------ | -------------------------------------------------------------------- |
| `nginx`  | `sh`   | Reverse proxy — http://dev.<%PROJECT_SLUG%>.localhost:81 (host port) |
| `django` | `bash` | Django/Uvicorn — internal, hot-reload via `--reload`                 |
| `db`     | `bash` | PostgreSQL 18 — internal only                                        |
| `cache`  | `sh`   | Valkey 8 — internal only                                             |

There are four services and no more. `shell.sh` rejects any other name.

## Routing

All traffic enters through the `nginx` service at
`http://dev.<%PROJECT_SLUG%>.localhost:81`. Host port **81**, not 80 — a local router
(e.g. DDEV) commonly holds `127.0.0.1:80`. Config: `code/src/docker/nginx/dev.conf`.

| Path prefix | Proxied to                                         |
| ----------- | -------------------------------------------------- |
| `/static/`  | `django`                                           |
| `/media/`   | `django`                                           |
| `/control/` | `django` (Django's own admin — never at `/admin/`) |
| `/`         | `django` (catch-all)                               |

At baseline the URLconf serves only `/control/`; the catch-all is there for the marketing
pages a project adds on top of the template.

## Compose file

`code/src/docker/docker-compose.dev.yml`

All scripts resolve this path automatically. Run commands from any directory.

## Notes

- `server.sh down --volumes` wipes all named volumes including the PostgreSQL data.
  Use `database/reset.sh` for a targeted database reset that keeps volumes intact.
- Scripts use `exec docker compose …` for interactive commands (`shell.sh`, `logs --follow`)
  so Ctrl+C / Ctrl+D behave naturally.
- `pnpm-update.sh` and `install-frontend.sh` maintain the **repo tooling** only
  (markdownlint, Prettier, ESLint, lefthook, Bruno). There is no client-side build —
  the site is server-rendered by Django.
