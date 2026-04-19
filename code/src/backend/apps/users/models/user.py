from django.contrib.auth.models import AbstractUser

from apps.core.encryption import EncryptedCharField, EncryptedEmailField


class User(AbstractUser):
    # username and password are inherited — username must stay plaintext for auth
    # backend lookups; password is already Argon2-hashed by Django's auth system.
    first_name = EncryptedCharField(blank=True, verbose_name="first name")
    last_name = EncryptedCharField(blank=True, verbose_name="last name")
    email = EncryptedEmailField(blank=True, verbose_name="email address")

    class Meta(AbstractUser.Meta):
        db_table_comment = (
            "Auth identity table — extends AbstractUser. "
            "PII fields (first_name, last_name, email) are Fernet-encrypted at rest. "
            "No RLS applied: auth backend queries this table before session context is set. "
            "Custom RBAC/ABAC groups are added in a later data migration."
        )
