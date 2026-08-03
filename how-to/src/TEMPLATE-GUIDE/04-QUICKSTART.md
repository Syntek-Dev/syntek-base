# Quickstart — Generate to Running Stack

**Last Updated**: 02/08/2026

The short path from nothing to a project serving pages. Assumes `03-PREREQUISITES.md` is satisfied.

---

## 1. Generate

```bash
uvx copier copy gh:Syntek-Dev/syntek-base my-project
cd my-project
```

Copier asks twenty-four questions, plus two more for the mobile surface and one more for the
desktop surface, if you opt into them. Every one has
either a sensible default or a value derived from
an earlier answer — pressing Enter through the infrastructure and locale sections is a reasonable
first pass. If you want to think about them properly, read `05-ANSWERS.md` first.

You will be asked to trust the template, because generation runs post-tasks. Those tasks are the
four at the bottom of `copier.yml` and nothing else: move the README into place, un-ignore
`uv.lock`, generate the lock, and `git init`. Read them if you like — that is why they are short.

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

```bash
grep -rIo '<%[A-Z_]*%>' . --exclude-dir=.git | wc -l    # must print 0
```

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

That brings up Django (Gunicorn + Uvicorn, hot reload), the Celery worker and beat, PostgreSQL,
Valkey, Mailpit and Nginx.

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

| URL                                            | What                                |
| ---------------------------------------------- | ----------------------------------- |
| `http://dev.<project-slug>.localhost`          | The public site                     |
| `http://dev.<project-slug>.localhost/api/docs` | OpenAPI docs (dev only)             |
| `http://dev.<project-slug>.localhost/control/` | Django admin — note: not `/admin/`  |
| `http://dev.<project-slug>.localhost:8027`     | Mailpit, catching all outbound mail |

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
routes itself. Good first prompts:

```text
Read .claude/CLAUDE.md and .claude/MEMORY.md, then give me a tour of this repository.
```

```text
/scale-planning
```

`/scale-planning` regenerates the two architecture snapshots (`how-to/src/SCALE-ARCHITECTURE/`
and `SERVER-ARCHITECTURE/`) against your actual code — they ship as skeletons full of
`TBD — regenerate via /scale-planning` markers and are not meaningful until you do.

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
- Understand the agent setup → `08-CLAUDE-CODE.md`
- Build the first feature → `10-FIRST-FEATURE.md`
