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
/// The seven UCD major category classes (L, M, N, P, S, Z, C). A mechanical fold over
/// <see cref="UnicodeCategory"/> — no data table and no version stamp of its own, unlike the block
/// and script properties, which would ship as versioned UCD data.
/// </summary>
public enum UnicodeCategoryClass
{
    Letter,
    Mark,
    Number,
    Punctuation,
    Symbol,
    Separator,
    Other,
}

/// <summary>
/// A maximal consecutive atom range whose atoms all yield one break-key value. A run carries its
/// span, the key it broke on, and how many atoms it covers — nothing else. There is deliberately no
/// intrinsic "run category": a run keyed on something other than category has no single category,
/// which is exactly why the key travels with the run instead of a fixed type field.
/// </summary>
public readonly record struct AtomRun<TKey>(TextSpan Span, TKey Key, int AtomCount);

/// <summary>
/// Break-key selectors over the facts an atom actually carries. Each is a plain
/// <c>TextAtom -> key</c> function, so <see cref="TextTopology.EmitRuns"/> accepts these and any
/// caller-supplied selector on the same footing. Compose facts by returning a tuple —
/// <c>atom =&gt; (atom.LineIndex, AtomFacts.CategoryClass(atom))</c> breaks on both, and the run
/// reports both values.
/// </summary>
public static class AtomFacts
{
    /// <summary>Breaks on the exact Unicode general category (Lu and Ll are different keys).</summary>
    public static Func<TextAtom, UnicodeCategory> Category { get; } = static atom => atom.Category;

    /// <summary>Breaks on the UCD major class (Lu and Ll are both <c>Letter</c>).</summary>
    public static Func<TextAtom, UnicodeCategoryClass> CategoryClass { get; } =
        static atom => Classify(atom.Category);

    /// <summary>Breaks between well-formed scalars and preserved unpaired surrogates.</summary>
    public static Func<TextAtom, bool> IsValidScalar { get; } = static atom => atom.IsValidScalar;

    /// <summary>Breaks at line boundaries; the resulting runs are the line extents.</summary>
    public static Func<TextAtom, int> LineIndex { get; } = static atom => atom.LineIndex;

    /// <summary>Folds a general category onto its UCD major class.</summary>
    public static UnicodeCategoryClass Classify(UnicodeCategory category) => category switch
    {
        UnicodeCategory.UppercaseLetter or
        UnicodeCategory.LowercaseLetter or
        UnicodeCategory.TitlecaseLetter or
        UnicodeCategory.ModifierLetter or
        UnicodeCategory.OtherLetter => UnicodeCategoryClass.Letter,

        UnicodeCategory.NonSpacingMark or
        UnicodeCategory.SpacingCombiningMark or
        UnicodeCategory.EnclosingMark => UnicodeCategoryClass.Mark,

        UnicodeCategory.DecimalDigitNumber or
        UnicodeCategory.LetterNumber or
        UnicodeCategory.OtherNumber => UnicodeCategoryClass.Number,

        UnicodeCategory.ConnectorPunctuation or
        UnicodeCategory.DashPunctuation or
        UnicodeCategory.OpenPunctuation or
        UnicodeCategory.ClosePunctuation or
        UnicodeCategory.InitialQuotePunctuation or
        UnicodeCategory.FinalQuotePunctuation or
        UnicodeCategory.OtherPunctuation => UnicodeCategoryClass.Punctuation,

        UnicodeCategory.MathSymbol or
        UnicodeCategory.CurrencySymbol or
        UnicodeCategory.ModifierSymbol or
        UnicodeCategory.OtherSymbol => UnicodeCategoryClass.Symbol,

        UnicodeCategory.SpaceSeparator or
        UnicodeCategory.LineSeparator or
        UnicodeCategory.ParagraphSeparator => UnicodeCategoryClass.Separator,

        UnicodeCategory.Control or
        UnicodeCategory.Format or
        UnicodeCategory.Surrogate or
        UnicodeCategory.PrivateUse or
        UnicodeCategory.OtherNotAssigned => UnicodeCategoryClass.Other,

        _ => throw new ArgumentOutOfRangeException(nameof(category)),
    };
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
    /// Emits the maximal atom runs agreeing on an explicit break-key. The key is the whole of the
    /// caller's typing decision: the tiling itself carries facts only, and any coarser grouping —
    /// word-like versus space-like, letters versus everything else, per line — is this view, chosen
    /// per call rather than baked into the atoms. <see cref="AtomFacts"/> holds the built-in
    /// selectors; a tuple-returning selector breaks on several facts at once.
    /// </summary>
    /// <remarks>
    /// Computed on demand, never cached and never constructor work: a job that wants no runs pays
    /// for none. The result tiles the master exactly — run spans are contiguous from 0 to
    /// <see cref="TextLength"/>, and the atom counts sum to <see cref="AtomCount"/>.
    /// </remarks>
    public IReadOnlyList<AtomRun<TKey>> EmitRuns<TKey>(
        Func<TextAtom, TKey> breakKey,
        IEqualityComparer<TKey>? comparer = null)
    {
        ArgumentNullException.ThrowIfNull(breakKey);
        if (_atoms.Length == 0)
        {
            return Array.Empty<AtomRun<TKey>>();
        }

        var equality = comparer ?? EqualityComparer<TKey>.Default;
        var runs = new List<AtomRun<TKey>>();
        var currentKey = breakKey(_atoms[0]);
        var start = _atoms[0].Span.Start;
        var end = _atoms[0].Span.End;
        var count = 1;
        for (var i = 1; i < _atoms.Length; i++)
        {
            // One key evaluation per atom: the selector is caller code and may be arbitrarily
            // expensive, so a boundary must not re-evaluate the atom that ended the previous run.
            var key = breakKey(_atoms[i]);
            if (equality.Equals(key, currentKey))
            {
                end = _atoms[i].Span.End;
                count++;
                continue;
            }

            runs.Add(new AtomRun<TKey>(new TextSpan(start, end), currentKey, count));
            currentKey = key;
            start = _atoms[i].Span.Start;
            end = _atoms[i].Span.End;
            count = 1;
        }

        runs.Add(new AtomRun<TKey>(new TextSpan(start, end), currentKey, count));
        return runs.AsReadOnly();
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
