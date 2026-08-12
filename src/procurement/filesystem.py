"""Physical-path and stable-file primitives for procurement transactions."""

from __future__ import annotations

import hashlib
import os
import stat
from dataclasses import dataclass
from pathlib import Path
from uuid import uuid4

from procurement.errors import SourceMaterializationError

_CHUNK_BYTES = 1024 * 1024
_REPARSE_POINT = getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)


def is_link_or_reparse(info: os.stat_result) -> bool:
    """Return whether a filesystem entry redirects path traversal."""

    return stat.S_ISLNK(info.st_mode) or bool(
        getattr(info, "st_file_attributes", 0) & _REPARSE_POINT
    )


def _same_open_snapshot(left: os.stat_result, right: os.stat_result) -> bool:
    fields = ("st_dev", "st_ino", "st_size", "st_mtime_ns", "st_ctime_ns")
    return all(getattr(left, field, None) == getattr(right, field, None) for field in fields)


def _same_named_generation(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return (
            left.st_dev == right.st_dev
            and left.st_ino == right.st_ino
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_mtime_ns", None) == getattr(right, "st_mtime_ns", None)
    )


def _path_components(path: Path) -> tuple[Path, ...]:
    absolute = path.absolute()
    current = Path(absolute.anchor)
    result: list[Path] = []
    if absolute.anchor:
        result.append(current)
    for part in absolute.parts:
        if part == absolute.anchor:
            continue
        current = current / part
        result.append(current)
    return tuple(result)


def require_physical_directory(path: str | Path, *, label: str) -> Path:
    """Resolve a directory whose complete path contains no links or reparse points."""

    requested = Path(path).absolute()
    final: os.stat_result | None = None
    try:
        for component in _path_components(requested):
            final = component.stat(follow_symlinks=False)
            if is_link_or_reparse(final):
                raise SourceMaterializationError(
                    f"{label} must not traverse a symbolic link or reparse point: "
                    f"'{component}'"
                )
    except SourceMaterializationError:
        raise
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not accessible: '{requested}'") from exc
    if final is None or not stat.S_ISDIR(final.st_mode):
        raise SourceMaterializationError(f"{label} is not a directory: '{requested}'")
    resolved = requested.resolve(strict=True)
    if os.path.normcase(str(requested)) != os.path.normcase(str(resolved)):
        raise SourceMaterializationError(
            f"{label} must not traverse a symbolic link or reparse point: '{requested}'"
        )
    return resolved


def read_bounded_regular_file(
    path: str | Path,
    *,
    label: str,
    maximum_bytes: int,
) -> bytes:
    """Read one bounded regular-file generation through a no-follow handle."""

    target = Path(path).absolute()
    try:
        named_before = target.stat(follow_symlinks=False)
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not readable: '{target}'") from exc
    if is_link_or_reparse(named_before) or not stat.S_ISREG(named_before.st_mode):
        raise SourceMaterializationError(f"{label} is not a physical regular file: '{target}'")
    if named_before.st_size > maximum_bytes:
        raise SourceMaterializationError(
            f"{label} exceeds the {maximum_bytes}-byte boundary: '{target}'"
        )

    flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    try:
        descriptor = os.open(target, flags)
        with os.fdopen(descriptor, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if not stat.S_ISREG(opened_before.st_mode) or not _same_named_generation(
                named_before, opened_before
            ):
                raise SourceMaterializationError(
                    f"{label} changed before it could be read: '{target}'"
                )
            raw = handle.read(maximum_bytes + 1)
            opened_after = os.fstat(handle.fileno())
    except SourceMaterializationError:
        raise
    except OSError as exc:
        raise SourceMaterializationError(f"{label} could not be read: '{target}'") from exc

    if len(raw) > maximum_bytes:
        raise SourceMaterializationError(
            f"{label} exceeds the {maximum_bytes}-byte boundary: '{target}'"
        )
    if len(raw) != opened_after.st_size or not _same_open_snapshot(
        opened_before, opened_after
    ):
        raise SourceMaterializationError(f"{label} changed while it was read: '{target}'")
    try:
        named_after = target.stat(follow_symlinks=False)
    except OSError as exc:
        raise SourceMaterializationError(f"{label} disappeared after it was read: '{target}'") from exc
    if is_link_or_reparse(named_after) or not _same_named_generation(
        opened_after, named_after
    ):
        raise SourceMaterializationError(f"{label} path changed while it was read: '{target}'")
    return raw


@dataclass(frozen=True, slots=True)
class StableCopyResult:
    """Outcome of publishing one independently copied immutable file."""

    path: str
    created: bool


def measure_stable_regular_file(
    path: str | Path,
    *,
    label: str,
    maximum_bytes: int,
) -> tuple[int, str]:
    """Stream one bounded regular-file generation and return its size and SHA-256."""

    target = Path(path).absolute()
    try:
        named_before = target.stat(follow_symlinks=False)
    except OSError as exc:
        raise SourceMaterializationError(f"{label} is not readable: '{target}'") from exc
    if is_link_or_reparse(named_before) or not stat.S_ISREG(named_before.st_mode):
        raise SourceMaterializationError(f"{label} is not a physical regular file: '{target}'")
    if named_before.st_size > maximum_bytes:
        raise SourceMaterializationError(
            f"{label} exceeds the {maximum_bytes}-byte boundary: '{target}'"
        )

    flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    digest = hashlib.sha256()
    size = 0
    try:
        descriptor = os.open(target, flags)
        with os.fdopen(descriptor, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if not stat.S_ISREG(opened_before.st_mode) or not _same_named_generation(
                named_before, opened_before
            ):
                raise SourceMaterializationError(
                    f"{label} changed before it could be measured: '{target}'"
                )
            while chunk := handle.read(_CHUNK_BYTES):
                if len(chunk) > maximum_bytes - size:
                    raise SourceMaterializationError(
                        f"{label} exceeds the {maximum_bytes}-byte boundary: '{target}'"
                    )
                size += len(chunk)
                digest.update(chunk)
            opened_after = os.fstat(handle.fileno())
    except SourceMaterializationError:
        raise
    except OSError as exc:
        raise SourceMaterializationError(f"{label} could not be measured: '{target}'") from exc

    if size != opened_after.st_size or not _same_open_snapshot(opened_before, opened_after):
        raise SourceMaterializationError(f"{label} changed while it was measured: '{target}'")
    try:
        named_after = target.stat(follow_symlinks=False)
    except OSError as exc:
        raise SourceMaterializationError(
            f"{label} disappeared after it was measured: '{target}'"
        ) from exc
    if is_link_or_reparse(named_after) or not _same_named_generation(opened_after, named_after):
        raise SourceMaterializationError(f"{label} path changed while it was measured: '{target}'")
    return size, digest.hexdigest()


def stable_copy_no_clobber(
    source: str | Path,
    destination: str | Path,
    *,
    expected_bytes: int,
    expected_sha256: str,
) -> StableCopyResult:
    """Copy one stable source generation and publish it without replacing occupancy."""

    if expected_bytes < 1:
        raise ValueError("expected_bytes must be positive")
    if (
        len(expected_sha256) != 64
        or expected_sha256 != expected_sha256.casefold()
        or any(char not in "0123456789abcdef" for char in expected_sha256)
    ):
        raise ValueError("expected_sha256 must be 64 lowercase hexadecimal characters")

    source_path = Path(source).absolute()
    target = Path(destination).absolute()
    parent = require_physical_directory(target.parent, label="copy destination parent")
    if target.parent != parent or not target.name:
        raise SourceMaterializationError("copy destination must be one physical child path")

    if os.path.lexists(target):
        size, digest = measure_stable_regular_file(
            target,
            label="existing deposited file",
            maximum_bytes=expected_bytes,
        )
        if size != expected_bytes or digest != expected_sha256:
            raise SourceMaterializationError(
                f"existing deposited file conflicts with acquired bytes: '{target}'"
            )
        return StableCopyResult(path=str(target), created=False)

    partial = parent / f".copy-{uuid4().hex}.part"
    source_flags = os.O_RDONLY | getattr(os, "O_BINARY", 0) | getattr(os, "O_NOFOLLOW", 0)
    try:
        try:
            named_before = source_path.stat(follow_symlinks=False)
        except OSError as exc:
            raise SourceMaterializationError(
                f"acquired source file is not readable: '{source_path}'"
            ) from exc
        if is_link_or_reparse(named_before) or not stat.S_ISREG(named_before.st_mode):
            raise SourceMaterializationError(
                f"acquired source file is not a physical regular file: '{source_path}'"
            )
        if named_before.st_size != expected_bytes:
            raise SourceMaterializationError(
                f"acquired source file size no longer matches its receipt: '{source_path}'"
            )

        try:
            descriptor = os.open(source_path, source_flags)
            with os.fdopen(descriptor, "rb") as input_handle, partial.open("xb") as output_handle:
                opened_before = os.fstat(input_handle.fileno())
                if not stat.S_ISREG(opened_before.st_mode) or not _same_named_generation(
                    named_before, opened_before
                ):
                    raise SourceMaterializationError(
                        f"acquired source file changed before copying: '{source_path}'"
                    )
                digest = hashlib.sha256()
                size = 0
                while chunk := input_handle.read(_CHUNK_BYTES):
                    if len(chunk) > expected_bytes - size:
                        raise SourceMaterializationError(
                            f"acquired source file grew while copying: '{source_path}'"
                        )
                    size += len(chunk)
                    digest.update(chunk)
                    output_handle.write(chunk)
                output_handle.flush()
                os.fsync(output_handle.fileno())
                opened_after = os.fstat(input_handle.fileno())
        except SourceMaterializationError:
            raise
        except OSError as exc:
            raise SourceMaterializationError(
                f"acquired source file could not be copied: '{source_path}'"
            ) from exc

        if not _same_open_snapshot(opened_before, opened_after):
            raise SourceMaterializationError(
                f"acquired source file changed while copying: '{source_path}'"
            )
        try:
            named_after = source_path.stat(follow_symlinks=False)
        except OSError as exc:
            raise SourceMaterializationError(
                f"acquired source file disappeared after copying: '{source_path}'"
            ) from exc
        if is_link_or_reparse(named_after) or not _same_named_generation(
            opened_after, named_after
        ):
            raise SourceMaterializationError(
                f"acquired source path changed while copying: '{source_path}'"
            )
        if size != expected_bytes or digest.hexdigest() != expected_sha256:
            raise SourceMaterializationError(
                f"acquired source file no longer matches its receipt: '{source_path}'"
            )

        try:
            if os.name == "nt":
                os.rename(partial, target)
            else:
                os.link(partial, target, follow_symlinks=False)
                partial.unlink()
        except FileExistsError:
            if os.path.lexists(partial):
                partial.unlink()
            size, digest = measure_stable_regular_file(
                target,
                label="concurrently deposited file",
                maximum_bytes=expected_bytes,
            )
            if size != expected_bytes or digest != expected_sha256:
                raise SourceMaterializationError(
                    f"destination appeared with conflicting bytes: '{target}'"
                )
            return StableCopyResult(path=str(target), created=False)
        except OSError as exc:
            raise SourceMaterializationError(
                f"deposited file publication failed: '{target}'"
            ) from exc

        size, digest = measure_stable_regular_file(
            target,
            label="published deposited file",
            maximum_bytes=expected_bytes,
        )
        if size != expected_bytes or digest != expected_sha256:
            raise SourceMaterializationError(
                f"published deposited file does not match acquired bytes: '{target}'"
            )
        return StableCopyResult(path=str(target), created=True)
    finally:
        if os.path.lexists(partial):
            try:
                partial.unlink()
            except OSError:
                pass


__all__ = [
    "StableCopyResult",
    "is_link_or_reparse",
    "measure_stable_regular_file",
    "read_bounded_regular_file",
    "require_physical_directory",
    "stable_copy_no_clobber",
]
