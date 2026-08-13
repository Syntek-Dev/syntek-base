---
type: guide
skills: [planner, codebase-design, domain-modelling]
model: fable
---

# Provider Neutrality — Interfaces, Seams and Substrate

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** fable — deciding whether a dependency is a seam or substrate, and what evidence
that claim needs

How this project decides whether an infrastructure dependency is something a project may swap or
something the code is written against — and what a claim of neutrality has to prove before it is
allowed to stand.

**This document owns the rule.** The register of what each component actually resolves to in this
project lives on the operate side, in
[`how-to/src/PLATFORM-PROVIDERS.md`](../../../how-to/src/PLATFORM-PROVIDERS.md), because those
answers change per project and this rule does not.

---

## The problem this solves

A template that hard-codes SeaweedFS, GlitchTip, Loki and Grafana ships someone else's
infrastructure choice as though it were a standard. A template that refuses to name any product
produces guides that say _"use an error tracker"_ and help nobody.

The resolution is neither. **Lead with the interface; name the product as a default behind it.**
The product name is not the problem — a product name standing where an interface should be is.

---

## The two seam kinds

`SERVICE-AND-MIDDLEWARE.md` states the governing rule:

> **One adapter is a hypothetical seam; two adapters are a real seam.**

Read naively that rule kills most of this document, because swapping SeaweedFS for MinIO changes
an environment variable and no code at all — there is exactly one code path, so by a literal
reading there is exactly one adapter and therefore no seam.

That reading is wrong, and the reason is worth stating precisely: **the rule is about
implementations that vary, not about code paths that exist.** When the varying implementations
live behind a wire protocol, they vary on the far side of the socket rather than inside this
repository. The seam is real; it simply is not made of Python.

So there are two kinds, and they carry **different evidence bars**.

### Protocol seam

The interface is a **wire protocol or exposition format** with **at least two independent
implementations already shipping in the world**.

**Evidence required — all three:**

1. The protocol is **named** in the guide, not merely implied by a product.
2. The code speaks the protocol through the protocol's **own client** (`boto3`, `sentry-sdk`,
   a Prometheus client, an OTLP exporter) — never a vendor SDK wrapping it.
3. **No product-specific API is touched.** One call to a SeaweedFS admin endpoint, one GlitchTip-only
   field, and the seam is gone — silently, and usually years before anyone tries to swap.

**No second code path is required, and demanding one is waste.** Writing a second adapter to prove
a seam the protocol already guarantees is the abstraction `SERVICE-AND-MIDDLEWARE.md` warns against,
arrived at from the opposite direction.

Point (3) is the whole of the discipline. Points (1) and (2) are satisfied once, at design time;
point (3) is violated later, by a small convenience, in a pull request nobody reads twice.

### Adapter seam

**No wire protocol exists.** The interface is one this project defines.

**Evidence required:** the original rule, unchanged — a **second real implementation**, or the
seam is not claimed. `services/git_writeback.py` is the worked example: a provider-agnostic
Contents-API adapter over GitHub, GitLab and Forgejo. Three implementations, one interface, a
genuinely real seam ([`../design-tokens/CASCADE.md`](../design-tokens/CASCADE.md)).

An adapter seam with one implementation is a **hypothetical seam**. Say so in the register rather
than quietly claiming neutrality — a claim nobody has tested is worse than an acknowledged
coupling, because it gets budgeted for.

---

## The substrate test

Not every dependency should be a seam. The test is one question:

> **Does swapping it change application code, or only configuration?**

| Answer             | Verdict       |
| ------------------ | ------------- |
| Only configuration | **Seam**      |
| Application code   | **Substrate** |

**PostgreSQL is substrate**, and the reason generalises rather than being asserted: the code is
written against Postgres-specific semantics throughout — row-level security policies, `JSONB`,
`CHECK` constraints, concurrent index builds, and the `ACCESS EXCLUSIVE` lock reasoning that
governs every migration ([`../DATABASE.md`](../DATABASE.md)). Swapping it rewrites the data layer.
That is a fork, not an answer to a question.

Substrate is not a failure. It is a decision to spend the coupling somewhere it buys depth. What
is not acceptable is leaving a component **unclassified** — silence reads as "seam" to anyone
who wants it to, and as "substrate" to anyone who does not.

**Every infrastructure dependency carries a verdict and a reason** in the register. No exceptions,
including the ones where the answer is obvious.

---

## How a guide expresses this

Any guide documenting a provider-backed capability opens with this block, before prose:

```markdown
**Interface:** the S3 API, consumed via boto3
**Seam kind:** protocol
**Default:** <%OBJECT_STORE%>
**Proven alternates:** MinIO · Garage · Ceph RGW · AWS S3 · Cloudflare R2 · Backblaze B2
```

Rules for the surrounding prose:

- **Headings name the interface, never the product.** `## Error tracking`, not `## GlitchTip`. A
  product name in a heading is the specific defect this rule exists to prevent.
- **The product may be named freely in the body** as the default. Stripping product names produces
  the unhelpful-neutrality failure, not neutrality.
- **The default is a token, not a literal**, so a project that answered differently reads its own
  choice. Tokens: [`how-to/src/TEMPLATE-TOKENS.md`](../../../how-to/src/TEMPLATE-TOKENS.md).
- **Substrate says so outright**, with its reason, and does not list alternates.

### Three exceptions, each with its reason

**1. A contract names the product.** The heading rule binds the **build side** (`code/docs/`),
where a guide explains why something is done. It does not bind the **operate side**
(`how-to/src/SERVER-ARCHITECTURE/`), which is a contract another repository implements: an
instruction to _"provision a metrics scraper"_ cannot be implemented.
[`BUILD-OPERATE-SEAM.md`](BUILD-OPERATE-SEAM.md) already establishes that the two sides have
different jobs; this is that split applied to naming. The contract still names **the project's**
product rather than the template's, so the value is a token wherever one exists. The line is drawn
on what a file _is_ — the same test that scoped the `**Source:**` field to `SERVER-ARCHITECTURE/`
and not `SCALE-ARCHITECTURE/`, which is reasoning rather than contract.

**2. A token goes where its value fits.** Some provider tokens resolve to a phrase rather than a
bare product name — `OBSERVABILITY_STACK` is `Prometheus + Grafana`, `HOSTING_PROVIDER` is
`Self-hosted — NixOS on bare metal`. Those read correctly in a table cell and break mid-sentence.
**A phrase-valued token is cell-only**; a token used in running prose must resolve to a bare name.
Which token is which is recorded in
[`how-to/src/TEMPLATE-TOKENS.md`](../../../how-to/src/TEMPLATE-TOKENS.md). Reshaping a token to be
prose-safe is the cheaper fix, and the reason the parenthetical belongs in the question's `help:`
text rather than in its default.

**3. An identifier follows the interface, never the token.** Environment variables, NixOS
attribute paths and secret filenames are code. `SENTRY_DSN` is correct because the SDK's own
convention names the protocol; `GLITCHTIP_DSN` names the product. A token in that position would
turn a generation answer into a code symbol, which is a different mistake from the one this rule
prevents.

**A heading that compares two implementations is not a heading naming one.**
[`../api-design/EVENT-TRACKING.md`](../api-design/EVENT-TRACKING.md) § _Plausible vs an own store_
stands, and is recorded here so nobody repairs it: the defect this rule catches is a product
standing **where an interface should be**, and a product standing beside another product is a
comparison.

---

## Why there is no audit script

The shipped audits (`css-tokens.sh`, `css-gradients.sh`, `copy-emdash.sh`) prove that a
deterministic gate is worth building **when the rule is mechanically decidable**. This one is not,
and the boundary is worth naming rather than discovering through false failures:

- **A code scan is vacuous here.** The template ships no application code beyond the Django
  skeleton, so a scan for product-specific API usage has nothing to read. It would pass green in
  this repository and be untested doctrine on the day a generated project first violated it.
- **A docs scan cannot make the judgement.** The rule turns on _product named as a default_
  (correct, and the entire point) versus _product named in place of an interface_ (wrong). No grep
  distinguishes those. An audit that tried would fire on the guides that follow the rule best.

So enforcement is **doctrine plus review**, and it is honest about being that:

| Mechanism           | Where                                                                           |
| ------------------- | ------------------------------------------------------------------------------- |
| Review clause       | `code-reviewer`, `backend`, `planner`                                           |
| Definition of done  | Adding any infrastructure dependency adds its register row, verdict + reason    |
| The register itself | [`how-to/src/PLATFORM-PROVIDERS.md`](../../../how-to/src/PLATFORM-PROVIDERS.md) |

If a project later grows enough application code that point (3) above becomes greppable — imports
and call sites outside the named protocol clients — that is the moment to revisit this section,
not before.

---

## Cross-references

- [`BUILD-OPERATE-SEAM.md`](BUILD-OPERATE-SEAM.md) — the sibling rule governing **where** these
  facts live. The rule/register split this document uses (doctrine here, per-project answers in
  `how-to/src/`) is that convention applied; a guide written under this rule states its ownership
  sentence and its `SERVER-ARCHITECTURE/` counterpart carries the matching `**Source:**` field
- [`SERVICE-AND-MIDDLEWARE.md`](SERVICE-AND-MIDDLEWARE.md) — deep modules, and the two-adapter
  rule this document refines rather than contradicts
- [`../DATABASE.md`](../DATABASE.md) — PostgreSQL as fixed substrate
- [`../design-tokens/CASCADE.md`](../design-tokens/CASCADE.md) — the worked adapter seam
- [`how-to/src/PLATFORM-PROVIDERS.md`](../../../how-to/src/PLATFORM-PROVIDERS.md) — the register
- [`how-to/src/TEMPLATE-TOKENS.md`](../../../how-to/src/TEMPLATE-TOKENS.md) — the provider tokens

_Part of the `code/docs/` documentation family._
