"""Provider registration and capability lookup."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from procurement.errors import ProviderNotFoundError, UnsupportedCapabilityError
from procurement.providers.base import Capability

_METHOD_BY_CAPABILITY = {
    Capability.SEARCH: "search",
    Capability.GET_WORK: "get_work",
    Capability.CITATIONS: "related",
    Capability.REFERENCES: "related",
    Capability.RECOMMENDATIONS: "related",
    Capability.RESOLVE: "resolve",
}


@dataclass(frozen=True, slots=True)
class ProviderBinding:
    """A provider object and the operations it advertises."""

    provider: Any
    capabilities: frozenset[Capability]

    def __post_init__(self) -> None:
        name = getattr(self.provider, "name", None)
        if not isinstance(name, str) or not name.strip():
            raise ValueError("a provider requires a non-empty name")
        for capability in self.capabilities:
            method = _METHOD_BY_CAPABILITY[capability]
            if not callable(getattr(self.provider, method, None)):
                raise ValueError(f"provider {name!r} advertises {capability.value!r} without {method}()")

    @property
    def name(self) -> str:
        return self.provider.name


class ProviderRegistry:
    """Explicit provider composition without protocol-layer switches."""

    def __init__(self, bindings: tuple[ProviderBinding, ...] | list[ProviderBinding] = ()) -> None:
        self._bindings: dict[str, ProviderBinding] = {}
        for binding in bindings:
            self.register(binding)

    def register(self, binding: ProviderBinding) -> None:
        key = binding.name.casefold()
        if key in self._bindings:
            raise ValueError(f"provider already registered: {binding.name}")
        self._bindings[key] = binding

    def get(self, name: str, capability: Capability) -> Any:
        binding = self._bindings.get(name.casefold())
        if binding is None:
            known = ", ".join(self.names()) or "(none)"
            raise ProviderNotFoundError(f"unknown provider {name!r}; registered providers: {known}")
        if capability not in binding.capabilities:
            raise UnsupportedCapabilityError(
                f"provider {binding.name!r} does not support {capability.value!r}"
            )
        return binding.provider

    def names(self, capability: Capability | None = None) -> tuple[str, ...]:
        return tuple(
            binding.name
            for binding in self._bindings.values()
            if capability is None or capability in binding.capabilities
        )
