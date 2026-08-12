"""Provider registration and capability lookup."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from procurement.errors import ProviderNotFoundError, UnsupportedCapabilityError
from procurement.models import ProviderDescriptor
from procurement.providers.base import Capability, ProviderRole, SEARCH_CONSTRAINTS

_METHOD_BY_CAPABILITY = {
    Capability.SEARCH: "search",
    Capability.GET_WORK: "get_work",
    Capability.CITATIONS: "related",
    Capability.REFERENCES: "related",
    Capability.RECOMMENDATIONS: "related",
    Capability.RESOLVE: "resolve",
    Capability.METADATA: "get_metadata",
    Capability.PLAN_ARTIFACT: "plan_artifact",
}


@dataclass(frozen=True, slots=True)
class ProviderBinding:
    """A provider object and the operations it advertises."""

    provider: Any
    capabilities: frozenset[Capability]
    roles: frozenset[ProviderRole] = frozenset()

    def __post_init__(self) -> None:
        name = getattr(self.provider, "name", None)
        if not isinstance(name, str) or not name.strip():
            raise ValueError("a provider requires a non-empty name")
        for capability in self.capabilities:
            method = _METHOD_BY_CAPABILITY[capability]
            if not callable(getattr(self.provider, method, None)):
                raise ValueError(f"provider {name!r} advertises {capability.value!r} without {method}()")
        if Capability.SEARCH in self.capabilities:
            constraints = getattr(self.provider, "search_constraints", None)
            if not isinstance(constraints, frozenset):
                raise ValueError(
                    f"search provider {name!r} requires an immutable search_constraints declaration"
                )
            unknown = constraints.difference(SEARCH_CONSTRAINTS)
            if unknown:
                raise ValueError(
                    f"search provider {name!r} declares unknown constraints: {sorted(unknown)}"
                )

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

    def binding(self, name: str) -> ProviderBinding:
        """Return one complete declaration by case-insensitive name."""

        binding = self._bindings.get(name.casefold())
        if binding is None:
            known = ", ".join(self.names()) or "(none)"
            raise ProviderNotFoundError(f"unknown provider {name!r}; registered providers: {known}")
        return binding

    def describe(self) -> tuple[ProviderDescriptor, ...]:
        """Return stable role and capability declarations for every provider."""

        return tuple(
            ProviderDescriptor(
                name=binding.name,
                roles=tuple(sorted(role.value for role in binding.roles)),
                capabilities=tuple(sorted(capability.value for capability in binding.capabilities)),
                search_constraints=tuple(
                    sorted(getattr(binding.provider, "search_constraints", frozenset()))
                ),
            )
            for binding in self._bindings.values()
        )
