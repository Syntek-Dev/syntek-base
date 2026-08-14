---
type: guide
skills: [logging, stack-htmx-templates]
model: opus
---

# Logging — Browser

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — browser logging: Sentry browser SDK, project logger, no Node server

---

## There is no server-side JS logger

The site is Django-server-rendered throughout — templates + django-components + HTMX + Alpine. The
application runs no JavaScript server and has no client-side framework, so all server logging is
Django logging only — see [`DJANGO-LOGGING.md`](DJANGO-LOGGING.md).

Very little JavaScript reaches the browser, which means browser logging is a small surface with two
jobs:

1. **Capture unhandled errors** to GlitchTip via the Sentry browser SDK.
2. **Provide a small project logger** for deliberate, level-aware logging in Alpine and per-page
   scripts — dev-only console output, with errors forwarded to Sentry in staging/prod.

---

## Configuration reaches the browser through the page

There is no build step, so there is no `import.meta.env` and no compile-time variable substitution.
The DSN is a Django setting rendered into the page as a `<meta>` tag, and the script reads it from
the DOM. CSP forbids inline `<script>`, so it cannot be interpolated into a script body
(`code/docs/RENDERING.md`).

```django
{# base.html #}
<meta name="sentry-dsn" content="{{ SENTRY_BROWSER_DSN|default:'' }}" />
<meta name="app-env" content="{{ ENVIRONMENT }}" />
<script defer src="{% static 'js/observability.js' %}"></script>
```

Leave the setting empty in dev and test — the SDK then initialises as a no-op. The browser DSN is a
**separate** DSN from the Django backend one; GlitchTip creates one per project.

---

## Sentry browser SDK — unhandled error capture

Load `@sentry/browser` as a versioned, content-hashed static asset alongside HTMX and Alpine, and
initialise it once from `observability.js`:

```javascript
// code/src/django/static/js/observability.js
const dsn = document.querySelector('meta[name="sentry-dsn"]')?.content;

if (dsn) {
  Sentry.init({
    dsn,
    tracesSampleRate: 0.1,
    sendDefaultPii: false, // GDPR: never send PII automatically
  });
}
```

**HTMX errors are not JavaScript errors.** A failed swap raises an HTMX event rather than throwing,
so the SDK will not see it unless you forward it. Do that once, globally, rather than per element:

```javascript
document.body.addEventListener("htmx:responseError", (event) => {
  Sentry.captureMessage("htmx response error", {
    level: "error",
    extra: { status: event.detail.xhr.status, path: event.detail.requestConfig.path },
  });
});

document.body.addEventListener("htmx:sendError", () => {
  Sentry.captureMessage("htmx network error", { level: "error" });
});
```

Never put the request body or a form's field values in the `extra` payload — the path and status
are enough to locate the failure, and the body may carry PII.

---

## The project logger

A thin wrapper gives a single, lint-clean logging surface. In dev it prints to the browser console;
in staging/prod it stays quiet at `debug`/`info` and forwards `warn`/`error` to Sentry.

```javascript
// code/src/django/static/js/logger.js
const isDev = document.querySelector('meta[name="app-env"]')?.content === "development";

export const logger = {
  debug(message, fields) {
    if (isDev) console.debug(message, fields ?? {});
  },
  info(message, fields) {
    if (isDev) console.info(message, fields ?? {});
  },
  warn(message, fields) {
    if (isDev) console.warn(message, fields ?? {});
    else Sentry.captureMessage(message, { level: "warning", extra: fields });
  },
  error(message, fields) {
    if (isDev) console.error(message, fields ?? {});
    else Sentry.captureMessage(message, { level: "error", extra: fields });
  },
};
```

---

## Where browser logging is _not_ the answer

On a server-rendered stack most of what you would want to log has already happened on the server,
where the logging is richer, the context is complete, and nothing depends on the user's browser
reporting back. Before adding a browser log, check whether the event is visible in Django:

| Event                        | Log it in                                                      |
| ---------------------------- | -------------------------------------------------------------- |
| A form failed validation     | **Django** — the view already knows                            |
| A save succeeded             | **Django** — the view already knows                            |
| An HTMX request 500'd        | **Django** (the exception) — the browser side is a duplicate   |
| An HTMX request never landed | **Browser** — only the client can see a network failure        |
| A script threw               | **Browser** — the server cannot see it                         |
| An Alpine interaction broke  | **Browser** — but ask first why the logic is not on the server |

---

## Dev vs staging/prod behaviour

| Environment    | `logger.*` output                                  | Unhandled errors                                    |
| -------------- | -------------------------------------------------- | --------------------------------------------------- |
| dev / test     | Browser DevTools console (readable)                | Surfaced in the console; Sentry is a no-op (no DSN) |
| staging / prod | `debug`/`info` suppressed; `warn`/`error` → Sentry | Captured automatically by the Sentry browser SDK    |

There is no browser log file and no frontend container log — browser errors reach the observability
stack **only** through GlitchTip, never through Loki.

---

## Rules

| Never commit this               | Always use this instead                                     |
| ------------------------------- | ----------------------------------------------------------- |
| `console.log("state:", x)`      | `logger.debug("state", { x })` (dev-only sink)              |
| `console.error("failed:", err)` | `logger.error("save failed", { err })` → forwards to Sentry |
| A caught error swallowed        | `Sentry.captureException(err)` then rethrow or handle       |

Bare `console.*` is banned in committed JavaScript. Use the browser DevTools console for ad-hoc
inspection during development only.

_Part of the `code/docs/` documentation family. See [`../LOGGING.md`](../LOGGING.md) for the full index._
