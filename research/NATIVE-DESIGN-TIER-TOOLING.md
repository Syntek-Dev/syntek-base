# Native design tier — tools, editors and human approval for a script-first 04–08

**Written**: 09/10/2026 · **Driver**: `MAP-NATIVE-DESIGN-TIER` **N-001 to N-006** (the research
nodes resolved at CHART Step 7) · **Charted at**: `1d1290d`

**Method.** Six research legs, then four adversarial verification legs that tried to refute the
load-bearing claims, then two critique passes over the chart they fed. The `context7` and
Perplexity tiers returned invalid-API-key errors for the whole session and were **not consulted**
(`code/docs/GATE-REPORTING.md`: could not look, not looked-and-clean). Primary sources were found
with WebSearch and read with the `scrapling` MCP `get` tool, `gh api`, `nix eval` and local renders
in `/tmp`. Nothing here is quoted: every line is re-authored and cited, so the no-grant rule in
`research/CLAUDE.md` never bites. This note never ships — `copier.yml:146` excludes `/research/**`.

---

## Question

What does the PM design tier (`project-management/src/04`–`08`) hold today, and which renderers,
editors, sibling-template patterns and GitHub mechanisms can carry a script-first replacement for
Claude Design — artefacts authored in Markdown, rendered headless to HTML on vanilla CSS, human
edits never silently overwritten, and approval granted only by a human?

## Verdict

The tier holds templates only, and nothing produces the diagram images its docs promise. Python
with the already-pinned Playwright can render Markdown, Mermaid (inside the page, no Node) and
PDF, so neither a Node CLI nor a specialist renderer is needed — but the Mermaid bundle must be
fetched at build time, never committed. ArtCraft's studio is unusable here; its sibling VectorCraft
has a verified CLI and MCP server but was created nine days ago. On this host every agent holds the human's
GitHub token, so any approval resting on a GitHub account can be produced by an agent; a signing
key that needs a physical touch is the only measured signal of human presence.

---

## Claims

### N-001 — the design tier as it stands (measured in the repository, 09/10/2026)

1. Each of `04`–`08` holds its `CONTEXT.md`/`CLAUDE.md` pair, three stage folders with one
   `*000-TEMPLATE*` each, and one cumulative asset folder. Fourteen of the fifteen stage templates
   are Markdown; the exception is `08-WIREFRAMES/USER-STORY-IDEAS/WF-IDEA-US000-TEMPLATE.html`.
   (repository listing)
2. Nothing produces a diagram image. `ERD-DIAGRAMS/` and `DIAGRAMS/` hold only their pair, yet the
   folders promise Mermaid PNG exports and the consolidated templates instruct a re-export on
   sign-off and carry a "re-exported" sign-off box; no script, workflow step or CI job runs a
   diagram renderer. (`project-management/src/04-DATABASE/CLAUDE.md:54-55`,
   `05-USER-FLOW/CLAUDE.md:54`; `04-DATABASE/CONSOLIDATED-IDEAS/DB-CONSOLIDATED-000-TEMPLATE.md:132`
   and `:144`; `05-USER-FLOW/CONSOLIDATED-IDEAS/USER-FLOW-CONSOLIDATED-000-TEMPLATE.md:96` and
   `:107`)
3. `brand_guide.py` (638 lines) and `components.py` (406) hold their values as Python literals,
   write `.tex`, and call xelatex. `--check` compares the `.tex` only. No `code/src/scripts/**`
   wrapper calls either, no CI or lefthook job runs them, and both are run as raw `python3`.
   (`06-BRAND-GUIDE/guide-build/brand_guide.py:21-25`, `:47-205`, `:559-634`;
   `07-COMPONENTS/component-build/components.py:49-66`, `:337-402`; `pyproject.toml:151-160`)
4. Token values live in three hand-synced copies — the `brand_guide.py` inputs, the
   `components.py` palette and the `wireframe.css` `:root` — and they have drifted: colours agree,
   but the large radius is 14 px in one and 16 in another, a 28 px type step exists outside the
   brand scale, and the dark-pair border colour differs from the palette border.
   (`08-WIREFRAMES/SHARED/wireframe.css:20-66`; `brand_guide.py:47-205`; `components.py:49-66`)
5. The DB-canonical token layer is declared, not wired, and no design-token app exists under
   `code/src/django/apps/`. (`code/docs/DESIGN-TOKENS.md:16-17`)
6. `render-slop.sh` scans `08-WIREFRAMES/CONSOLIDATED-IDEAS` only, at 1280 × 800, warns only, and
   exits 0 with a note when no browser is installed. `css-tokens.sh` scans web CSS only. `06` and
   `07` have no script gate. (`code/src/scripts/audits/render-slop.sh:79` scope, `:7` and `:63`
   warn-only, `:86-87` viewport, `:409-431` no-browser exit;
   `code/src/scripts/audits/css-tokens.sh:50-53`)
7. Three export scripts hard-code Chrome at `/usr/bin/google-chrome`, `/usr/bin/chromium-browser`
   and `/snap/bin/chromium`, none present on NixOS; `export-design-docs.sh` expects six
   Foundations, Components and Patterns HTML files that nothing produces; `export-pm-files.sh` has
   its own Markdown converter and strips Mermaid blocks.
   (`project-management/src/00-ASSETS/scripts/export-design-docs.sh:28-29`, `:63`, `:73-80`;
   `export-wireframes.sh:74`; `export-pm-files.sh:236`, `:500-510`)
8. Claude Design is still named for brand ideation, artifacts are still disabled with the
   deprecated key, and the predecessor map's five slices were never cut.
   (`project-management/workflows/06-brand-guides/CONTEXT.md:34`, `CLAUDE.md:17`;
   `.claude/settings.json:230`; `project-management/src/02-STORIES/CUT-PLAN.md:393-406`)
9. Design sign-off is free text: a `**Status:**` line in the DB idea template, a
   `**Consolidated by**` field in all five consolidated templates, and workflow `04` telling the
   reader to record sign-off in the document or a PR review.
   (`04-DATABASE/USER-STORY-IDEAS/DB-IDEA-US000-TEMPLATE.md:9`;
   `project-management/workflows/04-database-schema/STEPS.md:75-78`)
10. The repository pins Playwright 1.61.0, which needs Chromium revision 1228; the current NixOS
    system generation roots only a browser bundle at revision 1243 (Playwright 1.63), and 1228
    survives only through older generations. (`pyproject.toml:106`; `render-slop.sh:114`; Nix
    store root query, 09/10/2026)
11. `markdown-it-py` 4.2.0 and `mdit-py-plugins` 0.6.1 reach the lock only through the dev and
    test groups (`pip-audit`, `mutmut`); `pyyaml` 6.0.3 also arrives through the runtime
    `uvicorn[standard]`. None of the three is declared directly. (`uv.lock:1048`, `:1065`,
    `:1537`, `:1937`; `pyproject.toml:26`)
12. `copier.yml` excludes `/project-management/src/**` and re-includes the pairs, templates, the
    `00-ASSETS` scripts, both generators' `.py`/`.tex`, and `wireframe.css`; with
    `_templates_suffix: ""` and `<%` delimiters, every shipped file is rendered as a template.
    (`copier.yml:16`, `:27`, `:157-174`)
13. Stale references, each at its own line: `07-COMPONENTS/component-build/components.py:11`
    names `05-BRAND-GUIDE`; `08-WIREFRAMES/SHARED/wireframe.css:21` says it mirrors `05/06`;
    `06-BRAND-GUIDE/USER-STORY-IDEAS/CLAUDE.md:29`, `:34` and
    `08-WIREFRAMES/USER-STORY-IDEAS/CLAUDE.md:36`, `:40` name workflow `17` as the consolidation
    gate; `workflows/04-database-schema/CHECKLIST.md:24` and
    `workflows/05-user-flow-design/CHECKLIST.md:26` name root-level files that contradict stage
    naming; `workflows/06-brand-guides/CLAUDE.md:42-43` and `CONTEXT.md:38` name
    `BRAND-COLOURS.md`-style outputs; `00-ASSETS/CLAUDE.md:19-20` and `:25` contradict each
    other.

### N-002 — the ArtCraft family (two independent passes)

1. ArtCraft is an AI image, video and 3D studio driving hosted models. Its licence calls itself
   a work-in-progress fair-source licence, is not OSI-approved, forbids building a competing
   product and limits reuse of the code, while use of the app and of generated media is
   unrestricted. No CLI, MCP or headless mode is documented; the hosted backend carries
   undocumented MCP-session endpoints in code. Desktop releases are macOS and Windows; Linux is
   build-from-source; a web app exists.
   (https://github.com/storytold/artcraft — `README.md`, `LICENSE.md`, `ROADMAP.md`,
   `crates/api_clients/artcraft/artcraft_api_defs/src/mcp_sessions/create_mcp_session.rs`;
   https://getartcraft.com/download)
2. PhotoCraft, VectorCraft and DesignCraft exist under the same organisation, were created
   30/09–01/10/2026, released v0.5.0, v0.7.0 and v0.4.0 on 08/10/2026, and are dual-licensed MIT
   OR Apache-2.0. (`gh api repos/storytold/{photocraft,vectorcraft,designcraft}` and their
   releases; each repo's `LICENSE-MIT`, `LICENSE-APACHE`, `Cargo.toml`)
3. VectorCraft's CLI has `mcp`, `run`, `commands`, `convert`, `info`, `bench` and `perf`. Its MCP
   server runs over stdio, either headless with a CPU renderer or attached to the running app, and
   exposes document inspection, open/save, export, screenshot and drawing tools. Its native
   `.vectorcraft` format is JSON (optionally gzip-compressed); SVG is imported and exported, and
   saving to SVG reports what the format loses.
   (https://github.com/storytold/vectorcraft — `apps/vectorcraft-cli/src/main.rs:114-121`,
   `docs/mcp.md`, `README.md`)
4. PhotoCraft is a raster editor whose CLI has `convert`, `info`, `run`, `batch`, `droplet`,
   `commands`, `mcp` and `serve`. (https://github.com/storytold/photocraft —
   `apps/photocraft-cli/src/lib.rs:63-82`)
5. DesignCraft is a page-layout app with a JSON native format, IDML exchange and PNG/JPEG export;
   its roadmap lists PDF export and placed SVG as done while its README still lists PDF as
   planned. (https://github.com/storytold/designcraft — `README.md:90`, `ROADMAP.md:8`, `:19-20`,
   `:157`, `docs/mcp.md`)
6. The Linux packages of all three install the CLI at `/usr/bin/<app>-cli`. (each repo's
   `packaging/linux/nfpm.yaml`; release tarball listings)
7. Maturity signals: the top committer on all three is an account named `claude` (664, 817 and
   283 commits — 817 of VectorCraft's 1,719), each repo opens with bulk first-day drops, star counts reached roughly 34k, 5k
   and 2k within ten days with no timeline obtainable here, the organisation is unverified, and
   the docs contradict themselves. (`gh api` contributor and repository metadata; the READMEs)
8. No binary was run. The prebuilt Linux builds target generic glibc, so NixOS would need
   `appimage-run`, `nix-ld` or a source build — untested. (`docs/releasing.md` in each repo)

### N-003 — renderers and the Mermaid paths

1. `mcp-mermaid` renders through `mermaid-isomorphic` (Playwright with Mermaid 11). Its npm
   `latest` is 0.4.1 (12/02/2026); 0.5.1 and 0.6.1 were published then pulled. The repository
   launches it unpinned with install scripts disabled; on this host every call fails because no
   Chromium of the expected revision exists. It renders before it checks the requested output
   type, and its URL output modes encode the full diagram source into a public mermaid.ink link.
   (https://github.com/hustcc/mcp-mermaid — `package.json`, `src/utils/render.ts`;
   https://registry.npmjs.org/mcp-mermaid; `.mcp.json:13-19`; `.codex/config.toml:20-25`)
2. Re-enabling its install scripts would not repair it on NixOS: the post-install step asks
   Playwright to install system dependencies through the distribution package manager first
   (an inference from how `--with-deps` is documented, not executed). A working route needs a
   pinned Playwright matched to a host browser bundle. (https://playwright.dev/docs/browsers;
   `package.json` of https://github.com/hustcc/mcp-mermaid for the post-install command)
3. `dist/mermaid.min.js`, loaded into a page from Python Playwright, returns an SVG from
   `mermaid.render` for both 11.17.2 and 12.1.0 — no Node at runtime, a Chromium at the
   Playwright pin required. The single-file bundle is about 3.6 MB at 11.17.2 and 5.5 MB at
   12.1.0; the ESM build is a hundred-plus chunk files. (local render in `/tmp`, 09/10/2026;
   https://www.npmjs.com/package/mermaid)
4. The 12.x bundle inlines elkjs, licensed EPL-2.0; the 11.x bundle does not. (string search of
   both bundles, 09/10/2026; https://github.com/kieler/elkjs)
5. Committing the bundle would break `copier copy`: it contains a DOMPurify regular expression
   with `<%`, which Jinja rejects under this repository's delimiters, and Copier falls back to a
   plain copy only on a decode error, not a syntax error. (`copier.yml:16`, `:27`; local test,
   09/10/2026; https://github.com/copier-org/copier — `copier/_main.py`)
6. Mermaid's configuration schema defaults `deterministicIds` to false and `handDrawnSeed` to 0
   (random); both may be set in a diagram's front matter. Two `mmdc` renders of one ERD differed
   byte-for-byte until both were set. (https://github.com/mermaid-js/mermaid —
   `packages/mermaid/src/schemas/config.schema.yaml`; local renders, 09/10/2026)
7. `@mermaid-js/mermaid-cli` 12.0.0 (24/09/2026) requires Mermaid 12, which moved most diagram
   types to the ELK layout and a new default theme and look. (https://github.com/mermaid-js/mermaid-cli
   — tag `12.0.0`; https://github.com/mermaid-js/mermaid — release `mermaid@12.0.0`)
8. GitHub renders Mermaid fenced blocks in Markdown files and pull requests.
   (https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-diagrams)
9. Specialist renderers, for the record: Graphviz (EPL-2.0, C); PlantUML (licence-choice jars,
   Java); `@dbml/cli` (Apache-2.0) and `dbml-renderer` (ISC), both Node; D2 (MPL-2.0, Go, fully
   repeatable here, with a closed paid layout engine, TALA); Kroki (MIT, but its public service
   sends source off the host); django-extensions `graph_models` (MIT, needs django-extensions);
   Structurizr (Apache-2.0, image export via Playwright). (https://graphviz.org/license/;
   https://github.com/plantuml/plantuml — `README.md`; https://dbml.dbdiagram.io/cli/;
   https://d2lang.com/tour/tala/; https://docs.kroki.io/kroki/setup/install/;
   https://github.com/django-extensions/django-extensions — `docs/graph_models.rst`;
   https://docs.structurizr.com/export)
10. Editors: Inkscape 1.4's CLI exports headless and can save plain SVG without editor namespaces;
    draw.io Desktop changed from Apache-2.0 to GPL-3.0 on 23/09/2026 and needs Xvfb in CI;
    Penpot's MCP server works through a live browser plugin; the Excalidraw MCP export uploads to
    excalidraw.com; tldraw needs a licence key for production use.
    (https://inkscape.org/doc/inkscape-man.html; https://github.com/jgraph/drawio-desktop —
    `LICENSE` history; https://help.penpot.app/mcp/; https://github.com/excalidraw/excalidraw-mcp;
    https://github.com/tldraw/tldraw — `LICENSE.md`)
11. perceptualdiff is GPL-2.0 upstream, and nixpkgs no longer carries it: evaluating its attribute
    there throws, giving vulnerabilities in its FreeImage dependency as the reason.
    (`gh api repos/myint/perceptualdiff/license`; `nix eval nixpkgs#perceptual-diff`, 09/10/2026)
12. Validation: Playwright for Python will not get `toHaveScreenshot` (issue closed as not
    planned), and Playwright's own docs say pixel baselines vary by OS, browser version and
    hardware; `coloraide` (MIT) computes WCAG contrast; `wcag-contrast-ratio` is unmaintained since
    2015; the design-tokens format reached its first stable version in 10/2025 as a Community
    Group report, not a W3C standard. (https://github.com/microsoft/playwright-python/issues/837;
    https://playwright.dev/docs/test-snapshots;
    https://facelessuser.github.io/coloraide/contrast/;
    https://www.w3.org/community/design-tokens/2025/10/28/design-tokens-specification-reaches-first-stable-version/)

### N-004 — the sibling templates (`syntek-media` at `4d508a9`, `syntek-author` at `9a65902`)

1. Both are Copier templates in syntek-base's lineage — paired `CONTEXT.md`/`CLAUDE.md`, numbered
   workflows with routing front matter. (https://github.com/Syntek-Dev/syntek-media —
   `copier.yml`; https://github.com/Syntek-Dev/syntek-author — `copier.yml`)
2. Their tools are stdlib argparse CLIs exiting 0 clean, 1 findings, 2 could not run; every tool
   has a `--self-test`, and a skip is never reported as a pass; heavy dependencies run as PEP 723
   scripts under `uv run` with Playwright pinned. (media `template/toolkit/media.py`,
   `template/toolkit/card.py`; author `template/tooling/`)
3. A tracked output is replaced only when git shows it committed and unchanged, and every write
   goes through a temporary file and an atomic rename; generated folders are denied to the `Edit`
   tool. (media `template/toolkit/media_common.py` — `clean_tracked_output`, `output_path`,
   `replace_file`; `template/.claude/settings.json`)
4. Before any skill changes a draft, a difference from the last recorded state is logged as the
   author's revision first, on an append-only ledger that also records rejected proposals.
   (author `template/standards/style/ledger/CLAUDE.md`; `template/tooling/provenance.py`)
5. An external copy that differs from the tracked file is saved beside it, dated, never over it.
   (author `template/.github/workflows/google-drive-pull.yml`)
6. Renders are hermetic: every network request is aborted, fonts are awaited, and the output's
   size is read back. (media `template/toolkit/card.py`, `template/toolkit/scene.py`)
7. Approval is a dated gate ladder: explicit wording only, a recorded approval file, and gates
   reopened by a material change. Neither repository hashes an approval or uses CODEOWNERS.
   (author `template/standards/verification/verification.md`,
   `template/.claude/skills/promote-section/SKILL.md`,
   `template/planning/workflows/07-record-an-approval/STEPS.md`; media
   `template/.claude/rules/syntek-media/03-production-ethics.md`)
8. Neither has diagram tooling, a computed accessibility check, or an editor integration of the
   ArtCraft kind. (both trees, searched)

### N-005 — GitHub approval mechanics, and this repository's identity

1. The repository belongs to the organisation Syntek-Dev on the Free plan. Its only member and
   only collaborator is `Syntek-Studio`, an organisation admin; it is the sole code owner; `gh` on
   this host also holds two inactive accounts. (`gh api` collaborators, members, organisation;
   `.github/CODEOWNERS:4`; `gh auth status`)
2. The ruleset on `main` requires 0 approvals, leaves code-owner review and last-push approval
   off, dismisses stale reviews, and lets the admin role bypass the whole ruleset at all times.
   (`gh api repos/Syntek-Dev/syntek-base/rulesets`)
3. All twelve pull requests were authored and merged by `Syntek-Studio` with no review. Actions
   cannot approve pull requests at repository level; the organisation-level value was unreadable
   with this token. (`gh api` pulls, reviews, actions permissions)
4. A pull request's author cannot approve it, and repository owners and administrators can merge
   without any approving review
   (https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/approving-a-pull-request-with-required-reviews).
   Stale approvals can be dismissed on push; last-push
   approval requires someone other than the last pusher; CODEOWNERS is read from the base branch;
   only approvals from accounts with write access count. (https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets;
   https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners)
5. A submitted review can be dismissed and its body edited, but not deleted; its user may be
   null. (https://docs.github.com/en/rest/pulls/reviews)
6. A commit signature proves possession of a key, not presence of a person; security-key SSH
   keys (`ed25519-sk`) generally require a touch for each operation.
   (https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification;
   https://man.openbsd.org/ssh-keygen)
7. `claude-code-action` declines to approve pull requests by its own policy, not because GitHub
   prevents it. (https://github.com/anthropics/claude-code-action — `docs/capabilities-and-limitations.md`)
8. Workflow runs and their logs follow the repository's retention period, 90 days by default, so
   a CI log is not durable approval evidence.
   (https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository)
9. On this host the active `gh` account and the git user are both `Syntek-Studio`, with the `gh`
   credentials stored in the user's own `~/.config/gh/hosts.yml`. Agent sessions run as that same
   operating-system user, so every agent inherits the token and identity the human approves with.
   (`gh auth status`; `git config user.name`, 09/10/2026)

### N-006 — agent hosts (an input to `MAP-INSTRUCTION-DELIVERY` N-001, which owns discovery)

| Host        | Instruction files                                         | MCP configuration                         | Skills                                     |
| ----------- | --------------------------------------------------------- | ----------------------------------------- | ------------------------------------------ |
| Claude Code | `CLAUDE.md`; `AGENTS.md` only when no `CLAUDE.md` exists  | project `.mcp.json`, `${VAR}` expansion   | `.claude/skills/`                          |
| Codex       | `AGENTS.md` chain from the root, 32 KiB budget, fallbacks | `.codex/config.toml` for trusted projects | `.agents/skills/`                          |
| Antigravity | `AGENTS.md`, `GEMINI.md`, `.agents/rules/*.md`            | workspace `.agents/mcp_config.json`       | `.agents/skills/`                          |
| opencode    | `AGENTS.md`, falling back to `CLAUDE.md`                  | `opencode.json`                           | `.agents/skills`, `.claude/`, `.opencode/` |
| Cline       | `.clinerules/`, `AGENTS.md`                               | global settings only                      | `.agents/skills`, `.claude/skills`, others |
| Goose       | `AGENTS.md`, `.goosehints`                                | global `config.yaml`                      | `.agents/skills`, `.claude/skills`         |
| Aider       | files passed with `--read`                                | none                                      | none                                       |

Antigravity workflows stop working on 19/10/2026 in favour of skills, and its default sandbox has
no network. (https://code.claude.com/docs/en/memory; https://code.claude.com/docs/en/mcp;
https://developers.openai.com/codex/guides/agents-md; https://developers.openai.com/codex/mcp;
https://antigravity.google/docs/rules; https://antigravity.google/docs/mcp;
https://antigravity.google/docs/skills;
https://antigravity.google/docs/migration/workflows-to-skills; https://opencode.ai/docs/rules/;
https://docs.cline.bot/customization/cline-rules;
https://goose-docs.ai/docs/guides/context-engineering/using-goosehints/;
https://aider.chat/docs/usage/conventions.html)

---

## Sources

- **This repository** — the paths cited per claim, at `1d1290d`.
- **ArtCraft family** — https://github.com/storytold/artcraft · https://github.com/storytold/photocraft ·
  https://github.com/storytold/vectorcraft · https://github.com/storytold/designcraft ·
  https://getartcraft.com/apps · https://getartcraft.com/download
- **Mermaid** — https://github.com/hustcc/mcp-mermaid · https://registry.npmjs.org/mcp-mermaid ·
  https://github.com/remcohaszing/mermaid-isomorphic · https://github.com/mermaid-js/mermaid ·
  https://github.com/mermaid-js/mermaid-cli · https://www.npmjs.com/package/mermaid ·
  https://github.com/kieler/elkjs
- **Renderers and editors** — https://graphviz.org/license/ · https://github.com/plantuml/plantuml ·
  https://dbml.dbdiagram.io/cli/ · https://d2lang.com/tour/tala/ · https://docs.kroki.io/ ·
  https://github.com/django-extensions/django-extensions · https://docs.structurizr.com/export ·
  https://inkscape.org/doc/inkscape-man.html · https://github.com/jgraph/drawio-desktop ·
  https://help.penpot.app/mcp/ · https://github.com/excalidraw/excalidraw-mcp ·
  https://github.com/tldraw/tldraw
- **Validation** — https://github.com/microsoft/playwright-python/issues/837 ·
  https://playwright.dev/docs/test-snapshots · https://facelessuser.github.io/coloraide/contrast/ ·
  https://www.w3.org/community/design-tokens/
- **Copier** — https://github.com/copier-org/copier
- **GitHub** — the docs and REST pages cited under N-005 ·
  https://github.com/anthropics/claude-code-action
- **Agent hosts** — the pages cited under N-006
- **Sibling templates** — https://github.com/Syntek-Dev/syntek-media (`4d508a9`) ·
  https://github.com/Syntek-Dev/syntek-author (`9a65902`)

## Feeds

`MAP-NATIVE-DESIGN-TIER` grilling nodes **N-007 to N-019** (09/10/2026), and through them the
`ADR-US###-*` records their slice stories author. No ADR or `STORY-PLAN-US###` exists yet; each
links back here by path when it does.

`MAP-INSTRUCTION-DELIVERY` **N-001** (09/10/2026) — the agent-host facts under N-006 are an input
to that map's open research node, which owns agent discovery; its next RESOLVE cites this note.
