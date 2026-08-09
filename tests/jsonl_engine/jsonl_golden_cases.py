"""Shared byte-policy cases for JSONL golden verification and maintenance."""

from __future__ import annotations

import os

from jsonl_engine.engine import JsonlEngine
from jsonl_engine.policy import Codec, Eol


GOLDEN_DIR = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "fixtures",
    "jsonl_engine",
)

# A lone high surrogate: no UTF-8 form, so it exists only to exercise Codec.ASCII. This is the case
# Codec.ASCII was introduced for -- a PDF font CMap yielding code units that are not scalar values.
LONE_SURROGATE = "cap: \ud800 end"

CASES = {
    "plain-lf": {
        "records": [
            {"kind": "block", "page": 1, "bbox": [72.0, 96.5, 540.0, 120.25]},
            {"kind": "block", "page": 1, "text": "The quick brown fox.", "rule": None},
            {"kind": "block", "page": 2, "nested": {"a": [1, 2, 3], "b": {"c": True}}},
        ],
        "codec": Codec.UNICODE,
        "eol": Eol.LF,
    },
    "unicode-lf": {
        "records": [
            {"math": "∫ f(x) dx = 𝔼[X]", "set": "𝕊¹", "lig": "ﬁﬂﬃ"},
            {"greek": "αβγδε", "cjk": "日本語", "emoji": "🜲", "sentinel": "�"},
        ],
        "codec": Codec.UNICODE,
        "eol": Eol.LF,
    },
    "unicode-ascii-escaped": {
        # Same records as unicode-lf under the other escaping policy. Byte-different by design;
        # freezing both is what proves the codec is a knob rather than an accident.
        "records": [
            {"math": "∫ f(x) dx = 𝔼[X]", "set": "𝕊¹", "lig": "ﬁﬂﬃ"},
            {"greek": "αβγδε", "cjk": "日本語", "emoji": "🜲", "sentinel": "�"},
        ],
        "codec": Codec.ASCII,
        "eol": Eol.LF,
    },
    "surrogate-ascii": {
        "records": [
            {"extracted": LONE_SURROGATE, "page": 3},
            {"extracted": "ordinary text", "page": 4},
        ],
        "codec": Codec.ASCII,
        "eol": Eol.LF,
    },
    "plain-crlf": {
        # Same records as plain-lf. Two bytes per terminator, so this also pins that .jidx offsets
        # follow the declared terminator width rather than assuming one.
        "records": [
            {"kind": "block", "page": 1, "bbox": [72.0, 96.5, 540.0, 120.25]},
            {"kind": "block", "page": 1, "text": "The quick brown fox.", "rule": None},
            {"kind": "block", "page": 2, "nested": {"a": [1, 2, 3], "b": {"c": True}}},
        ],
        "codec": Codec.UNICODE,
        "eol": Eol.CRLF,
    },
}


def emit(case: dict, out_path: str) -> None:
    """Write one case's records under its declared policy."""
    engine = JsonlEngine(output_path=out_path, codec=case["codec"], eol=case["eol"])
    with engine:
        for record in case["records"]:
            engine.append(record)
        engine.commit(stage_metadata={"case": os.path.basename(out_path)})
