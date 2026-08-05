using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

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

/// <summary>
/// An interned string column of a frozen batch: one integer ID per row plus the table of distinct
/// values in first-appearance order. Built at freeze so equal column values share one table entry
/// and one ID, giving columnar consumers (and, later, persisted formats) integer equality and a
/// compact vocabulary. Interning is value-preserving: the string read back for any row is equal to
/// the string the claim was added with. IDs are batch-local — they carry no meaning across batches.
/// </summary>
public sealed class InternedColumn
{
    /// <summary>The ID recorded for rows whose value is null (nullable columns only).</summary>
    public const int NullId = -1;

    private readonly int[] _ids;
    private readonly string[] _table;
    private readonly ReadOnlyCollection<int> _idsView;
    private readonly ReadOnlyCollection<string> _tableView;

    private InternedColumn(int[] ids, string[] table)
    {
        _ids = ids;
        _table = table;
        _idsView = Array.AsReadOnly(_ids);
        _tableView = Array.AsReadOnly(_table);
    }

    public int Count => _ids.Length;

    /// <summary>Per-row table IDs, ordinal-aligned with the batch; <see cref="NullId"/> marks null.</summary>
    public IReadOnlyList<int> Ids => _idsView;

    /// <summary>Distinct non-null values in first-appearance order; index = ID.</summary>
    public IReadOnlyList<string> Table => _tableView;

    public string? this[int ordinal]
    {
        get
        {
            var id = _ids[ordinal];
            return id == NullId ? null : _table[id];
        }
    }

    internal static InternedColumn Intern(IReadOnlyList<string?> values)
    {
        var ids = new int[values.Count];
        var table = new List<string>();
        var lookup = new Dictionary<string, int>(StringComparer.Ordinal);
        for (var i = 0; i < values.Count; i++)
        {
            var value = values[i];
            if (value is null)
            {
                ids[i] = NullId;
                continue;
            }

            if (!lookup.TryGetValue(value, out var id))
            {
                id = table.Count;
                table.Add(value);
                lookup.Add(value, id);
            }

            ids[i] = id;
        }

        return new InternedColumn(ids, table.ToArray());
    }
}

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

    // Kind and Source are non-null by builder validation, so the interned lookup cannot return
    // null for them; RuleId is genuinely nullable and passes the column's null ID through.
    public string Kind => Batch.Kinds[Ordinal]!;

    public SpanLevel Level => Batch.Levels[Ordinal];

    public string Source => Batch.Sources[Ordinal]!;

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
        if (!Enum.IsDefined(claim.Level))
        {
            throw new ArgumentException($"Undefined SpanLevel value {(int)claim.Level}.", nameof(claim));
        }

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
        // The string columns are interned here, at the one point where the claim set stops
        // growing: distinct values become a table and every row keeps an integer ID into it.
        _frozen ??= new SpanBatch(
            Master,
            _starts.ToArray(),
            _ends.ToArray(),
            InternedColumn.Intern(_kinds),
            _levels.ToArray(),
            InternedColumn.Intern(_sources),
            _priorities.ToArray(),
            InternedColumn.Intern(_ruleIds));
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
        InternedColumn kinds,
        SpanLevel[] levels,
        InternedColumn sources,
        int[] priorities,
        InternedColumn ruleIds)
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
    internal SpanLevel[] Levels { get; }
    internal int[] Priorities { get; }

    /// <summary>The interned claim-kind column: per-row IDs plus the distinct-kind table.</summary>
    public InternedColumn Kinds { get; }

    /// <summary>The interned claim-source column: per-row IDs plus the distinct-source table.</summary>
    public InternedColumn Sources { get; }

    /// <summary>
    /// The interned rule-id column. Rows from producers that record no rule carry
    /// <see cref="InternedColumn.NullId"/>.
    /// </summary>
    public InternedColumn RuleIds { get; }

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

/// <summary>
/// Named result orderings for lookup queries. Resolution order is query policy (D5): priority
/// stays default evidence on the claim, and a caller names the order a query answers in
/// (contract D24). Pure per-query ordering — acceleration structures are F4's business.
/// </summary>
public enum ClaimOrder
{
    /// <summary>The stable start order: start ascending, end descending, then ordinal.</summary>
    Geometry = 0,

    /// <summary>
    /// Priority descending — the D2 max-priority posture — then the geometry order, then
    /// ordinal. A total order, so determinism needs no stability argument.
    /// </summary>
    PriorityThenGeometry = 1,
}

/// <summary>One implementation of the named claim orders shared by every ordered query.</summary>
internal static class ClaimOrdering
{
    public static void Validate(ClaimOrder order)
    {
        if (!Enum.IsDefined(order))
        {
            throw new ArgumentOutOfRangeException(nameof(order), order, "Undefined ClaimOrder value.");
        }
    }

    public static int Compare(SpanBatch batch, int left, int right, ClaimOrder order)
    {
        if (order == ClaimOrder.PriorityThenGeometry)
        {
            var priority = batch.Priorities[right].CompareTo(batch.Priorities[left]);
            if (priority != 0)
            {
                return priority;
            }
        }

        var comparison = batch.Starts[left].CompareTo(batch.Starts[right]);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = batch.Ends[right].CompareTo(batch.Ends[left]);
        return comparison != 0 ? comparison : left.CompareTo(right);
    }

    public static int Compare(SpanRecord left, SpanRecord right, ClaimOrder order)
    {
        if (order == ClaimOrder.PriorityThenGeometry)
        {
            var priority = right.Priority.CompareTo(left.Priority);
            if (priority != 0)
            {
                return priority;
            }
        }

        var comparison = left.Span.Start.CompareTo(right.Span.Start);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = right.Span.End.CompareTo(left.Span.End);
        return comparison != 0 ? comparison : left.Ordinal.CompareTo(right.Ordinal);
    }
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

        Array.Sort(_order, (left, right) => ClaimOrdering.Compare(_batch, left, right, ClaimOrder.Geometry));
    }

    /// <summary>
    /// Claims whose spans set-theoretically intersect the query: an empty query span finds
    /// nothing. To ask which claims cover a position — an insertion point, say — use
    /// <see cref="FindContaining"/>.
    /// </summary>
    public IReadOnlyList<SpanRecord> FindIntersecting(TextSpan query, ClaimOrder order = ClaimOrder.Geometry)
    {
        ValidateOrder(order);
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

        return Ordered(found, order);
    }

    /// <summary>
    /// The point-location query: claims whose spans contain the UTF-16 code-unit offset
    /// (<c>Start &lt;= position &lt; End</c>), in the lookup's stable start order. This is the
    /// named form of the question an empty span used to smuggle through
    /// <see cref="FindIntersecting"/>. The position addresses a code unit, not a claim boundary,
    /// so it may legitimately sit inside a surrogate pair a claim covers; <c>position ==
    /// master.Length</c> is a valid question whose answer is always empty.
    /// </summary>
    public IReadOnlyList<SpanRecord> FindContaining(int position, ClaimOrder order = ClaimOrder.Geometry)
    {
        ValidateOrder(order);
        if ((uint)position > (uint)_batch.Master.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(position));
        }

        var found = new List<SpanRecord>();
        foreach (var index in _order)
        {
            var candidate = _batch[index];
            if (candidate.Span.Start > position)
            {
                break;
            }

            if (candidate.Span.Contains(position))
            {
                found.Add(candidate);
            }
        }

        return Ordered(found, order);
    }

    private static void ValidateOrder(ClaimOrder order)
    {
        ClaimOrdering.Validate(order);
    }

    private static IReadOnlyList<SpanRecord> Ordered(List<SpanRecord> found, ClaimOrder order)
    {
        if (order == ClaimOrder.PriorityThenGeometry)
        {
            // The comparison ends at the ordinal, making it a total order: equal-priority,
            // equal-geometry claims keep their batch order deterministically.
            found.Sort(static (left, right) =>
                ClaimOrdering.Compare(left, right, ClaimOrder.PriorityThenGeometry));
        }

        return found.AsReadOnly();
    }
}
