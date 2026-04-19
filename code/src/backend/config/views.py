from django.http import HttpRequest, HttpResponse


def health_check(request: HttpRequest) -> HttpResponse:
    return HttpResponse(b"ok")
