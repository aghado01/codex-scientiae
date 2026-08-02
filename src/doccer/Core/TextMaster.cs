using System;
using System.Runtime.InteropServices;
using System.Security.Cryptography;

namespace CodexSci.Doccer;

/// <summary>An immutable text snapshot and the identity of its coordinate space.</summary>
public sealed class TextMaster
{
    private readonly Lazy<string> _fingerprint;

    private readonly Lazy<TextTopology> _topology;

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
        // Both computed on first use: construction cost must scale with what a job touches,
        // so interval algebra over a master never pays for hashing or the scalar tiling.
        // Hash the raw UTF-16 code units. An encoder would route lone surrogates through its
        // replacement fallback (every unpaired surrogate becomes U+FFFD), collapsing masters the
        // topology distinguishes as first-class atoms. Identity must distinguish everything the
        // topology distinguishes. The bytes are host-endian; if fingerprints ever persist
        // cross-platform, endianness must be fixed explicitly.
        _fingerprint = new Lazy<string>(
            () => Convert.ToHexString(SHA256.HashData(MemoryMarshal.AsBytes(text.AsSpan()))));
        _topology = new Lazy<TextTopology>(() => TextTopology.Build(text));
    }

    public string DocumentId { get; }

    public long Revision { get; }

    public string Text { get; }

    public string Fingerprint => _fingerprint.Value;

    public AddressUnit AddressUnit => AddressUnit.Utf16CodeUnit;

    public int Length => Text.Length;

    public TextSpan Extent => new(0, Length);

    public TextTopology Topology => _topology.Value;

    internal bool FingerprintIsCreated => _fingerprint.IsValueCreated;

    internal bool TopologyIsCreated => _topology.IsValueCreated;

    public static TextMaster Create(string text, string? documentId = null, long revision = 0) =>
        new(documentId ?? Guid.NewGuid().ToString("N"), revision, text);

    public bool IsCompatibleWith(TextMaster? other) =>
        // Same instance is trivially the same coordinate space; short-circuiting here keeps
        // same-master span algebra from ever forcing the fingerprint.
        ReferenceEquals(this, other) ||
        (other is not null &&
        Revision == other.Revision &&
        AddressUnit == other.AddressUnit &&
        Length == other.Length &&
        StringComparer.Ordinal.Equals(DocumentId, other.DocumentId) &&
        StringComparer.Ordinal.Equals(Fingerprint, other.Fingerprint));

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
