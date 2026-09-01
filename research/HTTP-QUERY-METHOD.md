# The HTTP QUERY method — is it usable from a browser today?

**Written**: 01/09/2026 · **Driver**: ad-hoc question — can a safe read carry a request body,
retiring the GET-with-body and POST-as-read workarounds? · **Feeds**: unassigned (see Section 5)

## Question

Is the HTTP QUERY method now usable in all browsers, so that querying an API or a database no
longer needs a GET with parameters stuffed into the URI or a POST pretending to be a read?

## Verdict

**Half yes, and the half that works is not the half that matters.** QUERY became an IETF Proposed
Standard — **RFC 10008**, June 2026 — and `fetch(url, {method: 'QUERY', body})` is already sent on
the wire by Chrome, Firefox and Safari. But it is sent as an **unrecognised extension method**: no
engine implements a single one of RFC 10008's semantics. Nothing caches a QUERY response, nothing
reads `Accept-Query`, `<form method="query">` silently falls back to GET and drops the body, and
every cross-origin QUERY costs a CORS preflight — by design, permanently.

**So the workaround does not go away, it changes shape.** POST-as-read is replaced by
QUERY-as-read, which is _semantically_ honest — the method is registered safe and idempotent, so
retry logic and intermediaries can reason about it — but delivers **no caching**, which is the
main reason a team wants out of POST in the first place. Adopting it today buys correct semantics
and forward-compatibility, and costs a preflight plus a CDN compatibility cliff (CloudFront
rejects the method outright).

---

## 1. The standard — settled, and stronger than expected

| Claim                                                                                                                                                                                                                                                   | Primary source                                                                                                                                                                            |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `draft-ietf-httpbis-safe-method-w-body` was published as **RFC 10008, "The HTTP QUERY Method", Standards Track (Proposed Standard), June 2026** (Reschke, Snell, Bishop). Draft rev -14 posted 18/11/2025; IESG approved 20/11/2025                     | [rfc-editor.org/rfc/rfc10008.html](https://www.rfc-editor.org/rfc/rfc10008.html) · [datatracker history](https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/history/) |
| QUERY is **safe** — the client neither requests nor expects a change to the target resource's state                                                                                                                                                     | RFC 10008 [§2](https://www.rfc-editor.org/rfc/rfc10008.html#section-2)                                                                                                                    |
| QUERY is **idempotent** — it may be retried or repeated, e.g. after a connection failure                                                                                                                                                                | RFC 10008 [§2](https://www.rfc-editor.org/rfc/rfc10008.html#section-2)                                                                                                                    |
| Responses are **cacheable**, and the cache key **must** incorporate the request content — not just the URI                                                                                                                                              | RFC 10008 [§2.7](https://www.rfc-editor.org/rfc/rfc10008.html#section-2.7)                                                                                                                |
| The **body is required in practice**: it carries the query, and a server must fail the request when `Content-Type` is missing or inconsistent with the content. Sniffing a media type from the content is forbidden                                     | RFC 10008 [§2, §2.1](https://www.rfc-editor.org/rfc/rfc10008.html#section-2.1)                                                                                                            |
| **`Accept-Query`** is a response header by which a resource advertises QUERY support and the query media types it takes. It is a Structured Fields **List**, parsed per RFC 8941 despite resembling `Accept`, and applies to every URI sharing the path | RFC 10008 [§3](https://www.rfc-editor.org/rfc/rfc10008.html#section-3)                                                                                                                    |
| The POST-to-GET rewriting exception that browsers apply on 301/302 **does not apply** to QUERY. A 303 means the query is reachable as a plain GET on the `Location` URI                                                                                 | RFC 10008 [§2.5](https://www.rfc-editor.org/rfc/rfc10008.html#section-2.5)                                                                                                                |
| **IANA registration is live**: the HTTP Method Registry (updated 17/06/2026) carries `QUERY — yes (Safe), yes (Idempotent), [RFC10008 §2]`; `Accept-Query` is registered as a permanent field, Structured Type List                                     | [iana.org/assignments/http-methods](https://www.iana.org/assignments/http-methods/http-methods.txt)                                                                                       |
| The RFC anticipates the CORS cost itself: a QUERY **will** require a preflight, since it is not a CORS-safelisted method                                                                                                                                | RFC 10008 [§4](https://www.rfc-editor.org/rfc/rfc10008.html#section-4)                                                                                                                    |
| The RFC concedes QUERY caching is inherently harder than GET caching — the full request content must be read to derive the key — and offers the `Location`-to-GET redirect as the simplifying escape                                                    | RFC 10008 [§2.7](https://www.rfc-editor.org/rfc/rfc10008.html#section-2.7)                                                                                                                |

**The gap this fills, in the RFC's own framing.** GET's content has no defined semantics; POST is
neither safe nor idempotent and its responses are cacheable only for a _later GET_. QUERY is the
one method that is safe, idempotent, and takes its input in the body
([§1, Table 1](https://www.rfc-editor.org/rfc/rfc10008.html#section-1)).

---

## 2. What a browser will actually do — Fetch permits it, and always has

The Fetch Standard contains **zero occurrences of the word QUERY** (full-text search of the
published Living Standard, 1,930,753 bytes, fetched 01/09/2026 — last updated 31/08/2026). Same
for the XHR Standard. Everything below is generic extension-method handling, not QUERY support.

| Claim                                                                                                                                                                                                      | Primary source                                                                                                                                    |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Not forbidden.** The forbidden-method list is exactly `CONNECT`, `TRACE`, `TRACK`. `new Request(url, {method:'QUERY'})` therefore constructs                                                             | Fetch [#forbidden-method](https://fetch.spec.whatwg.org/#forbidden-method) · [#dom-request](https://fetch.spec.whatwg.org/#dom-request)           |
| **A body is permitted.** The constructor throws only when a body accompanies `GET` or `HEAD`. XHR's `send()` likewise nulls the body only for those two                                                    | Fetch [#dom-request](https://fetch.spec.whatwg.org/#dom-request) · XHR [#the-send()-method](<https://xhr.spec.whatwg.org/#the-send()-method>)     |
| **Case is not normalised.** Only `DELETE`, `GET`, `HEAD`, `OPTIONS`, `POST`, `PUT` are byte-uppercased — `{method:'query'}` goes on the wire as lowercase `query` and will very likely 405                 | Fetch [#concept-method-normalize](https://fetch.spec.whatwg.org/#concept-method-normalize)                                                        |
| **Never CORS-safelisted.** The safelist is `GET`, `HEAD`, `POST`. `fetch()` and XHR set the unsafe-request flag, so a cross-origin QUERY **always** preflights, bar a live preflight-cache entry           | Fetch [#cors-safelisted-method](https://fetch.spec.whatwg.org/#cors-safelisted-method) · [#main-fetch](https://fetch.spec.whatwg.org/#main-fetch) |
| The preflight is an `OPTIONS` carrying `Access-Control-Request-Method: QUERY`; the response's `Access-Control-Allow-Methods` must list `QUERY` in those exact bytes, or `*` for a non-credentialed request | Fetch [#cors-preflight-fetch](https://fetch.spec.whatwg.org/#cors-preflight-fetch)                                                                |

**The safelist will not change.** Adding QUERY to it would let any page send a body cross-origin
without the server's opt-in — the preflight is the security boundary, not an oversight, and
[whatwg/fetch#1938](https://github.com/whatwg/fetch/issues/1938) explicitly does not request it.

---

## 3. Engine by engine — nobody has taken a position

Verified against each engine's shipping source on `main`, 01/09/2026. Every engine implements
exactly the Fetch lists above and nothing QUERY-specific.

| Engine       | Position                                                                                                                                                                                                                                                                           | Implementation                                                                                                                               |
| ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **Chromium** | No chromestatus entry, no blink-dev intent, no tracked feature                                                                                                                                                                                                                     | Pass-through only — `IsForbiddenMethod()` covers CONNECT/TRACE/TRACK; `FetchUtils::NormalizeMethod()` uppercases the six classic methods     |
| **Gecko**    | [standards-positions#1430](https://github.com/mozilla/standards-positions/issues/1430) **open, no position label**. One Mozilla comment (07/07/2026): looks generally OK, but the semantics should settle in the Fetch and HTML discussions first. No Bugzilla bug                 | Pass-through only — `FetchUtil::GetValidRequestMethod()` rejects only non-tokens and the three forbidden methods                             |
| **WebKit**   | [#692](https://github.com/WebKit/standards-positions/issues/692) closed as `invalid` (template formality, no ruling on the merits); re-filed as [#709](https://github.com/WebKit/standards-positions/issues/709) 16/08/2026, **still unanswered**, Bugzilla and Radar fields empty | Pass-through only — `FetchRequest.cpp` throws only on invalid tokens or forbidden methods; `methodCanHaveBody()` excludes GET and HEAD alone |

Sources: [chromium `cors.cc`](https://github.com/chromium/chromium/blob/main/services/network/public/cpp/cors/cors.cc) ·
[`fetch_utils.cc`](https://github.com/chromium/chromium/blob/main/third_party/blink/renderer/platform/loader/fetch/fetch_utils.cc) ·
[firefox `FetchUtil.cpp`](https://github.com/mozilla-firefox/firefox/blob/main/dom/fetch/FetchUtil.cpp) ·
[WebKit `FetchRequest.cpp`](https://github.com/WebKit/WebKit/blob/main/Source/WebCore/Modules/fetch/FetchRequest.cpp)

**The documentation surfaces are empty too.** MDN's browser-compat-data
[`http/methods.json`](https://github.com/mdn/browser-compat-data/blob/main/http/methods.json)
holds exactly CONNECT, DELETE, GET, HEAD, OPTIONS, POST, PUT — no QUERY key (open issue
[mdn/content#44665](https://github.com/mdn/content/issues/44665)). caniuse's
[`data.json`](https://github.com/Fyrd/caniuse/blob/main/data.json) has no QUERY feature at all.
**"Can I use it" has no answer because nobody has recorded the question.**

**Two proposals sit at `needs implementer interest`:**

- [whatwg/fetch#1938](https://github.com/whatwg/fetch/issues/1938) — normalisation, CORS and
  body-keyed caching integration.
- [whatwg/html#12594](https://github.com/whatwg/html/issues/12594) — `<form method="query">`. Until
  it lands, the attribute is an invalid enumerated value and **falls back to GET, dropping the body**.

**The caching claim is the one to watch.** The Fetch issue's filer reports testing current Chrome
and Firefox: both cache GET, **neither caches a repeated identical QUERY**. That is a
secondary-source report, not a vendor test suite, and no Safari result exists anywhere — but it
matches the spec position exactly, since no engine implements a body-keyed cache key.

---

## 4. Our own stack — every hop passes it except one CDN

| Hop                | Verdict                                                                                                                                                                                                                                             | Primary source                                                                                                                                                                                                                                                                   |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **nginx**          | **Parses and proxies it verbatim.** Any `A–Z`/`_`/`-` method parses; an unknown one keeps `r->method = NGX_HTTP_UNKNOWN` while `r->method_name` holds the literal text, which `ngx_http_proxy_create_request` writes into the upstream request line | [`ngx_http_parse.c`](https://github.com/nginx/nginx/blob/master/src/http/ngx_http_parse.c) · [`ngx_http_proxy_module.c`](https://github.com/nginx/nginx/blob/master/src/http/modules/ngx_http_proxy_module.c)                                                                    |
| **nginx caveats**  | `limit_except` **cannot name QUERY** (fixed method list), so any `limit_except` block restricts it wholesale. `proxy_cache_methods` accepts only GET/HEAD/POST — **nginx will never cache a QUERY response**                                        | [limit_except](https://nginx.org/en/docs/http/ngx_http_core_module.html#limit_except) · [proxy_cache_methods](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_cache_methods)                                                                                     |
| **Gunicorn**       | **Accepts it with zero config.** The method is validated as an RFC 9110 token, plus default extras banning lowercase/`#` and lengths outside 3–20. `QUERY` — five uppercase letters — passes every check                                            | [`gunicorn/http/message.py`](https://github.com/benoitc/gunicorn/blob/master/gunicorn/http/message.py)                                                                                                                                                                           |
| **Django 6**       | **No method whitelist in the handler path** — `WSGIRequest` just uppercases `REQUEST_METHOD`. `request.body` is readable for any method; only `request.POST` is gated on `method == "POST"`                                                         | [`wsgi.py`](https://github.com/django/django/blob/stable/6.0.x/django/core/handlers/wsgi.py) · [`request.py`](https://github.com/django/django/blob/stable/6.0.x/django/http/request.py)                                                                                         |
| **Django CBVs**    | **405 by default** — `View.http_method_names` omits it. Add `"query"` to the list and define a `query()` handler. `@require_http_methods(["QUERY"])` works as-is (plain membership test, no whitelist)                                              | [`generic/base.py`](https://github.com/django/django/blob/stable/6.0.x/django/views/generic/base.py) · [`decorators/http.py`](https://github.com/django/django/blob/stable/6.0.x/django/views/decorators/http.py)                                                                |
| **Django Ninja**   | **Registrable end to end.** `Router.api_operation(methods=["QUERY"], ...)` takes an unvalidated `List[str]`; dispatch is an exact string match against `request.method` (so register it uppercase); body parsing has **no method gate**             | [`router.py`](https://github.com/vitalik/django-ninja/blob/master/ninja/router.py) · [`operation.py`](https://github.com/vitalik/django-ninja/blob/master/ninja/operation.py) · [`params/models.py`](https://github.com/vitalik/django-ninja/blob/master/ninja/params/models.py) |
| **Fastly**         | **Passes it through as received** (only PURGE is rewritten). Not cached — only GET/HEAD/PURGE trigger a lookup                                                                                                                                      | [req.method](https://www.fastly.com/documentation/reference/vcl/variables/client-request/req-method) · [vcl_recv](https://www.fastly.com/documentation/reference/vcl/subroutines/recv)                                                                                           |
| **Cloudflare**     | **Probably passes it** — Cloudflare does not itself generate 405s, and the Workers runtime supports every method but CONNECT. Not cached (anything other than GET is skipped by default). _Inference, not a stated guarantee — see Section 6_       | [Error 405](https://developers.cloudflare.com/support/troubleshooting/http-status-codes/4xx-client-error/error-405/) · [Default cache behavior](https://developers.cloudflare.com/cache/concepts/default-cache-behavior/)                                                        |
| **AWS CloudFront** | **Hard stop.** It forwards a closed list — DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT. **QUERY cannot traverse a CloudFront distribution**                                                                                                        | [Request behavior, custom origins](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/RequestAndResponseBehaviorCustomOrigin.html#RequestCustomHTTPMethods)                                                                                                      |

**No intermediary anywhere in this chain caches QUERY by default.** That is the finding that
decides the question: the cacheability RFC 10008 grants is theoretical until browsers and proxies
implement a body-derived cache key, and none has.

---

## 5. What this means for us

**Nothing changes today, and there is no decision waiting on it** — this template has no endpoint
whose URI length or POST-as-read semantics currently hurt. Recorded here so the next API-design
grilling does not re-derive it.

**If an endpoint ever needs a body on a read** — a complex filter payload, a search DSL, an
identifier list past a URI limit — the shape is:

1. Register the operation for **both** `POST` and `QUERY` on one path, uppercase, via
   `api_operation`. One handler, one Schema; the body parser does not care which arrived.
2. Answer `Accept-Query` so a future client can discover the surface, and keep POST as the floor.
3. Expect a preflight on every cross-origin call; list `QUERY` literally in
   `Access-Control-Allow-Methods`.
4. **Do not put a CloudFront distribution in front of that path.** nginx and Fastly are fine.
5. Where the result genuinely needs caching, use RFC 10008 §2.5's own answer — respond `303` with a
   `Location` pointing at a GET-able result resource. That is the only route to a cached query
   today, and it works in every browser now.

**No ADR yet.** When one is written it takes the next free `ADR-###` in
`project-management/src/15-DECISIONS/` and links back to this note by path.

---

## 6. What is not settled

- **No empirical browser test was run here** — the Chrome extension was not paired, so
  "Chrome/Firefox/Safari send it" rests on the Fetch Standard plus each engine's shipping source,
  not on an observed request. The one reported live test (Chrome and Firefox send it; neither
  caches it) is the standards-position filer's own, and **no Safari result exists in any source**.
- **Cloudflare's edge handling of unknown methods is inferred**, not documented. No Cloudflare page
  states whether an unrecognised method reaches the origin.
- **CloudFront's rejection status code** (405 vs 403) is not stated on the documented page — only
  the closed list of forwarded methods.
- **Source claims were read against branch heads** — Django `stable/6.0.x`, django-ninja `master`,
  gunicorn `master`, nginx `master` — not the exact pinned releases; and **Django's ASGI handler
  was not checked**, only WSGI. Relevant if this stack serves via ASGI, which the FastMCP mount in
  `config/asgi.py` implies it does.
- **Django Ninja's OpenAPI output for a QUERY operation** was not investigated — registration,
  dispatch and body parsing were, schema generation was not.
- **web-platform-tests coverage** was not verified against the wpt repository; Mozilla's filing
  implies none exists yet.

---

## Sources

**Standards** — [RFC 10008](https://www.rfc-editor.org/rfc/rfc10008.html) ·
[IETF datatracker](https://datatracker.ietf.org/doc/draft-ietf-httpbis-safe-method-w-body/) ·
[IANA HTTP Method Registry](https://www.iana.org/assignments/http-methods/http-methods.txt) ·
[WHATWG Fetch](https://fetch.spec.whatwg.org/) ·
[WHATWG XMLHttpRequest](https://xhr.spec.whatwg.org/)

**Engines** — Chromium `cors.cc`, `fetch_utils.cc` · Firefox `FetchUtil.cpp`, `Request.cpp` ·
WebKit `FetchRequest.cpp` · [mozilla/standards-positions#1430](https://github.com/mozilla/standards-positions/issues/1430) ·
[WebKit/standards-positions#709](https://github.com/WebKit/standards-positions/issues/709) ·
[whatwg/fetch#1938](https://github.com/whatwg/fetch/issues/1938) ·
[whatwg/html#12594](https://github.com/whatwg/html/issues/12594) ·
[MDN browser-compat-data](https://github.com/mdn/browser-compat-data/blob/main/http/methods.json) ·
[caniuse](https://github.com/Fyrd/caniuse/blob/main/data.json)

**Stack** — Django 6 `wsgi.py`, `request.py`, `generic/base.py`, `decorators/http.py` ·
django-ninja `router.py`, `operation.py`, `params/models.py` · gunicorn `http/message.py`,
`config.py` · nginx `ngx_http_parse.c`, `ngx_http_request.c`, `ngx_http_proxy_module.c` and the
`limit_except` / `proxy_cache_methods` directive docs · Fastly VCL reference · Cloudflare cache and
support docs · AWS CloudFront developer guide

**Note on quoting**: no verbatim text is reproduced from any source above; every claim is
re-authored and cited to the source that owns it, per `research/CLAUDE.md`.
