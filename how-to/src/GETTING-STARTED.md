# Getting Started — project-name

**Last Updated**: 19/04/2026\
**Language**: British English (en_GB)

---

## What this is

`project-name` is a full-stack monorepo template from Syntek Studio — Django + Strawberry GraphQL
backend, Next.js frontend, Expo React Native mobile app, and a three-layer documentation structure.
Everything runs inside Docker. No host-level Python or Node.js required inside the containers.

If you are adapting this as your own project, read [Customising the Template](CUSTOMISING-TEMPLATE.md)
after completing this guide.

---

## Prerequisites

| Tool           | Version       | Notes                                                                                         |
| -------------- | ------------- | --------------------------------------------------------------------------------------------- |
| Docker Engine  | 27+           | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/)                             |
| Docker Compose | v2+           | Bundled with Docker Desktop; plugin for Linux                                                 |
| Git            | any recent    |                                                                                               |
| Node.js        | 24 (`.nvmrc`) | Root scripts and git hooks only                                                               |
| pnpm           | 10.33.0       | Root workspace only                                                                           |
| uv             | 0.11.7+       | Python tooling — [docs.astral.sh/uv](https://docs.astral.sh/uv/getting-started/installation/) |

---

## First-time setup

### 1. Clone and run the install script

```bash
git clone git@github.com:your-org/project-name.git
cd project-name
chmod +x install.sh
./install.sh
```

The script:

- Renames all `project-name` / `project_name` placeholders (interactive prompt)
- Installs Python dependencies via `uv sync`
- Installs JavaScript dependencies via `pnpm install`
- Copies missing `.env.*` files from their examples
- Marks all scripts in `code/src/scripts/` executable

### 2. Populate the environment files

The install script creates these files — open each and fill in values marked `CHANGE_ME`:

```text
code/src/docker/.env.dev
code/src/docker/.env.test
```

Full variable reference: [Environment Setup](ENV-SETUP.md)

### 3. Start the development stack

```bash
./code/src/scripts/development/server.sh up
```

### 4. Apply database migrations

```bash
./code/src/scripts/database/migrate.sh run
```

### 5. Create a superuser (optional)

```bash
./code/src/scripts/database/manageusers.sh create-superuser
```

### 6. Verify

| Service            | URL                                 |
| ------------------ | ----------------------------------- |
| Frontend           | http://dev.projectname.com          |
| GraphQL Playground | http://dev.projectname.com/graphql/ |
| Django Admin       | http://dev.projectname.com/admin/   |
| Maildev            | http://dev.projectname.com:1080     |

After `install.sh` replaces the `projectname` placeholder with your project name, these URLs
will reflect your project name automatically.

---

## Where to go next

| Task                          | Guide                                                             |
| ----------------------------- | ----------------------------------------------------------------- |
| Daily development workflow    | `how-to/workflows/02-daily-development/STEPS.md`                  |
| Branch and commit conventions | [Branch Guide](BRANCH-GUIDE.md) · [Commit Guide](COMMIT-GUIDE.md) |
| All CLI commands              | `how-to/docs/CLI-TOOLING.md`                                      |
| Claude Code integration       | [Claude Multilayer Guide](CLAUDE-MULTILAYER.md)                   |
| Using this as a template      | [Customising the Template](CUSTOMISING-TEMPLATE.md)               |

---

## Rule — never run tooling directly on the host

All `python`, `pytest`, `pnpm`, and `next` commands run inside the containers. Use the scripts
in `code/src/scripts/` or prefix with `docker compose exec`:

```bash
docker compose exec backend python manage.py <command>
docker compose exec frontend pnpm <command>
```
