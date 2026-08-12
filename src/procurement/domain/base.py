"""Shared immutable value-model primitives."""

from __future__ import annotations

from collections.abc import Mapping
from typing import Annotated, Any

from pydantic import AfterValidator, BaseModel, ConfigDict, PlainSerializer


def _unique_strings(values: Any) -> tuple[str, ...]:
    if values is None:
        return ()
    if isinstance(values, str):
        values = (values,)
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        if value is None:
            continue
        text = str(value).strip()
        key = text.casefold()
        if text and key not in seen:
            seen.add(key)
            result.append(text)
    return tuple(result)


class FrozenStringMapping(Mapping[str, str]):
    """Immutable, deepcopy-stable string mapping."""

    __slots__ = ("_data",)

    def __init__(self, value: Mapping[str, str]) -> None:
        self._data = dict(value)

    def __getitem__(self, key: str) -> str:
        return self._data[key]

    def __iter__(self):
        return iter(self._data)

    def __len__(self) -> int:
        return len(self._data)

    def __repr__(self) -> str:
        return f"FrozenStringMapping({self._data!r})"

    def __eq__(self, other: object) -> bool:
        return isinstance(other, Mapping) and dict(self.items()) == dict(other.items())

    def __copy__(self) -> "FrozenStringMapping":
        return self

    def __deepcopy__(self, memo: dict[int, object]) -> "FrozenStringMapping":
        return self


def _freeze_string_map(value: Mapping[str, str]) -> Mapping[str, str]:
    if isinstance(value, FrozenStringMapping):
        return value
    return FrozenStringMapping(value)


FrozenStringMap = Annotated[
    Mapping[str, str],
    AfterValidator(_freeze_string_map),
    PlainSerializer(lambda value: dict(value), return_type=dict[str, str]),
]


def _require_serialized_properties(schema: dict[str, Any]) -> None:
    """Mark every default-serialized object property as required."""

    properties = schema.get("properties")
    if isinstance(properties, dict):
        schema["required"] = list(properties)


class DomainModel(BaseModel):
    """Immutable, extra-forbidding base for public procurement values."""

    model_config = ConfigDict(
        frozen=True,
        extra="forbid",
        populate_by_name=True,
        serialize_by_alias=True,
        validate_default=True,
        json_schema_serialization_defaults_required=True,
        json_schema_extra=_require_serialized_properties,
    )


__all__ = [
    "DomainModel",
    "FrozenStringMap",
    "FrozenStringMapping",
]
