using System;
using System.Collections.Generic;

namespace CodexSci.Doccer;

/// <summary>Shared sort-specific primitives for located composition and graph partitions.</summary>
internal static class LocatedSemantics
{
    /// <summary>
    /// Shared-boundary adjacency on located extents. This admits diagonal extents and is
    /// deliberately distinct from Allen <see cref="AllenRelation.Meets"/>.
    /// </summary>
    internal static bool CanSeq(TextSpan left, TextSpan right) => left.End == right.Start;

    /// <summary>Enumerates scalar-valid boundaries in one already validated window.</summary>
    internal static List<int> ValidBoundaries(TextMaster master, TextSpan window)
    {
        var boundaries = new List<int>();
        for (var offset = window.Start; ; offset++)
        {
            if (master.IsScalarBoundary(offset))
            {
                boundaries.Add(offset);
            }

            if (offset == window.End)
            {
                break;
            }
        }

        return boundaries;
    }
}
