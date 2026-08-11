using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// An exact-source-basis-stamped ordered output program. Piece declaration order is retained with
/// multiplicity and determines the complete materialized output.
/// </summary>
public sealed class RewritePlan : IReadOnlyList<OutputPiece>
{
    private readonly OutputPiece[] _pieces;
    private readonly ReadOnlyCollection<OutputPiece> _pieceView;
    private readonly string[] _payloads;

    private RewritePlan(
        OriginBasis sourceBasis,
        MaterializationTarget target,
        OutputPiece[] pieces,
        string[] payloads,
        int totalOutputLength)
    {
        SourceBasis = sourceBasis;
        Target = target;
        _pieces = pieces;
        _pieceView = Array.AsReadOnly(_pieces);
        _payloads = payloads;
        TotalOutputLength = totalOutputLength;
    }

    public OriginBasis SourceBasis { get; }

    public MaterializationTarget Target { get; }

    public IReadOnlyList<OutputPiece> Pieces => _pieceView;

    public int Count => _pieces.Length;

    public OutputPiece this[int index]
    {
        get
        {
            if ((uint)index >= (uint)_pieces.Length)
            {
                throw new ArgumentOutOfRangeException(nameof(index));
            }

            return _pieces[index];
        }
    }

    public static RewritePlan Create(
        OriginBasis sourceBasis,
        MaterializationTarget target,
        IEnumerable<OutputPiece> pieces)
    {
        ArgumentNullException.ThrowIfNull(sourceBasis);
        ArgumentNullException.ThrowIfNull(target);
        ArgumentNullException.ThrowIfNull(pieces);

        var collected = new List<OutputPiece>();
        var payloads = new List<string>();
        var totalOutputLength = 0;
        string? previousPayload = null;

        foreach (var piece in pieces)
        {
            if (piece is null)
            {
                throw new ArgumentException("Rewrite-plan pieces must be non-null.", nameof(pieces));
            }

            var payload = ResolveAndValidatePiece(sourceBasis, piece, nameof(pieces));
            if (previousPayload is not null &&
                char.IsHighSurrogate(previousPayload[^1]) &&
                char.IsLowSurrogate(payload[0]))
            {
                throw new ArgumentException(
                    "Adjacent piece payloads must not fuse a high/low surrogate pair.",
                    nameof(pieces));
            }

            totalOutputLength = AddOutputLengthChecked(totalOutputLength, payload.Length);
            collected.Add(piece);
            payloads.Add(payload);
            previousPayload = payload;
        }

        return new RewritePlan(
            sourceBasis,
            target,
            collected.ToArray(),
            payloads.ToArray(),
            totalOutputLength);
    }

    public IEnumerator<OutputPiece> GetEnumerator() =>
        ((IEnumerable<OutputPiece>)_pieces).GetEnumerator();

    IEnumerator IEnumerable.GetEnumerator() => _pieces.GetEnumerator();

    internal int TotalOutputLength { get; }

    internal string GetPayload(int pieceOrdinal) => _payloads[pieceOrdinal];

    internal static int AddOutputLengthChecked(int current, int pieceLength) =>
        checked(current + pieceLength);

    private static string ResolveAndValidatePiece(
        OriginBasis sourceBasis,
        OutputPiece piece,
        string parameterName)
    {
        switch (piece.Kind)
        {
            case OutputPieceKind.Copy:
                {
                    var sourceSlotOrdinal = piece.SourceSlotOrdinal!.Value;
                    if ((uint)sourceSlotOrdinal >= (uint)sourceBasis.Count)
                    {
                        throw new ArgumentException(
                            "A copy piece names an unavailable source-basis slot.",
                            parameterName);
                    }

                    var sourceSpan = piece.SourceSpan!.Value;
                    var sourceMaster = sourceBasis[sourceSlotOrdinal].Master;
                    try
                    {
                        sourceMaster.ValidateSpan(sourceSpan, allowEmpty: false);
                    }
                    catch (ArgumentException exception)
                    {
                        throw new ArgumentException(
                            "A copy piece has invalid source geometry.",
                            parameterName,
                            exception);
                    }

                    return sourceMaster.Slice(sourceSpan);
                }

            case OutputPieceKind.OriginMapped:
                foreach (var origin in piece.Origins)
                {
                    sourceBasis.ValidateAtom(origin.Source, parameterName);
                }

                return piece.Literal!;

            case OutputPieceKind.Synthetic:
                return piece.Literal!;

            default:
                throw new ArgumentException("A rewrite piece has an undefined kind.", parameterName);
        }
    }
}
