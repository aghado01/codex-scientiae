using System;
using System.Collections;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>
/// A normalized Boolean interval set over one immutable master. Unlike a SpanBatch, it deliberately
/// forgets claim identity and is therefore suitable for mask-like inclusion/exclusion operations.
/// </summary>
public sealed class SpanSet : IReadOnlyList<TextSpan>, IEquatable<SpanSet>
{
    private readonly TextSpan[] _spans;

    private SpanSet(TextMaster master, TextSpan[] normalized)
    {
        Master = master;
        _spans = normalized;
    }

    public TextMaster Master { get; }

    public int Count => _spans.Length;

    public TextSpan this[int index] => _spans[index];

    public long Coverage
    {
        get
        {
            long coverage = 0;
            foreach (var span in _spans)
            {
                coverage += span.Length;
            }

            return coverage;
        }
    }

    public static SpanSet Empty(TextMaster master) =>
        new(master ?? throw new ArgumentNullException(nameof(master)), Array.Empty<TextSpan>());

    public static SpanSet Whole(TextMaster master)
    {
        ArgumentNullException.ThrowIfNull(master);
        return master.Length == 0 ? Empty(master) : new SpanSet(master, new[] { master.Extent });
    }

    public static SpanSet Create(TextMaster master, IEnumerable<TextSpan> spans)
    {
        ArgumentNullException.ThrowIfNull(master);
        ArgumentNullException.ThrowIfNull(spans);
        return new SpanSet(master, Normalize(master, spans));
    }

    public static SpanSet FromClaims(SpanBatch batch, Func<SpanRecord, bool>? predicate = null)
    {
        ArgumentNullException.ThrowIfNull(batch);
        var spans = new List<TextSpan>();
        foreach (var record in batch)
        {
            if (predicate is null || predicate(record))
            {
                spans.Add(record.Span);
            }
        }

        return Create(batch.Master, spans);
    }

    public SpanSet Union(SpanSet other)
    {
        EnsureCompatible(other);
        var combined = new TextSpan[Count + other.Count];
        Array.Copy(_spans, combined, Count);
        Array.Copy(other._spans, 0, combined, Count, other.Count);
        return Create(Master, combined);
    }

    public SpanSet Intersect(SpanSet other)
    {
        EnsureCompatible(other);
        var result = new List<TextSpan>();
        var left = 0;
        var right = 0;
        while (left < Count && right < other.Count)
        {
            var a = _spans[left];
            var b = other._spans[right];
            var start = Math.Max(a.Start, b.Start);
            var end = Math.Min(a.End, b.End);
            if (start < end)
            {
                result.Add(new TextSpan(start, end));
            }

            if (a.End < b.End)
            {
                left++;
            }
            else
            {
                right++;
            }
        }

        return new SpanSet(Master, result.ToArray());
    }

    public SpanSet Subtract(SpanSet other)
    {
        EnsureCompatible(other);
        var result = new List<TextSpan>();
        var right = 0;
        foreach (var source in _spans)
        {
            var cursor = source.Start;
            while (right < other.Count && other[right].End <= cursor)
            {
                right++;
            }

            var scan = right;
            while (scan < other.Count && other[scan].Start < source.End)
            {
                var cut = other[scan];
                if (cut.Start > cursor)
                {
                    result.Add(new TextSpan(cursor, Math.Min(cut.Start, source.End)));
                }

                cursor = Math.Max(cursor, cut.End);
                if (cursor >= source.End)
                {
                    break;
                }

                scan++;
            }

            if (cursor < source.End)
            {
                result.Add(new TextSpan(cursor, source.End));
            }
        }

        return new SpanSet(Master, result.ToArray());
    }

    public SpanSet Complement() => Whole(Master).Subtract(this);

    public bool Contains(int offset)
    {
        if ((uint)offset >= (uint)Master.Length)
        {
            return false;
        }

        var low = 0;
        var high = Count - 1;
        while (low <= high)
        {
            var middle = low + ((high - low) / 2);
            var span = _spans[middle];
            if (offset < span.Start)
            {
                high = middle - 1;
            }
            else if (offset >= span.End)
            {
                low = middle + 1;
            }
            else
            {
                return true;
            }
        }

        return false;
    }

    public bool Equals(SpanSet? other)
    {
        if (other is null || !Master.IsCompatibleWith(other.Master) || Count != other.Count)
        {
            return false;
        }

        for (var i = 0; i < Count; i++)
        {
            if (_spans[i] != other._spans[i])
            {
                return false;
            }
        }

        return true;
    }

    public override bool Equals(object? obj) => obj is SpanSet other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Master.DocumentId, StringComparer.Ordinal);
        hash.Add(Master.Revision);
        hash.Add(Master.Fingerprint, StringComparer.Ordinal);
        foreach (var span in _spans)
        {
            hash.Add(span);
        }

        return hash.ToHashCode();
    }

    public IEnumerator<TextSpan> GetEnumerator() => ((IEnumerable<TextSpan>)_spans).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => _spans.GetEnumerator();

    private void EnsureCompatible(SpanSet other)
    {
        ArgumentNullException.ThrowIfNull(other);
        Master.EnsureCompatibleWith(other.Master);
    }

    private static TextSpan[] Normalize(TextMaster master, IEnumerable<TextSpan> spans)
    {
        var ordered = new List<TextSpan>();
        foreach (var span in spans)
        {
            master.ValidateSpan(span);
            if (!span.IsEmpty)
            {
                ordered.Add(span);
            }
        }

        ordered.Sort(static (left, right) =>
        {
            var comparison = left.Start.CompareTo(right.Start);
            return comparison != 0 ? comparison : left.End.CompareTo(right.End);
        });

        if (ordered.Count == 0)
        {
            return Array.Empty<TextSpan>();
        }

        var normalized = new List<TextSpan>(ordered.Count);
        var current = ordered[0];
        for (var i = 1; i < ordered.Count; i++)
        {
            var next = ordered[i];
            if (next.Start <= current.End)
            {
                current = new TextSpan(current.Start, Math.Max(current.End, next.End));
            }
            else
            {
                normalized.Add(current);
                current = next;
            }
        }

        normalized.Add(current);
        return normalized.ToArray();
    }
}
