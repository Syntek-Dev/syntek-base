# Discoverability — the SEO and ASO skill ecosystem

**Written**: 04/08/2026 · **Licences verified**: 09/08/2026 (N-009)
**Method**: web search + repository inspection + GitHub REST licence-file reads · **For**: `MAP-DISCOVERABILITY`
**Feeds**: `MAP-DISCOVERABILITY` N-001 (ecosystem), N-009 (licences), N-010 (attribution)

The discipline `AGENT-SKILL-ECOSYSTEM.md` did not sweep. Same method as that note — survey what
exists, record what each source covers and on what licence terms, then name the holes.

> **Template-development artefact.** `research/` is **not** copier-excluded, so this note ships
> into generated projects until it is pruned. Same open question as the other two notes.

---

## Why this note exists

`research/AGENT-SKILL-ECOSYSTEM.md` swept seventeen disciplines and concluded the template was
short in three places. **SEO appears zero times in that note**, and neither does
"discoverability". It was not scoped out — it was never in the sweep, and the N-020 verdict on
`MAP-DOCTRINE-UPGRADE.md` reads as exhaustive without saying so.

Verified 04/08/2026 by grep across the note and the map.

---

## What the repository has today

| Surface                     | Covered by                                                                                 | Verdict                      |
| --------------------------- | ------------------------------------------------------------------------------------------ | ---------------------------- |
| **Web — specification**     | `project-management/docs/SEO-CHECKLIST.md` · workflow `12-seo-checks` · `src/12-SEO/`      | Real and reasonably complete |
| **Web — implementation**    | `.claude/agents/seo.md` — `build_seo`, JSON-LD, canonical, robots/sitemap/`llms.txt` views | Real                         |
| **Web — build-side guide**  | _nothing in `code/docs/`_                                                                  | **Hole**                     |
| **Mobile — store listing**  | _nothing_                                                                                  | **Hole**                     |
| **Desktop — store listing** | _nothing_                                                                                  | **Hole**                     |

**The web hole has the same signature the N-020 sweep was built to detect** — specified on one
side, silent on the build side. The difference is the seam: N-020's three holes were
`how-to/` ↔ `code/docs/` (operate ↔ build); this one is `project-management/docs/` ↔ `code/docs/`
(specify ↔ build). The `seo` agent carries the implementation knowledge in its own prompt, which
is where it goes stale unread.

**The `seo` agent is explicitly web-only** — its description scopes it to "the Django-templated
frontend" and "the public marketing pages". Nothing routes app-store metadata anywhere.

**App-store versioning is handled; app-store discoverability is not.** The only app-store
reference repository-wide is `RELEASES.md` on version monotonicity. `code/src/mobile/app.json`
holds `name`, `slug` and `icon` — genuine store-listing inputs — documented nowhere as a
discoverability surface.

---

## The ecosystem — what exists

### SEO

| Source                                                                              | Covers                                                                                                                                  | Licence                        | Vendor tie                                                                    |
| ----------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ | ----------------------------------------------------------------------------- |
| [`AgriciDaniel/claude-seo`](https://github.com/AgriciDaniel/claude-seo)             | 25 sub-skills / 18 sub-agents: technical SEO, E-E-A-T, Schema.org, **GEO/AEO**, local, e-commerce, international, hreflang, Google APIs | **MIT** — verified, clean text | Optional only (DataForSEO, Ahrefs, SE Ranking, Profound — bring your own key) |
| [`kpab/seo-mastery-agent-skills`](https://github.com/kpab/seo-mastery-agent-skills) | Technical SEO, structured data, Core Web Vitals, E-E-A-T, site audits, against Google's own docs                                        | **MIT** — verified, clean text | **None** — self-contained                                                     |
| [`seranking/seo-skills`](https://github.com/seranking/seo-skills)                   | Content briefs, AI-search share of voice, audits, backlink gaps, keyword clusters, schema, sitemap, GEO                                 | **MIT** — verified, clean text | **Hard** — built for the SE Ranking MCP server                                |

### ASO

| Source                                                                                | Covers                                                                                                                                            | Licence                         | Vendor tie                         |
| ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- | ---------------------------------- |
| [`furkancingoz/aso-skill`](https://github.com/furkancingoz/aso-skill)                 | Metadata + character validation, competitor analysis via iTunes API, App Store Connect submission, screenshots, reviews, phased releases          | **MIT** — verified, **derived** | Optional only (Gemini, RevenueCat) |
| [`TimBroddin/app-store-aso-skill`](https://github.com/TimBroddin/app-store-aso-skill) | Name, subtitle, promotional text, description, keywords, what's-new — validated against Apple's character limits; screenshot caption OCR indexing | **MIT** — verified, clean text  | None apparent                      |
| [`Eronred/aso-skills`](https://github.com/Eronred/aso-skills)                         | Keyword research, metadata optimisation, competitor analysis, growth — scoring rubrics and output templates                                       | **MIT** — verified, clean text  | None apparent                      |
| [`appalize/aso-skills`](https://github.com/appalize/aso-skills)                       | 30 skills for keyword research, metadata, competitor analysis, growth                                                                             | **MIT** — verified, clean text  | **Hard** — "powered by Appalize"   |

### Desktop — the one defective grant

| Source                                                                      | Covers                                                        | Licence                                     | Vendor tie |
| --------------------------------------------------------------------------- | ------------------------------------------------------------- | ------------------------------------------- | ---------- |
| [`fayazara/macos-app-skills`](https://github.com/fayazara/macos-app-skills) | macOS build-and-ship patterns; **no listing discoverability** | **Incomplete** — README says "MIT", no file | None       |

---

## Claims

### 1. Two of the three holes have a mature ecosystem; the third has none

Web SEO and Apple/Google ASO are both well served, several sources are MIT, and the concerns are
stable and well documented. **Desktop store listings are not.** A search for Mac App Store and
Microsoft Store listing-optimisation skills returns only Microsoft's own
[Store search-optimisation documentation](https://developer.microsoft.com/en-us/microsoft-store/search-optimization)
and general macOS build-and-ship skills
([`fayazara/macos-app-skills`](https://github.com/fayazara/macos-app-skills), which carries **no
licence file** — see §5) — nothing on listing discoverability. If the desktop surface needs this,
it is authored from primary sources, not derived from an existing skill. Licence terms make that
the only option here anyway.

### 2. GEO / AEO is the genuinely new dimension, and the repository has one leg of it already

Every serious SEO source now covers **GEO** (Generative Engine Optimisation) / **AEO** (Answer
Engine Optimisation) — being found and cited by AI answer engines rather than only ranked by
crawlers. The template already ships `llms.txt` (`SEO-CHECKLIST.md` cites the
[llmstxt.org](https://llmstxt.org/) specification), which is one leg of it. The rest —
answer-shaped content structure, citation-worthiness, entity clarity — is uncovered.

### 3. Vendor tie is the sharpest filter, and N-026 already gives us the test

Two of the seven sources are **marketing surfaces for a paid product** — `seranking/seo-skills`
is built for the SE Ranking MCP server; `appalize/aso-skills` is "powered by Appalize". Under
`code/docs/architecture/PROVIDER-NEUTRALITY.md` these are the failure the rule exists to prevent:
a product presented as though it were the standard. **The concerns they document are still valid
input**; their tooling assumptions are not adoptable.

The neutral spine to write against, per that rule: Google Search Central and Schema.org for web;
Apple's App Store Connect and Google Play's own metadata limits for mobile. Those are the
interfaces. A keyword-research SaaS is a provider behind them.

### 4. Adoption terms — already settled, and this note does not reopen them

`MAP-DOCTRINE-UPGRADE.md` N-001 and its Out-of-scope table already govern this:

| Action                                                              | Position                                                                        |
| ------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Install and run these skills in a developer's own environment       | Fine — use, not redistribution                                                  |
| Adapt their skill text into `.claude/skills/`                       | **No** — every permissive licence propagates attribution through Copier (N-001) |
| Use their skill list as a **checklist of concerns**, author our own | **Fine** — facts and method are not copyrightable                               |
| Vendor via `npx skills add …`                                       | **No** — `.claude/skills/CLAUDE.md` requires internalised skills                |

**Every source actually adopted as a checklist is credited** in the root `README.md` **and**
`.copier/README.md`, so the credit ships into generated projects rather than stopping at the
template (N-018). Keeping that list true as rules are derived is N-019, still open.

No CC-BY-SA source was found in this sweep — the share-alike trap that N-033 exists for did not
recur here.

### 5. Every licence is now verified, and licence excludes nothing (N-009)

Verified 09/08/2026 against each repository's own licence file via the GitHub REST API
(`repos/{owner}/{repo}/license`), reading the decoded file rather than trusting the SPDX
detector. **Seven of eight are MIT. None is share-alike. No source is excluded on licence
grounds** — the two vendor-tied sources stay out on `PROVIDER-NEUTRALITY.md` grounds alone, which
is a design rule, not a legal one.

Four corrections to the 04/08/2026 sweep, all of which the map's N-001 verdict repeats:

| #   | The sweep said                                    | Verified                                                                                                                         |
| --- | ------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `fayazara/macos-app-skills` counted among the MIT | **No licence file anywhere in the tree.** A bare `## License / MIT` heading in the README, no copyright holder, no licence text  |
| 2   | "three licences unchecked"                        | **Four** were unchecked — `seranking`, `TimBroddin`, `Eronred`, `appalize`. All four are MIT                                     |
| 3   | `furkancingoz/aso-skill` is MIT                   | Correct, but it is a **derivative** of three upstream repos, credited in its own licence file — the lineage is a credit question |
| 4   | Owner spelled `AgricIDaniel`                      | Canonical spelling is `AgriciDaniel` (lowercase `i`); GitHub redirects, so the link worked and hid it                            |

**On correction 1 — a README heading is not a grant.** MIT is a text whose own terms require that
"the above copyright notice and this permission notice" be reproduced downstream. A repository
with neither cannot supply what its stated licence obligates a redistributor to pass on. Nothing
here depends on it: `fayazara` covers macOS _build_, not listing discoverability, and desktop
store listings are already out of scope. **Treat it as unlicensed** — usable as a private
reference, never citable as an adopted source — unless a maintainer adds the file.

**On correction 3 — `furkancingoz` is a merge, not an origin.** Its licence file credits
[`alirezarezvani/claude-code-aso-skill`](https://github.com/alirezarezvani/claude-code-aso-skill)
(MIT, verified — appended third-party notices defeat the SPDX detector, same as `furkancingoz`
itself), [`Mehrozsheikh/aso-appstore-listing-skill`](https://github.com/Mehrozsheikh/aso-appstore-listing-skill)
(MIT) and [`adamlyttleapps/claude-skill-aso-appstore-screenshots`](https://github.com/adamlyttleapps/claude-skill-aso-appstore-screenshots)
(MIT). Under the derive-never-port rule this changes no permission — we take concerns, not text.
It changes **N-010**: crediting `furkancingoz` alone credits a merge point for concerns that
originate three repos upstream. Whether to credit the lineage or the merge point is N-010's call,
not this note's.

**Method note.** The SPDX detector returned `NOASSERTION` for two repositories that are plainly
MIT, in both cases because extra sections are appended below the licence text. **Detector output
is a lead, not a finding** — any future licence check reads the file.

---

## What this does not answer

- Whether web SEO's missing build-side guide is worth writing, or whether the `seo` agent plus
  `SEO-CHECKLIST.md` is genuinely sufficient. The layer-seam argument says write it; the
  do-not-duplicate rule says be careful what goes in it.
- Whether ASO belongs in this template at all, given both app surfaces are optional. A web-only
  project would carry doctrine for a surface it does not have — the same gating problem
  `stack-react-native` and `stack-slint` already solve, applied to a PM-side artefact.
- Who owns store-listing copy. It is marketing-register copy under `how-to/src/BRAND-VOICE.md`,
  but no agent has the remit, and `seo` is scoped web-only.
- Whether GEO/AEO is one concern with SEO or a separate one that will diverge.

---

## Sources

All licences verified 09/08/2026 by reading each repository's licence file via the GitHub REST
API. "Detector" notes where GitHub's SPDX classifier disagrees with the file.

- [`AgriciDaniel/claude-seo`](https://github.com/AgriciDaniel/claude-seo) — MIT
- [`kpab/seo-mastery-agent-skills`](https://github.com/kpab/seo-mastery-agent-skills) — MIT
- [`seranking/seo-skills`](https://github.com/seranking/seo-skills) — MIT, vendor-tied
- [`furkancingoz/aso-skill`](https://github.com/furkancingoz/aso-skill) — MIT (detector: `NOASSERTION`; derived from the three below)
- [`alirezarezvani/claude-code-aso-skill`](https://github.com/alirezarezvani/claude-code-aso-skill) — MIT (detector: `NOASSERTION`) — lineage of `furkancingoz`
- [`Mehrozsheikh/aso-appstore-listing-skill`](https://github.com/Mehrozsheikh/aso-appstore-listing-skill) — MIT — lineage of `furkancingoz`
- [`adamlyttleapps/claude-skill-aso-appstore-screenshots`](https://github.com/adamlyttleapps/claude-skill-aso-appstore-screenshots) — MIT — lineage of `furkancingoz`
- [`TimBroddin/app-store-aso-skill`](https://github.com/TimBroddin/app-store-aso-skill) — MIT
- [`Eronred/aso-skills`](https://github.com/Eronred/aso-skills) — MIT
- [`appalize/aso-skills`](https://github.com/appalize/aso-skills) — MIT, vendor-tied
- [`fayazara/macos-app-skills`](https://github.com/fayazara/macos-app-skills) — **no licence file**; README states "MIT"
- [Microsoft Store search optimisation](https://developer.microsoft.com/en-us/microsoft-store/search-optimization)
- [llms.txt specification](https://llmstxt.org/)
