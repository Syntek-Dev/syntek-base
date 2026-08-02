# Prerequisites

**Last Updated**: 02/08/2026

What must be on your machine before generating a project, and how to verify it.

---

## The short version

```bash
docker --version && docker compose version   # 27+ / v2+
node --version && pnpm --version             # 24 / 11+
python3 --version && uv --version            # 3.14 / 0.11+
git --version && openssl version
```

Copier itself needs no installation — `uvx` fetches and runs it on demand.

---

## What each is for

| Tool               | Minimum     | Needed for                                                               |
| ------------------ | ----------- | ------------------------------------------------------------------------ |
| **git**            | any recent  | Version control; Copier reads the template over git.                     |
| **Docker Engine**  | 27+         | Every application service. Nothing runs on the host directly.            |
| **Docker Compose** | v2 (plugin) | Orchestrating the dev, test, staging and prod stacks.                    |
| **uv**             | 0.11+       | Python dependencies and the lockfile; also provides `uvx` to run Copier. |
| **Python**         | 3.14        | Root tooling (ruff, basedpyright) and uv's interpreter resolution.       |
| **Node.js**        | 24          | Repo tooling and git hooks. Not an application dependency.               |
| **pnpm**           | 11+         | Root workspace packages — Prettier, ESLint, markdownlint, Lefthook.      |
| **openssl**        | any recent  | `install.sh` uses it to generate development secrets.                    |

The application itself never runs on the host — no `python`, `pytest` or `pnpm` against your
machine's interpreter. Those versions matter for root tooling and for uv's resolution, not for
serving the app.

---

## Installing

### uv (and therefore uvx)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then restart your shell, or `source $HOME/.local/bin/env`. Full options:
<https://docs.astral.sh/uv/getting-started/installation/>

### Node and pnpm

Use a version manager rather than a system package, and let `.nvmrc` pick the version:

```bash
# fnm
curl -fsSL https://fnm.vercel.app/install | bash && fnm install 24

# or nvm
nvm install && nvm use          # reads .nvmrc once you are inside a generated project

corepack enable && corepack prepare pnpm@latest --activate
```

### Docker

**Linux** — install Docker Engine and the Compose plugin from your distribution, then add
yourself to the `docker` group so `docker compose` works without `sudo`:

```bash
sudo usermod -aG docker "$USER"   # log out and back in
```

**macOS** — Docker Desktop, or Colima if you prefer no GUI. Give it at least 4 CPUs and 8 GB;
the test stack runs Postgres, Valkey, Celery and the app together.

**Windows** — Docker Desktop with the WSL 2 backend, and do all your work **inside** the WSL 2
filesystem (`~/projects/…`, not `/mnt/c/…`). Bind-mount performance across the Windows filesystem
boundary is poor enough to make the dev loop unpleasant. Every command in these guides assumes
bash or zsh.

---

## Verifying

```bash
docker run --rm hello-world       # daemon reachable without sudo
uvx copier --version              # uvx can fetch and run a tool
```

If `docker run` needs `sudo`, fix the group membership before generating — several project
scripts assume a rootless-capable `docker compose`.

---

## Hostnames

A generated project serves itself at `dev.<project-slug>.localhost` rather than
`localhost:8000`. On most Linux distributions and macOS, `*.localhost` resolves to `127.0.0.1`
automatically.

If it does not, `install.sh` offers to add the `/etc/hosts` entries for you (it will ask for
sudo). For git worktrees, `code/src/scripts/development/hosts-story-add.sh` manages per-story
hostnames.

---

## Disk and memory

| Resource | Guidance                                                                                          |
| -------- | ------------------------------------------------------------------------------------------------- |
| Disk     | ~5 GB for images and volumes; a generated project's own tree is small (a few MB)                  |
| Memory   | 8 GB workable, 16 GB comfortable — the test stack runs a second Postgres and Valkey alongside dev |
| CPU      | 4 cores workable. Playwright and the mutation-testing suite are the only heavy consumers.         |

---

## Optional

| Tool                               | For                                                                                                                                                                                                 |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Claude Code**                    | The agents, skills and hooks. The template is far less useful without it. The suite uses the Fable tier, so it assumes **Claude Max 20× or above, or the Anthropic API** — see `08-CLAUDE-CODE.md`. |
| **Bruno**                          | Running the committed API collections through a GUI.                                                                                                                                                |
| **`gh` CLI**                       | PR creation from the terminal; the `pr` agent uses it.                                                                                                                                              |
| **context7 / mermaid MCP servers** | Library docs and diagram rendering inside Claude Code.                                                                                                                                              |

---

## Next

- Generate your first project → `04-QUICKSTART.md`
- Decide what to answer at the prompts → `05-ANSWERS.md`
