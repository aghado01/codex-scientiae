"""Hierarchical generation-pinned directory operations for artifact publication.

The path-oriented engine remains the owner of JSONL bytes and sidecars.  A pinned publication
root changes only how those names reach the filesystem: POSIX operations are relative to an open
directory descriptor, while Windows holds each pinned directory without delete sharing. Windows
refuses rename or removal of that open directory and of ancestors containing it, so the complete
named route remains fixed for the lifetime of the transaction.
"""

from __future__ import annotations

import ctypes
import hashlib
import ntpath
import os
import stat
import sys
from contextlib import ExitStack, contextmanager
from dataclasses import dataclass
from pathlib import Path
from types import TracebackType
from typing import BinaryIO, Iterator

from .sidecar import is_transaction_scratch, scratch_root, temp_write_path
from .writer import publish_staged_file

_REPARSE_POINT = getattr(stat, "FILE_ATTRIBUTE_REPARSE_POINT", 0x400)
_DIRECTORY_ATTRIBUTE = getattr(stat, "FILE_ATTRIBUTE_DIRECTORY", 0x10)
_COPY_CHUNK_BYTES = 1024 * 1024


class PublicationError(ValueError):
    """A pinned filesystem operation could not preserve its declared invariants."""


class PublicationConflict(PublicationError):
    """A named filesystem generation or occupied destination conflicts with publication."""


@dataclass(frozen=True, slots=True)
class PinnedFileMeasurement:
    """Stable byte count and SHA-256 for one file in a retained directory generation."""

    path: str
    bytes: int
    sha256: str


@dataclass(frozen=True, slots=True)
class PinnedFileCopy:
    """Result of a stable create-only copy between retained directory generations."""

    path: str
    bytes: int
    sha256: str
    created: bool


def _is_reparse(info: os.stat_result) -> bool:
    return stat.S_ISLNK(info.st_mode) or bool(
        getattr(info, "st_file_attributes", 0) & _REPARSE_POINT
    )


def _plain_leaf(value: str, *, label: str) -> str:
    if (
        not isinstance(value, str)
        or not value
        or value in (".", "..")
        or os.path.basename(value) != value
        or os.path.isabs(value)
    ):
        raise ValueError(f"{label} must be one relative filesystem leaf")
    return value


def _relative_parts(value: str | os.PathLike[str], *, label: str) -> tuple[str, ...]:
    """Return normalized portable separators for one confined relative path."""

    text = os.fspath(value)
    if not isinstance(text, str):
        raise TypeError(f"{label} must be a string or text path")
    drive, _ = ntpath.splitdrive(text)
    if (
        not text
        or drive
        or text.startswith(("/", "\\"))
        or "\\" in text
        or text.endswith("/")
    ):
        raise ValueError(f"{label} must be one normalized relative path")
    parts = tuple(text.split("/"))
    if any(not part or part in (".", "..") for part in parts):
        raise ValueError(f"{label} must be one normalized relative path")
    return parts


def _path_components(path: str) -> list[str]:
    """Return an absolute directory route from its anchor through ``path``."""

    absolute = Path(os.path.abspath(path))
    current = absolute.anchor
    components: list[str] = []
    if current:
        components.append(current)
    for part in absolute.parts:
        if part == absolute.anchor:
            continue
        current = os.path.join(current, part) if current else part
        components.append(current)
    return components


def _extended_windows_path(path: str) -> str:
    """Return one normalized absolute DOS or UNC path in Win32 extended form."""

    normalized = ntpath.normpath(path).replace("/", "\\")
    if normalized.startswith("\\\\.\\"):
        raise ValueError(f"device namespace paths are not publication roots: '{path}'")
    folded = normalized[:8].upper()
    if folded == "\\\\?\\UNC\\":
        return "\\\\?\\UNC\\" + normalized[8:]
    if normalized.startswith("\\\\?\\"):
        remainder = normalized[4:]
        drive, tail = ntpath.splitdrive(remainder)
        if len(drive) == 2 and drive[1] == ":":
            drive = drive[0].upper() + ":"
            return "\\\\?\\" + drive + tail
        return "\\\\?\\" + remainder
    if normalized.startswith("\\\\"):
        return "\\\\?\\UNC\\" + normalized[2:]
    drive, tail = ntpath.splitdrive(normalized)
    if not drive or not tail.startswith("\\"):
        raise ValueError(f"publication root is not an absolute Windows path: '{path}'")
    drive = drive[0].upper() + drive[1:]
    return "\\\\?\\" + drive + tail


def _windows_paths_equal(left: str, right: str) -> bool:
    """Compare normalized Win32 routes exactly under Windows ordinal semantics."""

    import ctypes
    from ctypes import wintypes

    normalized_left = _extended_windows_path(left)
    normalized_right = _extended_windows_path(right)
    compare = ctypes.WinDLL("kernel32", use_last_error=True).CompareStringOrdinal
    compare.argtypes = (
        wintypes.LPCWSTR,
        ctypes.c_int,
        wintypes.LPCWSTR,
        ctypes.c_int,
        wintypes.BOOL,
    )
    compare.restype = ctypes.c_int
    result = compare(
        normalized_left,
        len(normalized_left),
        normalized_right,
        len(normalized_right),
        False,
    )
    if result == 0:
        raise ctypes.WinError(ctypes.get_last_error())
    return result == 2  # CSTR_EQUAL


def _same_directory(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return left.st_dev == right.st_dev and left.st_ino == right.st_ino
    left_birth = getattr(left, "st_birthtime_ns", None)
    right_birth = getattr(right, "st_birthtime_ns", None)
    if left_birth is not None or right_birth is not None:
        return left.st_dev == right.st_dev and left_birth == right_birth
    return left.st_dev == right.st_dev and getattr(
        left, "st_ctime_ns", None
    ) == getattr(right, "st_ctime_ns", None)


def _same_file_generation(left: os.stat_result, right: os.stat_result) -> bool:
    if left.st_ino or right.st_ino:
        return (
            left.st_dev == right.st_dev
            and left.st_ino == right.st_ino
            and left.st_size == right.st_size
        )
    left_birth = getattr(left, "st_birthtime_ns", None)
    right_birth = getattr(right, "st_birthtime_ns", None)
    if left_birth is not None or right_birth is not None:
        return (
            left.st_dev == right.st_dev
            and left_birth == right_birth
            and left.st_size == right.st_size
        )
    return (
        left.st_dev == right.st_dev
        and left.st_size == right.st_size
        and getattr(left, "st_ctime_ns", None) == getattr(right, "st_ctime_ns", None)
    )


def _same_file_snapshot(left: os.stat_result, right: os.stat_result) -> bool:
    fields = ("st_dev", "st_ino", "st_size", "st_mtime_ns", "st_ctime_ns")
    return all(getattr(left, field, None) == getattr(right, field, None) for field in fields)


def _is_regular_file(info: os.stat_result) -> bool:
    return stat.S_ISREG(info.st_mode) and not _is_reparse(info)


def _validate_maximum_bytes(value: int | None) -> int | None:
    if value is None:
        return None
    if isinstance(value, bool) or not isinstance(value, int) or value < 1:
        raise ValueError("maximum_bytes must be a positive integer or None")
    return value


def _validate_expected_file(expected_bytes: int | None, expected_sha256: str | None) -> None:
    if (expected_bytes is None) != (expected_sha256 is None):
        raise ValueError("expected_bytes and expected_sha256 must be supplied together")
    if expected_bytes is None:
        return
    if (
        isinstance(expected_bytes, bool)
        or not isinstance(expected_bytes, int)
        or expected_bytes < 0
    ):
        raise ValueError("expected_bytes must be a non-negative integer")
    assert expected_sha256 is not None
    if (
        len(expected_sha256) != 64
        or expected_sha256 != expected_sha256.casefold()
        or any(character not in "0123456789abcdef" for character in expected_sha256)
    ):
        raise ValueError("expected_sha256 must be 64 lowercase hexadecimal characters")


def _raise_rename_error(result: int, destination: str) -> None:
    if result == 0:
        return
    code = ctypes.get_errno()
    raise OSError(code, os.strerror(code), destination)


def _rename_directory_no_replace_posix(
    directory_fd: int,
    source_leaf: str,
    destination_leaf: str,
    *,
    destination_path: str,
) -> None:
    """Use the host's atomic exclusive directory rename primitive or fail closed."""

    library = ctypes.CDLL(None, use_errno=True)
    source = os.fsencode(source_leaf)
    destination = os.fsencode(destination_leaf)
    if sys.platform.startswith("linux"):
        rename = getattr(library, "renameat2", None)
        if rename is None:
            raise NotImplementedError("atomic no-replace directory publication requires renameat2")
        rename.argtypes = (
            ctypes.c_int,
            ctypes.c_char_p,
            ctypes.c_int,
            ctypes.c_char_p,
            ctypes.c_uint,
        )
        rename.restype = ctypes.c_int
        ctypes.set_errno(0)
        _raise_rename_error(
            rename(directory_fd, source, directory_fd, destination, 1),  # RENAME_NOREPLACE
            destination_path,
        )
        return
    if sys.platform == "darwin":
        rename = getattr(library, "renameatx_np", None)
        if rename is None:
            raise NotImplementedError(
                "atomic no-replace directory publication requires renameatx_np"
            )
        rename.argtypes = (
            ctypes.c_int,
            ctypes.c_char_p,
            ctypes.c_int,
            ctypes.c_char_p,
            ctypes.c_uint,
        )
        rename.restype = ctypes.c_int
        ctypes.set_errno(0)
        _raise_rename_error(
            rename(directory_fd, source, directory_fd, destination, 0x00000004),
            destination_path,
        )
        return
    raise NotImplementedError(
        "atomic no-replace directory publication is unavailable on this POSIX platform"
    )


class PinnedPublicationRoot:
    """One physical directory generation retained across reads and publication.

    The object is an active context manager.  Engine publication paths must be direct children;
    catalog readers may additionally use the direct-child inspection helpers.
    """

    def __init__(self, path: str | os.PathLike[str]) -> None:
        self.path = os.path.abspath(os.fspath(path))
        self._directory_fd: int | None = None
        self._windows_handles: list[int] = []
        self._identity: tuple[int, ...] | None = None
        self._activation: object | None = None
        self._parent: PinnedPublicationRoot | None = None
        self._parent_leaf: str | None = None
        self._parent_activation: object | None = None

    def __enter__(self) -> "PinnedPublicationRoot":
        if self._identity is not None:
            raise RuntimeError("publication root is already active")
        if self._parent is not None:
            self._parent._require_active()
            self._parent_activation = self._parent._activation
        if os.name == "nt":
            self._pin_windows()
        elif self._parent is not None:
            descriptor = self._open_posix_child()
            info = os.fstat(descriptor)
            self._directory_fd = descriptor
            self._identity = (int(info.st_dev), int(info.st_ino))
        else:
            descriptor = self._open_posix_route()
            info = os.fstat(descriptor)
            self._directory_fd = descriptor
            self._identity = (int(info.st_dev), int(info.st_ino))
        self._activation = object()
        return self

    def __exit__(
        self,
        exc_type: type[BaseException] | None,
        exc_value: BaseException | None,
        traceback: TracebackType | None,
    ) -> None:
        try:
            if self._directory_fd is not None:
                os.close(self._directory_fd)
            for handle in reversed(self._windows_handles):
                self._close_windows(handle)
        finally:
            self._directory_fd = None
            self._windows_handles = []
            self._identity = None
            self._activation = None
            self._parent_activation = None

    def _open_posix_child(self) -> int:
        """Open one physical child relative to the active parent generation."""

        assert self._parent is not None
        assert self._parent_leaf is not None
        parent_fd = self._parent.directory_fd
        if parent_fd is None:
            raise RuntimeError("POSIX child pin has no parent directory descriptor")
        flags = os.O_RDONLY | getattr(os, "O_DIRECTORY", 0) | getattr(os, "O_NOFOLLOW", 0)
        descriptor = os.open(self._parent_leaf, flags, dir_fd=parent_fd)
        try:
            info = os.fstat(descriptor)
            if not stat.S_ISDIR(info.st_mode) or _is_reparse(info):
                raise NotADirectoryError(
                    f"publication child is not a physical directory: '{self.path}'"
                )
            return descriptor
        except BaseException:
            os.close(descriptor)
            raise

    def _open_posix_route(self) -> int:
        """Open every component without link traversal and return the root descriptor."""

        flags = os.O_RDONLY | getattr(os, "O_DIRECTORY", 0) | getattr(os, "O_NOFOLLOW", 0)
        components = _path_components(self.path)
        if not components:
            raise NotADirectoryError(f"publication root is not accessible: '{self.path}'")
        descriptor: int | None = None
        try:
            descriptor = os.open(components[0], flags)
            for component in components[1:]:
                child = os.path.basename(component)
                following = os.open(child, flags, dir_fd=descriptor)
                os.close(descriptor)
                descriptor = following
            info = os.fstat(descriptor)
            if not stat.S_ISDIR(info.st_mode) or _is_reparse(info):
                raise NotADirectoryError(
                    f"publication root is not a physical directory: '{self.path}'"
                )
            return descriptor
        except BaseException:
            if descriptor is not None:
                os.close(descriptor)
            raise

    def _pin_windows(self) -> None:
        import ctypes
        from ctypes import wintypes

        class ByHandleFileInformation(ctypes.Structure):
            _fields_ = (
                ("attributes", wintypes.DWORD),
                ("creation_time", wintypes.FILETIME),
                ("access_time", wintypes.FILETIME),
                ("write_time", wintypes.FILETIME),
                ("volume_serial", wintypes.DWORD),
                ("size_high", wintypes.DWORD),
                ("size_low", wintypes.DWORD),
                ("links", wintypes.DWORD),
                ("file_index_high", wintypes.DWORD),
                ("file_index_low", wintypes.DWORD),
            )

        kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
        create_file = kernel32.CreateFileW
        create_file.argtypes = (
            wintypes.LPCWSTR,
            wintypes.DWORD,
            wintypes.DWORD,
            wintypes.LPVOID,
            wintypes.DWORD,
            wintypes.DWORD,
            wintypes.HANDLE,
        )
        create_file.restype = wintypes.HANDLE
        invalid = wintypes.HANDLE(-1).value
        get_information = kernel32.GetFileInformationByHandle
        get_information.argtypes = (wintypes.HANDLE, ctypes.POINTER(ByHandleFileInformation))
        get_information.restype = wintypes.BOOL
        opened: list[int] = []
        root_information: ByHandleFileInformation | None = None
        try:
            for component in [self.path]:
                handle = create_file(
                    component,
                    0x0001 | 0x0080,  # FILE_LIST_DIRECTORY | FILE_READ_ATTRIBUTES
                    0x0001 | 0x0002,  # READ | WRITE sharing; deliberately no DELETE sharing
                    None,
                    3,  # OPEN_EXISTING
                    0x02000000 | 0x00200000,  # BACKUP_SEMANTICS | OPEN_REPARSE_POINT
                    None,
                )
                if handle == invalid:
                    error = ctypes.WinError(ctypes.get_last_error())
                    error.filename = component
                    raise error
                numeric_handle = int(handle)
                opened.append(numeric_handle)
                information = ByHandleFileInformation()
                if not get_information(handle, ctypes.byref(information)):
                    error = ctypes.WinError(ctypes.get_last_error())
                    error.filename = component
                    raise error
                if not information.attributes & _DIRECTORY_ATTRIBUTE:
                    raise NotADirectoryError(
                        f"publication route component is not a directory: '{component}'"
                    )
                if information.attributes & _REPARSE_POINT:
                    raise NotADirectoryError(
                        f"publication route contains a reparse point: '{component}'"
                    )
                resolved = self._windows_final_path(numeric_handle)
                if not _windows_paths_equal(resolved, self.path):
                    raise NotADirectoryError(
                        "publication root resolves through another filesystem route: "
                        f"expected '{_extended_windows_path(self.path)}', got '{resolved}'"
                    )
                root_information = information
        except BaseException:
            for opened_handle in reversed(opened):
                self._close_windows(opened_handle)
            raise

        if root_information is None:
            raise NotADirectoryError(f"publication root is not accessible: '{self.path}'")
        self._windows_handles = opened
        self._identity = (
            int(root_information.volume_serial),
            int(root_information.file_index_high),
            int(root_information.file_index_low),
        )

    @staticmethod
    def _close_windows(handle: int) -> None:
        import ctypes
        from ctypes import wintypes

        close = ctypes.WinDLL("kernel32", use_last_error=True).CloseHandle
        close.argtypes = (wintypes.HANDLE,)
        close.restype = wintypes.BOOL
        close(wintypes.HANDLE(handle))

    @staticmethod
    def _windows_final_path(handle: int) -> str:
        """Return the normalized DOS-volume path naming an open Windows directory."""

        import ctypes
        from ctypes import wintypes

        get_final_path = ctypes.WinDLL(
            "kernel32", use_last_error=True
        ).GetFinalPathNameByHandleW
        get_final_path.argtypes = (
            wintypes.HANDLE,
            wintypes.LPWSTR,
            wintypes.DWORD,
            wintypes.DWORD,
        )
        get_final_path.restype = wintypes.DWORD
        # FILE_NAME_NORMALIZED | VOLUME_NAME_DOS are both represented by zero-valued flags.
        size = get_final_path(wintypes.HANDLE(handle), None, 0, 0)
        if size == 0:
            raise ctypes.WinError(ctypes.get_last_error())
        while True:
            buffer = ctypes.create_unicode_buffer(size + 1)
            copied = get_final_path(
                wintypes.HANDLE(handle),
                buffer,
                len(buffer),
                0,
            )
            if copied == 0:
                raise ctypes.WinError(ctypes.get_last_error())
            if copied < len(buffer):
                return buffer.value
            size = copied

    def _require_active(self) -> None:
        if self._identity is None:
            raise RuntimeError("publication root is not active")
        if self._parent is not None:
            self._parent._require_active()
            if self._parent._activation is not self._parent_activation:
                raise RuntimeError("publication child outlived its parent activation")

    @property
    def is_active(self) -> bool:
        """Return whether this directory pin and its parent activation remain active."""

        if self._identity is None:
            return False
        try:
            self._require_active()
        except RuntimeError:
            return False
        return True

    @property
    def identity(self) -> tuple[int, ...]:
        """Return the filesystem identity captured for the active directory generation."""

        self._require_active()
        assert self._identity is not None
        return self._identity

    @property
    def directory_fd(self) -> int | None:
        """Return the POSIX directory descriptor, or ``None`` on Windows."""

        self._require_active()
        return self._directory_fd

    def direct_leaf(self, path: str | os.PathLike[str]) -> str:
        """Return a direct-child leaf for one absolute engine path."""

        self._require_active()
        full = os.path.abspath(os.fspath(path))
        try:
            relative = os.path.relpath(full, self.path)
        except ValueError as exc:
            raise ValueError(f"publication path is outside its pinned root: '{full}'") from exc
        return _plain_leaf(relative, label="publication path")

    def absolute(self, leaf: str) -> str:
        return os.path.join(self.path, _plain_leaf(leaf, label="publication leaf"))

    def pin_child(self, leaf: str) -> "PinnedPublicationRoot":
        """Return an unopened pin for one direct physical child directory."""

        self._require_active()
        child_leaf = _plain_leaf(leaf, label="publication child")
        child = type(self)(self.absolute(child_leaf))
        child._parent = self
        child._parent_leaf = child_leaf
        return child

    @contextmanager
    def pin_descendant(
        self,
        relative_directory: str | os.PathLike[str],
    ) -> Iterator["PinnedPublicationRoot"]:
        """Pin every directory in one normalized descendant route for the context lifetime."""

        parts = _relative_parts(relative_directory, label="publication directory")
        with ExitStack() as stack:
            current = self
            for part in parts:
                try:
                    named = current.stat_leaf(part)
                except OSError as exc:
                    raise NotADirectoryError(
                        f"publication directory is not accessible: '{current.absolute(part)}'"
                    ) from exc
                child = stack.enter_context(current.pin_child(part))
                opened = child.stat_root()
                if (
                    not stat.S_ISDIR(named.st_mode)
                    or _is_reparse(named)
                    or not _same_directory(named, opened)
                ):
                    raise PublicationConflict(
                        "publication directory changed while its route was pinned: "
                        f"'{child.path}'"
                    )
                current = child
            yield current

    def absolute_relative(self, relative_path: str | os.PathLike[str]) -> str:
        """Return the display path for one normalized descendant address."""

        parts = _relative_parts(relative_path, label="publication relative path")
        self._require_active()
        return os.path.join(self.path, *parts)

    def mkdir_relative(
        self,
        relative_directory: str | os.PathLike[str],
        *,
        parents: bool = False,
        exist_ok: bool = False,
        mode: int = 0o700,
    ) -> str:
        """Create one physical descendant directory through retained parent generations."""

        parts = _relative_parts(relative_directory, label="publication directory")
        if not parents and len(parts) > 1:
            with self.pin_descendant("/".join(parts[:-1])) as parent:
                try:
                    return parent.mkdir_leaf(parts[-1], mode=mode)
                except FileExistsError:
                    if not exist_ok:
                        raise
                    info = parent.stat_leaf(parts[-1])
                    if not stat.S_ISDIR(info.st_mode) or _is_reparse(info):
                        raise NotADirectoryError(parent.absolute(parts[-1]))
                    return parent.absolute(parts[-1])

        with ExitStack() as stack:
            current = self
            for index, part in enumerate(parts):
                final = index == len(parts) - 1
                try:
                    named = current.stat_leaf(part)
                    existed = True
                except FileNotFoundError:
                    current.mkdir_leaf(part, mode=mode)
                    named = current.stat_leaf(part)
                    existed = False
                if final and existed and not exist_ok:
                    raise FileExistsError(current.absolute(part))
                if not stat.S_ISDIR(named.st_mode) or _is_reparse(named):
                    raise NotADirectoryError(current.absolute(part))
                child = stack.enter_context(current.pin_child(part))
                if not _same_directory(named, child.stat_root()):
                    raise PublicationConflict(
                        "publication directory changed while its generation was pinned: "
                        f"'{child.path}'"
                    )
                current = child
            return self.absolute_relative(relative_directory)

    @contextmanager
    def open_relative_file(
        self,
        relative_path: str | os.PathLike[str],
        mode: str,
    ) -> Iterator[BinaryIO]:
        """Open one nested file while retaining every directory in its route."""

        parts = _relative_parts(relative_path, label="publication file")
        if len(parts) == 1:
            with self.open_leaf(parts[0], mode) as handle:
                yield handle
            return
        with self.pin_descendant("/".join(parts[:-1])) as parent:
            with parent.open_leaf(parts[-1], mode) as handle:
                yield handle

    @contextmanager
    def open_stable_relative_file(
        self,
        relative_path: str | os.PathLike[str],
    ) -> Iterator[BinaryIO]:
        """Open one stable regular file while retaining its complete directory route."""

        parts = _relative_parts(relative_path, label="publication file")
        if len(parts) == 1:
            with self.open_stable_file(self.absolute(parts[0])) as handle:
                yield handle
            return
        with self.pin_descendant("/".join(parts[:-1])) as parent:
            with parent.open_stable_file(parent.absolute(parts[-1])) as handle:
                yield handle

    def read_relative_bytes(
        self,
        relative_path: str | os.PathLike[str],
        *,
        maximum_bytes: int | None = None,
    ) -> bytes:
        """Read one stable descendant file within an optional encoded-byte boundary."""

        maximum = _validate_maximum_bytes(maximum_bytes)
        with self.open_stable_relative_file(relative_path) as handle:
            size = os.fstat(handle.fileno()).st_size
            if maximum is not None and size > maximum:
                raise PublicationError(
                    f"publication file exceeds the {maximum}-byte boundary: "
                    f"'{self.absolute_relative(relative_path)}'"
                )
            raw = handle.read() if maximum is None else handle.read(maximum + 1)
            if len(raw) != size or (maximum is not None and len(raw) > maximum):
                raise PublicationConflict(
                    "publication file changed while it was read: "
                    f"'{self.absolute_relative(relative_path)}'"
                )
            return raw

    def stat_relative(self, relative_path: str | os.PathLike[str]) -> os.stat_result:
        """Inspect one descendant without following any directory or final-entry link."""

        parts = _relative_parts(relative_path, label="publication path")
        if len(parts) == 1:
            return self.stat_leaf(parts[0])
        with self.pin_descendant("/".join(parts[:-1])) as parent:
            return parent.stat_leaf(parts[-1])

    def list_relative(self, relative_directory: str | os.PathLike[str]) -> list[str]:
        """List one physical descendant directory while its complete route is retained."""

        with self.pin_descendant(relative_directory) as directory:
            return directory.list_names()

    def mkdir_leaf(self, leaf: str, *, mode: int = 0o700) -> str:
        """Create one direct child directory relative to the pinned generation."""

        leaf = _plain_leaf(leaf, label="publication child")
        self._require_active()
        if self._directory_fd is not None:
            os.mkdir(leaf, mode=mode, dir_fd=self._directory_fd)
        else:
            os.mkdir(self.absolute(leaf), mode=mode)
        info = self.stat_leaf(leaf)
        if not stat.S_ISDIR(info.st_mode) or _is_reparse(info):
            raise NotADirectoryError(
                f"created publication child is not a physical directory: '{self.absolute(leaf)}'"
            )
        return self.absolute(leaf)

    def rmdir_leaf(self, leaf: str) -> None:
        """Remove one empty direct child directory relative to the pinned generation."""

        leaf = _plain_leaf(leaf, label="publication child")
        self._require_active()
        if self._directory_fd is not None:
            os.rmdir(leaf, dir_fd=self._directory_fd)
        else:
            os.rmdir(self.absolute(leaf))

    def list_names(self) -> list[str]:
        self._require_active()
        if self._directory_fd is not None:
            return list(os.listdir(self._directory_fd))
        return list(os.listdir(self.path))

    def stat_root(self) -> os.stat_result:
        """Return metadata for the pinned root generation."""

        self._require_active()
        if self._directory_fd is not None:
            return os.fstat(self._directory_fd)
        return os.stat(self.path, follow_symlinks=False)

    def lexists(self, path: str | os.PathLike[str]) -> bool:
        leaf = self.direct_leaf(path)
        try:
            self.stat_leaf(leaf)
            return True
        except FileNotFoundError:
            return False

    def stat_leaf(self, leaf: str) -> os.stat_result:
        leaf = _plain_leaf(leaf, label="publication leaf")
        self._require_active()
        if self._directory_fd is not None:
            return os.stat(leaf, dir_fd=self._directory_fd, follow_symlinks=False)
        return os.stat(self.absolute(leaf), follow_symlinks=False)

    def stat_path(self, path: str | os.PathLike[str]) -> os.stat_result:
        return self.stat_leaf(self.direct_leaf(path))

    def stat_child(self, child: str) -> os.stat_result:
        return self.stat_leaf(_plain_leaf(child, label="catalog child"))

    def stat_child_file(self, child: str, leaf: str) -> os.stat_result:
        child = _plain_leaf(child, label="catalog child")
        leaf = _plain_leaf(leaf, label="catalog child file")
        self._require_active()
        if self._directory_fd is None:
            return os.stat(os.path.join(self.path, child, leaf), follow_symlinks=False)
        child_fd = os.open(
            child,
            os.O_RDONLY | getattr(os, "O_DIRECTORY", 0) | getattr(os, "O_NOFOLLOW", 0),
            dir_fd=self._directory_fd,
        )
        try:
            return os.stat(leaf, dir_fd=child_fd, follow_symlinks=False)
        finally:
            os.close(child_fd)

    def open_file(self, path: str | os.PathLike[str], mode: str) -> BinaryIO:
        return self.open_leaf(self.direct_leaf(path), mode)

    @contextmanager
    def open_stable_file(
        self,
        path: str | os.PathLike[str],
    ) -> Iterator[BinaryIO]:
        """Open one direct regular file and verify its named generation through close."""

        leaf = self.direct_leaf(path)
        try:
            self.assert_current()
            named_before = self.stat_leaf(leaf)
        except OSError as exc:
            raise PublicationConflict(
                f"publication file is not readable: '{self.absolute(leaf)}'"
            ) from exc
        if not _is_regular_file(named_before):
            raise PublicationConflict(
                f"publication file is not a physical regular file: '{self.absolute(leaf)}'"
            )
        with self.open_leaf(leaf, "rb") as handle:
            opened_before = os.fstat(handle.fileno())
            if not _is_regular_file(opened_before) or not _same_file_generation(
                named_before, opened_before
            ):
                raise PublicationConflict(
                    f"publication file changed before it could be opened: '{self.absolute(leaf)}'"
                )
            yield handle
            opened_after = os.fstat(handle.fileno())
        if not _same_file_snapshot(opened_before, opened_after):
            raise PublicationConflict(
                f"publication file changed while it was open: '{self.absolute(leaf)}'"
            )
        try:
            named_after = self.stat_leaf(leaf)
        except OSError as exc:
            raise PublicationConflict(
                f"publication file disappeared while it was open: '{self.absolute(leaf)}'"
            ) from exc
        if not _is_regular_file(named_after) or not _same_file_generation(
            opened_after, named_after
        ):
            raise PublicationConflict(
                f"publication file path changed while it was open: '{self.absolute(leaf)}'"
            )
        try:
            self.assert_current()
        except RuntimeError as exc:
            raise PublicationConflict(
                f"publication root changed while a file was open: '{self.path}'"
            ) from exc

    def read_bytes(
        self,
        path: str | os.PathLike[str],
        *,
        maximum_bytes: int | None = None,
    ) -> bytes:
        """Read one stable direct file within an optional encoded-byte boundary."""

        maximum = _validate_maximum_bytes(maximum_bytes)
        with self.open_stable_file(path) as handle:
            size = os.fstat(handle.fileno()).st_size
            if maximum is not None and size > maximum:
                raise PublicationError(
                    f"publication file exceeds the {maximum}-byte boundary: '{path}'"
                )
            raw = handle.read() if maximum is None else handle.read(maximum + 1)
            if len(raw) != size or (maximum is not None and len(raw) > maximum):
                raise PublicationConflict(
                    f"publication file changed while it was read: '{path}'"
                )
            return raw

    def measure_file(
        self,
        path: str | os.PathLike[str],
        *,
        maximum_bytes: int | None = None,
    ) -> PinnedFileMeasurement:
        """Return a stable byte count and SHA-256 for one direct regular file."""

        maximum = _validate_maximum_bytes(maximum_bytes)
        digest = hashlib.sha256()
        size = 0
        with self.open_stable_file(path) as handle:
            declared_size = os.fstat(handle.fileno()).st_size
            if maximum is not None and declared_size > maximum:
                raise PublicationError(
                    f"publication file exceeds the {maximum}-byte boundary: '{path}'"
                )
            while chunk := handle.read(_COPY_CHUNK_BYTES):
                size += len(chunk)
                if maximum is not None and size > maximum:
                    raise PublicationError(
                        f"publication file exceeds the {maximum}-byte boundary: '{path}'"
                    )
                digest.update(chunk)
            if size != declared_size:
                raise PublicationConflict(
                    f"publication file changed while it was measured: '{path}'"
                )
        return PinnedFileMeasurement(
            path=self.absolute(self.direct_leaf(path)),
            bytes=size,
            sha256=digest.hexdigest(),
        )

    def open_leaf(self, leaf: str, mode: str) -> BinaryIO:
        leaf = _plain_leaf(leaf, label="publication leaf")
        self._require_active()
        if self._directory_fd is None:
            return self._open_windows_leaf(leaf, mode)
        flags, permissions = self._open_flags(mode)
        descriptor = os.open(
            leaf,
            flags | getattr(os, "O_NOFOLLOW", 0),
            permissions,
            dir_fd=self._directory_fd,
        )
        return os.fdopen(descriptor, mode)

    def _open_windows_leaf(self, leaf: str, mode: str) -> BinaryIO:
        """Open one Windows leaf without following a final reparse point."""

        import ctypes
        import msvcrt
        from ctypes import wintypes

        if os.name != "nt":
            raise RuntimeError("Windows leaf opening is unavailable on this platform")
        access_and_creation = {
            "rb": (0x80000000, 3, os.O_RDONLY | getattr(os, "O_BINARY", 0)),
            "wb": (0x40000000, 2, os.O_WRONLY | getattr(os, "O_BINARY", 0)),
            "xb": (0x40000000, 1, os.O_WRONLY | getattr(os, "O_BINARY", 0)),
        }
        try:
            desired_access, creation, descriptor_flags = access_and_creation[mode]
        except KeyError as exc:
            raise ValueError(f"unsupported pinned-root file mode: {mode!r}") from exc

        create_file = ctypes.WinDLL("kernel32", use_last_error=True).CreateFileW
        create_file.argtypes = (
            wintypes.LPCWSTR,
            wintypes.DWORD,
            wintypes.DWORD,
            wintypes.LPVOID,
            wintypes.DWORD,
            wintypes.DWORD,
            wintypes.HANDLE,
        )
        create_file.restype = wintypes.HANDLE
        invalid = wintypes.HANDLE(-1).value
        path = self.absolute(leaf)
        handle = create_file(
            path,
            desired_access,
            0x0001 | 0x0002,  # READ | WRITE sharing; no DELETE sharing
            None,
            creation,
            0x00000080 | 0x00200000,  # NORMAL | OPEN_REPARSE_POINT
            None,
        )
        if handle == invalid:
            error = ctypes.WinError(ctypes.get_last_error())
            error.filename = path
            raise error
        numeric_handle = int(handle)
        try:
            descriptor = msvcrt.open_osfhandle(numeric_handle, descriptor_flags)
        except BaseException:
            self._close_windows(numeric_handle)
            raise
        try:
            file_handle = os.fdopen(descriptor, mode)
        except BaseException:
            os.close(descriptor)
            raise
        try:
            info = os.fstat(file_handle.fileno())
            if not stat.S_ISREG(info.st_mode) or _is_reparse(info):
                raise OSError(f"publication leaf is not a physical regular file: '{path}'")
            return file_handle
        except BaseException:
            file_handle.close()
            raise

    def open_child_file(self, child: str, leaf: str, mode: str) -> BinaryIO:
        child = _plain_leaf(child, label="catalog child")
        leaf = _plain_leaf(leaf, label="catalog child file")
        self._require_active()
        if self._directory_fd is None:
            return open(os.path.join(self.path, child, leaf), mode)
        child_fd = os.open(
            child,
            os.O_RDONLY | getattr(os, "O_DIRECTORY", 0) | getattr(os, "O_NOFOLLOW", 0),
            dir_fd=self._directory_fd,
        )
        try:
            flags, permissions = self._open_flags(mode)
            descriptor = os.open(
                leaf,
                flags | getattr(os, "O_NOFOLLOW", 0),
                permissions,
                dir_fd=child_fd,
            )
        finally:
            os.close(child_fd)
        return os.fdopen(descriptor, mode)

    @staticmethod
    def _open_flags(mode: str) -> tuple[int, int]:
        binary = getattr(os, "O_BINARY", 0)
        if mode == "rb":
            return os.O_RDONLY | binary, 0o666
        if mode == "wb":
            return os.O_WRONLY | os.O_CREAT | os.O_TRUNC | binary, 0o666
        if mode == "xb":
            return os.O_WRONLY | os.O_CREAT | os.O_EXCL | binary, 0o666
        raise ValueError(f"unsupported pinned-root file mode: {mode!r}")

    def unlink(self, path: str | os.PathLike[str]) -> None:
        leaf = self.direct_leaf(path)
        if self._directory_fd is not None:
            os.unlink(leaf, dir_fd=self._directory_fd)
        else:
            os.remove(self.absolute(leaf))

    def replace(self, staged: str | os.PathLike[str], destination: str | os.PathLike[str]) -> None:
        source_leaf = self.direct_leaf(staged)
        destination_leaf = self.direct_leaf(destination)
        if self._directory_fd is not None:
            os.replace(
                source_leaf,
                destination_leaf,
                src_dir_fd=self._directory_fd,
                dst_dir_fd=self._directory_fd,
            )
        else:
            os.replace(self.absolute(source_leaf), self.absolute(destination_leaf))

    def publish(
        self,
        staged: str | os.PathLike[str],
        destination: str | os.PathLike[str],
        *,
        overwrite: bool,
    ) -> None:
        source_leaf = self.direct_leaf(staged)
        destination_leaf = self.direct_leaf(destination)
        if self._directory_fd is None:
            publish_staged_file(
                self.absolute(source_leaf),
                self.absolute(destination_leaf),
                overwrite=overwrite,
            )
            return
        if overwrite:
            os.replace(
                source_leaf,
                destination_leaf,
                src_dir_fd=self._directory_fd,
                dst_dir_fd=self._directory_fd,
            )
            return
        os.link(
            source_leaf,
            destination_leaf,
            src_dir_fd=self._directory_fd,
            dst_dir_fd=self._directory_fd,
            follow_symlinks=False,
        )
        try:
            os.unlink(source_leaf, dir_fd=self._directory_fd)
        except OSError:
            pass

    def publish_directory(
        self,
        staged: str | os.PathLike[str],
        destination: str | os.PathLike[str],
    ) -> str:
        """Atomically rename one physical direct-child directory without replacement."""

        source_leaf = self.direct_leaf(staged)
        destination_leaf = self.direct_leaf(destination)
        if source_leaf.casefold() == destination_leaf.casefold():
            raise ValueError("staged and destination directory leaves must be distinct")
        try:
            self.assert_current()
            source_before = self.stat_leaf(source_leaf)
        except OSError as exc:
            raise PublicationConflict(
                f"staged publication directory is not accessible: '{self.absolute(source_leaf)}'"
            ) from exc
        if not stat.S_ISDIR(source_before.st_mode) or _is_reparse(source_before):
            raise PublicationConflict(
                "staged publication directory is not a physical directory: "
                f"'{self.absolute(source_leaf)}'"
            )
        if self.lexists(self.absolute(destination_leaf)):
            raise FileExistsError(self.absolute(destination_leaf))

        try:
            if self._directory_fd is None:
                os.rename(self.absolute(source_leaf), self.absolute(destination_leaf))
            else:
                _rename_directory_no_replace_posix(
                    self._directory_fd,
                    source_leaf,
                    destination_leaf,
                    destination_path=self.absolute(destination_leaf),
                )
        except OSError:
            # Some remote filesystems can report a rename failure after committing it. Adopt only
            # the exact staged directory generation when its source name has disappeared.
            try:
                source_remains = self.lexists(self.absolute(source_leaf))
                destination_after_error = self.stat_leaf(destination_leaf)
            except OSError:
                raise
            if source_remains or not _same_directory(
                source_before, destination_after_error
            ):
                raise

        try:
            destination_after = self.stat_leaf(destination_leaf)
        except OSError as exc:
            raise PublicationConflict(
                f"published directory is not accessible: '{self.absolute(destination_leaf)}'"
            ) from exc
        if (
            not stat.S_ISDIR(destination_after.st_mode)
            or _is_reparse(destination_after)
            or not _same_directory(source_before, destination_after)
        ):
            raise PublicationConflict(
                "published directory does not preserve the staged generation: "
                f"'{self.absolute(destination_leaf)}'"
            )
        try:
            self.assert_current()
        except RuntimeError as exc:
            raise PublicationConflict(
                f"publication root changed during directory publication: '{self.path}'"
            ) from exc
        return self.absolute(destination_leaf)

    def stale_scratch(self, *subjects: str | os.PathLike[str]) -> list[str]:
        leaves = tuple(self.direct_leaf(subject) for subject in subjects)
        return [
            self.absolute(name)
            for name in self.list_names()
            if any(is_transaction_scratch(subject, name) for subject in leaves)
        ]

    def lock_path(self, artifact_path: str | os.PathLike[str]) -> str:
        """Return a lock address keyed by directory generation and artifact leaf."""

        leaf = self.direct_leaf(artifact_path)
        assert self._identity is not None
        key = repr(("pinned-publication", self._identity, leaf.casefold())).encode("utf-8")
        digest = hashlib.sha256(key).hexdigest()[:32]
        return os.path.join(scratch_root(), f"{digest}.lock")

    def path_is_current(self) -> bool:
        """Return whether the original lexical path still names the pinned generation."""

        self._require_active()
        if self._parent is not None:
            if not self._parent.path_is_current():
                return False
            assert self._parent_leaf is not None
            try:
                named = self._parent.stat_leaf(self._parent_leaf)
                opened = self.stat_root()
            except OSError:
                return False
            return (
                stat.S_ISDIR(named.st_mode)
                and not _is_reparse(named)
                and _same_directory(named, opened)
            )
        if self._directory_fd is None:
            # The Windows root handle denies replacement of the root or its ancestor route.
            return True
        try:
            named_descriptor = self._open_posix_route()
            named = os.fstat(named_descriptor)
            opened = os.fstat(self._directory_fd)
        except OSError:
            return False
        finally:
            if "named_descriptor" in locals():
                os.close(named_descriptor)
        return not _is_reparse(named) and _same_directory(named, opened)

    def assert_current(self) -> None:
        """Raise when the lexical route no longer names the pinned directory generation."""

        if not self.path_is_current():
            raise RuntimeError(
                f"publication root path no longer names its pinned generation: '{self.path}'"
            )


def copy_file_no_clobber(
    source_root: PinnedPublicationRoot,
    source: str | os.PathLike[str],
    destination_root: PinnedPublicationRoot,
    destination: str | os.PathLike[str],
    *,
    expected_bytes: int | None = None,
    expected_sha256: str | None = None,
    maximum_bytes: int | None = None,
) -> PinnedFileCopy:
    """Copy one stable direct file and atomically adopt only identical occupancy."""

    if not isinstance(source_root, PinnedPublicationRoot) or not isinstance(
        destination_root, PinnedPublicationRoot
    ):
        raise TypeError("copy_file_no_clobber requires two PinnedPublicationRoot values")
    _validate_expected_file(expected_bytes, expected_sha256)
    maximum = _validate_maximum_bytes(maximum_bytes)
    source_leaf = source_root.direct_leaf(source)
    destination_leaf = destination_root.direct_leaf(destination)
    if (
        source_root.identity == destination_root.identity
        and source_leaf.casefold() == destination_leaf.casefold()
    ):
        raise ValueError("source and destination must name distinct files")
    source_path = source_root.absolute(source_leaf)
    destination_path = destination_root.absolute(destination_leaf)
    partial = temp_write_path(destination_path)
    destination_root.direct_leaf(partial)
    digest = hashlib.sha256()
    size = 0
    try:
        with source_root.open_stable_file(source_path) as input_handle:
            source_size = os.fstat(input_handle.fileno()).st_size
            if maximum is not None and source_size > maximum:
                raise PublicationError(
                    f"source file exceeds the {maximum}-byte boundary: '{source_path}'"
                )
            if expected_bytes is not None and source_size != expected_bytes:
                raise PublicationConflict(
                    f"source file size does not match its expected bytes: '{source_path}'"
                )
            with destination_root.open_file(partial, "xb") as output_handle:
                while chunk := input_handle.read(_COPY_CHUNK_BYTES):
                    size += len(chunk)
                    if maximum is not None and size > maximum:
                        raise PublicationError(
                            f"source file exceeds the {maximum}-byte boundary: '{source_path}'"
                        )
                    digest.update(chunk)
                    written = output_handle.write(chunk)
                    if written != len(chunk):
                        raise OSError(
                            f"short write while copying publication file ({written} of "
                            f"{len(chunk)} bytes): '{destination_path}'"
                        )
                output_handle.flush()
                os.fsync(output_handle.fileno())
            if size != source_size:
                raise PublicationConflict(
                    f"source file changed while it was copied: '{source_path}'"
                )
        sha256 = digest.hexdigest()
        if expected_bytes is not None and (
            size != expected_bytes or sha256 != expected_sha256
        ):
            raise PublicationConflict(
                f"source file does not match its expected digest: '{source_path}'"
            )
        source_root.assert_current()
        destination_root.assert_current()

        if destination_root.lexists(destination_path):
            existing = destination_root.measure_file(
                destination_path,
                maximum_bytes=maximum,
            )
            if existing.bytes != size or existing.sha256 != sha256:
                raise PublicationConflict(
                    f"destination contains conflicting bytes: '{destination_path}'"
                )
            return PinnedFileCopy(
                path=destination_path,
                bytes=size,
                sha256=sha256,
                created=False,
            )

        try:
            destination_root.publish(partial, destination_path, overwrite=False)
        except FileExistsError:
            existing = destination_root.measure_file(
                destination_path,
                maximum_bytes=maximum,
            )
            if existing.bytes != size or existing.sha256 != sha256:
                raise PublicationConflict(
                    f"destination appeared with conflicting bytes: '{destination_path}'"
                )
            return PinnedFileCopy(
                path=destination_path,
                bytes=size,
                sha256=sha256,
                created=False,
            )

        published = destination_root.measure_file(
            destination_path,
            maximum_bytes=maximum,
        )
        if published.bytes != size or published.sha256 != sha256:
            raise PublicationConflict(
                f"published file does not match the stable source: '{destination_path}'"
            )
        source_root.assert_current()
        destination_root.assert_current()
        return PinnedFileCopy(
            path=destination_path,
            bytes=size,
            sha256=sha256,
            created=True,
        )
    finally:
        try:
            if destination_root.lexists(partial):
                destination_root.unlink(partial)
        except (OSError, RuntimeError, ValueError):
            pass


__all__ = [
    "PinnedFileCopy",
    "PinnedFileMeasurement",
    "PinnedPublicationRoot",
    "PublicationConflict",
    "PublicationError",
    "copy_file_no_clobber",
]
