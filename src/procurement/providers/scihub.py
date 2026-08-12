"""Sci-Hub access-source declaration."""

from procurement.providers.base import (
    ProviderCategory,
    ProviderDefinition,
    ProviderRole,
)


class SciHubProvider:
    """Declared Sci-Hub identity without callable acquisition operations."""

    descriptor = ProviderDefinition(
        name="scihub",
        category=ProviderCategory.ACCESS_SOURCE,
        capabilities=frozenset(),
        roles=frozenset({ProviderRole.ARTIFACT_ACCESS}),
    )
    name = descriptor.name
    search_constraints = descriptor.search_constraints
