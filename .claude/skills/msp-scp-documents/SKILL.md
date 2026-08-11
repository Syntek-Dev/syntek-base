---
name: msp-scp-documents
description: "Shared drafting standard for Managed Service Provider (MSP) and Security/Compliance Programme (SCP) policy documents — required sections, ISO/IEC alignment, the standard document header, version control, and the quality checklist. Load this whenever an internalised policy-writer agent drafts an information security policy, password/authentication policy, incident response plan, acceptable use policy, business continuity plan, network security policy, data classification policy, data retention policy, sub-processor register, service level agreement, change management policy, or vendor assessment report."
---

# MSP / SCP Documents — Skill

This skill is the shared drafting standard loaded by the internalised security,
compliance, and GDPR policy-writer agents under
`/home/sam-dev/Repos/<%PROJECT_SLUG%>/<%PROJECT_SLUG%>/.claude/agents/` (for example
`information-security-policy-writer`, `password-auth-policy-writer`,
`incident-response-plan-writer`, `acceptable-use-policy-writer`,
`business-continuity-plan-writer`, `network-security-policy-writer`,
`data-classification-policy-writer`, `data-retention-policy-writer`,
`sub-processor-register-writer`, `service-level-agreement-writer`,
`change-management-policy-writer`, and `vendor-assessment-writer`). It defines the
required sections, ISO/IEC alignment rules, the standard document header, version
control, and the quality checklist that every MSP/SCP policy document must follow.

These agents are **document drafters, not code implementers**. They produce Markdown
policy text as a **draft for professional review** — they never present a document as
final or as legal advice, and never build routes, run migrations, or touch source.
Publishing a signed-off policy behind a marketing legal page is a separate task for the
`feature` / `frontend` path.

Locale: <%LOCALE%> · <%TIMEZONE%> · date format DD/MM/YYYY · currency <%CURRENCY%>.

---

## Document Types Covered

| Document type                    | Required-sections reference                      |
| -------------------------------- | ------------------------------------------------ |
| Information Security Policy      | [SECURITY-POLICIES.md](SECURITY-POLICIES.md)     |
| Password & Authentication Policy | [SECURITY-POLICIES.md](SECURITY-POLICIES.md)     |
| Network Security Policy          | [SECURITY-POLICIES.md](SECURITY-POLICIES.md)     |
| Data Classification Policy       | [SECURITY-POLICIES.md](SECURITY-POLICIES.md)     |
| Incident Response Plan           | [INCIDENT-CONTINUITY.md](INCIDENT-CONTINUITY.md) |
| Business Continuity Plan         | [INCIDENT-CONTINUITY.md](INCIDENT-CONTINUITY.md) |
| Acceptable Use Policy            | [USE-AND-CHANGE.md](USE-AND-CHANGE.md)           |
| Change Management Policy         | [USE-AND-CHANGE.md](USE-AND-CHANGE.md)           |
| Data Retention & Disposal Policy | [DATA-GOVERNANCE.md](DATA-GOVERNANCE.md)         |
| Sub-Processor Register           | [DATA-GOVERNANCE.md](DATA-GOVERNANCE.md)         |
| Vendor Assessment Report         | [VENDOR-AND-SLA.md](VENDOR-AND-SLA.md)           |
| Service Level Agreement          | [VENDOR-AND-SLA.md](VENDOR-AND-SLA.md)           |

---

## Section Map

| Sub-document                                     | Covers                                                                                                                                            |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| [SECURITY-POLICIES.md](SECURITY-POLICIES.md)     | Required sections for the four core security policies                                                                                             |
| [INCIDENT-CONTINUITY.md](INCIDENT-CONTINUITY.md) | Required sections for incident response and business continuity                                                                                   |
| [USE-AND-CHANGE.md](USE-AND-CHANGE.md)           | Required sections for acceptable use and change management                                                                                        |
| [DATA-GOVERNANCE.md](DATA-GOVERNANCE.md)         | Required sections for retention/disposal and the sub-processor register                                                                           |
| [VENDOR-AND-SLA.md](VENDOR-AND-SLA.md)           | Required sections for vendor assessment and service level agreements                                                                              |
| [STANDARDS.md](STANDARDS.md)                     | The standard header, version control, ISO/IEC alignment, formatting, tone, quality checklist, and disclaimer — applies to **every** document type |

---

## When to Use

- A policy-writer agent is drafting **any** of the twelve document types above — load
  this skill first, then read the matching sub-document for the required section list.
- You need the **standard header**, **version-history table**, or **category-specific
  disclaimer** that opens every MSP/SCP document — see [STANDARDS.md](STANDARDS.md).
- You need to confirm **ISO/IEC alignment** wording, the **P1–P4 severity scale**, the
  **imperative voice** rules, or the pre-delivery **quality checklist** — all in
  [STANDARDS.md](STANDARDS.md).
- You need to cross-check a policy against the project's own governing docs:
  `project-management/docs/SECURITY-GUIDE.md`, `project-management/docs/GDPR-GUIDE.md`,
  `code/docs/SECURITY.md`, and the shared drafting standards in
  `.claude/skills/global-workflow/SKILL.md` (if present).

## Clarifying questions

Every policy-writer runs a **clarifying-questions step** before drafting, using the
document-specific question set defined in its own agent file. Keep that question content as
written — this skill sets only the **method**.

Conduct the clarifying questions as a **grilling pass** — load
`.claude/skills/grilling/SKILL.md`, which owns the round shape, the question format and the
recommendation rule. The user can also invoke it directly as `/grill-me`.

Use the **stateless** grilling (the `grilling` engine / `/grill-me`), **not**
`/grill-with-docs` — a policy draft for professional review is not a plan, ADR, or story
artifact, so nothing is recorded to the repo. Mark anything still unknown at draft time as
`[AWAITING USER INPUT]`.

## How the Sub-Documents Fit Together

For any draft:

1. Read [STANDARDS.md](STANDARDS.md) — it governs the header, version history, tone,
   formatting, ISO alignment, disclaimer, and the final quality checklist for **all**
   document types.
2. Read the one sub-document that lists the **required sections** for your document
   type (see the map above).
3. Draft every required section. Mark any unknown field `[AWAITING USER INPUT]` — never
   invent statutory references, vendor product names, or approver names.
4. Verify the draft against the quality checklist in [STANDARDS.md](STANDARDS.md) before
   delivering.

## Governing procedures (route here — do not restate at length)

**No governing workflow.** This skill is a session or sandbox mechanic, not a step in the
delivery chain. It is invoked directly and does not route into `code/workflows/`,
`project-management/workflows/`, or `how-to/workflows/`.
