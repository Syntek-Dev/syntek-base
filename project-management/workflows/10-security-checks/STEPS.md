---
workflow: 10-security-checks
phase: harden
skills: [security, stack-django, stack-htmx-templates]
model: fable
---

# Security Checks — Steps

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%ORG_NAME%>
**Language**: British English (en_GB)

---

## Key references

Consult `project-management/REFERENCES.md` as you work through these steps:

| Step | Section                                                                                                                                |
| ---- | -------------------------------------------------------------------------------------------------------------------------------------- |
| 2–3  | **Internal — Guides** → project-management/docs/SECURITY-GUIDE.md                                                                      |
| 3–4  | **External — Compliance & Legal** → OWASP Top 10 (2025), STRIDE threat modelling, NIST Cybersecurity Framework 2.0, ISO/IEC 27001:2022 |
| 5    | **Internal — Live Artefacts** → src/10-SECURITY/                                                                                       |

---

## Steps

### Step 1 — Grill, then Review User Flows and Wireframes

> **Model:** opus

**Grill first** (`.claude/CLAUDE.md` Section 10): load `.claude/skills/grill-with-docs` and
interview <%DEVELOPER_NAME%> about the trust boundaries, authentication points,
and data touchpoints before reviewing the user flows and wireframes.

Read the completed user flows in `project-management/src/05-USER-FLOW/` and wireframes in
`project-management/src/08-WIREFRAMES/`. Identify all points where:

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

### Step 3 — Map to OWASP and NIST CSF

For each finding from Step 2, record:

- **OWASP category** — the most relevant A01–A10 category from the **2025** list, cited with its
  year (e.g. `A01:2025` Broken Access Control, `A05:2025` Injection, `A06:2025` Insecure Design)
- **NIST CSF 2.0 function** — the function most affected if the threat is exploited
  (GV Govern, ID Identify, PR Protect, DE Detect, RS Respond, RC Recover)

Add both columns to the threat table in the threat model document. Full mappings in
`project-management/docs/SECURITY-GUIDE.md`.

### Step 4 — Run Security Agent

```text
security [describe the feature, its user flows, and any identified threats]
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `security` · **Model:** fable · **MCP:** none

### Step 5 — Document Findings

This gate writes **two** artefacts, both required, and the threat model first — the assessment
synthesises it rather than restating it. For any `CRITICAL` or `HIGH` finding it writes a third,
an individual vulnerability report; where there is none, the absence is recorded with its reason
rather than left to be inferred (`code/docs/GATE-REPORTING.md`).

**The category, the phase sub-folder and the filename are not stated here.** Read
`project-management/src/10-SECURITY/CLAUDE.md`, which owns them — `.claude/CLAUDE.md` Section 5
makes each folder's `CLAUDE.md` authoritative for its own tree, and this workflow does not own
`src/10-SECURITY/`. A pattern copied into this file is a second owner that drifts silently from
the first; that is not hypothetical here, and the three lines this paragraph replaced had drifted
on every one of their three tokens.

### Step 6 — Resolve Blocking Findings

Any `HIGH` or `CRITICAL` findings must be addressed in the design before sprint planning proceeds.
Update wireframes or user flows if structural changes are required.

### Step 7 — Commit

```text
git
```

> **↳ New dispatch:** `general-purpose` · **Skill:** `git` · **Model:** opus · **MCP:** none

---

## Update context files

If this workflow created new files, directories, or established new constraints:

1. Update the directory tree in the relevant `CONTEXT.md` to reflect any new files or folders
2. Update the `**Last Updated**` date at the top of any `CONTEXT.md` you modified
3. Add any new constraint, pattern, or decision to the relevant `CONTEXT.md`
4. If this workflow created a new directory, add a `CONTEXT.md` inside it describing its purpose, contents, and when to use it

---

## Completion

Run through `CHECKLIST.md` before marking this workflow complete.
