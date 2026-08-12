"""Provider descriptor composition and capability lookup."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from procurement.errors import ProviderNotFoundError, UnsupportedCapabilityError
from procurement.domain.providers import ProviderDescriptor
from procurement.providers.base import (
    Capability,
    ProviderCategory,
    ProviderDefinition,
    ProviderRole,
)

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


def _category_for_roles(roles: frozenset[ProviderRole]) -> ProviderCategory:
    if ProviderRole.METADATA_AGGREGATOR in roles:
        return ProviderCategory.AGGREGATOR
    if ProviderRole.ARTIFACT_ORIGIN in roles or ProviderRole.METADATA_AUTHORITY in roles:
        return ProviderCategory.REPOSITORY
    if ProviderRole.ARTIFACT_ACCESS in roles:
        return ProviderCategory.ACCESS_SOURCE
    return ProviderCategory.SERVICE


@dataclass(frozen=True, slots=True, init=False)
class ProviderBinding:
    """One adapter bound to its immutable provider descriptor."""

    provider: Any
    descriptor: ProviderDefinition

    def __init__(
        self,
        provider: Any,
        descriptor: ProviderDefinition | frozenset[Capability] | None = None,
        roles: frozenset[ProviderRole] = frozenset(),
    ) -> None:
        if descriptor is None:
            declaration = getattr(provider, "descriptor", None)
            if not isinstance(declaration, ProviderDefinition):
                raise ValueError("a provider requires an immutable descriptor declaration")
        elif isinstance(descriptor, ProviderDefinition):
            if roles:
                raise ValueError("roles are part of ProviderDefinition and cannot be supplied twice")
            declaration = descriptor
        else:
            # Supports compact descriptors for injected test and application-local adapters.
            normalized_roles = frozenset(ProviderRole(role) for role in roles)
            declaration = ProviderDefinition(
                name=getattr(provider, "name", ""),
                category=_category_for_roles(normalized_roles),
                capabilities=frozenset(Capability(item) for item in descriptor),
                roles=normalized_roles,
                search_constraints=frozenset(getattr(provider, "search_constraints", frozenset())),
            )
        object.__setattr__(self, "provider", provider)
        object.__setattr__(self, "descriptor", declaration)
        self._validate_adapter()

    def _validate_adapter(self) -> None:
        name = getattr(self.provider, "name", None)
        if not isinstance(name, str) or name != self.descriptor.name:
            raise ValueError(
                f"provider name must exactly match descriptor name {self.descriptor.name!r}"
            )
        adapter_descriptor = getattr(self.provider, "descriptor", None)
        if adapter_descriptor is not None and adapter_descriptor != self.descriptor:
            raise ValueError(
                f"provider {name!r} descriptor differs from its catalog binding"
            )
        for capability in self.capabilities:
            method = _METHOD_BY_CAPABILITY[capability]
            if not callable(getattr(self.provider, method, None)):
                raise ValueError(
                    f"provider {name!r} advertises {capability.value!r} without {method}()"
                )
        constraints = getattr(self.provider, "search_constraints", frozenset())
        if constraints != self.descriptor.search_constraints:
            raise ValueError(
                f"provider {name!r} search constraints differ from its descriptor"
            )

    @property
    def name(self) -> str:
        return self.descriptor.name

    @property
    def category(self) -> ProviderCategory:
        return self.descriptor.category

    @property
    def capabilities(self) -> frozenset[Capability]:
        return self.descriptor.capabilities

    @property
    def roles(self) -> frozenset[ProviderRole]:
        return self.descriptor.roles

    @property
    def search_constraints(self) -> frozenset[str]:
        return self.descriptor.search_constraints


class ProviderCatalog:
    """Application provider catalog with role and capability selection."""

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
        binding = self.binding(name)
        if capability not in binding.capabilities:
            raise UnsupportedCapabilityError(
                f"provider {binding.name!r} does not support {capability.value!r}"
            )
        return binding.provider

    def bindings(
        self,
        *,
        capability: Capability | None = None,
        role: ProviderRole | None = None,
        category: ProviderCategory | None = None,
    ) -> tuple[ProviderBinding, ...]:
        """Return declarations matching every supplied selector."""

        return tuple(
            binding
            for binding in self._bindings.values()
            if (capability is None or capability in binding.capabilities)
            and (role is None or role in binding.roles)
            and (category is None or category is binding.category)
        )

    def names(
        self,
        capability: Capability | None = None,
        *,
        role: ProviderRole | None = None,
        category: ProviderCategory | None = None,
    ) -> tuple[str, ...]:
        return tuple(
            binding.name
            for binding in self.bindings(
                capability=capability,
                role=role,
                category=category,
            )
        )

    def binding(self, name: str) -> ProviderBinding:
        """Return one complete declaration by case-insensitive name."""

        binding = self._bindings.get(name.casefold())
        if binding is None:
            known = ", ".join(self.names()) or "(none)"
            raise ProviderNotFoundError(f"unknown provider {name!r}; registered providers: {known}")
        return binding

    def describe(self) -> tuple[ProviderDescriptor, ...]:
        """Return stable declarations for every provider."""

        return tuple(
            ProviderDescriptor(
                name=binding.name,
                category=binding.category.value,
                roles=tuple(sorted(role.value for role in binding.roles)),
                capabilities=tuple(sorted(capability.value for capability in binding.capabilities)),
                search_constraints=tuple(sorted(binding.search_constraints)),
            )
            for binding in self._bindings.values()
        )
