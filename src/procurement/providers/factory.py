"""Provider construction declarations and immutable factory catalogs."""

from __future__ import annotations

from collections.abc import Callable, Iterable, Mapping
from dataclasses import dataclass, field
from types import MappingProxyType
from typing import Any

from procurement.http import HttpClient
from procurement.providers.base import ProviderDefinition
from procurement.providers.catalog import ProviderBinding, ProviderCatalog
from procurement.settings import (
    ArtifactLimitSettings,
    ProviderHttpSettings,
    RuntimeSecrets,
)

ProviderConstructor = Callable[["ProviderBuildContext"], Any]
ProviderSettingsValidator = Callable[[ProviderHttpSettings], None]


@dataclass(frozen=True, slots=True)
class ProviderBuildContext:
    """Dependencies supplied to one provider constructor."""

    http: HttpClient
    settings: ProviderHttpSettings | None
    secrets: RuntimeSecrets
    artifact_limits: ArtifactLimitSettings

    def require_settings(self, provider_name: str) -> ProviderHttpSettings:
        """Return configured settings for a provider that requires them."""

        if self.settings is None:
            raise ValueError(f"provider {provider_name!r} requires HTTP settings")
        return self.settings


@dataclass(frozen=True, slots=True)
class ProviderFactory:
    """One adapter type, constructor, and optional settings validator."""

    adapter_type: type[Any]
    constructor: ProviderConstructor
    requires_settings: bool = True
    settings_validator: ProviderSettingsValidator | None = None
    descriptor: ProviderDefinition = field(init=False)

    def __post_init__(self) -> None:
        descriptor = getattr(self.adapter_type, "descriptor", None)
        if not isinstance(descriptor, ProviderDefinition):
            raise ValueError("provider adapter types require an immutable descriptor")
        object.__setattr__(self, "descriptor", descriptor)
        if not callable(self.constructor):
            raise ValueError(f"provider {descriptor.name!r} requires a constructor")
        if not self.requires_settings and self.settings_validator is not None:
            raise ValueError(
                f"declaration-only provider {descriptor.name!r} cannot validate HTTP settings"
            )

    @property
    def name(self) -> str:
        return self.descriptor.name

    def validate_settings(self, settings: ProviderHttpSettings | None) -> None:
        """Validate provider-specific configuration before runtime allocation."""

        if self.requires_settings and settings is None:
            raise ValueError(f"provider {self.name!r} requires HTTP settings")
        if not self.requires_settings and settings is not None:
            raise ValueError(f"provider {self.name!r} does not accept HTTP settings")
        if settings is not None and self.settings_validator is not None:
            self.settings_validator(settings)

    def bind(self, context: ProviderBuildContext) -> ProviderBinding:
        """Construct and validate one runtime provider binding."""

        self.validate_settings(context.settings)
        provider = self.constructor(context)
        if not isinstance(provider, self.adapter_type):
            raise ValueError(
                f"provider factory {self.name!r} returned {type(provider).__name__!r}, "
                f"expected {self.adapter_type.__name__!r}"
            )
        return ProviderBinding(provider, self.descriptor)

    @classmethod
    def configured(
        cls,
        adapter_type: type[Any],
        *,
        artifact_limits: bool = False,
        settings_validator: ProviderSettingsValidator | None = None,
    ) -> "ProviderFactory":
        """Declare an adapter with the standard configured constructor shape."""

        descriptor = getattr(adapter_type, "descriptor", None)
        name = descriptor.name if isinstance(descriptor, ProviderDefinition) else "provider"

        if artifact_limits:

            def construct(context: ProviderBuildContext) -> Any:
                return adapter_type(
                    context.http,
                    context.require_settings(name),
                    context.secrets,
                    context.artifact_limits,
                )

        else:

            def construct(context: ProviderBuildContext) -> Any:
                return adapter_type(
                    context.http,
                    context.require_settings(name),
                    context.secrets,
                )

        return cls(
            adapter_type=adapter_type,
            constructor=construct,
            requires_settings=True,
            settings_validator=settings_validator,
        )

    @classmethod
    def declaration_only(cls, adapter_type: type[Any]) -> "ProviderFactory":
        """Declare an adapter that has no configured runtime dependencies."""

        def construct(_context: ProviderBuildContext) -> Any:
            return adapter_type()

        return cls(
            adapter_type=adapter_type,
            constructor=construct,
            requires_settings=False,
        )


@dataclass(frozen=True, slots=True, init=False)
class ProviderFactoryCatalog:
    """Immutable ordered catalog of provider construction declarations."""

    _factories: tuple[ProviderFactory, ...]
    _by_name: Mapping[str, ProviderFactory]

    def __init__(self, factories: Iterable[ProviderFactory] = ()) -> None:
        ordered = tuple(factories)
        by_name: dict[str, ProviderFactory] = {}
        for factory in ordered:
            if not isinstance(factory, ProviderFactory):
                raise TypeError("provider factory catalogs contain ProviderFactory values")
            if factory.name in by_name:
                raise ValueError(f"provider factory already declared: {factory.name}")
            by_name[factory.name] = factory
        object.__setattr__(self, "_factories", ordered)
        object.__setattr__(self, "_by_name", MappingProxyType(by_name))

    def factories(self) -> tuple[ProviderFactory, ...]:
        return self._factories

    def names(self, *, requires_settings: bool | None = None) -> tuple[str, ...]:
        return tuple(
            factory.name
            for factory in self._factories
            if requires_settings is None or factory.requires_settings is requires_settings
        )

    def factory(self, name: str) -> ProviderFactory:
        factory = self._by_name.get(name.casefold())
        if factory is None:
            known = ", ".join(self.names()) or "(none)"
            raise ValueError(f"unknown provider factory {name!r}; declared providers: {known}")
        return factory

    def definition(self, name: str) -> ProviderDefinition:
        return self.factory(name).descriptor

    def definitions(self) -> tuple[ProviderDefinition, ...]:
        return tuple(factory.descriptor for factory in self._factories)

    def extended(self, *factories: ProviderFactory) -> "ProviderFactoryCatalog":
        """Return a new catalog with additional declarations appended."""

        return ProviderFactoryCatalog((*self._factories, *factories))

    def validate_settings(self, settings: Mapping[str, ProviderHttpSettings]) -> None:
        """Validate exact configured-provider coverage and adapter-specific settings."""

        configured = set(settings)
        expected = set(self.names(requires_settings=True))
        unsupported = configured.difference(expected)
        if unsupported:
            raise ValueError(
                "provider settings name adapters without implementations: "
                + ", ".join(sorted(unsupported))
            )
        missing = expected.difference(configured)
        if missing:
            raise ValueError(
                f"discovery settings omit providers: {', '.join(sorted(missing))}"
            )
        for factory in self._factories:
            factory.validate_settings(settings.get(factory.name))

    def build(
        self,
        settings: Mapping[str, ProviderHttpSettings],
        *,
        http: HttpClient,
        secrets: RuntimeSecrets,
        artifact_limits: ArtifactLimitSettings,
    ) -> ProviderCatalog:
        """Construct the runtime catalog from validated settings and dependencies."""

        self.validate_settings(settings)
        bindings = []
        for factory in self._factories:
            context = ProviderBuildContext(
                http=http,
                settings=settings.get(factory.name),
                secrets=secrets,
                artifact_limits=artifact_limits,
            )
            bindings.append(factory.bind(context))
        return ProviderCatalog(bindings)
