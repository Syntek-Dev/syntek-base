"""Django project configuration package.

Deliberately empty. Celery is declared in ``pyproject.toml`` but unwired at baseline
(``code/src/django/CONTEXT.md``), so nothing is imported here.

This module is imported before *any* Django setting is read — ``config.settings.*``
cannot be loaded without it — so an import that fails takes the whole project down
before it can report why. When Celery is wired, add ``config/celery.py`` and re-export
its app from here in the same change; never one without the other.
"""
