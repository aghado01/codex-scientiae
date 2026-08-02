using System;

namespace CodexSci.Doccer;

/// <summary>
/// Opt-in lineage between a parent master and the fragment-local child master minted over one
/// window of it (D12: a master is a coordinate space and masters scale down; D7: slice→parent
/// rebase is the total bijective case and does not wait for OffsetMap). The slice object is the
/// lineage — neither master points at the other, and either is fully usable alone.
/// </summary>
/// <remarks>
/// <para>
/// Child identity is derived and deterministic — <c>{parent}#{start}-{end}</c> at the parent's
/// revision — so slicing is a pure function (D19): re-creating the same slice of the same parent
/// mints a compatible master, and geometry rebases through either lineage object
/// interchangeably. The identity floor still governs mixing: even a whole-extent child is its
/// own coordinate space and refuses the parent's spans.
/// </para>
/// <para>
/// Rebase is coordinate arithmetic, never interpretation: claims keep kind, level, source,
/// priority and rule identity untouched. Child → parent is total and bijective. Parent → child
/// is partial and loud — geometry outside the window is refused, never clamped; scope a
/// <see cref="SpanSet"/> with <c>Intersect</c> against the window before rebasing it down.
/// There is deliberately no parent → child batch projection: clipping claims to a window needs
/// a residual policy, which is OffsetMap (F1) business.
/// </para>
/// </remarks>
public sealed class TextSlice
{
    private TextSlice(TextMaster parent, TextSpan window, TextMaster child)
    {
        Parent = parent;
        Window = window;
        Child = child;
    }

    public TextMaster Parent { get; }

    /// <summary>The child's extent in parent coordinates.</summary>
    public TextSpan Window { get; }

    public TextMaster Child { get; }

    /// <summary>
    /// Mints a fragment-local child master over one window of the parent. The window is
    /// validated by the parent (bounds and scalar boundaries), so a slice can never split a
    /// surrogate pair; an empty window is legal and mints an empty child — degenerate, but still
    /// a coordinate space.
    /// </summary>
    public static TextSlice Create(TextMaster parent, TextSpan window)
    {
        ArgumentNullException.ThrowIfNull(parent);
        var child = new TextMaster(
            $"{parent.DocumentId}#{window.Start}-{window.End}",
            parent.Revision,
            parent.Slice(window));
        return new TextSlice(parent, window, child);
    }

    /// <summary>Rebases a child offset into parent coordinates. Total on <c>[0, Child.Length]</c>.</summary>
    public int ToParent(int childOffset)
    {
        if ((uint)childOffset > (uint)Child.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(childOffset));
        }

        return Window.Start + childOffset;
    }

    /// <summary>Rebases a child span into parent coordinates. Total on the child's valid spans.</summary>
    public TextSpan ToParent(TextSpan childSpan)
    {
        Child.ValidateSpan(childSpan);
        return new TextSpan(Window.Start + childSpan.Start, Window.Start + childSpan.End);
    }

    /// <summary>
    /// Rebases a parent offset into child coordinates. Partial: the offset must lie within
    /// <c>[Window.Start, Window.End]</c>; anything else fails loud rather than clamping.
    /// </summary>
    public int ToChild(int parentOffset)
    {
        if (parentOffset < Window.Start || parentOffset > Window.End)
        {
            throw new ArgumentOutOfRangeException(
                nameof(parentOffset),
                parentOffset,
                $"Offset lies outside the slice window {Window}.");
        }

        return parentOffset - Window.Start;
    }

    /// <summary>
    /// Rebases a parent span into child coordinates. Partial: the span must lie within the
    /// window; out-of-window geometry is refused, never clamped — clamping is a projection
    /// policy, and policies are OffsetMap (F1) business.
    /// </summary>
    public TextSpan ToChild(TextSpan parentSpan)
    {
        Parent.ValidateSpan(parentSpan);
        if (!Window.Contains(parentSpan))
        {
            throw new ArgumentException(
                $"Span {parentSpan} lies outside the slice window {Window}; intersect with the " +
                "window before rebasing down.",
                nameof(parentSpan));
        }

        return new TextSpan(parentSpan.Start - Window.Start, parentSpan.End - Window.Start);
    }

    /// <summary>Rebases a child-bound region set into an equal parent-bound set.</summary>
    public SpanSet ToParent(SpanSet childSet)
    {
        ArgumentNullException.ThrowIfNull(childSet);
        Child.EnsureCompatibleWith(childSet.Master);
        var mapped = new TextSpan[childSet.Count];
        for (var i = 0; i < childSet.Count; i++)
        {
            mapped[i] = new TextSpan(
                Window.Start + childSet[i].Start,
                Window.Start + childSet[i].End);
        }

        return SpanSet.Create(Parent, mapped);
    }

    /// <summary>
    /// Rebases a parent-bound region set into child coordinates. Partial: every region must lie
    /// within the window — <c>Intersect</c> the set with the window first to scope it.
    /// </summary>
    public SpanSet ToChild(SpanSet parentSet)
    {
        ArgumentNullException.ThrowIfNull(parentSet);
        Parent.EnsureCompatibleWith(parentSet.Master);
        var mapped = new TextSpan[parentSet.Count];
        for (var i = 0; i < parentSet.Count; i++)
        {
            if (!Window.Contains(parentSet[i]))
            {
                throw new ArgumentException(
                    $"Region {parentSet[i]} lies outside the slice window {Window}; intersect " +
                    "the set with the window before rebasing down.",
                    nameof(parentSet));
            }

            mapped[i] = new TextSpan(
                parentSet[i].Start - Window.Start,
                parentSet[i].End - Window.Start);
        }

        return SpanSet.Create(Child, mapped);
    }

    /// <summary>Rebases a child-bound batch into a new frozen parent-bound batch.</summary>
    public SpanBatch ToParent(SpanBatch childBatch)
    {
        ArgumentNullException.ThrowIfNull(childBatch);
        var builder = new SpanBatchBuilder(Parent);
        ToParentInto(builder, childBatch);
        return builder.Freeze();
    }

    /// <summary>
    /// Rebases a child-bound batch into a caller's parent-bound builder, in ordinal order — the
    /// weaving form: collect on several fragments, rebase each into one parent batch.
    /// </summary>
    public void ToParentInto(SpanBatchBuilder parentBuilder, SpanBatch childBatch)
    {
        ArgumentNullException.ThrowIfNull(parentBuilder);
        ArgumentNullException.ThrowIfNull(childBatch);
        if (parentBuilder.IsFrozen)
        {
            throw new InvalidOperationException("The span batch has already been frozen.");
        }

        Parent.EnsureCompatibleWith(parentBuilder.Master);
        Child.EnsureCompatibleWith(childBatch.Master);

        // Rebase is total, so unlike collection (D16) there is no mid-sweep failure to stage
        // against: every claim valid on the child is valid on the parent, because the window is
        // scalar-bounded and the text over it is identical.
        foreach (var record in childBatch)
        {
            var claim = record.ToClaim();
            parentBuilder.Add(claim with { Span = ToParent(claim.Span) });
        }
    }
}
