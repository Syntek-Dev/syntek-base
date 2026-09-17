# US009 — The git hooks arm on purpose at install, and the README claim that they already do becomes true

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Should Have | 3 |

## Client Summary

Setting up the project installs its automatic code-quality checks as a visible, deliberate step,
instead of leaving them to switch themselves on later at an unpredictable moment. The setup guide
already tells people this happens; after this change, it is true.

## User Story

As a **developer setting up this project for the first time**, I want **the git pre-commit hooks
installed as an explicit, reported step of `install.sh`**, so that **the quality gates are either
armed and visible from the first commit, or absent and known — never arming themselves silently at
a moment I did not choose**.
