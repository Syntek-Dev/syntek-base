---
type: guide
agent: planner
skills: [stack-django, stack-htmx-templates]
model: fable
---

# Architecture Patterns — AdminMember/ModulePermission Auth Contract

**Last Updated:** {{DATE}} **Version:** 0.1.0 **Maintained By:** {{ORG_NAME}} **Language:**
British English (en_GB) **Timezone:** {{TIMEZONE}}
**Claude Model:** opus — AdminMember/ModulePermission endpoint auth contract, privilege escalation gates

---

## AdminMember/ModulePermission Actor Auth Contract

Any Django Ninja endpoint — or any other state-changing operation — that creates, modifies, or
deletes `AdminMember` or `ModulePermission` records must enforce the following contract before
executing any database write.

---

## The Contract

1. **Authentication guard** — the endpoint declares an authentication class (session auth for the
   same-origin callers) and `_require_user(request)` is asserted at entry; unauthenticated callers
   receive HTTP 401 (`PermissionError("Authentication required.")`) before any business logic
   executes.

2. **Area-admin gate** — only a user with `is_area_admin=True` may invoke `AdminMember` or
   `ModulePermission` operations. Non-area-admin callers receive HTTP 403; the failed attempt is
   written to the audit log.

3. **Superadmin gate** — only a user with `is_superuser=True` may grant or revoke the `gdpr`,
   `integrations`, or `billing` module permissions. An area admin who is not a superuser must be
   rejected when attempting to assign these sensitive modules.

4. **Actor ≠ Target** — an operation that modifies another user's `AdminMember` record must assert
   `actor.id != target.id` for any privilege-escalating change. A user may not promote themselves
   or grant themselves permissions they do not already hold.

5. **Area scope** — the actor and target must belong to the same area. A member from area B cannot
   manipulate `AdminMember` or `ModulePermission` records for area A.

---

## Implementation Checklist

For any new state-changing endpoint on these models:

- [ ] `_require_user(request)` called at endpoint entry; unauthenticated callers receive HTTP 401
- [ ] `actor.admin_member.is_area_admin` verified before any service method is called;
      non-area-admin callers receive HTTP 403
- [ ] Superadmin gate applied for `gdpr`, `integrations`, `billing` permissions:
      `actor.is_superuser` checked
- [ ] `actor.id != target.id` asserted for any operation that modifies the target's permission
      level
- [ ] Area scope verified: `actor`'s area matches `target`'s area
- [ ] `audit_auditlog` entry written within the same `transaction.atomic()` block: `actor_id`,
      `target_id`, `action`, `affected_module`, `timestamp`; entries are immutable
- [ ] Unit tests cover: unauthenticated rejection, non-area-admin rejection, superadmin gate,
      actor=target guard, area-scope guard, and audit log write

---

## Reference

This contract closes two classes of vulnerability: state-changing endpoints that miss an explicit
permission check, and auth-backend bypasses that are not tested end to end.

See [`../SECURITY.md`](../SECURITY.md) for the OWASP A01 permission-check baseline and
[`../API-DESIGN.md`](../API-DESIGN.md) for the endpoint auth and error conventions.

_Part of the `code/docs/` documentation family. See [`../ARCHITECTURE-PATTERNS.md`](../ARCHITECTURE-PATTERNS.md) for the full index._
