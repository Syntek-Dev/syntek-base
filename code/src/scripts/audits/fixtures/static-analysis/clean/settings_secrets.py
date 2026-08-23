"""Fixture settings for static-analysis.sh --self-test. Never imported, never loaded.

The counterpart to broken/settings_secrets.py: the same five settings, every value read
from the environment. None of the five rules in secrets-in-source.yml should fire, and
each shape here is the one the guides ask for
(code/docs/security/SECRETS-AND-TRANSPORT.md, "Secrets Management").
"""

from __future__ import annotations

import os

SECRET_KEY = os.environ["SECRET_KEY"]

API_KEY = os.environ["API_KEY"]

OAUTH_CLIENT = {
    "client_id": os.environ["OAUTH_CLIENT_ID"],
    "client_secret": os.environ["OAUTH_CLIENT_SECRET"],
    "token_url": "https://oauth.invalid/token",
}

DATABASE_URL = os.environ["DATABASE_URL"]

SIGNING_KEY_PEM = os.environ["SIGNING_KEY_PEM"]
