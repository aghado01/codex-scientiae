"""Generation-pinned acquisition receipt storage and crash recovery."""

from __future__ import annotations

import hashlib
import os
import stat
from contextlib import contextmanager
from pathlib import Path
from typing import Iterator

from filelock import FileLock, Timeout

from jsonl_engine.documents import JsonDocumentError, JsonDocumentStore
from jsonl_engine.inventory_catalog import MAX_CATALOG_CHILDREN
from jsonl_engine.publication import PinnedPublicationRoot
from procurement.domain.acquisition.receipts import AcquiredArtifact, AcquisitionManifest
from procurement.domain.deposits import validate_deposit_slug
from procurement.domain.metadata import ArtifactReference
from procurement.errors import AcquisitionConflictError, AcquisitionError
from procurement.storage.catalogs import (
    ArticleCatalogConfigurationError,
    ArticleCatalogRoots,
)
from procurement.storage.documents import AcquisitionManifestDocument
from procurement.storage.roots import ConfiguredRootDescriptor, ConfiguredRootKind
from procurement.storage.safety import (
    is_link_or_reparse,
    require_current,
    same_directory_generation,
)

_JOURNAL_LEAF = ".acquisition-publish.json"
_PARTIAL_LEAF = ".download.part"
_FORM_ORDER = {"source": 0, "pdf": 1, "html": 2}
_ACQUISITION_ROOT_KINDS = frozenset(
    {
        ConfiguredRootKind.STAGING,
        ConfiguredRootKind.ARTICLE_CATALOG,
    }
)


def _measure_file(path: Path) -> tuple[int, str]:
    digest = hashlib.sha256()
    size = 0
    try:
        with path.open("rb") as handle:
            before = os.fstat(handle.fileno())
            if not stat.S_ISREG(before.st_mode) or is_link_or_reparse(before):
                raise AcquisitionConflictError(f"artifact is not a regular file: '{path}'")
            while chunk := handle.read(1024 * 1024):
                size += len(chunk)
                digest.update(chunk)
            after = os.fstat(handle.fileno())
    except AcquisitionConflictError:
        raise
    except OSError as exc:
        raise AcquisitionConflictError(f"artifact cannot be measured: '{path}'") from exc
    if (
        size != after.st_size
        or before.st_dev != after.st_dev
        or before.st_ino != after.st_ino
        or before.st_mtime_ns != after.st_mtime_ns
        or getattr(before, "st_ctime_ns", None) != getattr(after, "st_ctime_ns", None)
    ):
        raise AcquisitionConflictError(f"artifact changed while being measured: '{path}'")
    current = path.lstat()
    if (
        not stat.S_ISREG(current.st_mode)
        or is_link_or_reparse(current)
        or current.st_dev != after.st_dev
        or current.st_ino != after.st_ino
        or current.st_size != after.st_size
    ):
        raise AcquisitionConflictError(f"artifact path changed while being measured: '{path}'")
    return size, digest.hexdigest()


def _measure_pinned_file(
    root: PinnedPublicationRoot,
    path: str | Path,
) -> tuple[int, str]:
    """Measure one direct leaf through an active directory generation."""

    leaf = root.direct_leaf(path)
    require_current(root, label="artifact directory", error=AcquisitionConflictError)
    try:
        named_before = root.stat_leaf(leaf)
        if not stat.S_ISREG(named_before.st_mode) or is_link_or_reparse(named_before):
            raise AcquisitionConflictError(
                f"artifact is not a regular file: '{root.absolute(leaf)}'"
            )
        digest = hashlib.sha256()
        size = 0
        with root.open_leaf(leaf, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if (
                not stat.S_ISREG(opened_before.st_mode)
                or is_link_or_reparse(opened_before)
                or opened_before.st_dev != named_before.st_dev
                or opened_before.st_ino != named_before.st_ino
            ):
                raise AcquisitionConflictError(
                    f"artifact changed before it could be measured: '{root.absolute(leaf)}'"
                )
            while chunk := handle.read(1024 * 1024):
                size += len(chunk)
                digest.update(chunk)
            opened_after = os.fstat(handle.fileno())
        named_after = root.stat_leaf(leaf)
    except AcquisitionConflictError:
        raise
    except OSError as exc:
        raise AcquisitionConflictError(
            f"artifact cannot be measured: '{root.absolute(leaf)}'"
        ) from exc
    if (
        size != opened_after.st_size
        or opened_before.st_dev != opened_after.st_dev
        or opened_before.st_ino != opened_after.st_ino
        or opened_before.st_mtime_ns != opened_after.st_mtime_ns
        or getattr(opened_before, "st_ctime_ns", None)
        != getattr(opened_after, "st_ctime_ns", None)
        or not stat.S_ISREG(named_after.st_mode)
        or is_link_or_reparse(named_after)
        or named_after.st_dev != opened_after.st_dev
        or named_after.st_ino != opened_after.st_ino
        or named_after.st_size != opened_after.st_size
    ):
        raise AcquisitionConflictError(
            f"artifact changed while being measured: '{root.absolute(leaf)}'"
        )
    require_current(root, label="artifact directory", error=AcquisitionConflictError)
    return size, digest.hexdigest()


def measure_artifact_file(
    path: str | Path,
    *,
    publication_root: PinnedPublicationRoot | None = None,
) -> tuple[int, str]:
    """Return stable byte count and SHA-256 for one physical artifact file."""

    if publication_root is not None:
        return _measure_pinned_file(publication_root, path)
    return _measure_file(Path(path))


def collate_acquisition(
    existing: AcquisitionManifest | None,
    incoming: AcquisitionManifest,
) -> AcquisitionManifest:
    """Union compatible acquired forms without weakening prior evidence."""

    if existing is None:
        return incoming
    if existing.slug != incoming.slug or existing.artifact != incoming.artifact:
        raise AcquisitionConflictError("acquisition receipt identity conflicts with the staged item")
    forms = {form.kind: form for form in existing.forms}
    for new_form in incoming.forms:
        current = forms.get(new_form.kind)
        if current is None:
            forms[new_form.kind] = new_form
            continue
        immutable = ("path", "format", "bytes", "sha256")
        if any(getattr(current, field) != getattr(new_form, field) for field in immutable):
            raise AcquisitionConflictError(
                f"acquired {new_form.kind!r} form conflicts with its existing receipt"
            )
        if (
            current.provider_checksum is not None
            and new_form.provider_checksum is not None
            and current.provider_checksum != new_form.provider_checksum
        ):
            raise AcquisitionConflictError(
                f"provider checksum for {new_form.kind!r} conflicts with its existing receipt"
            )
        if current.provider_checksum is None and new_form.provider_checksum is not None:
            forms[new_form.kind] = current.model_copy(
                update={"provider_checksum": new_form.provider_checksum}
            )
    ordered = tuple(sorted(forms.values(), key=lambda form: _FORM_ORDER[form.kind]))
    return AcquisitionManifest(
        slug=existing.slug,
        artifact=existing.artifact,
        forms=ordered,
    )


class AcquisitionItem:
    """One locked and generation-pinned staging item transaction."""

    def __init__(self, root: PinnedPublicationRoot, slug: str) -> None:
        root.identity
        self.publication_root = root
        self.slug = validate_deposit_slug(slug)
        self.directory = Path(root.path)
        if self.directory.name != self.slug:
            raise AcquisitionError("acquisition item pin does not match its deposit slug")
        self.manifest_path = self.directory / "acquisition.json"
        kind = AcquisitionManifestDocument()
        self._manifest = JsonDocumentStore(root, self.manifest_path.name, kind)
        # A journal is a schema-valid one-form receipt fragment. The private partial leaf is fixed
        # by this transaction implementation rather than repeated in a second JSON contract.
        self._journal = JsonDocumentStore(root, _JOURNAL_LEAF, kind)

    def assert_current(self) -> None:
        """Require the item path and its retained parent to name this generation."""

        require_current(
            self.publication_root,
            label="acquisition item",
            error=AcquisitionConflictError,
        )

    def exists(self, path: str | Path) -> bool:
        return self.publication_root.lexists(path)

    def unlink(self, path: str | Path) -> None:
        self.publication_root.unlink(path)

    def open_file(self, path: str | Path, mode: str):
        return self.publication_root.open_file(path, mode)

    def measure_file(self, path: str | Path) -> tuple[int, str]:
        return measure_artifact_file(path, publication_root=self.publication_root)

    def validate_form(self, form: AcquiredArtifact) -> Path:
        """Validate one receipt form against this pinned item generation."""

        path = self.artifact_path(form.path)
        size, digest = self.measure_file(path)
        if size != form.bytes or digest != form.sha256:
            raise AcquisitionConflictError(
                f"staged artifact no longer matches acquisition.json: '{path}'"
            )
        return path

    def read_manifest(self) -> AcquisitionManifest | None:
        try:
            return self._manifest.read()
        except RuntimeError as exc:
            raise AcquisitionConflictError(
                "acquisition item changed while acquisition.json was read"
            ) from exc
        except (JsonDocumentError, ValueError) as exc:
            raise AcquisitionConflictError(
                f"existing acquisition.json is invalid: '{self.manifest_path}': {exc}"
            ) from exc

    def publish_manifest(self, manifest: AcquisitionManifest) -> None:
        if manifest.slug != self.slug:
            raise AcquisitionConflictError("acquisition receipt slug does not match its directory")
        try:
            self._manifest.publish(manifest, overwrite=self._manifest.exists())
        except (JsonDocumentError, RuntimeError, ValueError, OSError) as exc:
            raise AcquisitionConflictError(
                f"acquisition.json could not be published: '{self.manifest_path}'"
            ) from exc

    def private_download_path(self) -> Path:
        return self.directory / _PARTIAL_LEAF

    def artifact_path(self, leaf: str) -> Path:
        return self.directory / validate_deposit_slug(leaf)

    def write_journal(self, artifact: ArtifactReference, partial: Path, form: AcquiredArtifact) -> Path:
        if partial.parent != self.directory or partial.name != _PARTIAL_LEAF:
            raise AcquisitionError("publication partial is outside the locked staging item")
        journal = AcquisitionManifest(
            slug=self.slug,
            artifact=artifact,
            forms=(form,),
        )
        try:
            return Path(self._journal.publish(journal, overwrite=False))
        except (JsonDocumentError, RuntimeError, ValueError, OSError) as exc:
            raise AcquisitionConflictError(
                f"acquisition publication journal could not be written: '{self._journal.path}'"
            ) from exc

    def delete_journal(self) -> None:
        try:
            self.publication_root.unlink(self._journal.path)
        except FileNotFoundError:
            pass

    def publish_download(self, partial: Path, form: AcquiredArtifact) -> Path:
        if partial.parent != self.directory or partial.name != _PARTIAL_LEAF:
            raise AcquisitionError("publication partial is outside the locked staging item")
        destination = self.artifact_path(form.path)
        if self.exists(destination):
            raise AcquisitionConflictError(f"refusing to overwrite staged artifact: '{destination}'")
        try:
            self.publication_root.publish(partial, destination, overwrite=False)
        except FileExistsError as exc:
            raise AcquisitionConflictError(
                f"staged artifact appeared during publication: '{destination}'"
            ) from exc
        except OSError as exc:
            raise AcquisitionError(f"artifact publication failed: '{destination}'") from exc
        self.validate_form(form)
        return destination

    def recover(self, existing: AcquisitionManifest | None) -> AcquisitionManifest | None:
        """Finish journaled publications and remove abandoned private downloads."""

        manifest = existing
        try:
            journal = self._journal.read()
        except RuntimeError as exc:
            raise AcquisitionConflictError(
                "acquisition item changed while its publication journal was read"
            ) from exc
        except (JsonDocumentError, ValueError) as exc:
            raise AcquisitionConflictError(
                f"invalid acquisition publication journal: '{self._journal.path}'"
            ) from exc
        if journal is not None:
            if journal.slug != self.slug or len(journal.forms) != 1:
                raise AcquisitionConflictError(
                    f"publication journal is not one receipt fragment: '{self._journal.path}'"
                )
            form = journal.forms[0]
            partial = self.private_download_path()
            destination = self.artifact_path(form.path)
            if self.exists(destination):
                self.validate_form(form)
                if self.exists(partial):
                    size, digest = self.measure_file(partial)
                    if size != form.bytes or digest != form.sha256:
                        raise AcquisitionConflictError(
                            f"publication partial conflicts with journal: '{partial}'"
                        )
                    self.unlink(partial)
            elif self.exists(partial):
                size, digest = self.measure_file(partial)
                if size != form.bytes or digest != form.sha256:
                    raise AcquisitionConflictError(f"publication partial conflicts with journal: '{partial}'")
                self.publish_download(partial, form)
            else:
                self.delete_journal()
                journal = None
            if journal is not None:
                manifest = collate_acquisition(manifest, journal)
                self.publish_manifest(manifest)
                self.delete_journal()

        partial = self.private_download_path()
        if self.exists(partial):
            info = self.publication_root.stat_path(partial)
            if not stat.S_ISREG(info.st_mode) or is_link_or_reparse(info):
                raise AcquisitionConflictError(f"private download is not a regular file: '{partial}'")
            self.unlink(partial)
        return manifest


def store_for_catalog(
    staging: "AcquisitionStore",
    catalog: str | None,
    *,
    catalogs: ArticleCatalogRoots | None = None,
) -> "AcquisitionStore":
    """Return the staging store or one catalog-rooted acquisition store."""

    if catalog is None:
        return staging
    if catalogs is None:
        raise AcquisitionError("article catalogs are not configured for this application")
    try:
        article = catalogs.resolve(catalog, create=True)
    except ArticleCatalogConfigurationError as exc:
        raise AcquisitionError(str(exc)) from exc
    return AcquisitionStore(
        ConfiguredRootDescriptor(
            kind=ConfiguredRootKind.ARTICLE_CATALOG,
            name=article.name,
            path=article.catalog_dir,
            identity=article.identity,
            publication_root=article.publication_root,
        ),
        lock_timeout=staging.lock_timeout,
    )


class AcquisitionStore:
    """Retained acquisition-item generation with one lease and child pin per receipt."""

    def __init__(
        self,
        root: ConfiguredRootDescriptor,
        *,
        lock_timeout: float = 60.0,
    ) -> None:
        if (
            not isinstance(root, ConfiguredRootDescriptor)
            or root.kind not in _ACQUISITION_ROOT_KINDS
        ):
            raise TypeError(
                "AcquisitionStore requires an active staging or article-catalog root descriptor"
            )
        try:
            active_identity = root.publication_root.identity
        except RuntimeError as exc:
            raise AcquisitionError("acquisition-root descriptor is no longer active") from exc
        if active_identity != root.identity:
            raise AcquisitionError("acquisition-root descriptor identity is no longer active")
        self.descriptor = root
        self.publication_root = root.publication_root
        self.root = Path(root.path)
        self.lock_timeout = lock_timeout

    @contextmanager
    def transaction(self, slug: str, *, create: bool = True) -> Iterator[AcquisitionItem]:
        slug = validate_deposit_slug(slug)
        root = self.publication_root
        require_current(root, label="acquisition root", error=AcquisitionConflictError)
        directory = Path(root.absolute(slug))
        lease = FileLock(root.lock_path(directory), timeout=self.lock_timeout)
        try:
            lease.acquire()
        except Timeout as exc:
            raise TimeoutError(
                f"could not acquire acquisition receipt lease within {self.lock_timeout}s: "
                f"'{directory / 'acquisition.json'}'"
            ) from exc
        try:
            require_current(
                root,
                label="acquisition root",
                error=AcquisitionConflictError,
            )
            names = root.list_names()
            if (
                self.descriptor.kind is ConfiguredRootKind.ARTICLE_CATALOG
                and len(names) > MAX_CATALOG_CHILDREN
            ):
                raise AcquisitionError(
                    "article catalog exceeds the "
                    f"{MAX_CATALOG_CHILDREN}-child boundary: '{root.path}'"
                )
            collisions = [name for name in names if name.casefold() == slug.casefold()]
            if len(collisions) > 1 or (collisions and collisions[0] != slug):
                raise AcquisitionConflictError(
                    f"acquisition item name has a portable case collision: {slug!r}"
                )
            if collisions:
                info = root.stat_leaf(slug)
                if not stat.S_ISDIR(info.st_mode) or is_link_or_reparse(info):
                    raise AcquisitionError(
                        f"acquisition item must be a physical directory: '{directory}'"
                    )
            elif create:
                root.mkdir_leaf(slug)
                info = root.stat_leaf(slug)
            else:
                raise AcquisitionError(f"acquisition item does not exist: '{directory}'")
            with root.pin_child(slug) as item_root:
                opened = item_root.stat_root()
                if not same_directory_generation(info, opened):
                    raise AcquisitionConflictError(
                        f"acquisition item changed while its generation was pinned: '{directory}'"
                    )
                require_current(
                    item_root,
                    label="acquisition item",
                    error=AcquisitionConflictError,
                )
                item = AcquisitionItem(item_root, slug)
                yield item
                item.assert_current()
                require_current(
                    root,
                    label="acquisition root",
                    error=AcquisitionConflictError,
                )
        finally:
            lease.release()
