"""The three text-policy axes of a JSON or JSONL artifact.

Each is declared, never sniffed and never inherited from the host. They are orthogonal: a UTF-16
file can hold ASCII-escaped JSON terminated by CRLF.

    encoding   bytes <-> text            DEFAULT_ENCODING, a codec name
    Codec      text <-> JSON string      escaping policy
    Eol        record terminator         JSONL only

A kind declares all three as class attributes and the .sig records them, so a store carries its own
policy. An ad-hoc store with no kind takes them as call arguments under the same defaults.

The operating system contributes nothing: every handle in this package is opened in binary mode, so
universal-newline translation and locale-default encodings are excluded by construction rather than
configured away. .gitattributes governs bytes in the repository for tracked files and is never read
at runtime.

Leaf module: stdlib only, no package imports.
"""

from __future__ import annotations

from enum import Enum

# Applied when nothing else is declared. A default, not an invariant -- a caller reading foreign
# input states what that input is, and PowerShell-produced text is commonly utf-16-le.
DEFAULT_ENCODING = "utf-8"


class Codec(Enum):
    """Escaping policy for text with no plain form in the artifact's encoding.

    UNICODE  ensure_ascii=False. Non-ASCII is written as-is. An unpaired surrogate has no UTF-8
             encoding and raises at write time. Default.

    ASCII    ensure_ascii=True. Non-ASCII is written as \\uXXXX, a UTF-16 code unit, so an unpaired
             surrogate round-trips. For extracted text, where a PDF font CMap can yield code units
             that are not scalar values. Costs roughly 1.2x on multilingual prose.

    Substitution is not offered. Separators and key order are fixed in JsonlEngine.append() and are
    not part of this choice.
    """

    UNICODE = "unicode"
    ASCII = "ascii"

    @property
    def ensure_ascii(self) -> bool:
        return self is Codec.ASCII


class Eol(Enum):
    """Record terminator for a JSONL store.

    LF is the default posture for everything this engine writes: it is what the JSONL convention
    assumes, it keeps byte offsets one-to-one with a line's payload plus one, and it is stable
    across the platforms this repository runs on.

    CRLF exists because ad-hoc stores produced by other tooling carry it, and refusing to read them
    would be a policy decision disguised as a parse error. Declaring CRLF does not make it
    preferred; it makes it stated.

    A declared terminator is enforced, not merely tolerated. A store declared LF that contains CR
    is an error rather than a value to be silently repaired.
    """

    LF = "lf"
    CRLF = "crlf"

    @property
    def text(self) -> str:
        return "\r\n" if self is Eol.CRLF else "\n"

    def terminator(self, encoding: str = DEFAULT_ENCODING) -> bytes:
        """The terminator as bytes under `encoding`.

        Encoded rather than returned as a literal: under utf-16-le a newline is b"\\n\\x00", so a
        raw b"\\n" would be a half character. The two knobs compose; neither may assume the other.
        """
        return self.text.encode(encoding)
