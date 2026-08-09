"""Kind discovery: KIND string -> declaring class.

A catalog is an in-memory index of what is available. It is not a registry -- nothing is keyed,
ordered, or published here; see registry.py for the category that word now names.
"""

from typing import Dict, List, Optional, Type

from .base import BaseStore


class KindCatalog:
    """Registers and instantiates artifact kinds by KIND."""

    _classes: Dict[str, Type[BaseStore]] = {}

    @classmethod
    def register(cls, kind_cls: Type[BaseStore]) -> Type[BaseStore]:
        """Class decorator. Indexes a kind by its declared KIND."""
        kind = kind_cls.KIND
        if not kind or kind == "base":
            raise ValueError(
                f"Cannot register base or empty KIND for kind class {kind_cls.__name__}"
            )
        cls._classes[kind] = kind_cls
        return kind_cls

    @classmethod
    def get(cls, kind: str) -> Type[BaseStore]:
        if kind not in cls._classes:
            raise KeyError(
                f"No kind registered for '{kind}'. Available: {sorted(cls._classes)}"
            )
        return cls._classes[kind]

    @classmethod
    def create(
        cls, kind: str, target_dir: str, run_id: Optional[str] = None, **kwargs
    ) -> BaseStore:
        return cls.get(kind)(target_dir=target_dir, run_id=run_id, **kwargs)

    @classmethod
    def kinds(cls) -> List[str]:
        return sorted(cls._classes)
