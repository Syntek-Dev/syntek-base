# US021 — Every valid offered configuration generates a complete, gated project: the 72-case `[3/4]` matrix

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Should Have | 8 |

## Client Summary

Today the template is test-generated in only two ways, with and without the mobile app, although
it offers seventy-two valid combinations of options. This story generates every one of them on
each change and checks each result in full, so a combination nobody happened to try can no longer
ship a broken or leaking project.

## User Story

As the maintainer of syntek-base, I want every valid combination of the template's offered options
generated and checked in full on each change, so that "the template generates a correct project"
is measured for every configuration a developer can choose, rather than inferred from two.
