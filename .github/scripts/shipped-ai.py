#!/usr/bin/env python3
"""Exercise shared AI aliases through real Copier copies and updates, offline.

Entry point: bash .github/scripts/shipped-ai.sh [--self-test]

The temporary template uses the repository's AI files, questions, exclusions and
seed-once task unchanged. Other files, dependency installation and historical
migrations are outside this focused probe. All Git writes stay in temporary repos.
"""

from __future__ import annotations

import argparse
import copy
import json
import os
import shutil
import tempfile
import tomllib
from pathlib import Path

import yaml
from copier import run_copy, run_update
from copier.errors import TaskError
from plumbum import local

ROOT = Path(__file__).resolve().parents[2]
OPTIONAL = {
    "stack-react-native": "INCLUDE_MOBILE",
    "stack-rust": "INCLUDE_RUST",
    "stack-slint": "INCLUDE_DESKTOP",
    "stack-wagtail": "INCLUDE_WAGTAIL",
}
ANSWERS = {
    "PROJECT_NAME": "AI Probe",
    "PROJECT_DESCRIPTION": "A temporary project verifying shared instructions and project memory.",
    "ORG_NAME": "CI Org",
    "DEVELOPER_NAME": "CI Runner",
    "DEVELOPER_EMAIL": "ci@example.com",
    "DATE": "14/09/2026",
}
TEMPLATE_MEMORY = "Template memory must never become project memory."
PROJECT_MEMORY = "Project memory must survive a template update."
UPDATED_SKILL = "Shared skill update reached both coding tools."


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def git(directory: Path, *args: str) -> str:
    return local["git"](
        "-C",
        str(directory),
        "-c",
        "core.hooksPath=/dev/null",
        "-c",
        "commit.gpgsign=false",
        "-c",
        "user.name=AI Probe",
        "-c",
        "user.email=ai-probe@example.com",
        *args,
    )


def commit(directory: Path, message: str) -> None:
    git(directory, "add", "--all")
    git(directory, "commit", "--quiet", "-m", message)


def duplicate(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    if source.is_symlink():
        destination.symlink_to(os.readlink(source))
    elif source.is_dir():
        shutil.copytree(source, destination, symlinks=True)
    else:
        shutil.copy2(source, destination)


def fixture(directory: Path, config: dict, *, legacy: bool = False) -> None:
    directory.mkdir()
    for name in (
        "AGENTS.md",
        ".ai",
        ".agents/skills",
        ".claude/skills",
        ".claude/MEMORY.md",
        ".codex/config.toml",
        ".mcp.json",
        ".copier-answers.yml",
    ):
        duplicate(ROOT / name, directory / name)
    # Include every seed consumed by the actual seed-once task, and the destination
    # folder marker that normally makes its scale-planning destination exist.
    for source in (ROOT / ".copier").iterdir():
        if source.is_file():
            duplicate(source, directory / ".copier" / source.name)
    migration = ".copier/migrations/shared-ai-symlinks.sh"
    duplicate(ROOT / migration, directory / migration)
    marker = "project-management/src/01-FEATURE-MAPS/CONTEXT.md"
    duplicate(ROOT / marker, directory / marker)
    (directory / ".claude/MEMORY.md").write_text(TEMPLATE_MEMORY + "\n")
    if legacy:
        for name in ("AGENTS.md", ".ai", ".codex"):
            path = directory / name
            if path.is_dir():
                shutil.rmtree(path)
            else:
                path.unlink()
        for path in (directory / ".agents/skills").iterdir():
            if path.is_symlink():
                path.unlink()
    (directory / "copier.yml").write_text(yaml.safe_dump(config, sort_keys=False))
    git(directory, "init", "--quiet", "--initial-branch=main")
    commit(directory, "Initial AI fixture")
    git(directory, "tag", "v1.0.0")


def check_settings(project: Path) -> None:
    codex = tomllib.loads((project / ".codex/config.toml").read_text())
    claude = json.loads((project / ".mcp.json").read_text())["mcpServers"]
    servers = codex["mcp_servers"]
    require(servers.keys() == claude.keys(), "The coding tools expose different MCP servers")
    for name, server in claude.items():
        require(servers[name]["command"] == server["command"], f"MCP command differs: {name}")
        require(servers[name]["args"] == server["args"], f"MCP arguments differ: {name}")
        forwarded = {
            key for key, value in server.get("env", {}).items() if value == "${" + key + "}"
        }
        fixed = {key: value for key, value in server.get("env", {}).items() if key not in forwarded}
        require(
            set(servers[name].get("env_vars", [])) == forwarded,
            f"Forwarded MCP environment variable names differ: {name}",
        )
        require(servers[name].get("env", {}) == fixed, f"Fixed MCP environment differs: {name}")


def check_links(project: Path, enabled: bool, *, updated: bool = False) -> None:
    check_settings(project)
    for path, target in {
        ".ai/skills": "../.claude/skills",
        ".ai/MEMORY.md": "../.claude/MEMORY.md",
    }.items():
        alias = project / path
        require(alias.is_symlink(), f"{path} was dereferenced instead of preserved")
        require(os.readlink(alias) == target, f"{path} has the wrong relative target")
        require(alias.exists(), f"{path} is dangling")

    for source in sorted((ROOT / ".claude/skills").iterdir()):
        if not (source / "SKILL.md").is_file():
            continue
        paths = [
            project / base / source.name
            for base in (".ai/skills", ".agents/skills", ".claude/skills")
        ]
        if source.name in OPTIONAL and not enabled:
            for path in paths:
                require(
                    not path.exists() and not path.is_symlink(), f"Excluded skill leaked: {path}"
                )
            continue
        for path in paths:
            require((path / "SKILL.md").is_file(), f"Skill discovery is broken: {path}")
        if not source.is_symlink():
            alias = project / ".agents/skills" / source.name
            require(alias.is_symlink(), f"First-party skill was copied: {alias}")
            require(os.readlink(alias) == f"../../.claude/skills/{source.name}", str(alias))

    memory = (project / ".ai/MEMORY.md").read_text()
    require(TEMPLATE_MEMORY not in memory, "Template memory leaked through the shared alias")
    if updated:
        require(PROJECT_MEMORY in memory, "Copier update discarded accumulated project memory")
        for base in (".ai/skills", ".agents/skills", ".claude/skills"):
            require(
                UPDATED_SKILL in (project / base / "global-workflow/SKILL.md").read_text(), base
            )
    else:
        require(
            not any(line.startswith("### ") for line in memory.splitlines()),
            "Memory was not seeded empty",
        )
    require(not (project / ".copier").exists(), "Seed staging directory survived")


def copy_project(template: Path, project: Path, enabled: bool) -> None:
    data = {**ANSWERS, **dict.fromkeys(OPTIONAL.values(), enabled)}
    run_copy(
        str(template), project, data=data, defaults=True, unsafe=True, vcs_ref="v1.0.0", quiet=True
    )
    check_links(project, enabled)


def exercise(directory: Path, config: dict) -> None:
    template = directory / "template"
    fixture(template, config)
    for enabled in (False, True):
        project = directory / f"project-{enabled}"
        copy_project(template, project, enabled)
        with (project / ".ai/MEMORY.md").open("a") as memory:
            memory.write(f"\n### Local knowledge\n\n{PROJECT_MEMORY}\n")
        git(project, "init", "--quiet", "--initial-branch=main")
        commit(project, "Record generated project and its own memory")

    with (template / ".claude/skills/global-workflow/SKILL.md").open("a") as skill:
        skill.write(f"\n{UPDATED_SKILL}\n")
    # A changing source memory makes the update check exercise isolation as well
    # as preservation. It must never be present under either path in the project.
    with (template / ".claude/MEMORY.md").open("a") as memory:
        memory.write("An additional template-only entry.\n")
    commit(template, "Update a shared skill and template memory")
    git(template, "tag", "v1.1.0")

    for enabled in (False, True):
        project = directory / f"project-{enabled}"
        run_update(
            project, defaults=True, unsafe=True, overwrite=True, vcs_ref="v1.1.0", quiet=True
        )
        check_links(project, enabled, updated=True)
        print(
            f"PASS: copy/update with optional skills {enabled}; "
            "aliases resolve and project memory survives"
        )


def self_test(directory: Path, config: dict) -> None:
    for name in ("dereferenced-aliases", "excluded-skill-alias"):
        mutated = copy.deepcopy(config)
        if name == "dereferenced-aliases":
            mutated["_preserve_symlinks"] = False
            expected = ".ai/skills was dereferenced"
        else:
            mutated["_exclude"] = [
                entry for entry in mutated["_exclude"] if "/.agents/skills/stack-rust" not in entry
            ]
            expected = "Excluded skill leaked:"
        template = directory / name
        fixture(template, mutated)
        try:
            copy_project(template, directory / f"{name}-project", False)
        except AssertionError as error:
            require(expected in str(error), f"Mutation failed for an unexpected reason: {error}")
            print(f"PASS: detector rejects {name}")
        else:
            raise AssertionError(f"Detector accepted the broken {name} fixture")


def exercise_legacy(directory: Path, config: dict) -> None:
    template = directory / "legacy-template"
    previous = copy.deepcopy(config)
    previous.pop("_preserve_symlinks", None)
    previous["_migrations"] = [
        task for task in previous["_migrations"] if "shared-ai-symlinks.sh" not in task["command"]
    ]
    fixture(template, previous, legacy=True)
    project = directory / "legacy-project"
    run_copy(
        str(template),
        project,
        data={**ANSWERS, **dict.fromkeys(OPTIONAL.values(), False)},
        defaults=True,
        unsafe=True,
        vcs_ref="v1.0.0",
        quiet=True,
    )
    with (project / ".claude/MEMORY.md").open("a") as memory:
        memory.write(f"\n### Local knowledge\n\n{PROJECT_MEMORY}\n")
    git(project, "init", "--quiet", "--initial-branch=main")
    commit(project, "Record project generated before shared aliases")

    divergent = directory / "divergent-project"
    shutil.copytree(project, divergent, symlinks=True)
    changed = divergent / ".claude/skills/cloudinary-transformations/SKILL.md"
    with changed.open("a") as skill:
        skill.write("\nKeep this project's local changes.\n")
    changed_contents = changed.read_bytes()
    commit(divergent, "Record a locally customised vendored skill")

    for name in ("AGENTS.md", ".ai", ".codex"):
        duplicate(ROOT / name, template / name)
    for path in (ROOT / ".agents/skills").iterdir():
        if path.is_symlink():
            duplicate(path, template / ".agents/skills" / path.name)
    with (template / ".claude/skills/global-workflow/SKILL.md").open("a") as skill:
        skill.write(f"\n{UPDATED_SKILL}\n")
    (template / "copier.yml").write_text(yaml.safe_dump(config, sort_keys=False))
    commit(template, "Introduce shared aliases")
    git(template, "tag", "v1.1.0")

    run_update(project, defaults=True, unsafe=True, overwrite=True, vcs_ref="v1.1.0", quiet=True)
    check_links(project, False, updated=True)
    print("PASS: legacy generated skill directories upgrade to aliases and retain project memory")
    try:
        run_update(
            divergent, defaults=True, unsafe=True, overwrite=True, vcs_ref="v1.1.0", quiet=True
        )
    except TaskError as error:
        require(
            "shared-ai-symlinks.sh" in str(error), "Legacy upgrade failed for an unexpected reason"
        )
        require(changed.read_bytes() == changed_contents, "Local skill content was discarded")
        require(
            not git(divergent, "status", "--porcelain").strip(),
            "The refused legacy upgrade changed the project",
        )
        print("PASS: a divergent legacy skill stops the upgrade with all local files intact")
    else:
        raise AssertionError("Legacy upgrade accepted divergent local skill content")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--self-test", action="store_true", help="also prove the alias regression checks fail"
    )
    args = parser.parse_args()
    config = yaml.safe_load((ROOT / "copier.yml").read_text())
    config["_tasks"] = [
        task
        for task in config["_tasks"]
        if "mv .copier/MEMORY.md .claude/MEMORY.md" in task["command"]
    ]
    require(
        len(config["_tasks"]) == 1,
        "The repository must provide exactly one project-memory seed task",
    )
    config["_migrations"] = [
        task
        for task in config["_migrations"]
        if task["command"] == "rm -rf .copier" or "shared-ai-symlinks.sh" in task["command"]
    ]
    for key in ("_message_after_copy", "_message_after_update"):
        config.pop(key, None)
    with tempfile.TemporaryDirectory(prefix="syntek-shipped-ai-") as temporary:
        directory = Path(temporary)
        exercise(directory, config)
        exercise_legacy(directory, config)
        if args.self_test:
            self_test(directory, config)


if __name__ == "__main__":
    main()
