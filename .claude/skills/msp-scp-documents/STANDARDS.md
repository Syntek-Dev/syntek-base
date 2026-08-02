# MSP / SCP Documents — Shared Standards

These standards apply to **every** MSP/SCP policy document, regardless of type. Read
this alongside the required-sections sub-document for your document type (see the map in
[SKILL.md](SKILL.md)).

---

## Policy Document Header (All Documents)

Every policy document must open with this standard header table before any body content:

```markdown
| Field                | Value                                |
| -------------------- | ------------------------------------ |
| **Document title**   | [Policy Name]                        |
| **Version**          | [VERSION]                            |
| **Status**           | Draft / Under Review / Approved      |
| **Owner**            | [CONTACT_NAME], [Job Title]          |
| **Approved by**      | [AWAITING USER INPUT]                |
| **Date issued**      | [DATE]                               |
| **Next review date** | [REVIEW_DATE]                        |
| **Classification**   | Internal / Confidential / Restricted |
```

This header is mandatory — do not omit it.

---

## Policy Version Control

Policies must include a version history table immediately after the header:

```markdown
## Version History

| Version | Date   | Author         | Summary of Changes |
| ------- | ------ | -------------- | ------------------ |
| 0.1.0   | [DATE] | [CONTACT_NAME] | Initial draft      |
```

Versioning follows semantic versioning (MAJOR.MINOR.PATCH):

- MAJOR: significant restructure or regulatory requirement change
- MINOR: new sections or controls added
- PATCH: wording corrections, typo fixes, minor clarifications

This mirrors the project's own single-track semver — see
`project-management/docs/VERSIONING-GUIDE.md`.

---

## ISO/IEC Alignment

Policy documents must align with the following standards where applicable. Do not claim
certification — write "aligned with" or "informed by", never "certified to".

| Standard                    | Relevance                                                                                   |
| --------------------------- | ------------------------------------------------------------------------------------------- |
| **ISO/IEC 27001:2022**      | Information Security Management System (ISMS) framework — core reference for all policies   |
| **ISO/IEC 27002:2022**      | Controls guidance — reference specific controls by clause number when citing                |
| **NIST SP 800-53**          | Optional US-aligned control reference; use when the client operates in US-regulated sectors |
| **Cyber Essentials (NCSC)** | UK government scheme — required for UK government contract eligibility                      |
| **GDPR / UK GDPR**          | All policies involving personal data must reference relevant data protection obligations    |

When citing ISO controls, use the clause format: "ISO/IEC 27001:2022, Annex A, Control
8.8 — Management of technical vulnerabilities."

---

## Formatting Conventions

- Document header table at the very top, before the disclaimer
- Version history table immediately after the header
- Numbered sections throughout the body
- Use bold for defined terms and policy keywords on first use (e.g. **"Incident"**, **"Privileged Account"**)
- Severity classification tables use the P1–P4 scale with response times
- Use the imperative voice for policy rules: "The organisation **must**…", "All staff **shall**…"
- Date format: DD/MM/YYYY

---

## Tone and Voice

- Formal, authoritative, and unambiguous
- Written in the imperative ("The organisation must…", "All staff shall…")
- Avoid weak language: "should consider" → "must" or "shall"
- Use "organisation" rather than the company name where a rule applies universally
- Define all technical terms on first use

---

## Category-Specific Disclaimer

All MSP/SCP policy documents must begin with this blockquote after the document header
and before the body:

> **Important Notice**: This document has been generated as a starting point only and
> does not constitute professional security, compliance, or legal advice. It must be
> reviewed and approved by a qualified information security professional and, where
> applicable, a legal adviser before adoption. <%ORG_NAME%> accepts no liability for
> the use of this document without professional review.

---

## Quality Checklist

Before delivering any MSP/SCP policy document, verify:

- [ ] Professional disclaimer present as the first blockquote
- [ ] Document header table present with all fields
- [ ] Version history table present
- [ ] All required sections for the document type present (see the per-type sub-document)
- [ ] Severity classification table present in incident response plans
- [ ] ISO/IEC alignment noted where applicable (using "aligned with", not "certified to")
- [ ] MFA section addresses SMS OTP weakness in password policies
- [ ] ICO 72-hour notification requirement present in incident response plans
- [ ] No specific vendor product names in policy body
- [ ] No `[PLACEHOLDER]` fields — every field completed or marked `[AWAITING USER INPUT]`
- [ ] No invented statutory or ISO references
- [ ] British English throughout
- [ ] Date format DD/MM/YYYY
