from django.contrib import admin
from django.urls import path

from strawberry.django.views import AsyncGraphQLView

from apps.core.schema import schema
from config.views import health_check

urlpatterns = [
    path("admin/", admin.site.urls),
    path("graphql/", AsyncGraphQLView.as_view(schema=schema)),
    path("health/", health_check),
]
