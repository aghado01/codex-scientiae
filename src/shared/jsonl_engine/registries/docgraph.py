"""
src/shared/jsonl_engine/registries/docgraph.py - DocGraph Node/Edge Artifact Registry
"""

# Note: this needs to be disambiguated from a document's ref-graph, a first class object that can be obtained from latex source and, aspirationally, PDF source parsing
# A docgraph proper is related to the latent manifest shape or "protograph", of which a doc graph is a specific instantiation
# Graph is the abstraction here, anda need to consider the base data structure of graph objects in jsonl format


from typing import Dict, Any, List, Optional
from ..registry import BaseArtifactRegistry
from .catalog import RegistryCatalog


@RegistryCatalog.register
class DocGraphRegistry(BaseArtifactRegistry):
    KIND = "docgraph"
    VERSION = "0.1"
    RECORD_SCHEMA = "docgraph.schema.json"
    EMIT_HEADER = False
    NAME_FORMAT = "{stem}.docgraph.jsonl"
    PARENT_KIND = "article"

    def add_node(self, node_id: str, label: str, node_class: str, properties: Optional[Dict[str, Any]] = None) -> None:
        rec = {
            "type": "node",
            "id": node_id,
            "label": label,
            "class": node_class
        }
        if properties:
            rec["properties"] = properties
        self.add(rec)

    def add_edge(self, source: str, target: str, relation: str) -> None:
        self.add({
            "type": "edge",
            "source": source,
            "target": target,
            "relation": relation
        })
