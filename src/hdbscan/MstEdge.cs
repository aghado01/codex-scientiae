using System;

namespace CodexSci.Hdbscan;

/// <summary>
/// One MST edge (parent <see cref="U"/> → child <see cref="V"/>) weighted by mutual
/// reachability. Ordering is by <see cref="Weight"/> with an index tiebreak on (U, V):
/// <see cref="Array.Sort{T}(T[], int, int)"/> is an unstable introsort, so without the
/// tiebreak tied-weight edges could reorder run-to-run and shuffle the dendrogram's
/// internal-node ids — the tiebreak makes the merge tree (and thus dendrogram.json)
/// byte-stable. Any tie order yields a valid single-linkage tree; this just picks a
/// canonical one.
/// </summary>
public readonly record struct MstEdge(int U, int V, double Weight) : IComparable<MstEdge>
{
    public int CompareTo(MstEdge other)
    {
        int c = Weight.CompareTo(other.Weight);
        if (c != 0) return c;
        c = U.CompareTo(other.U);
        if (c != 0) return c;
        return V.CompareTo(other.V);
    }
}
