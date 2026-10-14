# ArtCraft design apps — NixOS install, and fit with the design tier

**Written**: 14/10/2026 · **Driver**: Sam's question (14/10/2026) — can FigCraft, PhotoCraft,
VectorCraft, LightCraft and EffectCraft be installed on NixOS and used for the database, user-flow,
brand-guide, component and wireframe work? · **Feeds**: no decision yet — Section 9 names the
candidates

## Question

Can the ArtCraft "Crafting Apps" (FigCraft, PhotoCraft, VectorCraft, LightCraft and EffectCraft) be
installed on this NixOS host, and can they be the tools for `project-management/src/04-DATABASE`,
`05-USER-FLOW`, `06-BRAND-GUIDE`, `07-COMPONENTS` and `08-WIREFRAMES`?

## Verdict

**Install: yes. Four of the five are installed on this machine already.** The `nix-config`
`pkgs/craft-apps` family installs PhotoCraft, VectorCraft, LightCraft and EffectCraft, with six
sister apps, as pinned AppImages. FigCraft is the only one missing. It fits the same route through a
one-line addition to the updater, with three catches: it cannot see system fonts, the wrapper puts no
CLI on `PATH`, and the prebuilt binary has a public share server compiled in.

**As the artefact of record: no.** This design tier is text that Claude writes and git diffs —
Mermaid, Markdown, self-contained HTML, and Python-to-LaTeX generators. The repository removed Figma
on 22/08/2026 to keep it that way. The apps are between five and fourteen days old and self-described
alpha. Their Linux packages are unsigned, and their native formats are either binary or still
changing version every few days. None of them can draw an ERD or a flow diagram whose arrows survive
export.

**Where they help:**

- **VectorCraft** — logo SVG for `00-ASSETS/LOGOS/`.
- **PhotoCraft and LightCraft** — brand imagery.
- **EffectCraft** — brand motion outside the UI.
- **FigCraft** — throwaway exploration.

Commit the exports, never the native files.

**Method.** Every claim was read statically: from source at a pinned commit, from the
checksum-verified Linux release binaries (`readelf`, `objdump`, `strings`), from the live host's
configuration and from this repository. **Nothing was executed.** Runtime behaviour on this host is
therefore unverified (Section 8). An adversarial pass re-checked the load-bearing claims, and its
corrections are applied throughout (Section 6).

Citations use the short forms in [Sources](#sources): `figcraft@833f0d2` is the v0.6.0 tag, and so
on.

---

## 1. The suite

| Claim                                                                                                                                                                                                                        | Primary source                                                                                                                                                              |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The apps are Rust repositories under the GitHub organisation `storytold` (display name ArtCraft; official site getartcraft.com), created between 30/09/2026 and 09/10/2026. FigCraft is the youngest                         | `gh api repos/storytold/<app>` (`created_at`) · `gh api orgs/storytold`                                                                                                     |
| Latest releases on 14/10/2026: FigCraft v0.6.0, PhotoCraft v0.8.2, VectorCraft v0.11.0, LightCraft v0.7.1, EffectCraft v0.9.2, craft-launcher v0.4.1. LightCraft v0.8.0 was tagged after the research and is **not** covered | `gh api repos/storytold/<app>/releases` and `/tags`                                                                                                                         |
| FigCraft shipped six releases in five days, v0.2.0 on 10/10 to v0.6.0 on 14/10                                                                                                                                               | `gh api repos/storytold/figcraft/releases`                                                                                                                                  |
| All five call themselves alpha. FigCraft rates itself at about half of Figma for real work (49% in the README, 53% in the roadmap) and says it has not been checked against real Figma files                                 | `figcraft@833f0d2` README.md:22, :265 · ROADMAP.md:46                                                                                                                       |
| Self-rated readiness of the others for real work: PhotoCraft about 45%, VectorCraft about 65%, LightCraft about 61%, EffectCraft about 45%                                                                                   | `photocraft@c699e3c` ROADMAP.md headline table · `vectorcraft@0a33cff` README.md:209 · `lightcraft@3b4279f` ROADMAP.md headline table · `effectcraft@05955c0` README.md:237 |
| Linux has had no hand QA. FigCraft's and VectorCraft's own gap lists say so, and their alpha gates were verified on macOS. FigCraft's CI runs headless `cargo test` on Linux only                                            | `figcraft@833f0d2` docs/gaps.md:24, :204-215 · .github/workflows/ci.yml:33, :63 · `vectorcraft@0a33cff` docs/gaps.md:118-120                                                |
| Each Cargo.toml says MIT OR Apache-2.0, while GitHub's licence detector shows Apache-2.0 only. The ArtCraft name and logos are trademarks outside the open-source grant                                                      | `figcraft@833f0d2` Cargo.toml:11 · docs/brand/LICENSE-brand.txt                                                                                                             |
| Each release ships x86_64 and aarch64 Linux builds (tarball, AppImage, deb, rpm, flatpak) and a static web build. The separate `-cli-` zip is macOS-only, because the macOS bundle holds only the GUI                        | release asset lists · `photocraft@c699e3c` book/src/automation/mcp.md                                                                                                       |
| The static web builds cannot replace a native install for this work. FigCraft's web build has no working save, and none of the web builds has a CLI or MCP                                                                   | `figcraft@833f0d2` packaging/web/README.md:16-19 · figcraft#195                                                                                                             |

---

## 2. Installing on NixOS

### The host and what is already there

| Claim                                                                                                                                                                                                                  | Primary source                                                                                                                              |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| The live host is `devtower-intel`: NixOS 26.11 on nixos-unstable (nixpkgs `e7439b6`), Hyprland on Wayland, NVIDIA RTX 2080 Ti on driver 595.104.02 with the open kernel module                                         | `nixos-version` · `$XDG_SESSION_TYPE $XDG_CURRENT_DESKTOP` · `lspci` · `nix-config@3897629` modules/hardware/intel-nvidia-desktop.nix:10-37 |
| Ten Craft apps are installed system-wide: photocraft, vectorcraft, lightcraft, effectcraft, pdfcraft, designcraft, filmcraft, soundcraft, wordcraft and deckcraft. FigCraft is not, and the config never mentions it   | `ls /run/current-system/sw/bin` · `nix-config@3897629` scripts/update-craft-apps.py:31-42                                                   |
| The route: each AppImage is fetched with a pinned SRI hash, extracted, wrapped with `appimageTools.wrapType2` with the wgpu and winit runtime libraries in `extraPkgs`, and has AppImage self-integration switched off | `nix-config@3897629` pkgs/craft-apps/default.nix:41-130, :61-78, :83-86 · modules/software/craft-apps.nix:17-22                             |
| Versions live in `pkgs/craft-apps/sources.json` and change only through `just update-craft`. The updater takes the hash from the GitHub release digest and requires it to match that release's `SHA256SUMS.txt`        | `nix-config@3897629` justfile:392-400 · scripts/update-craft-apps.py:76-103                                                                 |
| FigCraft was missed, not excluded. Its first releases predate the packaging commit, and its v0.6.0 AppImage name matches the updater's asset pattern                                                                   | `nix-config` commit `5cc9494` (12/10/2026) · scripts/update-craft-apps.py:72-73 · v0.6.0 asset list                                         |
| The installed copies are behind: photocraft 0.7.0, vectorcraft 0.10.0, lightcraft 0.6.0 and effectcraft 0.8.0, against the releases in Section 1                                                                       | `nix-config@3897629` pkgs/craft-apps/sources.json · `readlink -f` on the installed binaries                                                 |
| The wrapper is not a sandbox. Its bubblewrap call binds `/home`, `/run` and `/tmp` read-write with no `--unshare-*`, so the apps run with the user's full rights and network access                                    | the generated wrapper script in the Nix store (`photocraft-0.7.0-bwrap/bin/photocraft`, lines 2 and 70-79)                                  |

### What the binaries need

| Claim                                                                                                                                                                                                                | Primary source                                                                                                     |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| Every Linux binary links only glibc (2.35 or newer), libm and libgcc_s. None has an RPATH, and no shared libraries are bundled                                                                                       | `readelf -d` and `objdump -T` on each latest linux-x86_64 tarball, checksums verified against its `SHA256SUMS.txt` |
| The GUIs load Vulkan, EGL, Wayland, X11/xcb, xkbcommon and libdbus at runtime with `dlopen`, which is why the wrapper must supply them. EffectCraft's GUI also links libasound                                       | `strings` on the GUI binaries · `figcraft@833f0d2` packaging/linux/nfpm.yaml:26-33                                 |
| The PhotoCraft and VectorCraft CLIs need nothing beyond glibc. The LightCraft and EffectCraft CLIs reference EGL/Wayland (and LightCraft's Vulkan) only for an optional GPU path, and render on the CPU without them | `strings` on the CLI binaries · `effectcraft@05955c0` apps/effectcraft-cli/src/main.rs:31-32                       |

### Three catches for FigCraft

| Claim                                                                                                                                                                                                                                                                           | Primary source                                                                                                                                                               |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Fonts.** FigCraft scans only `/usr/share/fonts`, `/usr/local/share/fonts`, `~/.fonts` and `~/.local/share/fonts`, with no fontconfig. None of these exists on this host or inside the wrapper's root filesystem, so it would see only its embedded fonts — no brand typefaces | `figcraft@833f0d2` crates/text/src/fontdb.rs:650-678 · `ls` on the host · the wrapper's FHS root filesystem                                                                  |
| VectorCraft and EffectCraft read `/etc/fonts` themselves, and PhotoCraft calls `fc-list`, so they should find system fonts. This is reasoned from code, not observed                                                                                                            | `vectorcraft@0a33cff` crates/text/src/fontconfig.rs:164-233 · `effectcraft@05955c0` crates/text/src/font_dirs.rs:1-8 · `photocraft@c699e3c` crates/text/src/fonts.rs:716-795 |
| **CLIs are not on `PATH`.** Every Linux tarball contains a headless `<app>-cli`, but `wrapType2` exposes only the GUI. FigCraft's AppRun forwards `cli <args>` to its CLI. The other four AppRuns start the GUI only                                                            | tarball listings · `figcraft@833f0d2` packaging/linux/AppRun:76-83 · `vectorcraft@v0.11.0` packaging/linux/package.sh:109 · `photocraft@v0.8.2` packaging/linux/AppRun:94    |
| **Public share server.** Both prebuilt FigCraft binaries have `wss://collab.craftapps.dev/` compiled in as the default share target. Only a source build with `FIGCRAFT_DEFAULT_SERVER` set empty removes it                                                                    | `figcraft@833f0d2` crates/engine/src/live.rs:64-71 · `strings` on `bin/figcraft` and `bin/figcraft-cli`                                                                      |
| The project runs that server. It keeps shared files unencrypted until nobody has opened them for 30 days, and it logs IP addresses                                                                                                                                              | `figcraft@833f0d2` docs/online-sharing-terms.md:30-44                                                                                                                        |

### Other routes, and known issues on this host

| Claim                                                                                                                                                                                                                                                                                          | Primary source                                                                                                                                                   |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The other routes are worse here:<br>- **Flatpak** is not enabled on the host.<br>- **nix-ld**'s library list lacks Vulkan, Wayland and xkbcommon, and the config records a decision against widening it.<br>- **A source build** means a long wgpu compile on every release, roughly one a day | `flatpak --version` (absent) · `nix-config@3897629` modules/core/nix-settings.nix:94 · pkgs/uv-manylinux.nix:20-56 · `figcraft@833f0d2` flatpak manifest comment |
| None of the apps is in nixpkgs. Init PRs for PhotoCraft, VectorCraft, LightCraft and EffectCraft are open and several versions behind, and none exists for FigCraft. Only LightCraft ships a flake, and its own docs say CI does not build it                                                  | `nix eval nixpkgs#<app>` · NixOS/nixpkgs#571418, #571423, #571429, #571432 · `lightcraft@3b4279f` AGENTS.md:134-135                                              |
| Wayland file drag-and-drop does nothing in PhotoCraft, VectorCraft, LightCraft or EffectCraft, a limitation of winit 0.30                                                                                                                                                                      | photocraft#386 · `vectorcraft@0a33cff` README.md:175 · lightcraft#639 · effectcraft#268                                                                          |
| On Hyprland with NVIDIA — this host's combination — EffectCraft's GPU compositor falls back to the CPU after a resize, and PhotoCraft's image paste does nothing                                                                                                                               | effectcraft#1116 · photocraft#5031                                                                                                                               |

---

## 3. File formats and automation

### Native formats

| Claim                                                                                                                                                                                  | Primary source                                                                                                                                                                                |
| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A `.figcraft` file is a zip whose `document.json` is compact JSON on a single line, so git sees an opaque blob. Node order is deterministic (an ordered map)                           | `figcraft@833f0d2` crates/format/src/lib.rs:1-17, :37-39, :251, :346-347 · crates/doc/src/lib.rs:160 · `unzip -p examples/ridgeline-design-system.figcraft document.json` contains no newline |
| `figcraft-cli convert x.figcraft x.json` writes pretty JSON, and the app opens `.json`, so Claude can read and write a document as text. Saving from the app always writes `.figcraft` | `figcraft@833f0d2` apps/figcraft-cli/src/files.rs:101-103, :269-279 · docs/mcp.md:230                                                                                                         |
| FigCraft's format number has been 1 in every release                                                                                                                                   | `crates/format/src/lib.rs` at each tag from v0.2.0 to v0.6.0                                                                                                                                  |
| The other formats are churning. Across releases in two weeks, VectorCraft's format went 2, 3, 4 and the LightCraft catalogue went 1, 3, 7. Older builds refuse newer files             | `vectorcraft` crates/format/src/lib.rs at each tag · `lightcraft` crates/catalog/src/journal.rs at each tag                                                                                   |
| VectorCraft saves a small vector-only document as pretty JSON. Embedded data of 8 KiB or more appends a binary blob section, and large files are written compact                       | `vectorcraft@0a33cff` crates/format/src/lib.rs:52-56, :246-285                                                                                                                                |
| EffectCraft's `.ecproj` is pretty JSON (schema 2) with absolute footage paths. PhotoCraft's `.pcraft` is a zip of a JSON manifest plus compressed pixel tiles — binary in practice     | `effectcraft@v0.9.2` crates/project/src/lib.rs:34, :1443-1450 · `effectcraft@05955c0` docs/gaps.md:77 · `photocraft@c699e3c` book/src/formats/pcraft.md:3-13                                  |

### Exports and design tokens

| Claim                                                                                                                                                                                                                         | Primary source                                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| FigCraft exports PNG, JPG, WebP, SVG and PDF (with bleed, crop marks and naive CMYK), plus experimental `.fig`. Its `render` command writes rasters only                                                                      | `figcraft@833f0d2` docs/cli.md:44-85 · apps/figcraft-cli/src/files.rs:285-287                                                     |
| FigCraft variables export as Figma-REST JSON or CSS custom properties, and import only the Figma-REST shape. None of the five apps reads or writes W3C design-token (DTCG) JSON or Style Dictionary                           | `figcraft@833f0d2` crates/engine/src/cmd/variables_io.rs:16-95 · a repo-wide grep in each app                                     |
| FigCraft's generated CSS writes a bound variable as `var(--name, <literal value>)`                                                                                                                                            | `figcraft@833f0d2` crates/engine/src/codegen.rs:253-256, :312                                                                     |
| VectorCraft writes clean SVG 1.1 (presentation attributes, readable ids, editing data off by default). But fills are always literal hex, never `currentColor`, and rectangles and circles come back as `<path>`               | `vectorcraft@0a33cff` crates/svg/src/lib.rs:186-246 · crates/svg/src/export.rs:110, :454, :725-745 · vectorcraft#1292             |
| PhotoCraft has no SVG export, and LightCraft has no SVG support at all                                                                                                                                                        | `photocraft@c699e3c` book/src/formats/svg.md:3 · `lightcraft@3b4279f` crates/codecs/src (no SVG code)                             |
| EffectCraft exports Lottie (`.json` or `.lottie`) and WebM VP9 with alpha, but no SVG of any kind. Its Lottie writer was built from the spec and is untested against real players, and one export renders blank in lottie-web | `effectcraft@v0.9.2` crates/export/src/lib.rs:3-15 · crates/lottie/src/export.rs:490 · crates/svg/src/lib.rs:1 · effectcraft#1361 |

### Agent automation

| Claim                                                                                                                                                                                                                             | Primary source                                                                                                                                                                                                    |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Every app has a headless CLI and a stdio MCP server. VectorCraft, PhotoCraft and EffectCraft can confine an agent's file reads and writes to named directories. **FigCraft cannot**: its `mcp` subcommand accepts only `--attach` | `figcraft@833f0d2` apps/figcraft-cli/src/main.rs:135-140 · `vectorcraft@0a33cff` docs/mcp.md:52-80 · `photocraft@v0.8.2` book/src/automation/mcp.md:11 · `effectcraft@v0.9.2` crates/automation/src/confine.rs:76 |
| A FigCraft MCP agent can publish the open document to the public share server with one parameterless command and no confirmation, because headless MCP installs a live network link                                               | `figcraft@833f0d2` crates/mcp/src/headless.rs:49-53 · crates/engine/src/live.rs:1646-1689                                                                                                                         |
| FigCraft's GUI control port listens on loopback with no authentication, so any local process can drive the app while it is open                                                                                                   | `figcraft@833f0d2` apps/figcraft/src/control_server.rs:16, :30                                                                                                                                                    |

---

## 4. Fit per design folder

| Folder           | Verdict              | Why                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ---------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `04-DATABASE`    | **No**               | ERD PNGs are generated only and must trace to a Mermaid source (`project-management/src/04-DATABASE/ERD-DIAGRAMS/CLAUDE.md:23-24`). FigCraft has no connector node: an "arrow" is a loose line that does not follow its entities. FigJam is out of scope, and there is no diagram template (`figcraft@833f0d2` crates/doc/src/node.rs:68-125 · crates/engine/src/cmd/create.rs:140 · docs/target-app-parity.md:87-88 · crates/engine/src/templates/mod.rs:73-129). The other four have no diagramming at all |
| `05-USER-FLOW`   | **No**               | Flow PNGs are only ever re-exported from Mermaid (`project-management/src/05-USER-FLOW/DIAGRAMS/CLAUDE.md:25-28`). FigCraft's prototype connections are drawn by the editor only and are absent from PNG, SVG and PDF exports (`figcraft@833f0d2` crates/ui-egui/src/proto_canvas.rs:1-3; no prototype code in crates/svg or crates/pdf)                                                                                                                                                                     |
| `06-BRAND-GUIDE` | **Assets only**      | The brand values live in `guide-build/brand_guide.py` (`:42-45`), and the token layer is database-canonical (`code/docs/DESIGN-TOKENS.md:51-66`). VectorCraft fits the logo slot, where SVG is the source of truth (`project-management/src/00-ASSETS/LOGOS/CONTEXT.md:12-17`). PhotoCraft and LightCraft fit imagery. EffectCraft fits a logo sting only: the PDF guide cannot hold motion, and UI motion is CSS only (`code/docs/visual-design/WEB.md:122-126`)                                            |
| `07-COMPONENTS`  | **Exploration only** | FigCraft's components, variants and auto layout are real, but the record is Markdown plus `component-build/components.py` (`project-management/src/07-COMPONENTS/component-build/CONTEXT.md:25-45`). No token interchange exists (Section 3)                                                                                                                                                                                                                                                                 |
| `08-WIREFRAMES`  | **Exploration only** | The medium is fixed as self-contained HTML, and a second, undiffable medium is ruled out (`project-management/workflows/08-wireframes/STEPS.md:75-79`). Consolidated wireframes are slop-gated (`code/src/scripts/audits/css-slop.sh:89-94`). The map's out-of-scope line bars any hosted tool as the artefact of record (`project-management/src/01-FEATURE-MAPS/MAP-CLAUDE-DESIGN-HANDOFF.md:158`)                                                                                                         |

Two cross-cutting facts constrain any adoption:

- **No gate would catch literal colours** from either app.
  - `css-tokens.sh` only checks that each `var(--x)` in `*.css` resolves; it has no literal-value
    detection (`code/src/scripts/audits/css-tokens.sh:3-24`, `:50-52`).
  - `template-slop.sh` leaves colour to the stylesheet guards (`template-slop.sh:41-43`).
  - So FigCraft's `var(--x, literal)` fallbacks and VectorCraft's inline-SVG hex fills pass every
    gate, and token-first rests on review alone.
- **`.mcp.json` ships into every generated project.** `copier.yml` does not exclude it, so a
  project-level FigCraft MCP entry would reach every client project. The precedent for an opt-in
  third-party tool is `INCLUDE_CLICKUP` (`copier.yml:281-285`, `:660`).

---

## 5. Provenance and supply chain

| Claim                                                                                                                                                                                                         | Primary source                                                                                                                                                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Most of the code is agent-written. Claude co-author trailers sit on 57-75% of non-merge commits (FigCraft: 153 of 268), and the roadmaps are costed in agent-hours. Two public members steer it               | `git log --grep 'co-authored-by:.*claude'` on each clone · `effectcraft@05955c0` docs/target-app-parity.md:361 · `gh api orgs/storytold/public_members`                                |
| Linux packages are deliberately unsigned. `SHA256SUMS.txt` is generated and published in the same release, and no build attestations exist — so a checksum match proves integrity, not authenticity           | `vectorcraft@0a33cff` .github/workflows/release.yml:182 · `figcraft@833f0d2` .github/workflows/release.yml:7, :525 · `gh api repos/storytold/<app>/attestations/sha256:<digest>` (404) |
| The shared release workflow that receives the signing secrets is called at `@main`, deliberately unpinned, and its `main` branch has no ruleset                                                               | `effectcraft@v0.9.2` .github/workflows/release.yml:22-23 · `gh api repos/storytold/craft-common-actions/rules/branches/main` (empty)                                                   |
| Private vulnerability reporting is off in all six repositories. A third party's request for a private channel for high-severity findings has no maintainer reply                                              | `gh api repos/storytold/<app>/private-vulnerability-reporting` · photocraft#4819 (13/10/2026)                                                                                          |
| No app has telemetry crates. FigCraft's only network path is the share WebSocket. The launcher polls `api.storyteller.ai` and replaces its own AppImage                                                       | `Cargo.lock` scans at each release · `craft-launcher@v0.4.1` crates/core/src/feed.rs:26 · crates/native/src/self_update.rs:14, :237                                                    |
| Open data-loss bugs: in FigCraft, a document silently rolls back on a text edit and undo cannot recover it; in EffectCraft, a failed export destroys the previous file; PhotoCraft has open save-path defects | figcraft#278 · effectcraft#1230 · photocraft#4953, #4968                                                                                                                               |
| The clean-room claim is challenged in open issues with no owner reply. A nixpkgs legal-status issue closed with agreement to package. **Not legal advice.**                                                   | photocraft#341 · lightcraft#1339 · NixOS/nixpkgs#571683                                                                                                                                |
| artcrafttools.com and effectcrafts.com are unaffiliated third-party sites, by their own disclaimers. The official site is getartcraft.com                                                                     | each site's own footer · `gh api orgs/storytold` (`blog` field)                                                                                                                        |

---

## 6. Corrections made in verification

The adversarial pass refuted four researcher claims. The text above already uses the corrected
version:

- **FigCraft issue #219 is not a format bump.** Every tag has format 1, and the version check cannot
  raise the error the issue reports (`figcraft@833f0d2` crates/format/src/lib.rs:304-310).
- **`css-tokens.sh` is not a raw-literal ban**, so literal colours pass rather than fail (Section 4).
- **PhotoCraft's HTTP and TLS crates are on `main` only**, not in the v0.8.2 release's `Cargo.lock`.
- **Running `figcraft-cli mcp` as a project MCP server was withdrawn as a recommendation.** It has no
  file confinement and can publish to the public server in one command, and `.mcp.json` ships to
  every project.

---

## 7. Drift found in this repository

Found incidentally and confirmed by the verifier. None of it depends on adopting any app:

- `project-management/workflows/05-user-flow-design/STEPS.md:59-60` allows "any committed format".
  `CHANGELOG.md:146` says the workflow names Mermaid alone.
- `project-management/src/06-BRAND-GUIDE/CLAUDE.md:22-24` says to commit the `.pdf`, but
  `.gitignore:61-62` ignores both generated PDFs. The same instruction recurs in workflow 18
  (`STEPS.md:137`, `CHECKLIST.md:62-63`).
- `DESIGN.md:141` and `project-management/src/00-ASSETS/scripts/export-design-docs.sh:74-79` point
  at `Foundations*.html` and sibling files that nothing produces.
- The palette is copied by hand into three places: `guide-build/brand_guide.py:62-90`,
  `component-build/components.py:49-67` and `08-WIREFRAMES/SHARED/wireframe.css:20-66`.
- The 05 stage-1 template's image link (`USER-FLOW-IDEA-US000-TEMPLATE.md:27`) resolves from the
  wrong directory. It needs `../DIAGRAMS/`.
- No install doc lists the generators' xelatex dependency.
- The `.gitattributes:41` comment says no binary file is tracked, but `research/` tracks a PDF.

---

## 8. What is not settled

- **Runtime behaviour on this host.** Nothing was run, so it is unknown whether any app starts and
  renders correctly on NVIDIA with Hyprland. That includes the four already installed and FigCraft
  inside the wrapper.
- **FigCraft's runtime library set.** The wrapper's `extraPkgs` list was derived from the sister
  apps' binaries.
- **Font discovery** in VectorCraft, EffectCraft and PhotoCraft on NixOS is reasoned from code only.
- **EffectCraft's Lottie output** has not been validated against any player.
- **DesignCraft**, already installed at 0.6.0, was not evaluated as a brand-guide PDF tool.
- **Clean-room legality** was not assessed beyond recording the open challenges.
- **Ageing.** Releases land almost daily, so every version-bound claim here ages within days.

---

## 9. What this feeds

No ADR or story plan consumes this note yet. Candidate decisions:

| Decision                                                                                                                                         | Where it would land                                                                                                                                                     |
| ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Add FigCraft to the `pkgs/craft-apps` family, with the font and CLI fixes and a decision on the share server                                     | `nix-config` — outside this repository                                                                                                                                  |
| Allow a local tool as an exploration aid, or as the lesser tier used when Claude Design is unavailable                                           | A new node on `MAP-CLAUDE-DESIGN-HANDOFF.md`. N-003 already names a lesser, internal-deliverable tier for projects that fail Claude Design's availability floor (`:86`) |
| A VectorCraft logo pipeline: SVG into `LOGOS/`, fills converted to `currentColor`, headless rasters through a `code/src/scripts/**/*.sh` wrapper | A story touching `06-BRAND-GUIDE` and `00-ASSETS`                                                                                                                       |
| The Section 7 drift                                                                                                                              | `GAPS.md`, through workflow 22                                                                                                                                          |

---

## Sources

**Repositories, pinned.** Line citations above are against these commits:

| Short form              | Repository                                                                          | Commit         | What it is                               |
| ----------------------- | ----------------------------------------------------------------------------------- | -------------- | ---------------------------------------- |
| `figcraft@833f0d2`      | [storytold/figcraft](https://github.com/storytold/figcraft/tree/833f0d2c27f0)       | `833f0d2c27f0` | tag v0.6.0                               |
| `vectorcraft@0a33cff`   | [storytold/vectorcraft](https://github.com/storytold/vectorcraft/tree/0a33cff3f6e2) | `0a33cff3f6e2` | tag v0.11.0                              |
| `photocraft@c699e3c`    | [storytold/photocraft](https://github.com/storytold/photocraft/tree/c699e3cda69f)   | `c699e3cda69f` | `main`, 14/10/2026 (v0.8.2 is `d43db3e`) |
| `lightcraft@3b4279f`    | [storytold/lightcraft](https://github.com/storytold/lightcraft/tree/3b4279fc2485)   | `3b4279fc2485` | `main`, 14/10/2026 (v0.7.1 is `701f78e`) |
| `effectcraft@05955c0`   | [storytold/effectcraft](https://github.com/storytold/effectcraft/tree/05955c08b4fd) | `05955c08b4fd` | `main`, 14/10/2026 (v0.9.2 is `470ea7a`) |
| `craft-launcher@v0.4.1` | [storytold/craft-launcher](https://github.com/storytold/craft-launcher/tree/v0.4.1) | `cbae640688c5` | tag v0.4.1                               |
| `<app>@v<x.y.z>`        | the app's release tag                                                               | —              | where the verifier read the tag directly |
| `nix-config@3897629`    | `~/Repos/personal/nix-config` (private, local)                                      | `389762971a1f` | `main`, 14/10/2026                       |

**Release binaries.** Each app's latest `linux-x86_64.tar.gz` and its
[`SHA256SUMS.txt`](https://github.com/storytold/figcraft/releases/tag/v0.6.0) passed `sha256sum -c`.
They were inspected with `tar -tzvf`, `readelf`, `objdump -T` and `strings`, and never executed.

**Issues and pull requests** cited as `<repo>#<n>` live at `https://github.com/storytold/<repo>/issues/<n>`:

- figcraft #195, #219, #278
- photocraft #341, #386, #4819, #4953, #4968, #5031
- vectorcraft #1292
- lightcraft #639, #1339
- effectcraft #268, #1116, #1230, #1361

nixpkgs:

- [NixOS/nixpkgs#571418](https://github.com/NixOS/nixpkgs/pull/571418),
  [#571423](https://github.com/NixOS/nixpkgs/pull/571423),
  [#571429](https://github.com/NixOS/nixpkgs/pull/571429),
  [#571432](https://github.com/NixOS/nixpkgs/pull/571432)
- [NixOS/nixpkgs#571683](https://github.com/NixOS/nixpkgs/issues/571683)

**GitHub API.** `gh api` reads of `orgs/storytold`, the repo metadata, releases and tags,
contributors, attestations, `private-vulnerability-reporting` and branch rules — all on 14/10/2026.

**Live host.** `nixos-version`, `lspci`, the session variables, `ls /run/current-system/sw/bin`,
`nix eval nixpkgs#<app>`, and the four font directories — all read-only, on 14/10/2026.

**This repository.** Every `project-management/`, `code/`, `copier.yml`, `.gitignore`,
`.gitattributes`, `DESIGN.md` and `CHANGELOG.md` path cited above, at `24b932a`.

**Scouts only, cited for nothing.** These pointed at the primaries above:

- [GIGAZINE](https://gigazine.net/gsc_news/en/20261005-artcraft-crafting-apps/)
- [TechAeris](https://techaeris.com/2026/10/07/artcraft-launches-7-open-source-creative/)
- [pasqualepillitteri.it](https://pasqualepillitteri.it/en/tools/artcraft-apps-download)
- [OMG! Ubuntu](https://www.omgubuntu.co.uk/2026/10/artcraft-free-photoshop-ai-clone)
- [Notebookcheck](https://notebookcheck.net/Photoshop-Premiere-more-Experienced-Rust-developer-recreates-Adobe-suite-with-AI-assistance-as-open-source.1419230.0.html)
- [artcrafttools.com](https://artcrafttools.com/), which is unaffiliated
