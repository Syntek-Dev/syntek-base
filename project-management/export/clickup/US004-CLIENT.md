# US004 — The citation gate stops depending on the git index, and the PM tree becomes checkable

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 8 |

## Client Summary

This repository runs an automated check that every file path written in its documentation
actually exists, and that a document destined for a customer's project never points at a file
only this repository holds. That check currently gives different answers for the same sentence
depending on whether the file it sits in has been saved into version control yet, and it cannot
see the project-management folder at all. This story makes its answer depend on what the
documentation says rather than on the state of the developer's working copy.

## User Story

As a developer writing a story, sprint record or decision note, I want the citation gate to give
the same verdict on the same sentence whether or not the file is committed yet, so that I can
trust a green run instead of maintaining a written baseline of findings to subtract from it.
