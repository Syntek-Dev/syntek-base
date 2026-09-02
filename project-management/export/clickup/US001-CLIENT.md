# US001 — Reliability doctrine gets an owning guide, and every pointer reaches it

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 5 |

## Client Summary

Retry and idempotency rules — what happens when a network call fails, and whether repeating an
operation is safe — are currently spread across three documents that disagree with each other.
This story gives those rules a single home and points every related document at it, so a
developer finds one answer instead of three.

## User Story

As a developer building a network-facing surface, I want retry and idempotency doctrine to live in
one named guide that every related document points to, so that I can find the rule governing my
code without reading three guides that contradict each other.
