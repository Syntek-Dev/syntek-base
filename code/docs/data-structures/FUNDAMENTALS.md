---
type: guide
skills: [database, stack-django]
model: opus
---

# Data Structures — Fundamentals

**Last Updated:** <%DATE%> **Version:** 0.1.0 **Maintained By:** <%ORG_NAME%> **Language:**
British English (en_GB) **Timezone:** <%TIMEZONE%>
**Claude Model:** opus — Choosing data structures across the stack, when each fits

---

## Overview

This document covers fundamental data structures and when to use them in the <%PROJECT_NAME%>
stack. Everything runs in Python on the server — there is no client-side code holding application
data, so these are the only structures in play.

> "If you have chosen the right data structures and organised things well, the algorithms will
> almost always be self-evident." — Rob Pike

> "Show me your tables, and I won't usually need your flowcharts; they'll be obvious." — Linus
> Torvalds (via Fred Brooks)

Before writing logic, design the data. Before optimising an algorithm, question the data structure
it operates on. Before adding a conditional, ask whether the structure should make the condition
unnecessary.

---

## Lists and Arrays

An ordered, indexed collection. Use when order matters and you need to iterate, slice, or access
elements by position.

```python
# Good — ordered collection where position matters
stages = ["draft", "review", "published", "archived"]
current_index = stages.index(article.status)
next_stage = stages[current_index + 1]
```

**When to avoid:** if you are frequently searching for an element by value, you need a set or
dictionary instead. Linear search on a list is O(n); lookup in a set or dict is O(1).

---

## Dictionaries and Maps

An unordered (insertion-ordered in Python 3.7+) collection of key-value pairs. Use when you need
fast lookup by a known key.

```python
permissions_by_role = {
    "admin": {"read", "write", "delete", "manage_users"},
    "editor": {"read", "write"},
    "viewer": {"read"},
}
user_permissions = permissions_by_role[user.role]
```

---

## Sets

An unordered collection of unique values. Use when you need fast membership testing,
deduplication, or set operations.

```python
required_permissions = {"read", "write"}
user_permissions = {"read", "write", "delete"}
if required_permissions.issubset(user_permissions):
    allow_access()
unique_tags = set(tag.lower() for tag in raw_tags)
```

---

## Tuples and Frozen Structures

An immutable, ordered collection. Use when a group of values belongs together and should not be
modified after creation.

```python
from typing import NamedTuple

class PageRange(NamedTuple):
    start: int
    end: int

visible = PageRange(start=1, end=25)
```

---

## Queues and Stacks

**Queue (FIFO):** first in, first out. Use for task processing, message handling, breadth-first
traversal. On the server, durable background work goes through Celery on Valkey — an in-process
`deque` is only for transient, single-request state.

**Stack (LIFO):** last in, first out. Use for undo operations, depth-first traversal, expression
parsing.

```python
from collections import deque
task_queue: deque[Task] = deque()
task_queue.append(new_task)       # enqueue
next_task = task_queue.popleft()  # dequeue — O(1)

undo_stack: list[Action] = []
undo_stack.append(action)         # push
last_action = undo_stack.pop()    # pop — O(1)
```

**Important:** never use `list.pop(0)` for a queue in Python — it is O(n). Use `collections.deque`.

---

## Trees

A hierarchical structure where each node has zero or more children. Use for category hierarchies,
nested navigation, comment threads, and organisational structures.

**Django (self-referential model):**

```python
class Category(models.Model):
    name = models.CharField(max_length=200)
    parent = models.ForeignKey(
        "self", null=True, blank=True,
        on_delete=models.CASCADE, related_name="children",
    )
```

For deep trees with frequent ancestor/descendant queries, consider `django-mptt` or
`django-treebeard`.

---

## Graphs

A structure where nodes connect to other nodes via edges, with no hierarchy constraint. Use for
social networks, dependency resolution, routing, and workflow systems.

```python
from collections import defaultdict
from graphlib import TopologicalSorter

dependencies: dict[str, set[str]] = defaultdict(set)
dependencies["apps.users"].add("apps.core")
dependencies["apps.marketing"].add("apps.core")

sorter = TopologicalSorter(dependencies)
build_order = list(sorter.static_order())
```

---

## Choosing the Right Structure

| Primary operation           | Python                                |
| --------------------------- | ------------------------------------- |
| Access by index / position  | `list`                                |
| Lookup by key               | `dict`                                |
| Membership check            | `set`                                 |
| FIFO processing             | `deque`                               |
| LIFO processing             | `list`                                |
| Hierarchical navigation     | self-referential model                |
| Many-to-many with traversal | `dict[str, set]`                      |
| Ordered, deduplicated       | `dict.fromkeys()` (insertion-ordered) |

**Key questions before choosing:**

1. What operations are most frequent?
2. Does mutability matter? Use immutable structures where data should not change after creation.
3. Is uniqueness required? Use sets or dicts to enforce it.
4. How large will the collection grow? For large or unbounded collections, choose based on complexity.
5. Will this structure cross a boundary? Prefer plain dicts, lists, and Ninja/`dataclass` shapes for
   serialisation.

_Part of the `code/docs/` documentation family. See [`../DATA-STRUCTURES.md`](../DATA-STRUCTURES.md) for the full index._
