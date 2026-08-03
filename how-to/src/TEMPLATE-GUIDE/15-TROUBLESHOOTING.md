# Troubleshooting

**Last Updated**: 02/08/2026

What breaks, why, and what to do. Grouped by when it happens.

---

## Generation

### `<%SOMETHING%>` survived in the generated project

A token exists in the tree but not in `copier.yml`. This is a template bug —
[report it](https://github.com/Syntek-Dev/syntek-base/issues) with the file and token.

Locally, fix by hand:

```bash
grep -rIn '<%[A-Z_]*%>' . --exclude-dir=.git
```

### A token came out mangled — the underscore became an asterisk

**Prettier did it.** Token names contain underscores, and Prettier's Markdown formatter treats
`_` as emphasis. When a paragraph contains a token and nearby `_emphasis_`, Prettier can pair the
token's underscore with the emphasis marker and rewrite both — silently replacing the underscore
in `<%PROJECT_NAME%>` with an asterisk. The result renders as an undefined variable and
disappears from the generated project.

This is a defect in the template, not in your project. After running any formatter over the
Markdown, check:

```bash
bash .github/scripts/check-template-tokens.sh
```

It reports mangled tokens, tokens that are not registered questions in `copier.yml` (they render
to nothing), and unclosed `<%` delimiters (they kill generation outright). CI runs it on every
pull request as **[1/2] Template Tokens**.

To avoid the problem in the first place, prefer `**bold**` over `_emphasis_` in any paragraph that
also contains a token.

### `TemplateSyntaxError` during generation

A file contains something Jinja tried to parse with the custom delimiters — a literal `<%`, `<:`
or `<~`. The fix in the template is to wrap it:

```text
<: raw :>
content with <% literal delimiters %>
<: endraw :>
```

Report it; the sequences were verified absent when the delimiters were chosen, so this means new
content introduced one.

### `UnicodeDecodeError` on some file

A binary file is being rendered. `_templates_suffix: ""` makes Copier attempt every file, so
binaries must be in `_exclude`. Currently only `*.pdf` needs it. A new binary asset type needs
adding to the exclude list.

### The `mv .copier/README.md` task failed

`.copier/README.md` was not copied — usually because an `_exclude` pattern matched it. Remember
`_exclude` uses **gitignore semantics**: an unanchored `README.md` matches at every depth. Root-only
patterns need a leading slash.

### Copier generated an old version

`copier copy` uses the **latest git tag**, not `main`. To take the tip:

```bash
copier copy --vcs-ref=HEAD gh:Syntek-Dev/syntek-base my-project
```

### `--vcs-ref=HEAD` on a local path ignores my uncommitted changes

It reads committed state. To test uncommitted template work, generate from a copy with no `.git`:

```bash
rsync -a --exclude=.git --exclude=node_modules /path/to/syntek-base/ /tmp/tmpl/
copier copy --trust --defaults /tmp/tmpl /tmp/check
```

---

## First run

### Docker build fails on `COPY pyproject.toml uv.lock ./`

`uv.lock` does not exist. It is deliberately not shipped — the template's package name is a token
until rendered, so no valid lock can exist upstream.

```bash
uv lock
git add uv.lock && git commit -m "chore: add lockfile"
```

### `dev.<slug>.localhost` does not resolve

Most systems resolve `*.localhost` automatically; some do not.

```bash
echo "127.0.0.1 dev.<your-slug>.localhost" | sudo tee -a /etc/hosts
```

`bash install.sh` offers to do this.

### Port already allocated

A local Postgres (5432), Redis/Valkey (6379) or web server (80) is running. Stop the host service,
or change the published port in `code/src/docker/docker-compose.dev.yml`.

```bash
ss -tulpn | grep -E ':(80|5432|6379|8000)'
```

### `permission denied` running a script

```bash
bash install.sh          # sets executable bits on every project script
# or
chmod +x code/src/scripts/**/*.sh
```

### Docker needs `sudo`

```bash
sudo usermod -aG docker "$USER"    # then log out and back in
```

Several scripts assume `docker compose` works unprivileged.

### `install.sh` cannot find `uv` / `pnpm`

They must be on `PATH` in the shell running the script. If you installed uv in the same session,
`source $HOME/.local/bin/env` or restart the shell.

---

## Development

### Migrations will not apply

```bash
bash code/src/scripts/database/migrate.sh show     # what state are we in
bash code/src/scripts/database/migrate.sh check    # unapplied or conflicting
```

Conflicting migrations from parallel branches usually need a merge migration. In dev, the blunt
fix is:

```bash
bash code/src/scripts/database/reset.sh --seed     # destructive
```

### Tests pass locally, fail in CI

Common causes, in order of likelihood:

1. The test stack was not running locally in the same configuration.
2. A test depends on seeded data CI does not have.
3. Ordering dependence — CI runs a different order.
4. A stale lockfile: `[2/8] Lockfile Alignment` fails when the lock and manifest disagree.

```bash
bash code/src/scripts/tests/server.sh up
bash code/src/scripts/tests/all.sh --coverage
```

### `css-tokens.sh` fails

Component CSS used a raw value instead of `var(--token)`, or a token that does not resolve in the
token layer. Design values are DB-canonical — add the token through `/admin/design-tokens` or a
migration, never as a literal. See `code/docs/DESIGN-TOKENS.md`.

### The cloc audit fails

A source file passed 800 lines. Split it — the limit is 750 with grace to 800, and it is a design
signal rather than an arbitrary rule.

### The stub audit fails

`NotImplementedError`, `TODO`, `FIXME` or `HACK` reached a commit. Either finish it, or move it to
`GAPS.md` (active blocker) or `DEFERRED.md` (deferred to a named story) and remove the marker.

---

## Claude Code

### Claude ignores the conventions

It has not read the entry files. Start with:

```text
Read .claude/CLAUDE.md and .claude/MEMORY.md before doing anything.
```

If it persists, the target directory is probably missing its `CONTEXT.md`/`CLAUDE.md` pair.

### Claude asks endless questions

That is grilling, and it is deliberate (`.claude/CLAUDE.md` §10). For genuinely trivial work, say
so — "this is a mechanical rename, skip the grilling pass". To remove it entirely, edit §10.

### Context fills up

Do not compact — auto-compaction is disabled and intercepted. Run `/handoff`, which writes
`handoffs/HANDOFF-<DESCRIPTOR>-DD-MM-YYYY.md`, then `/clear` and resume from that file.

### The code-review-graph is stale

```bash
code-review-graph update
```

Refresh it whenever you revise the layered docs — they are two views of one codebase and are
meant to move together.

---

## Updating

### `copier update` refuses to run

The working tree is dirty. Commit or stash first.

### Conflicts everywhere

You have edited files the template also maintains. Resolve as a normal merge:

```bash
git diff --name-only --diff-filter=U
```

To reduce it next time, see the _Keeping updates cheap_ section of `11-CUSTOMISING.md`.

### Deleted files came back

`copier update` restores anything the template still ships. Delete again, or fork and add them to
`_exclude`.

### No `.copier-answers.yml`

The project predates Copier (generated with the old `setup.sh`), or the file was not committed.
Recreate it by hand from a fresh generation's format, filling in your values with `_src_path` and
`_commit`, then updates will work. See `14-UPDATING.md`.

---

## Still stuck

1. `TEMPLATE-GUIDE/` — the guide for the area you are in
2. `how-to/docs/DEVELOPMENT.md` and `CLI-TOOLING.md` — environment and commands
3. `GAPS.md` — it may be a known gap
4. [Open an issue](https://github.com/Syntek-Dev/syntek-base/issues) with the bug template

Security problems go through [private disclosure](https://github.com/Syntek-Dev/syntek-base/security),
never a public issue.
