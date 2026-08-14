# Quickstart — Generate to Running Stack

**Last Updated**: 14/08/2026

The short path from nothing to a project serving pages. Assumes `03-PREREQUISITES.md` is satisfied.

---

## 1. Generate

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
cd my-project
```

Copier asks thirty-four questions, plus four more between the optional surfaces if you opt into
them. Most have either a sensible default or a value derived from an earlier answer — pressing
Enter through the infrastructure and locale sections is a reasonable first pass. If you want to
think about them properly, read `05-ANSWERS.md` first.

You will be asked to trust the template, because generation runs post-tasks. Those tasks are the
four at the bottom of `copier.yml` and nothing else: move the seeded files (README, version state,
blank project memory, the scale-planning map) into place, un-ignore `uv.lock`, generate the lock,
and `git init`. Read them if you like — that is why they are short.

To skip the interview entirely and take every default:

```bash
uvx copier copy --trust --defaults \
  --data PROJECT_NAME="My Project" \
  --data ORG_NAME="My Org" \
  --data DEVELOPER_NAME="Your Name" \
  --data DEVELOPER_EMAIL="you@example.com" \
  --data DATE="02/08/2026" \
  gh:Syntek-Dev/syntek-base my-project
```

## 2. Check it rendered

<: raw :>

```bash
grep -rIo '<%[A-Z_]*%>' . --exclude-dir=.git | wc -l    # must print 0
```

<: endraw :>

Anything other than `0` is a template bug — please
[report it](https://github.com/Syntek-Dev/syntek-base/issues).

## 3. Install the toolchain

```bash
bash install.sh
```

This installs Python and JavaScript dependencies, copies every `.env.*` file from its example,
auto-generates development secrets with `openssl`, offers to add the `/etc/hosts` entries, marks
every project script executable, and writes a gitignored machine profile.

To go further and build the Docker stack and run migrations in the same pass:

```bash
bash install.sh --full
```

## 4. Fill in the environment files

`install.sh` creates them; the secrets it cannot invent are yours to add:

```text
code/src/docker/.env.dev
code/src/docker/.env.test
code/src/docker/.env.staging
code/src/docker/.env.production
```

Cloudinary credentials, mail settings, and any third-party keys go here. **Never commit these** —
only the `.env.*.example` templates are tracked.

Full variable reference: `how-to/docs/DEVELOPMENT.md`.

## 5. Start the stack

```bash
bash code/src/scripts/development/server.sh up
```

That brings up the four services `docker-compose.dev.yml` defines: Django (`django` — Uvicorn
`--reload` directly, for reliable hot-reload of `.py` and templates; staging and prod run
Gunicorn + Uvicorn workers instead), PostgreSQL (`db`), Valkey (`cache`) and Nginx (`nginx`).

Celery is **declared, not wired**: `celery[redis]` is a dependency in `pyproject.toml`, but no
Compose file defines a `worker` or `beat` service and no `CELERY_*` setting exists under
`code/src/django/config/settings/`. Wiring it is a deliberate change — read
`how-to/docs/CELERY-FIRST-RUN.md` before the first start in any long-lived environment.

**There is no mail catcher either.** Dev uses Django's console email backend
(`config/settings/dev.py`), so outbound mail is printed to the `django` container's stdout —
read it with `bash code/src/scripts/development/logs.sh --service django --follow`. Test uses the
in-memory backend. Adding Mailpit is a deliberate change, like any other service.

## 6. Migrate and seed

```bash
bash code/src/scripts/database/migrate.sh run
bash code/src/scripts/database/reset.sh --seed        # optional: dev accounts + fixtures
```

Or create a single superuser:

```bash
bash code/src/scripts/database/manageusers.sh create-superuser
```

## 7. Open it

| URL                                            | What                               |
| ---------------------------------------------- | ---------------------------------- |
| `http://dev.<project-slug>.localhost`          | The public site                    |
| `http://dev.<project-slug>.localhost/api/docs` | OpenAPI docs (dev only)            |
| `http://dev.<project-slug>.localhost/control/` | Django admin — note: not `/admin/` |

---

## 8. Commit the generation

```bash
git add -A
git commit -m "chore(template): generate from syntek-base"
```

Commit `uv.lock` — every Dockerfile builds with `uv sync --frozen` and the build fails without it.
Keep `.copier-answers.yml` too; `copier update` needs it.

## 9. Point Claude Code at it

Open the project and let Claude read `.claude/CLAUDE.md` then `.claude/MEMORY.md`. From there it
routes itself.

```text
Read .claude/CLAUDE.md and .claude/MEMORY.md, then give me a tour of this repository.
```

## 10. Four passes before any feature

These are `how-to/workflows/01-first-time-setup/` Steps 7–10. Run them **once, now, in this
order** — each depends on the one before, and every one of them is cheap today and expensive to
retrofit.

**1. Sharpen the brief.**

```text
Open CONTEXT.md — What this project is. Expand it into a real brief with me: what it
does, who for, what it replaces, and what it deliberately is not.
```

`PROJECT_DESCRIPTION` put your generation-time answer at the top of `CONTEXT.md`, which
`.claude/CLAUDE.md` imports — so it is the first thing every agent reads in every session, and
what every scope decision is measured against. A one-liner typed at a prompt is not that yet.

**2. Settle the voice.**

```text
Fill in how-to/src/BRAND-VOICE.md Section 3 and Section 5 with me.
```

Tone, person, formality, the reader, the signature, the never-this line, and the
say-this-not-that vocabulary. The reader comes straight from the brief, which is why it runs
second. Every skill that writes a user-facing string loads this file first, and
`code/src/scripts/audits/copy-emdash.sh` already enforces part of Section 4.

**3. Settle the visual direction.**

```text
Fill in code/docs/VISUAL-DESIGN.md Section 3 with me.
```

The same doctrine in composition rather than copy: name the direction, then give every one of
the six axes a setting — alignment, rhythm, contrast, ornament, density, motion. `editorial`
ships as the default. **Naming it is what makes Section 4.2's ban list decidable at all** — a centred
hero is a defect under `editorial` and correct under `classical-symmetric`, and with no direction
named there is nothing to judge against.

**4. Size it.**

```text
/scale-planning
```

Regenerates the two architecture snapshots (`how-to/src/SCALE-ARCHITECTURE/` and
`SERVER-ARCHITECTURE/`) against your actual code — they ship as skeletons full of
`TBD — regenerate via /scale-planning` markers and are not meaningful until you do.

Run it now rather than later, because its value is the questions it forces while everything is
still cheap to change — target users, read/write mix, which scaling phase-gate the design must
not foreclose — and because it is where **what you do not need** gets written down. That list is
what stops the first feature carrying machinery it will never use.

If any of the four is still carrying its `TBD` placeholders when you start planning, Claude is
required to say so before it plans anything.

---

## Common first-run problems

| Symptom                                          | Cause and fix                                                                 |
| ------------------------------------------------ | ----------------------------------------------------------------------------- |
| `COPY pyproject.toml uv.lock` fails during build | `uv lock` never ran. Run it at the project root, then rebuild.                |
| `dev.<slug>.localhost` does not resolve          | Add the `/etc/hosts` entry — `bash install.sh` offers this.                   |
| Port 5432 or 6379 already in use                 | A local Postgres or Redis is running. Stop it, or change the published port.  |
| `permission denied` on a script                  | `bash install.sh` sets the executable bits; run it, or `chmod +x` the script. |
| Docker asks for `sudo`                           | Add yourself to the `docker` group and log back in.                           |

More: `15-TROUBLESHOOTING.md`.

---

## Next

- Find your way around what you just generated → `07-REPO-TOUR.md`
- Understand the skill setup → `08-CLAUDE-CODE.md`
- Build the first feature → `10-FIRST-FEATURE.md`
