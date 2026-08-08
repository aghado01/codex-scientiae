"""Byte-equality gate for JsonlEngine.

Every case here is a record set plus a declared text policy, frozen as committed bytes under
tests/fixtures/jsonl-engine/. The engine re-emits each case into a temporary directory and the
bytes must match exactly. This is what makes a change to the writer's internals reviewable: a
refactor that is meant to preserve output either does, or this says which case it broke.

Only the .jsonl is frozen. The .jidx and .sig carry mtime ticks and a timestamp, so they are not
reproducible by construction; their contents are checked structurally elsewhere.

To refresh the fixtures after a DELIBERATE format change:

    CODEX_REGEN_FIXTURES=1 .venv/Scripts/python.exe -m pytest tests/shared/test_byte_equality.py

then read the diff before committing it. A fixture that changes without a format decision behind it
is the failure this file exists to catch.

Goldens carry a .golden suffix and .gitattributes marks *.golden as -text. Without that the CRLF
case would be normalized to LF on commit and would silently test nothing. The suffix is what earns
the exemption, so it travels with the file rather than depending on where the file lives.
"""

import os
import shutil
import tempfile
import unittest

from jsonl_engine.engine import JsonlEngine
from jsonl_engine.policy import Codec, Eol
from jsonl_engine.reader import JsonlStore

FIXTURES = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "fixtures", "jsonl-engine"
)
REGEN = os.environ.get("CODEX_REGEN_FIXTURES") == "1"

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
    engine = JsonlEngine(
        output_path=out_path, codec=case["codec"], eol=case["eol"]
    )
    with engine:
        for record in case["records"]:
            engine.append(record)
        engine.commit(stage_metadata={"case": os.path.basename(out_path)})


class TestByteEquality(unittest.TestCase):
    """Frozen bytes per policy, plus the round-trip each policy must satisfy."""

    def _emit_to_tmp(self, name: str, case: dict, tmpdir: str) -> str:
        out_path = os.path.join(tmpdir, name + ".jsonl")
        emit(case, out_path)
        return out_path

    def test_cases_match_frozen_bytes(self):
        os.makedirs(FIXTURES, exist_ok=True)
        drift = []
        for name, case in CASES.items():
            with tempfile.TemporaryDirectory() as tmpdir:
                produced = self._emit_to_tmp(name, case, tmpdir)
                with open(produced, "rb") as handle:
                    actual = handle.read()

                golden = os.path.join(FIXTURES, name + ".jsonl.golden")
                if REGEN or not os.path.exists(golden):
                    shutil.copyfile(produced, golden)
                    continue

                with open(golden, "rb") as handle:
                    expected = handle.read()
                if actual != expected:
                    at = next(
                        (i for i in range(min(len(actual), len(expected)))
                         if actual[i] != expected[i]),
                        min(len(actual), len(expected)),
                    )
                    drift.append(
                        f"{name}: differs at byte {at}\n"
                        f"    frozen:   {expected[max(0, at - 30):at + 40]!r}\n"
                        f"    produced: {actual[max(0, at - 30):at + 40]!r}"
                    )

        if REGEN:
            self.skipTest("fixtures regenerated; review the diff before committing")
        self.assertEqual([], drift, "writer output drifted from frozen bytes:\n" + "\n".join(drift))

    def test_cases_round_trip_through_the_reader(self):
        """Records survive write and read unchanged under every declared policy."""
        for name, case in CASES.items():
            with self.subTest(case=name), tempfile.TemporaryDirectory() as tmpdir:
                out_path = self._emit_to_tmp(name, case, tmpdir)
                store = JsonlStore(out_path, eol=case["eol"])
                self.assertEqual(case["records"], list(store))
                self.assertEqual(len(case["records"]), len(store))
                self.assertEqual(case["records"][-1], store[-1])
                self.assertTrue(store.verify())

    def test_sig_records_the_policy_that_produced_the_bytes(self):
        for name, case in CASES.items():
            with self.subTest(case=name), tempfile.TemporaryDirectory() as tmpdir:
                out_path = self._emit_to_tmp(name, case, tmpdir)
                sig = JsonlStore(out_path, eol=case["eol"]).read_sig()
                self.assertEqual(case["codec"].value, sig["codec"])
                self.assertEqual(case["eol"].value, sig["eol"])
                self.assertEqual("utf-8", sig["encoding"])

    def test_reading_under_the_wrong_terminator_is_named_not_guessed(self):
        """A CRLF store read as LF reports the policy, not a parse failure downstream."""
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = self._emit_to_tmp("plain-crlf", CASES["plain-crlf"], tmpdir)
            with self.assertRaises(ValueError) as caught:
                list(JsonlStore(out_path, eol=Eol.LF))
            self.assertIn("CR", str(caught.exception))

            with self.assertRaises(ValueError) as caught:
                JsonlStore(out_path, eol=Eol.LF).verify()
            self.assertIn("Policy disagreement", str(caught.exception))

    def test_every_index_offset_lands_on_a_record_start_byte(self):
        """Ported from the PowerShell glyph gauntlet, whose subject is retired.

        The invariant is the engine's, not that lane's: offsets are captured from a byte position
        while records are serialized as text, so an off-by-one under multibyte content would seek
        into the middle of a character and only surface as a decode error much later.
        """
        for name, case in CASES.items():
            with self.subTest(case=name), tempfile.TemporaryDirectory() as tmpdir:
                out_path = self._emit_to_tmp(name, case, tmpdir)
                store = JsonlStore(out_path, eol=case["eol"])
                with open(out_path, "rb") as handle:
                    raw = handle.read()

                terminator = case["eol"].terminator("utf-8")
                starts = {0}
                position = raw.find(terminator)
                while position != -1 and position + len(terminator) < len(raw):
                    starts.add(position + len(terminator))
                    position = raw.find(terminator, position + len(terminator))

                self.assertEqual(starts, set(store.index.offsets))
                # And each offset decodes from that byte, rather than mid-character.
                for record, offset in enumerate(store.index.offsets):
                    self.assertEqual(case["records"][record], store[record])
                    self.assertNotEqual(b"", raw[offset:offset + 1])

    def test_writing_the_same_records_twice_yields_the_same_offsets(self):
        """The .jidx carries mtime ticks so it is not byte-identical across writes; the offsets
        it describes must be, or the store is not deterministic in the way its hash claims."""
        for name, case in CASES.items():
            with self.subTest(case=name):
                with tempfile.TemporaryDirectory() as d1, tempfile.TemporaryDirectory() as d2:
                    first = JsonlStore(self._emit_to_tmp(name, case, d1), eol=case["eol"])
                    second = JsonlStore(self._emit_to_tmp(name, case, d2), eol=case["eol"])
                    self.assertEqual(first.index.offsets, second.index.offsets)

    def test_utf16_is_refused_for_line_framed_stores(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, "x.jsonl")
            with self.assertRaises(ValueError) as caught:
                JsonlStore(out_path, encoding="utf-16-le")
            self.assertIn("frame JSONL records", str(caught.exception))


if __name__ == "__main__":
    unittest.main()
