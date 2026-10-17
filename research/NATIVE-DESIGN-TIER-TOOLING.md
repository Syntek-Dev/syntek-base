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
   `.claude/settings.json:230`; `project-management/src/02-STORIES/CUT-PLAN.md:492-511`)
9. Design sign-off is free text: a `**Status:**` line in the DB idea template, a
   `**Consolidated by**` field in all five consolidated templates, and workflow `04` telling the
   reader to record sign-off in the document or a PR review.
   (`04-DATABASE/USER-STORY-IDEAS/DB-IDEA-US000-TEMPLATE.md:9`;
   `project-management/workflows/04-database-schema/STEPS.md:75-78`)
10. The repository pins Playwright 1.61.0, which needs Chromium revision 1228; the current NixOS
    system generation roots only one bundle, whose browser is revision 1243 (Playwright 1.63); 1228
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
   30/09–01/10/2026, released `v0.5.0`, `v0.7.0` and `v0.4.0` on 08/10/2026, and are dual-licensed
   MIT OR Apache-2.0. (`gh api repos/storytold/{photocraft,vectorcraft,designcraft}` and their
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
2. Their tools are stdlib argparse CLIs whose exits mean clean (0), findings (1) and unable to run
   (2); each offers a `--self-test`, and a skip never turns into a pass; heavy dependencies run
   as PEP 723 scripts under `uv run` with Playwright pinned. (media `template/toolkit/media.py`,
   `template/toolkit/card.py`; author `template/tooling/`)
   (Corrected 15/10/2026 - see Addendum, N-004 at b841fd4.)
3. A tracked output is replaced only when git shows it committed and unchanged, and every write
   goes through a temporary file and an atomic rename; generated folders are denied to the `Edit`
   tool. (media `template/toolkit/media_common.py` — `clean_tracked_output`, `output_path`,
   `replace_file`; `template/.claude/settings.json`)
   (Corrected 15/10/2026 - see Addendum, N-004 at b841fd4.)
4. A draft that differs from its previously recorded state has the gap logged as the author's
   edit before any skill touches it, on an append-only ledger that keeps rejected proposals.
   (author `template/standards/style/ledger/CLAUDE.md`; `template/tooling/provenance.py`)
5. An external copy that differs from the tracked file is saved beside it, dated, never over it.
   (author `template/.github/workflows/google-drive-pull.yml`)
6. Renders are hermetic: every network request is aborted, fonts are awaited, and the output's
   size is read back. (media `template/toolkit/card.py`, `template/toolkit/scene.py`)
   (Corrected 15/10/2026 - see Addendum, N-004 at b841fd4.)
7. Approval is a dated gate ladder: explicit wording only, a recorded approval file, and a
   material change sends gates back open. Neither repository hashes an approval or uses CODEOWNERS.
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

### Added 15/10/2026, for the Addendum

- **syntek-media at `b841fd4`** — the local clone `~/Repos/syntek/syntek-media`, each path read
  with `git show b841fd4:<path>`; the ranges `f8dfbd2..b841fd4` and `b841fd4..95581d6` read with
  `git log --stat` and `git diff`; per-claim paths below. **Licence:** the tree at that commit
  holds no `LICENSE` or `COPYING` file (`git ls-tree -r`), and GitHub reports no licence for the
  public repository (`gh api repos/Syntek-Dev/syntek-media`), so nothing is granted. Facts only.
- **syntek-media PR #4** — https://github.com/Syntek-Dev/syntek-media/pull/4, branch
  `fix/toolkit-selftest-colour`, one commit, `7f71efe`; read with `gh pr view 4` and
  `gh pr diff 4` at 17:24 on 15/10/2026, when it was **open** and unmerged. Same repository, same
  licence position. Facts only.
- **syntek-media handoff, untracked** — `handoffs/HANDOFF-syntek-media-15-10-2026.md`, kept
  untracked in the media clone (`git status` lists `handoffs/` as untracked). Hash and time when
  read: sha256 `cdc6f0b7771f4cef93c2de3509fa8e26f023639276923bba5662f46b4a7a6f5f`, modified
  15/10/2026 16:44:20 BST. Still being edited, so it is cited by section heading and bullet, never
  by line. Unpublished maintainer notes, no licence. Facts only.
- **syntek-author at `b4669a5`** — the local clone `~/Repos/syntek/syntek-author` (branch
  `feat/shared-skills-update-report`, whose uncommitted work is not used); tracked files read
  with `git show b4669a5:<path>` and `git grep`. **Licence:** no `LICENSE` or `COPYING` file at
  that commit, and none reported by GitHub (`gh api repos/Syntek-Dev/syntek-author`). Facts only.
- **syntek-author handoff, untracked** — `handoffs/15-10-2026-shared-skills-update-report/` in
  that clone, kept out of Git by a root `.gitignore` that is itself untracked. As read:
  `HANDOFF.md`, sha256 `fcbaf0fd444403a2e16023e7ce237800054e23309e0d23d04a3ac2709fd1bf1c`,
  modified 15/10/2026 16:43:12 BST; `design/D50-data-root-proposal.md`, sha256
  `4d1276425d6569a2bad15a6f77d180b17d89dff3095bfeb75cc51ea6f4e52eec`, modified 15/10/2026
  11:03:06 BST, dated 14/10/2026 in its own header. Both cited by section heading and bullet; the
  proposal's line numbers are added in brackets as a convenience. Unpublished maintainer notes,
  no licence. Facts only.
- **This host's Nix store** — measured 15/10/2026 16:38 with `ls`, `find -maxdepth 2`,
  `nix-store -qR /run/current-system` and `nix-store -q --roots`. A measurement, not a text.
- **This repository at `d16de16`** — `copier.yml`, `pyproject.toml`,
  `code/src/scripts/audits/render-slop.sh`, `.claude/CLAUDE.md`, at the lines cited.

---

## Addendum - N-004 re-read, 15/10/2026

**Written**: 15/10/2026 | **Driver**: N-004 proved inexact, and it had never looked at
syntek-media's design hand-off surface or at family storage; both came to light in the
15/10/2026 design hand-off research | **Read at**: syntek-media `b841fd4` (HEAD is now
`95581d6`), syntek-author `b4669a5`, this repository `d16de16`

**Method.** The author of this addendum checked each claim again at its primary: both sibling
templates through `git show`, `git diff`, `git log --stat` and `git grep` at the commits named;
syntek-media PR #4 through `gh`; the untracked handoff files in each working tree, hashed and
timed as read (Sources above); and the Nix store by measurement. Research briefs written earlier
in this session served as leads and nothing more; where a primary disagrees with one, the
primary is what is recorded. No web page was needed. `context7` and Perplexity had no working
credentials this session and were **not consulted** (`code/docs/GATE-REPORTING.md`: could not
look, not looked-and-clean). No sibling repository, handoff or PR here grants a licence, so
**nothing is quoted**, and that is **measured** rather than asserted: on 15/10/2026 a word
five-gram comparison of this whole note's prose (lowercased, split on non-alphanumerics, with
backticked spans, URLs and citation brackets dropped; 5,331 distinct five-grams) against every
no-grant source this Addendum draws on found **0 shared runs** in each class: syntek-media at
`b841fd4` and `95581d6` with its uncommitted edits; its handoff folder; syntek-author at
`b4669a5` with its uncommitted edits; its handoff folder; and PR #4's description, commit
message and diff. Paths, environment variables,
question keys, commands, version strings and the layout pattern sit in backticks as
identifiers, not prose. The note never ships: `copier.yml:146` excludes `/research/**`, and
`:147-148` re-include just this folder's own `CONTEXT.md`/`CLAUDE.md` pair.

**Question.** Is N-004 still right about syntek-media at `b841fd4` and syntek-author at
`b4669a5`? And what has each sibling built, or settled on, for handing design work to an outside
tool and for keeping big files out of Git?

**Verdict.** N-004 overstates syntek-media three times. Its `media.py` self-test reports a pass
when ffmpeg is missing (.2), a fault syntek-media PR #4, still open, addresses. The temporary-file
rename and the Git-state check each reach only part of what the toolkit writes (.3). And only
http and https requests are blocked (.6). syntek-media also has a design hand-off surface that
N-004 never examined. For storage, syntek-media ships three mechanisms today; the shared external
data root is approved but unbuilt, written down only in untracked handoffs, and tied to
`syntek-*` answers files and to `make`, while syntek-base sits outside the shared set.

### The range, and why no cited line moved

1. syntek-media's HEAD is now `95581d6` (release `0.4.3`, 15/10/2026), two commits past
   `b841fd4`. Those commits touch six files: `VERSION`, `CHANGELOG.md`, `CONTEXT.md`,
   `README.md`, `DESIGN.md` and the syntek-author names list. Only `DESIGN.md` is cited here, and
   there a single header line (`:3`, the version) is swapped for another, so no cited line
   shifts; citations stay at `b841fd4`. (media `git log --stat b841fd4..95581d6`;
   `git diff b841fd4 95581d6 -- DESIGN.md`)
2. `f8dfbd2..b841fd4` holds seven commits. Three cited files change by one line each, edited
   where it stands: `template/toolkit/media_repo.py:756` (the Chromium folder list is now sorted)
   and `DESIGN.md:295` and `:995` (the development MCP server; CI cancelling superseded runs). The
   exception is `.github/workflows/audit-template.yml`, which gains a seven-line `concurrency`
   block at `:36-42`, so the lines cited from it below (`:103-112`, `:161`) stood seven lines
   earlier at `f8dfbd2` (`:96-105`, `:154`). They are cited at `b841fd4`. (media
   `git log --stat f8dfbd2..b841fd4`; `git diff f8dfbd2 b841fd4`)
3. The code behind the three corrections below is already present at `4d508a9`, the commit N-004
   read: those claims were inexact from the start, not overtaken later. (media
   `git show 4d508a9:template/toolkit/media.py` `:966`, `:982`; `card.py` `:199`, `:294`;
   `media_common.py` `:181`, `:232`, `:465`)

### N-004.2 corrected — the skip rule differs between the two scripts

1. `card.py --self-test` has three endings. Exit 0 means every case ran and none failed. Exit 1
   means at least one case failed, skips or not. Exit 2 means some part was unable to run: each
   such part gets its own SKIP line giving the reason, and the closing line calls the run
   incomplete. (media `template/toolkit/card.py:48-50`, `:483-485`, `:705-717`)
2. In `media.py`, the self-test's skip helper only prints; it keeps no count. When either ffmpeg
   or ffprobe cannot be found, the whole set of ffmpeg probes goes through that helper, and
   unless a case that did run has failed, the run closes as passed with exit 0. (media
   `template/toolkit/media.py:911-912`, `:965-966`, `:979-983`)
3. syntek-media's own contract is split on this. D20 lets `media.py` keep its exit when an
   optional tool is missing and lists those tools as Rhubarb, `systemd-run`, pandoc and an image
   encoder; ffmpeg is not among them. The `--self-test` row of the command table, though, counts
   ffmpeg among the tools whose missing probes leave the exit as it is. (media `DESIGN.md:55`,
   `:416`)
4. CI never meets the case. Its renders job installs ffmpeg and hands `--require-ffmpeg` to
   `toolkit-smoke.sh`, which then halts with an error, not a skip, if ffmpeg is absent. (media
   `.github/workflows/audit-template.yml:103-112`, `:161`; `.github/scripts/toolkit-smoke.sh:3374`)
5. Run without that flag on a host lacking ffmpeg, `toolkit-smoke.sh` takes `media.py`'s
   self-test as an ordinary result in its check 1, so the exit 0 above is recorded there as a
   pass. `card_skips()`, the helper that turns an exit 2 ending in an incomplete-run line into a
   named SKIP, is applied to `card.py` and `scene.py` alone. The checks that depend on ffmpeg (2,
   3, 5, 6, 7, 9, 10, 13, 15, 16, 17 and 18) are each recorded as a named SKIP instead. (media
   `.github/scripts/toolkit-smoke.sh:463-467`, `:498-516`, `:543-544`)
6. syntek-media PR #4, open on 15/10/2026, changes this. Should ffmpeg or ffprobe be missing,
   `media.py --self-test` would print a SKIP line carrying the install hint, finish with
   `self-test incomplete` and exit 2, as `card.py` does; an absent optional tool still produces
   only its lower-case skip notice, and the exit is untouched; a failed case still takes
   precedence over a skip (exit 1). The same PR runs `card_skips()` over `media.py` in check 1,
   so the smoke run would then show that exit as a SKIP, with the reason `media.py` printed.
   Unmerged when read: neither `b841fd4` nor `95581d6` contains any of it.
   (`gh pr view 4 -R Syntek-Dev/syntek-media`, state OPEN at 17:24; `gh pr diff 4`, the
   `template/toolkit/media.py` hunks at `:900`, `:961` and `:976`, and the
   `.github/scripts/toolkit-smoke.sh` hunks at `:457` and `:507`)

### N-004.3 corrected — two separate guards, and many writes made in place

1. The general output guard will not write over a file that already exists unless its path lies
   inside a `renders/` or `generated/` folder, and it rejects an output path that is also one of
   the inputs. It judges by the folder names in the path alone and never consults Git, so it
   behaves the same in or out of a work tree. (media `template/toolkit/media_common.py:172-174`,
   `:201-229`)
2. The Git-state check (the file must exist in HEAD with no staged or unstaged change) applies
   only when `-o` points at one of five tracked timing or scene files, the keys of
   `TIMING_OUTPUTS`: `words.json`, `words-check.md`, `mouth.json`, `cues.json` and `real.json`.
   The one other tracked file `-o` may replace, a show's podcast feed, is protected differently:
   before anything is written, its content is compared with what the episode register says it
   should hold. (media `media_common.py:177-198`, `:215-222`;
   `template/toolkit/media_feed.py:1023-1027`, `:1045-1046`; `DESIGN.md:101`, D66)
3. `replace_file` puts the bytes in a hidden temporary file next to the target and then renames
   that file over it. All five of the tracked outputs just named are written this way: the word
   timings and their check report, the mouth cues, the cue file and the real-asset index. It
   also writes the podcast feed, the episode register, the voice-levels working copy and a
   scene's stills report. A second temp-and-rename path exists in `feed tag`, where ffmpeg writes
   a temporary MP3 that is verified and only then renamed over the render. (media
   `media_common.py:177-178`, `:232-242`; `template/toolkit/media_audio.py:634`, `:740-741`,
   `:793`; `template/toolkit/media_captions.py:505`; `template/toolkit/media_repo.py:477`;
   `media_feed.py:281-288`, `:958-967`, `:1046`; `template/toolkit/scene.py:145`)
4. Everything else goes straight to its destination. Playwright saves card and thumbnail PNGs
   directly at the output path. ffmpeg's other outputs (cuts, encodes, images and loudness
   normalisation among them) are named as its final argument, and after a failed run the partial
   file is removed only if it sits in an output folder. The remaining tracked registers are
   rewritten in full where they lie: a row added to a Markdown table, the footage manifest, and
   the archive field of a voiceover register. (media `card.py:294`; `media_audio.py:228`,
   `:232-239`, `:276`; `template/toolkit/media_video.py:658`, `:761`, `:771`;
   `template/toolkit/media_image.py:225`; `media_common.py:465-474`; `media_repo.py:174`, `:205`)
5. The template's shipped settings deny the `Edit` tool, not `Write`, beneath `generated/` and
   `renders/`, and `check --setup` reports any project whose settings lack either of the two
   rules. (media `template/.claude/settings.json:24-28`; `media_repo.py:70`, `:807`)

### N-004.6 corrected — only http(s) is aborted

1. Every request from `card.py`'s browser passes a route handler: a URL beginning `http://` or
   `https://` is aborted and noted, and anything else is let through. A `file:` request that
   fails goes on a separate list and is reported as a finding. (media `card.py:196-209`,
   `:239-252`)
2. `scene.py` drives the same browser class, so scenes follow the same rule. (media
   `template/toolkit/scene.py:119`, `:184`)
3. For a card, the page loads first; a script then sets its CSS variables, after which the render
   waits for fonts and checks images. Variables go in ahead of the page's own scripts only when a
   caller supplies them up front, which the scene path does. (media `card.py:210-228`,
   `:286-292`; `scene.py:87`)
4. The finished PNG is read back to confirm its size and, under `--transparent`, its alpha
   channel. (media `card.py:300-304`)

### Approval in syntek-media's design tier

1. Setting up or changing the brand kit lies outside the piece ladder: the procedure's checklist
   says none of the ladder's gates applies, and the work ends when every required token has been
   settled by the author and both layouts approved in proof. (media
   `template/brand/workflows/01-set-up-the-brand-kit/CHECKLIST.md:13`, `:52`)
2. Approving a revised design export can cost later gates on the pieces that use the original.
   Any scene piece built on moved sprite or source art has `M4.stills` and every later gate date
   cleared, and its new stills go back for review; a piece already at `produced` or beyond keeps
   the original file, and only a reopening by the author changes that. (media
   `template/brand/workflows/03-record-a-design-export/STEPS.md:88-96`, `:119-126`)
3. N-004.7 stands; it simply does not cover this.

### syntek-media's design hand-off surface (not surveyed by N-004)

1. **Workflow `02-sync-with-claude-design`.** The author says which components travel and in
   which direction. Before anything travels, the kit must be committed and must pass the token
   check and the card check. The brand's preferred route is `/design-sync`; whether it works on
   a hand-written HTML kit is untested, so it carries a `VERIFY` flag, and only the author may
   launch it. The fallback pairs `/design export` with `/design import`, staged in a scratch
   folder that lies outside `brand/` and is never committed. Components then come across singly,
   every one cleared with the author and checked again; layout proofs go to a dated folder
   under `production/src/renders/proofs/`; and the first sync adds a row for the design project
   to the register. (media `template/brand/workflows/02-sync-with-claude-design/STEPS.md:22-37`,
   `:39-46`, `:48-64`, `:66-74`, `:76-94`, `:96-103`)
2. **Workflow `03-record-a-design-export`.** It collects the source design, its link and the date
   of export; opens rights rows; files by size, 10 MB and below into `brand/src/exports/` as
   storage `git` and anything larger into `brand/src/exports/large/` as storage `lfs`; before
   filing a large file, confirms that git-lfs is installed and an LFS filter is set up, halting
   if not; never writes over an existing file, giving a revision a `-vN` suffix instead; adds a
   single register row; and, once a revision is approved, marks the original superseded and moves
   only the references the author agrees to. (media `.../03-record-a-design-export/STEPS.md:20-30`,
   `:32-47`, `:49-58`, `:60-72`, `:78-103`)
3. **The register, `brand/src/design-register.md`.** Six columns: `Design`,
   `Claude Design link`, `Export path`, `Storage` (`git` or `lfs`), `Exported` and `Notes`.
   Links are kept in this file alone; rows are never removed; an export that has been replaced is
   marked superseded. It ships with no rows, and check 11 of `scrub.sh` fails the template build
   if a real Claude Design link turns up in shipped files. (media
   `template/brand/src/design-register.md:10-12`, `:16-23`, `:28`;
   `.github/scripts/scrub.sh:43-45`, `:133`)
4. **The LFS export folder and its tripwire.** A `.gitattributes` inside
   `brand/src/exports/large/` sends every file there through LFS apart from that attributes file
   and the folder's `CONTEXT.md`/`CLAUDE.md`; the template writes no root `.gitattributes` and
   forbids `git lfs track`. At copy time, when no level of Git configuration has an LFS filter, a
   task sets `filter.lfs.required` in the new project's local config, so staging a large file
   there errors out rather than slipping into a commit as an ordinary blob; the after-copy message
   explains this. (media `template/brand/src/exports/large/.gitattributes:1-4`, `CONTEXT.md:3-7`,
   `CLAUDE.md:32`; `copier.yml:996-1000`, `:1032-1049`)
5. The code's threshold is 10 MiB (`10 * 1024 * 1024`), while the procedure and the finding
   message both speak of MB. (media `media_repo.py:63`, `:527-528`;
   `.../03-record-a-design-export/STEPS.md:46-47`)

### syntek-media toolkit patterns, as facts

Each row says what exists and what it does. None of it is copied, and anything syntek-base takes
from it would be written afresh.

| Pattern                    | Where in syntek-media (`b841fd4`)                                           | What it does                                                                                                                                                                                                                                                                                                                                                                      |
| -------------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Verb CLI                   | `template/toolkit/media.py:257-261`, `:685-707`; `DESIGN.md:55` (D20)       | A single standard-library argparse CLI with sub-commands; `--self-test` is handled before the parser runs; the `media_*.py` helper modules offer no command line themselves                                                                                                                                                                                                       |
| Exit taxonomy              | `media.py:699-707`; `media_common.py:146-151`                               | Exit 1 comes from a raised finding; exit 2 from a fatal error, an OS error or a decoding error                                                                                                                                                                                                                                                                                    |
| Skip exits 2               | `card.py:48-50`, `:705-717`                                                 | A failure takes precedence over a skip; skips on their own give exit 2; exit 0 needs a complete, clean run                                                                                                                                                                                                                                                                        |
| Fixture-mutation self-test | `.github/scripts/_common.sh:71-128`; `.github/scripts/CLAUDE.md:56-68`      | An unclean baseline gives exit 2; each mutation has to yield precisely one finding, worded as expected; a missing tool is SKIP and a need that does not arise is n/a (development only)                                                                                                                                                                                           |
| Readiness rows             | `media_repo.py:696-841`, item rule `:700-705`                               | `check --setup` prints one line per item (ok, FAIL or a note); only a FAIL counts as a finding, and each names its remedy; Chromium must match the pinned revision                                                                                                                                                                                                                |
| Browser discovery          | `media_repo.py:565-592`; `media.py:1448-1466`                               | Looks first at `PLAYWRIGHT_BROWSERS_PATH`, then the OS cache at that revision, then an offline `uv` probe outside any project for a path a wrapper sets; its self-test uses a fake `uv`                                                                                                                                                                                           |
| Browser pin                | `media_repo.py:66-67`; `card.py:2-5`                                        | The PEP 723 header pins Playwright `1.63.0`, whose Chromium is revision `1243`                                                                                                                                                                                                                                                                                                    |
| Render checks              | `card.py:196-209`, `:286-304`                                               | As N-004.6 above                                                                                                                                                                                                                                                                                                                                                                  |
| Geometry checks            | `scene.py:36-62`                                                            | Reports a box off the pixel grid or past the safe-zone edge, text spilling out of its box, and overlapping text boxes                                                                                                                                                                                                                                                             |
| Token check                | `media_repo.py:247-269`; `media_common.py:681-740`                          | Each required name must exist; `var()` chains are followed up to depth 8; each value's type is checked; every `@font-face` must be local and present. At `b841fd4` the colour pattern lets any bare word through; PR #4, still open, would admit only CSS named colours, `transparent` and `currentColor`, through a new `is_colour` filter, leaving `COLOUR_RE` itself unchanged |
| Output guards              | `media_common.py:172-242`                                                   | As N-004.3 above                                                                                                                                                                                                                                                                                                                                                                  |
| Dated reference data       | `template/toolkit/data/platforms.toml:1-40`; `media.py:184-232`             | Every table records its checked-on date, its source, keys not yet confirmed and house choices; a brand's overrides live in their own file; `presets --stale-after` lists tables past their date                                                                                                                                                                                   |
| Open-flag count            | `media_repo.py:323-357`                                                     | Counts `AUTHOR TO CONFIRM` and `VERIFY` markers across files that are tracked, or would be if added; under `--strict` they become findings                                                                                                                                                                                                                                        |
| Check before hand-off      | `.../02-sync-with-claude-design/STEPS.md:30-37`                             | Nothing transfers until the kit has been committed and passes its checks                                                                                                                                                                                                                                                                                                          |
| Scratch return             | `.../02-sync-with-claude-design/STEPS.md:66-74`                             | What comes back lands in a scratch folder away from the kit, outside Git, and is applied by hand                                                                                                                                                                                                                                                                                  |
| Export register            | `design-register.md:14-29`; `.../03-record-a-design-export/STEPS.md:78-103` | A row for each file, kept for good; `-vN` revisions; superseded rows marked; links held only there                                                                                                                                                                                                                                                                                |
| Governance                 | `DESIGN.md:55` (D20); `template/toolkit/CLAUDE.md:58-91`                    | Nothing new (dependency, script or framework) arrives without a recorded decision; one self-test covers the helper modules                                                                                                                                                                                                                                                        |

### N-001.10 — wording drift, re-measured

1. N-001.10's last clause, that revision 1228 survives through older generations, no longer holds:
   at 16:38 on 15/10/2026 no directory named `chromium*-1228` exists at depth two of `/nix/store`,
   and no store path whose name contains `1228` names Chromium or Playwright.
   (`find /nix/store -maxdepth 2 -name 'chromium*-1228'`; `ls -d /nix/store/*1228*`)
2. The current system generation's closure holds one Playwright bundle, at revision 1243, and
   that bundle's only roots are system generations. (`nix-store -qR /run/current-system`;
   `nix-store -q --roots`)
3. Two more bundles sit in the store with no roots: one at revision 1234, and a combined one
   holding 1234 and 1243. (`ls` of each; `nix-store -q --roots` returns nothing for either)
4. The repository's pin has not moved: Playwright 1.61.0. (`pyproject.toml:106`;
   `code/src/scripts/audits/render-slop.sh:114`)

### Family storage, decided but unbuilt

**Shipped in syntek-media today: three mechanisms.**

1. **Nested ignores.** Template-owned `.gitignore` files inside the output folders keep renders and
   generated audio untracked, leaving each folder's README tracked; they ship with every profile.
   (media `DESIGN.md:54`, D19; `template/production/src/.gitignore:16-17`, `:24-25`, `:35-36`,
   `:45-48`)
2. **The footage manifest and a Git-ignored mirror.** By recorded decision, source footage is
   kept outside the repository. The committed `manifest.toml` holds one entry per file: a
   permanent ID, the path, its kind, sha256, size in bytes, duration, a free-text label naming the
   master copy's location, a recorded date, rights and notes. `footage add` copies (it never moves)
   and hashes; the local mirror is a fixed, ignored folder inside the repository,
   `production/src/footage/raw/`. A location containing `://` draws a note, not a refusal. (media
   `template/production/src/footage/manifest.toml:1-21`; `media_common.py:93-95`;
   `media_repo.py:122-125`; `template/production/src/.gitignore:22-25`)
3. **LFS only for `brand/src/exports/large/`**, behind the copy-time tripwire described above;
   `media.py check` also reports three cases: an LFS-tagged file that Git holds as an ordinary
   blob; an LFS-tagged file when no filter is set up; and any file above the size threshold sitting
   outside both the ignored folders and the LFS folder. (media `media_repo.py:502-530`)
4. No question in `copier.yml` deals with storage or LFS, and no file committed at `b841fd4`
   mentions a data root, `SYNTEK_DATA_ROOT`, `DATA_STORE` or `external.toml`. (media
   `copier.yml:491-771`; `git grep b841fd4`, no hits)

**Decided, recorded only in untracked handoffs.**

1. **Status.** Author D50, an external data root, is approved but unbuilt, and comes after D51 and
   D52. The handoff's opening paragraph calls its folder development state, not committed. The
   proposal, dated 14/10/2026, describes itself as unimplemented. syntek-author's HEAD contains no
   data-root text. (author `HANDOFF.md`, opening paragraph, and Section 3
   (`Decisions the maintainer made`), the D50 row; `D50-data-root-proposal.md`, header status
   line (`:3`); `git grep b4669a5`, no hits)
2. **The root.** For now only the environment supplies `SYNTEK_DATA_ROOT`, but the resolver is to
   be built so that sources read from files can join later. That narrows the proposal, whose
   original order went on to a file kept inside `.git/` for each clone and then a per-user config
   file. In the proposal, a source that is present but invalid ends the lookup with exit 2
   instead of passing on to the next, and no fallback directory exists, by design. The root's
   path is kept out of Copier's answers and out of every tracked file. (author `HANDOFF.md`,
   Section 3, the paragraph on the D50 decisions; `D50-data-root-proposal.md`, Summary, the
   per-machine bullet (`:20`); Section 2.1, the options table (`:111-116`); Section 2.2
   (`:121-127`))
3. **The marker.** A `.syntek-data-root` file (TOML, format 1) has to sit in the root, which lets
   an unmounted volume be detected. (author `HANDOFF.md`, Section 3, the D50 paragraph;
   `D50-data-root-proposal.md`, Section 2.2, the validity checks (`:140-142`))
4. **The layout.** `<root>/<DATA_AREA>/<kind>/<DATA_SLUG>/<repo-relative path>`, the kind folder
   named by one of the `DATA_KIND_*` answers. A file's place under the root repeats its place in
   the repository; readers try the work tree before the root; and prose refers to an external
   file as `ext:` plus its repository path. (author `HANDOFF.md`, Section 3, the D50 paragraph;
   `D50-data-root-proposal.md`, Summary, the layout bullet (`:22`); Section 3.1 (`:197-203`))
5. **The questions.** `DATA_STORE` takes `external` or `repo`, defaulting to `external` for a
   fresh copy and to `repo` the first time an update asks it; `DATA_AREA` defaults to `business`,
   keeps its case and is validated as safe on Windows; `DATA_SLUG` defaults to the folder name;
   and four `DATA_KIND_*` answers name the kind folders. All of them sit in the D48 shared
   question block, and each template may look up its sibling's answers, for the `DATA_*` keys
   alone. (author `HANDOFF.md`, Section 3, the D50 paragraph; `D50-data-root-proposal.md`,
   Summary, the portable-settings bullet (`:19`); Section 2.3, the questions table
   (`:166-174`); media handoff, Section 4 (`Media 0.5.0`), `The data root` bullet)
6. **The manifest.** One `external.toml` for each layer that stores binaries, in a single format
   shared by both templates and derived from syntek-media's footage manifest. Rows are keyed by
   path and hold kind, role, sha256, bytes, filing date, state (no row is ever deleted), source,
   replaces, a label that may not be a URL, a former name and notes. The hash is computed at
   filing via a temporary copy, fsync, rename and a second hash; it is never rewritten, and
   verification compares hashes only. (author `HANDOFF.md`, Section 3, the D50 paragraph;
   `D50-data-root-proposal.md`, Section 3.2 (`:217-250`))
7. **Without a root.** Text-only work (lint, flags, proofs) carries on; issuing, filing and
   verifying stop with exit 2 and never write into the repository as a fallback. The resolver's
   codes are 0 for clean, 1 for a failed check and 2 for a missing or invalid root. (author
   `D50-data-root-proposal.md`, Summary, the bullet on an absent root (`:23`); Section 4.3,
   step 8 (`:354`); Section 6, Template, the resolver bullet (`:457`))
8. **Agents and sync.** New projects receive a guard hook that refuses `Edit` and `Write` beneath
   the root. Cloud sync becomes the user's choice of provider in place of `INCLUDE_DRIVE_SYNC`;
   that part is not yet designed. (author `HANDOFF.md`, Section 3, the D50 paragraph;
   `D50-data-root-proposal.md`, Section 6, Template, the guard-hook bullet (`:458`))
9. **LFS.** The proposal rules out Git LFS and lists syntek-media's `exports/large/` as
   conflicting with that, leaving any change there to syntek-media. syntek-media's handoff, for
   its part, says only that large brand exports will go where the user's answers send them.
   (author `D50-data-root-proposal.md`, Summary, the first bullet (`:17`); Section 5, the media
   LFS row (`:404`); media handoff, Section 4 (`Media 0.5.0`), `The data root` bullet, its
   sub-bullet on large brand exports)
10. **Target.** The proposal plans the data root for syntek-author `0.5.0`, released alongside a
    matching syntek-media release, because both templates' copies of the shared block change.
    The author handoff's latest plan puts D51 and D52 in `v0.4.0`, and in `v0.5.0` the data root
    together with a cloud-provider choice, `code-review-graph` and Scrapling. syntek-media's
    handoff files the same decisions under its own `0.5.0`, which copies from author `v0.5.0` and
    waits until syntek-author's files are merged. Today syntek-author is at `0.3.0` (tags
    `v0.1.0` to `v0.3.0`) and syntek-media at `0.4.3`. (author `D50-data-root-proposal.md`,
    Summary, the release bullet (`:26`); Section 9 (`:566-568`); author `HANDOFF.md`, Section 6
    (`Decisions after this handoff`), the release-plan bullet; `git show b4669a5:VERSION`;
    `git tag`; media handoff, Section 2 (`Next actions, in order`), the versions list, and the
    Section 4 heading; `git show 95581d6:VERSION`)

**Left out on purpose.** The last bullet of Section 7 (`Outside this repository`) of
syntek-media's handoff concerns syntek-base's own future handling of the data-root design. It is
not recorded here as a finding: it reports a decision made on 15/10/2026, and decisions live on
the maps (storage belongs to `MAP-NATIVE-DESIGN-TIER` N-011), never in a research note.

**Where syntek-base stands.**

1. syntek-base sits outside the set of files the family shares, which D48 defines: syntek-author
   owns it, and syntek-media agreed to it in principle. Both templates mention syntek-base only as
   the source of their house Copier idiom, and check 3 of each template's `scrub.sh` fails a
   build that finds the string `syntek-base` in shipped paths. (author `DESIGN.md:8`, `:20`, `:67`;
   `.github/scripts/scrub.sh:108`; media `DESIGN.md:8`, `:22`; `.github/scripts/scrub.sh:126`)
2. The untracked syntek-author handoff names syntek-base once, in its file list, describing a
   design file that weighs which of syntek-base's skills and hooks suit the shared set, with port
   details for `to-questionnaire` and `wayfinder` and what a context-usage threshold hook needs;
   its Section 3 records those three as approved and folded into the D51 branch. (author
   `HANDOFF.md`, Section 5 (`Files in this folder`), the `design/base-skills-hooks-assessment.md`
   bullet; Section 3, the D51 row and the paragraph after the table)
3. The proposed resolver takes `DATA_*` answers only from files named like
   `.copier-answers.syntek-*.yml`. Both siblings name their answers files that way, whereas
   syntek-base sets no `_answers_file` and so writes the default `.copier-answers.yml`. (author
   `D50-data-root-proposal.md`, Section 6, Template, the resolver bullet (`:456`); author
   `copier.yml:36`; media `copier.yml:45`; this repository's `copier.yml`, which has no
   `_answers_file` key)
4. Under the proposal, agents find the root through `make root`, and filing goes through new
   `files-*` Make targets; syntek-base tracks no Makefile and sends every development operation
   through `code/src/scripts/**/*.sh`. The peer validators are wired pairwise, author with media.
   (author `D50-data-root-proposal.md`, Section 2.3, the `peer` keys (`:149-150`); Section 6,
   Template, the bridge and `Makefile` bullets (`:459-463`); `git ls-files`;
   `.claude/CLAUDE.md:270`)

**The D50 number collision.** syntek-media's D50 is an unrelated rule (tooling never reads files
Git ignores, adopted from author D42), whereas author D50 is the data root. The proposal points
out the clash and asks every citation to say which template's D50 it means. (media
`DESIGN.md:85`; author `D50-data-root-proposal.md`, Section 5, the row on the two D50s (`:403`))

---

## Feeds

`MAP-NATIVE-DESIGN-TIER` grilling nodes **N-007 to N-019** (09/10/2026), and through them the
`ADR-US###-*` records their slice stories author. No ADR or `STORY-PLAN-US###` exists yet; each
links back here by path when it does.

`MAP-INSTRUCTION-DELIVERY` **N-001** (09/10/2026) — the agent-host facts under N-006 are an input
to that map's open research node, which owns agent discovery; its next RESOLVE cites this note.

`MAP-DESIGN-HANDOFF` — a **new** map, charted 15/10/2026 and landing together with this
Addendum. It is a different map from the older `MAP-CLAUDE-DESIGN-HANDOFF` (charted 22/08/2026),
which `MAP-NATIVE-DESIGN-TIER` N-007 is set to retire. It takes the Addendum's facts on
syntek-media's design hand-off surface and its toolkit patterns.

`MAP-NATIVE-DESIGN-TIER` **N-011** (storage) — the Addendum's family-storage facts, both shipped
and decided.
