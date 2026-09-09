# US008 — Cookies go host-only under `__Host-` names, the CSRF cookie goes httpOnly, and one guide owns the rule

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 8 |

## Client Summary

When someone signs in, their browser holds a small token that keeps them signed in, and a second
one that proves each form they submit is genuinely theirs. This story locks both tokens to the
exact web address that issued them — so a page on any other address, including one this project
might add later, can neither read nor replace them — and stops scripts on the page from reading
the second one at all. It also teaches the project's own automated checks to refuse any future
change that loosens this, and tells an existing project what to look at when it takes the update.

## User Story

As a developer deploying `<%PROJECT_SLUG%>` to staging or production, I want the session and CSRF
cookies host-only under `__Host-` names, the CSRF cookie unreadable by script, the rule stated by
exactly one guide, and `audits/negative-space.sh` refusing any settings module that loosens it, so
that no subdomain this project adds later can plant or read a cookie the apex accepts, and no
future edit can reopen that quietly.
