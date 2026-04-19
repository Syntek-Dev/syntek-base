from django.apps import AppConfig


class CoreConfig(AppConfig):
    default_auto_field: str = "django.db.models.BigAutoField"  # pyright: ignore[reportIncompatibleVariableOverride]
    name = "apps.core"
