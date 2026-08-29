"""JSON-in, JSON-out command surface over the engine.

Exists so the PowerShell client can remain an adapter. The client parses no JSONL, resolves no
pointer, and knows no sidecar convention: it marshals arguments here and converts the versioned
JSON protocol back into PowerShell values. A second implementation of the engine in PowerShell is
not part of this boundary.

Contract, so the front-end can stay dumb:

    stdout   UTF-8, LF-terminated, one compact JSON value per line
    stderr   one JSON error object on failure
    exit     0 on success, 1 on a handled failure, 2 on bad arguments

Writing bytes to the stdout buffer directly rather than through print(): the process encoding is
whatever the host console happens to be, and on Windows that is routinely not UTF-8. Encoding is a
declared knob here for the same reason it is everywhere else in this engine.
"""

from __future__ import annotations

import argparse
import importlib
import json
import sys
from typing import Any, Callable, Dict, Iterable, Iterator, List, Optional

from .deposit import deposit_article
from .inspect import inspect_prefix, inspect_store, repair_prefix, snapshot
from .inventory_catalog import build_inventory, load_article_paths_json
from .kinds.article import ArticleManifest, ArticleMetadataExtension
from .policy import Eol
from .pointer import MISSING, resolve
from .reader import JsonlStore, read_json, read_json_or_none
from .schemas import get_schema_catalog
from .sidecar import SIG_SCHEMA_ID, store_paths

__all__ = ["main"]


PROTOCOL = "codex-scientiae/jsonl_engine-cli"
PROTOCOL_VERSION = 1
STABLE_VERBS = (
    "capabilities",
    "info",
    "count",
    "deposit",
    "build-inventory",
    "head",
    "tail",
    "range",
    "get",
    "select",
    "find",
    "validate-json",
    "verify",
    "sig",
    "snapshot",
    "inspect-prefix",
    "repair-prefix",
    "schemas",
    "json",
)


class ArgumentError(ValueError):
    """An argparse failure that belongs to the machine-readable CLI contract."""


class _CliArgumentParser(argparse.ArgumentParser):
    """Keep bad arguments off argparse's human-oriented usage/error stream."""

    def error(self, message: str) -> None:
        raise ArgumentError(message)


def _json_bytes(value: Any) -> bytes:
    """One strict JSON value as UTF-8, escaping only when UTF-8 has no form for the text.

    Codec.ASCII exists specifically so an extracted unpaired surrogate can survive in a store.
    Such a code unit has no UTF-8 representation, but it does have an unambiguous JSON escape, so
    the process boundary falls back to ensure_ascii=True rather than making that store unreadable.
    """
    options = {"separators": (",", ":"), "allow_nan": False}
    text = json.dumps(value, ensure_ascii=False, **options)
    try:
        return text.encode("utf-8")
    except UnicodeEncodeError:
        return json.dumps(value, ensure_ascii=True, **options).encode("utf-8")


def _emit(values: Iterable[Any], *, framed: bool = False) -> None:
    """Write each value as one compact, strict JSON line of UTF-8."""
    buffer = sys.stdout.buffer
    for sequence, value in enumerate(values):
        if framed:
            value = {
                "protocol": PROTOCOL,
                "version": PROTOCOL_VERSION,
                "type": "value",
                "sequence": sequence,
                "value": value,
            }
        buffer.write(_json_bytes(value) + b"\n")
    buffer.flush()


def _fail(exc: BaseException, *, exit_code: int = 1) -> int:
    payload = {
        "protocol": PROTOCOL,
        "version": PROTOCOL_VERSION,
        "type": "error",
        "error": type(exc).__name__,
        "message": str(exc),
    }
    sys.stderr.buffer.write(_json_bytes(payload) + b"\n")
    sys.stderr.buffer.flush()
    return exit_code


def _emit_for(args: argparse.Namespace, values: Iterable[Any]) -> None:
    """Emit values using the global framing mode parsed before the verb."""
    _emit(values, framed=args.framed)


def _declared_store(path: str) -> JsonlStore:
    """Open a store under policy witnessed by an engine signature, when one exists.

    A foreign or malformed optional sidecar does not prevent ordinary reads under the defaults.
    Operations that require a signature still call read_sig()/at_signature() and report it.
    """
    store = JsonlStore(path, require_object=False)
    try:
        raw_sig = read_json_or_none(store_paths(path).sig)
        if not isinstance(raw_sig, dict) or raw_sig.get("schema") != SIG_SCHEMA_ID:
            return store

        sig = store.read_sig()
        return JsonlStore(
            path,
            encoding=sig["encoding"],
            eol=Eol(sig["eol"]),
            require_object=False,
        )
    except (FileNotFoundError, ValueError):
        # The sidecar is optional for ordinary reads. verify/--at-signature will consult it again
        # through the strict reader and surface absence or corruption there.
        return store


def _store(args: argparse.Namespace) -> JsonlStore:
    """Open the store under the view the caller asked for.

    Default is the last complete record rather than EOF: a shell reader is the most likely thing to
    be pointed at a store something else is still appending to, and a torn final record is a
    confusing way to learn that.
    """
    store = _declared_store(args.path)
    if getattr(args, "at_signature", False):
        return store.at_signature()
    if getattr(args, "unbounded", False):
        return store
    return store.at_length()


# -- verbs --------------------------------------------------------------------------------------


def _cmd_info(args: argparse.Namespace) -> int:
    info = inspect_store(args.path)
    _emit_for(args, [{
        "path": info.path,
        "exists": info.exists,
        "size": info.size,
        "line_count": info.line_count,
        "terminated": info.terminated,
        "eol": info.eol.value if info.eol else None,
        "has_index": info.has_index,
        "has_signature": info.has_signature,
    }])
    return 0


def _cmd_count(args: argparse.Namespace) -> int:
    _emit_for(args, [{"count": len(_store(args))}])
    return 0


def _cmd_head(args: argparse.Namespace) -> int:
    _emit_for(args, _take(_store(args), args.count))
    return 0


def _cmd_tail(args: argparse.Namespace) -> int:
    store = _store(args)
    total = len(store)
    _emit_for(args, store[max(0, total - args.count):total])
    return 0


def _cmd_range(args: argparse.Namespace) -> int:
    store = _store(args)
    stop = args.stop if args.stop is not None else len(store)
    _emit_for(args, store[args.start:stop])
    return 0


def _cmd_get(args: argparse.Namespace) -> int:
    _emit_for(args, [_store(args)[args.index]])
    return 0


def _cmd_select(args: argparse.Namespace) -> int:
    """Project one pointer from each record. Records where it does not resolve are skipped.

    Skipped rather than emitted as null: over a heterogeneous store, "this row has none" and "this
    row has null" are different answers, and collapsing them would make a projection unable to say
    which it found.
    """
    projected = (resolve(record, args.pointer) for record in _store(args))
    _emit_for(args, (value for value in projected if value is not MISSING))
    return 0


def _compare(found: Any, want: Any, operation: Callable[[Any, Any], bool]) -> bool:
    """Apply an ordered predicate only where the pointer resolved and the types compare."""
    if found is MISSING or found is None or want is None:
        return False
    try:
        return operation(found, want)
    except TypeError:
        return False


def _reject_json_constant(token: str) -> None:
    """Reject the JavaScript constants Python's decoder otherwise accepts as JSON."""
    raise ValueError(f"Non-standard JSON constant is not allowed: {token}")


def _contains(found: Any, want: Any) -> bool:
    """Apply containment where JSON value types define it without coercion."""
    if found is MISSING:
        return False
    if isinstance(found, str):
        return isinstance(want, str) and want in found
    if isinstance(found, list):
        return want in found
    return False


_PREDICATES: Dict[str, Callable[[Any, Any], bool]] = {
    "eq": lambda found, want: found is not MISSING and found == want,
    "ne": lambda found, want: found is not MISSING and found != want,
    "gt": lambda found, want: _compare(found, want, lambda left, right: left > right),
    "lt": lambda found, want: _compare(found, want, lambda left, right: left < right),
    "contains": _contains,
    "exists": lambda found, want: found is not MISSING,
    "missing": lambda found, want: found is MISSING,
}


def _cmd_find(args: argparse.Namespace) -> int:
    predicate = _PREDICATES[args.op]
    wanted = (
        json.loads(
            args.value,
            parse_constant=_reject_json_constant,
        )
        if args.value is not None
        else None
    )
    matches = (
        record
        for record in _store(args)
        if predicate(resolve(record, args.pointer), wanted)
    )
    _emit_for(args, _take(matches, args.limit) if args.limit else matches)
    return 0


def _cmd_verify(args: argparse.Namespace) -> int:
    # Verification answers for the physical store by default. The ordinary shell read default is a
    # complete-record prefix so it does not parse a torn append; applying that default here would
    # silently ignore an unterminated tail and report the whole store as verified. A caller that
    # deliberately wants the committed signed prefix asks for --at-signature.
    store = _declared_store(args.path)
    if getattr(args, "at_signature", False):
        store = store.at_signature()
    verified = store.verify()
    _emit_for(args, [{
        "path": store.paths.artifact,
        "signed": store.has_signature,
        # None means unsigned: no check ran, which is not the same as a check that failed.
        "verified": verified,
    }])
    return 0


def _cmd_sig(args: argparse.Namespace) -> int:
    _emit_for(args, [JsonlStore(args.path).read_sig()])
    return 0


def _cmd_snapshot(args: argparse.Namespace) -> int:
    written = snapshot(args.path, args.destination)
    _emit_for(args, [{"source": args.path, "destination": args.destination, "bytes": written}])
    return 0


def _prefix_policy(path: str) -> tuple:
    """Encoding and terminator witnessed by an engine signature, else the engine defaults."""
    store = _declared_store(path)
    return store.encoding, store.eol


def _cmd_inspect_prefix(args: argparse.Namespace) -> int:
    encoding, eol = _prefix_policy(args.path)
    scan = inspect_prefix(
        args.path,
        encoding=encoding,
        eol=eol,
        collect_records=bool(args.collect),
    )
    payload = {
        "path": scan.path,
        "exists": scan.exists,
        "valid": scan.valid,
        "size": scan.size,
        "valid_prefix_bytes": scan.valid_prefix_bytes,
        "record_count": scan.record_count,
        "error_line": scan.error_line,
        "error": scan.error,
    }
    if args.collect:
        payload["records"] = list(scan.records)
    _emit_for(args, [payload])
    return 0


def _cmd_repair_prefix(args: argparse.Namespace) -> int:
    encoding, eol = _prefix_policy(args.path)
    scan = inspect_prefix(args.path, encoding=encoding, eol=eol)
    bound = scan.valid_prefix_bytes if args.bytes is None else args.bytes
    removed = max(scan.size - bound, 0)
    needed = scan.exists and bound < scan.size
    if not args.apply:
        _emit_for(
            args,
            [{
                "path": scan.path,
                "needed": needed,
                "applied": False,
                "valid_prefix_bytes": scan.valid_prefix_bytes,
                "committed_bytes": bound,
                "removed_bytes": removed if needed else 0,
                "error_line": scan.error_line,
                "error": scan.error,
            }],
        )
        return 0
    if not needed:
        raise ValueError(
            f"repair prefix must remove at least one byte from a {scan.size}-byte store"
        )
    receipt = repair_prefix(
        args.path,
        bound,
        backup_label=args.backup_label,
    )
    _emit_for(
        args,
        [{
            "path": receipt.path,
            "needed": True,
            "applied": True,
            "backup": receipt.backup_path,
            "original_bytes": receipt.original_bytes,
            "committed_bytes": receipt.committed_bytes,
            "removed_bytes": receipt.removed_bytes,
            "signed": receipt.signed,
            "indexed": receipt.indexed,
            "error_line": scan.error_line,
            "error": scan.error,
        }],
    )
    return 0


def _cmd_schemas(args: argparse.Namespace) -> int:
    catalog = get_schema_catalog()
    _emit_for(
        args,
        (
            {
                "id": schema_id,
                "title": catalog.get_schema(schema_id).get("title"),
                "identity": list(catalog.identity_of(schema_id)),
            }
            for schema_id in catalog.keys()
        ),
    )
    return 0


def _cmd_read_json(args: argparse.Namespace) -> int:
    _emit_for(args, [read_json(args.path, require_object=False)])
    return 0


def _cmd_validate_json(args: argparse.Namespace) -> int:
    """Read one strict JSON object through a shipped schema and emit the validated value."""
    catalog = get_schema_catalog()
    requested_schema = catalog.get_schema(args.schema)
    article_schema = catalog.get_schema(ArticleManifest.RECORD_SCHEMA)
    validator = (
        ArticleManifest(target_dir=".", schema_catalog=catalog)
        if requested_schema is article_schema
        else catalog.get_validator(args.schema)
    )
    _emit_for(args, [read_json(args.path, validator=validator)])
    return 0


def _cmd_capabilities(args: argparse.Namespace) -> int:
    _emit_for(args, [{
        "protocol": PROTOCOL,
        "version": PROTOCOL_VERSION,
        "framing": True,
        "verbs": list(STABLE_VERBS),
    }])
    return 0


def _load_metadata_extension(specification: str | None) -> ArticleMetadataExtension | None:
    """Load one caller-selected article metadata extension factory."""

    if specification is None:
        return None
    module_name, separator, attribute_name = specification.partition(":")
    if not separator or not module_name or not attribute_name:
        raise ValueError("metadata extension must use the form 'module:factory'")
    module = importlib.import_module(module_name)
    target = getattr(module, attribute_name)
    extension = target() if callable(target) else target
    if not isinstance(extension, ArticleMetadataExtension):
        raise TypeError("metadata extension factory returned an incompatible object")
    return extension


def _cmd_deposit(args: argparse.Namespace) -> int:
    result = deposit_article(
        document_dir=args.document_dir,
        slug=args.slug,
        archive=args.archive,
        archive_sha256=args.archive_sha256,
        archive_kind=args.archive_kind,
        tree=args.tree,
        tree_sha256=args.tree_sha256,
        files=args.files,
        tex_files=args.tex_files,
        entrypoint=args.entrypoint,
        entrypoint_selection=args.entrypoint_selection,
        publication=args.publication,
        findings=read_json(args.findings_json),
        provider_json=args.provider_json,
        metadata_json=args.metadata_json,
        metadata_extension=_load_metadata_extension(args.metadata_extension),
        pdf=args.pdf,
    )
    _emit_for(args, [result.as_dict()])
    return 0


def _cmd_build_inventory(args: argparse.Namespace) -> int:
    article_paths = load_article_paths_json(args.article_paths_json)
    result = build_inventory(
        catalog_dir=args.catalog_dir,
        article_paths=article_paths,
        force=bool(args.force),
    )
    _emit_for(args, [result.as_dict()])
    return 0


def _take(values: Iterable[Any], count: int) -> Iterator[Any]:
    for index, value in enumerate(values):
        if index >= count:
            return
        yield value


# -- argument surface ---------------------------------------------------------------------------


def _build_parser() -> argparse.ArgumentParser:
    parser = _CliArgumentParser(
        prog="python -m jsonl_engine",
        description="Read, inspect, and publish JSON/JSONL artifacts.",
    )
    parser.add_argument(
        "--framed",
        action="store_true",
        help="wrap each success value in a versioned protocol frame",
    )
    sub = parser.add_subparsers(dest="verb", required=True)

    def store_verb(
        name: str, help_text: str, handler, *, views: bool = True
    ) -> argparse.ArgumentParser:
        cmd = sub.add_parser(name, help=help_text)
        cmd.add_argument("path")
        if views:
            view = cmd.add_mutually_exclusive_group()
            view.add_argument(
                "--at-signature",
                action="store_true",
                help="read only what the .sig attests to",
            )
            view.add_argument(
                "--unbounded",
                action="store_true",
                help="read to EOF, including a record another process is still writing",
            )
        cmd.set_defaults(handler=handler)
        return cmd

    store_verb("info", "physical facts, without parsing", _cmd_info, views=False)
    store_verb("count", "number of records", _cmd_count)
    store_verb("verify", "check the store against its .sig", _cmd_verify)
    store_verb("sig", "print the .sig", _cmd_sig, views=False)

    capabilities = sub.add_parser("capabilities", help="describe the stable CLI protocol")
    capabilities.set_defaults(handler=_cmd_capabilities)

    head = store_verb("head", "first N records", _cmd_head)
    head.add_argument("-n", "--count", type=int, default=10)

    tail = store_verb("tail", "last N records", _cmd_tail)
    tail.add_argument("-n", "--count", type=int, default=10)

    rng = store_verb("range", "records [start, stop)", _cmd_range)
    rng.add_argument("start", type=int)
    rng.add_argument("stop", type=int, nargs="?")

    get = store_verb("get", "one record by index", _cmd_get)
    get.add_argument("index", type=int)

    select = store_verb("select", "project a JSON Pointer from each record", _cmd_select)
    select.add_argument("pointer")

    find = store_verb("find", "records matching a pointer predicate", _cmd_find)
    find.add_argument("pointer")
    find.add_argument("op", choices=sorted(_PREDICATES))
    find.add_argument("value", nargs="?", help="JSON literal, e.g. '\"text\"' or 3")
    find.add_argument("--limit", type=int, default=0)

    snap = store_verb(
        "snapshot", "copy the complete-record prefix elsewhere", _cmd_snapshot, views=False
    )
    snap.add_argument("destination")

    inspect_prefix_cmd = store_verb(
        "inspect-prefix",
        "walk records until the first framing or JSON failure",
        _cmd_inspect_prefix,
        views=False,
    )
    inspect_prefix_cmd.add_argument(
        "--collect",
        action="store_true",
        help="include decoded records up to the valid prefix",
    )

    repair_prefix_cmd = store_verb(
        "repair-prefix",
        "preview or publish a complete-record prefix onto the store",
        _cmd_repair_prefix,
        views=False,
    )
    repair_prefix_cmd.add_argument(
        "--apply",
        action="store_true",
        help="perform the write; without this flag the command only reports",
    )
    repair_prefix_cmd.add_argument(
        "--bytes",
        type=int,
        default=None,
        help="byte length to keep; default is the inspected valid prefix",
    )
    repair_prefix_cmd.add_argument(
        "--backup-label",
        default="corrupt",
        help="lowercase filesystem-safe token used in the sibling .bak name",
    )

    schemas = sub.add_parser("schemas", help="schemas the engine ships")
    schemas.set_defaults(handler=_cmd_schemas)

    document = sub.add_parser("json", help="read one JSON document")
    document.add_argument("path")
    document.set_defaults(handler=_cmd_read_json)

    validated_document = sub.add_parser(
        "validate-json", help="read one JSON object through a shipped schema"
    )
    validated_document.add_argument("path")
    validated_document.add_argument("schema")
    validated_document.set_defaults(handler=_cmd_validate_json)

    deposit = sub.add_parser(
        "deposit",
        help="create or validate one article.json deposit",
        description=(
            "Create or validate one article.json deposit. The caller must keep the source "
            "tree and deposited inputs stable for the duration of this command."
        ),
    )
    deposit.add_argument("--document-dir", required=True)
    deposit.add_argument("--slug", required=True)
    deposit.add_argument("--archive", required=True)
    deposit.add_argument("--archive-sha256", required=True)
    deposit.add_argument(
        "--archive-kind", required=True, choices=("tar+gzip", "single-tex+gzip")
    )
    deposit.add_argument("--tree", required=True)
    deposit.add_argument("--tree-sha256", required=True)
    deposit.add_argument("--files", required=True, type=int)
    deposit.add_argument("--tex-files", required=True, type=int)
    deposit.add_argument("--entrypoint", required=True)
    deposit.add_argument("--entrypoint-selection", required=True)
    deposit.add_argument(
        "--publication",
        required=True,
        choices=("published-new-tree", "recovered-existing-tree"),
    )
    deposit.add_argument("--findings-json", required=True)
    metadata = deposit.add_mutually_exclusive_group()
    metadata.add_argument("--provider-json")
    metadata.add_argument("--metadata-json")
    deposit.add_argument(
        "--metadata-extension",
        help="application metadata extension as module:factory; required with --metadata-json",
    )
    deposit.add_argument("--pdf")
    deposit.set_defaults(handler=_cmd_deposit)

    build_inventory_cmd = sub.add_parser(
        "build-inventory",
        help="build one catalog-root inventory.jsonl from article.json paths",
        description=(
            "Publish inventory.jsonl under a catalog directory from an explicit JSON array of "
            "direct-child article.json paths. Refuses an existing inventory.jsonl unless --force "
            "is set. The engine does not walk the filesystem."
        ),
    )
    build_inventory_cmd.add_argument("--catalog-dir", required=True)
    build_inventory_cmd.add_argument(
        "--article-paths-json",
        required=True,
        help="JSON array of absolute article.json paths (UTF-8, one array value)",
    )
    build_inventory_cmd.add_argument(
        "--force",
        action="store_true",
        help="overwrite an existing inventory.jsonl",
    )
    build_inventory_cmd.set_defaults(handler=_cmd_build_inventory)

    return parser


def main(argv: Optional[List[str]] = None) -> int:
    try:
        args = _build_parser().parse_args(argv)
    except ArgumentError as exc:
        return _fail(exc, exit_code=2)
    try:
        return args.handler(args)
    except BrokenPipeError:
        # A downstream consumer stopped reading, e.g. `... | Select-Object -First 5`.
        return 0
    except Exception as exc:  # noqa: BLE001 - the boundary turns every failure into JSON
        return _fail(exc)


if __name__ == "__main__":
    sys.exit(main())
