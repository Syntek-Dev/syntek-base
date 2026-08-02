---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security — Secrets Management, Transport Security, Container Security

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Secrets management, transport encryption, and container security hardening

---

## Secrets Management

**Never hardcode secrets.** This is an absolute rule with no exceptions.

- All secrets, API keys, tokens, and credentials must be stored in environment variables.
- Environment variable files (`.env.*`) must never be committed to version control.
- Each environment (development, test, staging, production) uses a separate set of credentials.
- Provide `.env.*.example` files with placeholder values — never the real values.
- In production, use a secrets manager (HashiCorp Vault, AWS Secrets Manager, or equivalent).
- Rotate all secrets immediately if a breach is suspected.

### Repository hygiene

- Run `git diff --cached` before every commit and verify no secrets are staged.
- Use pre-commit hooks (`gitleaks`, `detect-secrets`) to block accidental secret commits.
- If a secret is accidentally committed, treat it as compromised and rotate it immediately.

---

## Transport Security

All communication between clients, services, and backing systems must be encrypted in transit.

### TLS configuration

- **Minimum version: TLS 1.2.** Prefer TLS 1.3. TLS 1.0 and 1.1 must be disabled.
- Disable insecure cipher suites: RC4, DES, 3DES, export ciphers, NULL ciphers.
- Prefer forward-secrecy cipher suites (ECDHE).
- Certificates must be from a trusted Certificate Authority.

### HSTS (HTTP Strict Transport Security)

```text
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

- Set `max-age` to at least one year (31536000 seconds).
- Include `includeSubDomains` to cover all subdomains.
- Never deploy HSTS without first confirming all resources are accessible over HTTPS.

### Internal service communication

- Services communicating within a private network should still use TLS or mTLS.
- Never send credentials, tokens, or PII over unencrypted channels, even within a private network.

---

## Container Security

### Image security

- **Use minimal base images.** Prefer `*-slim`, `alpine`, or distroless images.
- **Pin base image versions.** Use digest pinning or specific tags. Never use `latest`.
- **Scan images for vulnerabilities** before deployment. Use `trivy`, `grype`, or Docker Scout.
- **Do not install unnecessary tools** in production images.

### Runtime security

- **Run as a non-root user.** Every Dockerfile must include a `USER` directive.

```dockerfile
RUN addgroup --system app && adduser --system --ingroup app app
USER app
```

- **Use read-only filesystems** where possible.

```yaml
services:
  app:
    read_only: true
    tmpfs:
      - /tmp
    volumes:
      - uploads:/app/uploads
```

- **Never run containers in privileged mode.** Grant only specific capabilities with `--cap-add`.
- **Do not mount the Docker socket** into application containers.

### Network isolation

- **Isolate services by network.** The database should not be on the same network as the
  public-facing web server unless needed.
- **Do not expose ports unless required.** Only bind to `127.0.0.1` if the port must be
  accessible from the host but not externally.

### Secrets in containers

- **Never bake secrets into images.** Do not use `ENV` in Dockerfiles for secrets.
- Build arguments (`ARG`) are visible in `docker history`. Never pass secrets as build arguments.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
