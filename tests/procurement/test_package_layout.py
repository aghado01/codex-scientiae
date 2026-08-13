"""Hard procurement package-boundary contracts."""

from __future__ import annotations

import ast
import importlib.util
from pathlib import Path

import procurement.source as source_package
import procurement.storage.source_deposits as source_deposits


def _imports(module_path: Path) -> set[str]:
    tree = ast.parse(module_path.read_text(encoding="utf-8"), filename=str(module_path))
    names: set[str] = set()
    for node in ast.walk(tree):
        if isinstance(node, ast.ImportFrom) and node.module:
            names.add(node.module)
        elif isinstance(node, ast.Import):
            names.update(alias.name for alias in node.names)
    return names


def test_removed_flat_namespaces_have_no_compatibility_modules() -> None:
    for name in (
        "procurement.archive",
        "procurement.filesystem",
        "procurement.http",
        "procurement.models",
        "procurement.payloads",
        "procurement.services",
        "procurement.settings",
        "procurement.source.archive",
        "procurement.staging",
    ):
        assert importlib.util.find_spec(name) is None, name

    for old_export in (
        "ArchiveLimits",
        "SourceDepositStore",
        "SourceMaterializationRequest",
        "build_source_findings",
    ):
        assert not hasattr(source_package, old_export), old_export


def test_storage_does_not_import_the_operation_layer() -> None:
    imports = _imports(Path(source_deposits.__file__))
    assert not any(
        name == "procurement.operations" or name.startswith("procurement.operations.")
        for name in imports
    )
