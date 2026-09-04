"""The article manifest: one bounded JSON object per deposited article.

A document kind, not a store -- `article.json` holds one object, so it has records neither to index
nor to iterate. It shares schema binding, text policy, and naming with every other kind and differs
only in the writer it reaches for.

Assembling an article is mint()'s job, from one data structure. The schema declares `schema` and
`state` as const, so neither is restated here; a signature enumerating the rest would be a second
copy of article.schema.json that goes stale the moment the schema moves.
"""

from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Any, Dict

import jsonschema

from ..writer import write_json
from .base import BaseStore
from .catalog import KindCatalog

MAX_ARTICLE_MANIFEST_BYTES = 4 * 1024 * 1024


def source_archive_names(slug: str) -> tuple[str, str]:
    """Return the accepted LaTeX archive leaves for one deposit slug."""

    return (f"{slug}.tar.gz", f"arXiv-{slug}.tar.gz")


@dataclass(frozen=True, slots=True)
class ArticleMetadataContribution:
    """Validated bibliographic and evidence values contributed by an application extension."""

    article: Dict[str, Any]
    evidence: Dict[str, Any]
    resolution: Dict[str, Any]


class ArticleMetadataExtension(ABC):
    """Application-owned validator and projector for one external metadata document."""

    @property
    @abstractmethod
    def maximum_bytes(self) -> int:
        """Return the maximum accepted encoded document size."""

    @abstractmethod
    def project(
        self,
        value: Dict[str, Any],
        *,
        raw: bytes,
        path: str,
        slug: str,
    ) -> ArticleMetadataContribution:
        """Validate one document and return article-schema values derived from it."""


@KindCatalog.register
class ArticleManifest(BaseStore):
    KIND = "article"
    VERSION = "0.1"
    RECORD_SCHEMA = "article.schema.json"
    NAME_FORMAT = "article.json"

    def publish(self, values: Dict[str, Any], *, overwrite: bool = False) -> str:
        """Mint, validate, and create one article manifest atomically.

        An article is an immutable source-ready sentinel by default. Existing-file validation and
        idempotent return are deposit-service concerns. ``overwrite=True`` is the explicit rebuild
        path; this primitive still does not infer replacement.
        """
        record = self.validate_record(self.mint(values))
        out_path = self.get_output_path()
        root = self.publication_root
        if root is not None:
            root.assert_current()
        published = write_json(
            out_path,
            record,
            encoding=self.ENCODING,
            codec=self.CODEC,
            indent=2,
            overwrite=overwrite,
            publication_root=root,
        )
        if root is not None:
            root.assert_current()
        return published

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
        if archive["path"] not in source_archive_names(record["slug"]):
            conflict(
                "latex-source-archive path must be '<slug>.tar.gz' or 'arXiv-<slug>.tar.gz'",
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

        html_forms = [
            (index, form)
            for index, form in indexed_forms
            if form.get("role") == "html-source"
        ]
        if len(html_forms) > 1:
            conflict("source_forms may contain at most one html-source", "source_forms")
        if html_forms:
            html_index, html = html_forms[0]
            if html_index < 2:
                conflict(
                    "html-source cannot occupy the archive or source-tree slots",
                    "source_forms",
                    html_index,
                )
            if html.get("path") != f"{record['slug']}-html":
                conflict(
                    "html-source path must be '<slug>-html'",
                    "source_forms",
                    html_index,
                    "path",
                )
            if html.get("entrypoint") != f"{record['slug']}.html":
                conflict(
                    "html-source entrypoint must be '<slug>.html'",
                    "source_forms",
                    html_index,
                    "entrypoint",
                )

        resolution = record["evidence"].get("metadata_resolution")
        api_evidence = [
            item
            for item in record["evidence"]["provider_metadata"]
            if item.get("role") == "api-metadata-bundle"
        ]
        if resolution is not None:
            if len(api_evidence) != 1:
                conflict(
                    "metadata resolution requires exactly one API metadata bundle record",
                    "evidence",
                    "provider_metadata",
                )
            bundle = api_evidence[0]
            relationships = (
                ("route", "route"),
                ("selected_provider", "provider"),
                ("selected_provider_roles", "provider_roles"),
            )
            for resolution_field, bundle_field in relationships:
                if resolution[resolution_field] != bundle[bundle_field]:
                    conflict(
                        f"metadata resolution {resolution_field} must match API evidence",
                        "evidence",
                        "metadata_resolution",
                        resolution_field,
                    )
            artifact = resolution["artifact"]
            if artifact["provider"] != bundle["artifact_provider"] or artifact[
                "provider_roles"
            ] != bundle["artifact_provider_roles"]:
                conflict(
                    "metadata resolution artifact must match API evidence",
                    "evidence",
                    "metadata_resolution",
                    "artifact",
                )
            anchor = resolution.get("identity_anchor")
            if anchor is not None and record["identifiers"].get("doi") != anchor["value"]:
                conflict(
                    "DOI identity anchor must equal the projected article DOI",
                    "evidence",
                    "metadata_resolution",
                    "identity_anchor",
                    "value",
                )
        return record

    def validate(self, record: Dict[str, Any]) -> None:
        """Implement the validator protocol used by strict JSON readers."""
        self.validate_record(record)

    def read(self) -> Any:
        """Read one manifest back under this kind's declared policy and schema."""
        from ..reader import loads, read_json

        path = self.get_output_path()
        root = self.publication_root
        if root is None:
            return read_json(
                path,
                encoding=self.ENCODING,
                validator=self,
            )
        root.assert_current()
        raw = root.read_bytes(path, maximum_bytes=MAX_ARTICLE_MANIFEST_BYTES)
        value = loads(raw, path=path, encoding=self.ENCODING, validator=self)
        root.assert_current()
        return value


__all__ = [
    "ArticleManifest",
    "ArticleMetadataContribution",
    "ArticleMetadataExtension",
    "MAX_ARTICLE_MANIFEST_BYTES",
]
