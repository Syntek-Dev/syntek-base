---
type: guide
skills: [stack-react-native]
model: opus
---

# App Store Listing — being found by store search

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — the store-listing text fields, the limits they must fit, and which of
them this repository can check

**Mobile-only.** Present only in a project generated with the mobile surface.

The other four guides in this family own the `<head>`, the JSON-LD block, the root files and the
page body — four artefacts of **one deployable**, the Django project. This one owns a fifth
artefact that belongs to a **different deployable**: the App Store and Google Play listing for
`code/src/mobile/`.

It is here rather than in a family of its own because the destination is the same. A person
looking for this product searches somewhere; this guide covers the somewhere that is a store.

---

## 1. The fields and their limits

The limits are the **interface**. They are set by Apple and Google, they change without notice,
and they are the reason a listing is written to a shape rather than to taste.

| Field                 | Apple App Store         | Google Play          |
| --------------------- | ----------------------- | -------------------- |
| App name              | 2–30 characters         | 30 characters        |
| Subtitle              | 30 characters           | —                    |
| Short description     | —                       | 80 characters        |
| Keywords              | **100 bytes** (see § 2) | _no keyword field_   |
| Description           | 4000 characters         | 4000 characters      |
| Promotional text      | 170 characters          | —                    |
| What's New in version | 4000 characters         | _see the note below_ |

- **Source (Apple):** App Store Connect Help —
  [App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
  and
  [Platform version information](https://developer.apple.com/help/app-store-connect/reference/platform-version-information/)
  · **Verified:** 11/08/2026
- **Source (Google Play):** Play Console Help —
  [Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152)
  · **Verified:** 11/08/2026

**Google Play's release-notes field is deliberately absent from the table.** It exists, and it is
limited; the pages cited above do not state the figure, and this guide carries no number it has
not read from a primary source. Read the limit off the Play Console field itself and record it
with the project's listing, not here.

**Re-verify before writing a listing, not on a schedule.** The dates above are what makes a stale
figure visible. A table without them looks equally true a year after it stops being true.

---

## 2. Apple counts bytes; Google counts characters

Apple, on the keywords field:

> You can provide up to **100 bytes** of content.

Google, on all three of its fields:

> Character limits apply to both full-width and half-width characters — the numbers listed above
> are the maximum limits regardless of what type of characters you are using.

**These are different units, and almost every third-party ASO source states Apple's as "100
characters".** For an ASCII-only listing the two coincide, which is why the error survives. They
diverge the moment a listing is localised: in UTF-8 an accented Latin character costs two bytes,
and most CJK characters cost three. A keyword set that measures 100 characters can be rejected at
a third of its apparent length.

**Count bytes for Apple.** `len(text.encode("utf-8"))`, never `len(text)`.

This section exists for the same reason [`CONTENT-STRUCTURE.md`](CONTENT-STRUCTURE.md) § 1 exists:
the incorrect figure is not merely absent from this repository, it is **actively circulating
everywhere a developer would go to check**.

---

## 3. The rules

### `app.json` is not the store listing

`code/src/mobile/app.json` sets `expo.name` — the name **under the icon on the device**. The
store listing name is entered in App Store Connect and the Play Console, and is a different
field that can hold a different string.

Treat any divergence as a decision, never as a default. Two names for one product is a
discoverability cost and a trust cost; if they differ, someone chose that.

### Never spend keywords on the app name or the developer name

Apple's own instruction, on the keywords field:

> Your app is searchable by app name and company name, so you shouldn't duplicate these values in
> the keyword list. Names of other apps or companies aren't allowed.

Two consequences: duplication wastes a hard 100-byte budget on terms already indexed, and naming
a competitor is a rejection risk, not a tactic.

### The description is plain text

Apple states that the description is plain text with line breaks, and that **HTML is not
supported**. Markup written into it ships as literal characters.

### Promotional text is the field that moves

Apple's promotional text is editable **without submitting a new version**. That is what it is
for: a sale, a seasonal message, a launch. Rewriting the description for a time-limited claim
couples marketing copy to the release cycle and leaves the claim standing after it expires.

### The words are marketing register

Store-listing copy is customer-facing marketing text and is written in the register
`how-to/src/BRAND-VOICE.md` settles — the same rule the page body follows. This guide owns the
**shape and the limits**; the voice is not its to set.

---

## 4. Limits are the rule; the listing is the instance

This guide holds what is true of **every** project shipping to these stores. What this project's
listing actually says — its name, subtitle, keyword set and descriptions — is per-project
content, and it lives in **`how-to/src/STORE-LISTING.md`**, beside the other per-project answer
sheets rather than in a guide that ships to everyone.

Same split as [`../architecture/PROVIDER-NEUTRALITY.md`](../architecture/PROVIDER-NEUTRALITY.md)
and its register: the rule is doctrine, the choice is a record. A guide that hard-codes one
project's keyword set has stopped being a guide.

**The register repeats the limits; this guide still owns them.** That is deliberate — a value
column with no target beside it cannot be reviewed. What is **not** repeated is the provenance:
the `Source:` and `Verified:` fields in § 1 exist in this file only, because a date duplicated is
a date that goes stale in one copy while still looking authoritative in the other. If the two
disagree, **this guide is right and the register is stale.**

---

## 5. What this guide does not own

| Concern                                                    | Owner                                                                           |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Screenshots, preview video, the app icon                   | [`../visual-design/MOBILE.md`](../visual-design/MOBILE.md)                      |
| Privacy nutrition labels, Data Safety declarations         | `project-management/src/09-GDPR/` and `project-management/docs/GDPR-GUIDE.md`   |
| Deep links, universal links, app-site association          | [`../URL-STRATEGY.md`](../URL-STRATEGY.md)                                      |
| Version numbering and release monotonicity                 | `project-management/docs/VERSIONING-GUIDE.md`                                   |
| The words' tone and register                               | `how-to/src/BRAND-VOICE.md`                                                     |
| Everything about the web surface                           | The other four guides in this family                                            |
| Keyword research, competitor analysis, ratings and reviews | **Nothing here.** Growth activities — no guide in this repository consumes them |

The last row is the same boundary [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) draws for
backlinks and PR on the web side, applied to the store. It is not a gap.

---

## What is mechanically checkable here

**One thing, and it is not the important thing.** `code/src/mobile/app.json` is in the repository,
so `expo.name` can be length-checked against the 30-character limit both stores share.

Every other field in § 1 lives in App Store Connect or the Play Console. Nothing in this
repository can see them, so nothing here can gate them — including the byte count in § 2, which is
the rule most likely to be got wrong.

That makes the listing a **review artefact, not an audit artefact**. Treat a green pipeline as
saying nothing at all about it.

---

## Cross-references

- [`../DISCOVERABILITY.md`](../DISCOVERABILITY.md) — the index and the seam statement
- [`CONTENT-STRUCTURE.md`](CONTENT-STRUCTURE.md) — the body of a web page; § 1 is the precedent
  for § 2 here
- [`../visual-design/MOBILE.md`](../visual-design/MOBILE.md) — the mobile visual surface, which
  owns the listing's imagery
- [`../architecture/PROVIDER-NEUTRALITY.md`](../architecture/PROVIDER-NEUTRALITY.md) — the
  rule-versus-instance split § 4 applies
- `how-to/src/BRAND-VOICE.md` — the register the listing copy is written in
- [Apple — App information](https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/)
  · [Apple — Platform version information](https://developer.apple.com/help/app-store-connect/reference/platform-version-information/)
- [Google Play — Create and set up your app](https://support.google.com/googleplay/android-developer/answer/9859152)

_Part of the `code/docs/` documentation family._
