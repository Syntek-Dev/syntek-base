# Design hand-off targets — what each external tool takes in, gives back, runs on and binds a project to

**Written**: 15/10/2026. **Driver**: the 15/10/2026 design hand-off research (`MAP-DESIGN-HANDOFF`,
a new map written alongside this note, see Feeds). **Read at**: `d16de16`.

**Method.** On 15/10/2026 three reader legs went back to the primaries behind earlier leads; where a
primary had moved, the primary won and the claim says what it says now. The writer re-opened the
load-bearing pages (Figma's modes and image articles, Penpot's token, layer and migration guides,
Claude Design's migration article, Canva's Trust Centre). The `context7` and Perplexity tiers were
unauthenticated for the session and were **not consulted** (`code/docs/GATE-REPORTING.md`: could not
look, not looked-and-clean). Web pages were read with the `scrapling` MCP — `get`, `make_request` or
`bulk_get` first, `fetch` only for the JavaScript-rendered pricing pages of Canva, Adobe, OpenAI and
Penpot; `stealthy_fetch` was not needed and `WebFetch` read nothing. GitHub sources were read with
`gh api`; this repository at `d16de16`, the installed Claude Code 2.1.291, the host's PATH and the
installed copier (9.17.1) were measured locally. The `claude-design` MCP server failed with HTTP
403, so nothing ran against Claude Design. **Nothing is quoted**: every line is re-authored and
cited, so the no-grant rule in `research/CLAUDE.md` never bites. This note never ships —
`copier.yml:146` excludes `/research/**`. The same day, an independent verifier's findings were
applied: every citation now resolves to a full URL or a repository path, the Verdict carries the
token-profile hedge, and the FigCraft export and Penpot intake claims were re-read and corrected.
Word five-grams shared with each source class were then counted and reworded to zero, against copies
saved with the `scrapling` CLI (`fetch` where `get` came back empty or challenged). Later the same
day the whole note was measured again by a stricter method, against copies that keep page
metadata, and the runs it found in this body were reworded too; the method and the figure are in
the Addendum's closing paragraph.

---

## Question

"Which external design tools can a project hand its consolidated, internally produced design set
to, and for each: what it takes in, what it gives back, whether it works on Linux, how it is driven
(MCP or API), and on what data-protection terms?"

## Verdict

No tool and no format takes the whole set. **Figma and Penpot are the only targets that read DTCG
token files**, both from a Linux browser through a vendor MCP server; FigCraft reads Figma's REST
variables JSON instead, which is not DTCG. Each of the two reads its own DTCG profile and neither
matches the 2025.10 report in full. On their documented profiles they disagree on colour form and
file structure, so no single token file is shown to serve both — inferred from the documentation
(DTCG claim 8), untested end to end. Canva, Adobe Express and ChatGPT take images and PDF but no
tokens; Adobe lists no Linux support; Claude Design's standalone site closes on 14/12/2026 and its
Claude Code route is disabled here. A raster image is the only input all seven main targets
document. Five of them take PDF, which **the repository's export scripts cannot produce on this host
as written**: a Chromium build sits in the Nix store and `qpdf` is on PATH, but the scripts look for
neither. Data terms turn on the plan: Canva's DPA covers Business and Enterprise only, OpenAI stops
training by default only from Business up, Figma's training opt-out below Organization is
prospective, and of the residency pages read only OpenAI's offers a UK region, for API and new
Enterprise/Edu customers.

---

## The targets at a glance

_Data floor_ is what the vendor's own pages say about processor terms, model training and
residency. Each cell summarises numbered claims below, which carry the citations.

| Tool          | Takes in                                                                                          | Gives back                                                              | Linux                                                    | MCP / API                                                                                                  | Data floor                                                                                                                                             |
| ------------- | ------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Figma         | Images; SVG as vectors; `.fig`, `.sketch`, PPTX; a DTCG subset; live UI                           | PNG, JPG, SVG, PDF renders; variables JSON (not called DTCG)            | Browser only; no local fonts                             | Remote MCP (OAuth); writes in beta; Variables REST API Enterprise-only                                     | Processor DPA with UK Addendum; training on by default on Starter and Professional; residency Enterprise-only, no UK region                            |
| Penpot        | Images and SVG; `.penpot`; Figma files via its Exporter plugin; tokens JSON in its own set layout | SVG, PDF, PNG, JPEG, WEBP; tokens JSON                                  | Browser; self-hostable                                   | Official MCP, remote (key in the URL) or local; needs an open tab                                          | Self-hosted: own server, official compose sends telemetry by default. SaaS DPA EEA/Swiss only, silent on UK GDPR                                       |
| Canva         | Office files, PDF, PSD, AI; images; SVG in the editor only; public URLs                           | JPG, PNG, GIF, PPTX, MP4, PDF, CSV, email HTML; no SVG via API          | Browser only                                             | Remote MCP (OAuth); Connect REST API                                                                       | DPA for Business and Enterprise only; their content not used for AI; stored in the US; residency US or EU, Enterprise tier                             |
| Adobe Express | PPTX, PDF, PSD, INDD, AI; images; SVG up to 250 KB                                                | PNG, JPEG, GIF, PDF, PPT; layered PSD (beta); IDML                      | Not listed (Windows, macOS, ChromeOS)                    | Adobe connector for Claude: template-based Express only                                                    | Adobe Ireland is controller for UK users; no generative-AI training on content; main processing in the US and India                                    |
| Claude Design | Screenshots, images, decks, documents, a code repo, design files                                  | Zip, PDF, PPTX, Google Slides, HTML, 15 send-to tools, Claude Code      | Web; `/design` artboards edited in a desktop browser     | Claude Code's `/design` and `/design-sync`; user-scope MCP (403 here)                                      | No residency; ZDR organisations excluded; outside the HIPAA BAA; the docs disagree on CMEK                                                             |
| ChatGPT/Codex | DOCX, PDF, TXT, sheets, PPTX, images; Codex reads the repo                                        | PNG, JPEG, WebP, never vector; text and files from Codex                | Desktop app in preview (named distros); Codex CLI native | Image API; `codex mcp`; read-write custom MCP on Business, Enterprise/Edu only                             | No training by default from Business up; Free to Pro opt-out; processor DPA with UK Addendum; UK storage residency for API and new Enterprise/Edu only |
| FigCraft      | `.fig` (best effort), Figma REST JSON, SVG, PNG, JPG, WebP, PDF                                   | PNG, JPG, WebP, SVG, PDF; experimental `.fig`; variables as JSON or CSS | Native builds; installed here                            | stdio MCP with no path roots; `figcraft-cli`                                                               | Local, no account or telemetry; default share server stores files unencrypted, terms name no entity                                                    |
| Framer        | Not read                                                                                          | No HTML export to host elsewhere                                        | Not read                                                 | Not read                                                                                                   | Trains its own models on non-Enterprise AI inputs and outputs unless switched off                                                                      |
| Lunacy        | Figma files                                                                                       | PNG, JPG, WEBP, TIFF, BMP, ICO, SVG, PDF; CSS, XAML, JSON code views    | Native                                                   | None shown (corrected 15/10/2026: a local MCP server - see Addendum, N-029 on MAP-DESIGN-HANDOFF, item 14) | Not read here; see Addendum, N-029 on MAP-DESIGN-HANDOFF                                                                                               |
| Miro          | Boards and diagrams built from DSL text through MCP                                               | Not read                                                                | Not read                                                 | Remote MCP (OAuth 2.1); off on Enterprise until enabled                                                    | Not read here; see Addendum, N-029 on MAP-DESIGN-HANDOFF                                                                                               |
| draw.io       | Mermaid as native shapes (28 types through its MCP)                                               | SVG 1.1 with optional embedded diagram; PNG, PDF                        | Desktop builds; offline                                  | Hosted or local MCP; assistant plugins                                                                     | Web data leaves the browser only for PDF (or old-browser raster) export; desktop fully offline                                                         |

---

## Claims

### Figma

1. DTCG JSON imports as variables, linked to the 2025.10 Format Module. Each file dropped into a new
   collection becomes one mode; a variable is made only for a token present, with the same
   supported type, in every file. Exports come back as JSON the article does not call DTCG.
   (Figma help 15343816063383, 'Import modes', 'Export modes')
2. Starter is the one plan without variable modes; every paid tier and Education has them, and
   publishing variables needs a paid or Education plan. The Variables REST API is Enterprise-only,
   and its page's text and table disagree on who may read. (Figma help 15343816063383,
   15339657135383; https://www.figma.com/pricing/;
   https://developers.figma.com/docs/rest-api/variables/ 'Getting started')
3. JPG, PNG, HEIC, WebP and GIF upload as fills on every plan, scaled down past 4,096 px; an SVG
   becomes an editable vector layer. The file browser takes Figma's own formats, `.sketch`,
   PowerPoint and PNG/JPG; PDF is in neither list. (Figma help 360040028034, 360041003114)
4. On Linux Figma runs only in a supported browser — the desktop apps are macOS and Windows — and
   local fonts are not supported, leaving the default Google Fonts. (Figma help 360039827194, 360039956994)
5. The remote MCP server (`https://mcp.figma.com/mcp`) signs each user in with OAuth and needs no
   desktop app; Claude Code and Codex are in its client catalogue. The desktop server needs the
   macOS/Windows app and lacks the write tools. Dev and Full seats get 200 calls a day (600 on
   Enterprise); View, Collab and Starter seats get 20 a month. (Figma help 32132100833559; Figma
   dev `remote-server-installation`, `rate-limits-access`)
6. `use_figma` runs Plugin API code to create frames, components, variables and styles; it needs a
   Full seat, and below Enterprise is the scripted route to variables. It allows 20 KB per call,
   no images and no custom fonts, and is free in beta before becoming paid. A remote-only
   `upload_assets` places PNG, JPG, GIF or WebP fills. Figma's pages disagree on images and on
   fonts. (Figma dev `write-to-canvas`, `tools-and-prompts`; Figma help 15339657135383)
7. `generate_figma_design` captures live UI from localhost, staging or production, binding variables
   only from a library added first. `download_assets` returns PNG, JPG, SVG or PDF renders;
   `generate_diagram` builds FigJam diagrams from Mermaid. (Figma dev `code-to-canvas`,
   `tools-and-prompts`)
8. AI training is on by default for Starter and Professional, where an admin can switch it off for
   new content only (training has run since 15/08/2024); it is off for Organization and
   Enterprise. (Figma help 17725942479127)
9. Residency is Enterprise-only, on AWS, with an EU region and no UK region, and excludes plugin
   output, AI chats and beta products. (Figma help 15643274574871)
10. The DPA (30/03/2026) makes Figma a processor, with 72-hour breach notice where feasible and
    15 days' sub-processor notice. It brings UK GDPR into scope, layers the UK's transfer addendum
    over its standard contractual clauses, and states Data Privacy Framework certification with the
    UK Extension. Professional costs USD 16 per Full seat a month. (https://www.figma.com/legal/dpa/
    sections 1.2-5, Schedule 2 sections 4 and 5.3; https://www.figma.com/pricing/)

### Penpot

1. Penpot is MPL-2.0; its default branch is `develop`; the latest release is 2.18.3 (06/10/2026),
   and 2.19.0 is unreleased. (`gh api repos/penpot/penpot` and releases;
   `penpot/penpot@7383e08:CHANGES.md:3`)
2. Images are inserted with the image tool, by dragging or by pasting. For a team leaving Figma, the
   migration guide gives three routes: place exported SVG, PNG or JPG as static assets; move whole
   design files, components, variants, styles, variables and libraries with Penpot's Exporter
   plugin for Figma, expecting some layout cleanup; and bring tokens as Tokens Studio JSON, or
   native Figma Variables through Tokens Studio or that plugin. Files arrive as `.penpot` or zip,
   up to 1 GB. (Penpot 2.18.3 `designing/layers.njk:203-210`,
   `first-steps/migration-guide.njk:21-23`, `export-import/export-import-files.njk:43-45`)
3. Token import replaces the file's global set, from one JSON, a folder or a zip, and can be undone.
   A single file's top-level keys become set names; a folder adds `$themes.json` and
   `$metadata.json`. Export is JSON. The unreleased 2.19 docs block import while a library
   supplies the tokens. (Penpot 2.18.3 `design-systems/design-tokens.njk:680-761`;
   `penpot/penpot@7383e08:docs/user-guide/design-systems/design-tokens.njk:22-23,685`)
4. Layers and boards export as SVG, PDF, PNG, JPEG or WEBP. (Penpot 2.18.3
   `export-import/exporting-layers.njk:32,58-59`)
5. Penpot MCP works through a plugin in the open tab, reading and changing components, tokens and
   layers on the page in focus. The remote URL carries a per-user key that Penpot treats as a
   password; no plan gate is stated. Local MCP can use local paths; remote cannot.
   (https://help.penpot.app/mcp/; https://penpot.app/pricing)
6. 2.15.0 added MCP and fixed a REPL that listened on every interface, open to unauthenticated code
   execution; 2.18.0 stopped MCP tokens working as API tokens and disabled the MCP devtools whenever
   an instance runs with several users. (`penpot/penpot@7383e08:CHANGES.md:223,276,279,729,766`)
7. Self-hosting is documented for Compose and Helm. The official 2.18.3 compose file enables MCP and
   sends anonymous telemetry by default. (https://help.penpot.app/technical-guide/getting-started/;
   `penpot/penpot@2.18.3:docker/images/docker-compose.yaml:27,165-170,203-204`)
8. The DPA (31/01/2023) makes Kaleidos the processor under EU GDPR for the EEA and Switzerland and
   does not mention UK GDPR. The terms (05/08/2025) analyse only metadata; no AI-training clause
   was found. Unlimited costs USD 7 per editor. (https://penpot.app/dpa; https://penpot.app/terms
   4.3; https://penpot.app/pricing)

### DTCG 2025.10, and the two profiles

1. The 2025.10 Format Module is a Community Group Report in Final status, dated 28/10/2025 and
   licensed by W3C's Community Final Specification Agreement; W3C has not made it a Standard. The
   2025.10 set has three modules. Tools must keep unknown `$extensions` and never guess a type.
   (https://www.designtokens.org/tr/2025.10/format/ 'Status', 'Type', 'Extensions';
   https://www.designtokens.org/tr/2025.10/)
2. A colour value is an object: `colorSpace` names one of 14 spaces, OKLCH among them, and
   `components` holds the per-channel numbers; gamut mapping is non-normative.
   (https://www.designtokens.org/tr/2025.10/color/)
3. Dimension is px or rem, duration ms or s, fontFamily a string or array, and fontWeight 1-1000 or
   a name. There are six composites and no string type. Theming is in the Resolver module, which has
   no `$themes` or `$metadata`. (2025.10 format 'Types';
   https://www.designtokens.org/tr/2025.10/resolver/)
4. **Figma's profile**: object colours in sRGB or HSL only; px and s only; one fontFamily string; a
   non-standard string type; no fontWeight, cubicBezier or composites; group paths become slash
   names. (Figma help 15343816063383 'Supported token types', 'Token naming'; set against claim 3)
5. **Penpot's profile**: colours as strings in Hex, HSL, HSLA, RGB, RGBA or ARGB; top-level keys
   read as sets; font size px only; fontFamily a comma list; fontWeight a case-insensitive string;
   typography and shadow composites. Its rem section sits inside an HTML comment, unpublished.
   (Penpot 2.18.3 `design-systems/design-tokens.njk:30,369,409,420-421,477,507,539,703,818-845`)
6. Penpot's guide calls its tokens DTCG-compliant and portable without conversion, and links a URL
   that now redirects to a DTCG draft dated 08/09/2026. (Penpot 2.18.3
   `design-systems/design-tokens.njk:18-19`;
   https://www.designtokens.org/tr/drafts/format/)
7. Issue #9305 (open, no maintainer reply, tested on 2.14.4) is one user's report that object
   colours import silently as errors. (`gh api repos/penpot/penpot/issues/9305`)
8. **No single file serves both** (inference from claims 4 and 5): Figma needs object colours and
   group-keyed files; Penpot documents string colours and reads top-level keys as sets.
9. This repository's token model is declared, not wired: OKLCH is canonical, with HSL, HSLA, RGB,
   RGBA and HEX derived on every write; its value kinds include easing and shadow; out-of-sRGB
   colours are gamut-mapped by CSS Color 4 chroma reduction. (`code/docs/DESIGN-TOKENS.md:16`;
   `code/docs/design-tokens/MODEL.md:51,61-63`; `code/docs/design-tokens/MOBILE.md:61-65`)

### Canva

1. REST import takes Office, OpenDocument, iWork, Affinity, PSD, AI and PDF files; REST asset upload
   takes raster images under 50 MB. Neither takes SVG. (Canva dev
   `rest-apis/reference/design-imports`, 'Supported file types'; Canva dev
   `rest-apis/reference/assets`)
2. The editor takes SVG 1.1 under 3 MB, styled with presentation attributes rather than CSS.
   (Canva help `upload-formats-requirements`; Canva dev `api/latest/asset-upload`)
3. Two help pages disagree on whether an imported PDF stays editable. (Canva help
   `import-and-edit-pdfs-canva`, `upload-formats-requirements`)
4. REST export gives JPG, PNG, GIF, PPTX, MP4, PDF, CSV and email HTML, no SVG, with links that
   expire in 24 hours. The editor's SVG download is not on Free. (Canva dev
   `rest-apis/reference/exports/create-design-export-job`; Canva help `download-or-purchase`)
5. The remote MCP server uses per-user OAuth. `import-design-from-url` needs a public HTTPS URL, and
   `create-upload-url` takes a local file's bytes. `list-brand-kits` returns no colour or font
   values. (Canva dev `mcp/verify-app`, `mcp/tools/import-design-from-url`,
   `mcp/tools/create-upload-url`, `mcp/tools/list-brand-kits`)
6. Canva runs in a browser, with desktop apps for Windows and macOS only. Pro costs GBP 100 a year
   and Business GBP 180. (Canva help `technical-requirements`; https://www.canva.com/en_gb/pricing/)
7. Canva stores data in the US. Its DPA is listed for Business and Enterprise only, with the UK
   Addendum; their content is not used for AI. Residency (US or EU) is Enterprise-tier.
   (https://www.canva.com/trust/privacy/; Canva help `data-residency`)

### Adobe Express

1. Express lists Windows, macOS and ChromeOS, and so does the Claude connector; Linux is not listed.
   (https://helpx.adobe.com/express/web/get-started/web-technical-requirements.html;
   https://helpx.adobe.com/creative-cloud/apps/integration-with-other-apps/adobe-connectors/adobe-for-claude.html
   'Technical requirements')
2. It converts PPTX, PDF, PSD, INDD and AI into editable designs, and takes SVG up to 250 KB. It
   warns that Figma-exported PDFs import badly.
   (https://helpx.adobe.com/express/web/bring-in-assets-from-other-apps/import-files-from-other-apps/import-files.html;
   https://helpx.adobe.com/express/web/image-creation-and-editing/change-file-formats/image-requirements.html)
3. Export is PNG, JPEG, GIF, PDF and PPT, plus layered PSD (beta) and IDML.
   (https://www.adobe.com/uk/express/pricing;
   https://helpx.adobe.com/express/web/print-and-export/export-to-photoshop.html;
   https://helpx.adobe.com/express/web/print-and-export/export-adobe-express-designs-to-adobe-indesign.html)
4. The connector starts Express work from a template and ends in a PDF. The page describes no import
   of a project's own design.
   (https://helpx.adobe.com/creative-cloud/apps/integration-with-other-apps/adobe-connectors/adobe-for-claude.html)
5. Adobe Ireland is the controller for UK users. It does no generative-AI training on content
   outside Adobe Stock. (https://www.adobe.com/uk/privacy/policy.html;
   https://helpx.adobe.com/account/individual/terms-policies-and-regulations/content-analysis-faq.html)

### Claude Design

1. Claude Design is now a template in Claude and Claude Code, on every plan. The standalone
   `claude.ai/design` site closes on 14/12/2026. Its projects are not yet movable, and its chats
   and public links end then. (Claude support 14604416, 17440474)
2. A project takes screenshots, images, decks, documents, a linked repository and design files; no
   article names SVG or Mermaid. Two Claude pages disagree on what `/design-sync` ingests.
   (Claude support 14604416, 14604397; Claude Code docs `commands.md`)
3. Export covers zip, PDF, PPTX, Google Slides, HTML, 15 send-to tools and Claude Code; `/design`
   artboards export as PNG or PDF. (Claude support 14604416; Claude Code docs `artifacts.md`)
4. In Claude Code, artifacts need Pro or above and the Anthropic provider. There is no residency.
   ZDR organisations cannot use it, and the docs disagree on CMEK. (Claude Code docs
   `artifacts.md`; Claude support 16994751, 17440474)
5. In the installed 2.1.291 CLI, `/design` import and export sit behind a server flag that defaults
   off. `disableBundledSkills` drops `/design-sync`. (local: Claude Code 2.1.291 binary)
6. This repository sets `disableBundledSkills` and `disableArtifact`, denies `DesignSync` but not
   `ClaudeDesign`, and ships no `claude-design` MCP entry. (`.claude/settings.json:119,229-230`;
   `.mcp.json`; local `~/.claude.json`)

### ChatGPT and Codex

1. Uploads take DOCX, PDF, TXT, spreadsheets, PPTX and images; HTML, CSS and SVG are not named.
   (OpenAI help 8555545)
2. The Image API returns PNG, JPEG or WebP and no vector. OpenAI notes weak exact text and layout.
   (https://developers.openai.com/api/docs/guides/image-generation.md 'Output format',
   'Limitations')
3. The Linux app is a preview for named distributions; nixpkgs packages it as unfree. The installed
   Codex CLI here is 0.160.1. (ChatGPT docs `linux/linux-app.md`;
   `NixOS/nixpkgs@cd0a087a1c68:pkgs/by-name/ch/chatgpt/`; local)
4. Only Business and Enterprise/Edu workspaces get read-write custom MCP. (OpenAI help 12584461)
5. OpenAI does not train on Business, Enterprise or Edu content by default; Free to Pro train, with
   an opt-out. (OpenAI help 7730893; https://chatgpt.com/pricing/)
6. UK storage residency is for API and new Enterprise/Edu customers. The DPA uses the UK Addendum
   and names the ICO. (OpenAI help 9903489; https://openai.com/policies/data-processing-addendum/
   section 2.9, Schedule 1)

### FigCraft

1. FigCraft calls itself early alpha. It opens `.fig` best-effort and reads SVG, PNG, JPG, WebP,
   PDF and Figma REST JSON. (`storytold/figcraft@102404e:README.md:22,73`; `docs/mcp.md:230`)
2. It exports PNG, JPG, WebP, SVG and PDF. A `.fig` writer also exists but is marked experimental
   and best effort. Variables export as JSON in the REST shape its importer reads, or as CSS, and
   it has no DTCG support. (`README.md:194`; `crates/format/src/fig/export.rs:1`;
   `docs/file-format-parity.md:59`; `crates/engine/src/cmd/variables_io.rs:1-3,66-69`)
3. The stdio MCP passes paths through with no root limit (#481). The control channel has no
   authentication (#480; fix PR #500 unmerged). (`crates/mcp/src/tools.rs:677-697`; `gh api`)
4. Its compiled-in share server stores files unencrypted and names no legal entity.
   (`crates/engine/src/live.rs:62-71`; `docs/online-sharing-terms.md`)

### Other and not-offered tools

1. **Framer** cannot export a site as HTML to host elsewhere, and trains on non-Enterprise AI
   inputs unless switched off.
   (https://www.framer.com/help/articles/can-i-export-my-website-to-html-and-self-host-it/;
   https://www.framer.com/legal/ai-notice sections 7.1-7.3)
2. **Lunacy** is a free native app, Linux included, that imports Figma files; it shows no API or
   MCP. **Miro**'s remote MCP builds boards and diagrams, signs in with OAuth 2.1 and is off on
   Enterprise until an admin enables it. (https://lunacy.docs.icons8.com/raw/export.md;
   https://icons8.com/lunacy; https://developers.miro.com/docs/mcp-intro.md 'Admin & Enterprise
   Guide')
   (Corrected 15/10/2026 - see Addendum, N-029 on MAP-DESIGN-HANDOFF, item 14.)
3. **draw.io** turns Mermaid into native shapes (its MCP lists 28 Mermaid diagram kinds) and
   exports SVG 1.1. Its desktop app runs offline on Linux, and the web app sends a diagram to its
   servers only for PDF export or raster export from an outdated browser.
   (https://www.drawio.com/docs/manual/mermaid/;
   https://www.drawio.com/docs/manual/export/export-to-svg/; https://www.drawio.com/docs/security/;
   `jgraph/drawio-mcp@7ed3cc2:README.md:36,118-148`)
4. **Not offered**: Affinity ships for Mac and Windows only; XD, from Adobe, sits in maintenance
   mode; Sketch's MCP is local to its Mac app; Uizard exports only JPG, PNG and PDF.
   (https://www.affinity.studio/download; https://helpx.adobe.com/xd/desktop/introduction/faq.html
   'Maintenance mode'; https://www.sketch.com/docs/mcp-server.md; https://uizard.io/pricing/)

### Kit floor — which format reaches which target

| Format              | Intake documented                                                     | Not documented in the pages read        | Constraint                                                              |
| ------------------- | --------------------------------------------------------------------- | --------------------------------------- | ----------------------------------------------------------------------- |
| Raster image (PNG)  | Figma, Penpot, Canva, Adobe Express, Claude Design, ChatGPT, FigCraft | —                                       | PNG named wherever formats are named; Figma caps 4,096 px               |
| PDF                 | Canva, Adobe Express, ChatGPT, FigCraft, Claude Design (brand)        | Figma Design, Penpot                    | The repo's export scripts cannot run here as written (claims 1-2 below) |
| SVG                 | Figma, Penpot, Canva editor, Adobe Express, FigCraft                  | Canva REST, ChatGPT, Claude Design      | Canva: SVG 1.1, presentation attributes; Express: 250 KB                |
| HTML or served page | Figma capture; Canva MCP (public URL); Claude Design (a linked repo)  | Canva REST, ChatGPT upload              | Canva needs a public HTTPS URL                                          |
| DTCG tokens         | Figma (its profile); Penpot (its profile)                             | Canva, Adobe Express, ChatGPT, FigCraft | No single file serves both (DTCG claim 8)                               |
| Mermaid source      | Figma `generate_diagram`; draw.io                                     | Claude Design, Penpot, FigCraft         | draw.io resets layout when the source is reapplied                      |

1. Both PDF export scripts look for Chrome only at three fixed paths, none present here. Chromium
   `155.0.8059.39` and Playwright's Chromium builds are in the Nix store but not on PATH, so the
   host is not shown unable to render a PDF; the scripts as written cannot.
   (`project-management/src/00-ASSETS/scripts/export-design-docs.sh:62-69`;
   `export-wireframes.sh:73-80`; local)
2. Both need `gs` for cropping and `pdfunite`, `gs` or Python `pypdf` for merging; none is available
   here, and `qpdf` is on PATH but unused. (`export-design-docs.sh:125-207`;
   `export-wireframes.sh:191-281`; local)
3. Copier's floor here is 9.6.0, with 9.17.1 installed. Multi-select arrived in 9.1.0 and answer
   validation in 9.2.0. List answers on the command line need 9.8.0, above the floor.
   (`copier.yml:13`; `copier-org/copier@5d95bfa:CHANGELOG.md:310-314,440-474`)

---

## What this note does not settle

- **Unread or unreadable** when this note was first written, each since read for the Addendum:
  - Figma's sub-processors and AI terms. (Answered 15/10/2026 - see Addendum, N-025 on
    MAP-DESIGN-HANDOFF.)
  - Whether Figma's token import works on Starter. (Read 15/10/2026 and still open: no Figma page
    settles it - see Addendum, N-025 on MAP-DESIGN-HANDOFF, items 10 to 12.)
  - Penpot's SaaS storage location, privacy policy and hosting-region plan. (Answered 15/10/2026 -
    see Addendum, N-026 on MAP-DESIGN-HANDOFF, which establishes only EU-based data centres;
    the operator, the country and which plan buys a region are still open.)
  - Anthropic's DPA. (Answered 15/10/2026 - see Addendum, N-027 on MAP-DESIGN-HANDOFF.)
  - Adobe's DPA and Express API docs. (Answered 15/10/2026 - see Addendum, N-028 on
    MAP-DESIGN-HANDOFF.)
  - Lunacy's and Miro's terms. (Answered 15/10/2026 - see Addendum, N-029 on MAP-DESIGN-HANDOFF.)
- **Not re-read in this pass:** Photoshop, Illustrator and Google Stitch. (Answered 15/10/2026 -
  see Addendum, N-030 on MAP-DESIGN-HANDOFF.)
- **Unmeasurable offline:** whether the Claude Design server flag is on for this account.
- **Untested end to end:** a Penpot export into Figma; a 2025.10 object-colour file into Penpot;
  Canva PDF editability; Figma's remote MCP from this NixOS/Wayland host.

---

## Sources

Shorthand in the claims, each expanding to a URL or path that resolved on 15/10/2026: _Figma help
N_ is `https://help.figma.com/hc/en-us/articles/N`; _Figma dev X_ is
`https://developers.figma.com/docs/figma-mcp-server/X/`; _Canva help X_ is
`https://www.canva.com/help/X/`; _Canva dev X_ is `https://www.canva.dev/docs/apps/X/`; _Claude
support N_ is `https://support.claude.com/en/articles/N`; _Claude Code docs X_ is
`https://code.claude.com/docs/en/X`; _OpenAI help N_ is `https://help.openai.com/en/articles/N`;
_ChatGPT docs X_ is `https://learn.chatgpt.com/docs/X`; _Penpot 2.18.3 F_ is file F under
`penpot/penpot@2.18.3:docs/user-guide/`. Adobe, Framer and the other tools are cited by full URL.

- **Figma** — the help articles and developer pages cited; `https://developers.figma.com/docs/rest-api/variables/`;
  https://www.figma.com/legal/dpa/; https://www.figma.com/pricing/. **No licence grant**: reworded.
- **Penpot** — `penpot/penpot` at `2.18.3` and `develop` (`7383e08`); help.penpot.app pages.
  **MPL-2.0**, reworded. Issue #9305 is user content under GitHub's terms. penpot.app `dpa`,
  `terms` and `pricing`: **no licence grant**, reworded.
- **DTCG** — https://www.designtokens.org/tr/2025.10/ (format, color, resolver), licensed by W3C's
  **Community Final Specification Agreement**, which is permissive with attribution; reworded, as
  is the draft at `/tr/drafts/format/`.
- **Canva** — the help and canva.dev pages cited; https://www.canva.com/en_gb/pricing/;
  https://www.canva.com/trust/privacy/; https://www.canva.com/policies/privacy-policy/;
  https://www.canva.com/policies/data-processing-addendum/. **No licence grant**: reworded.
- **Adobe** — the helpx pages cited by full URL; https://www.adobe.com/uk/express/pricing;
  https://www.adobe.com/uk/privacy/policy.html. **No licence grant**: reworded.
- **Anthropic** — the support articles and Claude Code docs cited;
  `anthropics/claude-code@94506ff:CHANGELOG.md`. **No licence grant**: reworded. The 2.1.291
  binary is **proprietary**: behaviour and identifiers only, nothing reproduced.
- **OpenAI** — the help articles cited; `https://developers.openai.com/api/docs/guides/image-generation.md`;
  the ChatGPT docs cited; https://chatgpt.com/pricing/; https://openai.com/policies/data-processing-addendum/.
  **No licence grant**: reworded. `openai/codex` (**Apache-2.0**) and `NixOS/nixpkgs` (**MIT**):
  metadata only.
- **FigCraft** — `storytold/figcraft@102404e`, **`MIT OR Apache-2.0`**, brand marks excluded;
  issues #480 and #481 and PR #500 under GitHub's terms. Reworded.
- **Others** — Framer, Lunacy, Miro, draw.io, Affinity, Adobe XD, Sketch and Uizard pages, each
  cited by full URL in its claim (**no licence grant**); `jgraph/drawio-mcp` (**Apache-2.0**).
  Reworded throughout.
- **Copier** — `copier-org/copier@5d95bfa` (**MIT**), reworded.
- **This repository and host** — the paths cited at `d16de16`, and host measurements on 15/10/2026.

### Added 15/10/2026, for the CHART Step 7 addendum

Two more shorthands: _Anthropic privacy N_ is `https://privacy.claude.com/en/articles/N`, and _Miro
help N_ is `https://help.miro.com/hc/en-us/articles/N`. Every page below was read on 15/10/2026.

- **Figma** — https://www.figma.com/sub-processors/; https://www.figma.com/legal/tos/;
  https://www.figma.com/legal/ai-terms/; Figma help 17725942479127, 14506821864087 and 360040328273;
  https://www.figma.com/blog/schema-2025-design-systems-recap/. **No licence grant**: reworded.
  `figma/plugin-samples` at `03131be` (**MIT**, read with `gh api`): facts only.
- **Penpot** — new: https://penpot.app/security-whitepaper, `/penpot-enterprise` and
  `/privacy-policy`; re-read: `/pricing`, `/dpa` and `/terms`, listed above. Penpot's code is
  MPL-2.0; its website and legal text are not, and carry **no licence grant**: reworded.
- **Anthropic** — https://www.anthropic.com/legal/ `data-processing-addendum`, `commercial-terms`,
  `service-specific-terms`, `consumer-terms` (the UK version served) and `privacy`; Anthropic
  privacy 7996862, 9267385 and 7996866; Claude support 14604397 and 11176164; Claude Code docs
  `data-usage.md`. **No licence grant**: reworded.
- **Adobe, legal** — `dpa-ww.pdf` and the Express Product Specific Terms PDF (both cited by full
  URL); https://www.adobe.com/uk/legal/terms/enterprise-licensing/data-protection.html;
  https://www.adobe.com/uk/legal/terms.html; https://www.adobe.com/privacy/sub-processors.html.
  `make_request` returned the PDFs as bytes it could not decode, so each was read from a copy taken
  with an impersonating `curl` and converted with `pdftotext`. https://dpa.adobe.com ends at an
  Adobe sign-in and is recorded as **unavailable**. **No licence grant**: reworded.
- **Adobe, product and requirements pages** — the helpx pages for Photoshop (desktop and web),
  Illustrator (desktop and web), Adobe for Claude and the connector overview, each cited by full
  URL. **No licence grant**: reworded.
- **Adobe, developer pages** — developer.adobe.com pages for the Express API, the Embed SDK and the
  add-on SDK, rendered from `AdobeDocs/ffs-express-api`, `AdobeDocs/cc-everywhere` and
  `AdobeDocs/express-add-ons-docs`, which GitHub reports as **Apache-2.0** (`gh api`). Facts and API
  identifiers only.
- **Miro** — https://miro.com/legal/ `terms-of-service`, `customer-data-processing-addendum`,
  `privacy-policy` and `ai-features-addendum`; Miro help 23084283851026, 22874000865554
  and 11277533556626. **No licence grant**: reworded. Miro's sub-processor PDF was **not read**.
- **Icons8 and Lunacy** — https://icons8.com/privacy-policy;
  https://icons8.com/terms-and-conditions; the `lunacy.docs.icons8.com/raw/` pages cited;
  `icons8/lunacy-docs` at `373c97f`, for which GitHub reports **no licence**, so it grants nothing.
  Reworded.
- **Google** — the three blog.google Stitch posts cited by full URL;
  https://policies.google.com/terms/service-specific?hl=en-GB and the UK Terms of Service. **No
  licence grant**: reworded. `google-labs-code/stitch-sdk` at `e3f8ece` and
  `google-labs-code/design.md` at `9bf8eae` (**Apache-2.0**): facts and tool identifiers only.
  Stitch's own documentation (https://stitch.withgoogle.com/docs) is **unavailable**: it renders by
  script inside a frame and came back empty.
- **Finders, never cited** — WebSearch; the community.penpot.app FAQ index; Figma's release-notes
  feed; the partial read of trust.anthropic.com/subprocessors (10 of 22 entries).
- **This repository and this conversation** —
  `project-management/src/09-GDPR/THIRD-PARTY-PROCESSORS.md`; `MAP-DESIGN-HANDOFF.md`, its Out of
  scope rows; Sam's Q5 decision on the offered list, cited as on that map (Sam, this conversation,
  15/10/2026 (Q5)).

---

## Addendum - CHART Step 7 research nodes, 15/10/2026

**Written**: 15/10/2026 | **Driver**: the six research nodes MAP-DESIGN-HANDOFF listed for Step 7
(N-025 to N-030 on MAP-DESIGN-HANDOFF), fired the same day | **Read at**: this repository at
`d16de16` (working tree); GitHub sources at the commits named under Sources

**Method.** Reader legs went to each primary on 15/10/2026. The writer of this addendum then
re-opened every load-bearing passage through the `scrapling` MCP: `make_request` or `bulk_get`,
scoped by a CSS selector to the clause in question, and `fetch` only for Adobe Express pricing
(drawn in the browser) and Adobe's DPA generator (which ends at a sign-in). The two Adobe PDFs are
the exception recorded under Sources. GitHub sources were read with `gh api` at pinned commits.
`context7` and Perplexity were unauthenticated this session and were **not consulted**
(`code/docs/GATE-REPORTING.md`: could not look, not looked-and-clean). Each node is answered as
fact; the response is left to the map. **Nothing is quoted**, and that is measured: see the closing
paragraph. This addendum answers the items "What this note does not settle" lists as unread or not
re-read. The body above keeps its wording; where this addendum answers or corrects it, a dated
pointer says so (the Lunacy row of the table, 'Other and not-offered tools' claim 2, and each item
in "What this note does not settle").

### N-025 on MAP-DESIGN-HANDOFF — Figma's sub-processors, AI terms and Starter token import

**Answer.** Figma's processor terms reach the free plan: the Terms of Service governing Starter and
Professional incorporate the DPA. Customer content is hosted on AWS in the United States unless an
Enterprise customer has chosen another location, and Figma AI passes prompts and outputs to nine
model vendors listed in the US, with requests allowed through data centres anywhere for latency.
Figma lists any new sub-processor at least 15 days before it starts; an objection that finds no fix
leaves ending the affected order as the only remedy. Under the AI Terms, inputs and outputs are the
customer's content and checking output is the customer's job; training follows an admin toggle that
protects only later content, is on by default for Starter and Professional, and below Enterprise AI
features cannot be switched back off once on. No Figma page read says whether native DTCG import
works on Starter.

1. The sub-processor page (dated 22/09/2026) is the list the DPA points to. Each row gives the
   service, the activity, the location and the kind of personal data, and a form takes sign-ups for
   change notices. (https://www.figma.com/sub-processors/; https://www.figma.com/legal/dpa/ 3.3)
2. Every service is hosted on AWS in the US, or for an Enterprise plan wherever it chose. Datadog,
   Sentry and Snowflake are also listed as handling customer content, all in the US.
   (sub-processors, hosting table)
3. Figma AI sends prompt inputs and outputs to nine model vendors, each placed in the US: Anthropic,
   AWS, Cerebras, Fireworks.ai, Google (Vertex), Jasper, Microsoft (Azure), OpenAI and Recraft. A
   footnote lets requests travel through data centres worldwide for speed or resilience; such data
   stays in volatile memory and its cache is emptied within two hours. (sub-processors, AI table and
   footnote)
4. Weave Tools (Figma AI running on Figma Weave) adds 15 vendors, some processing in the EU,
   Indonesia, Malaysia, Singapore or Israel. AWS Bedrock, Akismet, Hive and OpenAI screen prompts
   for moderation; IntouchCX gives support from Canada and the Philippines; and 15 Figma group
   companies, Figma UK Limited among them, may see customer content while supporting it.
   (sub-processors, Weave, hosting, support and entities tables)
5. The DPA (dated 30/03/2026) authorises sub-processors generally. A new one joins the list at least
   15 days before it starts, with written notice to subscribers. An objection must be written and
   rest on data-protection grounds; if none is resolved in that window, Figma may go ahead, and the
   customer's sole remedy is to end the affected order. (https://www.figma.com/legal/dpa/ 3.1, 3.4,
   3.5)
6. The Terms of Service (effective 11/03/2026) cover the two lower tiers, Starter and Professional,
   and fold the DPA in; Organization and Enterprise buyers are sent to the Software Services
   Agreement. Figma AI is limited to people aged 18 or more. (https://www.figma.com/legal/tos/
   preamble, 1.2, 2.1)
7. The Figma AI Terms (effective 24/06/2026) join the customer agreement, win where the two
   conflict, and leave standalone Weave out. Inputs and outputs are customer content the customer
   owns; Figma does not check output, and reviewing it is the customer's responsibility.
   (https://www.figma.com/legal/ai-terms/ preamble, 2, 5)
8. While an admin leaves Content Training switched on, Figma may train on customer content;
   switching it off shields only content and edits made afterwards. (ai-terms 3, 4)
9. Content training starts switched on for Starter and Professional teams, and an admin may switch
   it off; Organization and Enterprise start with it off and cannot turn it on for now. On Starter,
   Professional and Organization, AI features stay on for good once enabled; only an Enterprise
   organisation admin can disable them, organisation-wide or per workspace. The same article
   says outside model vendors may not train on customer data and keep it briefly or not at all.
   (Figma help 17725942479127)
10. Native DTCG import is documented only in the modes article, whose eligibility box names
    Enterprise, Organization, Professional and Education but not Starter; a new collection gets one
    mode per imported file. The variables overview puts variables on any plan, and the plan table
    leaves Starter's modes cell blank, against 10 a collection on Professional, 20 on Organization
    and no limit through extended collections on Enterprise. (Figma help 15343816063383, 'Before you
    Start', 'Import modes'; 14506821864087; 360040328273)
11. Figma's post of 28/10/2025 announcing native import and export of variables gave November and
    named no plan. Figma's MIT sample plugin imports a single collection and mode per run, with
    colour, number and alias tokens only.
    (https://www.figma.com/blog/schema-2025-design-systems-recap/;
    `figma/plugin-samples@03131be:variables-import-export/README.md:25-30`)
12. **Inference, not a statement:** a one-file import makes one mode, which Starter might allow; no
    Figma source read settles it. (claims 10 and 11)

**Not settled.** Starter import needs a test on a Starter team, with one file and then two. No page
read says whether the remote MCP's write tools count as Figma AI and so reach the AI vendors. The
list is a 22/09/2026 snapshot that moves on 15 days' notice, and no transfer mechanism is named for
the Weave vendors outside the US and the EU.

### N-026 on MAP-DESIGN-HANDOFF — Penpot SaaS: storage location, privacy policy and region plan

**Answer.** Kaleidos Subsidiary S.L of Madrid runs Penpot's SaaS, and its security whitepaper (dated
10/02/2025) keeps cloud customer data in EU-based data centres without naming the operator or the
country. Penpot's own pages disagree on which plan buys a hosting region: the whitepaper sells US or
other hosting as an extra on the Enterprise plan, the pricing table ticks region choice under
Private Server alone (USD 50,000 a year), and the Enterprise page offers any region without naming a
plan. The privacy policy (dated 05/08/2025) makes Kaleidos controller for its websites, hands its
processor work to the DPA, relies on European Commission clauses for transfers, runs Google
Analytics and PostHog, sends complaints to Spain's AEPD and never mentions the UK. The DPA names no
sub-processor and expects no international transfer; the whitepaper names six third parties and
plans for safeguarded transfers.

1. Per the whitepaper, Penpot/Kaleidos hosts and manages the cloud service; the free plan is hosted
   in Europe, and US or other hosting is an extra the Enterprise plan can buy. Customer data
   sits in EU-based data centres; no operator or country is named.
   (https://penpot.app/security-whitepaper, 'Deployment Models', 'Cloud Service Data Protection',
   'Data Security')
2. The pricing cards give Professional at USD 0; Unlimited at USD 7 per editor a month, capped at
   USD 175; Enterprise at USD 25 per member a month, with a USD 950 monthly minimum in the page's
   structured data; and Private Server at USD 50,000 a year. In the comparison table the
   region-choice row has a tick under Private Server only, and SSO is ticked under Enterprise and
   Private Server. (https://penpot.app/pricing; the row icons read from the page's HTML)
3. The Enterprise page charges USD 950 a month whatever the team size, and offers cloud, self-hosted
   or air-gapped use hosted in any region, without saying which plan includes it.
   (https://penpot.app/penpot-enterprise)
4. The whitepaper names FLOSSystems SL of Spain for infrastructure work with server access, and
   PostHog, Customer.io, Inkeep, HubSpot and Google Analytics for marketing and analytics. Its
   transfer section pairs EU hosting with transfer impact assessments and, where they apply,
   standard contractual clauses. (whitepaper, 'Subprocessors and Third Parties', 'International Data
   Transfers')
5. The DPA (dated 31/01/2023) is confined to EEA or Swiss controllers or data subjects. It lets
   Kaleidos engage subcontractors (hosting, network, anti-fraud, analytics and similar) under a
   general authorisation, with no list, notice period or objection right, and says no international
   transfer is expected. (https://penpot.app/dpa sections 2 and 10)
6. The two documents differ on breaches and deletion. The DPA has each party warn the other within
   48 hours and allows up to 90 days to suppress data once the relationship ends; the whitepaper
   promises notice within 72 hours and removes marked data after 30 days for records or 15 for
   media. (dpa sections 5 and 11; whitepaper, 'Cloud Service GDPR Compliance', 'Cloud Service Data
   Protection')
7. The privacy policy makes Kaleidos Subsidiary S.L, Madrid, controller for processing through its
   website, and leaves out what it processes as a processor for an organisation, referring that to
   the DPA. (https://penpot.app/privacy-policy, 'Data controller', section 1)
8. It shares data with IT suppliers such as hosting, CRM and email firms; for transfers it relies
   on the EU's SCCs, which the European Commission issues, or on another lawful route.
   Site analytics use Google Analytics and PostHog, which holds a pseudonymised profile and a
   de-identified IP address. (privacy-policy, sections 2 and 5)
9. Complaints go to Spain's AEPD. A search of saved copies of the policy and the DPA found no
   mention of the UK or the ICO. The policy says the services are not meant for under-18s; the terms
   admit users from 14. (privacy-policy, sections 6 and 10; https://penpot.app/terms 3.1)

**Not settled.** The data-centre operator and country. Which plan buys a region, which needs
Penpot's written answer. Where the whitepaper's marketing vendors process. Whether a UK controller
can rely on a DPA scoped to EEA and Swiss parties, a legal call for N-021 on MAP-DESIGN-HANDOFF. No
dated public sub-processor list or change notice was found, and which breach and deletion windows
govern is unsettled.

### N-027 on MAP-DESIGN-HANDOFF — Anthropic's DPA and Claude Design content

**Answer.** Read together, Anthropic's privacy centre and its Team and Enterprise admin guide put
Claude Design work by those organisations under the Commercial Terms and so under the DPA, though no
Anthropic page names Claude Design in either. On those plans the organisation is controller and
Anthropic its processor (Anthropic Ireland for a UK customer); no model trains on the data unless
the organisation opts in as a development partner; a breach is reported within 48 hours; a new
subprocessor can be objected to within 15 days; data comes back and is erased no later than 30 days
after the end; and UK transfers use the ICO addendum over the EU clauses. Uploaded brand material is
kept persistently under the organisation's retention rules, with no residency option and no BAA
cover. Design systems are in beta, so the beta clause (as-is, liability capped at USD 1,000) may
reach them, which is an inference. On Free, Pro or Max no DPA applies: the Consumer Terms govern
even an entity using Pro, and training runs unless the user opts out. Work sent on to Adobe, Canva
or another send-to tool leaves Anthropic's terms for that tool's.

1. The DPA (effective 24/02/2025) forms part of the Commercial Terms or of any other agreement that
   refers to it, and covers Customer Data.
   (https://www.anthropic.com/legal/data-processing-addendum, opening)
2. For Customer Personal Data the customer is controller and Anthropic processor, processing it only
   to run and keep up the Services, as the customer's documented instructions direct, unless a law
   binding Anthropic says otherwise. (DPA B.1, B.2)
3. Subprocessors on the list are authorised generally. A new one needs reasonable notice before it
   gets access; the customer may object in writing on privacy or security grounds within 15 days,
   and silence counts as consent. Anthropic stays liable for them. (DPA C.1-C.3)
4. Anthropic must report a breach in writing, promptly and never later than 48 hours after it learns
   of it. No later than 30 days after the end, Anthropic returns data on request, or offers
   self-service export, and deletes it, subprocessors included, unless law, a dispute or misuse
   prevention needs it kept. (DPA G.1, H.1)
5. UK GDPR transfers use the ICO's international transfer addendum laid over SCC Modules Two and
   Three, with Irish law and Irish courts for the SCCs; special category data is recorded as none.
   (DPA A.10, I.1-I.2, Schedule 1 B.3, Schedule 3 A.1.c-d and B.1)
6. The Commercial Terms (effective 17/06/2025) govern API keys and other offerings that cite them; a
   UK customer contracts with Anthropic Ireland, Limited. They exclude consumer use, leaving
   Claude.ai to the Consumer Terms. Anthropic may not train on customer content; inputs stay the
   customer's and outputs are assigned to it; the DPA is incorporated; and third-party features a
   customer opts into are not Services and are not Anthropic's responsibility.
   (https://www.anthropic.com/legal/commercial-terms preamble, A.2, B, C)
7. The privacy centre treats a Team or Enterprise customer as controller of what its users submit
   under the Commercial Terms, with Anthropic as processor, and says commercial data trains nothing
   unless the customer joins the Development Partner Program; accepting the Commercial Terms accepts
   the DPA. (Anthropic privacy 9267385, 7996862)
8. The Service Specific Terms (effective 31/08/2026) let a customer turn on Development Partner
   Mode, after which Anthropic may train on its submissions. Pre-release and beta Services come
   as-is, with liability limited to the lower of USD 1,000 and the last 12 months' fees.
   (https://www.anthropic.com/legal/service-specific-terms B, E)
9. Claude Design's design systems are in beta for Team, Enterprise, Pro and Max; they are on by
   default except on Enterprise, where an owner has to enable them. (Claude support 14604397)
10. The Team and Enterprise admin guide says uploaded design assets, brand guidelines and
    screenshots persist under the organisation's retention and deletion policies; Claude Design has
    no residency support; in a HIPAA-ready organisation Design falls outside the BAA, so PHI stays
    out; and artifacts are available under CMEK. (Claude support 16994751, 'Data handling and
    privacy' and the special-configurations list)
11. For organisations, a deleted conversation leaves back-end storage within 30 days; flagged
    content is kept for as long as 2 years and its classifier scores for as long as 7; feedback is
    kept 5 years. (Anthropic privacy 7996866)
12. The UK Consumer Terms (effective 08/10/2025) are with Anthropic Ireland, Limited for Claude Pro,
    Claude.ai and Anthropic's other services for individuals, and the Commercial Terms do not reach
    Claude.ai or Pro even for an entity. Anthropic may train on Materials unless the user opts out,
    and still uses feedback and safety-flagged material after an opt-out.
    (https://www.anthropic.com/legal/consumer-terms, opening, the note on organisations, 'Our use of
    Materials')
13. The privacy policy (effective 10/09/2026) makes Anthropic Ireland, Limited controller for UK
    residents and stands aside for content processed for business customers, which their agreements
    govern. Claude Code's data-usage page draws the same line: no training and 30-day retention on
    Team, Enterprise and API; a training choice on Free, Pro and Max, with 5 years' retention if
    allowed and 30 days if not. (https://www.anthropic.com/legal/privacy; Claude Code docs
    `data-usage.md`)
14. The tools Claude Design can pass work on to include Adobe for Creativity, Adobe Experience
    Manager, Adobe Journey Optimizer and Canva. Anthropic's connectors article says a connected
    service works on its own infrastructure under its own terms, and settings that pin where
    Claude's inference happens do not move it. The migration article says the standalone site's
    chats and comments go after the 14/12/2026 closure, under Anthropic's retention practices.
    (Claude support 14604416, 11176164, 17440474)
15. **Inference:** Team and Enterprise coverage of Claude Design rests on claims 7 and 10, not on a
    document that names it; whether the design-systems beta is a Beta Service under claim 8 is not
    stated.

**Not settled.** The subprocessor list at trust.anthropic.com was only part-read, 10 of 22 entries
by a reader leg, and its audit reports need an access request. Which retention article governs standalone Team and
Enterprise data at the closure: the migration article links the consumer one. The `claude-design`
MCP failed with HTTP 403, so nothing was measured against the product.

### N-028 on MAP-DESIGN-HANDOFF — Adobe's DPA against Express Premium, and Express import routes

**Answer.** No Adobe page read says the DPA covers Express Premium, and what the pages do say points
the other way. The DPA (Cloud Services only, June 2024) makes Adobe a processor where an agreement
such as the General Terms or a Sales Order supplies Cloud Services; Adobe offers a signed copy to
business customers only; its privacy policy makes Adobe controller when it sells straight to an
individual; and the UK pricing page sells Premium as a plan for individuals. Express is on Adobe's
processor list, but on the pages read only by way of a business plan, which is an inference. The DPA
link in the General Terms ends at an Adobe sign-in, recorded as unavailable. For importing a
project's own design no server-side route is documented: the Express API is a beta for evaluation
that reads and fills tagged Express documents and exports renditions, with no import; the Embed SDK
can open an image as a new design but needs Adobe's business approval and lists no Linux; and the
add-on SDK, inside a signed-in Express session, places SVG, AI, PSD and raster files, opens a PDF or
PPTX as a new document, and can draw shapes. No page read mentions importing tokens or HTML.

1. The DPA, headed Cloud Services Only and footed June 2024, supplements the General Terms, a Sales
   Order or another agreement, and covers personal data Adobe processes for the customer as part of
   Cloud Services, which it defines as the managed and on-demand services in that agreement.
   (https://www.adobe.com/cc-shared/assets/pdf/legal/terms/enterprise/pdfs/dpa-ww.pdf, opening, 1.3)
2. Adobe warns subscribed addresses 14 days before it adds a sub-processor. If an objection cannot
   be resolved, the customer may end only the affected part of a Sales Order and gets prepaid unused
   fees back. A breach is reported without undue delay, with no hour limit, and when the term ends
   the data is deleted or returned, whichever the customer picks. (dpa-ww.pdf 4.3, 8.1, 9.4)
3. Its European Area Law definition takes in the UK GDPR, its SCC definition takes in the UK
   transfer addendum, and European personal data passes first to Adobe Ireland before any onward
   transfer to sub-processors. (dpa-ww.pdf 1.10, 1.14, 7.2)
4. Adobe's data-protection page offers the DPA for download but limits generating a signed copy to
   business customers.
   (https://www.adobe.com/uk/legal/terms/enterprise-licensing/data-protection.html)
5. The General Terms of Use (effective 18/06/2024) apply the EU DPA where the user supplies EEA or
   UK personal data as controller with Adobe as processor, linking `adobe.com/go/tou-dpa`, which
   redirects to `dpa.adobe.com`. That page gave an empty body to `make_request` and an Adobe sign-in
   to `fetch`, and was not pursued further: a login is an access control.
   (https://www.adobe.com/uk/legal/terms.html 2.3; the redirect measured with `curl -I`)
6. The same terms make a person given an entitlement by an organisation on a business plan a
   Business User, bound by the contract that organisation holds with Adobe, and a person on an
   individual plan a Personal User in sole control of their content. (terms.html 1.3)
7. Adobe's privacy policy (dated 24/10/2025) has Adobe as controller when it supplies an individual
   directly, a purchase on adobe.com for instance, and as processor when enterprise customers use
   its products to serve their own users; outside North America and Japan the controller is Adobe
   Ireland. (https://www.adobe.com/uk/privacy/policy.html)
8. The UK pricing page lists Express Premium at GBP 9.98 a month including VAT, aimed at
   individuals, billed monthly with no annual commitment, with brand kits among its features.
   (https://www.adobe.com/uk/express/pricing, read with `fetch`)
9. Express's Product Specific Terms (updated 07/10/2024) sit under the General Terms, say nothing of
   a DPA or of plan tiers, and make the user alone answerable for personal data gathered from
   visitors to what they publish.
   (https://wwwimages2.adobe.com/content/dam/cc/en/legal/servicetou/Adobe-Express-Product-Specific-Terms-en_US-20241007.pdf
   sections 1-2)
10. Adobe's sub-processor list (dated 28/09/2026) covers only processing where Adobe is processor
    for a controller customer; Adobe Express appears against Elastic (optional content assessment),
    Black Forest Labs (generative fill) and Intercom (in-app support).
    (https://www.adobe.com/privacy/sub-processors.html)
11. The Express API is a beta with four operations: details of one tagged document, a list of tagged
    documents, a generated variation and a rendition export; it lists no import. Access is by
    request form or a Firefly Services administrator's provisioning, for testing and evaluation
    only, with no commercial use of output and no production deployment. Variations fill tagged
    elements from text or pre-signed AWS, Dropbox or Azure URLs and are kept 30 days. The overview
    counts PDF among export formats; the FAQ names only JPG, PNG and MP4.
    (https://developer.adobe.com/firefly-services/docs/express-api/ and its
    `getting-started/support/FAQ/`)
12. The Embed SDK now needs Adobe's business approval, weighed on enterprise Express adoption, a
    paid strategic partnership or a user base of one million or more; unapproved integrations carry
    a red banner, and approved ones run until December 2027. Users sign in with an Adobe ID to save;
    work goes into their own Express account under a folder carrying the integration's name,
    entitlements follow their own subscription, and the systems listed are Windows 10+, macOS 11+
    and ChromeOS. The editor opens a blank canvas, an image asset, a template or an existing
    document. (https://developer.adobe.com/express/embed-sdk/docs/guides/troubleshooting/faq/;
    https://developer.adobe.com/express/embed-sdk/docs/v4/sdk/src/workflows/3p/editor-workflow/classes/editor-workflow)
13. Inside Express, the add-on SDK's `addImage` puts a PSD, AI, SVG, GIF or other image file on the
    current page, while `importPdf` and `importPresentation` (PPTX only) open the file as a new
    Express document; images stop at 8,192 px a side, 80 MB on desktop and 65 million pixels. The
    Document APIs let an add-on create shapes and then size, place and fill them.
    (https://developer.adobe.com/express/add-ons/docs/references/addonsdk/app-document;
    https://developer.adobe.com/express/add-ons/docs/references/document-sandbox/document-apis/)
14. **Inference:** the DPA reaches Express bought under a business plan, not Premium bought by an
    individual; no page read says either.

**Not settled.** The generator's terms (sign-in). Whether a sole trader on Premium who processes
client data may rely on General Terms 2.3. Express for teams and business plans: the pricing page's
business tab did not render. Whether the Embed SDK's image route takes a PDF or PSD: its method text
says image, and a reader leg saw an asset-type list naming both, a page this writer could not
reach again (its reader-reported path now answers 404). The PDF-export disagreement. Whether an unpublished
add-on runs in a Linux browser, which is untested.

### N-029 on MAP-DESIGN-HANDOFF — Lunacy and Miro data terms, for an 'other' row

**Answer.** Miro contracts as a processor on its self-serve plans; Icons8 offers no processor terms
on any page read. Miro's self-serve terms (effective 01/09/2021, California law) bring in a customer
DPA (17/09/2024) that makes the customer controller and Miro processor, counts UK GDPR among its
laws, and carries UK transfers on the EU clauses with the ICO's UK Addendum. Board content is held
in the EU, in Ireland with a German backup, on every plan; other regions are for Enterprise, and
names, avatars, SSO and integration data sit outside residency, while AI work may be processed
elsewhere. On AI improvement Enterprise customers are asked first and other plans only get a way to
object; Miro's help centre says it gathers AI interactions from Free accounts alone, that admins can
stop it, and that no model is trained on them. Special-category data is barred, and free access
counts as an evaluation offering, as-is, with liability capped at USD 50; whether that clause
reaches the Free plan is not stated. Icons8's privacy policy (02/10/2024) cites EU GDPR only, names
no processing country and keeps user data for its own ends, training its neural networks and testing
software on users' graphics among them. The Lunacy EULA, under US law, says nothing about data. What
reaches Icons8 depends on the mode: local files stay on the machine; cloud documents and Publish to
Web uploads sit on Icons8 servers; a Private Cloud runs on the customer's server or on a VPS Icons8
runs in a region the customer picks. Lunacy also documents a local MCP server, which this note's
Lunacy row misses. Against the processors register, by inference: Miro is a third-party
sub-processor, cloud Lunacy is nearest an independent controller with no DPA, and local or
on-premises Lunacy is self-hosted.

1. Miro's terms of service bind every self-serve and reseller customer; an Enterprise customer has
   the Master Cloud Agreement instead. The counterparty is RealtimeBoard Inc. trading as Miro, or an
   affiliate an order names; the terms took effect on 01/09/2021, under California law with courts
   in San Francisco. (https://miro.com/legal/terms-of-service/, opening and governing law)
2. Both sides agree to follow the DPA. Content can be exported during the subscription or for 30
   days after it, then deleted on Miro's schedule. Prohibited Data, which includes GDPR Art. 9(1)
   special categories, HIPAA health data and payment card data, may not go into the service. Access
   given free or on trial is for internal evaluation only, as-is, with Miro's liability capped at
   USD 50. (terms-of-service, the DPA, export, Prohibited Data and Trials and Betas clauses)
3. The customer DPA (effective 17/09/2024) makes the customer controller and Miro processor; its
   data protection law covers the UK GDPR, the UK's 2018 Data Protection Act, the EU GDPR and Swiss
   law.
   (https://miro.com/legal/customer-data-processing-addendum/, definitions, 2.1)
4. For EEA and Swiss transfers to the US the DPA leans on the Data Privacy Framework; where that
   does not apply the SCCs do, and for UK GDPR data the ICO's UK Addendum to them is treated as
   signed by both parties. The privacy policy (effective 01/08/2025) records RealtimeBoard Inc.'s
   certification under the framework's UK Extension. (DPA 8.2, 8.3, 8.3.5;
   https://miro.com/legal/privacy-policy/)
5. Sub-processors are authorised generally from a published PDF list. Ten days' notice of a new one
   reaches only customers who subscribe; an objection has 30 days, and if unresolved the exclusive
   remedy is suspending or ending the order or agreement. (DPA 3.1, 3.3, 3.4)
6. EU residency comes with every plan at no added cost, with Ireland as the main site and the backup
   in Germany; US, Australian and Japanese residency is for Enterprise. Residency covers generally
   available features only; users' names and avatars, SSO and SCIM setup, the organisation name and
   third-party integration data fall outside it; what Miro AI uses or makes stays in the region at
   rest, though it may be processed elsewhere. (Miro help 23084283851026)
7. Miro's AI Terms (effective 17/07/2024) ask a Master Cloud Agreement customer to consent before
   its AI input and output improve features or train models, and give free, starter, business or
   similar plans only a reasonable way to object. Where use goes ahead, Miro takes a perpetual
   licence and removes direct identifiers. (https://miro.com/legal/ai-features-addendum/ section 3)
8. From 03/02/2025 only Free-plan accounts feed their AI interactions into Miro's improvement work,
   and a paid or Education plan's guests and visitors are excluded; an admin can stop it. Miro says
   it neither trains nor fine-tunes models on that data and does not hand it to model vendors for
   their training. Its models run either at Miro or on Microsoft Azure AI, and the company-wide Miro
   AI switch is listed for Enterprise and Education. (Miro help 22874000865554, 11277533556626)
9. Icons8's privacy policy (dated 02/10/2024) calls the company only Icons8, a registered company,
   while the page footer reads Icons8 LLC. Its frame of reference is the GDPR alone: it never
   mentions the UK GDPR, names no processing country or transfer route, and addresses users of the
   website.
   (https://icons8.com/privacy-policy, opening)
10. Its listed uses include training its neural networks for search, classification and prediction,
    testing software with anonymised personal data, and testing software with users' graphics, such
    as reproducing bugs from cloud data. It defines controller and processor but gives Icons8 no
    processor role, and no Icons8 or Lunacy page read offers a DPA or a sub-processor list.
    (privacy-policy, the uses list and definitions)
11. Icons8's site terms (dated 04/10/2024) reach its websites and applications and give a
    Wilmington, Delaware address. The Lunacy EULA is with Icons8 LLC under United States law, has no
    data or privacy clause, and forbids letting outsiders run the software for someone else.
    (https://icons8.com/terms-and-conditions;
    `icons8/lunacy-docs@373c97f:docs/raw/lunacy license.md:4,27,46`)
12. Local documents never leave the user's machine; cloud documents are kept on Icons8 servers. Free
    use allows ten cloud documents, with 30 days of version history and deleted files; the personal
    cloud plan costs USD 4.99 a month. A layer sent with Publish to Web goes to Icons8's servers,
    where Icons8 says it neither reads nor analyses it and guarantees only 60 days of storage.
    (https://lunacy.docs.icons8.com/raw/clouddocs.md; `.../subscriptions.md`;
    `icons8/lunacy-docs@373c97f:docs/raw/export.md:210-235`)
13. Private Cloud is either on-premises, on a server inside the customer's network, which no data
    leaves, or on a VPS that Icons8 engineers set up and maintain in whichever region or legal
    jurisdiction the customer picks; only the VPS keeps the bundled graphics and AI tools. A
    graphics subscription unlocks the AI image upscaler.
    (https://lunacy.docs.icons8.com/raw/private_cloud.md; `.../subscriptions.md`)
14. Lunacy documents a local MCP server, switched on from its AI menu, that gives an assistant the
    selected objects, colour variables, components and images while keeping data on the machine.
    This note's Lunacy row and 'Other and not-offered tools' claim 2 say it shows no API or MCP.
    (`icons8/lunacy-docs@373c97f:docs/raw/mcp.md:14-31,94`; this note, 'The targets at a glance')
15. The processors register has three kinds of entry: third-party sub-processor (DPA required),
    self-hosted infrastructure (no DPA) and independent controller (no DPA, disclosed with a lawful
    basis). Placing Miro in the first, cloud Lunacy in the third and local or on-premises Lunacy in
    the second is an inference from the claims above.
    (`project-management/src/09-GDPR/THIRD-PARTY-PROCESSORS.md:25-29`)

**Not settled.** Miro's sub-processor PDF was not read, so the countries and AI vendors a Miro row
would name are open. Miro's AI Terms (an objection route for paid self-serve plans) and its help
article (collection from Free alone) are not reconciled. That a Free self-serve account is a DPA
customer is inferred from the terms' scope. Whether Icons8 offers a DPA on request, and where its
cloud servers sit, is unanswered; a web search found neither, which proves nothing. Whether the
Icons8 policy covers Lunacy at all (its scope names website users). Which other Lunacy AI tools send
content to Icons8, and whether the desktop app sends telemetry.

### N-030 on MAP-DESIGN-HANDOFF — Photoshop, Illustrator and Stitch re-read against their grounds

**Answer.** Partly. Photoshop and Illustrator still fail on Linux: neither desktop app lists it, and
Photoshop on the web lists Windows, macOS and ChromeOS alone. Illustrator on the web is still a beta
whose requirements link lands on the desktop page, so its Linux position is undocumented rather than
refused. Adobe's connector for Claude, usable from Claude Code, reaches Photoshop and Illustrator
capabilities, but its requirements list macOS, Windows and Chromebook only. Stitch no longer fits
its ground as worded: it still turns out its own HTML, but since 18/03/2026 it also takes design
rules in, as a DESIGN.md file, as a system derived from a URL, or from code, images and design files
given as context, and its MCP has tools to upload a DESIGN.md and apply it. DESIGN.md is Google's
own alpha format, modelled on DTCG, and its CLI exports DTCG but imports nothing. Stitch's terms are
now read: Google's standard Terms of Service and its policy on prohibited uses of generative AI,
with no Stitch terms or privacy notice of its own; UK users contract with Google LLC under English
law. The Out of scope row sends readers to this note's 'Other and not-offered tools' for its
grounds, but that section gives none for these three; they rest on Sam's Q5 decision, and the row
now states them.

1. On MAP-DESIGN-HANDOFF the Out of scope row for Affinity, Photoshop, Illustrator, XD, Sketch,
   Stitch and Uizard stands on Sam's Q5 decision and cites this note's 'Other and not-offered
   tools' for its grounds, leaving these three to N-030 on MAP-DESIGN-HANDOFF; that section's
   not-offered claim covers Affinity, XD, Sketch and Uizard only. The grounds for the three are no
   Linux build of Adobe's desktop or web apps, and Stitch generating only its own HTML under terms
   not then read; the row now states Stitch's ground itself. (`MAP-DESIGN-HANDOFF.md`, 'Out of
   scope', the not-offered row; Sam, this conversation, 15/10/2026 (Q5); this note, 'Other and
   not-offered tools' claim 4)
2. Photoshop's desktop requirements (dated 09/09/2026) have tables for Windows, Windows on ARM and
   macOS only. Photoshop on the web (dated 27/03/2025) lists Windows 10 64-bit or later, macOS 10.15
   or later and ChromeOS 102 or later, with Chrome, Edge 102+, Firefox 111+ and Safari 18.3+ in
   beta. Illustrator's desktop page (dated 09/04/2026) lists Windows 10 and 11 and macOS 13 to 26
   for current releases. None names Linux.
   (https://helpx.adobe.com/photoshop/desktop/get-started/technical-requirements-installation/adobe-photoshop-on-desktop-technical-requirements.html;
   https://helpx.adobe.com/photoshop/web/get-set-up/learn-the-basics/technical-requirements.html;
   https://helpx.adobe.com/illustrator/desktop/get-started/learn-the-basics/technical-requirements.html)
3. Illustrator on the web is labelled Beta. Its access page (dated 01/04/2026) tells users to open
   Chrome or Edge, and the requirements link on its overview page (dated 15/06/2026) redirects to
   the desktop requirements page, which has no web section.
   (https://helpx.adobe.com/illustrator/web/get-set-up/access-the-app/access-illustrator-web.html;
   https://helpx.adobe.com/illustrator/web/get-set-up/learn-the-basics/overview.html; the redirect
   measured with `curl -I`)
4. Adobe's Claude connector page (dated 24/09/2026) links Claude to capabilities from Acrobat,
   Express, Firefly, Illustrator, InDesign, Lightroom, Photoshop, Premiere and Stock; it works from
   Claude's web and desktop apps and from Claude Code, and needs no Adobe account to start.
   Its stated requirements cover browsers on macOS and Windows plus Chromebook. It is not tuned for
   enterprise use, excludes EDU accounts and withholds Express capabilities from enterprise
   accounts. Its documented workflows edit uploaded images, open and render PSD files and start
   designs from an Express template; it describes no Illustrator workflow. Adobe also lists
   connectors for ChatGPT, Google Gemini and Slack.
   (https://helpx.adobe.com/creative-cloud/apps/integration-with-other-apps/adobe-connectors/adobe-for-claude.html;
   https://helpx.adobe.com/creative-cloud/apps/integration-with-other-apps/adobe-connectors/adobe-connector-overview.html)
5. Google's Stitch post of 18/03/2026 says Stitch can derive a design system by reading a URL and
   bring design rules in or out as DESIGN.md; its canvas accepts images, text or code; it has an MCP
   server and SDK and exports to AI Studio and Antigravity. The post of 19/05/2026 adds starting
   from an existing codebase or design files, sharing through AI Studio, export to Antigravity and
   publishing through Netlify, for users everywhere.
   (https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/;
   https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-updates/)
6. The Stitch SDK README says a generated screen yields one download URL for its HTML and another
   for a screenshot, authenticated by `STITCH_API_KEY` or an OAuth token tied to a Google Cloud
   project. Its generated manifest lists 15 tools, among them `upload_design_md`,
   `create_design_system_from_design_md`, `create_design_system`, `update_design_system` and
   `apply_design_system`. (`google-labs-code/stitch-sdk@e3f8ece:README.md:5,9-23,327-330`;
   `packages/sdk/generated/tools-manifest.json`)
7. DESIGN.md is still an alpha format; the tokens in its YAML front matter take their lead from the
   DTCG 2025.10 format. Its CLI offers `lint`, `diff`, `export` (Tailwind v3 JSON, Tailwind v4 CSS,
   DTCG JSON) and `spec`, with no import command, though the spec says its tokens convert both ways
   with `tokens.json` and Figma variables. Google published the draft specification as open source
   on 21/04/2026. (`google-labs-code/design.md@9bf8eae:README.md`, CLI reference and status;
   `docs/spec.md:10-15`;
   https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-design-md/)
8. Google's list of service-specific terms places Stitch under the Terms of Service and the policy
   on prohibited uses of generative AI, with nothing added for Stitch. The UK edition of Google's
   terms, in force from 30/07/2026, names Google LLC, of Delaware and Mountain View, as the
   contracting party, and puts UK residents under English law and the English courts.
   (https://policies.google.com/terms/service-specific?hl=en-GB;
   https://policies.google.com/terms?hl=en-GB&gl=GB)
9. Stitch's own documentation renders by script inside a frame. A reader leg's `make_request` and
   `fetch` both came back empty, as did this writer's `bulk_get`; no challenge was served, so
   `stealthy_fetch` was not tried. (https://stitch.withgoogle.com/docs/mcp/setup)

**Not settled.** Stitch's own documentation (unavailable). Whether Stitch uses prompts, uploads or
outputs for training or human review: Google lists no Stitch privacy notice. Illustrator on the
web's operating-system list. Whether Adobe's Claude connector works from Claude Code on Linux, which
is untested. The ChatGPT, Gemini and Slack connector pages (not read). Whether a DESIGN.md generated
from this repository's tokens imports cleanly, which is untested.

**Measured: nothing quoted.** An earlier count on 15/10/2026 reported 0 shared five-grams and was
wrong: an independent check found three runs it had missed, because its script also deleted
domain-shaped words (Claude.ai, Customer.io), a step its stated method left out, and one saved page
had lost its metadata. Those three were reworded, as were twelve more runs the re-count found, most
of them stock phrases shared with the Claude Code binary's strings or with vendor pages, and two
bare Stitch addresses were written as full URLs; the whole note, body and Addendum together, was
then measured again the same day. **Method.** The note's text had curly apostrophes straightened and
full URLs (from `http` to the next space) removed, and nothing else: domain-shaped words, backticked
spans and citation brackets all stayed in. It was lowercased and broken on every non-alphanumeric
character into word five-grams: 11,914 distinct, 7,873 of them from the Addendum's Sources entry
onwards and the body lines that point to it. The comparison copies were raw pages taken with an
impersonating `curl` and kept whole, each read four ways (visible text; script contents, JSON-LD and
page data included; every attribute value, meta descriptions and titles among them; and the whole
page with tags stripped), plus the earlier `scrapling` copies of the body's pages, the GitHub files
through `gh api`, the Adobe PDFs through `pdftotext` and the strings of the Claude Code binary: 357
text copies, most pages in two or three independent copies. **Result.** No run of prose is shared.
26 five-grams are shared, every one inside or touching a backticked citation locator or identifier:
Canva's URL slugs, FigCraft and Penpot file paths, the `lunacy.docs.icons8.com/raw/` prefix,
`adobe.com/go/tou-dpa`, three GitHub repository names, one SPDX licence expression and one Stitch
tool name, each matching the page or repository it names. With backticked spans removed as well
(11,141 distinct five-grams), **0** are shared. Entity, product and plan names, dates, prices and
section numbers are facts, and were reworded around wherever they formed a run.

---

## Feeds

`MAP-DESIGN-HANDOFF` — **new**, written alongside this note in one change (15/10/2026), and distinct
from the existing `MAP-CLAUDE-DESIGN-HANDOFF`, which retires into it. It takes the per-tool facts,
the kit-floor table and the Copier facts. No ADR or `STORY-PLAN-US###` exists yet; each links back
here by path when it does.

`MAP-CLAUDE-DESIGN-HANDOFF` (fully charted 01/09/2026) — a pointer only; the map is not amended in
this change. Its Destination has the client-signoff half made in Claude Design through `/design`.
Claude Design claims 1 (the standalone site closes on 14/12/2026), 5 (`/design` import and export
wait on a server flag that defaults to off) and 6 (this repository sets `disableBundledSkills`
and `disableArtifact`) bear on that premise.

**N-025 to N-030 on MAP-DESIGN-HANDOFF** (the CHART Step 7 research nodes, resolved 15/10/2026) —
the Addendum, one section each, which each node's Became cell names. What the Addendum could not
settle by lookup is carried by three open nodes: **N-021 on MAP-DESIGN-HANDOFF** (per-tool guide
data floor) takes Figma's MCP writes against its AI terms, Penpot's EEA-scoped DPA and region plan,
Claude Design's inferred coverage, Express Premium and Icons8 (the sections on N-025 to N-029 on
MAP-DESIGN-HANDOFF); **N-022 on MAP-DESIGN-HANDOFF** (Claude Design route) takes which retention
article governs at the 14/12/2026 closure (the section on N-027 on MAP-DESIGN-HANDOFF); **N-034 on
MAP-DESIGN-HANDOFF** (Penpot to Figma round trip) takes the Starter DTCG import test (the section on
N-025 on MAP-DESIGN-HANDOFF, items 10 to 12). The map's not-offered Out of scope row cites the
section on N-030 on MAP-DESIGN-HANDOFF.

**N-010 on MAP-NATIVE-DESIGN-TIER** (single token source) — the DTCG profile facts and the
repository's token model; **N-014 on MAP-NATIVE-DESIGN-TIER** (one PDF engine) — the host's PDF
facts.

`research/ARTCRAFT-APPS-DESIGN-TIER.md:238` — its candidate of FigCraft as the lesser tier when
Claude Design is unavailable rests on Claude Design being the single hand-off destination. The
Claude Design and FigCraft claims here update that premise. That note is not amended.
