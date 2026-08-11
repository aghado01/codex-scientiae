using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;

namespace CodexSci.Doccer;

/// <summary>One exact-plan-stamped realized positive output piece.</summary>
public sealed class MaterializedPiece
{
    internal MaterializedPiece(
        RewritePlan plan,
        int pieceOrdinal,
        OutputPiece piece,
        TextMaster outputMaster,
        TextSpan outputSpan)
    {
        ArgumentNullException.ThrowIfNull(plan);
        ArgumentNullException.ThrowIfNull(piece);
        ArgumentNullException.ThrowIfNull(outputMaster);
        if ((uint)pieceOrdinal >= (uint)plan.Count)
        {
            throw new ArgumentOutOfRangeException(nameof(pieceOrdinal));
        }

        if (!ReferenceEquals(plan[pieceOrdinal], piece))
        {
            throw new ArgumentException(
                "The realized piece must be the exact object at its plan position.",
                nameof(piece));
        }

        outputMaster.ValidateSpan(outputSpan, allowEmpty: false);
        Plan = plan;
        PieceOrdinal = pieceOrdinal;
        Piece = piece;
        OutputMaster = outputMaster;
        OutputSpan = outputSpan;
    }

    public RewritePlan Plan { get; }

    public int PieceOrdinal { get; }

    public OutputPiece Piece { get; }

    public TextMaster OutputMaster { get; }

    public TextSpan OutputSpan { get; }
}

/// <summary>The exact output, origins, positive partition, and unused source material of one run.</summary>
public sealed class MaterializationResult
{
    private readonly ReadOnlyCollection<MaterializedPiece> _pieces;
    private readonly ReadOnlyCollection<SpanSet> _unusedSources;

    internal MaterializationResult(
        RewritePlan plan,
        TextMaster outputMaster,
        OriginBasis outputBasis,
        MaterializedPiece[] pieces,
        OriginRelation origins,
        SpanSet[] unusedSources)
    {
        Plan = plan ?? throw new ArgumentNullException(nameof(plan));
        OutputMaster = outputMaster ?? throw new ArgumentNullException(nameof(outputMaster));
        OutputBasis = outputBasis ?? throw new ArgumentNullException(nameof(outputBasis));
        ArgumentNullException.ThrowIfNull(pieces);
        Origins = origins ?? throw new ArgumentNullException(nameof(origins));
        ArgumentNullException.ThrowIfNull(unusedSources);
        _pieces = Array.AsReadOnly(pieces);
        _unusedSources = Array.AsReadOnly(unusedSources);
    }

    public RewritePlan Plan { get; }

    public TextMaster OutputMaster { get; }

    public OriginBasis OutputBasis { get; }

    public IReadOnlyList<MaterializedPiece> Pieces => _pieces;

    public OriginRelation Origins { get; }

    public IReadOnlyList<SpanSet> UnusedSources => _unusedSources;
}

/// <summary>Direct deterministic execution of an exact ordered rewrite plan.</summary>
public static class RewriteMaterialization
{
    public static MaterializationResult Materialize(RewritePlan plan)
    {
        ArgumentNullException.ThrowIfNull(plan);

        var outputBuilder = new StringBuilder(plan.TotalOutputLength);
        for (var pieceOrdinal = 0; pieceOrdinal < plan.Count; pieceOrdinal++)
        {
            outputBuilder.Append(plan.GetPayload(pieceOrdinal));
        }

        if (outputBuilder.Length != plan.TotalOutputLength)
        {
            throw new InvalidOperationException("Resolved plan length changed after validation.");
        }

        var outputMaster = new TextMaster(
            plan.Target.DocumentId,
            plan.Target.Revision,
            outputBuilder.ToString());
        var outputBasis = OriginBasis.Create(new[]
        {
            new OriginSlot(plan.Target.OutputTag, outputMaster),
        });

        var outputAtoms = outputMaster.Topology.Atoms;
        var originBearing = new bool[outputAtoms.Count];
        var synthetic = new bool[outputAtoms.Count];
        var materializedPieces = new MaterializedPiece[plan.Count];
        var edges = new List<OriginEdge>();
        var outputOffset = 0;
        var outputAtomOffset = 0;

        for (var pieceOrdinal = 0; pieceOrdinal < plan.Count; pieceOrdinal++)
        {
            var piece = plan[pieceOrdinal];
            var payload = plan.GetPayload(pieceOrdinal);
            var pieceEnd = checked(outputOffset + payload.Length);
            var outputSpan = new TextSpan(outputOffset, pieceEnd);
            materializedPieces[pieceOrdinal] = new MaterializedPiece(
                plan,
                pieceOrdinal,
                piece,
                outputMaster,
                outputSpan);

            if (!StringComparer.Ordinal.Equals(outputMaster.Slice(outputSpan), payload))
            {
                throw new InvalidOperationException("A realized piece does not reproduce its payload.");
            }

            var localTopology = TextTopology.Build(payload);
            VerifyLocalAtomEmbedding(
                localTopology,
                outputAtoms,
                outputOffset,
                outputAtomOffset);

            var isSynthetic = piece.Kind == OutputPieceKind.Synthetic;
            for (var localAtomOrdinal = 0;
                 localAtomOrdinal < localTopology.AtomCount;
                 localAtomOrdinal++)
            {
                var outputAtomOrdinal = outputAtomOffset + localAtomOrdinal;
                originBearing[outputAtomOrdinal] = !isSynthetic;
                synthetic[outputAtomOrdinal] = isSynthetic;
            }

            switch (piece.Kind)
            {
                case OutputPieceKind.Copy:
                    AddCopyEdges(
                        plan,
                        piece,
                        localTopology,
                        outputAtomOffset,
                        edges);
                    break;

                case OutputPieceKind.OriginMapped:
                    foreach (var localOrigin in piece.Origins)
                    {
                        edges.Add(new OriginEdge(
                            new OriginAtom(
                                0,
                                checked(outputAtomOffset + localOrigin.OutputAtomOrdinal)),
                            localOrigin.Source));
                    }

                    break;

                case OutputPieceKind.Synthetic:
                    break;

                default:
                    throw new InvalidOperationException("A rewrite piece has an undefined kind.");
            }

            outputOffset = pieceEnd;
            outputAtomOffset = checked(outputAtomOffset + localTopology.AtomCount);
        }

        if (outputOffset != outputMaster.Length || outputAtomOffset != outputAtoms.Count)
        {
            throw new InvalidOperationException("The realized piece partition does not cover the output.");
        }

        var origins = OriginRelation.Create(outputBasis, plan.SourceBasis, edges);
        VerifyMaterialPosture(originBearing, synthetic, origins);
        var unusedSources = ComputeUnusedSources(plan.SourceBasis, origins);

        return new MaterializationResult(
            plan,
            outputMaster,
            outputBasis,
            materializedPieces,
            origins,
            unusedSources);
    }

    private static void AddCopyEdges(
        RewritePlan plan,
        OutputPiece piece,
        TextTopology localTopology,
        int outputAtomOffset,
        List<OriginEdge> edges)
    {
        var sourceSlotOrdinal = piece.SourceSlotOrdinal!.Value;
        var sourceSpan = piece.SourceSpan!.Value;
        var sourceAtoms = plan.SourceBasis[sourceSlotOrdinal].Master.Topology.Atoms;
        var tiledSourceAtomOrdinals = new List<int>();
        for (var sourceAtomOrdinal = 0;
             sourceAtomOrdinal < sourceAtoms.Count;
             sourceAtomOrdinal++)
        {
            if (sourceSpan.Contains(sourceAtoms[sourceAtomOrdinal].Span))
            {
                tiledSourceAtomOrdinals.Add(sourceAtomOrdinal);
            }
        }

        if (tiledSourceAtomOrdinals.Count != localTopology.AtomCount)
        {
            throw new InvalidOperationException(
                "A copy payload does not preserve the source span's scalar tiling.");
        }

        for (var localAtomOrdinal = 0;
             localAtomOrdinal < tiledSourceAtomOrdinals.Count;
             localAtomOrdinal++)
        {
            var sourceAtomOrdinal = tiledSourceAtomOrdinals[localAtomOrdinal];
            var sourceAtomSpan = sourceAtoms[sourceAtomOrdinal].Span;
            var localAtomSpan = localTopology.Atoms[localAtomOrdinal].Span;
            var rebasedSourceAtomSpan = new TextSpan(
                sourceAtomSpan.Start - sourceSpan.Start,
                sourceAtomSpan.End - sourceSpan.Start);
            if (rebasedSourceAtomSpan != localAtomSpan)
            {
                throw new InvalidOperationException(
                    "A copied source atom does not match its local payload atom.");
            }

            edges.Add(new OriginEdge(
                new OriginAtom(0, checked(outputAtomOffset + localAtomOrdinal)),
                new OriginAtom(sourceSlotOrdinal, sourceAtomOrdinal)));
        }
    }

    private static void VerifyLocalAtomEmbedding(
        TextTopology localTopology,
        IReadOnlyList<TextAtom> outputAtoms,
        int outputOffset,
        int outputAtomOffset)
    {
        for (var localAtomOrdinal = 0;
             localAtomOrdinal < localTopology.AtomCount;
             localAtomOrdinal++)
        {
            var globalAtomOrdinal = checked(outputAtomOffset + localAtomOrdinal);
            if ((uint)globalAtomOrdinal >= (uint)outputAtoms.Count)
            {
                throw new InvalidOperationException(
                    "A piece-local atom has no corresponding output atom.");
            }

            var localSpan = localTopology.Atoms[localAtomOrdinal].Span;
            var expectedSpan = new TextSpan(
                checked(outputOffset + localSpan.Start),
                checked(outputOffset + localSpan.End));
            if (outputAtoms[globalAtomOrdinal].Span != expectedSpan)
            {
                throw new InvalidOperationException(
                    "Piece concatenation changed a piece-local scalar atom.");
            }
        }
    }

    private static void VerifyMaterialPosture(
        bool[] originBearing,
        bool[] synthetic,
        OriginRelation origins)
    {
        if (originBearing.Length != synthetic.Length)
        {
            throw new InvalidOperationException("Output material-posture vectors disagree.");
        }

        var hasOrigin = new bool[originBearing.Length];
        foreach (var edge in origins)
        {
            hasOrigin[edge.Output.AtomOrdinal] = true;
        }

        for (var atomOrdinal = 0; atomOrdinal < originBearing.Length; atomOrdinal++)
        {
            if (originBearing[atomOrdinal] == synthetic[atomOrdinal] ||
                originBearing[atomOrdinal] != hasOrigin[atomOrdinal])
            {
                throw new InvalidOperationException(
                    "Every output atom must be exactly origin-bearing or synthetic.");
            }
        }
    }

    private static SpanSet[] ComputeUnusedSources(
        OriginBasis sourceBasis,
        OriginRelation origins)
    {
        var usedBySlot = new HashSet<int>[sourceBasis.Count];
        for (var slotOrdinal = 0; slotOrdinal < usedBySlot.Length; slotOrdinal++)
        {
            usedBySlot[slotOrdinal] = new HashSet<int>();
        }

        foreach (var edge in origins)
        {
            usedBySlot[edge.Source.SlotOrdinal].Add(edge.Source.AtomOrdinal);
        }

        var unused = new SpanSet[sourceBasis.Count];
        for (var slotOrdinal = 0; slotOrdinal < sourceBasis.Count; slotOrdinal++)
        {
            var sourceMaster = sourceBasis[slotOrdinal].Master;
            var unusedSpans = new List<TextSpan>();
            for (var atomOrdinal = 0;
                 atomOrdinal < sourceMaster.Topology.AtomCount;
                 atomOrdinal++)
            {
                if (!usedBySlot[slotOrdinal].Contains(atomOrdinal))
                {
                    unusedSpans.Add(sourceMaster.Topology.Atoms[atomOrdinal].Span);
                }
            }

            unused[slotOrdinal] = SpanSet.Create(sourceMaster, unusedSpans);
        }

        return unused;
    }
}
