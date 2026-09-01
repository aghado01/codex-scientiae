"""LaTeX entrypoint, closure, metadata, and tree inspection."""

from __future__ import annotations

import hashlib
import os
import posixpath
import re
import stat
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator, Sequence

from jsonl_engine.publication import PinnedPublicationRoot, PublicationError

from procurement.errors import SourceMaterializationError
from procurement.source._safety import (
    _plain_directory,
    _portable_leaf,
    _portable_relative,
    _same_path,
    _same_path_generation,
    _stat_identity,
)
from procurement.storage.safety import is_link_or_reparse
from procurement.source.contracts import ArchiveLimits, LatexSourceError
from procurement.source.tree import (
    TreeFile,
    _TreeEntry,
    _fingerprint_inventory,
    _tree_inventory,
)


_DOCUMENT_CLASS = re.compile(r"\\documentclass(?:\s*\[[^\]]*\])?\s*\{")
_DOCUMENT_MARKER = re.compile(r"\\begin\s*\{\s*document\s*\}")
_INPUT_COMMAND = re.compile(
    r"\\(?P<command>input|include|subfile)(?![A-Za-z])"
    r"(?:\s*\{(?P<braced>[^{}]+)\}|"
    r"\s*(?P<bare>[^\s\\{}\[\]\x25][^\s\\{}%]*))"
)


@dataclass(frozen=True, slots=True)
class EmbeddedLatexMetadata:
    """Literal metadata declarations found in the resolved LaTeX source."""

    title_tex: str | None
    authors_tex: tuple[str, ...]
    doi: str | None


@dataclass(frozen=True, slots=True)
class UnresolvedLatexInput:
    """One literal input command whose target is absent from the source tree."""

    command: str
    literal: str
    referenced_by: str


@dataclass(frozen=True, slots=True)
class LatexSourceInspection:
    """Validated entrypoint, source closure, metadata, and tree identity."""

    root_path: str
    entrypoint: str
    entrypoint_selection: str
    file_count: int
    tex_file_count: int
    tree_sha256: str
    files: tuple[TreeFile, ...]
    package_control_files: tuple[TreeFile, ...]
    embedded_metadata: EmbeddedLatexMetadata
    unresolved_inputs: tuple[UnresolvedLatexInput, ...] = ()


def _stable_read_text(entry: _TreeEntry, *, maximum: int) -> tuple[str, str]:
    if entry.info.st_size > maximum:
        raise LatexSourceError(
            f"LaTeX input exceeds the {maximum}-byte read boundary: {entry.relative!r}"
        )
    try:
        with entry.publication_root.open_stable_relative_file(entry.relative) as handle:
            before = os.fstat(handle.fileno())
            if not _same_path_generation(before, entry.info):
                raise LatexSourceError(
                    f"LaTeX input changed before it was read: {entry.relative!r}"
                )
            raw = handle.read(maximum + 1)
            after = os.fstat(handle.fileno())
    except LatexSourceError:
        raise
    except (OSError, PublicationError, RuntimeError, ValueError) as exc:
        raise LatexSourceError(f"LaTeX input cannot be read: {entry.relative!r}") from exc
    if (
        len(raw) > maximum
        or len(raw) != after.st_size
        or _stat_identity(before) != _stat_identity(after)
    ):
        raise LatexSourceError(f"LaTeX input changed while it was read: {entry.relative!r}")
    try:
        current = entry.publication_root.stat_relative(entry.relative)
    except (OSError, PublicationError, RuntimeError, ValueError) as exc:
        raise LatexSourceError(f"LaTeX input path changed: {entry.relative!r}") from exc
    if (
        not stat.S_ISREG(current.st_mode)
        or is_link_or_reparse(current)
        or not _same_path_generation(after, current)
    ):
        raise LatexSourceError(f"LaTeX input path changed: {entry.relative!r}")
    try:
        text = raw.decode("utf-8", "strict")
    except UnicodeDecodeError as exc:
        raise LatexSourceError(f"LaTeX source is not valid UTF-8: {entry.relative!r}") from exc
    if "\x00" in text:
        raise LatexSourceError(f"LaTeX source contains NUL: {entry.relative!r}")
    return text, hashlib.sha256(raw).hexdigest()


def _remove_line_comments(text: str) -> str:
    lines = re.split(r"\r?\n", text)
    cleaned: list[str] = []
    for line in lines:
        cut = len(line)
        for index, character in enumerate(line):
            if character != "%":
                continue
            slashes = 0
            cursor = index - 1
            while cursor >= 0 and line[cursor] == "\\":
                slashes += 1
                cursor -= 1
            if slashes % 2 == 0:
                cut = index
                break
        cleaned.append(line[:cut])
    return "\n".join(cleaned)


def _entrypoint(
    entries: Sequence[_TreeEntry],
    document_class_candidates: Sequence[str],
    *,
    slug: str,
    main_tex: str,
    limits: ArchiveLimits,
) -> tuple[str, str]:
    by_path = {entry.relative: entry for entry in entries}
    candidate_set = set(document_class_candidates)
    if main_tex:
        try:
            explicit = _portable_relative(
                main_tex,
                limits=limits,
                label="explicit LaTeX entrypoint",
            )
        except SourceMaterializationError as exc:
            raise LatexSourceError(str(exc)) from exc
        if explicit not in by_path or not explicit.casefold().endswith(".tex"):
            raise LatexSourceError(f"explicit LaTeX entrypoint is missing: {main_tex!r}")
        if explicit not in candidate_set:
            raise LatexSourceError(
                f"explicit LaTeX entrypoint has no document class declaration: {main_tex!r}"
            )
        return explicit, "explicit"

    candidates = sorted(
        document_class_candidates,
        key=lambda value: value.encode("utf-16-be", "surrogatepass"),
    )
    if not candidates:
        raise LatexSourceError("no LaTeX entrypoint with a document class declaration was found")
    if len(candidates) == 1:
        return candidates[0], "single-candidate"
    roots = [candidate for candidate in candidates if "/" not in candidate]
    if len(roots) == 1:
        return roots[0], "unique-root"
    preferred = ([f"{slug}.tex"] if slug else []) + ["main.tex"]
    for leaf in preferred:
        hits = [
            candidate
            for candidate in candidates
            if posixpath.basename(candidate).casefold() == leaf.casefold()
        ]
        if len(hits) == 1:
            return hits[0], f"preferred-name:{leaf}"
    raise LatexSourceError(
        "ambiguous LaTeX entrypoint; specify main_tex. Candidates: " + ", ".join(candidates)
    )


def _resolve_inputs(
    entrypoint: str,
    entries: Sequence[_TreeEntry],
    expected_digests: dict[str, str],
    *,
    limits: ArchiveLimits,
) -> tuple[str, dict[str, str], tuple[UnresolvedLatexInput, ...]]:
    by_path = {entry.relative: entry for entry in entries}
    digests: dict[str, str] = {}
    active: set[str] = set()
    unresolved: list[UnresolvedLatexInput] = []

    def get_text(relative: str) -> str:
        text, digest = _stable_read_text(by_path[relative], maximum=limits.max_tex_bytes)
        prior = expected_digests.get(relative, digests.get(relative))
        if prior is not None and prior != digest:
            raise LatexSourceError(f"LaTeX input changed during inspection: {relative!r}")
        digests[relative] = digest
        return text

    def pieces(relative: str, depth: int) -> Iterator[str]:
        if depth > limits.max_input_depth:
            raise LatexSourceError(
                f"LaTeX input nesting exceeds the depth limit of {limits.max_input_depth}: "
                f"{relative!r}"
            )
        key = relative.casefold()
        if key in active:
            raise LatexSourceError(f"cyclic LaTeX input detected at {relative!r}")
        active.add(key)
        try:
            text = _remove_line_comments(get_text(relative))
            cursor = 0
            for match in _INPUT_COMMAND.finditer(text):
                yield text[cursor : match.start()]
                command = match.group("command")
                captured = match.group("braced")
                literal = (captured if captured is not None else match.group("bare")).strip()
                name = literal
                while name.startswith("./"):
                    name = name[2:]
                try:
                    requested = _portable_relative(
                        name,
                        limits=limits,
                        label=f"LaTeX {command} target referenced by {relative!r}",
                    )
                except SourceMaterializationError as exc:
                    raise LatexSourceError(str(exc)) from exc
                candidates: list[str] = []
                for value in (requested, f"{requested}.tex"):
                    # TeX resolves ordinary literal inputs in the compile-root
                    # coordinate system; entering an input file does not change
                    # the compiler's working directory.
                    candidate = value
                    if candidate not in candidates:
                        candidates.append(candidate)
                selected = next(
                    (candidate for candidate in candidates if candidate in by_path),
                    None,
                )
                if selected is None:
                    selected = _unique_casefold_path(candidates, by_path)
                if selected is None:
                    unresolved.append(
                        UnresolvedLatexInput(
                            command=command,
                            literal=literal,
                            referenced_by=relative,
                        )
                    )
                    yield match.group(0)
                    cursor = match.end()
                    continue
                yield from pieces(selected, depth + 1)
                cursor = match.end()
            yield text[cursor:]
        finally:
            active.remove(key)

    output: list[str] = []
    total = 0
    for piece in pieces(entrypoint, 0):
        encoded = piece.encode("utf-8", "strict")
        if len(encoded) > limits.max_resolved_bytes - total:
            raise LatexSourceError(
                f"resolved LaTeX source exceeds the {limits.max_resolved_bytes}-byte boundary"
            )
        total += len(encoded)
        output.append(piece)
    return "".join(output), digests, tuple(unresolved)


def _unique_casefold_path(
    candidates: Sequence[str],
    by_path: dict[str, _TreeEntry],
) -> str | None:
    hits: list[str] = []
    seen: set[str] = set()
    inventory = list(by_path)
    for candidate in candidates:
        folded = candidate.casefold()
        matches = [path for path in inventory if path.casefold() == folded]
        if len(matches) != 1:
            continue
        path = matches[0]
        if path not in seen:
            hits.append(path)
            seen.add(path)
    if len(hits) == 1:
        return hits[0]
    return None


def _braced_content(text: str, open_brace: int) -> str | None:
    depth = 0
    for index in range(open_brace, len(text)):
        character = text[index]
        slashes = 0
        cursor = index - 1
        while cursor >= 0 and text[cursor] == "\\":
            slashes += 1
            cursor -= 1
        escaped = slashes % 2 == 1
        if not escaped and character == "{":
            depth += 1
        elif not escaped and character == "}":
            depth -= 1
            if depth == 0:
                return text[open_brace + 1 : index]
    return None


_TITLE_COMMANDS = ("title", "aistatstitle", "icmltitle")
_GENERIC_AUTHOR_COMMAND = "author"
_DOI_COMMANDS = ("doi", "DOI")
_DOI_URL_COMMANDS = ("href", "url")
_PLACEHOLDER_AUTHOR = re.compile(
    r"^(?:(?:first|second|third|fourth)\s+)?author(?:\s+name)?$",
    re.IGNORECASE,
)
_AISTATS_AUTHOR_SPLIT = re.compile(r"\\(?:And|AND|and)(?![A-Za-z])")
_JMLR_NAME = re.compile(
    r"\\name(?![A-Za-z])\s*(.*?)(?=\\(?:name|email|addr|AND|and)(?![A-Za-z])|\\\\|\Z)",
    re.DOTALL,
)
_DECLARED_DOI = re.compile(
    r"(?:https?://(?:dx\.)?doi\.org/|doi:\s*)?(10\.\d{4,9}/[^\s\\{}]+)",
    re.IGNORECASE,
)


def _command_values(text: str, command: str) -> tuple[str, ...]:
    pattern = re.compile(
        r"\\" + re.escape(command) + r"(?![A-Za-z])\s*(?:\[[^\]]*\]\s*)?\{"
    )
    values: list[str] = []
    for match in pattern.finditer(text):
        value = _braced_content(text, match.end() - 1)
        if value is not None and value.strip():
            values.append(value.strip())
    return tuple(values)


def _preamble(text: str) -> str:
    match = _DOCUMENT_MARKER.search(text)
    return text[: match.start()] if match else text


def _collapse_tex_line(value: str) -> str:
    return " ".join(value.replace("\r", " ").replace("\n", " ").split())


def _usable_author(value: str) -> bool:
    collapsed = _collapse_tex_line(value)
    if not collapsed or collapsed in {"~", "."}:
        return False
    if _PLACEHOLDER_AUTHOR.match(collapsed):
        return False
    if re.search(r"\bfirst author name\b", collapsed, flags=re.IGNORECASE):
        return False
    return True


def _split_aistats_authors(block: str) -> tuple[str, ...]:
    names: list[str] = []
    for part in _AISTATS_AUTHOR_SPLIT.split(block):
        head = re.split(r"\\\\", part, maxsplit=1)[0]
        collapsed = _collapse_tex_line(head)
        if _usable_author(collapsed):
            names.append(collapsed)
    return tuple(names)


def _jmlr_names(text: str) -> tuple[str, ...]:
    names: list[str] = []
    for match in _JMLR_NAME.finditer(text):
        collapsed = _collapse_tex_line(match.group(1))
        if _usable_author(collapsed):
            names.append(collapsed)
    return tuple(names)


def _normalize_declared_doi(value: str) -> str | None:
    match = _DECLARED_DOI.search(value.strip().rstrip(".,;"))
    if match is None:
        return None
    doi = match.group(1).rstrip(".,;")
    while doi.endswith("}"):
        doi = doi[:-1]
    return doi or None


def _declared_title(text: str) -> str | None:
    for command in _TITLE_COMMANDS:
        values = _command_values(text, command)
        if values:
            return values[0]
    return None


_ICML_CENTER_SPLIT = re.compile(r"(?:\\quad|\\\\)")


def _icml_center_authors(text: str) -> tuple[str, ...]:
    if not _command_values(text, "icmltitle"):
        return ()
    marker = "\\textbf{"
    start = text.find(marker)
    if start < 0:
        return ()
    block = _braced_content(text, start + len(marker) - 1)
    if block is None:
        return ()
    names: list[str] = []
    for part in _ICML_CENTER_SPLIT.split(block):
        collapsed = _collapse_tex_line(part)
        collapsed = re.sub(r"^\\textbf\{|\}$", "", collapsed).strip()
        collapsed = re.sub(r"\\vspace\s*\{[^}]*\}?\s*$", "", collapsed).strip()
        if _usable_author(collapsed) and "$^" in collapsed:
            names.append(collapsed)
    return tuple(names)


def _declared_authors(text: str) -> tuple[str, ...]:
    specialized: list[str] = []
    aistats = _command_values(text, "aistatsauthor")
    if aistats:
        specialized.extend(_split_aistats_authors(aistats[0]))
    specialized.extend(
        value
        for value in _command_values(text, "icmlauthor")
        if _usable_author(value)
    )
    specialized.extend(
        value
        for value in _command_values(text, "IEEEauthorblockN")
        if _usable_author(value)
    )
    specialized.extend(_jmlr_names(text))
    specialized.extend(_icml_center_authors(text))
    if specialized:
        return tuple(specialized)
    return tuple(
        value for value in _command_values(text, _GENERIC_AUTHOR_COMMAND) if _usable_author(value)
    )


def _declared_doi(text: str) -> str | None:
    for command in _DOI_COMMANDS:
        for value in _command_values(text, command):
            parsed = _normalize_declared_doi(value) or (
                value.strip() if value.strip().startswith("10.") else None
            )
            if parsed:
                return parsed
    preamble = _preamble(text)
    for command in _DOI_URL_COMMANDS:
        for value in _command_values(preamble, command):
            parsed = _normalize_declared_doi(value)
            if parsed:
                return parsed
    title = _declared_title(text)
    if title:
        parsed = _normalize_declared_doi(title)
        if parsed:
            return parsed
    return None


def _embedded_metadata(text: str) -> EmbeddedLatexMetadata:
    return EmbeddedLatexMetadata(
        title_tex=_declared_title(text),
        authors_tex=_declared_authors(text),
        doi=_declared_doi(text),
    )


class LatexSourceInspector:
    """Validate an extracted LaTeX tree and return its source-ready facts."""

    def __init__(self, limits: ArchiveLimits | None = None) -> None:
        self.limits = ArchiveLimits() if limits is None else limits
        if not isinstance(self.limits, ArchiveLimits):
            raise TypeError("limits must be an ArchiveLimits instance")

    def inspect(
        self,
        root_path: str | os.PathLike[str],
        *,
        slug: str | None = None,
        main_tex: str | None = None,
        publication_root: PinnedPublicationRoot | None = None,
    ) -> LatexSourceInspection:
        """Validate entrypoint, document marker, tree identity, and input closure."""

        if slug is not None and not isinstance(slug, str):
            raise LatexSourceError("slug must be a string or None")
        if main_tex is not None and not isinstance(main_tex, str):
            raise LatexSourceError("main_tex must be a string or None")
        if publication_root is None:
            try:
                root = _plain_directory(Path(root_path), label="LaTeX source root")
            except SourceMaterializationError as exc:
                raise LatexSourceError(str(exc)) from exc
            try:
                with PinnedPublicationRoot(str(root)) as retained:
                    return self.inspect(
                        root,
                        slug=slug,
                        main_tex=main_tex,
                        publication_root=retained,
                    )
            except LatexSourceError:
                raise
            except (OSError, PublicationError, RuntimeError, ValueError) as exc:
                raise LatexSourceError(
                    f"LaTeX source root could not be retained: '{root}'"
                ) from exc
        else:
            try:
                publication_root.assert_current()
            except RuntimeError as exc:
                raise LatexSourceError(
                    "LaTeX source root no longer names its retained directory"
                ) from exc
            root = Path(publication_root.path)
            if not _same_path(Path(root_path).absolute(), root.absolute()):
                raise LatexSourceError("LaTeX source root does not match its retained directory")
        selected_slug = slug or ""
        selected_main_tex = main_tex or ""
        if selected_slug and not _portable_leaf(selected_slug, limits=self.limits):
            raise LatexSourceError(f"slug is not a portable leaf: {selected_slug!r}")
        entries = _tree_inventory(
            root,
            limits=self.limits,
            publication_root=publication_root,
        )
        decoded_digests: dict[str, str] = {}
        document_class_candidates: list[str] = []
        for entry in entries:
            if entry.relative.casefold().endswith(".tex"):
                text, digest = _stable_read_text(entry, maximum=self.limits.max_tex_bytes)
                decoded_digests[entry.relative] = digest
                if _DOCUMENT_CLASS.search(_remove_line_comments(text)):
                    document_class_candidates.append(entry.relative)
        if not decoded_digests:
            raise LatexSourceError("source tree contains no .tex files")
        entrypoint, selection = _entrypoint(
            entries,
            document_class_candidates,
            slug=selected_slug,
            main_tex=selected_main_tex,
            limits=self.limits,
        )
        resolved, input_digests, unresolved_inputs = _resolve_inputs(
            entrypoint,
            entries,
            decoded_digests,
            limits=self.limits,
        )
        decoded_digests.update(input_digests)
        if not _DOCUMENT_MARKER.search(resolved):
            raise LatexSourceError(
                f"resolved LaTeX entrypoint has no document environment: {entrypoint!r}"
            )
        fingerprint = _fingerprint_inventory(
            root,
            entries,
            limits=self.limits,
            publication_root=publication_root,
        )
        by_path = {record.path: record for record in fingerprint.files}
        for relative, digest in decoded_digests.items():
            if by_path[relative].sha256 != digest:
                raise LatexSourceError(f"LaTeX input changed during inspection: {relative!r}")
        controls = tuple(
            record for record in fingerprint.files if record.path.casefold() == "00readme.json"
        )
        return LatexSourceInspection(
            root_path=str(root),
            entrypoint=entrypoint,
            entrypoint_selection=selection,
            file_count=fingerprint.count,
            tex_file_count=fingerprint.tex_count,
            tree_sha256=fingerprint.sha256,
            files=fingerprint.files,
            package_control_files=controls,
            embedded_metadata=_embedded_metadata(resolved),
            unresolved_inputs=unresolved_inputs,
        )


def inspect_latex_source_tree(
    root_path: str | os.PathLike[str],
    *,
    slug: str | None = None,
    main_tex: str | None = None,
    limits: ArchiveLimits | None = None,
) -> LatexSourceInspection:
    """Inspect one expanded LaTeX source tree."""

    return LatexSourceInspector(limits).inspect(root_path, slug=slug, main_tex=main_tex)


__all__ = [
    "EmbeddedLatexMetadata",
    "LatexSourceInspection",
    "LatexSourceInspector",
    "UnresolvedLatexInput",
    "inspect_latex_source_tree",
]
