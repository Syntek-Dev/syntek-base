---
type: guide
skills: [backend, stack-django, stack-htmx-templates]
model: opus
---

# Performance — API, Background Jobs, Monitoring

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — API performance, response compression, background job queues, monitoring

---

## API and Network Performance

The application API is a **Django Ninja** JSON API serving machine clients — integrations,
webhooks, and any future mobile app. The site itself does not call it: pages use HTMX against
Django views that return HTML. Ninja auto-generates OpenAPI docs at `/api/docs`.

- **Minimise request count.** Prefer one endpoint that returns all the data a consumer needs over
  several round-trips. Shape each endpoint's response `Schema` (Pydantic) to include the related
  data in one go, rather than forcing follow-up calls.
- **Compress responses.** Enable gzip or Brotli on all text-based responses (JSON, HTML, CSS, JS),
  typically at the reverse proxy (Nginx).
- **Use connection keep-alive.** HTTP/2 multiplexing eliminates the need for domain sharding.
- **Avoid over-fetching.** Return only the fields the consumer needs — define a response `Schema`
  per endpoint. Where one endpoint serves several consumers, offer a sparse-fieldset query param
  (`?fields=id,status,total`) or dedicated Schema variants rather than one fat payload.
- **Validate at the edge.** A Ninja request `Schema` rejects malformed input before it reaches a
  service — cheaper than failing deep in the call stack — and throttling middleware caps abusive
  callers.
- **Set timeouts.** Every outbound HTTP call (Cloudinary, third parties) must have a connect
  timeout (5s) and read timeout (30s). Never make unbounded HTTP calls.

> DRF and FastAPI share the same request/response-schema discipline as a portable reference; the
> primary framework here is Django Ninja.

---

## Background Jobs and Queues (Celery)

**A failed job is an error in the error tracker, and is logged and monitored.** A failed job
that nobody notices is worse than no job: the request that queued it already returned success, so the queue is the only place the
failure exists. Error tracking and alert routing are [`../LOGGING.md`](../LOGGING.md).

Whether work belongs on a queue, and how a task is written, is [`../TASK-AUTHORING.md`](../TASK-AUTHORING.md); whether a retry is safe and
how it backs off is [`../RELIABILITY.md`](../RELIABILITY.md).

---

## Monitoring and Measurement

You cannot improve what you do not measure.

### Metrics to track

| Metric                          | Target   | Tool                         |
| ------------------------------- | -------- | ---------------------------- |
| Time to First Byte (TTFB)       | < 200ms  | Prometheus / Grafana         |
| Largest Contentful Paint (LCP)  | < 2.5s   | Lighthouse, Web Vitals       |
| Interaction to Next Paint (INP) | < 200ms  | Web Vitals                   |
| Cumulative Layout Shift (CLS)   | < 0.1    | Lighthouse, Web Vitals       |
| API response time (p95)         | < 500ms  | Sentry/GlitchTip, Prometheus |
| Database query time (p95)       | < 50ms   | Slow query log, Prometheus   |
| Page weight, first load         | < 150 KB | Manual check / Lighthouse    |
| Error rate                      | < 0.1%   | Sentry/GlitchTip             |

### Production monitoring

- Enable slow query logging in PostgreSQL (`log_min_duration_statement = 200`).
- Track request durations, database query counts, and external API call times with Sentry/GlitchTip
  (errors + tracing) and Prometheus (metrics); ship logs to Loki and telemetry via Alloy, and
  visualise on Grafana.
- Set up alerts for p95 response time exceeding the target and error rate exceeding the threshold.

---

## Load Testing

See `TESTING.md` — Performance and Load Testing for tools and examples.

### When to load test

- Before any release that changes database queries, caching, or serialisation in a high-traffic
  path.
- After adding a new tenant or significantly increasing the user base.
- When introducing a new backing service.
- When a production incident is traced to a performance regression.

### Load testing rules

- Test against a staging environment with production-like data volume. Do not test against an
  empty database.
- Establish baselines for critical endpoints. A regression of more than 20% in p95 response time
  requires investigation.
- Test with realistic concurrency patterns, not just maximum throughput. Simulate ramp-up,
  sustained load, and spike scenarios.
- Include database-heavy operations (reports, exports, search) in load tests, not just lightweight
  endpoints.

---

## Performance Checklist

Before deploying performance-sensitive changes:

- [ ] N+1 queries are eliminated (`select_related`/`prefetch_related` in Django)
- [ ] Lazy-loading detection is enabled in development (`nplusone` in Django)
- [ ] All collection endpoints are paginated with enforced limits
- [ ] `EXPLAIN ANALYZE` confirms that hot queries use indexes, not full table scans
- [ ] Cache keys include tenant/user scope where data is scoped
- [ ] Cached values have explicit TTL or invalidation triggers
- [ ] First-load page weight is within the budget in `FRONTEND-PERFORMANCE.md`
- [ ] Expensive template fragments are cached by versioned key
- [ ] Images are delivered via Cloudinary (`f_auto`/`q_auto`), responsive sizes, `loading="lazy"`
      below the fold
- [ ] HTMX responses return the smallest partial; chatty triggers are debounced
- [ ] Background jobs are idempotent with retries and back-off ([`../RELIABILITY.md`](../RELIABILITY.md))
- [ ] Database connection pooling is configured
- [ ] API responses are compressed (gzip/Brotli)
- [ ] Core Web Vitals targets are met (LCP < 2.5s, INP < 200ms, CLS < 0.1)
- [ ] Database scaling tier matches current load — phase gate observed before adding infrastructure
- [ ] Read replica queries do not require read-after-write consistency
- [ ] Cross-shard queries (Phase 2 only) are background Celery tasks, never on the request path

_Part of the `code/docs/` documentation family. See [`../PERFORMANCE.md`](../PERFORMANCE.md) for the full index._
