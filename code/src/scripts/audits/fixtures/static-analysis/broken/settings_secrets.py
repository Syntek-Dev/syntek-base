"""Fixture settings for static-analysis.sh --self-test. Never imported, never loaded.

Trips all five rules in secrets-in-source.yml: `hardcoded-credential-assignment`,
`hardcoded-credential-in-dict-literal`, `hardcoded-connection-uri-with-password`,
`hardcoded-private-key-material`, and `django-insecure-default-secret-key`.

Every value here is inert and unroutable by construction — a host that does not
resolve, a key that does not parse. TruffleHog runs with `--only-verified`, so nothing
in this file is reportable there; the Opengrep rules match on SHAPE, which is the
distinction this fixture exists to hold.
"""

from __future__ import annotations

# django-insecure-default-secret-key, and hardcoded-credential-assignment
SECRET_KEY = "django-insecure-fixture-0000000000000000"

# hardcoded-credential-assignment
API_KEY = "sk-fixture-000000000000000"

# hardcoded-credential-in-dict-literal
OAUTH_CLIENT = {
    "client_id": "fixture-client",
    "client_secret": "fixture-client-secret-0000000",
    "token_url": "https://oauth.invalid/token",
}

# hardcoded-connection-uri-with-password
DATABASE_URL = "postgres://fixture:fixturepassword@db.invalid:5432/fixture_db"

# hardcoded-private-key-material
SIGNING_KEY_PEM = """-----BEGIN RSA PRIVATE KEY-----
ThisIsNotAKeyItIsAFixtureAndWillNeverParse
-----END RSA PRIVATE KEY-----"""
