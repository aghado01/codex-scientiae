"""The article manifest: one bounded JSON object per deposited article.

A document kind, not a store -- `article.json` holds one object, so it has records neither to index
nor to iterate. It shares schema binding, text policy, and naming with every other kind and differs
only in the writer it reaches for.

Assembling an article is mint()'s job, from one data structure. The schema declares `schema` and
`state` as const, so neither is restated here; a signature enumerating the rest would be a second
copy of article.schema.json that goes stale the moment the schema moves.
"""

from typing import Any, Dict

import jsonschema

from ..writer import write_json
from .base import BaseStore
from .catalog import KindCatalog


@KindCatalog.register
class ArticleManifest(BaseStore):
    KIND = "article"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    NAME_FORMAT = "article.json"

    def publish(self, values: Dict[str, Any]) -> str:
        """Mint, validate, and create one article manifest atomically.

        An article is an immutable source-ready sentinel. Existing-file validation and idempotent
        return are deposit-service concerns; this primitive never replaces an existing article.
        """
        record = self.validate_record(self.mint(values))
        out_path = self.get_output_path()
        return write_json(
            out_path,
            record,
            encoding=self.ENCODING,
            codec=self.CODEC,
            indent=2,
            overwrite=False,
        )

    def validate_record(self, record: Dict[str, Any]) -> Dict[str, Any]:
        """Validate article shape plus the relationships established by deposit assembly."""
        if isinstance(record, dict) and record.get("__type__") == "header":
            raise jsonschema.ValidationError("an article manifest cannot be a JSONL header")
        record = super().validate_record(record)

        indexed_forms = list(enumerate(record["source_forms"]))
        archive_index, archive = next(
            item for item in indexed_forms if item[1]["role"] == "latex-source-archive"
        )
        tree_index, tree = next(
            item for item in indexed_forms if item[1]["role"] == "latex-source-tree"
        )
        latex_evidence = record["evidence"]["latex_source"]

        def conflict(message: str, *path: Any) -> None:
            raise jsonschema.ValidationError(message, path=path)

        if archive_index != 0 or tree_index != 1:
            conflict(
                "source_forms must begin with the sole archive followed by the sole source tree",
                "source_forms",
            )
        if archive["path"] != f"{record['slug']}.tar.gz":
            conflict(
                "latex-source-archive path must be '<slug>.tar.gz'",
                "source_forms",
                archive_index,
                "path",
            )
        if tree["path"] != f"{record['slug']}-tex":
            conflict(
                "latex-source-tree path must be '<slug>-tex'",
                "source_forms",
                tree_index,
                "path",
            )
        if tree["tex_files"] > tree["files"]:
            conflict(
                "latex-source-tree tex_files cannot exceed files",
                "source_forms",
                tree_index,
                "tex_files",
            )
        if tree["derived_from"] != archive["path"]:
            conflict(
                "latex-source-tree derived_from must equal the sole archive path",
                "source_forms",
                tree_index,
                "derived_from",
            )
        if latex_evidence["entrypoint"] != tree["entrypoint"]:
            conflict(
                "evidence latex_source entrypoint must equal the source-tree entrypoint",
                "evidence",
                "latex_source",
                "entrypoint",
            )
        if latex_evidence["selection"] != tree["entrypoint_selection"]:
            conflict(
                "evidence latex_source selection must equal the source-tree entrypoint_selection",
                "evidence",
                "latex_source",
                "selection",
            )
        return record

    def validate(self, record: Dict[str, Any]) -> None:
        """Implement the validator protocol used by strict JSON readers."""
        self.validate_record(record)

    def read(self) -> Any:
        """Read one manifest back under this kind's declared policy and schema."""
        from ..reader import read_json

        return read_json(
            self.get_output_path(),
            encoding=self.ENCODING,
            validator=self,
        )
