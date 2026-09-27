# US012 — A seeded file that never lands is reported, and the gate's header claim becomes true

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 2 |

## Client Summary

When a new project is created from this template, a few starter files are put in place by a
separate step at the end. The check that inspects every new project confirms that the files it
expects have arrived, but it has never looked for these particular files, so one could go missing
without anyone being told. This change makes the check look for them too, and proves it works by
removing one on purpose and confirming the loss is reported.

## User Story

As **the maintainer of syntek-base, or a developer generating a project from it**, I want **the
template-integrity gate to assert that every seeded file actually landed in the generated
project**, so that **a seeded file that fails to arrive is reported by the gate rather than
silently tolerated**.
