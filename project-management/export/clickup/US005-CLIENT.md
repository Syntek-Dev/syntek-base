# US005 — Exactly one layer decides to retry, and every budget says how long it may take

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 5 |

## Client Summary

When a call to an outside service fails, something has to decide whether to try again, how many
times, and for how long. Today several layers of the system could each decide that independently,
which multiplies a small failure into a large one, and the written guidance gives the same job
four different answers. This story settles who decides, and writes down the limits — so a failing
supplier gets a sensible number of retries rather than a flood.

## User Story

As a developer wiring a call to an external service, I want one written rule saying which layer
retries and what its budget is, so that I can configure a client without guessing whether the
layer beneath me is already retrying underneath it.
