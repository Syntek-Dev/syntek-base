---
workflow: 01-first-time-setup
phase: setup
agent: setup
skills: [global-workflow]
model: opus
---

# First-Time Setup — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `how-to/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                          |
| ---- | ------------------------------------------------------------------------------------------------ |
| 2    | **Internal → Reference guides** → how-to/docs/DEVELOPMENT.md (prerequisites and troubleshooting) |
| 2–4  | **External — Tools & CLI** → Docker Compose v2 reference, uv documentation, pnpm documentation   |
| 5–6  | **External — IDE & Editor** → Claude Code CLI documentation                                      |
| 7–8  | `CONTEXT.md` → _What this project is_ · `.claude/skills/scale-planning/SKILL.md`                 |

---

## Steps

### Step 1 — Clone the Repository

```bash
git clone git@github.com:<%ORG_SLUG%>/<%PROJECT_SLUG%>.git
cd <%PROJECT_SLUG%>
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
- Django Admin: http://localhost:8000/control/ (non-obvious path — never `/admin/`, which is reserved for the <%PROJECT_NAME%> Admin surface; see `code/docs/URL-STRATEGY.md`)
- Mail (dev): http://localhost:1080

> **Model:** opus · **MCP:** claude-in-chrome (rendered verification)

---

## Before any feature work

Steps 1–6 give a running stack. **Steps 7 and 8 are what make the work that follows worth
doing** — and both run once, before the first feature is charted.

### Step 7 — Sharpen the project description

> **Model:** fable

Open `CONTEXT.md` → _What this project is_. It holds the one or two sentences answered at
generation (`PROJECT_DESCRIPTION`). Read them back to <%DEVELOPER_NAME%> and ask whether they still
describe the project, then expand them into a real brief:

- **What it does** — the capability, not the technology.
- **Who it is for** — the actual user, named.
- **What it replaces** — the process, tool, or spreadsheet it is displacing.
- **What it is deliberately not** — the nearest thing it will be mistaken for.

Write the result back into `CONTEXT.md`. That paragraph is the first thing every agent reads in
every session, and every scope decision downstream is measured against it — an unedited
generation-time placeholder is a silent tax on every gate that follows.

_Done when `CONTEXT.md` opens with a brief <%DEVELOPER_NAME%> has confirmed, not the raw Copier answer._

### Step 8 — Plan scale and architecture before the first feature

> **Model:** fable

```text
/scale-planning
```

Runs the `scale-planner` agent against the live code and regenerates
`how-to/src/SCALE-ARCHITECTURE/` and `how-to/src/SERVER-ARCHITECTURE/`, which ship as skeletons
full of `TBD — regenerate via /scale-planning` markers.

**Do this before the first feature, not after the tenth.** Its value is not the server sizing —
it is the questions it forces while everything is still cheap to change: how many users, what
the read/write mix is, which of the scaling phase-gates the design must not foreclose, and what
the server and edge have to provide. Answering those after ten features means answering them
against decisions already made.

The output is also the honest **not-required** list. A project sized for hundreds of users does
not need the infrastructure a project sized for hundreds of thousands does, and knowing which
one you are building is what stops the first feature carrying machinery it will never use.

_Done when both snapshots carry real figures rather than `TBD` markers, and the scaling
phase-gate the project is designing under is named._

Next: `project-management/workflows/01-feature/` — chart the first feature against both.

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
