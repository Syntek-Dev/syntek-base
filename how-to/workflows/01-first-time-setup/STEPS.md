---
workflow: 01-first-time-setup
phase: setup
agent: setup
skills: [global-workflow]
model: opus
---

# First-Time Setup — Steps

**Last Updated**: {{DATE}} **Version**: 0.1.0 **Maintained By**: {{ORG_NAME}}
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                          |
| ---- | ------------------------------------------------------------------------------------------------ |
| 2    | **Internal → Reference guides** → how-to/docs/DEVELOPMENT.md (prerequisites and troubleshooting) |
| 2–4  | **External — Tools & CLI** → Docker Compose v2 reference, uv documentation, pnpm documentation   |
| 5–6  | **External — IDE & Editor** → Claude Code CLI documentation                                      |

---

## Steps

### Step 1 — Clone the Repository

```bash
git clone git@github.com:{{ORG_SLUG}}/{{PROJECT_SLUG}}.git
cd {{PROJECT_SLUG}}
```

> **Model:** opus

### Step 2 — Run the Installer

```bash
bash install.sh
```

This single command:

- Checks all prerequisites (Docker, docker compose v2, git, uv, pnpm, openssl)
- Installs Python dependencies (delegates to `code/src/scripts/development/install-backend.sh --sync`)
- Installs JavaScript dependencies (delegates to `code/src/scripts/development/install-frontend.sh --local`, keeping `pnpm-lock.yaml` in sync)
- Copies every `.env.*.example` file to its live counterpart (skips existing)
- Auto-generates `SECRET_KEY`, `ENCRYPTION_KEY`, `LEGAL_FIELD_HMAC_KEY`, `MFA_FIELD_KEY`, and `POSTGRES_PASSWORD` in `.env.dev`
- Marks `install.sh` and all `code/src/scripts/**/*.sh` files executable

> **Model:** opus

### Step 3 — Review Environment Files

Open `code/src/docker/.env.dev` and confirm the auto-generated secrets look correct.
For staging and production, populate `code/src/docker/.env.staging` and `.env.prod`
manually — those secrets are never generated automatically.

> **Model:** opus

### Step 4 — Start the Stack (choose one)

**Quick option — full bootstrap in one command:**

```bash
bash install.sh --full
```

This builds Docker images, starts all containers, and applies migrations automatically.
Use this for a clean first run when all secrets are already set.

**Manual option — step by step:**

```bash
bash code/src/scripts/development/server.sh up --build
bash code/src/scripts/database/migrate.sh run
```

> **Model:** opus

### Step 5 — Seed the Database

```bash
bash code/src/scripts/database/reset.sh --seed --yes
```

This applies all migrations and creates two dev accounts from `code/src/docker/.env.dev`:

- **Superuser** (`DJANGO_SUPERUSER_*`) — full admin access
- **Staff user** (`SEED_STAFF_*`) — staff-only access for testing permission boundaries

Accounts are idempotent — safe to re-run after any future reset.

> **Model:** opus

### Step 6 — Verify

Open:

- Public site: http://localhost:8000/
- API docs (OpenAPI): http://localhost:8000/api/docs
- Django Admin: http://localhost:8000/control/ (non-obvious path — never `/admin/`, which is reserved for the {{PROJECT_NAME}} Admin surface; see `code/docs/URL-STRATEGY.md`)
- Mail (dev): http://localhost:1080

> **Model:** opus · **MCP:** claude-in-chrome (rendered verification)

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
