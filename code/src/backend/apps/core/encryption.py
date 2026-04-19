from __future__ import annotations

import logging
from typing import Any

from django.conf import settings
from django.core.validators import validate_email
from django.db import models

from cryptography.fernet import Fernet

logger = logging.getLogger("apps.core.encryption")


def _get_fernet() -> Fernet:
    key = settings.ENCRYPTION_KEY
    return Fernet(key.encode() if isinstance(key, str) else key)


def encrypt_field(plaintext: str) -> str:
    """Encrypt a plaintext string. Returns URL-safe base64 ciphertext."""
    if not plaintext:
        return plaintext
    return _get_fernet().encrypt(plaintext.encode()).decode()


def decrypt_field(ciphertext: str) -> str:
    """Decrypt a ciphertext string produced by encrypt_field."""
    if not ciphertext:
        return ciphertext
    return _get_fernet().decrypt(ciphertext.encode()).decode()


class EncryptedCharField(models.TextField):
    """TextField that transparently Fernet-encrypts/decrypts its value at rest.

    Stores ciphertext (URL-safe base64) in the database. Plaintext is only
    visible in Python-layer model instances. max_length is not enforced at
    the database level because ciphertext is longer than the original plaintext.
    """

    def deconstruct(self) -> tuple[str, str, list[Any], dict[str, Any]]:
        name, path, args, kwargs = super().deconstruct()
        assert name is not None
        path = "apps.core.encryption.EncryptedCharField"
        return name, path, args, kwargs

    def from_db_value(self, value: str | None, expression: Any, connection: Any) -> str | None:
        if value is None:
            return value
        try:
            return decrypt_field(value)
        except Exception:
            logger.error(
                "apps.core.encryption: failed to decrypt EncryptedCharField value",
                exc_info=True,
            )
            raise

    def get_prep_value(self, value: Any) -> str | None:
        prepped: str | None = super().get_prep_value(value)
        if not prepped:
            return prepped
        return encrypt_field(prepped)


class EncryptedEmailField(EncryptedCharField):
    """EncryptedCharField for email addresses — adds email format validation."""

    default_validators = [validate_email]

    def deconstruct(self) -> tuple[str, str, list[Any], dict[str, Any]]:
        name, path, args, kwargs = super().deconstruct()
        assert name is not None
        path = "apps.core.encryption.EncryptedEmailField"
        return name, path, args, kwargs

    def formfield(self, **kwargs: Any) -> Any:
        from django.forms import EmailField as EmailFormField

        kwargs.setdefault("form_class", EmailFormField)
        return super().formfield(**kwargs)
