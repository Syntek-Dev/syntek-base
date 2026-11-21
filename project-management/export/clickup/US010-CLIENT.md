# US010 — The seven register indexes are born seeded, and the map index leaves the file that ships

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| In Review | Must Have | 8 |

## Client Summary

**Re-cut 19/11/2026.** Three record folders — decisions, findings and bugs — gain a contents
page generated from the records themselves, the way the feature-map, story, sprint and plan folders
gained theirs in 7.7.0, and a new project starts with all eight pages present and empty bar the one
seeded map. Each record's status line takes the same plain shape, so the page can read it, and old
records move to an archive once they are finished with. The text below is the summary as cut, kept
as the record.

Each folder that collects project records — feature maps, stories, sprints, decisions, plans,
findings and bugs — gains a contents page listing what is inside it, and a new project starts with
those contents pages already in place and empty. Today the feature-map folder's contents page says
"none charted yet" while every map in the folder sits beside it unlisted, and the instruction that
produced that mistake is repeated across the shipped files. This change puts each list in its own
file, fills the feature-map one in, and removes the instruction that made it wrong.

## User Story

As a **developer or agent returning to a register folder I did not fill**, I want **an index file
inside it that lists every instance, and a shipped instruction that points at that file rather
than at one which cannot hold the rows**, so that **I can see what a folder contains without
reading every file in it, and a generated project starts from an index that is empty and correct
rather than one that is populated and false**.
