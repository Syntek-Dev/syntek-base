# References — project-management layer

**Last Updated**: <%DATE%>

Internal and external references for PM, stories, sprints, GDPR, security, SEO, and QA.

---

## Internal — Guides

Every file in `project-management/docs/`, with path and purpose.

| File                                           | Purpose                                                                                                                              |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `project-management/docs/GDPR-GUIDE.md`        | GDPR compliance framework — lawful basis, retention schedule, and DSAR procedures                                                    |
| `project-management/docs/GIT-GUIDE.md`         | Branch strategy, commit format (Conventional Commits), PR flow, and PR gates                                                         |
| `project-management/docs/QA-GUIDE.md`          | QA approach — test scenario format, edge case categories, and story feedback rules                                                   |
| `project-management/docs/RESPONSIVE-DESIGN.md` | **Redirect stub, no content** — the authoritative guide is `code/docs/RESPONSIVE-DESIGN.md`                                          |
| `project-management/docs/SECURITY-GUIDE.md`    | STRIDE threat modelling, OWASP mapping, severity levels, and documentation format                                                    |
| `project-management/docs/SEO-CHECKLIST.md`     | **What must be true per page** before a story closes — the method side is `code/docs/DISCOVERABILITY.md`; neither restates the other |
| `project-management/docs/PLANNING-GUIDE.md`    | MoSCoW prioritisation rules, sprint record format, and phase breakdown schema                                                        |
| `project-management/docs/VERSIONING-GUIDE.md`  | Two-tier semver, independent sub-package tracks, and the files each bump touches                                                     |

---

## Internal — Live Artefacts

Each numbered directory in `project-management/src/`, in its tier, and what it holds.
Folders **04–08** are three-stage — `USER-STORY-IDEAS/` → `CONSOLIDATED-IDEAS/` →
`IMPLEMENTATION/` — because per-story design fragments and must be reconciled by workflow `18`.
Folders **09–13** are two-stage (`PLANNING/` + `IMPLEMENTATION/`): a lawful basis or an API
contract is genuinely per story and needs no consolidation. `10-SECURITY` nests that pair
under each of its four category folders rather than at its root.

| Path                   | Tier          | Contents                                                                                                                  |
| ---------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `src/00-ASSETS/`       | reference     | Logo SVGs, raster exports, and asset pipeline scripts                                                                     |
| `src/01-FEATURE-MAPS/` | discover      | Wayfinder decision maps (`MAP-<FEATURE>.md`) — charted once per feature                                                   |
| `src/02-STORIES/`      | specify       | User stories (`US###.md`); template `US000-TEMPLATE.md`                                                                   |
| `src/03-SPRINTS/`      | specify       | High-level sprint records (`SPRINT-##.md`) — backlog → sprint organisation                                                |
| `src/04-DATABASE/`     | specify       | **3 stages** (IDEAS → CONSOLIDATED → IMPL) + `ERD-DIAGRAMS/`; schema, PII, RLS, migration notes                           |
| `src/05-USER-FLOW/`    | specify       | **3 stages**; per-story fragments stitched into whole journeys + rendered `DIAGRAMS/`                                     |
| `src/06-BRAND-GUIDE/`  | specify       | **3 stages** of token records + `guide-build/` (Python → LaTeX → PDF, regenerated at consolidation)                       |
| `src/07-COMPONENTS/`   | specify       | **3 stages** of component records + `component-build/` (Python → LaTeX → PDF, regenerated at consolidation)               |
| `src/08-WIREFRAMES/`   | specify       | **3 stages** of self-contained HTML wireframes + `SHARED/wireframe.css`                                                   |
| `src/09-GDPR/`         | specify       | Six GDPR register skeletons; per-story `PLANNING/` + `IMPLEMENTATION/`                                                    |
| `src/10-SECURITY/`     | specify       | Four categories (THREAT-MODEL, ASSESSMENTS, AUDITS, VULNERABILITIES), each per-story `PLANNING/` + `IMPLEMENTATION/`      |
| `src/11-QA/`           | specify       | Per-story QA plans (`PLANNING/`) and reviews (`IMPLEMENTATION/`)                                                          |
| `src/12-SEO/`          | specify       | Per-story SEO plans (`PLANNING/`) and records (`IMPLEMENTATION/`)                                                         |
| `src/13-API-DESIGN/`   | specify       | Per-story Django Ninja API design (`PLANNING/`) and verification (`IMPLEMENTATION/`)                                      |
| `src/14-LOGGING/`      | specify       | Per-story log surface (`PLANNING/`) and what shipped with its leak evidence (`IMPLEMENTATION/`)                           |
| `src/15-DECISIONS/`    | decide & plan | Architectural Decision Records (`ADR-###-<TITLE>.md`)                                                                     |
| `src/16-SPRINT-PLANS/` | decide & plan | Detailed sprint execution plans (`##-SPRINT-PLAN-##.md`)                                                                  |
| `src/17-STORY-PLANS/`  | decide & plan | Per-story implementation plans (`STORY-PLAN-US###-*.md`) — the master reference for code                                  |
| `src/18-TESTS/`        | record        | Automated test status (`US###-TEST-STATUS.md`) and manual QA guides                                                       |
| `src/19-REVIEWS/`      | record        | Code review records (`REVIEW-US###-*.md`) per completed story                                                             |
| `src/20-FINDINGS/`     | record        | Per-story findings (`FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`) — divergences, retrofit cost, what the next story carries |
| `src/21-BUGS/`         | record        | Bug reports (`BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`) — story-anchored                                                     |
| `src/22-REFACTORING/`  | record        | Refactoring records (`REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`)                                                      |
| `src/23-INCIDENTS/`    | record        | The **PII-free** incident register (`INCIDENT-<DESCRIPTOR>-DD-MM-YYYY.md` + `INCIDENT-INDEX.md`) — not story-anchored     |

The three tiers: **specify** (02–14) → **decide & plan** (15–17) → **record** (18–22), with
**23-INCIDENTS** a record that sits outside the per-story chain entirely.
The story plan (17) is the master a developer codes from; it references its sprint plan
(16), the decisions (15), and every 02–14 spec.

---

## Internal — Workflows

Each workflow `CONTEXT.md` with path and purpose.

| Workflow path                                          | Purpose                                                             |
| ------------------------------------------------------ | ------------------------------------------------------------------- |
| `workflows/01-feature-map/CONTEXT.md`                  | Chart a feature's decision frontier with wayfinder, then resolve it |
| `workflows/02-story-creation/CONTEXT.md`               | Write a well-formed user story with acceptance criteria             |
| `workflows/03-sprint-planning/CONTEXT.md`              | Organise stories into a balanced sprint using MoSCoW                |
| `workflows/04-database-schema/CONTEXT.md`              | Design and sign off a database schema before any coding begins      |
| `workflows/05-user-flow-design/CONTEXT.md`             | Map user journeys and data touchpoints before wireframing           |
| `workflows/06-brand-guides/CONTEXT.md`                 | Define and document the visual brand identity and token system      |
| `workflows/07-component-designs/CONTEXT.md`            | Design reusable UI components before frontend implementation        |
| `workflows/08-wireframes/CONTEXT.md`                   | Create and sign off wireframes before frontend work begins          |
| `workflows/09-gdpr-compliance/CONTEXT.md`              | Review a feature for GDPR compliance                                |
| `workflows/10-security-checks/CONTEXT.md`              | STRIDE threat modelling and security review of designs              |
| `workflows/11-qa-checks/CONTEXT.md`                    | QA planning from wireframes — test scenarios before any code        |
| `workflows/12-seo-checks/CONTEXT.md`                   | Verify SEO on all public-facing pages before story closes           |
| `workflows/13-api-design/CONTEXT.md`                   | Design the Django Ninja API contract before sprint planning         |
| `workflows/14-logging-checks/CONTEXT.md`               | Set the story's log surface and its exclusion list before code      |
| `workflows/15-decisions/CONTEXT.md`                    | Author an Architectural Decision Record (ADR)                       |
| `workflows/16-sprint-plans/CONTEXT.md`                 | Write detailed sprint plans after GDPR, security, and QA checks     |
| `workflows/17-story-plans/CONTEXT.md`                  | Write the per-story implementation plan — the code master           |
| `workflows/18-consolidate-design-work/CONTEXT.md`      | Unify the per-story design and schema work into one system          |
| `workflows/19-backend-code/CONTEXT.md`                 | Implement Django models, services, and business logic (TDD)         |
| `workflows/20-api-code/CONTEXT.md`                     | Implement the Django Ninja API layer                                |
| `workflows/21-frontend-code/CONTEXT.md`                | Implement Django templates + django-components (HTMX/Alpine)        |
| `workflows/22-implementation-documentation/CONTEXT.md` | Update docs + write IMPLEMENTATION records after code               |
| `workflows/23-pr-and-review/CONTEXT.md`                | Create, review, and merge a feature PR through the branch chain     |
| `workflows/24-release/CONTEXT.md`                      | Cut a release — version bump, changelog, and deployment             |

> Workflow numbers mirror the `src/` tier numbers through the decide-&-plan tier (02–17);
> they then diverge — workflow 18 is the design-consolidation gate, 19–21 are the
> implementation phases, and 22–24 the documentation, PR, and release steps. None of
> 18–24 has a `src/` artefact folder of its own: `18` writes into the `CONSOLIDATED-IDEAS/`
> folders of `src/04`–`src/08`, and the record folders `src/18`–`src/22` are numbered
> independently of any workflow.

---

## External — Agile & Project Management

- **User Story format (Connextra)** — https://www.agilealliance.org/glossary/user-stories/ — "As a [role], I want [goal], so that [benefit]" format used by all US###.md files
- **MoSCoW prioritisation** — https://www.agilebusiness.org/dsdm-project-framework/moscow-prioririsation.html — Must / Should / Could / Won't framework applied in sprint planning
- **Definition of Done** — https://www.agilealliance.org/glossary/definition-of-done/ — DoD criteria applied per story in sprint plan documents
- **Story point estimation (Fibonacci)** — https://www.mountaingoatsoftware.com/blog/what-are-story-points — relative sizing used in sprint plan story tables

---

## External — Compliance & Legal

- **UK GDPR (ICO)** — https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/ — primary compliance framework for all personal data handling
- **UK GDPR legislation** — https://www.legislation.gov.uk/eur/2016/679/contents — full text of the retained EU GDPR as amended for the UK
- **PECR (ICO)** — https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guide-to-pecr/ — cookie consent and electronic marketing rules
- **ICO cookie guidance** — https://ico.org.uk/for-organisations/direct-marketing-and-privacy-and-electronic-communications/guide-to-pecr/guidance-on-the-use-of-cookies-and-similar-technologies/ — detailed cookie-consent rules
- **WCAG 2.2** — https://www.w3.org/TR/WCAG22/ — AA compliance required on all interactive frontend components
- **OWASP Top 10 (2025)** — https://owasp.org/www-project-top-ten/ — vulnerability categories mapped in all security assessments and audits. The mapping table is in `docs/SECURITY-GUIDE.md`; cite a category with its year (`A05:2025`), because 2021 and 2025 number differently
- **NIST Cybersecurity Framework 2.0** — https://www.nist.gov/cyberframework — risk management functions (Govern, Identify, Protect, Detect, Respond, Recover) applied in workflow 09
- **STRIDE threat modelling** — https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats — threat classification used in `docs/SECURITY-GUIDE.md`
- **ISO/IEC 27001:2022** — https://www.iso.org/standard/82875.html — information security management standard referenced in security assessments

---

## External — SEO & Discoverability

- **Google Search Central** — https://developers.google.com/search/docs — canonical SEO guidance for crawling, indexing, and structured data
- **Schema.org** — https://schema.org/ — vocabulary for JSON-LD structured data (Organization, Article, BreadcrumbList, etc.)
- **Google Lighthouse** — https://developer.chrome.com/docs/lighthouse/overview/ — authoritative tool for Core Web Vitals; results recorded per story
- **Core Web Vitals** — https://web.dev/articles/vitals — LCP < 2.5 s, CLS < 0.1, INP < 200 ms targets applied across all public pages
- **llms.txt specification** — https://llmstxt.org/ — an index for agents that read rather than crawl. **Not a search or citation signal**; see `code/docs/discoverability/ROOT-SURFACE.md` Section 1
- **Google — AI features and your website** — https://developers.google.com/search/docs/appearance/ai-features — the primary source stating that AI Overviews and AI Mode need no additional optimisation, no new machine-readable files, and no special schema
- **Per-page metadata** — rendered server-side via Django templates and the `build_seo()` head pipeline, **which will set** title, description, Open Graph and canonical tags on all public pages once it is wired (`code/docs/discoverability/WEB-METADATA.md`)
- **Open Graph protocol** — https://ogp.me/ — metadata standard for social sharing previews

---

## External — Version Control & CI

- **Conventional Commits 1.0** — https://www.conventionalcommits.org/en/v1.0.0/ — commit message format enforced by `docs/GIT-GUIDE.md`
- **Semantic Versioning 2.0** — https://semver.org/ — single-track semver applied by `docs/VERSIONING-GUIDE.md`
- **GitHub Actions** — https://docs.github.com/en/actions — CI/CD platform used for lint, test, and deploy pipelines
- **GitHub flow** — https://docs.github.com/en/get-started/using-github/github-flow — branch-per-feature model adapted in `docs/GIT-GUIDE.md`
