# US003 — Absence gets an owning guide, born under 270 with every clause's tier stated

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Should Have | 5 |

## Client Summary

When a piece of code returns "nothing", that can mean six different things — the record was
never there, it has not arrived yet, the list is genuinely empty, something failed, nobody
supplied it, or it does not apply. Today a developer has to guess which one, and different parts
of the codebase guess differently. This story writes the one guide that names all six and shows
what each looks like in every language this project uses.

## User Story

As a developer deciding between returning nothing, returning an empty list and raising an error,
I want the six kinds of absence named in one guide with a per-language crib, so that I can say
which kind I mean and read the correct expression of it off a single table.
