# Threat Model Plan — US000 {STORY TITLE}

_Template — copy to `THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md`, replace every `[EXAMPLE]`
row and `{PLACEHOLDER}` with this story's own analysis, and delete this note once
populated. This is the **pre-implementation** STRIDE threat model for a single story;
its post-implementation counterpart is
`../IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md`._

| Field               | Value                                                            |
| ------------------- | ---------------------------------------------------------------- |
| **Story**           | US### — {short title}                                            |
| **Date**            | {DD/MM/YYYY}                                                     |
| **Author**          | {name / agent}                                                   |
| **Status**          | Draft / Reviewed / Signed off                                    |
| **Feature surface** | {one line: the routes, endpoints, or components this story adds} |

---

## 1. Scope

State exactly what this model covers — the story's feature surface, the routes,
endpoints, models, components, and tasks in play — and its source artefacts.

- **User flow(s):** {`../../../05-USER-FLOW/USER-FLOW-<AREA>.md`}
- **Wireframe(s):** {`../../../08-WIREFRAMES/USER-STORY-IDEAS/WF-IDEA-US###-<SCREEN>.html`}
- **Surface under review:** {endpoints / views / components / tasks}
- **Data touched:** {the tables/stores and any PII classification}

### Severity scale

| Level      | Definition                                                                |
| ---------- | ------------------------------------------------------------------------- |
| `CRITICAL` | Exploitable without authentication, or full compromise / credential theft |
| `HIGH`     | Exploitable with low-privilege access; significant data or integrity risk |
| `MEDIUM`   | Exploitable under specific conditions; moderate impact                    |
| `LOW`      | Minor impact; defence-in-depth measure                                    |

Only **CRITICAL** and **HIGH** findings block sprint planning (per
`project-management/docs/SECURITY-GUIDE.md`).

## 2. Trust boundaries

Every point where data crosses a privilege or trust level. One row per boundary; the
STRIDE table below references these by ID.

| ID  | From                        | To                                     | Data crossing                |
| --- | --------------------------- | -------------------------------------- | ---------------------------- |
| TB1 | [EXAMPLE] Anonymous browser | {public route / Django Ninja endpoint} | {form input; session cookie} |

_Add a row per boundary (TB1..TBn) — anonymous↔frontend, frontend↔API, app↔database,
worker↔store, app↔third-party. Every threat below maps to one of these._

## 3. STRIDE threat table

One row per identified threat. Categorise by STRIDE, map to an OWASP Top 10 (2025)
category and a NIST CSF 2.0 function, tie it to a trust boundary, score severity, and
propose the design-stage mitigation. **Status is `Proposed` at planning time** — it is
re-assessed against shipped code in the implementation counterpart.

| ID              | STRIDE   | OWASP | NIST CSF | Trust Boundary | Threat description                                                                      | Severity | Status   | Mitigation (proposed control)                                                                                                       |
| --------------- | -------- | ----- | -------- | -------------- | --------------------------------------------------------------------------------------- | -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| [EXAMPLE] TM-01 | Spoofing | A01   | PR.AC    | TB1            | {Attacker impersonates another user by submitting a forged identifier to the endpoint.} | HIGH     | Proposed | {No user-supplied ID accepted; actor read from server session; ownership check before any write; `SameSite=Strict` session cookie.} |

_One row per threat. STRIDE = Spoofing / Tampering / Repudiation / Information disclosure
/ Denial of service / Elevation of privilege. OWASP = A01–A10 (2025). NIST CSF =
GV / ID / PR / DE / RS / RC (with sub-category where known, e.g. `PR.AC`). Every threat
needs a severity and a proposed mitigation._

## 4. Blocking findings & escalations

The CRITICAL/HIGH findings that must be resolved in design before this story enters
sprint planning. Each drives an acceptance criterion or developer constraint and is
escalated to a vulnerability record.

- [ ] [EXAMPLE] **TM-01 ({HIGH})** — {IDOR on the endpoint}; escalated to
      `../../VULNERABILITIES/PLANNING/VULN-<DESCRIPTOR>-DD-MM-YYYY.md`.

_List only CRITICAL/HIGH here; MEDIUM/LOW stay in the table above as tracked residuals._

## 5. Out of scope

Boundaries and surfaces this model deliberately does not cover, with where they are
covered instead.

- [EXAMPLE] {Existing authentication (US###) — modelled in its own
  `THREAT-MODEL-PLAN-US###-<DESCRIPTOR>.md`.}

---

## Cross-references

- `../IMPLEMENTATION/THREAT-MODEL-IMPL-US000-TEMPLATE.md` — the post-implementation
  review that re-assesses this model
- `../../ASSESSMENTS/PLANNING/` — the posture assessment that consumes this model
- `../../VULNERABILITIES/PLANNING/` — where blocking CRITICAL/HIGH findings are escalated
- `../../../02-STORIES/` — the story being modelled · `../../../05-USER-FLOW/` ·
  `../../../08-WIREFRAMES/`
- `project-management/docs/SECURITY-GUIDE.md` — STRIDE / OWASP Top 10 / NIST CSF 2.0 reference
- `project-management/workflows/10-security-checks/` — the workflow that produces this model
- `code/docs/SECURITY.md` — the code-side enforcement these controls specify
