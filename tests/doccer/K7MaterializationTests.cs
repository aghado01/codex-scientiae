using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static void MaterializationConstructionSnapshotsAndRefusesInvalidPlans()
    {
        var target = new MaterializationTarget(" document ", 7, " output ");
        Equal(" document ", target.DocumentId, "materialization target retains exact document ID");
        Equal(7L, target.Revision, "materialization target retains revision");
        Equal(" output ", target.OutputTag, "materialization target retains exact output tag");
        True(
            !target.Equals(new MaterializationTarget(" document ", 7, " output ")),
            "materialization targets retain reference identity");
        Throws<ArgumentException>(
            () => new MaterializationTarget(null!, 0, "output"),
            "null materialization document ID refused");
        Throws<ArgumentException>(
            () => new MaterializationTarget(" ", 0, "output"),
            "blank materialization document ID refused");
        Throws<ArgumentOutOfRangeException>(
            () => new MaterializationTarget("document", -1, "output"),
            "negative materialization revision refused");
        Throws<ArgumentException>(
            () => new MaterializationTarget("document", 0, "\t"),
            "blank materialization output tag refused");

        var source0 = new TextMaster("k7-construction-source", 0, "a😀c");
        var source1 = new TextMaster("k7-construction-source", 0, "a😀c");
        var basis = OriginBasis.Create(new[]
        {
            new OriginSlot("first", source0),
            new OriginSlot("second", source1),
        });
        var factTable = CanonicalFactTable.Create(source0, new[]
        {
            new FactKey(
                "k7",
                "derivation",
                new[] { new TextSpan(0, 1) },
                new[] { "construction" }),
        });
        var derivation = new FactReference(factTable, 0);

        var copy = OutputPiece.Copy(0, new TextSpan(1, 3), derivation);
        True(copy.Kind == OutputPieceKind.Copy, "copy factory freezes copy kind");
        True(
            copy.SourceSlotOrdinal == 0 && copy.SourceSpan == new TextSpan(1, 3),
            "copy factory retains its plan-relative source slice");
        True(
            copy.Literal is null && copy.Origins.Count == 0 &&
            copy.SyntheticExplanation is null,
            "copy exposes no inapplicable literal, origins, or synthesis fields");
        True(
            copy.Derivation.HasValue && copy.Derivation.Value == derivation &&
            ReferenceEquals(factTable, copy.Derivation.Value.Table),
            "copy retains its exact optional fact reference");

        var suppliedOrigins = new List<PieceOrigin>
        {
            new(1, new OriginAtom(1, 1)),
            new(0, new OriginAtom(1, 2)),
            new(0, new OriginAtom(0, 0)),
            new(0, new OriginAtom(0, 0)),
        };
        var mapped = OutputPiece.OriginMapped("x😀", suppliedOrigins, derivation);
        suppliedOrigins.Clear();
        True(mapped.Kind == OutputPieceKind.OriginMapped, "mapped factory freezes mapped kind");
        Equal("x😀", mapped.Literal, "mapped factory retains literal UTF-16 content");
        Equal(3, mapped.Origins.Count, "mapped origins snapshot and collapse exact duplicates");
        Equal(
            new PieceOrigin(0, new OriginAtom(0, 0)),
            mapped.Origins[0],
            "mapped origins first compare local output atom");
        Equal(
            new PieceOrigin(0, new OriginAtom(1, 2)),
            mapped.Origins[1],
            "mapped origins next compare source slot and atom");
        Equal(
            new PieceOrigin(1, new OriginAtom(1, 1)),
            mapped.Origins[2],
            "mapped origins retain the locally total second atom");
        True(
            mapped.SourceSlotOrdinal is null && mapped.SourceSpan is null &&
            mapped.SyntheticExplanation is null,
            "mapped piece exposes no copy or synthesis fields");

        var synthetic = OutputPiece.Synthetic(" \t", " generated separator ", derivation);
        True(synthetic.Kind == OutputPieceKind.Synthetic, "synthetic factory freezes synthetic kind");
        Equal(" \t", synthetic.Literal, "whitespace is legal synthetic material");
        Equal(
            " generated separator ",
            synthetic.SyntheticExplanation,
            "synthetic explanation retains exact text without trimming");
        True(
            synthetic.SourceSlotOrdinal is null && synthetic.SourceSpan is null &&
            synthetic.Origins.Count == 0,
            "synthetic piece exposes no copy or origin fields");
        True(
            typeof(OutputPiece).GetConstructors().Length == 0,
            "factory-only output pieces expose no public mixed-mode constructor");
        True(
            typeof(MaterializedPiece).GetConstructors().Length == 0 &&
            typeof(MaterializationResult).GetConstructors().Length == 0,
            "only the validated executor can mint realized pieces and results");
        True(
            !copy.Equals(OutputPiece.Copy(0, new TextSpan(1, 3), derivation)),
            "output pieces retain reference identity");

        var suppliedPieces = new List<OutputPiece> { copy, mapped, synthetic, copy };
        var plan = RewritePlan.Create(basis, target, suppliedPieces);
        suppliedPieces.Clear();
        Equal(4, plan.Count, "rewrite plan snapshots ordered piece multiplicity");
        True(
            ReferenceEquals(basis, plan.SourceBasis) && ReferenceEquals(target, plan.Target),
            "rewrite plan retains exact basis and target references");
        True(
            ReferenceEquals(copy, plan[0]) && ReferenceEquals(copy, plan[3]),
            "reusing one exact piece emits two ordered plan entries");
        True(
            ReferenceEquals(mapped, plan.Pieces[1]) &&
            ReferenceEquals(synthetic, plan.Pieces[2]),
            "rewrite plan exposes its frozen declaration order");
        True(
            !plan.Equals(RewritePlan.Create(basis, target, plan.Pieces)),
            "rewrite plans retain reference identity");
        Throws<ArgumentOutOfRangeException>(() => _ = plan[-1], "negative plan index refused");
        Throws<ArgumentOutOfRangeException>(() => _ = plan[4], "past-end plan index refused");

        Throws<ArgumentOutOfRangeException>(
            () => new PieceOrigin(-1, new OriginAtom(0, 0)),
            "negative piece-local output atom refused");
        Throws<ArgumentException>(
            () => OutputPiece.OriginMapped(null!, Array.Empty<PieceOrigin>()),
            "null mapped literal refused");
        Throws<ArgumentException>(
            () => OutputPiece.OriginMapped(string.Empty, Array.Empty<PieceOrigin>()),
            "empty mapped literal refused");
        Throws<ArgumentNullException>(
            () => OutputPiece.OriginMapped("x", null!),
            "null mapped-origin sequence refused");
        Throws<ArgumentException>(
            () => OutputPiece.OriginMapped(
                "x",
                new[] { new PieceOrigin(1, new OriginAtom(0, 0)) }),
            "past-end mapped local atom refused");
        Throws<ArgumentException>(
            () => OutputPiece.OriginMapped(
                "xy",
                new[] { new PieceOrigin(0, new OriginAtom(0, 0)) }),
            "locally partial mapped origins refused");
        Throws<ArgumentException>(
            () => OutputPiece.Synthetic(null!, "explanation"),
            "null synthetic literal refused");
        Throws<ArgumentException>(
            () => OutputPiece.Synthetic(string.Empty, "explanation"),
            "empty synthetic literal refused");
        Throws<ArgumentException>(
            () => OutputPiece.Synthetic("x", " \t"),
            "blank synthetic explanation refused");

        FactReference? uninitializedDerivation = default(FactReference);
        Throws<ArgumentException>(
            () => OutputPiece.Copy(0, new TextSpan(0, 1), uninitializedDerivation),
            "copy refuses uninitialized optional fact reference");
        Throws<ArgumentException>(
            () => OutputPiece.OriginMapped(
                "x",
                new[] { new PieceOrigin(0, new OriginAtom(0, 0)) },
                uninitializedDerivation),
            "mapped piece refuses uninitialized optional fact reference");
        Throws<ArgumentException>(
            () => OutputPiece.Synthetic("x", "explanation", uninitializedDerivation),
            "synthetic piece refuses uninitialized optional fact reference");

        Throws<ArgumentNullException>(
            () => RewritePlan.Create(null!, target, Array.Empty<OutputPiece>()),
            "null plan source basis refused");
        Throws<ArgumentNullException>(
            () => RewritePlan.Create(basis, null!, Array.Empty<OutputPiece>()),
            "null plan target refused");
        Throws<ArgumentNullException>(
            () => RewritePlan.Create(basis, target, null!),
            "null plan piece sequence refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(basis, target, new OutputPiece[] { copy, null! }),
            "null plan piece refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[] { OutputPiece.Copy(2, new TextSpan(0, 1)) }),
            "past-end copy source slot refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[] { OutputPiece.Copy(0, new TextSpan(0, 0)) }),
            "empty copy span refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[] { OutputPiece.Copy(0, new TextSpan(0, 5)) }),
            "out-of-range copy span refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[] { OutputPiece.Copy(0, new TextSpan(1, 2)) }),
            "scalar-splitting copy span refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[]
                {
                    OutputPiece.OriginMapped(
                        "x",
                        new[] { new PieceOrigin(0, new OriginAtom(2, 0)) }),
                }),
            "past-end mapped source slot refused by exact plan basis");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                basis,
                target,
                new[]
                {
                    OutputPiece.OriginMapped(
                        "x",
                        new[] { new PieceOrigin(0, new OriginAtom(0, 3)) }),
                }),
            "past-end mapped source atom refused by exact plan basis");
        Throws<ArgumentException>(
            () =>
            {
                var negative = OutputPiece.Copy(-1, new TextSpan(0, 1));
                RewritePlan.Create(basis, target, new[] { negative });
            },
            "negative copy source slot refused");

        Equal(
            int.MaxValue,
            RewritePlan.AddOutputLengthChecked(int.MaxValue - 1, 1),
            "checked output-length seam accepts the maximum representable length");
        Throws<OverflowException>(
            () => RewritePlan.AddOutputLengthChecked(int.MaxValue, 1),
            "checked cumulative output length refuses overflow");
        Throws<ArgumentNullException>(
            () => RewriteMaterialization.Materialize(null!),
            "null rewrite plan cannot be materialized");
    }

    private static void MaterializationCoversRequiredMaterialShapes()
    {
        var source0 = new TextMaster("k7-shapes-source", 4, "abcd");
        var source1 = new TextMaster("k7-shapes-source", 4, "abcd");
        True(source0.IsCompatibleWith(source1), "shape source slots use compatible master clones");
        var basis = OriginBasis.Create(new[]
        {
            new OriginSlot("left", source0),
            new OriginSlot("right", source1),
        });
        var pieces = new[]
        {
            OutputPiece.Copy(0, new TextSpan(2, 4)),
            OutputPiece.Copy(0, new TextSpan(0, 2)),
            OutputPiece.Copy(0, new TextSpan(1, 3)),
            OutputPiece.Copy(1, new TextSpan(0, 1)),
            OutputPiece.OriginMapped(
                "X",
                new[]
                {
                    new PieceOrigin(0, new OriginAtom(0, 0)),
                    new PieceOrigin(0, new OriginAtom(0, 1)),
                }),
            OutputPiece.OriginMapped(
                "YZ",
                new[]
                {
                    new PieceOrigin(0, new OriginAtom(0, 2)),
                    new PieceOrigin(1, new OriginAtom(0, 2)),
                }),
            OutputPiece.OriginMapped(
                "MN",
                new[]
                {
                    new PieceOrigin(0, new OriginAtom(0, 0)),
                    new PieceOrigin(0, new OriginAtom(1, 0)),
                    new PieceOrigin(1, new OriginAtom(0, 1)),
                    new PieceOrigin(1, new OriginAtom(1, 1)),
                }),
            OutputPiece.Synthetic("!", "shape terminator"),
        };
        var plan = RewritePlan.Create(
            basis,
            new MaterializationTarget("k7-shapes-output", 0, "result"),
            pieces);
        var result = RewriteMaterialization.Materialize(plan);

        Equal("cdabbcaXYZMN!", result.OutputMaster.Text, "ordered pieces determine exact output");
        Equal(8, result.Pieces.Count, "every shape piece is emitted exactly once");
        Equal(15, result.Origins.Count, "copy and mapped shape edges are all retained");
        True(!result.Origins.IsTotal, "mixed synthetic output is intentionally origin-partial");
        True(!result.Origins.IsFunctional, "contraction and many-to-many origins are nonfunctional");
        True(!result.Origins.IsInjective, "repeated and overlapping copy is noninjective");
        True(
            K7HasEdge(result.Origins, 0, 0, 2) &&
            K7HasEdge(result.Origins, 2, 0, 0) &&
            K7HasEdge(result.Origins, 4, 0, 1),
            "copy pieces support reordering and overlapping repeated use");
        True(
            K7HasEdge(result.Origins, 7, 0, 0) &&
            K7HasEdge(result.Origins, 7, 0, 1),
            "one mapped output atom can contract several source atoms");
        True(
            K7HasEdge(result.Origins, 8, 0, 2) &&
            K7HasEdge(result.Origins, 9, 0, 2),
            "mapped literal can expand one source atom into several outputs");
        True(
            K7HasEdge(result.Origins, 10, 0, 0) &&
            K7HasEdge(result.Origins, 10, 1, 0) &&
            K7HasEdge(result.Origins, 11, 0, 1) &&
            K7HasEdge(result.Origins, 11, 1, 1),
            "mapped literal retains direct many-to-many origins across compatible slots");
        True(
            !K7HasAnyOutputEdge(result.Origins, 12),
            "synthetic shape atom carries no origin edge");
        True(
            result.UnusedSources.Count == 2 && result.UnusedSources[0].Count == 0,
            "fully used first source slot has empty unused residue");
        True(
            ReferenceEquals(source1, result.UnusedSources[1].Master) &&
            result.UnusedSources[1].Count == 1 &&
            result.UnusedSources[1][0] == new TextSpan(2, 4),
            "compatible second slot retains its separate exact unused residue");

        var zeroBasis = OriginBasis.Create(Array.Empty<OriginSlot>());
        var allSyntheticPlan = RewritePlan.Create(
            zeroBasis,
            new MaterializationTarget("k7-all-synthetic", 0, "generated"),
            new[] { OutputPiece.Synthetic(" \uD800", "zero-source generation") });
        var allSynthetic = RewriteMaterialization.Materialize(allSyntheticPlan);
        Equal(" \uD800", allSynthetic.OutputMaster.Text, "all-synthetic zero-source output is legal");
        True(
            allSynthetic.Origins.IsEmpty && !allSynthetic.Origins.IsTotal &&
            allSynthetic.UnusedSources.Count == 0,
            "zero-slot all-synthetic result is locally complete without origins");
        True(
            allSynthetic.OutputBasis.Count == 1,
            "materialization creates one output slot even from a zero-slot source basis");

        Throws<ArgumentException>(
            () => RewritePlan.Create(
                zeroBasis,
                new MaterializationTarget("k7-zero-copy", 0, "out"),
                new[] { OutputPiece.Copy(0, new TextSpan(0, 1)) }),
            "zero-slot basis cannot admit copy material");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                zeroBasis,
                new MaterializationTarget("k7-zero-map", 0, "out"),
                new[]
                {
                    OutputPiece.OriginMapped(
                        "x",
                        new[] { new PieceOrigin(0, new OriginAtom(0, 0)) }),
                }),
            "zero-slot basis cannot admit mapped origins");
        True(
            pieces[0].Literal is null && pieces[0].Origins.Count == 0 &&
            pieces[4].SourceSpan is null && pieces[4].SyntheticExplanation is null &&
            pieces[7].SourceSpan is null && pieces[7].Origins.Count == 0,
            "closed factories prevent every public piece-mode confusion");
    }

    private static void MaterializationPreservesUtf16AtomBoundaries()
    {
        var sourceMaster = new TextMaster("k7-utf16-source", 0, "A😀\uD800B\uDC00C");
        var sourceBasis = K7SingletonBasis("source", sourceMaster);
        var pieces = new[]
        {
            OutputPiece.Copy(0, new TextSpan(0, 1)),
            OutputPiece.OriginMapped(
                "😀",
                new[] { new PieceOrigin(0, new OriginAtom(0, 1)) }),
            OutputPiece.OriginMapped(
                "\uD800",
                new[] { new PieceOrigin(0, new OriginAtom(0, 2)) }),
            OutputPiece.Synthetic("B", "scalar separator"),
            OutputPiece.OriginMapped(
                "\uDC00",
                new[] { new PieceOrigin(0, new OriginAtom(0, 4)) }),
        };
        var plan = RewritePlan.Create(
            sourceBasis,
            new MaterializationTarget("k7-utf16-output", 0, "out"),
            pieces);
        var result = RewriteMaterialization.Materialize(plan);

        Equal("A😀\uD800B\uDC00", result.OutputMaster.Text, "UTF-16 payload reconstructs exactly");
        Equal(5, result.OutputMaster.Topology.AtomCount, "supplementary scalar stays one output atom");
        var expectedPieceSpans = new[]
        {
            new TextSpan(0, 1),
            new TextSpan(1, 3),
            new TextSpan(3, 4),
            new TextSpan(4, 5),
            new TextSpan(5, 6),
        };
        True(
            result.Pieces.Select(piece => piece.OutputSpan).SequenceEqual(expectedPieceSpans),
            "piece spans accumulate UTF-16 widths while retaining scalar boundaries");
        True(
            K7HasEdge(result.Origins, 0, 0, 0) &&
            K7HasEdge(result.Origins, 1, 0, 1) &&
            K7HasEdge(result.Origins, 2, 0, 2) &&
            !K7HasAnyOutputEdge(result.Origins, 3) &&
            K7HasEdge(result.Origins, 4, 0, 4),
            "piece-local atom ordinals translate to global atoms rather than UTF-16 offsets");
        True(
            !result.OutputMaster.Topology.Atoms[2].IsValidScalar &&
            !result.OutputMaster.Topology.Atoms[4].IsValidScalar,
            "unpaired high and low surrogates remain first-class output atoms");

        var copiedSupplementary = RewriteMaterialization.Materialize(RewritePlan.Create(
            sourceBasis,
            new MaterializationTarget("k7-copied-supplementary", 0, "out"),
            new[] { OutputPiece.Copy(0, new TextSpan(1, 3)) }));
        True(
            copiedSupplementary.OutputMaster.Text == "😀" &&
            copiedSupplementary.OutputMaster.Topology.AtomCount == 1 &&
            copiedSupplementary.Pieces[0].OutputSpan == new TextSpan(0, 2) &&
            K7HasEdge(copiedSupplementary.Origins, 0, 0, 1),
            "copy materializes one supplementary scalar with its exact source atom");

        var zeroBasis = OriginBasis.Create(Array.Empty<OriginSlot>());
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                zeroBasis,
                new MaterializationTarget("k7-fused-boundary", 0, "out"),
                new[]
                {
                    OutputPiece.Synthetic("\uD83D", "left unpaired unit"),
                    OutputPiece.Synthetic("\uDE00", "right unpaired unit"),
                }),
            "cross-piece high-low fusion is refused");
        Throws<ArgumentException>(
            () => RewritePlan.Create(
                sourceBasis,
                new MaterializationTarget("k7-copy-literal-fusion", 0, "out"),
                new[]
                {
                    OutputPiece.Copy(0, new TextSpan(3, 4)),
                    OutputPiece.Synthetic("\uDC00", "literal low surrogate"),
                }),
            "resolved copy-high plus literal-low fusion is refused");

        var pairedPlan = RewritePlan.Create(
            zeroBasis,
            new MaterializationTarget("k7-contained-pair", 0, "out"),
            new[] { OutputPiece.Synthetic("😀", "intentional scalar") });
        var paired = RewriteMaterialization.Materialize(pairedPlan);
        True(
            paired.OutputMaster.Length == 2 && paired.OutputMaster.Topology.AtomCount == 1 &&
            paired.Pieces[0].OutputSpan == new TextSpan(0, 2),
            "the same surrogate pair is accepted within one piece");

        var highEdge = RewriteMaterialization.Materialize(RewritePlan.Create(
            zeroBasis,
            new MaterializationTarget("k7-high-edge", 0, "out"),
            new[] { OutputPiece.Synthetic("\uD800", "preserved high surrogate") }));
        var lowEdge = RewriteMaterialization.Materialize(RewritePlan.Create(
            zeroBasis,
            new MaterializationTarget("k7-low-edge", 0, "out"),
            new[] { OutputPiece.Synthetic("\uDC00", "preserved low surrogate") }));
        True(
            highEdge.OutputMaster.Topology.AtomCount == 1 &&
            lowEdge.OutputMaster.Topology.AtomCount == 1 &&
            !highEdge.OutputMaster.Topology.Atoms[0].IsValidScalar &&
            !lowEdge.OutputMaster.Topology.Atoms[0].IsValidScalar,
            "unpaired surrogates are legal at either output edge");
    }

    private static void MaterializationResultRetainsEvidenceAndComposesExactly()
    {
        var sourceMaster = new TextMaster("k7-result-source", 2, "abcde");
        var sourceBasis = K7SingletonBasis("source", sourceMaster);
        var evidenceMaster = new TextMaster("k7-unrelated-evidence", 99, "z");
        var factTable = CanonicalFactTable.Create(evidenceMaster, new[]
        {
            new FactKey(
                "k7",
                "selection",
                new[] { new TextSpan(0, 1) },
                new[] { "chosen" }),
        });
        var derivation = new FactReference(factTable, 0);
        var pieces = new[]
        {
            OutputPiece.Copy(0, new TextSpan(0, 1), derivation),
            OutputPiece.OriginMapped(
                "C",
                new[] { new PieceOrigin(0, new OriginAtom(0, 2)) },
                derivation),
            OutputPiece.Synthetic("!", "explicit punctuation", derivation),
        };
        var target = new MaterializationTarget("k7-result-output", 9, "materialized");
        var plan = RewritePlan.Create(sourceBasis, target, pieces);
        var result = RewriteMaterialization.Materialize(plan);

        True(ReferenceEquals(plan, result.Plan), "result retains exact plan stamp");
        True(
            result.OutputMaster.DocumentId == target.DocumentId &&
            result.OutputMaster.Revision == target.Revision &&
            result.OutputMaster.Text == "aC!",
            "result master reconstructs exact target identity and payload");
        True(
            result.OutputBasis.Count == 1 &&
            result.OutputBasis[0].Tag == target.OutputTag &&
            ReferenceEquals(result.OutputBasis[0].Master, result.OutputMaster),
            "result output basis is an exact singleton over its new master");
        True(
            ReferenceEquals(result.OutputBasis, result.Origins.OutputBasis) &&
            ReferenceEquals(sourceBasis, result.Origins.SourceBasis),
            "result relation retains exact output and plan-source bases");
        True(
            result.Origins.Count == 2 &&
            K7HasEdge(result.Origins, 0, 0, 0) &&
            K7HasEdge(result.Origins, 1, 0, 2) &&
            !K7HasAnyOutputEdge(result.Origins, 2),
            "result separates origin-bearing and explicitly synthetic atoms");

        var partitionValid = result.Pieces.Count == pieces.Length;
        var cursor = 0;
        var reconstructed = new StringBuilder();
        for (var i = 0; i < result.Pieces.Count; i++)
        {
            var realized = result.Pieces[i];
            partitionValid &=
                ReferenceEquals(plan, realized.Plan) &&
                realized.PieceOrdinal == i &&
                ReferenceEquals(pieces[i], realized.Piece) &&
                ReferenceEquals(result.OutputMaster, realized.OutputMaster) &&
                realized.OutputSpan.Start == cursor &&
                realized.OutputSpan.Length > 0 &&
                result.OutputMaster.IsScalarBoundary(realized.OutputSpan.Start) &&
                result.OutputMaster.IsScalarBoundary(realized.OutputSpan.End);
            reconstructed.Append(result.OutputMaster.Slice(realized.OutputSpan));
            cursor = realized.OutputSpan.End;
        }

        partitionValid &= cursor == result.OutputMaster.Length;
        True(partitionValid, "realized pieces form an exact stamped positive partition");
        Equal(result.OutputMaster.Text, reconstructed.ToString(), "realized piece slices reconstruct output");
        True(
            result.Pieces.All(piece =>
                piece.Piece.Derivation.HasValue &&
                piece.Piece.Derivation.Value == derivation &&
                ReferenceEquals(factTable, piece.Piece.Derivation.Value.Table)),
            "materialization retains exact optional derivation evidence on every piece");
        True(
            !evidenceMaster.IsCompatibleWith(sourceMaster) &&
            ReferenceEquals(evidenceMaster, factTable.Master),
            "derivation evidence may retain a fact table on an unrelated master");
        True(
            result.UnusedSources.Count == 1 &&
            ReferenceEquals(sourceMaster, result.UnusedSources[0].Master) &&
            result.UnusedSources[0].Count == 2 &&
            result.UnusedSources[0][0] == new TextSpan(1, 2) &&
            result.UnusedSources[0][1] == new TextSpan(3, 5),
            "unused source material retains disconnected normalized residue");

        var repeatedRun = RewriteMaterialization.Materialize(plan);
        True(
            !ReferenceEquals(result, repeatedRun) &&
            !ReferenceEquals(result.OutputMaster, repeatedRun.OutputMaster) &&
            result.OutputMaster.IsCompatibleWith(repeatedRun.OutputMaster) &&
            !ReferenceEquals(result.OutputBasis, repeatedRun.OutputBasis) &&
            !ReferenceEquals(result.Origins, repeatedRun.Origins) &&
            !ReferenceEquals(result.Pieces[0], repeatedRun.Pieces[0]),
            "reexecuting one exact plan mints a distinct compatible run");

        var compatibleCopyPlan = RewritePlan.Create(
            sourceBasis,
            new MaterializationTarget(
                sourceMaster.DocumentId,
                sourceMaster.Revision,
                "compatible-copy"),
            new[] { OutputPiece.Copy(0, sourceMaster.Extent) });
        var compatibleCopy = RewriteMaterialization.Materialize(compatibleCopyPlan);
        True(
            !ReferenceEquals(sourceMaster, compatibleCopy.OutputMaster) &&
            sourceMaster.IsCompatibleWith(compatibleCopy.OutputMaster),
            "materialization mints a new master even for a compatible full copy");

        var emptyPlan = RewritePlan.Create(
            sourceBasis,
            new MaterializationTarget("k7-empty-output", 0, "empty"),
            Array.Empty<OutputPiece>());
        var empty = RewriteMaterialization.Materialize(emptyPlan);
        True(
            empty.OutputMaster.Text.Length == 0 && empty.OutputBasis.Count == 1 &&
            empty.Pieces.Count == 0 && empty.Origins.IsEmpty && empty.Origins.IsTotal,
            "empty plan produces a stamped singleton empty output and empty relation");
        True(
            empty.UnusedSources.Count == 1 && empty.UnusedSources[0].Count == 1 &&
            empty.UnusedSources[0][0] == sourceMaster.Extent,
            "empty output leaves every meeting source atom unused");

        var stageSource = new TextMaster("k7-stage-source", 0, "ab");
        var stageSourceBasis = K7SingletonBasis("original", stageSource);
        var firstPlan = RewritePlan.Create(
            stageSourceBasis,
            new MaterializationTarget("k7-stage-one", 0, "stage-one"),
            new[]
            {
                OutputPiece.Copy(0, new TextSpan(0, 1)),
                OutputPiece.Synthetic("!", "first-stage synthesis"),
            });
        var first = RewriteMaterialization.Materialize(firstPlan);
        var secondPlan = RewritePlan.Create(
            first.OutputBasis,
            new MaterializationTarget("k7-stage-two", 0, "stage-two"),
            new[]
            {
                OutputPiece.Copy(0, new TextSpan(0, 1)),
                OutputPiece.Copy(0, new TextSpan(1, 2)),
            });
        var second = RewriteMaterialization.Materialize(secondPlan);
        var composed = second.Origins.ComposeOrigins(first.Origins);
        True(
            composed.Count == 1 && K7HasEdge(composed, 0, 0, 0) &&
            !K7HasAnyOutputEdge(composed, 1),
            "exact two-stage composition drops the copied synthetic atom at original-source grain");
        True(
            second.Origins.IsTotal && !composed.IsTotal &&
            second.Pieces[1].Piece.Kind == OutputPieceKind.Copy &&
            second.Pieces[1].Piece.SyntheticExplanation is null &&
            first.Pieces[1].Piece.SyntheticExplanation == "first-stage synthesis",
            "downstream copy is locally origin-bearing without inheriting synthesis explanation");
        True(
            ReferenceEquals(second.OutputBasis, composed.OutputBasis) &&
            ReferenceEquals(stageSourceBasis, composed.SourceBasis),
            "composed origins retain exact outer bases");

        var valueIdenticalMiddle = OriginBasis.Create(first.OutputBasis.Slots);
        var valueCloneSecond = RewriteMaterialization.Materialize(RewritePlan.Create(
            valueIdenticalMiddle,
            new MaterializationTarget("k7-stage-two-value-clone", 0, "stage-two"),
            new[] { OutputPiece.Copy(0, new TextSpan(0, 2)) }));
        Throws<InvalidOperationException>(
            () => valueCloneSecond.Origins.ComposeOrigins(first.Origins),
            "value-identical middle basis clone refuses stage composition");

        var compatibleMiddleMaster = new TextMaster(
            first.OutputMaster.DocumentId,
            first.OutputMaster.Revision,
            first.OutputMaster.Text);
        True(
            first.OutputMaster.IsCompatibleWith(compatibleMiddleMaster),
            "composition adversary uses a compatible middle-master clone");
        var compatibleMiddle = K7SingletonBasis(first.OutputBasis[0].Tag, compatibleMiddleMaster);
        var compatibleCloneSecond = RewriteMaterialization.Materialize(RewritePlan.Create(
            compatibleMiddle,
            new MaterializationTarget("k7-stage-two-compatible-clone", 0, "stage-two"),
            new[] { OutputPiece.Copy(0, new TextSpan(0, 2)) }));
        Throws<InvalidOperationException>(
            () => compatibleCloneSecond.Origins.ComposeOrigins(first.Origins),
            "compatible middle-master clone refuses stage composition");
    }

    private static void MaterializationMatchesIndependentFinitePlanOracle()
    {
        var leftMaster = new TextMaster("k7-census-left", 0, "L");
        var rightMaster = new TextMaster("k7-census-right", 0, "R");
        var sourceBasis = OriginBasis.Create(new[]
        {
            new OriginSlot("left", leftMaster),
            new OriginSlot("right", rightMaster),
        });
        var archetypes = new[]
        {
            OutputPiece.Copy(0, new TextSpan(0, 1)),
            OutputPiece.Copy(1, new TextSpan(0, 1)),
            OutputPiece.OriginMapped(
                "m",
                new[] { new PieceOrigin(0, new OriginAtom(0, 0)) }),
            OutputPiece.OriginMapped(
                "b",
                new[]
                {
                    new PieceOrigin(0, new OriginAtom(0, 0)),
                    new PieceOrigin(0, new OriginAtom(1, 0)),
                }),
            OutputPiece.Synthetic("s", "census synthesis"),
        };
        var target = new MaterializationTarget("k7-census-output", 0, "out");
        var payloadByCode = new[] { 'L', 'R', 'm', 'b', 's' };
        var agrees = true;
        var failure = string.Empty;
        var planCases = 0;
        var realizedPieceCases = 0;

        void Fail(string message)
        {
            if (agrees)
            {
                agrees = false;
                failure = message;
            }
        }

        for (var length = 0; length <= 3; length++)
        {
            var population = K7Power(5, length);
            for (var encoded = 0; encoded < population; encoded++)
            {
                planCases++;
                var codes = new int[length];
                var selected = new List<OutputPiece>(length);
                var expectedText = new StringBuilder(length);
                var expectedEdges = new List<OriginEdge>();
                var expectedUsed = new[] { false, false };
                var value = encoded;
                for (var position = 0; position < length; position++)
                {
                    var code = value % 5;
                    value /= 5;
                    codes[position] = code;
                    selected.Add(archetypes[code]);
                    expectedText.Append(payloadByCode[code]);

                    if (code is 0 or 2 or 3)
                    {
                        expectedEdges.Add(new OriginEdge(
                            new OriginAtom(0, position),
                            new OriginAtom(0, 0)));
                        expectedUsed[0] = true;
                    }

                    if (code is 1 or 3)
                    {
                        expectedEdges.Add(new OriginEdge(
                            new OriginAtom(0, position),
                            new OriginAtom(1, 0)));
                        expectedUsed[1] = true;
                    }
                }

                var plan = RewritePlan.Create(sourceBasis, target, selected);
                var result = RewriteMaterialization.Materialize(plan);
                realizedPieceCases += result.Pieces.Count;
                if (!StringComparer.Ordinal.Equals(expectedText.ToString(), result.OutputMaster.Text) ||
                    result.OutputMaster.Topology.AtomCount != length ||
                    result.Pieces.Count != length ||
                    result.Origins.Count != expectedEdges.Count ||
                    !ReferenceEquals(sourceBasis, result.Origins.SourceBasis) ||
                    !ReferenceEquals(result.OutputBasis, result.Origins.OutputBasis) ||
                    result.UnusedSources.Count != 2)
                {
                    Fail($"census shell mismatch at length {length}, encoding {encoded}");
                    continue;
                }

                var edgesAgree = true;
                for (var edgeOrdinal = 0; edgeOrdinal < expectedEdges.Count; edgeOrdinal++)
                {
                    edgesAgree &= result.Origins[edgeOrdinal] == expectedEdges[edgeOrdinal];
                }

                if (!edgesAgree)
                {
                    Fail($"canonical edge mismatch at length {length}, encoding {encoded}");
                }

                for (var position = 0; position < length; position++)
                {
                    var code = codes[position];
                    var expectedKind = code switch
                    {
                        0 or 1 => OutputPieceKind.Copy,
                        2 or 3 => OutputPieceKind.OriginMapped,
                        _ => OutputPieceKind.Synthetic,
                    };
                    var hasOrigin = K7HasAnyOutputEdge(result.Origins, position);
                    var isSynthetic = result.Pieces[position].Piece.Kind == OutputPieceKind.Synthetic;
                    if (result.Pieces[position].OutputSpan != new TextSpan(position, position + 1) ||
                        !ReferenceEquals(selected[position], result.Pieces[position].Piece) ||
                        result.Pieces[position].Piece.Kind != expectedKind ||
                        hasOrigin != (code != 4) ||
                        isSynthetic != (code == 4) ||
                        hasOrigin == isSynthetic)
                    {
                        Fail($"piece/coverage mismatch at length {length}, encoding {encoded}, position {position}");
                    }
                }

                for (var slot = 0; slot < 2; slot++)
                {
                    var residue = result.UnusedSources[slot];
                    var expectedMaster = slot == 0 ? leftMaster : rightMaster;
                    var residueAgrees = ReferenceEquals(expectedMaster, residue.Master) &&
                        (expectedUsed[slot]
                            ? residue.Count == 0
                            : residue.Count == 1 && residue[0] == new TextSpan(0, 1));
                    if (!residueAgrees)
                    {
                        Fail($"unused-source mismatch at length {length}, encoding {encoded}, slot {slot}");
                    }
                }
            }
        }

        Equal(156, planCases, "ordered five-archetype plan census through length three");
        Equal(430, realizedPieceCases, "ordered plan census realized-piece population");
        True(
            agrees,
            $"materialization agrees with independent ordered-plan oracle; {failure}");
    }

    private static OriginBasis K7SingletonBasis(string tag, TextMaster master) =>
        OriginBasis.Create(new[] { new OriginSlot(tag, master) });

    private static bool K7HasEdge(
        OriginRelation relation,
        int outputAtomOrdinal,
        int sourceSlotOrdinal,
        int sourceAtomOrdinal)
    {
        var expected = new OriginEdge(
            new OriginAtom(0, outputAtomOrdinal),
            new OriginAtom(sourceSlotOrdinal, sourceAtomOrdinal));
        return relation.Any(edge => edge == expected);
    }

    private static bool K7HasAnyOutputEdge(OriginRelation relation, int outputAtomOrdinal) =>
        relation.Any(edge =>
            edge.Output.SlotOrdinal == 0 && edge.Output.AtomOrdinal == outputAtomOrdinal);

    private static int K7Power(int value, int exponent)
    {
        var result = 1;
        for (var i = 0; i < exponent; i++)
        {
            result *= value;
        }

        return result;
    }
}
