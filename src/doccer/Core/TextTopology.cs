using System;
using System.Buffers;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Text;

namespace CodexSci.Doccer;

/// <summary>Address unit used by a <see cref="TextMaster"/>.</summary>
public enum AddressUnit
{
    Utf16CodeUnit = 0,
}

/// <summary>One Unicode scalar, or one preserved unpaired UTF-16 surrogate, in the total text tiling.</summary>
public readonly record struct TextAtom(
    TextSpan Span,
    int Value,
    UnicodeCategory Category,
    bool IsValidScalar,
    int LineIndex);

/// <summary>A half-open line-index interval.</summary>
public readonly record struct LineRange(int Start, int End)
{
    public int Count => End - Start;
}

/// <summary>
/// Complete Unicode-scalar tiling and line topology produced by a single pass over a master string.
/// </summary>
public sealed class TextTopology
{
    private readonly int[] _lineStarts;
    private readonly TextAtom[] _atoms;
    private readonly ReadOnlyCollection<int> _lineStartsView;
    private readonly ReadOnlyCollection<TextAtom> _atomsView;

    private TextTopology(int textLength, int[] lineStarts, TextAtom[] atoms)
    {
        TextLength = textLength;
        _lineStarts = lineStarts;
        _atoms = atoms;
        _lineStartsView = Array.AsReadOnly(_lineStarts);
        _atomsView = Array.AsReadOnly(_atoms);
    }

    public int TextLength { get; }

    public int LineCount => _lineStarts.Length;

    public int AtomCount => _atoms.Length;

    public IReadOnlyList<int> LineStarts => _lineStartsView;

    public IReadOnlyList<TextAtom> Atoms => _atomsView;

    internal static TextTopology Build(string text)
    {
        ArgumentNullException.ThrowIfNull(text);

        var lineStarts = new List<int> { 0 };
        var atoms = new List<TextAtom>(text.Length);
        var lineIndex = 0;
        var offset = 0;
        while (offset < text.Length)
        {
            var atomStart = offset;
            var status = Rune.DecodeFromUtf16(text.AsSpan(offset), out var rune, out var consumed);
            if (status == OperationStatus.Done)
            {
                atoms.Add(new TextAtom(
                    TextSpan.FromStartLength(offset, consumed),
                    rune.Value,
                    Rune.GetUnicodeCategory(rune),
                    true,
                    lineIndex));
                offset += consumed;
            }
            else
            {
                // .NET strings may contain unpaired surrogates. Preserve the code unit so the
                // topology remains total and let validation/reporting distinguish it explicitly.
                atoms.Add(new TextAtom(
                    TextSpan.FromStartLength(offset, 1),
                    text[offset],
                    UnicodeCategory.Surrogate,
                    false,
                    lineIndex));
                offset++;
            }

            var atomValue = text[atomStart];
            var terminatesLine = atomValue is '\n' or '\u0085' or '\u2028' or '\u2029' ||
                                 (atomValue == '\r' &&
                                  (offset >= text.Length || text[offset] != '\n'));
            if (terminatesLine)
            {
                lineStarts.Add(offset);
                lineIndex++;
            }
        }

        return new TextTopology(text.Length, lineStarts.ToArray(), atoms.ToArray());
    }

    public int GetLineIndex(int offset)
    {
        if ((uint)offset > (uint)TextLength)
        {
            throw new ArgumentOutOfRangeException(nameof(offset));
        }

        var index = Array.BinarySearch(_lineStarts, offset);
        if (index >= 0)
        {
            return index;
        }

        return ~index - 1;
    }

    public TextSpan GetLineExtent(int lineIndex)
    {
        if ((uint)lineIndex >= (uint)_lineStarts.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(lineIndex));
        }

        var start = _lineStarts[lineIndex];
        var end = lineIndex + 1 < _lineStarts.Length ? _lineStarts[lineIndex + 1] : TextLength;
        return new TextSpan(start, end);
    }

    /// <summary>
    /// Projects a character span onto the half-open range of lines it intersects.
    /// Empty-span convention (deliberate, part of the contract): an empty span projects to the
    /// one-line range containing its position, never to an empty range. A position always lies on
    /// exactly one line, and callers projecting insertion points need that line identified; an
    /// empty answer would discard the only information the position carries.
    /// </summary>
    public LineRange Project(TextSpan span)
    {
        if (span.End > TextLength)
        {
            throw new ArgumentOutOfRangeException(nameof(span));
        }

        var first = GetLineIndex(span.Start);
        if (span.IsEmpty)
        {
            return new LineRange(first, first + 1);
        }

        var last = GetLineIndex(span.End - 1);
        return new LineRange(first, last + 1);
    }
}
