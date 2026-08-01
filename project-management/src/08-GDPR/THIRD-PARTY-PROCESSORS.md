# Third-Party Data Processors

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document records every sub-processor that processes personal data on behalf of the organisation for the project. For each processor: the name, purpose, data categories transferred, country of processing, legal transfer mechanism, and whether an Article 28 Data Processing Agreement (DPA) is in place.

**Last reviewed:** {DATE — fill in on first review}

---

## Legal Context

Under UK GDPR Article 28, where the organisation (as controller) engages a processor to process personal data on its behalf, that engagement must be governed by a binding written contract (a Data Processing Agreement). The DPA must require the processor to:

- Process personal data only on the organisation's documented instructions
- Ensure confidentiality obligations on authorised personnel
- Implement appropriate technical and organisational measures (Art. 32)
- Engage sub-processors only with the organisation's consent
- Assist the controller in meeting data subject rights obligations
- Return or delete all personal data at the end of the services
- Provide all information necessary to demonstrate compliance

**Adequacy (transfers from UK):** The UK operates its own adequacy assessment framework. The UK has granted adequacy decisions for the EEA and several other countries. For transfers to the US, the UK–US Data Bridge (a UK extension of the EU–US Data Privacy Framework) provides an adequacy mechanism for certified organisations. Transfers to non-adequate countries require Standard Contractual Clauses (SCCs) or Binding Corporate Rules (BCRs) under UK GDPR.

**Not every recorded party is an Art. 28 processor.** Record three kinds of entry in this register, and distinguish them clearly:

- **Third-party sub-processor** (Art. 28 applies) — an external provider processing personal data on the organisation's documented instructions; a signed DPA is required.
- **Self-hosted infrastructure** (Art. 28 does _not_ apply) — a component the organisation runs on its own infrastructure; the organisation is controller and processor, so no DPA is required. Record it for completeness so its security posture and erasure handling are captured.
- **Independent data controller** (controller-to-controller; Art. 28 does _not_ apply) — a party that determines its own purposes for any data shared with it. No DPA exists or is required, but the sharing must be disclosed in the Privacy Policy with a lawful basis.

---

## Processor Register

_Guidance: create one entry like the illustrative example below per processor. Complete every attribute row; where an attribute does not apply, record "Not applicable" with a one-line reason. Once a DPA is signed, record its date, signatory, and URL in the "Art. 28 DPA in place" row._

### [EXAMPLE] Cloudinary — media storage and delivery

| Attribute                              | Detail                                                                                                                                                                                  |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Processor name**                     | Cloudinary Ltd / Cloudinary Inc                                                                                                                                                         |
| **Parent company**                     | {parent entity, or "Not applicable"}                                                                                                                                                    |
| **Purpose**                            | Cloud media storage and delivery — hosts public media assets uploaded through the application (e.g. profile avatars, portfolio images)                                                  |
| **Data categories transferred**        | Uploaded media files that may depict individuals — e.g. avatar photos, images in testimonials or case studies                                                                           |
| **Data subjects affected**             | {which categories of data subject — e.g. clients, portal users, prospects, public visitors}                                                                                             |
| **Country of processing**              | United States (primary); CDN nodes globally                                                                                                                                             |
| **Legal transfer mechanism**           | Provider participates in the EU–US Data Privacy Framework; UK–US Data Bridge adequacy applies — confirm against the provider's current certification at DPA signing                     |
| **Art. 28 DPA in place**               | {Yes / No — once signed, record the date, signatory, and DPA URL here}                                                                                                                  |
| **Lawful basis for transfer**          | {e.g. Art. 6(1)(b) contract performance, or Art. 6(1)(f) legitimate interest with a completed LIA}                                                                                      |
| **Data minimisation**                  | {what content restriction is enforced technically; note any PII-in-filename or metadata risk}                                                                                           |
| **Client / data-subject notification** | {where the processor is disclosed to data subjects — Privacy Policy, onboarding pack (Art. 13(1)(e))}                                                                                   |
| **Erasure handling**                   | {procedure to delete the data subject's data from this processor on an Art. 17 request — must fire before local references are cleared}                                                 |
| **Notes**                              | {deployment, regional, or configuration constraints; cross-reference `BREACH-NOTIFICATION.md` for any credential-compromise scenario and `RETENTION-DELETION.md` for retention periods} |

---

## Sub-Processor Register Summary

_Guidance: one row per processor entry above — a one-line index of the full register for quick review._

| Processor            | Purpose                    | Personal data transferred / processed                               | Art. 28 DPA                          | Priority              |
| -------------------- | -------------------------- | ------------------------------------------------------------------- | ------------------------------------ | --------------------- |
| [EXAMPLE] Cloudinary | Media storage and delivery | Avatar photos and other uploaded images that may depict individuals | {Signed DD/MM/YYYY / Not yet signed} | {High / Medium / Low} |

---

## Actions Required

_Guidance: list every outstanding action needed to bring a processor arrangement into Art. 28 compliance. Remove a row once its action is complete and the evidence (signed DPA, disclosure, erasure procedure) is recorded above._

| Action                                                                                     | Processor            | Priority                   | Blocking                                                        |
| ------------------------------------------------------------------------------------------ | -------------------- | -------------------------- | --------------------------------------------------------------- |
| [EXAMPLE] Sign the Art. 28 DPA before any personal data is processed through this provider | [EXAMPLE] Cloudinary | {Critical / High / Medium} | {Yes — the feature must not go to production without this / No} |
