# Security Checks — Steps

**Last Updated**: 28/04/2026 **Version**: 1.0.0 **Maintained By**: Syntek Studio
**Language**: British English (en_GB)

---

## Steps

### Step 1 — Review User Flows and Wireframes

Read the completed user flows in `project-management/src/04-USER-FLOW/` and wireframes in
`project-management/src/07-WIREFRAMES/`. Identify all points where:

- A user authenticates or changes credentials
- Data is submitted, stored, or transmitted
- Roles or permissions gate access to a screen or action
- Third-party integrations are invoked

### Step 2 — Threat Model (STRIDE)

For each identified point, apply STRIDE:

| Threat                 | Question to answer                                   |
| ---------------------- | ---------------------------------------------------- |
| Spoofing               | Can an attacker impersonate a legitimate user?       |
| Tampering              | Can data be modified in transit or at rest?          |
| Repudiation            | Can actions be denied without audit trail?           |
| Information Disclosure | Can sensitive data be exposed to unauthorised users? |
| Denial of Service      | Can an attacker degrade or block the feature?        |
| Elevation of Privilege | Can a lower-privileged user gain higher access?      |

### Step 3 — Run Security Agent

```text
/syntek-dev-suite:security [describe the feature, its user flows, and any identified threats]
```

### Step 4 — Document Findings

Save a threat model and assessment file in `project-management/src/09-SECURITY/`:

- `THREAT-MODEL/THREAT-MODEL-<FEATURE>-DD-MM-YYYY.md`
- `ASSESSMENTS/ASSESSMENT-<FEATURE>-DD-MM-YYYY.md`

### Step 5 — Resolve Blocking Findings

Any `HIGH` or `CRITICAL` findings must be addressed in the design before sprint planning proceeds.
Update wireframes or user flows if structural changes are required.

### Step 6 — Commit

```text
/syntek-dev-suite:git
```

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
