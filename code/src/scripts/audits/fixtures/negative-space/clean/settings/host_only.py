"""Fixture settings for negative-space.sh --self-test (US008, QA-06). Never imported.

Explicit spellings of host-only scope: a Domain of None is Django's default (no Domain
attribute), and a raw-string "/" is the root Path. Neither is a `cookie-scope-widened` finding.
"""

from __future__ import annotations

SESSION_COOKIE_DOMAIN = None
SESSION_COOKIE_PATH = r"/"
