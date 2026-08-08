"""JSON-in, JSON-out command surface over the engine.

Exists so a shell front-end can be thin. jso-shell.ps1 parses no JSONL, resolves no pointer, and
knows no sidecar convention: it marshals arguments here and converts one stream of JSON back. The
alternative is a second implementation of the engine in PowerShell, which is what this replaces.

Contract, so the front-end can stay dumb:

    stdout   UTF-8, LF-terminated, one compact JSON value per line
    stderr   one JSON object {"error": type, "message": ...} on failure
    exit     0 on success, 1 on a handled failure, 2 on bad arguments

Writing bytes to the stdout buffer directly rather than through print(): the process encoding is
whatever the host console happens to be, and on Windows that is routinely not UTF-8. Encoding is a
declared knob here for the same reason it is everywhere else in this engine.
"""

from __future__ import annotations

import argparse
import json
import sys
from typing import Any, Callable, Dict, Iterable, Iterator, List, Optional

from .inspect import inspect_store, snapshot
from .pointer import MISSING, resolve
from .reader import JsonlStore, read_json
from .schemas import get_schema_catalog

__all__ = ["main"]


def _emit(values: Iterable[Any]) -> None:
    """Write each value as one compact JSON line of UTF-8."""
    buffer = sys.stdout.buffer
    for value in values:
        buffer.write(json.dumps(value, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))
        buffer.write(b"\n")
    buffer.flush()


def _fail(exc: BaseException) -> int:
    payload = {"error": type(exc).__name__, "message": str(exc)}
    sys.stderr.buffer.write(
        json.dumps(payload, ensure_ascii=False, separators=(",", ":")).encode("utf-8") + b"\n"
    )
    sys.stderr.buffer.flush()
    return 1


def _store(args: argparse.Namespace) -> JsonlStore:
    """Open the store under the view the caller asked for.

    Default is the last complete record rather than EOF: a shell reader is the most likely thing to
    be pointed at a store something else is still appending to, and a torn final record is a
    confusing way to learn that.
    """
    store = JsonlStore(args.path, require_object=False)
    if getattr(args, "at_signature", False):
        return store.at_signature()
    if getattr(args, "unbounded", False):
        return store
    return store.at_length()


# -- verbs --------------------------------------------------------------------------------------


def _cmd_info(args: argparse.Namespace) -> int:
    info = inspect_store(args.path)
    _emit([{
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
    _emit([{"count": len(_store(args))}])
    return 0


def _cmd_head(args: argparse.Namespace) -> int:
    _emit(_take(_store(args), args.count))
    return 0


def _cmd_tail(args: argparse.Namespace) -> int:
    store = _store(args)
    total = len(store)
    _emit(store[max(0, total - args.count):total])
    return 0


def _cmd_range(args: argparse.Namespace) -> int:
    store = _store(args)
    stop = args.stop if args.stop is not None else len(store)
    _emit(store[args.start:stop])
    return 0


def _cmd_get(args: argparse.Namespace) -> int:
    _emit([_store(args)[args.index]])
    return 0


def _cmd_select(args: argparse.Namespace) -> int:
    """Project one pointer from each record. Records where it does not resolve are skipped.

    Skipped rather than emitted as null: over a heterogeneous store, "this row has none" and "this
    row has null" are different answers, and collapsing them would make a projection unable to say
    which it found.
    """
    projected = (resolve(record, args.pointer) for record in _store(args))
    _emit(value for value in projected if value is not MISSING)
    return 0


_PREDICATES: Dict[str, Callable[[Any, Any], bool]] = {
    "eq": lambda found, want: found == want,
    "ne": lambda found, want: found != want,
    "gt": lambda found, want: found is not None and want is not None and found > want,
    "lt": lambda found, want: found is not None and want is not None and found < want,
    "contains": lambda found, want: want in found if isinstance(found, (str, list)) else False,
    "exists": lambda found, want: found is not MISSING,
    "missing": lambda found, want: found is MISSING,
}


def _cmd_find(args: argparse.Namespace) -> int:
    predicate = _PREDICATES[args.op]
    wanted = json.loads(args.value) if args.value is not None else None
    matches = (
        record
        for record in _store(args)
        if predicate(resolve(record, args.pointer), wanted)
    )
    _emit(_take(matches, args.limit) if args.limit else matches)
    return 0


def _cmd_verify(args: argparse.Namespace) -> int:
    store = _store(args)
    verified = store.verify()
    _emit([{
        "path": store.paths.artifact,
        "signed": store.has_signature,
        # None means unsigned: no check ran, which is not the same as a check that failed.
        "verified": verified,
    }])
    return 0


def _cmd_sig(args: argparse.Namespace) -> int:
    _emit([JsonlStore(args.path).read_sig()])
    return 0


def _cmd_snapshot(args: argparse.Namespace) -> int:
    written = snapshot(args.path, args.destination)
    _emit([{"source": args.path, "destination": args.destination, "bytes": written}])
    return 0


def _cmd_schemas(args: argparse.Namespace) -> int:
    catalog = get_schema_catalog()
    _emit(
        {
            "id": schema_id,
            "title": catalog.get_schema(schema_id).get("title"),
            "identity": list(catalog.identity_of(schema_id)),
        }
        for schema_id in catalog.keys()
    )
    return 0


def _cmd_read_json(args: argparse.Namespace) -> int:
    _emit([read_json(args.path, require_object=False)])
    return 0


def _take(values: Iterable[Any], count: int) -> Iterator[Any]:
    for index, value in enumerate(values):
        if index >= count:
            return
        yield value


# -- argument surface ---------------------------------------------------------------------------


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="python -m jsonl_engine",
        description="Read and inspect JSONL stores and JSON documents.",
    )
    sub = parser.add_subparsers(dest="verb", required=True)

    def store_verb(name: str, help_text: str, handler) -> argparse.ArgumentParser:
        cmd = sub.add_parser(name, help=help_text)
        cmd.add_argument("path")
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

    store_verb("info", "physical facts, without parsing", _cmd_info)
    store_verb("count", "number of records", _cmd_count)
    store_verb("verify", "check the store against its .sig", _cmd_verify)
    store_verb("sig", "print the .sig", _cmd_sig)

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

    snap = store_verb("snapshot", "copy the complete-record prefix elsewhere", _cmd_snapshot)
    snap.add_argument("destination")

    schemas = sub.add_parser("schemas", help="schemas the engine ships")
    schemas.set_defaults(handler=_cmd_schemas)

    document = sub.add_parser("json", help="read one JSON document")
    document.add_argument("path")
    document.set_defaults(handler=_cmd_read_json)

    return parser


def main(argv: Optional[List[str]] = None) -> int:
    args = _build_parser().parse_args(argv)
    try:
        return args.handler(args)
    except BrokenPipeError:
        # A downstream consumer stopped reading, e.g. `... | Select-Object -First 5`.
        return 0
    except Exception as exc:  # noqa: BLE001 - the boundary turns every failure into JSON
        return _fail(exc)


if __name__ == "__main__":
    sys.exit(main())
