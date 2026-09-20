# US010 — The seven register indexes are born seeded, and the map index leaves the file that ships

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 8 |

## Client Summary

Each folder that collects project records — feature maps, stories, sprints, decisions, plans,
findings and bugs — gains a contents page listing what is inside it, and a new project starts with
those contents pages already in place and empty. Today the feature-map folder's contents page says
"none charted yet" while fourteen maps sit beside it, and the instruction that produced that
mistake is repeated in four other files. This change puts each list in its own file, fills the
feature-map one in, and removes the instruction that made it wrong.

## User Story

As a **developer or agent returning to a register folder I did not fill**, I want **an index file
inside it that lists every instance, and a shipped instruction that points at that file rather
than at one which cannot hold the rows**, so that **I can see what a folder contains without
reading every file in it, and a generated project starts from an index that is empty and correct
rather than one that is populated and false**.
