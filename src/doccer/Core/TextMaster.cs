using System;
using System.Security.Cryptography;
using System.Text;

namespace CodexSci.Doccer;

/// <summary>An immutable text snapshot and the identity of its coordinate space.</summary>
public sealed class TextMaster
{
    public TextMaster(string documentId, long revision, string text)
    {
        if (string.IsNullOrWhiteSpace(documentId))
        {
            throw new ArgumentException("A document identity is required.", nameof(documentId));
        }

        if (revision < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(revision));
        }

        ArgumentNullException.ThrowIfNull(text);

        DocumentId = documentId;
        Revision = revision;
        Text = text;
        Fingerprint = Convert.ToHexString(SHA256.HashData(Encoding.Unicode.GetBytes(text)));
        Topology = TextTopology.Build(text);
    }

    public string DocumentId { get; }

    public long Revision { get; }

    public string Text { get; }

    public string Fingerprint { get; }

    public AddressUnit AddressUnit => AddressUnit.Utf16CodeUnit;

    public int Length => Text.Length;

    public TextSpan Extent => new(0, Length);

    public TextTopology Topology { get; }

    public static TextMaster Create(string text, string? documentId = null, long revision = 0) =>
        new(documentId ?? Guid.NewGuid().ToString("N"), revision, text);

    public bool IsCompatibleWith(TextMaster? other) =>
        other is not null &&
        Revision == other.Revision &&
        AddressUnit == other.AddressUnit &&
        Length == other.Length &&
        StringComparer.Ordinal.Equals(DocumentId, other.DocumentId) &&
        StringComparer.Ordinal.Equals(Fingerprint, other.Fingerprint);

    public void EnsureCompatibleWith(TextMaster other)
    {
        ArgumentNullException.ThrowIfNull(other);
        if (!IsCompatibleWith(other))
        {
            throw new InvalidOperationException(
                $"Coordinate spaces are incompatible: '{DocumentId}' r{Revision} and " +
                $"'{other.DocumentId}' r{other.Revision}.");
        }
    }

    public void ValidateSpan(TextSpan span, bool allowEmpty = true)
    {
        if (span.End > Length)
        {
            throw new ArgumentOutOfRangeException(nameof(span), $"Span {span} exceeds master length {Length}.");
        }

        if (!allowEmpty && span.IsEmpty)
        {
            throw new ArgumentException("The span must not be empty.", nameof(span));
        }

        if (!IsScalarBoundary(span.Start) || !IsScalarBoundary(span.End))
        {
            throw new ArgumentException($"Span {span} splits a UTF-16 surrogate pair.", nameof(span));
        }
    }

    public bool IsScalarBoundary(int offset)
    {
        if ((uint)offset > (uint)Length)
        {
            return false;
        }

        return offset == 0 ||
               offset == Length ||
               !(char.IsHighSurrogate(Text[offset - 1]) && char.IsLowSurrogate(Text[offset]));
    }

    public string Slice(TextSpan span)
    {
        ValidateSpan(span);
        return Text.Substring(span.Start, span.Length);
    }

    public TextSpan GetLineSpan(int lineIndex, bool includeLineBreak = true)
    {
        var span = Topology.GetLineExtent(lineIndex);
        if (includeLineBreak || span.IsEmpty)
        {
            return span;
        }

        var end = span.End;
        if (end > span.Start && Text[end - 1] == '\n')
        {
            end--;
            if (end > span.Start && Text[end - 1] == '\r')
            {
                end--;
            }
        }
        else if (end > span.Start && Text[end - 1] is '\r' or '\u0085' or '\u2028' or '\u2029')
        {
            end--;
        }

        return new TextSpan(span.Start, end);
    }
}
