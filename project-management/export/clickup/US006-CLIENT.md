# US006 — The destructive dev scripts read the deployment posture, and refuse to run above development

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Open | Must Have | 8 |

## Client Summary

Some of this project's developer commands wipe or restore the database. Today nothing stops one
being run against a live environment by mistake — the rule exists in writing, but only a person
following it enforces it. This story teaches those commands to check which environment the
project is deployed to and refuse to run anywhere real, unless the person running it names that
environment out loud on the command line.

## User Story

As a developer running a destructive database or container command, I want the script itself to
check the project's deployment posture and refuse above `development` unless I name the live
posture on the command line, so that a rule that currently binds only the model's compliance is
enforced by the thing that does the damage.
