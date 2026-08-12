"""Primitive JSONL file mechanics: serialization, byte offsets, and atomic publication.

A committed store uses its declared line-framable encoding and terminator, compact separators, and
insertion key order. Two optional sidecars can accompany it: a JSOI v2 byte-offset index (.jidx)
and a SHA-256 signature (.sig) accumulated during the write.

Offsets are captured from file.tell() as each record is written.

commit() publishes the .jsonl atomically, stats the published file, then writes and renames the
sidecars. The index records that file's length and last-write time; ticks are integer arithmetic on
st_mtime_ns.

Discipline selects create, append, or sealed. SEALED refuses to open this engine for writing and
does not mark the artifact on disk, so it constrains the declaring kind rather than the path.

Codec selects the escaping policy. Text with no form in the declared encoding is escaped or
refused; it is never substituted.

Contains no knowledge of kinds, schemas, ingestion, or run layout.
"""

import os
import json
import struct
import hashlib
from enum import Enum
from datetime import datetime, timezone
from typing import TYPE_CHECKING, Any, Dict, List, Optional

from .policy import DEFAULT_ENCODING, Codec, Eol, is_line_framable
from .sidecar import (
    SIG_SCHEMA_ID,
    find_stale_scratch,
    lock_path,
    temp_write_path,
    SIG_SCHEMA_PATH,
    DOTNET_TICKS_OFFSET,
    TICKS_PER_SECOND,
    get_file_dotnet_ticks,
    get_ticks_offset,
    store_paths,
)
from .writer import JsonWriterError, publish_staged_file, serialize_json, write_json

if TYPE_CHECKING:
    from .publication import PinnedPublicationRoot

# Codec and Eol are re-exported from policy, ticks and schema id from sidecar, for existing
# importers. The definitions live in the leaf modules that both the writer and the reader share.
__all__ = [
    "Codec",
    "Eol",
    "DEFAULT_ENCODING",
    "Discipline",
    "JsonlEngine",
    "SIG_SCHEMA_ID",
    "SIG_SCHEMA_PATH",
    "DOTNET_TICKS_OFFSET",
    "TICKS_PER_SECOND",
    "get_file_dotnet_ticks",
    "get_ticks_offset",
]


class Discipline(Enum):
    CREATE = "create"  # Replaces or creates fresh output
    APPEND = "append"  # Publishes existing records plus new records as one replacement
    SEALED = "sealed"  # Immutable; write attempt raises PermissionError


class JsonlEngine:
    """
    Deterministic JSONL engine for stream emission and transactional sidecar management.
    """
    def __init__(
        self,
        output_path: str,
        discipline: Discipline = Discipline.CREATE,
        codec: Codec = Codec.UNICODE,
        eol: Eol = Eol.LF,
        encoding: str = DEFAULT_ENCODING,
        emit_index: bool = True,
        emit_sig: bool = True,
        lock: bool = True,
        lock_timeout: float = 60.0,
        require_absent: bool = False,
        publication_root: Optional["PinnedPublicationRoot"] = None,
    ):
        self.discipline = discipline
        self.codec = codec
        self.eol = eol
        self.encoding = encoding
        try:
            framable = is_line_framable(encoding)
        except LookupError as exc:
            raise ValueError(f"unknown encoding '{encoding}'") from exc
        if not framable:
            raise ValueError(
                f"encoding '{encoding}' cannot frame JSONL records: a newline is not a single "
                f"0x0A byte under it (or the encoding emits a BOM). Single-object JSON has no "
                f"such limit -- use write_json()."
            )
        self.emit_index = emit_index
        self.emit_sig = emit_sig
        self.lock = lock
        self.lock_timeout = lock_timeout
        self.require_absent = require_absent
        self.publication_root = publication_root
        if publication_root is not None and discipline is not Discipline.CREATE:
            raise ValueError("a pinned publication root currently requires create discipline")

        paths = store_paths(output_path)
        self.output_path = paths.artifact
        self.jidx_path = paths.jidx
        self.sig_path = paths.sig
        if self.publication_root is not None:
            for path in (self.output_path, self.jidx_path, self.sig_path):
                self.publication_root.direct_leaf(path)

        # Resolved at __enter__: a scratch path is per-transaction, and reusing one across two
        # opens of the same engine would recreate the collision it exists to avoid.
        self.tmp_path = ""
        self.jidx_tmp = ""
        self.sig_tmp = ""
        self._lock = None

        self.offsets: List[int] = []
        self.line_count: int = 0
        self.hasher = hashlib.sha256()
        self._file = None
        self._committed = False
        self._poisoned: Optional[str] = None
        # Resolved at __enter__ against what is on disk; see the invariant there.
        self._emit_index = emit_index
        self._emit_sig = emit_sig

    def __enter__(self):
        if self.discipline == Discipline.SEALED:
            raise PermissionError(f"Cannot open sealed JSONL artifact for writing: {self.output_path}")

        if self.publication_root is None:
            os.makedirs(os.path.dirname(self.output_path), exist_ok=True)
        else:
            self.publication_root.direct_leaf(self.output_path)

        # An exclusive lease over the whole transaction, not merely over the rename. commit()
        # publishes the store and then writes two sidecars against it; a second writer landing
        # between those steps leaves a store signed by neither. The lock lives outside the artifact
        # directory -- see sidecar.lock_path.
        self._acquire_lease()
        try:
            # This precondition is intentionally evaluated only after the artifact lease is held.
            # A caller-side existence check cannot distinguish two concurrent create-only writers:
            # both can observe absence before either publishes.  lexists() also refuses dangling
            # links rather than treating them as vacant output paths.
            if self.require_absent and self._lexists(self.output_path):
                raise FileExistsError(
                    f"Refusing to replace existing JSONL artifact: {self.output_path}"
                )
            self._sweep_stale_scratch()

            self.tmp_path = temp_write_path(self.output_path)
            self.jidx_tmp = temp_write_path(self.jidx_path)
            self.sig_tmp = temp_write_path(self.sig_path)

            self.offsets.clear()
            self.line_count = 0
            self.hasher = hashlib.sha256()
            self._file = None
            self._committed = False
            self._poisoned = None

            # A commit must not leave a sidecar describing bytes it replaced. A sidecar already on
            # disk is therefore rebuilt whether or not this write asked for one: its presence is a
            # standing request, and the alternative is silently orphaning it against the new bytes.
            self._emit_index = self.emit_index or self._lexists(self.jidx_path)
            self._emit_sig = self.emit_sig or self._lexists(self.sig_path)

            if self.discipline == Discipline.APPEND and self._lexists(self.output_path):
                self._adopt_existing()
            else:
                self._file = self._open(self.tmp_path, "wb")
        except BaseException:
            # __exit__ is never called when __enter__ raises. Every operation after lease
            # acquisition therefore lives under this one cleanup guard, including APPEND's early
            # terminator precheck before a scratch handle exists.
            try:
                self._discard_transaction_scratch()
            finally:
                self._release_lease()
            raise

        return self

    def _acquire_lease(self) -> None:
        """Take the exclusive write lease for this artifact, if locking is enabled.

        filelock is already this repository's lock primitive and is reentrant per process, so a
        caller that nests writes on one artifact is not deadlocked by its own lease. Contention
        raises rather than blocking forever: a writer waiting on a lease held by something that
        died is a hang, and a hang is worse than an error that names the artifact.
        """
        if not self.lock:
            return

        from filelock import FileLock, Timeout

        target = (
            self.publication_root.lock_path(self.output_path)
            if self.publication_root is not None
            else lock_path(self.output_path)
        )
        self._lock = FileLock(target, timeout=self.lock_timeout)
        try:
            self._lock.acquire()
        except Timeout as exc:
            self._lock = None
            raise TimeoutError(
                f"Could not acquire the write lease for {self.output_path} within "
                f"{self.lock_timeout}s; another writer holds it (lock file: {target})."
            ) from exc

    def _sweep_stale_scratch(self) -> List[str]:
        """Remove scratch left beside this artifact by a writer that died mid-transaction.

        Sound only because the lease is held: no other live writer can be working on this artifact,
        so anything matching the scratch pattern was orphaned. Skipped when locking is declined --
        without the lease those files are indistinguishable from a peer's work in progress, and
        removing them would destroy it.
        """
        if self._lock is None:
            return []
        removed = []
        stale_paths = (
            self.publication_root.stale_scratch(
                self.output_path,
                self.jidx_path,
                self.sig_path,
            )
            if self.publication_root is not None
            else find_stale_scratch(self.output_path)
        )
        for stale in stale_paths:
            try:
                self._remove(stale)
                removed.append(stale)
            except OSError:
                pass
        return removed

    def _release_lease(self) -> None:
        if self._lock is not None:
            try:
                self._lock.release()
            finally:
                self._lock = None

    def _discard_transaction_scratch(self) -> None:
        """Close scratch and remove every unpublished transaction file, best effort."""
        if self._file is not None and not self._file.closed:
            try:
                self._file.close()
            except BaseException:
                # Cleanup must keep progressing and, during __enter__, must reach lease release
                # even if an unusual file wrapper itself fails while closing.
                pass
        self._file = None
        for tmp_file in (self.tmp_path, self.jidx_tmp, self.sig_tmp):
            if tmp_file and self._lexists(tmp_file):
                try:
                    self._remove(tmp_file)
                except OSError:
                    pass

    def _lexists(self, path: str) -> bool:
        if self.publication_root is not None:
            return self.publication_root.lexists(path)
        return os.path.lexists(path)

    def _open(self, path: str, mode: str):
        if self.publication_root is not None:
            return self.publication_root.open_file(path, mode)
        return open(path, mode)

    def _remove(self, path: str) -> None:
        if self.publication_root is not None:
            self.publication_root.unlink(path)
        else:
            os.remove(path)

    def _stat(self, path: str) -> os.stat_result:
        if self.publication_root is not None:
            return self.publication_root.stat_path(path)
        return os.stat(path, follow_symlinks=False)

    def _replace(self, staged: str, destination: str) -> None:
        if self.publication_root is not None:
            self.publication_root.replace(staged, destination)
        else:
            os.replace(staged, destination)

    def _publish(self, staged: str, destination: str, *, overwrite: bool) -> None:
        if self.publication_root is not None:
            self.publication_root.publish(staged, destination, overwrite=overwrite)
        else:
            publish_staged_file(staged, destination, overwrite=overwrite)

    def _adopt_existing(self) -> None:
        """Carry the published store into this transaction's tmp file, in one pass.

        The adoption copy, hash, framing check, and offset capture happen together, so the store is
        never held in memory. A conflicting valid signature requires one preliminary hash pass to
        establish that it still witnesses the bytes before its policy can be trusted.

        Adoption validates. A record this engine would refuse to read is one it refuses to extend:
        appending to a store with invalid framing or non-JSON values produces a longer store the
        reader still rejects, and the failure then surfaces at read time with no trace of which
        write introduced it. The base object contract is checked here; record schemas belong to the
        kind, and this module knows nothing about kinds.
        """
        # Local import avoids a module-load dependency from engine back to its reader. Both share
        # only leaf modules, so the reader is safe to use once this engine instance is active.
        from .reader import loads

        self._check_existing_signature_policy()
        terminator = self.eol.terminator(self.encoding)
        file_size = os.path.getsize(self.output_path)

        # O(1) precheck so a large store fails before it is copied rather than after.
        if file_size > 0:
            with open(self.output_path, "rb") as probe:
                probe.seek(-min(len(terminator), file_size), os.SEEK_END)
                tail = probe.read()
            if tail != terminator:
                raise ValueError(
                    f"Cannot append to unterminated JSONL file (expected a trailing "
                    f"{self.eol.value.upper()} terminator, found {tail!r}): {self.output_path}"
                )

        self._file = open(self.tmp_path, "wb")
        offset = 0
        with open(self.output_path, "rb") as src:
            for index, line in enumerate(src):
                body = self._check_adopted(line, index, terminator)
                # This is JsonlStore's strict parser, including non-finite-number and object checks.
                loads(body, path=self.output_path, encoding=self.encoding, record=index)
                written = self._file.write(line)
                if written != len(line):
                    raise OSError(
                        f"short write while adopting record {index}: wrote {written!r} of "
                        f"{len(line)} bytes"
                    )
                self.hasher.update(line)
                self.offsets.append(offset)
                offset += len(line)
        self.line_count = len(self.offsets)

    def _check_existing_signature_policy(self) -> None:
        """Refuse a conflicting policy witnessed by a current engine signature.

        Foreign, malformed, and stale sidecars retain the pre-existing append behavior: they are
        not policy witnesses and a successful commit replaces them. Hash and line count establish
        that a structurally valid engine signature describes the bytes being adopted before its
        declarations are trusted.
        """
        if not os.path.exists(self.sig_path):
            return

        # Local import keeps engine -> writer/sidecar/policy as the module-level dependency graph;
        # reader imports the same leaf modules and is safe to use after engine initialization.
        from .reader import JsonlStore

        try:
            signature = JsonlStore(self.output_path).read_sig()
        except (OSError, ValueError):
            return

        declared = {
            "encoding": self.encoding,
            "eol": self.eol.value,
            "codec": self.codec.value,
        }
        conflicts = [
            (field, signature.get(field), value)
            for field, value in declared.items()
            if signature.get(field) != value
        ]
        if not conflicts:
            return

        if signature["file_size"] != os.path.getsize(self.output_path):
            return
        witnessed_hash = hashlib.sha256()
        witnessed_lines = 0
        with open(self.output_path, "rb") as source:
            for line in source:
                witnessed_hash.update(line)
                witnessed_lines += 1
        if (
            witnessed_hash.hexdigest() != signature["sha256"]
            or witnessed_lines != signature["line_count"]
        ):
            return

        details = ", ".join(
            f"{field}: signature={witnessed!r}, appender={value!r}"
            for field, witnessed, value in conflicts
        )
        raise ValueError(
            f"Cannot append to {self.output_path}: its current engine signature declares a "
            f"conflicting write policy ({details})."
        )

    def _check_adopted(self, line: bytes, index: int, terminator: bytes) -> bytes:
        """Apply reader-equivalent framing checks and return the record body."""
        where = f"record {index} of {os.path.basename(self.output_path)}"
        if not line.endswith(terminator):
            raise ValueError(
                f"Cannot append: {where} does not end with this store's declared "
                f"{self.eol.value.upper()} terminator"
            )

        body = line[: -len(terminator)]
        if not body.strip():
            raise ValueError(f"Cannot append: {where} is blank")
        if b"\r" in body:
            raise ValueError(f"Cannot append: {where} contains a CR inside the record")
        return body

    def append(self, record: Dict[str, Any]) -> None:
        """
        Serializes and appends a single record line.

        Compact separators and insertion key order are fixed for every kind. The escaping policy,
        the encoding, and the record terminator are declared; see Codec, DEFAULT_ENCODING, and Eol.
        """
        if self._file is None or self._file.closed:
            raise RuntimeError("JsonlEngine must be active inside a 'with' context manager.")

        if self._poisoned is not None:
            raise RuntimeError(
                f"JSONL transaction for {self.output_path} is poisoned by an earlier write "
                f"failure and cannot accept records ({self._poisoned})."
            )

        # 1. Deterministic serialization under this store's declared policy. The writer names the
        #    encoding and the remedy but not the record; re-raise with it, since in a store of
        #    50,000 rows the index is the part a caller cannot recover.
        try:
            json_bytes = serialize_json(
                record, encoding=self.encoding, codec=self.codec, path=self.output_path
            )
        except JsonWriterError as exc:
            raise ValueError(f"record {self.line_count}: {exc}") from exc

        json_bytes += self.eol.terminator(self.encoding)

        # 2. Only advance index/hash/count after a complete write. Serialization failures occur
        # before the stream is touched and are recoverable; a stream failure may have written an
        # unknown prefix, so it poisons the transaction and commit must refuse it.
        offset = self._file.tell()
        try:
            written = self._file.write(json_bytes)
            if written != len(json_bytes):
                raise OSError(
                    f"short write for record {self.line_count}: wrote {written!r} of "
                    f"{len(json_bytes)} bytes"
                )
        except BaseException as exc:
            self._poisoned = f"record {self.line_count}: {type(exc).__name__}: {exc}"
            raise

        self.hasher.update(json_bytes)
        self.offsets.append(offset)
        self.line_count += 1

    def commit(self, stage_metadata: Optional[Dict[str, Any]] = None) -> None:
        """Publish the store, then write and rename its sidecars.

        The ordering is forced, not incidental. Both sidecars record the published file's byte
        length and last-write ticks, and neither exists until the .jsonl is at its final path, so
        publication has to come first. That leaves a window in which the store is published and its
        sidecars are not yet in place.

        A store is signed by default and an unsigned one is a valid state, so the window is
        survivable -- but it must not be silent. If a sidecar step fails, any sidecar left over
        from a previous commit now describes bytes that are gone; those are removed so the store
        reads as unsigned rather than as wrongly signed, and the error names what is on disk.
        """
        if self._poisoned is not None:
            raise RuntimeError(
                f"Refusing to commit poisoned JSONL transaction for {self.output_path} "
                f"({self._poisoned})."
            )

        if self._file and not self._file.closed:
            try:
                self._file.flush()
                self._file.close()
            except BaseException as exc:
                self._poisoned = f"finalizing scratch: {type(exc).__name__}: {exc}"
                raise

        # 1. Atomically publish .jsonl scratch -> final .jsonl FIRST
        self._publish(
            self.tmp_path,
            self.output_path,
            overwrite=not self.require_absent,
        )

        try:
            self._write_sidecars(stage_metadata)
        except BaseException as exc:
            stranded = self._discard_stale_sidecars()
            raise RuntimeError(
                f"{self.output_path} was published but its sidecars were not written "
                f"({type(exc).__name__}: {exc}). "
                + (
                    f"Removed now-stale {', '.join(stranded)} from a previous commit; "
                    if stranded
                    else ""
                )
                + "the store is intact and unsigned; re-run the write to sign it."
            ) from exc

        self._committed = True

    def _write_sidecars(self, stage_metadata: Optional[Dict[str, Any]]) -> None:
        """Build both sidecars against the published file, then rename them into place."""
        # 2. Stat the final published .jsonl file for exact size and .NET integer ticks
        published_info = self._stat(self.output_path)
        file_size = published_info.st_size
        ticks = (published_info.st_mtime_ns // 100) + get_ticks_offset()

        # 3. Generate JSOI v2 .jidx.tmp sidecar using exact stat ticks
        if self._emit_index:
            self._write_jidx_v2(self.jidx_tmp, file_size, ticks)

        # 4. Generate .sig.tmp sidecar
        if self._emit_sig:
            sig_payload = {
                # The sidecar names the schema that governs it, matching the manifest convention.
                # Unheadered stores carry no identity in the .jsonl itself, so this is where a
                # reader learns what it is holding.
                "schema": SIG_SCHEMA_ID,
                "sha256": self.hasher.hexdigest(),
                "line_count": self.line_count,
                "file_size": file_size,
                "ticks": ticks,
                "discipline": self.discipline.value,
                # The hash covers bytes produced under all three text-policy axes; record every one
                # of them, so a signature that fails to reproduce is attributable to a policy
                # difference rather than merely wrong. A reader learns the store's policy here.
                "encoding": self.encoding,
                "codec": self.codec.value,
                "eol": self.eol.value,
                "metadata": stage_metadata or {},
                "created_at": datetime.now(timezone.utc).isoformat()
            }
            # The .sig is written ASCII-escaped and UTF-8 regardless of the store's own policy: it
            # is the artifact that tells a reader what that policy was, so it cannot require the
            # answer in order to be read. atomic=False because the rename is step 5 -- both
            # sidecars appear together or not at all.
            if self.publication_root is None:
                write_json(
                    self.sig_tmp,
                    sig_payload,
                    encoding=DEFAULT_ENCODING,
                    codec=Codec.ASCII,
                    indent=2,
                    atomic=False,
                )
            else:
                raw = serialize_json(
                    sig_payload,
                    encoding=DEFAULT_ENCODING,
                    codec=Codec.ASCII,
                    indent=2,
                    path=self.sig_tmp,
                ) + b"\n"
                with self._open(self.sig_tmp, "wb") as handle:
                    written = handle.write(raw)
                    if written != len(raw):
                        raise OSError(
                            f"short write for signature: wrote {written!r} of {len(raw)} bytes"
                        )

        # 5. Atomically rename sidecars into target destinations. No existence guard: if the emit
        #    flag is set, step 3 or 4 wrote the tmp, and a missing one is the silent non-write this
        #    method exists to refuse. os.replace raises, which is the point.
        if self._emit_index:
            self._replace(self.jidx_tmp, self.jidx_path)
        if self._emit_sig:
            self._replace(self.sig_tmp, self.sig_path)

    def _discard_stale_sidecars(self) -> List[str]:
        """Remove sidecars describing bytes this commit replaced. Returns what was removed."""
        removed: List[str] = []
        for enabled, path, tmp in (
            (self._emit_index, self.jidx_path, self.jidx_tmp),
            (self._emit_sig, self.sig_path, self.sig_tmp),
        ):
            if not enabled:
                continue
            for target, label in ((tmp, None), (path, os.path.basename(path))):
                if self._lexists(target):
                    try:
                        self._remove(target)
                        if label:
                            removed.append(label)
                    except OSError:
                        pass
        return removed

    def _write_jidx_v2(self, target_jidx_path: str, file_size: int, ticks: int) -> None:
        """
        Writes binary JSOI v2 index format:
        ASCII 'JSOI' | int32 ver=2 | int32 lineCount | int64 sourceLength |
        int64 sourceLastWriteUtcTicks | int64[lineCount] offsets
        """
        with self._open(target_jidx_path, "wb") as f:
            f.write(b"JSOI")                              # Magic (4B ASCII)
            f.write(struct.pack("<i", 2))                 # Version 2 (int32)
            f.write(struct.pack("<i", len(self.offsets))) # Line Count (int32)
            f.write(struct.pack("<q", file_size))         # sourceLength (int64)
            f.write(struct.pack("<q", ticks))             # sourceLastWriteUtcTicks (int64)
            for o in self.offsets:
                f.write(struct.pack("<q", o))             # Line Offset (int64)

    def __exit__(self, exc_type, exc_val, exc_tb):
        try:
            # Clean up temporary files if uncommitted or on exception
            if not self._committed or exc_type is not None:
                self._discard_transaction_scratch()
            elif self._file and not self._file.closed:
                self._file.close()
        finally:
            # Released last and unconditionally: the lease covers the publish and both sidecar
            # renames, so dropping it earlier would reopen the window it exists to close.
            self._release_lease()
