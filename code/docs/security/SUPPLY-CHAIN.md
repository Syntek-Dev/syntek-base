---
type: guide
agent: security
skills: [stack-django, stack-htmx-templates]
model: opus
---

# Security — Dependency Security and Supply Chain

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%> **Language**:
British English (en_GB) **Timezone**: <%TIMEZONE%>
**Claude Model:** opus — Dependency audits, vulnerability triage, supply-chain update policy

---

## Dependency Security

Run security audits regularly and before every deployment:

```bash
# Django / Python
pip-audit  # or: safety check

# Node.js / TypeScript
pnpm audit
```

**When a vulnerability is found:**

1. Check if your usage is actually affected by the vulnerability.
2. Update to the patched version immediately if affected.
3. If no patched version exists, evaluate a mitigation or replacement.
4. Do not leave known vulnerabilities unresolved in production.

**Dependency update policy:**

- Run security audits weekly (automate with GitHub Dependabot, Renovate, or equivalent).
- Apply security patches within 7 days of release for critical/high severity.
- Review and test all dependency updates before merging to production.

---

## Supply Chain Security

Dependency auditing catches known vulnerabilities, but supply chain attacks target the delivery
mechanism itself — compromised packages, hijacked maintainer accounts, and tampered build pipelines.

### Lock file integrity

- **Commit lock files** (`pnpm-lock.yaml`, `uv.lock`) to version control. Lock files pin the exact
  dependency tree, including transitive dependencies.
- **Review lock file diffs** in code review. A lock file change should correspond to an intentional
  dependency update. Unexplained changes are a red flag.
- **Run `--frozen-lockfile` in CI** (pnpm) or equivalent (`uv sync --frozen`). This ensures CI
  installs exactly what was committed, not a silently updated version.

### Commit signing

- Sign commits with GPG or SSH keys. This verifies that a commit was authored by the claimed person
  and has not been tampered with in transit.
- Require signed commits on protected branches where the project's hosting platform supports it.
- Store signing keys securely. Do not share private keys between developers.

### CI/CD pipeline security

- **Treat CI configuration as security-critical code.** Changes to workflow files
  (`.github/workflows/`, `.gitlab-ci.yml`) must go through the same review process as application
  code.
- **Pin CI action versions** by commit SHA, not tag. Tags can be moved; commit SHAs cannot.

```yaml
# WRONG — tag can be moved to a compromised version
- uses: actions/checkout@v4

# CORRECT — pinned to a specific, verified commit
- uses: actions/checkout@b4ffde65f46336ab88eb53be808477a3936bae11 # v4.1.1
```

- **Limit CI permissions.** CI runners should have the minimum permissions needed. Do not grant
  write access to production secrets, deployment credentials, or package registries unless the
  specific job requires it.
- **Do not run CI on untrusted code** with elevated permissions. Pull requests from forks should run
  in a restricted context without access to repository secrets.

### Package provenance

- Where available, verify package provenance (npm provenance, Sigstore for Python).
- Prefer packages from verified publishers over anonymous uploads.
- For critical dependencies, review the source code rather than trusting the published package
  blindly.

_Part of the `code/docs/` documentation family. See [`../SECURITY.md`](../SECURITY.md) for the full index._
