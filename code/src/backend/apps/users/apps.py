from django.apps import AppConfig


class UsersConfig(AppConfig):
    default_auto_field: str = "django.db.models.BigAutoField"  # pyright: ignore[reportIncompatibleVariableOverride]
    name = "apps.users"
