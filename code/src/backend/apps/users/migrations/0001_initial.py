from __future__ import annotations

import django.contrib.auth.models
import django.contrib.auth.validators
import django.utils.timezone
from django.db import migrations, models

import apps.core.encryption


def _rls_setup(apps: object, schema_editor: object) -> None:
    """Row Level Security decision for users_user.

    users_user is the auth identity table (AbstractUser extension). Standard
    per-user RLS (id = current_setting('app.current_user_id', true)::bigint)
    cannot be applied here: Django's authentication backend must query this
    table before any RLS session context is established — during login, token
    validation, and session hydration app.current_user_id is not yet set.

    Row-level isolation for user-owned data is enforced via FK → users_user.id
    on each data table with policies on those tables, not within users_user
    itself. Pattern documented in code/docs/RLS-GUIDE.md § "When to Use RLS".
    """


def _rls_teardown(apps: object, schema_editor: object) -> None:
    pass  # No policies were created; nothing to remove.


class Migration(migrations.Migration):
    initial = True

    dependencies = [
        ("auth", "0012_alter_user_first_name_max_length"),
        ("contenttypes", "0002_remove_content_type_name"),
    ]

    operations = [
        migrations.CreateModel(
            name="User",
            fields=[
                (
                    "id",
                    models.BigAutoField(
                        auto_created=True,
                        primary_key=True,
                        serialize=False,
                        verbose_name="ID",
                    ),
                ),
                (
                    "password",
                    models.CharField(max_length=128, verbose_name="password"),
                ),
                (
                    "last_login",
                    models.DateTimeField(blank=True, null=True, verbose_name="last login"),
                ),
                (
                    "is_superuser",
                    models.BooleanField(
                        default=False,
                        help_text=(
                            "Designates that this user has all permissions without "
                            "explicitly assigning them."
                        ),
                        verbose_name="superuser status",
                    ),
                ),
                (
                    "username",
                    models.CharField(
                        error_messages={"unique": "A user with that username already exists."},
                        help_text=(
                            "Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only."
                        ),
                        max_length=150,
                        unique=True,
                        validators=[django.contrib.auth.validators.UnicodeUsernameValidator()],
                        verbose_name="username",
                    ),
                ),
                (
                    "first_name",
                    apps.core.encryption.EncryptedCharField(blank=True, verbose_name="first name"),
                ),
                (
                    "last_name",
                    apps.core.encryption.EncryptedCharField(blank=True, verbose_name="last name"),
                ),
                (
                    "email",
                    apps.core.encryption.EncryptedEmailField(
                        blank=True, verbose_name="email address"
                    ),
                ),
                (
                    "is_staff",
                    models.BooleanField(
                        default=False,
                        help_text=("Designates whether the user can log into this admin site."),
                        verbose_name="staff status",
                    ),
                ),
                (
                    "is_active",
                    models.BooleanField(
                        default=True,
                        help_text=(
                            "Designates whether this user should be treated as active. "
                            "Unselect this instead of deleting accounts."
                        ),
                        verbose_name="active",
                    ),
                ),
                (
                    "date_joined",
                    models.DateTimeField(
                        default=django.utils.timezone.now,
                        verbose_name="date joined",
                    ),
                ),
                (
                    "groups",
                    models.ManyToManyField(
                        blank=True,
                        help_text=(
                            "The groups this user belongs to. A user will get all "
                            "permissions granted to each of their groups."
                        ),
                        related_name="user_set",
                        related_query_name="user",
                        to="auth.group",
                        verbose_name="groups",
                    ),
                ),
                (
                    "user_permissions",
                    models.ManyToManyField(
                        blank=True,
                        help_text="Specific permissions for this user.",
                        related_name="user_set",
                        related_query_name="user",
                        to="auth.permission",
                        verbose_name="user permissions",
                    ),
                ),
            ],
            options={
                "verbose_name": "user",
                "verbose_name_plural": "users",
                "abstract": False,
                "swappable": "AUTH_USER_MODEL",
            },
            managers=[
                ("objects", django.contrib.auth.models.UserManager()),
            ],
        ),
        migrations.RunPython(_rls_setup, reverse_code=_rls_teardown),
    ]
