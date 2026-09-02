# US002 — The audits register regains the headroom nine new gates need

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 3 |

## Client Summary

The folder that lists this project's automated quality checks keeps its own index, and that index
is two lines from a hard limit. Nine new checks are due to be built over the coming sprints, and
each needs two lines in it — so the next check to be written cannot register itself, and a check
nobody can find is a check nobody runs. This story makes room by deleting the parts of the index
that repeat rules already stated elsewhere, so the register itself survives intact.

## User Story

As a developer adding an audit script to this repository, I want
`code/src/scripts/audits/CONTEXT.md` to have room for its inventory and dependencies rows, so that
I can register my gate in the same change that writes it instead of having to shrink someone
else's documentation first.
