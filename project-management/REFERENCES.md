# References — project-management layer

**Last Updated**: <%DATE%>

Internal and external references for PM, stories, sprints, GDPR, security, SEO, and QA.

---

## Internal — Guides

Every file in `project-management/docs/`, with path and purpose.

| File                                               | Purpose                                                                            |
| -------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `project-management/docs/GDPR-GUIDE.md`            | GDPR compliance framework — lawful basis, retention schedule, and DSAR procedures  |
| `project-management/docs/GIT-GUIDE.md`             | Branch strategy, commit format (Conventional Commits), PR flow, and PR gates       |
| `project-management/docs/QA-GUIDE.md`              | QA approach — test scenario format, edge case categories, and story feedback rules |
| `project-management/docs/RESPONSIVE-DESIGN.md`     | Breakpoints, container queries, mobile-first design principles, and device data    |
| `project-management/docs/SECURITY-GUIDE.md`        | STRIDE threat modelling, OWASP mapping, severity levels, and documentation format  |
| `project-management/docs/SEO-CHECKLIST.md`         | SEO and AI discoverability checklist for all public-facing pages                   |
| `project-management/docs/SPRINT-PLANNING-GUIDE.md` | MoSCoW prioritisation rules, sprint record format, and phase breakdown schema      |
| `project-management/docs/VERSIONING-GUIDE.md`      | Two-tier semver, independent sub-package tracks, and the files each bump touches   |

---

## Internal — Live Artefacts

Each numbered directory in `project-management/src/`, in its tier, and what it holds.
Folders 08–15 tie their artefacts to a user story via per-story `PLANNING/` +
`IMPLEMENTATION/` templates.

| Path                   | Tier          | Contents                                                                                                                  |
| ---------------------- | ------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `src/00-ASSETS/`       | reference     | Logo SVGs, raster exports, and asset pipeline scripts                                                                     |
| `src/01-STORIES/`      | specify       | User stories (`US###.md`); template `US000-TEMPLATE.md`                                                                   |
| `src/02-SPRINTS/`      | specify       | High-level sprint records (`SPRINT-##.md`) — backlog → sprint organisation                                                |
| `src/03-DATABASE/`     | specify       | Schema docs, ERD diagrams, encryption audit, and RLS migration notes                                                      |
| `src/04-USER-FLOW/`    | specify       | User journey maps (`USER-FLOW-<AREA>.md`) + rendered `DIAGRAMS/`                                                          |
| `src/05-BRAND-GUIDE/`  | specify       | Brand guide generated Python → LaTeX → PDF (`guide-build/`)                                                               |
| `src/06-COMPONENTS/`   | specify       | Indicative component sheet generated Python → LaTeX → PDF (`component-build/`)                                            |
| `src/07-WIREFRAMES/`   | specify       | Self-contained HTML wireframes (`SCREENS/` + `SHARED/wireframe.css`)                                                      |
| `src/08-GDPR/`         | specify       | Six GDPR register skeletons; per-story `PLANNING/` + `IMPLEMENTATION/`                                                    |
| `src/09-SECURITY/`     | specify       | Four categories (THREAT-MODEL, ASSESSMENTS, AUDITS, VULNERABILITIES), each per-story `PLANNING/` + `IMPLEMENTATION/`      |
| `src/10-QA/`           | specify       | Per-story QA plans (`PLANNING/`) and reviews (`IMPLEMENTATION/`)                                                          |
| `src/11-SEO/`          | specify       | Per-story SEO plans (`PLANNING/`) and records (`IMPLEMENTATION/`)                                                         |
| `src/12-API-DESIGN/`   | specify       | Per-story Django Ninja API design (`PLANNING/`) and verification (`IMPLEMENTATION/`)                                      |
| `src/13-DECISIONS/`    | decide & plan | Architectural Decision Records (`ADR-###-<TITLE>.md`)                                                                     |
| `src/14-SPRINT-PLANS/` | decide & plan | Detailed sprint execution plans (`##-SPRINT-PLAN-##.md`)                                                                  |
| `src/15-STORY-PLANS/`  | decide & plan | Per-story implementation plans (`STORY-PLAN-US###-*.md`) — the master reference for code                                  |
| `src/16-TESTS/`        | record        | Automated test status (`US###-TEST-STATUS.md`) and manual QA guides                                                       |
| `src/17-REVIEWS/`      | record        | Code review records (`REVIEW-US###-*.md`) per completed story                                                             |
| `src/18-FINDINGS/`     | record        | Per-story findings (`FINDING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`) — divergences, retrofit cost, what the next story carries |
| `src/19-BUGS/`         | record        | Bug reports (`BUG-US###-<DESCRIPTOR>-DD-MM-YYYY.md`) — story-anchored                                                     |
| `src/20-REFACTORING/`  | record        | Refactoring records (`REFACTORING-US###-<DESCRIPTOR>-DD-MM-YYYY.md`)                                                      |

The three tiers: **specify** (01–12) → **decide & plan** (13–15) → **record** (16–20).
The story plan (15) is the master a developer codes from; it references its sprint plan
(14), the decisions (13), and every 01–12 spec.

---

## Internal — Workflows

Each workflow `CONTEXT.md` with path and purpose.

| Workflow path                                          | Purpose                                                         |
| ------------------------------------------------------ | --------------------------------------------------------------- |
| `workflows/01-story-creation/CONTEXT.md`               | Write a well-formed user story with acceptance criteria         |
| `workflows/02-sprint-planning/CONTEXT.md`              | Organise stories into a balanced sprint using MoSCoW            |
| `workflows/03-database-schema/CONTEXT.md`              | Design and sign off a database schema before any coding begins  |
| `workflows/04-user-flow-design/CONTEXT.md`             | Map user journeys and data touchpoints before wireframing       |
| `workflows/05-brand-guides/CONTEXT.md`                 | Define and document the visual brand identity and token system  |
| `workflows/06-component-designs/CONTEXT.md`            | Design reusable UI components before frontend implementation    |
| `workflows/07-wireframes/CONTEXT.md`                   | Create and sign off wireframes before frontend work begins      |
| `workflows/08-gdpr-compliance/CONTEXT.md`              | Review a feature for GDPR compliance                            |
| `workflows/09-security-checks/CONTEXT.md`              | STRIDE threat modelling and security review of designs          |
| `workflows/10-qa-checks/CONTEXT.md`                    | QA planning from wireframes — test scenarios before any code    |
| `workflows/11-seo-checks/CONTEXT.md`                   | Verify SEO on all public-facing pages before story closes       |
| `workflows/12-api-design/CONTEXT.md`                   | Design the Django Ninja API contract before sprint planning     |
| `workflows/13-decisions/CONTEXT.md`                    | Author an Architectural Decision Record (ADR)                   |
| `workflows/14-sprint-plans/CONTEXT.md`                 | Write detailed sprint plans after GDPR, security, and QA checks |
| `workflows/15-story-plans/CONTEXT.md`                  | Write the per-story implementation plan — the code master       |
| `workflows/16-backend-code/CONTEXT.md`                 | Implement Django models, services, and business logic (TDD)     |
| `workflows/17-api-code/CONTEXT.md`                     | Implement the Django Ninja API layer                            |
| `workflows/18-frontend-code/CONTEXT.md`                | Implement Django templates + django-components (HTMX/Alpine)    |
| `workflows/19-implementation-documentation/CONTEXT.md` | Update docs + write IMPLEMENTATION records after code           |
| `workflows/20-pr-and-review/CONTEXT.md`                | Create, review, and merge a feature PR through the branch chain |
| `workflows/21-release/CONTEXT.md`                      | Cut a release — version bump, changelog, and deployment         |

> Workflow numbers mirror the `src/` tier numbers through the decide-&-plan tier (01–15);
> they then diverge — workflows 16–18 are the implementation phases and 19–21 the
> documentation, PR, and release steps, which have no `src/` artefact folder.

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
- **OWASP Top 10 (2021)** — https://owasp.org/www-project-top-ten/ — vulnerability categories mapped in all security assessments and audits
- **NIST Cybersecurity Framework 2.0** — https://www.nist.gov/cyberframework — risk management functions (Govern, Identify, Protect, Detect, Respond, Recover) applied in workflow 09
- **STRIDE threat modelling** — https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats — threat classification used in `docs/SECURITY-GUIDE.md`
- **ISO/IEC 27001:2022** — https://www.iso.org/standard/82875.html — information security management standard referenced in security assessments

---

## External — SEO & Discoverability

- **Google Search Central** — https://developers.google.com/search/docs — canonical SEO guidance for crawling, indexing, and structured data
- **Schema.org** — https://schema.org/ — vocabulary for JSON-LD structured data (Organization, Article, BreadcrumbList, etc.)
- **Google Lighthouse** — https://developer.chrome.com/docs/lighthouse/overview/ — authoritative tool for Core Web Vitals; results recorded per story
- **Core Web Vitals** — https://web.dev/articles/vitals — LCP < 2.5 s, CLS < 0.1, INP < 200 ms targets applied across all public pages
- **llms.txt specification** — https://llmstxt.org/ — AI agent discoverability standard; see `SEO-CHECKLIST.md` for implementation guidance
- **Per-page metadata** — rendered server-side via Django templates and the SEO app (`code/src/django/apps/seo`) — sets title, description, Open Graph, and canonical tags on all public pages
- **Open Graph protocol** — https://ogp.me/ — metadata standard for social sharing previews

---

## External — Version Control & CI

- **Conventional Commits 1.0** — https://www.conventionalcommits.org/en/v1.0.0/ — commit message format enforced by `docs/GIT-GUIDE.md`
- **Semantic Versioning 2.0** — https://semver.org/ — single-track semver applied by `docs/VERSIONING-GUIDE.md`
- **GitHub Actions** — https://docs.github.com/en/actions — CI/CD platform used for lint, test, and deploy pipelines
- **GitHub flow** — https://docs.github.com/en/get-started/using-github/github-flow — branch-per-feature model adapted in `docs/GIT-GUIDE.md`
