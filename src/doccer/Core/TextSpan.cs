using System;

namespace CodexSci.Doccer;

/// <summary>A half-open interval <c>[Start, End)</c> in one master coordinate space.</summary>
public readonly record struct TextSpan
{
    public TextSpan(int start, int end)
    {
        if (start < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(start));
        }

        if (end < start)
        {
            throw new ArgumentOutOfRangeException(nameof(end), "End must not precede Start.");
        }

        Start = start;
        End = end;
    }

    public int Start { get; }

    public int End { get; }

    public int Length => End - Start;

    public bool IsEmpty => Start == End;

    public static TextSpan FromStartLength(int start, int length)
    {
        if (length < 0)
        {
            throw new ArgumentOutOfRangeException(nameof(length));
        }

        return new TextSpan(start, checked(start + length));
    }

    public bool Contains(int offset) => Start <= offset && offset < End;

    public bool Contains(TextSpan other) => Start <= other.Start && other.End <= End;

    public bool ProperlyContains(TextSpan other) =>
        Contains(other) && (Start != other.Start || End != other.End);

    public bool Intersects(TextSpan other) => Start < other.End && other.Start < End;

    public bool Crosses(TextSpan other) =>
        (Start < other.Start && other.Start < End && End < other.End) ||
        (other.Start < Start && Start < other.End && other.End < End);

    public override string ToString() => $"[{Start},{End})";
}
