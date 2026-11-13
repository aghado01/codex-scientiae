"""Inline-image controls for the pypdf content-stream backend."""

from io import BytesIO
import zlib

import pytest


@pytest.mark.parametrize("compressed", [False, True], ids=["unfiltered", "flate"])
def test_inline_image_keeps_binary_payload_and_following_text(compressed):
    pypdf = pytest.importorskip("pypdf", reason="the PDF reader backend requires pypdf")
    from pypdf.generic import (
        ContentStream,
        DecodedStreamObject,
        DictionaryObject,
        NameObject,
    )

    # The first four pixel bytes look like a delimited end-of-image operator.
    pixels = b" EI \x00("
    payload = zlib.compress(pixels, level=0) if compressed else pixels
    filter_spec = b" /F /FlateDecode" if compressed else b""
    instructions = (
        b"q BI /W 2 /H 1 /BPC 8 /CS /RGB" + filter_spec + b" ID "
        + payload + b" EI Q BT /F1 10 Tf (AFTER) Tj ET"
    )

    writer = pypdf.PdfWriter()
    page = writer.add_blank_page(width=180, height=180)
    font = DictionaryObject({
        NameObject("/Type"): NameObject("/Font"),
        NameObject("/Subtype"): NameObject("/Type1"),
        NameObject("/BaseFont"): NameObject("/Helvetica"),
    })
    page[NameObject("/Resources")] = DictionaryObject({
        NameObject("/Font"): DictionaryObject({NameObject("/F1"): font}),
    })
    stream = DecodedStreamObject()
    stream.set_data(instructions)
    page.replace_contents(stream)
    buffer = BytesIO()
    writer.write(buffer)
    buffer.seek(0)

    reader = pypdf.PdfReader(buffer)
    operations = ContentStream(reader.pages[0].get_contents(), reader).operations
    assert [operator for _, operator in operations] == [
        b"q", b"INLINE IMAGE", b"Q", b"BT", b"Tf", b"Tj", b"ET",
    ]
    image = operations[1][0]["data"]
    if compressed:
        # pypdf can include the whitespace separator before the real EI.
        assert image in (payload, payload + b" ")
        assert zlib.decompress(image) == pixels
    else:
        assert image == pixels
    assert operations[5][0][0].original_bytes == b"AFTER"
