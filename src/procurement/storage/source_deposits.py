"""Generation-pinned source-deposit transactions and immutable components."""

from __future__ import annotations

import os
import stat
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterator, Literal

import jsonschema
from filelock import FileLock, Timeout
from jsonl_engine.documents import JsonDocumentError, JsonDocumentStore
from jsonl_engine.inventory_catalog import MAX_CATALOG_CHILDREN
from jsonl_engine.kinds.article import ArticleManifest
from jsonl_engine.publication import (
    PinnedPublicationRoot,
    PublicationError,
)
from jsonl_engine.sidecar import is_transaction_scratch, temp_write_path

from procurement.domain.deposits import validate_deposit_slug
from procurement.domain.materialization import MetadataMode
from procurement.domain.metadata import ArtifactReference, DepositMetadataBundle
from procurement.domain.works import WorkIdentityAnchor
from procurement.errors import SourceMaterializationError
from procurement.source.latex import LatexSourceInspection, LatexSourceInspector
from procurement.storage.catalogs import ArticleCatalogRoots
from procurement.storage.documents import DepositMetadataDocument
from procurement.storage.safety import (
    is_link_or_reparse,
    require_current,
    same_directory_generation,
)

SourcePublication = Literal["published-new-tree", "recovered-existing-tree"]


def _same_artifact(left: ArtifactReference, right: ArtifactReference) -> bool:
    return (
        left.provider.casefold() == right.provider.casefold()
        and left.identifier.casefold() == right.identifier.casefold()
        and frozenset(left.provider_roles) == frozenset(right.provider_roles)
    )


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


class SourceDepositItem:
    """One locked document generation beneath a retained article catalog."""

    def __init__(
        self,
        catalog: str,
        catalog_root: PinnedPublicationRoot,
        publication_root: PinnedPublicationRoot,
        slug: str,
    ) -> None:
        catalog_root.identity
        publication_root.identity
        self.catalog = catalog
        self.catalog_root = catalog_root
        self.publication_root = publication_root
        self.slug = validate_deposit_slug(slug)
        self.directory = Path(publication_root.path)
        if self.directory.name != self.slug:
            raise SourceMaterializationError(
                "source-deposit pin does not match its deposit slug"
            )
        self.article_path = self.directory / "article.json"
        self.metadata_path = self.directory / f"{self.slug}.api-metadata.json"
        self.archive_path = self.directory / f"{self.slug}.tar.gz"
        self.pdf_path = self.directory / f"{self.slug}.pdf"
        self.html_path = self.directory / f"{self.slug}-html"
        self.tree_path = self.directory / f"{self.slug}-tex"
        self._article = ArticleManifest(
            target_dir=str(self.directory),
            publication_root=publication_root,
        )
        self._metadata = JsonDocumentStore(
            publication_root,
            self.metadata_path.name,
            DepositMetadataDocument(),
        )

    def assert_current(self) -> None:
        """Require both catalog and document paths to retain their generations."""

        require_current(
            self.publication_root,
            label="source deposit",
            error=SourceMaterializationError,
        )
        require_current(
            self.catalog_root,
            label=f"article catalog {self.catalog!r}",
            error=SourceMaterializationError,
        )

    def exists(self, path: str | Path) -> bool:
        return self.publication_root.lexists(path)

    def read_article(self) -> dict[str, Any] | None:
        """Return one validated article sentinel without accepting malformed occupancy."""

        if not self.exists(self.article_path):
            return None
        try:
            value = self._article.read()
            if not isinstance(value, dict):
                raise ValueError("article.json must contain one object")
            return value
        except (
            jsonschema.ValidationError,
            KeyError,
            OSError,
            RuntimeError,
            StopIteration,
            TypeError,
            ValueError,
        ) as exc:
            raise SourceMaterializationError(
                f"existing article.json is invalid: '{self.article_path}': {exc}"
            ) from exc

    def read_metadata(
        self,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
    ) -> DepositMetadataBundle | None:
        """Return canonical API evidence after validating deposit and work identity."""

        try:
            bundle = self._metadata.read()
        except (JsonDocumentError, OSError, RuntimeError, ValueError) as exc:
            raise SourceMaterializationError(
                f"existing API metadata bundle is invalid: '{self.metadata_path}': {exc}"
            ) from exc
        if bundle is None:
            return None
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
        receipt_has_html: bool = False,
        rebuild: bool = False,
    ) -> ExistingSourceDeposit | None:
        """Validate immutable optional forms, metadata mode, and reusable evidence."""

        if type(receipt_has_pdf) is not bool:
            raise TypeError("receipt_has_pdf must be a boolean")
        if type(receipt_has_html) is not bool:
            raise TypeError("receipt_has_html must be a boolean")
        if type(rebuild) is not bool:
            raise TypeError("rebuild must be a boolean")
        self.assert_current()
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
        if article_has_pdf != receipt_has_pdf and not rebuild:
            frozen = "included" if article_has_pdf else "omitted"
            requested = "include" if receipt_has_pdf else "omit"
            raise SourceMaterializationError(
                "article.json freezes PDF inclusion at first publication: "
                f"the sentinel {frozen} a PDF but the acquisition receipt would {requested} it"
            )
        article_has_html = any(
            form.get("role") == "html-source" for form in article["source_forms"]
        )
        if article_has_html != receipt_has_html and not rebuild:
            frozen = "included" if article_has_html else "omitted"
            requested = "include" if receipt_has_html else "omit"
            raise SourceMaterializationError(
                "article.json freezes HTML inclusion at first publication: "
                f"the sentinel {frozen} an HTML tree but the acquisition receipt would {requested} it"
            )
        self.assert_current()
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
        try:
            self._metadata.publish(bundle, overwrite=False)
        except FileExistsError:
            pass
        except (JsonDocumentError, OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceMaterializationError(
                f"API metadata bundle could not be published: '{self.metadata_path}'"
            ) from exc
        published = self.read_metadata(
            artifact=artifact,
            identity_anchor=identity_anchor,
        )
        if published is None:
            raise SourceMaterializationError(
                f"API metadata bundle was not published: '{self.metadata_path}'"
            )
        return published

    def _require_tree_stage(self, candidate: str | Path) -> Path:
        path = Path(candidate).absolute()
        if (
            path.parent != self.directory
            or not is_transaction_scratch(self.tree_path.name, path.name)
        ):
            raise SourceMaterializationError(
                f"source tree stage is not transaction-owned scratch: '{path}'"
            )
        return path

    def sweep_tree_stages(self) -> None:
        """Remove abandoned private source-tree stages under the source lease."""

        for candidate in self.publication_root.stale_scratch(self.tree_path):
            try:
                self.publication_root.remove_owned_tree(candidate)
            except FileNotFoundError:
                continue
            except (OSError, PublicationError, RuntimeError, ValueError) as exc:
                raise SourceMaterializationError(
                    f"abandoned source tree stage could not be removed: '{candidate}'"
                ) from exc

    def new_tree_stage(self) -> Path:
        """Create one empty private tree using the process write serial convention."""

        self.sweep_tree_stages()
        candidate = Path(temp_write_path(str(self.tree_path))).absolute()
        try:
            self.publication_root.mkdir_leaf(candidate.name)
        except OSError as exc:
            raise SourceMaterializationError(
                f"private source tree stage could not be created: '{candidate}'"
            ) from exc
        return self._require_tree_stage(candidate)

    @contextmanager
    def pin_tree_stage(self, candidate: str | Path) -> Iterator[PinnedPublicationRoot]:
        """Retain one private source-tree stage while it is populated and inspected."""

        candidate_path = self._require_tree_stage(candidate)
        try:
            named = self.publication_root.stat_leaf(candidate_path.name)
            if not stat.S_ISDIR(named.st_mode) or is_link_or_reparse(named):
                raise SourceMaterializationError(
                    f"private source tree stage is not a physical directory: '{candidate_path}'"
                )
            with self.publication_root.pin_child(candidate_path.name) as tree_root:
                if not same_directory_generation(named, tree_root.stat_root()):
                    raise SourceMaterializationError(
                        f"private source tree stage changed while pinned: '{candidate_path}'"
                    )
                yield tree_root
                require_current(
                    tree_root,
                    label="private source tree stage",
                    error=SourceMaterializationError,
                )
        except SourceMaterializationError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceMaterializationError(
                f"private source tree stage could not be retained: '{candidate_path}'"
            ) from exc

    def discard_tree_stage(self, candidate: str | Path) -> None:
        """Remove one still-private tree after success or failure."""

        candidate_path = self._require_tree_stage(candidate)
        try:
            if self.publication_root.lexists(candidate_path):
                self.publication_root.remove_owned_tree(candidate_path)
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceMaterializationError(
                f"private source tree stage could not be removed: '{candidate_path}'"
            ) from exc

    def install_tree(
        self,
        candidate: Path,
        candidate_inspection: LatexSourceInspection,
        *,
        inspector: LatexSourceInspector,
        main_tex: str,
    ) -> InstalledSourceTree:
        """Atomically publish a tree or recover a byte-identical existing tree."""

        candidate = self._require_tree_stage(candidate)
        publication: SourcePublication = "published-new-tree"
        if not self.publication_root.lexists(self.tree_path):
            try:
                self.publication_root.publish_directory(candidate, self.tree_path)
            except FileExistsError:
                publication = "recovered-existing-tree"
            except (OSError, PublicationError, RuntimeError, ValueError) as exc:
                raise SourceMaterializationError(
                    f"source tree publication failed: '{self.tree_path}'"
                ) from exc
        else:
            publication = "recovered-existing-tree"

        try:
            named = self.publication_root.stat_leaf(self.tree_path.name)
            if not stat.S_ISDIR(named.st_mode) or is_link_or_reparse(named):
                raise SourceMaterializationError(
                    f"existing source tree is not a physical directory: '{self.tree_path}'"
                )
            with self.publication_root.pin_child(self.tree_path.name) as tree_root:
                if not same_directory_generation(named, tree_root.stat_root()):
                    raise SourceMaterializationError(
                        f"source tree changed while its generation was pinned: '{self.tree_path}'"
                    )
                inspection = inspector.inspect(
                    self.tree_path,
                    slug=self.slug,
                    main_tex=main_tex,
                    publication_root=tree_root,
                )
                if inspection.tree_sha256 != candidate_inspection.tree_sha256:
                    raise SourceMaterializationError(
                        "existing source tree conflicts with the acquired archive: "
                        f"'{self.tree_path}'"
                    )
        except SourceMaterializationError:
            raise
        except (OSError, PublicationError, RuntimeError, ValueError) as exc:
            raise SourceMaterializationError(
                f"published source tree could not be validated: '{self.tree_path}'"
            ) from exc
        return InstalledSourceTree(
            path=str(self.tree_path),
            inspection=inspection,
            publication=publication,
        )


class SourceDepositStore:
    """Retain catalog and document generations for source materialization."""

    def __init__(
        self,
        catalogs: ArticleCatalogRoots,
        *,
        lock_timeout: float = 60.0,
    ) -> None:
        if lock_timeout <= 0:
            raise ValueError("lock_timeout must be positive")
        self._catalogs = catalogs
        self.lock_timeout = lock_timeout

    @contextmanager
    def transaction(
        self,
        catalog: str,
        slug: str,
        *,
        create: bool = True,
    ) -> Iterator[SourceDepositItem | None]:
        """Hold the catalog generation, source lease, and document generation."""

        descriptor = self._catalogs.resolve(catalog, create=True)
        root = descriptor.publication_root
        try:
            active_identity = root.identity
        except RuntimeError as exc:
            raise SourceMaterializationError(
                f"article catalog {descriptor.name!r} descriptor is no longer active"
            ) from exc
        if active_identity != descriptor.identity:
            raise SourceMaterializationError(
                f"article catalog {descriptor.name!r} descriptor is not active"
            )
        slug = validate_deposit_slug(slug)
        directory = Path(root.absolute(slug))
        lease = FileLock(root.lock_path(directory), timeout=self.lock_timeout)
        try:
            lease.acquire()
        except Timeout as exc:
            raise TimeoutError(
                "could not acquire the source-materialization lease within "
                f"{self.lock_timeout}s: '{directory}'"
            ) from exc

        created = False
        failed = False
        created_generation: os.stat_result | None = None
        try:
            require_current(
                root,
                label=f"article catalog {descriptor.name!r}",
                error=SourceMaterializationError,
            )
            names = root.list_names()
            if len(names) > MAX_CATALOG_CHILDREN:
                raise SourceMaterializationError(
                    "article catalog exceeds the "
                    f"{MAX_CATALOG_CHILDREN}-child boundary: '{root.path}'"
                )
            matches = [name for name in names if name.casefold() == slug.casefold()]
            if len(matches) > 1 or (matches and matches[0] != slug):
                raise SourceMaterializationError(
                    f"source deposit slug {slug!r} has a portable case collision: {sorted(matches)}"
                )
            if not matches:
                if not create:
                    yield None
                    return
                try:
                    root.mkdir_leaf(slug)
                except OSError as exc:
                    raise SourceMaterializationError(
                        f"source deposit directory could not be created: '{directory}'"
                    ) from exc
                created = True
            named = root.stat_leaf(slug)
            if created:
                created_generation = named
            if not stat.S_ISDIR(named.st_mode) or is_link_or_reparse(named):
                raise SourceMaterializationError(
                    f"source deposit path is not a physical directory: '{directory}'"
                )
            with root.pin_child(slug) as document_root:
                if not same_directory_generation(named, document_root.stat_root()):
                    raise SourceMaterializationError(
                        f"source deposit changed while its generation was pinned: '{directory}'"
                    )
                item = SourceDepositItem(
                    descriptor.name,
                    root,
                    document_root,
                    slug,
                )
                try:
                    yield item
                    item.assert_current()
                except BaseException:
                    failed = True
                    raise
            require_current(
                root,
                label=f"article catalog {descriptor.name!r}",
                error=SourceMaterializationError,
            )
        except BaseException:
            failed = True
            raise
        finally:
            if failed and created:
                try:
                    current = root.stat_leaf(slug)
                    if created_generation is not None and same_directory_generation(
                        created_generation,
                        current,
                    ):
                        root.rmdir_leaf(slug)
                except OSError:
                    pass
            lease.release()

    def inspect_existing(
        self,
        catalog: str,
        slug: str,
        *,
        artifact: ArtifactReference,
        identity_anchor: WorkIdentityAnchor | None = None,
        requested_mode: MetadataMode,
        receipt_has_pdf: bool,
        receipt_has_html: bool = False,
        rebuild: bool = False,
    ) -> ExistingSourceDeposit | None:
        """Inspect immutable evidence without creating a document directory."""

        with self.transaction(catalog, slug, create=False) as item:
            if item is None:
                return None
            return item.inspect_existing(
                artifact=artifact,
                identity_anchor=identity_anchor,
                requested_mode=requested_mode,
                receipt_has_pdf=receipt_has_pdf,
                receipt_has_html=receipt_has_html,
                rebuild=rebuild,
            )


__all__ = [
    "ExistingSourceDeposit",
    "InstalledSourceTree",
    "SourceDepositItem",
    "SourceDepositStore",
]
