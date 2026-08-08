"""The article manifest: one bounded JSON object per deposited article.

A document kind, not a store -- `article.json` holds one object, so it has records neither to index
nor to iterate. It shares schema binding, text policy, and naming with every other kind and differs
only in the writer it reaches for.

Assembling an article is mint()'s job, from one data structure. The schema declares `schema` and
`state` as const, so neither is restated here; a signature enumerating the rest would be a second
copy of article.schema.json that goes stale the moment the schema moves.
"""

import os
from typing import Any, Dict, Optional

from ..writer import write_json
from .base import BaseStore
from .catalog import KindCatalog


@KindCatalog.register
class ArticleManifest(BaseStore):
    KIND = "article"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    NAME_FORMAT = "article.json"

    def publish(
        self,
        values: Dict[str, Any],
        *,
        stem: Optional[str] = None,
        filename: Optional[str] = None,
    ) -> str:
        """Mint, validate, and write one article manifest atomically. Returns the path written."""
        record = self.validate_record(self.mint(values))
        out_path = self.get_output_path(stem=stem, filename=filename)
        return write_json(
            out_path, record, encoding=self.ENCODING, codec=self.CODEC, indent=2
        )

    def read(self, *, stem: Optional[str] = None, filename: Optional[str] = None) -> Any:
        """Read one manifest back under this kind's declared policy and schema."""
        from ..reader import read_json

        return read_json(
            self.get_output_path(stem=stem, filename=filename),
            encoding=self.ENCODING,
            validator=self._payload_validator,
        )
