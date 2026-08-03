# Data Subject Rights

_Template — replace every `[EXAMPLE]` row and `{PLACEHOLDER}` with your project's own data, and delete this note once populated._

This document describes how each of the eight data subject rights under UK GDPR is exercised in the project, mapped to the implementing story where one exists. Complete one **Implementation** table per right: list every mechanism that services the right, the story that delivers it, and its status.

**Last reviewed:** {DATE — fill in on first review}

---

## Data Subject Types

Record the categories of individual whose personal data the organisation processes. Each type frames who may exercise the rights below and how they are identified.

| Type                      | Description                                                                  |
| ------------------------- | ---------------------------------------------------------------------------- |
| [EXAMPLE] Registered user | An authenticated account holder with a profile and credentials in the system |

_Guidance: list each data-subject category the organisation processes (e.g. staff, customers, portal users, prospects, unauthenticated visitors) with a one-line description of who they are._

---

## Right 1 — Right of Access (Art. 15)

**Summary:** A data subject is entitled to receive a copy of all personal data held about them, together with information about how it is processed, the retention periods or criteria for determining them, and any third-party recipients.

**How to service it:** accept a subject access request (SAR) via a self-service form or written request → verify the requester's identity → collate all personal data held across every system → respond within one month (extendable by a further two months for complex or numerous requests) in a concise, intelligible, machine-readable form. Disclose the sub-processors that receive the data — keep that list in sync with `THIRD-PARTY-PROCESSORS.md`.

### Implementation

| Aspect                                     | Implementation                                                                               | Story   | Status   |
| ------------------------------------------ | -------------------------------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Self-service SAR submission form | Data subjects submit a SAR at a public route (e.g. `/privacy/sar/`) providing name and email | {US###} | Designed |

_Guidance: record each mechanism that services access — the SAR route or admin inbox, the identity-verification step, the one-month deadline tracker, the export generator, and the audit log of SAR processing._

---

## Right 2 — Right to Rectification (Art. 16)

**Summary:** A data subject is entitled to have inaccurate personal data corrected and incomplete personal data completed.

**How to service it:** provide self-service profile editing where the data subject holds an account; otherwise action a written request through an administrator. Ensure a correction propagates to any derived or companion fields (e.g. a searchable/HMAC token stored alongside an encrypted value). Respond within one month.

### Implementation

| Aspect                                | Implementation                                                         | Story   | Status   |
| ------------------------------------- | ---------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Self-service profile update | Account holders update their own name and email via their profile page | {US###} | Designed |

_Guidance: record each rectification path per data-subject type, and note any companion field a correction must propagate to._

---

## Right 3 — Right to Erasure (Art. 17)

**Summary:** A data subject may request deletion of their personal data in specified circumstances — where data is no longer needed, consent has been withdrawn, or the data has been processed unlawfully.

**How to service it:** accept an erasure request → verify identity → erase or anonymise the subject's personal data across every app that holds it → **retain any records exempt under Art. 17(3)**, then confirm completion. Under Art. 17(3)(b), data held to meet a legal obligation (for example accounting/tax records, or records kept for the limitation period) cannot be erased until the applicable retention window expires — record those exemptions in `RETENTION-DELETION.md` and disclose them to the data subject. Consent records are preserved on erasure as evidence of the lawful basis.

### Implementation

| Aspect                                      | Implementation                                                                                                                    | Story   | Status   |
| ------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Self-service erasure request form | Data subjects submit a request at a public route (e.g. `/privacy/erasure/`); an erase routine nullifies or anonymises PII per app | {US###} | Designed |

_Guidance: record, per app or table, the erasure behaviour (null / anonymise / hard-delete) and whether the record is exempt under Art. 17(3)(b) legal-retention; note where a legally-retained record is soft-deleted until its window expires._

---

## Right 4 — Right to Restriction of Processing (Art. 18)

**Summary:** A data subject may request that processing of their data is restricted (data retained but not actively used) while an accuracy dispute, objection, or unlawful processing claim is being resolved.

**How to service it:** set a restriction flag on the record that suppresses active processing (marketing, analytics, outreach) while the record itself is retained; track the request status (pending / active / lifted / rejected) with grounds and timestamps; have an administrator review, apply, and lift the restriction; reflect the restriction status in any SAR export.

### Implementation

| Aspect                                        | Implementation                                                                            | Story   | Status   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Restriction flag on the user record | A boolean field which, when set, suppresses outreach, marketing, and analytics processing | {US###} | Designed |

_Guidance: record the flag, the request-tracking table, the service that applies/lifts it, and how restriction appears in the SAR export._

---

## Right 5 — Right to Data Portability (Art. 20)

**Summary:** Where processing is based on consent or contract and is carried out by automated means, the data subject may receive their data in a structured, commonly used, machine-readable format (typically JSON or CSV), and may transmit it to another controller.

**How to service it:** generate an export of the personal data the subject provided, in a structured machine-readable format (JSON and/or CSV). Exclude sensitive internal fields (password hashes, MFA/TOTP secrets, internal lookup tokens). Scope is limited to processing based on consent or contract and carried out by automated means — narrower than the access right.

### Implementation

| Aspect                                 | Implementation                                                          | Story   | Status   |
| -------------------------------------- | ----------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Machine-readable JSON export | Per-app export aggregated into a JSON download of subject-provided data | {US###} | Designed |

_Guidance: record the export mechanism, the format(s) offered, the fields excluded as sensitive, and which processing activities are in scope for portability versus access only._

---

## Right 6 — Right to Object (Art. 21)

**Summary:** A data subject may object to processing based on legitimate interests (Art. 6(1)(f)) or processing for direct marketing purposes. The controller must cease that processing unless it can demonstrate compelling legitimate grounds.

**How to service it:** an objection to direct marketing is absolute and must be honoured immediately — provide a working unsubscribe link in every marketing message and enforce it via a suppression list. For processing based on legitimate interests, provide a route to lodge an objection, which the controller must honour unless it can demonstrate compelling legitimate grounds that override the data subject's interests.

### Implementation

| Aspect                           | Implementation                                                                                             | Story   | Status   |
| -------------------------------- | ---------------------------------------------------------------------------------------------------------- | ------- | -------- |
| [EXAMPLE] Newsletter unsubscribe | Unsubscribe link in every marketing email; status set to unsubscribed; consent record retained as evidence | {US###} | Designed |

_Guidance: record each objection path — marketing unsubscribe/suppression, and any mechanism to object to legitimate-interests processing (analytics, logging)._

---

## Right 7 — Rights Related to Automated Decision-Making (Art. 22)

**Summary:** A data subject has the right not to be subject to a decision based solely on automated processing that produces a legal or similarly significant effect.

**How to service it:** confirm whether any solely-automated decision with a legal or similarly significant effect exists. If one does, provide meaningful human review, the right to contest the decision, and an explanation of the logic involved. If none exists, record the right as **Not applicable** and re-confirm whenever any automated scoring, profiling, or decision feature is introduced.

### Implementation

{PLACEHOLDER — state whether any solely-automated decision-making with a legal or similarly significant effect is in scope. If none, record "Not applicable — no automated decision-making identified" and note the date this was last confirmed. If any exists, document the human-review, contest, and explanation mechanisms and the implementing story.}

---

## Right 8 — Right to Withdraw Consent (Art. 7(3))

**Summary:** Where processing is based on consent, the data subject must be able to withdraw consent at any time, as easily as it was given.

**How to service it:** provide a per-channel withdrawal path (e.g. newsletter unsubscribe, cookie-banner category toggle) that takes immediate effect and is as easy to use as the original opt-in. Retain the consent record on withdrawal as evidence of the prior lawful basis. Where no dedicated withdrawal path exists (e.g. a one-off form submission), withdrawal is achieved via the erasure right (Right 3).

### Implementation

| Aspect                                  | Implementation                                                                                   | Story   | Status   |
| --------------------------------------- | ------------------------------------------------------------------------------------------------ | ------- | -------- |
| [EXAMPLE] Newsletter consent withdrawal | Unsubscribe link in every email; status set to unsubscribed; consent record retained as evidence | {US###} | Designed |

_Guidance: record each consent-withdrawal path per processing activity, and note where withdrawal is instead achieved via the erasure right._

---

## Rights Implementation Summary Table

One row per right, summarising coverage. Keep the article mapping intact; fill the remaining columns from the sections above.

| Right                  | Article | Implemented | Implementing story | Key gap / notes                                     |
| ---------------------- | ------- | ----------- | ------------------ | --------------------------------------------------- |
| [EXAMPLE] Access (SAR) | Art. 15 | Partially   | {US###}            | Export scope to be confirmed against all PII models |

_Guidance: add one row per right (Access Art. 15, Rectification Art. 16, Erasure Art. 17, Restriction Art. 18, Portability Art. 20, Object Art. 21, Automated decisions Art. 22, Withdraw consent Art. 7(3)) recording implementation status, the implementing story, and any outstanding gap._
