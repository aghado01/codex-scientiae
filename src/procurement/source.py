"""Named source-deposit requests, results, and filesystem transactions."""

from __future__ import annotations

import os
import stat
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, Annotated, Any, Iterator, Literal, Self

from filelock import FileLock, Timeout
from pydantic import Field, field_validator, model_validator

from jsonl_engine.inventory_catalog import (
    MAX_ARTICLE_MANIFEST_BYTES,
    MAX_CATALOG_CHILDREN,
)
from jsonl_engine.kinds.article import ArticleManifest
from jsonl_engine.reader import loads
from jsonl_engine.sidecar import lock_path
from jsonl_engine.writer import write_json
from procurement.archive import ArchiveExtraction, LatexSourceInspection, LatexSourceInspector
from procurement.errors import SourceMaterializationError
from procurement.filesystem import (
    is_link_or_reparse,
    read_bounded_regular_file,
    require_physical_directory,
)
from procurement.limits import MAX_DEPOSIT_METADATA_BUNDLE_BYTES
from procurement.identifiers import is_doi, normalize_doi
from procurement.models import (
    ArtifactReference,
    DepositMetadataBundle,
    DomainModel,
    PORTABLE_LEAF_PATTERN,
    WorkIdentityAnchor,
    validate_artifact_deposit_reference,
    validate_deposit_slug,
)
from procurement.storage.schemas import get_procurement_schema_catalog

if TYPE_CHECKING:
    from procurement.services.catalog import ArticleCatalogService

MetadataMode = Literal["required", "omit"]
SourcePublication = Literal["published-new-tree", "recovered-existing-tree"]
PORTABLE_RELATIVE_PATTERN = (
    r"^(?!(?:.*\/)?(?:[Cc][Oo][Nn]|[Pp][Rr][Nn]|[Aa][Uu][Xx]|[Nn][Uu][Ll]|"
    r"[Cc][Oo][Mm][1-9]|[Ll][Pp][Tt][1-9])(?:\.|\/|$))"
    r"(?!(?:.*\/)?\.{1,2}(?:\/|$))(?!.*[ .](?:\/|$))"
    r"(?!.*[<>:\"\\|?*\u0000-\u001F])[^/]+(?:/[^/]+)*$"
)
PORTABLE_TEX_PATH_PATTERN = PORTABLE_RELATIVE_PATTERN[:-1] + r"\.[Tt][Ee][Xx]$"


def _same_artifact(left: ArtifactReference, right: ArtifactReference) -> bool:
    return (
        left.provider.casefold() == right.provider.casefold()
        and left.identifier.casefold() == right.identifier.casefold()
        and frozenset(left.provider_roles) == frozenset(right.provider_roles)
    )


def validate_source_relative_path(value: str) -> str:
    """Return one normalized portable relative source path."""

    if (
        not value
        or "\\" in value
        or value.startswith("/")
        or value.endswith("/")
        or ":" in value
    ):
        raise ValueError("main_tex must be a normalized portable relative path")
    parts = value.split("/")
    if any(validate_deposit_slug(part) != part for part in parts):
        raise ValueError("main_tex must be a normalized portable relative path")
    if not value.casefold().endswith(".tex"):
        raise ValueError("main_tex must name a .tex source file")
    return value


def _metadata_fallback_names(value: object) -> tuple[str, ...] | None:
    """Return distinct configured provider names without resolving them."""

    if value is None:
        return None
    if isinstance(value, str) or not isinstance(value, (list, tuple)):
        raise ValueError("fallback_sources must be a sequence or null")
    result: list[str] = []
    seen: set[str] = set()
    for item in value:
        if not isinstance(item, str) or not item.strip():
            raise ValueError("metadata fallback names must be non-empty strings")
        name = item.strip()
        key = name.casefold()
        if key in seen:
            raise ValueError("metadata fallback names must be unique")
        seen.add(key)
        result.append(name)
    return tuple(result)


class ArtifactIdentityMetadata(DomainModel):
    """Resolve bibliography from the acquisition artifact identity."""

    mode: Literal["artifact-identity"] = "artifact-identity"
    fallback_sources: tuple[str, ...] | None = None

    @field_validator("fallback_sources", mode="before")
    @classmethod
    def _fallbacks(cls, value: object) -> tuple[str, ...] | None:
        return _metadata_fallback_names(value)


class ExplicitDoiMetadata(DomainModel):
    """Resolve bibliography from one caller-selected DOI identity."""

    mode: Literal["explicit-doi"] = "explicit-doi"
    doi: str
    fallback_sources: tuple[str, ...] | None = None

    @field_validator("doi", mode="before")
    @classmethod
    def _canonical_doi(cls, value: object) -> str:
        if not is_doi(value):
            raise ValueError("explicit-doi metadata requires a complete DOI")
        return normalize_doi(value) or ""

    @field_validator("fallback_sources", mode="before")
    @classmethod
    def _fallbacks(cls, value: object) -> tuple[str, ...] | None:
        return _metadata_fallback_names(value)


class OmitArticleMetadata(DomainModel):
    """Publish a deliberately metadata-free article."""

    mode: Literal["omit"] = "omit"


SourceMetadataInput = Annotated[
    ArtifactIdentityMetadata | ExplicitDoiMetadata | OmitArticleMetadata,
    Field(discriminator="mode"),
]


class SourceMaterializationRequest(DomainModel):
    """One source-only preparation request addressed through configured names."""

    catalog: str = Field(min_length=1)
    acquisition_slug: str = Field(
        min_length=1,
        json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN},
    )
    main_tex: str | None = Field(
        default=None,
        json_schema_extra={"pattern": PORTABLE_TEX_PATH_PATTERN},
    )
    metadata: SourceMetadataInput = Field(default_factory=ArtifactIdentityMetadata)

    @field_validator("catalog", mode="before")
    @classmethod
    def _catalog_name(cls, value: object) -> str:
        if not isinstance(value, str) or not value.strip():
            raise ValueError("catalog must be a non-empty configured name")
        return value.strip()

    @field_validator("acquisition_slug", mode="before")
    @classmethod
    def _acquisition_leaf(cls, value: object) -> str:
        return validate_deposit_slug(value)

    @field_validator("main_tex", mode="before")
    @classmethod
    def _optional_main_tex(cls, value: object) -> str | None:
        if value is None:
            return None
        if not isinstance(value, str):
            raise ValueError("main_tex must be a string or null")
        text = value.strip()
        return validate_source_relative_path(text) if text else None

    @property
    def metadata_mode(self) -> MetadataMode:
        """Return the immutable article's coarse metadata state."""

        return "omit" if self.metadata.mode == "omit" else "required"

    @property
    def metadata_fallback_sources(self) -> tuple[str, ...] | None:
        """Return configured aggregator overrides for resolving strategies."""

        return getattr(self.metadata, "fallback_sources", None)

    @property
    def identity_anchor(self) -> WorkIdentityAnchor | None:
        """Return the expected durable identity anchor for explicit resolution."""

        if self.metadata.mode != "explicit-doi":
            return None
        return WorkIdentityAnchor(kind="doi", value=self.metadata.doi)


class SourceMaterializationResult(DomainModel):
    """Published source-deposit facts returned without rematerializing an inventory."""

    catalog: str = Field(min_length=1)
    slug: str = Field(min_length=1, json_schema_extra={"pattern": PORTABLE_LEAF_PATTERN})
    status: Literal["deposited", "already-deposited"]
    created: bool
    artifact: ArtifactReference
    acquisition_manifest_path: str = Field(min_length=1)
    document_directory: str = Field(min_length=1)
    article_path: str = Field(min_length=1)
    archive_path: str = Field(min_length=1)
    source_path: str = Field(min_length=1)
    metadata_path: str | None = None
    pdf_path: str | None = None
    archive_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    tree_sha256: str = Field(pattern=r"^[0-9a-f]{64}$")
    archive_kind: Literal["tar+gzip", "single-tex+gzip"]
    entrypoint: str = Field(min_length=1)
    metadata_route: Literal[
        "artifact-provider",
        "aggregator-fallback",
        "identifier-aggregator",
    ] | None = None

    @model_validator(mode="after")
    def _status_agrees(self) -> Self:
        validate_artifact_deposit_reference(
            self.artifact.provider,
            self.slug,
            self.artifact.identifier,
        )
        if self.created != (self.status == "deposited"):
            raise ValueError("created must agree with the source-deposit status")
        if (self.metadata_path is None) != (self.metadata_route is None):
            raise ValueError("metadata path and route must either both be present or both be absent")
        return self


@dataclass(frozen=True, slots=True)
class ExistingSourceDeposit:
    """Validated pre-existing sentinel and optional API metadata bundle."""

    article_present: bool
    metadata_mode: MetadataMode
    metadata: DepositMetadataBundle | None


@dataclass(frozen=True, slots=True)
class InstalledSourceTree:
    """Validated canonical tree and its current publication outcome."""

    path: str
    inspection: LatexSourceInspection
    publication: SourcePublication


def build_source_findings(
    extraction: ArchiveExtraction,
    inspection: LatexSourceInspection,
) -> dict[str, Any]:
    """Build the closed seven-probe ledger consumed by article publication."""

    checks: list[dict[str, Any]] = [
        {
            "name": "gzip-readable",
            "outcome": "passed",
            "archive_kind": extraction.archive_kind,
        }
    ]
    if extraction.archive_kind == "tar+gzip":
        checks.append(
            {
                "name": "archive-members-confined",
                "outcome": "passed",
                "entries": extraction.archive_entries,
            }
        )
    else:
        checks.append(
            {
                "name": "archive-members-confined",
                "outcome": "not-applicable",
                "reason": "single-payload gzip archive has no members to confine",
                "archive_kind": extraction.archive_kind,
            }
        )
    checks.extend(
        (
            {
                "name": "no-links-or-reparse-points",
                "outcome": "passed",
                "files": inspection.file_count,
            },
            {
                "name": "tex-valid-utf8",
                "outcome": "passed",
                "tex_files": inspection.tex_file_count,
            },
        )
    )
    if inspection.entrypoint_selection == "explicit":
        checks.append(
            {
                "name": "entrypoint-unambiguous",
                "outcome": "not-applicable",
                "reason": "entrypoint named explicitly; the ambiguity scan did not run",
                "selection": inspection.entrypoint_selection,
                "entrypoint": inspection.entrypoint,
            }
        )
    else:
        checks.append(
            {
                "name": "entrypoint-unambiguous",
                "outcome": "passed",
                "selection": inspection.entrypoint_selection,
                "entrypoint": inspection.entrypoint,
            }
        )
    checks.extend(
        (
            {
                "name": "literal-inputs-resolved",
                "outcome": "passed",
                "unresolved_input_action": "Stop",
            },
            {
                "name": "document-environment-present",
                "outcome": "passed",
                "basis": "resolved-input-text",
            },
        )
    )
    embedded = inspection.embedded_metadata
    return {
        "checks": checks,
        "declarations": {
            "title_tex": embedded.title_tex,
            "authors_tex": list(embedded.authors_tex),
            "doi": embedded.doi,
        },
        "package_control_files": [
            {
                "path": item.path,
                "bytes": item.bytes,
                "sha256": item.sha256,
            }
            for item in inspection.package_control_files
        ],
    }


class SourceDepositItem:
    """One source-materialization transaction beneath a named catalog."""

    def __init__(self, catalog: str, catalog_root: Path, directory: Path) -> None:
        self.catalog = catalog
        self.catalog_root = catalog_root
        self.directory = directory
        self.slug = directory.name
        self.article_path = directory / "article.json"
        self.metadata_path = directory / f"{self.slug}.api-metadata.json"

    def read_article(self) -> dict[str, Any] | None:
        """Return one validated article sentinel without accepting malformed occupancy."""

        if not os.path.lexists(self.article_path):
            return None
        raw = read_bounded_regular_file(
            self.article_path,
            label="article.json",
            maximum_bytes=MAX_ARTICLE_MANIFEST_BYTES,
        )
        try:
            value = loads(raw, path=str(self.article_path))
            if not isinstance(value, dict):
                raise ValueError("article.json must contain one object")
            return ArticleManifest(target_dir=str(self.directory)).validate_record(value)
        except Exception as exc:
            raise SourceMaterializationError(
                f"existing article.json is invalid: '{self.article_path}': {exc}"
            ) from exc

    def read_metadata(
        self,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
    ) -> DepositMetadataBundle | None:
        """Return the canonical API bundle after validating deposit and artifact identity."""

        if not os.path.lexists(self.metadata_path):
            return None
        raw = read_bounded_regular_file(
            self.metadata_path,
            label="API metadata bundle",
            maximum_bytes=MAX_DEPOSIT_METADATA_BUNDLE_BYTES,
        )
        try:
            value = loads(raw, path=str(self.metadata_path))
            if not isinstance(value, dict):
                raise ValueError("API metadata bundle must contain one object")
            get_procurement_schema_catalog().get_validator(
                "deposit.metadata.schema.json"
            ).validate(value)
            bundle = DepositMetadataBundle.model_validate(value)
        except Exception as exc:
            raise SourceMaterializationError(
                f"existing API metadata bundle is invalid: '{self.metadata_path}': {exc}"
            ) from exc
        if (
            bundle.deposit_slug != self.slug
            or not _same_artifact(bundle.artifact, artifact)
            or bundle.identity_anchor != identity_anchor
        ):
            raise SourceMaterializationError(
                "existing API metadata bundle does not identify the acquired artifact "
                "and requested bibliographic identity"
            )
        return bundle

    def inspect_existing(
        self,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
        requested_mode: MetadataMode,
        receipt_has_pdf: bool,
    ) -> ExistingSourceDeposit | None:
        """Validate immutable optional forms, metadata mode, and reusable evidence."""

        if type(receipt_has_pdf) is not bool:
            raise TypeError("receipt_has_pdf must be a boolean")

        article = self.read_article()
        bundle = self.read_metadata(
            artifact=artifact,
            identity_anchor=identity_anchor,
        )
        if article is None:
            if requested_mode == "omit" and bundle is not None:
                raise SourceMaterializationError(
                    "metadata-free publication is incompatible with an existing API metadata bundle"
                )
            if bundle is None:
                return None
            return ExistingSourceDeposit(
                article_present=False,
                metadata_mode="required",
                metadata=bundle,
            )
        article_mode: MetadataMode = (
            "required" if "metadata_resolution" in article["evidence"] else "omit"
        )
        if article_mode != requested_mode:
            raise SourceMaterializationError(
                f"existing article.json uses metadata mode {article_mode!r}, not {requested_mode!r}"
            )
        if article_mode == "omit" and bundle is not None:
            raise SourceMaterializationError(
                "metadata-free article.json has an unreferenced API metadata bundle"
            )
        if article_mode == "required" and bundle is None:
            raise SourceMaterializationError(
                "existing metadata-backed article.json has no canonical API metadata bundle"
            )
        article_has_pdf = any(
            form.get("role") == "pdf-source" for form in article["source_forms"]
        )
        if article_has_pdf != receipt_has_pdf:
            frozen = "included" if article_has_pdf else "omitted"
            requested = "include" if receipt_has_pdf else "omit"
            raise SourceMaterializationError(
                "article.json freezes PDF inclusion at first publication: "
                f"the sentinel {frozen} a PDF but the acquisition receipt would {requested} it"
            )
        return ExistingSourceDeposit(
            article_present=True,
            metadata_mode=article_mode,
            metadata=bundle,
        )

    def publish_metadata(
        self,
        bundle: DepositMetadataBundle,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
    ) -> DepositMetadataBundle:
        """Publish one API metadata bundle without replacing existing evidence."""

        existing = self.read_metadata(
            artifact=artifact,
            identity_anchor=identity_anchor,
        )
        if existing is not None:
            return existing
        if (
            bundle.deposit_slug != self.slug
            or not _same_artifact(bundle.artifact, artifact)
            or bundle.identity_anchor != identity_anchor
        ):
            raise SourceMaterializationError(
                "collected API metadata bundle does not identify the acquired artifact "
                "and requested bibliographic identity"
            )
        payload = bundle.model_dump(mode="json", by_alias=True)
        try:
            get_procurement_schema_catalog().get_validator(
                "deposit.metadata.schema.json"
            ).validate(payload)
        except Exception as exc:
            raise SourceMaterializationError(
                f"collected API metadata bundle does not satisfy the deposit schema: {exc}"
            ) from exc
        try:
            write_json(
                str(self.metadata_path),
                payload,
                indent=2,
                overwrite=False,
            )
        except FileExistsError:
            pass
        published = self.read_metadata(
            artifact=artifact,
            identity_anchor=identity_anchor,
        )
        if published is None:
            raise SourceMaterializationError(
                f"API metadata bundle was not published: '{self.metadata_path}'"
            )
        return published

    def install_tree(
        self,
        candidate: Path,
        candidate_inspection: LatexSourceInspection,
        *,
        inspector: LatexSourceInspector,
        main_tex: str,
    ) -> InstalledSourceTree:
        """Publish a canonical tree or recover a byte-identical existing tree."""

        destination = self.directory / f"{self.slug}-tex"
        if os.path.lexists(destination):
            existing_root = require_physical_directory(
                destination,
                label="existing source tree",
            )
            existing = inspector.inspect(existing_root, slug=self.slug, main_tex=main_tex)
            if existing.tree_sha256 != candidate_inspection.tree_sha256:
                raise SourceMaterializationError(
                    f"existing source tree conflicts with the acquired archive: '{destination}'"
                )
            return InstalledSourceTree(
                path=str(existing_root),
                inspection=existing,
                publication="recovered-existing-tree",
            )

        try:
            os.rename(candidate, destination)
        except OSError as exc:
            if not os.path.lexists(destination):
                raise SourceMaterializationError(
                    f"source tree publication failed: '{destination}'"
                ) from exc
            existing_root = require_physical_directory(
                destination,
                label="concurrently published source tree",
            )
            existing = inspector.inspect(existing_root, slug=self.slug, main_tex=main_tex)
            if existing.tree_sha256 != candidate_inspection.tree_sha256:
                raise SourceMaterializationError(
                    f"concurrently published source tree conflicts: '{destination}'"
                ) from exc
            return InstalledSourceTree(
                path=str(existing_root),
                inspection=existing,
                publication="recovered-existing-tree",
            )

        installed_root = require_physical_directory(destination, label="published source tree")
        installed = inspector.inspect(installed_root, slug=self.slug, main_tex=main_tex)
        if installed.tree_sha256 != candidate_inspection.tree_sha256:
            raise SourceMaterializationError(
                f"published source tree changed during installation: '{destination}'"
            )
        return InstalledSourceTree(
            path=str(installed_root),
            inspection=installed,
            publication="published-new-tree",
        )


class SourceDepositStore:
    """Coordinate direct-child source deposits beneath configured catalog roots."""

    def __init__(
        self,
        catalogs: "ArticleCatalogService",
        *,
        lock_timeout: float = 60.0,
    ) -> None:
        if lock_timeout <= 0:
            raise ValueError("lock_timeout must be positive")
        self._catalogs = catalogs
        self.lock_timeout = lock_timeout

    def _catalog_root(self, catalog: str) -> tuple[str, Path]:
        descriptor = self._catalogs.resolve(catalog)
        root = require_physical_directory(
            descriptor.catalog_dir,
            label=f"article catalog {descriptor.name!r}",
        )
        return descriptor.name, root

    def _locate_document(
        self,
        catalog: str,
        slug: str,
        *,
        create: bool,
    ) -> tuple[str, Path, Path | None, bool]:
        name, root = self._catalog_root(catalog)
        slug = validate_deposit_slug(slug)
        catalog_lease = FileLock(
            lock_path(str(root / ".source-materialization-catalog")),
            timeout=self.lock_timeout,
        )
        try:
            catalog_lease.acquire()
        except Timeout as exc:
            raise TimeoutError(
                f"could not acquire the catalog source lease within {self.lock_timeout}s: '{root}'"
            ) from exc
        try:
            try:
                entries = list(os.scandir(root))
            except OSError as exc:
                raise SourceMaterializationError(
                    f"article catalog could not be enumerated: '{root}'"
                ) from exc
            if len(entries) > MAX_CATALOG_CHILDREN:
                raise SourceMaterializationError(
                    f"article catalog exceeds the {MAX_CATALOG_CHILDREN}-child boundary: '{root}'"
                )
            matches = [entry for entry in entries if entry.name.casefold() == slug.casefold()]
            if len(matches) > 1 or (matches and matches[0].name != slug):
                names = sorted(entry.name for entry in matches)
                raise SourceMaterializationError(
                    f"source deposit slug {slug!r} has a portable case collision: {names}"
                )
            created = False
            if matches:
                entry = matches[0]
                try:
                    info = entry.stat(follow_symlinks=False)
                except OSError as exc:
                    raise SourceMaterializationError(
                        f"source deposit path could not be inspected: '{entry.path}'"
                    ) from exc
                if is_link_or_reparse(info) or not stat.S_ISDIR(info.st_mode):
                    raise SourceMaterializationError(
                        f"source deposit path is not a physical directory: '{entry.path}'"
                    )
                directory: Path | None = Path(entry.path).absolute()
            elif create:
                directory = root / slug
                try:
                    directory.mkdir(mode=0o700)
                except OSError as exc:
                    raise SourceMaterializationError(
                        f"source deposit directory could not be created: '{directory}'"
                    ) from exc
                created = True
            else:
                directory = None
            return name, root, directory, created
        finally:
            catalog_lease.release()

    @contextmanager
    def transaction(
        self,
        catalog: str,
        slug: str,
        *,
        create: bool = True,
    ) -> Iterator[SourceDepositItem | None]:
        """Hold one source lease without nesting the article publication lease."""

        name, root, directory, created = self._locate_document(
            catalog,
            slug,
            create=create,
        )
        if directory is None:
            yield None
            return
        lease = FileLock(
            lock_path(str(directory / ".source-materialization")),
            timeout=self.lock_timeout,
        )
        try:
            lease.acquire()
        except Timeout as exc:
            if created:
                try:
                    directory.rmdir()
                except OSError:
                    pass
            raise TimeoutError(
                f"could not acquire the source-materialization lease within "
                f"{self.lock_timeout}s: '{directory}'"
            ) from exc
        failed = False
        try:
            current_root = require_physical_directory(root, label=f"article catalog {name!r}")
            current_directory = require_physical_directory(
                directory,
                label="source deposit directory",
            )
            if current_root != root or current_directory.parent != root or current_directory.name != slug:
                raise SourceMaterializationError("source deposit directory escaped its named catalog")
            yield SourceDepositItem(name, root, current_directory)
        except BaseException:
            failed = True
            raise
        finally:
            lease.release()
            if failed and created:
                try:
                    directory.rmdir()
                except OSError:
                    pass

    def inspect_existing(
        self,
        catalog: str,
        slug: str,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
        requested_mode: MetadataMode,
        receipt_has_pdf: bool,
    ) -> ExistingSourceDeposit | None:
        """Inspect existing immutable forms and evidence without creating a catalog child."""

        with self.transaction(catalog, slug, create=False) as item:
            if item is None:
                return None
            return item.inspect_existing(
                artifact=artifact,
                identity_anchor=identity_anchor,
                requested_mode=requested_mode,
                receipt_has_pdf=receipt_has_pdf,
            )


__all__ = [
    "ArtifactIdentityMetadata",
    "ExplicitDoiMetadata",
    "ExistingSourceDeposit",
    "InstalledSourceTree",
    "MetadataMode",
    "OmitArticleMetadata",
    "PORTABLE_RELATIVE_PATTERN",
    "PORTABLE_TEX_PATH_PATTERN",
    "SourceDepositItem",
    "SourceDepositStore",
    "SourceMaterializationRequest",
    "SourceMaterializationResult",
    "SourceMetadataInput",
    "build_source_findings",
    "validate_source_relative_path",
]
