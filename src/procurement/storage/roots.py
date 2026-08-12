"""Application-owned configured filesystem roots retained by physical identity."""

from __future__ import annotations

import os
from contextlib import ExitStack
from dataclasses import dataclass, field
from enum import StrEnum
from pathlib import Path
from types import MappingProxyType
from typing import Mapping

from jsonl_engine.publication import PinnedPublicationRoot


class ConfiguredRootError(ValueError):
    """Configured root definitions or lifecycle state are invalid."""


class ConfiguredRootKind(StrEnum):
    """Logical namespaces for procurement-owned filesystem roots."""

    STAGING = "staging"
    LOCAL_INBOX = "local-inbox"
    ARTICLE_CATALOG = "article-catalog"


@dataclass(frozen=True, slots=True)
class ConfiguredRootDescriptor:
    """One logical root bound to an active physical directory generation."""

    kind: ConfiguredRootKind
    name: str
    path: str
    identity: tuple[int, ...]
    publication_root: PinnedPublicationRoot = field(repr=False, compare=False)

    def as_dict(self) -> dict[str, object]:
        return {
            "kind": self.kind.value,
            "name": self.name,
            "path": self.path,
            "identity": list(self.identity),
        }


@dataclass(frozen=True, slots=True)
class _RootDefinition:
    kind: ConfiguredRootKind
    name: str
    path: str


class ProcurementRootCatalog:
    """Open and retain every configured procurement root for one application lifetime."""

    STAGING_NAME = "default"

    def __init__(
        self,
        staging_root: str | Path,
        *,
        local_inboxes: Mapping[str, str | Path],
        article_catalogs: Mapping[str, str | Path],
    ) -> None:
        definitions = [
            _RootDefinition(
                ConfiguredRootKind.STAGING,
                self.STAGING_NAME,
                self._absolute_path(staging_root, label="staging root"),
            )
        ]
        definitions.extend(
            self._mapping_definitions(
                ConfiguredRootKind.ARTICLE_CATALOG,
                article_catalogs,
            )
        )
        definitions.extend(
            self._mapping_definitions(
                ConfiguredRootKind.LOCAL_INBOX,
                local_inboxes,
            )
        )

        path_keys: dict[str, _RootDefinition] = {}
        for definition in definitions:
            key = os.path.normcase(definition.path)
            prior = path_keys.get(key)
            if prior is not None:
                raise ConfiguredRootError(
                    "configured roots must not alias one lexical directory: "
                    f"{prior.kind.value}/{prior.name} and "
                    f"{definition.kind.value}/{definition.name} both name "
                    f"'{definition.path}'"
                )
            path_keys[key] = definition

        self._definitions = tuple(definitions)
        self._stack: ExitStack | None = None
        self._descriptors: Mapping[
            tuple[ConfiguredRootKind, str], ConfiguredRootDescriptor
        ] = MappingProxyType({})

    @staticmethod
    def _absolute_path(value: str | Path, *, label: str) -> str:
        if not isinstance(value, (str, os.PathLike)):
            raise ConfiguredRootError(f"{label} must be a non-empty filesystem path")
        raw = os.fspath(value)
        if not isinstance(raw, str) or not raw.strip():
            raise ConfiguredRootError(f"{label} must be a non-empty text filesystem path")
        return os.path.abspath(raw)

    @classmethod
    def _mapping_definitions(
        cls,
        kind: ConfiguredRootKind,
        values: Mapping[str, str | Path],
    ) -> list[_RootDefinition]:
        if not values:
            raise ConfiguredRootError(f"at least one {kind.value} root is required")
        configured: dict[str, _RootDefinition] = {}
        for name, path in values.items():
            if not isinstance(name, str) or not name or name != name.strip():
                raise ConfiguredRootError(
                    f"{kind.value} names must be non-empty strings without surrounding whitespace"
                )
            key = name.casefold()
            if key in configured:
                raise ConfiguredRootError(
                    f"{kind.value} names contain a case collision at {name!r}"
                )
            configured[key] = _RootDefinition(
                kind,
                name,
                cls._absolute_path(path, label=f"{kind.value} {name!r}"),
            )
        return sorted(configured.values(), key=lambda item: item.name.casefold())

    @property
    def is_open(self) -> bool:
        """Return whether every configured root is actively retained."""

        return self._stack is not None

    def open(self) -> "ProcurementRootCatalog":
        """Pin every configured directory and capture its physical identity."""

        if self._stack is not None:
            raise ConfiguredRootError("configured root catalog is already open")
        stack = ExitStack()
        descriptors: dict[tuple[ConfiguredRootKind, str], ConfiguredRootDescriptor] = {}
        physical: dict[tuple[int, ...], _RootDefinition] = {}
        try:
            for definition in self._definitions:
                root = stack.enter_context(PinnedPublicationRoot(definition.path))
                identity = root.identity
                prior = physical.get(identity)
                if prior is not None:
                    raise ConfiguredRootError(
                        "configured roots must not alias one physical directory generation: "
                        f"{prior.kind.value}/{prior.name} and "
                        f"{definition.kind.value}/{definition.name}"
                    )
                physical[identity] = definition
                descriptors[(definition.kind, definition.name.casefold())] = (
                    ConfiguredRootDescriptor(
                        kind=definition.kind,
                        name=definition.name,
                        path=definition.path,
                        identity=identity,
                        publication_root=root,
                    )
                )
        except BaseException:
            stack.close()
            raise
        self._descriptors = MappingProxyType(descriptors)
        self._stack = stack
        return self

    def close(self) -> None:
        """Release every configured root handle or descriptor."""

        stack = self._stack
        self._stack = None
        if stack is not None:
            stack.close()

    def __enter__(self) -> "ProcurementRootCatalog":
        return self.open()

    def __exit__(self, exc_type: object, exc: object, traceback: object) -> None:
        self.close()

    def _require_open(self) -> None:
        if self._stack is None:
            raise ConfiguredRootError("configured root catalog is not open")

    def resolve(
        self,
        kind: ConfiguredRootKind | str,
        name: str,
    ) -> ConfiguredRootDescriptor:
        """Return one active descriptor by namespace and case-insensitive logical name."""

        self._require_open()
        try:
            resolved_kind = ConfiguredRootKind(kind)
        except ValueError as exc:
            raise ConfiguredRootError(f"unknown configured root kind: {kind!r}") from exc
        if not isinstance(name, str) or not name.strip():
            raise ConfiguredRootError("configured root name must not be blank")
        descriptor = self._descriptors.get((resolved_kind, name.strip().casefold()))
        if descriptor is None:
            available = [
                item.name for item in self.descriptors(resolved_kind)
            ]
            raise ConfiguredRootError(
                f"unknown {resolved_kind.value} root {name!r}; available: {available}"
            )
        return descriptor

    @property
    def staging(self) -> ConfiguredRootDescriptor:
        """Return the active acquisition staging root."""

        return self.resolve(ConfiguredRootKind.STAGING, self.STAGING_NAME)

    def descriptors(
        self,
        kind: ConfiguredRootKind | str | None = None,
    ) -> tuple[ConfiguredRootDescriptor, ...]:
        """Return active descriptors in namespace and logical-name order."""

        self._require_open()
        selected = tuple(self._descriptors.values())
        if kind is not None:
            try:
                resolved_kind = ConfiguredRootKind(kind)
            except ValueError as exc:
                raise ConfiguredRootError(f"unknown configured root kind: {kind!r}") from exc
            selected = tuple(item for item in selected if item.kind is resolved_kind)
        return tuple(sorted(selected, key=lambda item: (item.kind.value, item.name.casefold())))

    def assert_current(self) -> None:
        """Require every configured path to name its retained physical generation."""

        self._require_open()
        for descriptor in self.descriptors():
            descriptor.publication_root.assert_current()


__all__ = [
    "ConfiguredRootDescriptor",
    "ConfiguredRootError",
    "ConfiguredRootKind",
    "ProcurementRootCatalog",
]
