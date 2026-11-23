# Requirements-practice sources and role-only redaction — what may be taken, and what still identifies

**Written**: 23/11/2026 · **Driver**: research node N-013 of
`project-management/src/01-FEATURE-MAPS/MAP-CLIENT-REQUIREMENTS-AND-FEEDBACK.md` · **Feeds**:
N-011 (identifiability half), N-023, and slice S-05's `README.md` _Influences_ criterion

## Question

What reuse terms bind ISO/IEC/IEEE 29148:2018, the IIBA BABOK Guide v3 and the Volere
Requirements Specification Template for a publicly redistributed Copier template, and does the
ICO treat replacing a person's name with their role as enough to stop client text being personal
data?

## Verdict

**None of the three is open-licensed, and none is share-alike.** All three reserve their text:
ISO by its copyright notice and licence agreement, IIBA by its terms of use, Volere by its
site notice and paid usage fee. So the `.claude/CLAUDE.md` Section 6 share-alike rule does not
apply. The narrower rule does: read them, name them, and re-author. Their **vocabulary** (common
terms of art such as "fit criterion", "stakeholder", "elicitation") may be used. Their **text**
and examples may not be reproduced. **Paraphrasing a structure or attribute list** is not
something any of the three permits in terms. The risk depends on how closely the template
follows the original. Re-authoring from general practice is safe. A section-by-section
restatement of Volere's 27 headings or 29148's information-item contents is not.

**A role in place of a name does not, on its own, take text out of personal data.** The ICO says
a person can be identifiable without their name, from any detail that distinguishes them in
context. Where a role is unique within a named organisation, as a small firm's Managing Director
usually is, the role works as an identifier. Holding the real names elsewhere makes the text, at
best, **pseudonymised**, and the ICO says pseudonymised data stays personal data.

**Not legal advice.** Every licence position is read from the owner's own published terms.

---

## 1. ISO/IEC/IEEE 29148:2018

| Claim                                                                                                                                                                                                                                                                                 | Primary source                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The current edition is Edition 2, published 11/2018, 92 pages, priced CHF 227. It was confirmed at systematic review in 2024. On 16/02/2026 it entered stage 90.92 (to be revised), and ISO/IEC/IEEE DIS 29148 is under development as its replacement                                | [ISO 29148:2018 page](https://www.iso.org/standard/72089.html), general information and life cycle                                                        |
| ISO owns copyright in all content on its site and in every ISO publication. Copying, scanning or distribution without written permission is prohibited, and permission is requested from the Central Secretariat or the national member body                                          | [ISO copyright](https://www.iso.org/copyright.html)                                                                                                       |
| A purchased publication is licensed, not sold. The licence covers reading, consulting and applying the content inside the licensee's own operations. It excludes reproduction, distribution, adaptation, incorporation and derivative works unless a further licence is granted       | [ISO Terms and conditions – Licence Agreement](https://www.iso.org/terms-conditions-licence-agreement.html) (updated 29/05/2026), Part B Sections 3 and 4 |
| A further licence is needed to reproduce or adapt the content, in whole or in part, into manuals, procedures, guidance or material made available to third parties. One is also needed to structure or operationalise it in software, workflow tools, data models or AI-enabled tools | Same, Part B Section 6(a) and 6(b)                                                                                                                        |
| A licensee may not use the publication for AI or ML purposes without a separate licence. This includes prompting a model with it, or having a model restate, summarise or reformulate it. ISO opts out of the EU text-and-data-mining exception                                       | Same, Part B Section 7(b)                                                                                                                                 |
| The standard is jointly published with IEEE. IEEE's own permission terms for 29148 were **not read** (the IEEE SA page reached covers contributions to standards development, not reuse of a published standard)                                                                      | [IEEE SA copyright FAQs](https://standards.ieee.org/faqs/copyrights/) — unmeasured for this question                                                      |

**What follows.** Citing "ISO/IEC/IEEE 29148" by name and using its general terms is reference.
Turning its required information-item contents into this template's register template or
workflow steps is the adaptation and digital incorporation that Section 6 says needs a licence.
Section 7(b) also means a project agent should not be handed a purchased copy to read or summarise.

## 2. IIBA BABOK Guide v3

| Claim                                                                                                                                                                                                                                                                                            | Primary source                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| The BABOK Guide is sold, or licensed to enterprises. Members read it through the KnowledgeHub. A **BABOK Guide Glossary** and the **Business Analysis Standard** are offered free                                                                                                                | [IIBA BABOK Guide page](https://www.iiba.org/career-resources/a-business-analysis-professionals-foundation-for-success/babok/)                                                                       |
| Access to IIBA Services is granted for **personal, non-commercial use**. Except where expressly stated, Services may not be copied, reproduced, republished, modified or distributed, in whole or in part, without IIBA's prior written consent. "Services" includes IIBA products and materials | [IIBA Terms of Use](https://www.iiba.org/footer/terms-of-use/) (effective 03/05/2021), Sections 1.1, 3.1 and 3.2                                                                                     |
| IIBA, BABOK Guide and Business Analysis Body of Knowledge are registered trademarks. A third party that uses them must attribute them in IIBA's set form, must not imply affiliation or endorsement, and must not use a confusable name for its own products                                     | [IIBA Trademarks and Guidelines](https://www.iiba.org/about-iiba/brand-centre-brand-identity-marketing-media/trademarks-and-guidelines/), Trademarks, Other Trademark Requirements, What "Not" To Do |
| The copyright notice printed in BABOK v3 itself, and the terms on the free Glossary and Business Analysis Standard, were **not read**                                                                                                                                                            | — unmeasured                                                                                                                                                                                         |

**What follows.** Naming the BABOK Guide in a reference row is ordinary reference. If it is
named, the registered-mark notice is IIBA's stated requirement. Its text, task and technique
descriptions and knowledge-area structure fall under the written-consent bar in Section 3.1. The
free Glossary's licence is unread, so treat it the same way until it is checked.

## 3. Volere Requirements Specification Template

| Claim                                                                                                                                                                                                                                                                                                                                   | Primary source                                                                                       |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| The current edition is **Edition 20**, by James and Suzanne Robertson of the Atlantic Systems Guild. The public page is an extract. The complete template (about 90 pages, with worked examples, the atomic-requirement spreadsheet and the Requirements Knowledge Model) is behind a usage fee of US$55 per project or US$255 per site | [Volere template page](https://www.volere.org/templates/volere-requirements-specification-template/) |
| The template may not be sold, or used for commercial gain or any purpose other than as the basis for a requirements specification. A separate **redistribution licence** is offered to tool vendors and others who want to include all or part of the template package in products they sell. Academic use is free on request           | Same page                                                                                            |
| Site content is copyright 2019 Atlantic Systems Guild Ltd, and reproduction needs the owner's contact and permission                                                                                                                                                                                                                    | Same page, footer                                                                                    |
| Commercial use of the template and other Volere intellectual property, and use of the Volere brand, are licensed case by case with no boilerplate licence                                                                                                                                                                               | [Volere Licensing](https://www.volere.org/services/licensing/)                                       |
| Older editions (v6 to v16) circulate on university mirrors with looser notices (copying permitted with a copyright acknowledgement). These mirrors are secondary copies of superseded editions and were **not relied on**                                                                                                               | Search results only; the owner's current page governs                                                |

**What follows.** Redistributing part of the template inside a public template is exactly what
the redistribution licence covers. The template's section list and its requirement-shell
attributes are its own structure. Naming Volere and terms of art such as "fit criterion" is
reference, and re-authoring a register from general practice is the safe route.

## 4. ICO — identifiability, pseudonymisation and anonymisation

**Status.** The anonymisation and pseudonymisation guidance was published on 28/03/2025. It is
not a statutory code, but the ICO takes it into account when it looks into an issue. It covers
free text as well as tabular data. Every page read carries a banner saying it is **under review
following the Data (Use and Access) Act** and may change
([About this guidance](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/about-this-guidance/)).

| Claim                                                                                                                                                                                                                                                                                                                                                | Primary source                                                                                                                                                                                                                                                                            |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A person can be identifiable without their name. Any identifier, or combination of identifiers, that distinguishes one person from the others in a group is enough. The ICO's own examples are descriptions, not names, such as an elderly man at a given address who drives a given car                                                             | [Can we identify an individual directly?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/personal-information-what-is-it/what-is-personal-data/can-we-identify-an-individual-directly-from-the-information-we-have/), "What if we don't know the individual's name?" |
| A corporate email address identifies its holder directly and also discloses where they work                                                                                                                                                                                                                                                          | Same page, "How do we directly identify someone?"                                                                                                                                                                                                                                         |
| Occupation is listed as one of the "significant criteria" that, combined, can single someone out. Information becomes indirectly identifying when it is combined with other information that distinguishes the person                                                                                                                                | [Can we identify an individual indirectly?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/personal-information-what-is-it/what-is-personal-data/can-we-identify-an-individual-indirectly/), "What kind of information…"                                             |
| Whether a detail identifies someone depends on context. The ICO gives the example of a family name that singles a person out within their workplace but not within the general population                                                                                                                                                            | [How do we ensure anonymisation is effective?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/how-do-we-ensure-anonymisation-is-effective/), "What is singling out?"                                                                      |
| Singling out and linkability are the two key indicators. **Removing direct identifiers alone is insufficient**: if a person can be linked to the information, it is personal data                                                                                                                                                                    | Same page, "What are the key indicators…" and "What is linkability?"                                                                                                                                                                                                                      |
| The test is the means "reasonably likely" to be used, by the holder or by anyone who may gain access. A purely hypothetical chance does not count. Public release calls for more robust techniques than release to known recipients                                                                                                                  | Same page, "At a glance" and the "reasonably likely" section · the indirect page, "very slight possibility"                                                                                                                                                                               |
| The motivated intruder test must be applied. The intruder is assumed to use public records, online search, social media, press archives and generative AI tools. The ICO's own example of prior knowledge is a colleague recognising a fellow employee from an absence statistic                                                                     | Same page, "What is the motivated intruder test?" and "How do we apply…"                                                                                                                                                                                                                  |
| Pseudonymisation means replacing, removing or transforming identifying information and keeping the additional information separate and secure. **Pseudonymised data is in scope of data protection law**, it is a risk-reduction measure and not anonymisation, and it stays personal data in the hands of anyone holding the additional information | [Pseudonymisation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/pseudonymisation/), "At a glance" and "Is pseudonymised data still personal data?"                                                                                      |
| Pseudonymised data shared **without** the additional information may be anonymous in the recipient's hands. That holds only where no means reasonably likely to be used could identify the person                                                                                                                                                    | Same page · effectiveness page, "whose hands?"                                                                                                                                                                                                                                            |
| Even after pseudonymisation, outlier values and rare characteristics can single a person out, so the ICO suggests removing them                                                                                                                                                                                                                      | Pseudonymisation page, "How should we assess the risk of attackers reversing pseudonymisation?"                                                                                                                                                                                           |
| Under DPA 2018 section 171 it is an offence knowingly or recklessly to re-identify de-identified personal data without the controller's consent. "De-identified" is wider than pseudonymised: it includes data with only direct identifiers stripped                                                                                                 | Same page, "Are there any offences relating to pseudonymisation?"                                                                                                                                                                                                                         |

**Applied to the map's example (inference, not an ICO statement).** The redacted text would sit
in a repository that names the client, as the project's subject. In that setting "the client's
Managing Director" usually points to one person. A motivated intruder needs only a public register
of company officers, or the client's own website, to put a name to it. Under the ICO's tests that
text is still personal data. Holding the originals "outside the repo" makes it pseudonymised at
best, and still personal data for the developer who holds them. Whether it is anonymous to a
member of the public reading a public generated repository depends on N-012's visibility answer
(F-09), and is a "whose hands" question the guidance leaves to the controller.

**The ICO's own reuse terms.** ICO website text is under the Open Government Licence v3.0, unless
stated otherwise. Reuse needs the ICO's attribution line. Images are excluded, and the ICO's
rights are unaffected ([ICO copyright and re-use](https://ico.org.uk/global/copyright-and-re-use-of-materials/)).
This note paraphrases throughout, so it reproduces no ICO text.

## Unmeasured

- **The Data (Use and Access) Act 2025's effect on the definition of personal data.** Every ICO
  page read is flagged under review because of it. The Act's own text was not read, so whether it
  changes the identifiability test above is unmeasured.
- **IEEE's reuse terms** for the jointly published 29148.
- **The BABOK v3 copyright page** and the licences on IIBA's free Glossary and Business Analysis
  Standard.
- **Copyright in structure alone.** Whether a re-authored section list or attribute set infringes
  is a question of law and degree. The owners' terms are silent on it, and no court or statute was
  read.

## Sources

- ISO — [ISO/IEC/IEEE 29148:2018](https://www.iso.org/standard/72089.html) ·
  [Copyright](https://www.iso.org/copyright.html) ·
  [Terms and conditions – Licence Agreement](https://www.iso.org/terms-conditions-licence-agreement.html)
- IEEE SA — [Copyright FAQs for participants](https://standards.ieee.org/faqs/copyrights/)
- IIBA — [BABOK Guide](https://www.iiba.org/career-resources/a-business-analysis-professionals-foundation-for-success/babok/) ·
  [Terms of Use](https://www.iiba.org/footer/terms-of-use/) ·
  [Trademarks and Guidelines](https://www.iiba.org/about-iiba/brand-centre-brand-identity-marketing-media/trademarks-and-guidelines/)
- Atlantic Systems Guild — [Volere Requirements Specification Template](https://www.volere.org/templates/volere-requirements-specification-template/) ·
  [Licensing](https://www.volere.org/services/licensing/)
- ICO — [About the anonymisation guidance](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/about-this-guidance/) ·
  [How do we ensure anonymisation is effective?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/how-do-we-ensure-anonymisation-is-effective/) ·
  [Pseudonymisation](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-sharing/anonymisation/pseudonymisation/) ·
  [Can we identify an individual directly?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/personal-information-what-is-it/what-is-personal-data/can-we-identify-an-individual-directly-from-the-information-we-have/) ·
  [Can we identify an individual indirectly?](https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/personal-information-what-is-it/what-is-personal-data/can-we-identify-an-individual-indirectly/) ·
  [Copyright and re-use of materials](https://ico.org.uk/global/copyright-and-re-use-of-materials/)

## Feeds

N-011 (what counts as identifying, the identifiability half), N-023 (the redaction guide) and
S-05's `README.md` _Influences_ criterion in
`project-management/src/01-FEATURE-MAPS/MAP-CLIENT-REQUIREMENTS-AND-FEEDBACK.md`. No ADR is
linked yet; the map is not edited by this note. 23/11/2026.
