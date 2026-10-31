# US013 — The 09 debugging workflow runs through the scripts, renders its vendor names from the answers, and stops at the root cause

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 3 |

## Client Summary

The written procedure a developer follows to find the cause of a fault from its logs contains
commands that cannot run, names monitoring products a project may not use, and goes on to fix
the fault when another procedure owns that. This story makes every command one the project's own
scripts run, makes the product names follow the choices each project makes when it is created,
and ends the procedure where it should: at the cause.

## User Story

As **a developer in a generated project debugging an incident**, I want **workflow 09 to give me
commands that run as written, vendor names that match my own project's answers, and a procedure
that stops at the root cause it owns**, so that **I can follow it under pressure without
translating it first, and hand the fix to workflow 10 instead of half-doing it here**.
