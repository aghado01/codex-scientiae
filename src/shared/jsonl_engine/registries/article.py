"""Article manifest registry.

One bounded JSON object per deposited article, written to `{slug}/article.json` by the source-deposit
transaction. Its presence is the deposit's success sentinel.

The same schema governs an inventory row. An article object is inserted into `inventory.jsonl`
verbatim, so no projection or row shape exists.

Publication is not implemented here. `article.json` is a single object rather than a JSONL store, and
the engine's atomic single-object writer does not exist yet; this class currently supplies the kind
declaration and mints validated article objects.
"""

from typing import Any, Dict, List, Optional

from ..registry import BaseStore
from .catalog import RegistryCatalog


@RegistryCatalog.register
class ArticleRegistry(BaseStore):
    KIND = "article"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    EMIT_HEADER = False
    NAME_FORMAT = "article.json"
    PARENT_KIND = "inventory"
    CHILD_KINDS = ["docgraph"]

    def add_article(
        self,
        slug: str,
        initialized_utc: str,
        title: Optional[str],
        authors: List[str],
        abstract: Optional[str],
        identifiers: Dict[str, Any],
        categories: List[str],
        evidence: Dict[str, Any],
        source_forms: List[Dict[str, Any]],
        validation: Dict[str, Any],
        primary_category: Optional[str] = None,
        published: Optional[str] = None,
        updated: Optional[str] = None,
    ) -> Dict[str, Any]:
        """Assemble one article object, validate it, and buffer it. Returns the validated object."""
        article: Dict[str, Any] = {
            "schema": "codex-scientiae/article/0.1",
            "state": "source-ready",
            "slug": slug,
            "initialized_utc": initialized_utc,
            "title": title,
            "authors": authors,
            "abstract": abstract,
            "identifiers": identifiers,
            "categories": categories,
            "primary_category": primary_category,
            "published": published,
            "updated": updated,
            "evidence": evidence,
            "source_forms": source_forms,
            "validation": validation,
        }
        self.add(article)
        return article
