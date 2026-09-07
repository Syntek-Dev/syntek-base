# US007 — The story status vocabulary gets one owner, and every instruction that writes it uses a value the owner admits

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 5 |

## Client Summary

Every piece of work in this project carries a one-word status — open, blocked, in review,
completed and so on. Today the project's own instructions disagree about which words are allowed:
one list has five, another has eleven, and two of the steps that record progress use words the
five-word list does not permit. Nothing has gone wrong yet, because no work has reached those
states. This story settles the list in one place, has every instruction point at it, and makes
sure the version that ships with each new project is the corrected one — so a recorded status is
always a word the project agreed on.

## User Story

As a developer recording where a story stands in this repository, I want the `**Status:**`
vocabulary defined in exactly one document, with every skill, workflow and template that writes
the field drawing its values from there, so that the value I record is one every reader — and the
index gate that will soon string-compare it — agrees is legal.
