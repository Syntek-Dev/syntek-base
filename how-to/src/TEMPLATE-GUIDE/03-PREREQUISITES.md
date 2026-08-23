# Prerequisites

**Last Updated**: 23/08/2026

What must be on your machine before generating a project, and how to verify it.

---

## Supported platforms

Every development operation runs through a `code/src/scripts/**/*.sh` script, so the shell is
part of the contract rather than a preference.

| Platform    | Supported         | What you use                                                                                                                                                              |
| ----------- | ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Linux**   | Natively          | Docker Engine and the Compose v2 plugin, with your user in the `docker` group. Your normal shell.                                                                         |
| **macOS**   | Natively          | Docker Desktop, or Colima if you prefer no GUI. bash or zsh, Apple silicon or Intel.                                                                                      |
| **Windows** | **Through WSL 2** | Docker Desktop on the **WSL 2 backend**, the repository cloned **inside** the WSL 2 filesystem (`~/projects/…`, never `/mnt/c/…`), and every command run from that shell. |

**On Windows, WSL 2 is required, not a fallback**, and the two halves of that are separate
requirements — the backend, and where the files live:

- **PowerShell, `cmd.exe` and Git Bash are not supported.** Git Bash gives you a bash, but MSYS
  path translation rewrites the arguments these scripts pass to `docker compose`, so commands
  that look correct fail with paths nobody wrote.
- **Clone into the WSL 2 filesystem, not `/mnt/c/…`.** A repository on the Windows filesystem puts
  every bind mount across the filesystem boundary, which is slow enough to make the dev loop
  unpleasant on its own — and it is the configuration most Windows developers land in by default.

Docker Desktop already installs WSL 2 to run its own engine, so none of this asks for a component
you would not have. Install it from a WSL 2 terminal exactly as the Linux instructions below
describe, and treat the distribution as the machine from then on.

---

## The short version

```bash
docker --version && docker compose version   # 24+ / v2+
node --version && pnpm --version             # 24+ / 11.22.0+
python3 --version && uv --version            # 3.14+ / 0.11+
git --version && openssl version
```

Copier itself needs no installation — `uvx` fetches and runs it on demand.

---

## What each is for

| Tool               | Minimum     | Needed for                                                               |
| ------------------ | ----------- | ------------------------------------------------------------------------ |
| **git**            | any recent  | Version control; Copier reads the template over git.                     |
| **Docker Engine**  | 24+         | Every application service. Nothing runs on the host directly.            |
| **Docker Compose** | v2 (plugin) | Orchestrating the dev, test, staging and prod stacks.                    |
| **uv**             | 0.11+       | Python dependencies and the lockfile; also provides `uvx` to run Copier. |
| **Python**         | 3.14+       | Root tooling (ruff, basedpyright) and uv's interpreter resolution.       |
| **Node.js**        | 24+         | Repo tooling and git hooks. Not an application dependency.               |
| **pnpm**           | 11.22.0+    | Root workspace packages — Prettier, ESLint, markdownlint, Lefthook.      |
| **openssl**        | any recent  | `install.sh` uses it to generate development secrets.                    |

**Those floors are the ones `install.sh` actually checks** — it is the executable copy of this
table, and it refuses rather than warning. The pnpm figure is not a round number on purpose:
`package.json` sets `packageManager: pnpm@11.22.0` and an `engines` floor to match, so an older
pnpm fails the install rather than resolving a different tree quietly.

`.python-version` pins `3.14`, `.nvmrc` pins `24`, and `package.json` pins pnpm exactly through
`packageManager` — so a version manager plus `corepack` will land you on the right ones without
being asked.

Two more become prerequisites only if you opt into a surface: **rustup** for `INCLUDE_RUST`
(because the PyO3 crate is a uv workspace member built by maturin, so `uv sync` needs a Rust
toolchain), and the **Expo Go** app on a phone for `INCLUDE_MOBILE`.

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
the test stack runs Postgres, Valkey, Nginx and the app together (and a Celery worker too, once
that is wired — it is a declared dependency with no Compose service at baseline).

**Windows** — Docker Desktop with the WSL 2 backend, then run the Linux instructions above from
inside the distribution. The full contract, including where the repository must live, is
_Supported platforms_ at the top of this guide.

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

A generated project serves itself at `dev.<project-slug>.localhost:81` rather than
`localhost:8000`. The port is **81** because a local router often holds `127.0.0.1:80`, and `:8000`
is the Django container's internal port, never published. On most Linux distributions and macOS,
`*.localhost` resolves to `127.0.0.1` automatically.

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

| Tool                        | For                                                                                                                                                                                                     |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Claude Code**             | The skills, hooks and MCP wiring. The template is far less useful without it. The suite uses the Fable tier, so it assumes **Claude Max 20× or above, or the Anthropic API** — see `08-CLAUDE-CODE.md`. |
| **Bruno**                   | Running the committed API collections through a GUI.                                                                                                                                                    |
| **`gh` CLI**                | PR creation from the terminal; the `pr` skill uses it.                                                                                                                                                  |
| **Claude Chrome extension** | Rendered UI inspection and browser automation. Nothing in the repository supplies it.                                                                                                                   |

The three MCP servers the project actually depends on — `code-review-graph`, `context7` and
`mcp-mermaid` — need **no installation**. They are declared in the shipped `.mcp.json` and
launched on demand through `uvx` and `npx`.

---

## Next

- Generate your first project → `04-QUICKSTART.md`
- Decide what to answer at the prompts → `05-ANSWERS.md`
