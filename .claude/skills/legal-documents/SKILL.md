---
name: legal-documents
description: >-
  Draft a legal document under English law for <%PROJECT_NAME%> — a service or consultancy
  contract, an NDA, Terms & Conditions, a Privacy Policy, a UK GDPR Article 13/14 data subject
  notice, or an Article 28 Data Processing Agreement. Carries the required sections per type,
  clause formatting, jurisdiction rules, the mandatory professional-review disclaimer, and the
  pre-delivery checklist. Load when a document governs a relationship with a person outside the
  business — a customer, a supplier, a data subject, a controller. Not an internal security or
  compliance policy governing staff and systems, which is `msp-scp-documents`.
model: opus
metadata:
  skills: global-workflow grilling
---

## Overview

**Task skill, inline** (axis 2 — the parties, the jurisdiction and the controller facts come
from the conversation, and a fork cannot ask for them).

This skill is the single source of truth for the house rules every legal and compliance
document in this project follows: the required sections per document type, clause formatting
conventions, jurisdiction rules, the mandatory disclaimer wording, and the quality checklist.
It is loaded before drafting so that structure, tone, formatting and the professional-review
disclaimer stay consistent across every document.

Route substantive UK GDPR procedure to `project-management/docs/GDPR-GUIDE.md` rather than
restating it here.

Locale: <%LOCALE%> · <%TIMEZONE%> · date format DD/MM/YYYY · currency <%CURRENCY%>.

---

## Document Types Covered

- Service / Consultancy Contract
- Non-Disclosure Agreement (NDA)
- Terms & Conditions
- Privacy Policy
- GDPR Data Subject Notice
- Data Processing Agreement (DPA)

---

## Before drafting

Open with a grilling pass (`.claude/skills/grilling/SKILL.md`), drawing the questions from the
required sections of the type being drafted.

**Stateless — `/grill-me`, never `/grill-with-docs`.** A legal document goes to professional
review rather than into the repo as a plan, ADR or story, so the pass records nothing. Mark
anything still unknown at draft time `[AWAITING USER INPUT]`.

---

## Required Sections

### Service / Consultancy Contract

1. Parties (full legal names, registered addresses, company numbers)
2. Background / Recitals
3. Definitions
4. Scope of Services
5. Fees and Payment Terms
6. Term and Termination
7. Intellectual Property
8. Confidentiality
9. Data Protection
10. Limitation of Liability
11. Warranties
12. Indemnification
13. Governing Law and Jurisdiction
14. General (entire agreement, variation, waiver, severability, notices)
15. Signatures (execution block with name, title, date)

### Non-Disclosure Agreement (NDA)

1. Parties
2. Background
3. Definitions (**Confidential Information**, **Disclosing Party**, **Receiving Party**)
4. Obligations of Confidentiality
5. Permitted Disclosures
6. Exclusions from Confidentiality
7. Duration
8. Return or Destruction of Information
9. Remedies
10. Governing Law and Jurisdiction
11. Signatures

### Terms & Conditions

1. Introduction (who operates the service)
2. Definitions
3. Acceptance of Terms
4. Services / Products Offered
5. User Obligations
6. Fees, Payment, and Refunds
7. Intellectual Property
8. Privacy and Data Protection (reference to Privacy Policy)
9. Disclaimers and Limitation of Liability
10. Indemnification
11. Termination of Service
12. Changes to Terms
13. Governing Law
14. Contact Information

### Privacy Policy

1. Introduction (who we are, contact details)
2. What Personal Data We Collect
3. How We Collect It (directly, automatically, from third parties)
4. Why We Process It (legal basis for each purpose under UK GDPR)
5. How We Use It
6. Who We Share It With
7. International Transfers
8. How Long We Keep It (retention periods)
9. Your Rights (access, rectification, erasure, restriction, portability, objection)
10. Cookies and Tracking (or link to Cookie Policy)
11. Changes to This Policy
12. How to Contact Us
13. How to Lodge a Complaint (ICO contact details for UK)

### GDPR Data Subject Notice

1. Identity and Contact Details of the Controller
2. Contact Details of the Data Protection Officer (if applicable)
3. Purposes and Legal Basis for Processing
4. Legitimate Interests (if relying on Article 6(1)(f))
5. Recipients or Categories of Recipients
6. Transfers to Third Countries
7. Retention Period
8. Data Subject Rights
9. Right to Withdraw Consent (if applicable)
10. Right to Lodge a Complaint with the ICO
11. Whether Provision of Data is a Statutory or Contractual Requirement
12. Existence of Automated Decision-Making (including profiling)

### Data Processing Agreement (DPA)

1. Parties (Controller and Processor, with addresses)
2. Background
3. Definitions (aligning with UK GDPR)
4. Subject Matter, Nature, and Duration of Processing (Article 28(3)(a))
5. Processor Obligations (process only on documented instructions)
6. Confidentiality of Processing
7. Security of Processing (Article 32)
8. Sub-Processor Restrictions (Article 28(2)) — state whether authorisation is **specific** (each sub-processor named) or **general** (written authorisation plus a notification-and-objection window)
9. International Transfers (Chapter V) — required whenever the processor or any sub-processor is established outside the UK/EEA; name the mechanism (UK IDTA, the UK Addendum to the EU SCCs, EU SCCs, or an adequacy decision) rather than asserting the transfer is lawful
10. Data Subject Rights Assistance (Article 28(3)(e))
11. Assistance with Data Protection Impact Assessments
12. Return or Deletion of Personal Data (Article 28(3)(g))
13. Audit Rights (Article 28(3)(h))
14. Liability
15. Term and Termination
16. Governing Law
17. Schedule A — Details of Processing (subject matter, duration, nature, purpose, data types, data subjects, and any **special category** data under Article 9 stated as such)
18. Schedule B — Technical and Organisational Security Measures

---

## Formatting Conventions

- **Numbered clauses**: `1.`, `1.1`, `1.1.1` — no letters for top-level clauses
- **Defined terms**: bold on first use, e.g. **"Confidential Information"**
- **Cross-references**: "clause 5.2" (lower-case "clause", no capitalisation)
- **Lists within clauses**: use `(a)`, `(b)`, `(c)` lettered sub-items
- **Schedules**: separate sections at the end, titled "Schedule A", "Schedule B" etc.
- **Signature block**: table with rows for name, title, signature, and date — one column per party
- **Date format**: DD/MM/YYYY throughout
- **Jurisdiction**: always state the governing law in a dedicated final clause before signatures

---

## Tone and Voice

- Formal and precise — avoid ambiguous language
- Use "shall" for obligations, "may" for permissions, "must" for absolute requirements
- Use the party's defined name (e.g. **"the Supplier"**) after first use rather than repeating the full legal name
- Avoid American legal terms: use "solicitor" not "attorney", "articles of association" not "bylaws"
- Plain English alternatives are acceptable for consumer-facing documents (T&Cs, Privacy Policies) but legal precision must not be sacrificed

---

## Quality Checklist

Before delivering any legal document, verify:

- [ ] Professional disclaimer present as the first blockquote, before clause 1
- [ ] All required sections for the document type present (see lists above)
- [ ] Governing law and jurisdiction clause included
- [ ] Parties section has full legal names, addresses, and company numbers
- [ ] Execution / signature block at the end
- [ ] No `[PLACEHOLDER_NAME]` fields remaining — all completed or marked `[AWAITING USER INPUT]`
- [ ] No invented statutory references (write "applicable data protection legislation" not a specific section number unless confirmed)
- [ ] British English throughout
- [ ] Date format DD/MM/YYYY

---

## Category-Specific Disclaimer

All legal documents must begin with this exact blockquote before any numbered clause:

> **Important Notice**: This document has been generated as a starting point only and does not constitute legal, financial, or professional advice. It must be reviewed and approved by a qualified legal, financial, or compliance professional before use. <%ORG_NAME%> accepts no liability for the use of this document without professional review.

Do not paraphrase or abbreviate this notice. Advise users not to remove it until their solicitor confirms the document is fit for purpose.

---

## Related Project Guides

- `project-management/docs/GDPR-GUIDE.md` — governing UK GDPR compliance procedure (lawful bases, DSAR handling, records of processing, ICO obligations).
- `code/workflows/06-gdpr-enforcement/CONTEXT.md` and `project-management/workflows/09-gdpr-compliance/CONTEXT.md` — the enforcement and compliance steps these documents must stay consistent with.
- Once a document is signed off, implementation (publishing behind the `(marketing)/` legal page, token-first) is handed to the `implement-story` / `frontend` path — this skill produces Markdown only and never touches source.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These are the procedure of record — do not restate them at length here.

- `project-management/workflows/09-gdpr-compliance/` — the compliance facts a GDPR-family document must reflect
