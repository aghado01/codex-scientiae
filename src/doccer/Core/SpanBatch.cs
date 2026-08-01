using System;
using System.Collections;
using System.Collections.Generic;

namespace CodexSci.Doccer;

public enum SpanLevel
{
    Character = 0,
    Line = 1,
    MultiLine = 2,
}

/// <summary>A typed structural assertion offered to a <see cref="SpanBatchBuilder"/>.</summary>
public readonly record struct SpanClaim(
    TextSpan Span,
    string Kind,
    SpanLevel Level,
    string Source,
    int Priority = 0,
    string? RuleId = null);

/// <summary>AoS view of one row in a columnar <see cref="SpanBatch"/>.</summary>
public readonly struct SpanRecord
{
    private readonly SpanBatch? _batch;

    internal SpanRecord(SpanBatch batch, int ordinal)
    {
        _batch = batch;
        Ordinal = ordinal;
    }

    private SpanBatch Batch => _batch ?? throw new InvalidOperationException("Uninitialized span record.");

    public int Ordinal { get; }

    public TextMaster Master => Batch.Master;

    public TextSpan Span => new(Batch.Starts[Ordinal], Batch.Ends[Ordinal]);

    public string Kind => Batch.Kinds[Ordinal];

    public SpanLevel Level => Batch.Levels[Ordinal];

    public string Source => Batch.Sources[Ordinal];

    public int Priority => Batch.Priorities[Ordinal];

    public string? RuleId => Batch.RuleIds[Ordinal];

    public SpanClaim ToClaim() => new(Span, Kind, Level, Source, Priority, RuleId);

    public override string ToString() => $"#{Ordinal} {Kind} {Span} ({Source})";
}

/// <summary>Append-only claim collector which freezes into a columnar batch.</summary>
public sealed class SpanBatchBuilder
{
    private readonly List<int> _starts = new();
    private readonly List<int> _ends = new();
    private readonly List<string> _kinds = new();
    private readonly List<SpanLevel> _levels = new();
    private readonly List<string> _sources = new();
    private readonly List<int> _priorities = new();
    private readonly List<string?> _ruleIds = new();
    private SpanBatch? _frozen;

    public SpanBatchBuilder(TextMaster master)
    {
        Master = master ?? throw new ArgumentNullException(nameof(master));
    }

    public TextMaster Master { get; }

    public int Count => _starts.Count;

    public bool IsFrozen => _frozen is not null;

    public int Add(SpanClaim claim)
    {
        if (_frozen is not null)
        {
            throw new InvalidOperationException("The span batch has already been frozen.");
        }

        Master.ValidateSpan(claim.Span, allowEmpty: false);
        if (string.IsNullOrWhiteSpace(claim.Kind))
        {
            throw new ArgumentException("A claim kind is required.", nameof(claim));
        }

        if (string.IsNullOrWhiteSpace(claim.Source))
        {
            throw new ArgumentException("A claim source is required.", nameof(claim));
        }

        var ordinal = _starts.Count;
        _starts.Add(claim.Span.Start);
        _ends.Add(claim.Span.End);
        _kinds.Add(claim.Kind);
        _levels.Add(claim.Level);
        _sources.Add(claim.Source);
        _priorities.Add(claim.Priority);
        _ruleIds.Add(claim.RuleId);
        return ordinal;
    }

    public SpanBatch Freeze()
    {
        _frozen ??= new SpanBatch(
            Master,
            _starts.ToArray(),
            _ends.ToArray(),
            _kinds.ToArray(),
            _levels.ToArray(),
            _sources.ToArray(),
            _priorities.ToArray(),
            _ruleIds.ToArray());
        return _frozen;
    }
}

/// <summary>Frozen multi-claim, overlap-preserving columnar span collection.</summary>
public sealed class SpanBatch : IReadOnlyList<SpanRecord>
{
    internal SpanBatch(
        TextMaster master,
        int[] starts,
        int[] ends,
        string[] kinds,
        SpanLevel[] levels,
        string[] sources,
        int[] priorities,
        string?[] ruleIds)
    {
        Master = master;
        Starts = starts;
        Ends = ends;
        Kinds = kinds;
        Levels = levels;
        Sources = sources;
        Priorities = priorities;
        RuleIds = ruleIds;
        Sorted = new SortedSpanLookup(this);
    }

    internal int[] Starts { get; }
    internal int[] Ends { get; }
    internal string[] Kinds { get; }
    internal SpanLevel[] Levels { get; }
    internal string[] Sources { get; }
    internal int[] Priorities { get; }
    internal string?[] RuleIds { get; }

    public TextMaster Master { get; }

    public int Count => Starts.Length;

    public SpanRecord this[int index]
    {
        get
        {
            if ((uint)index >= (uint)Count)
            {
                throw new ArgumentOutOfRangeException(nameof(index));
            }

            return new SpanRecord(this, index);
        }
    }

    public SortedSpanLookup Sorted { get; }

    public IEnumerator<SpanRecord> GetEnumerator()
    {
        for (var i = 0; i < Count; i++)
        {
            yield return new SpanRecord(this, i);
        }
    }

    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

/// <summary>Stable start-ordered query view over a frozen batch.</summary>
public sealed class SortedSpanLookup
{
    private readonly SpanBatch _batch;
    private readonly int[] _order;

    internal SortedSpanLookup(SpanBatch batch)
    {
        _batch = batch;
        _order = new int[batch.Count];
        for (var i = 0; i < _order.Length; i++)
        {
            _order[i] = i;
        }

        Array.Sort(_order, Compare);
    }

    private int Compare(int left, int right)
    {
        var comparison = _batch.Starts[left].CompareTo(_batch.Starts[right]);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = _batch.Ends[right].CompareTo(_batch.Ends[left]);
        return comparison != 0 ? comparison : left.CompareTo(right);
    }

    public IReadOnlyList<SpanRecord> FindIntersecting(TextSpan query)
    {
        _batch.Master.ValidateSpan(query);
        var found = new List<SpanRecord>();
        foreach (var index in _order)
        {
            var candidate = _batch[index];
            if (candidate.Span.Start >= query.End)
            {
                break;
            }

            if (candidate.Span.Intersects(query))
            {
                found.Add(candidate);
            }
        }

        return found.AsReadOnly();
    }
}
