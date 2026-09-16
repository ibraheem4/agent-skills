#!/usr/bin/env python3
"""Validate skill-library invariants without external packages."""

from __future__ import annotations

import re
import sys
from pathlib import Path


NAME_RE = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
FRONTMATTER_RE = re.compile(r"\A---\n(.*?)\n---\n", re.DOTALL)
KEY_RE = re.compile(r"^([A-Za-z0-9_-]+):", re.MULTILINE)


def validate_skill(skill_dir: Path) -> list[str]:
    errors: list[str] = []
    skill_file = skill_dir / "SKILL.md"
    text = skill_file.read_text(encoding="utf-8")
    match = FRONTMATTER_RE.match(text)
    if not match:
        return [f"{skill_dir.name}: missing YAML frontmatter"]

    frontmatter = match.group(1)
    keys = KEY_RE.findall(frontmatter)
    if keys != ["name", "description"]:
        errors.append(
            f"{skill_dir.name}: frontmatter keys must be name, description; got {keys}"
        )

    name_match = re.search(r"^name:\s*['\"]?([^'\"\n]+)", frontmatter, re.MULTILINE)
    description_match = re.search(
        r"^description:\s*['\"]?(.+)", frontmatter, re.MULTILINE
    )
    name = name_match.group(1).strip() if name_match else ""
    description = description_match.group(1).strip() if description_match else ""

    if name != skill_dir.name:
        errors.append(f"{skill_dir.name}: frontmatter name is {name!r}")
    if not NAME_RE.fullmatch(name):
        errors.append(f"{skill_dir.name}: invalid skill name")
    if len(description) < 60:
        errors.append(f"{skill_dir.name}: description is too short to trigger reliably")
    if "TODO" in text or "[TODO" in text:
        errors.append(f"{skill_dir.name}: unresolved TODO placeholder")
    if len(text.splitlines()) > 500:
        errors.append(f"{skill_dir.name}: SKILL.md exceeds 500 lines")

    metadata = skill_dir / "agents" / "openai.yaml"
    if not metadata.exists():
        errors.append(f"{skill_dir.name}: missing agents/openai.yaml")
    else:
        metadata_text = metadata.read_text(encoding="utf-8")
        for field in ("display_name:", "short_description:", "default_prompt:"):
            if field not in metadata_text:
                errors.append(f"{skill_dir.name}: openai.yaml missing {field[:-1]}")
        if f"${name}" not in metadata_text:
            errors.append(f"{skill_dir.name}: default prompt must mention ${name}")

    return errors


def main() -> int:
    default_root = Path(__file__).resolve().parents[2]
    root = Path(sys.argv[1]).expanduser().resolve() if len(sys.argv) > 1 else default_root
    skill_dirs = sorted(path.parent for path in root.glob("*/SKILL.md"))
    if not skill_dirs:
        print(f"FAIL: no skills found under {root}")
        return 1

    errors = [error for directory in skill_dirs for error in validate_skill(directory)]
    catalog = root / "catalog.yaml"
    if not catalog.exists():
        errors.append("library: missing catalog.yaml")
    else:
        catalog_text = catalog.read_text(encoding="utf-8")
        for directory in skill_dirs:
            if f'- id: "{directory.name}"' not in catalog_text:
                errors.append(f"{directory.name}: missing from catalog.yaml")
    if errors:
        for error in errors:
            print(f"FAIL: {error}")
        return 1

    print(f"PASS: {len(skill_dirs)} skills validated under {root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
