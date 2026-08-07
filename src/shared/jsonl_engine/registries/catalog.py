"""
src/shared/jsonl_engine/registries/catalog.py - Central Registry Catalog & Factory
"""

from typing import Dict, List, Optional, Type
from ..registry import BaseStore


class RegistryCatalog:
    """
    Central Registry Catalog and Factory.
    Registers, discovers, and instantiates artifact registries by KIND,
    and captures hierarchical parent-child relationships between artifact kinds.
    """
    _registry_classes: Dict[str, Type[BaseStore]] = {}

    @classmethod
    def register(cls, registry_cls: Type[BaseStore]) -> Type[BaseStore]:
        """Decorator or method to register an artifact registry class by its KIND."""
        kind = registry_cls.KIND
        if not kind or kind == "base":
            raise ValueError(f"Cannot register base or empty KIND for registry class {registry_cls.__name__}")
        cls._registry_classes[kind] = registry_cls
        return registry_cls

    @classmethod
    def get_registry_class(cls, kind: str) -> Type[BaseStore]:
        """Retrieves a registered BaseStore subclass by KIND."""
        if kind not in cls._registry_classes:
            raise KeyError(f"No artifact registry registered for KIND '{kind}'. Available: {list(cls._registry_classes.keys())}")
        return cls._registry_classes[kind]

    @classmethod
    def create(cls, kind: str, target_dir: str, run_id: Optional[str] = None, **kwargs) -> BaseStore:
        """Factory method to instantiate an artifact registry by KIND."""
        registry_cls = cls.get_registry_class(kind)
        return registry_cls(target_dir=target_dir, run_id=run_id, **kwargs)

    @classmethod
    def list_kinds(cls) -> List[str]:
        """Returns all registered artifact kinds."""
        return sorted(cls._registry_classes.keys())
