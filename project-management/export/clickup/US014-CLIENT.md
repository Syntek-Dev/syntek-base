# US014 — Structured JSON logging with a `request_id` on every entry, queried by Compose service label

| Status | MoSCoW | Story Points |
| --- | --- | --- |
| Blocked | Must Have | 8 |

## Client Summary

The project's guides promise that staging and production write structured, searchable logs with an
identifier tying every line of one request together. Neither is true today: the logs are plain
text and carry no identifier, so the documented searches return nothing. This story makes the
promise true, keeps personal data out of the fields that are written, and corrects the guides that
describe it.

## User Story

As **a developer in a generated project investigating a staging or production fault**, I want
**every line Django's `LOGGING` emits to be one valid JSON object carrying a `request_id`, written by a pipeline the
settings actually configure and queried by the label the collector really sets**, so that **the
LogQL queries in the guides return the lines they describe, and I can follow one request across
its log lines without reading personal data I did not need**.
