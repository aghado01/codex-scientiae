using System;
using System.Collections.Generic;
using System.Linq;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static void OriginBasisAndRelationAreExactCanonicalValues()
    {
        var master = new TextMaster("k6-basis", 3, "a😀");
        var first = new OriginSlot("stage", master);
        var second = new OriginSlot("STAGE", master);
        var suppliedSlots = new List<OriginSlot> { first, second };
        var basis = OriginBasis.Create(suppliedSlots);
        suppliedSlots.Clear();

        Equal(2, basis.Count, "origin basis snapshots its ordered slots");
        True(ReferenceEquals(first, basis[0]), "origin basis retains immutable slot object");
        True(ReferenceEquals(master, basis[0].Master), "origin slot retains exact master");
        Equal("stage", basis[0].Tag, "origin slot retains ordinal tag text");
        True(basis.Slots.SequenceEqual(new[] { first, second }), "origin basis exposes frozen slot order");
        True(
            !ReferenceEquals(basis, OriginBasis.Create(new[] { first, second })),
            "value-identical origin bases retain separate identities");

        var spaced = new OriginSlot(" stage ", master);
        Equal(" stage ", spaced.Tag, "origin tags are not trimmed or case-folded");
        Throws<ArgumentException>(() => new OriginSlot("", master), "empty origin tag refused");
        Throws<ArgumentException>(() => new OriginSlot(" \t", master), "blank origin tag refused");
        Throws<ArgumentNullException>(() => new OriginSlot("stage", null!), "null origin master refused");
        Throws<ArgumentNullException>(
            () => OriginBasis.Create(null!),
            "null origin-slot sequence refused");
        Throws<ArgumentException>(
            () => OriginBasis.Create(new OriginSlot[] { first, null! }),
            "null origin slot refused");
        Throws<ArgumentException>(
            () => OriginBasis.Create(new[] { first, new OriginSlot("stage", master) }),
            "ordinally duplicate origin tags refused");
        Equal(
            2,
            OriginBasis.Create(new[] { first, second }).Count,
            "case-distinct origin tags remain separate");

        var zeroBasis = OriginBasis.Create(Array.Empty<OriginSlot>());
        Equal(0, zeroBasis.Count, "zero-slot origin basis is legal");
        Throws<ArgumentOutOfRangeException>(() => _ = zeroBasis[0], "origin basis index validated");
        Throws<ArgumentOutOfRangeException>(() => new OriginAtom(-1, 0), "negative origin slot refused");
        Throws<ArgumentOutOfRangeException>(() => new OriginAtom(0, -1), "negative text atom refused");

        var twoAtom = new TextMaster("k6-relation", 0, "ab");
        var outputBasis = OriginBasis.Create(new[]
        {
            new OriginSlot("out-0", twoAtom),
            new OriginSlot("out-1", twoAtom),
        });
        var sourceBasis = OriginBasis.Create(new[]
        {
            new OriginSlot("source-0", twoAtom),
            new OriginSlot("source-1", twoAtom),
        });
        var e00 = new OriginEdge(new OriginAtom(0, 0), new OriginAtom(1, 1));
        var e01a = new OriginEdge(new OriginAtom(0, 1), new OriginAtom(0, 1));
        var e01b = new OriginEdge(new OriginAtom(0, 1), new OriginAtom(1, 0));
        var e11 = new OriginEdge(new OriginAtom(1, 1), new OriginAtom(1, 1));
        var suppliedEdges = new List<OriginEdge> { e11, e01b, e00, e01a, e00 };
        var relation = OriginRelation.Create(outputBasis, sourceBasis, suppliedEdges);
        suppliedEdges.Clear();

        Equal(4, relation.Count, "origin relation snapshots and coalesces exact duplicate edges");
        True(ReferenceEquals(outputBasis, relation.OutputBasis), "relation retains exact output basis");
        True(ReferenceEquals(sourceBasis, relation.SourceBasis), "relation retains exact source basis");
        Equal(e00, relation[0], "canonical origin order starts with first output coordinate");
        Equal(e01a, relation[1], "canonical origin order next compares source slot");
        Equal(e01b, relation[2], "canonical origin order retains same-output alternatives");
        Equal(e11, relation[3], "canonical origin order ends with last output coordinate");
        Throws<ArgumentOutOfRangeException>(() => _ = relation[-1], "negative relation index refused");
        Throws<ArgumentOutOfRangeException>(() => _ = relation[4], "past-end relation index refused");

        var equal = OriginRelation.Create(
            outputBasis,
            sourceBasis,
            new[] { e01b, e11, e01a, e00 });
        True(relation.Equals(equal), "canonical edges and exact bases define relation equality");
        Equal(relation.GetHashCode(), equal.GetHashCode(), "equal origin relations hash equally");
        var clonedOutputBasis = OriginBasis.Create(outputBasis.Slots);
        True(
            !relation.Equals(OriginRelation.Create(clonedOutputBasis, sourceBasis, relation)),
            "value-identical output-basis clone changes relation identity");
        var clonedSourceBasis = OriginBasis.Create(sourceBasis.Slots);
        True(
            !relation.Equals(OriginRelation.Create(outputBasis, clonedSourceBasis, relation)),
            "value-identical source-basis clone changes relation identity");

        Throws<ArgumentNullException>(
            () => OriginRelation.Create(null!, sourceBasis, Array.Empty<OriginEdge>()),
            "null output basis refused");
        Throws<ArgumentNullException>(
            () => OriginRelation.Create(outputBasis, null!, Array.Empty<OriginEdge>()),
            "null source basis refused");
        Throws<ArgumentNullException>(
            () => OriginRelation.Create(outputBasis, sourceBasis, null!),
            "null origin-edge sequence refused");
        Throws<ArgumentException>(
            () => OriginRelation.Create(
                outputBasis,
                sourceBasis,
                new[] { new OriginEdge(new OriginAtom(2, 0), new OriginAtom(0, 0)) }),
            "past-end output slot refused");
        Throws<ArgumentException>(
            () => OriginRelation.Create(
                outputBasis,
                sourceBasis,
                new[] { new OriginEdge(new OriginAtom(0, 2), new OriginAtom(0, 0)) }),
            "past-end output atom refused");
        Throws<ArgumentException>(
            () => OriginRelation.Create(
                outputBasis,
                sourceBasis,
                new[] { new OriginEdge(new OriginAtom(0, 0), new OriginAtom(2, 0)) }),
            "past-end source slot refused");
        Throws<ArgumentException>(
            () => OriginRelation.Create(
                outputBasis,
                sourceBasis,
                new[] { new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 2)) }),
            "past-end source atom refused");

        var none = OriginRelation.None(outputBasis, sourceBasis);
        True(none.IsEmpty && none.IsFunctional && none.IsInjective, "empty origin relation is partial");
        True(!none.IsTotal, "empty relation over populated output basis is not total");
        var identity = OriginRelation.Identity(outputBasis);
        Equal(4, identity.Count, "identity covers every atom of every tagged slot");
        True(
            ReferenceEquals(outputBasis, identity.OutputBasis) &&
            ReferenceEquals(outputBasis, identity.SourceBasis),
            "identity carries one exact basis on both sides");
        True(identity.IsFunctional && identity.IsTotal && identity.IsInjective, "identity shape queries");

        var zeroIdentity = OriginRelation.Identity(zeroBasis);
        True(
            zeroIdentity.IsEmpty && zeroIdentity.IsFunctional &&
            zeroIdentity.IsTotal && zeroIdentity.IsInjective,
            "zero-slot identity is vacuously total and one-to-one");
        var emptyMaster = new TextMaster("k6-empty", 0, string.Empty);
        var emptySingleton = K6SingletonBasis("empty", emptyMaster);
        var emptyIdentity = OriginRelation.Identity(emptySingleton);
        True(
            emptyIdentity.IsEmpty && emptyIdentity.IsTotal,
            "singleton empty-master basis differs from zero-slot basis but has empty identity");
        True(
            !ReferenceEquals(zeroIdentity.OutputBasis, emptyIdentity.OutputBasis),
            "zero-slot and singleton empty-master stamps remain distinct");
    }

    private static void OriginCompositionMatchesIndependentBooleanMatrixOracle()
    {
        var masterA = new TextMaster("k6-matrix-a", 0, "ab");
        var masterB = new TextMaster("k6-matrix-b", 0, "cd");
        var masterC = new TextMaster("k6-matrix-c", 0, "ef");
        var masterD = new TextMaster("k6-matrix-d", 0, "gh");
        var a = K6SingletonBasis("A", masterA);
        var b = K6SingletonBasis("B", masterB);
        var c = K6SingletonBasis("C", masterC);
        var d = K6SingletonBasis("D", masterD);
        var ab = new OriginRelation[16];
        var bc = new OriginRelation[16];
        var cd = new OriginRelation[16];
        for (var mask = 0; mask < 16; mask++)
        {
            ab[mask] = K6RelationFromMask(a, b, mask);
            bc[mask] = K6RelationFromMask(b, c, mask);
            cd[mask] = K6RelationFromMask(c, d, mask);
        }

        var agrees = true;
        var failure = string.Empty;
        var relationCases = 0;
        var pairCases = 0;
        var tripleCases = 0;

        void Fail(string message)
        {
            if (agrees)
            {
                agrees = false;
                failure = message;
            }
        }

        for (var mask = 0; mask < 16; mask++)
        {
            relationCases++;
            var relation = ab[mask];
            if (K6MaskOf(relation) != mask ||
                relation.IsFunctional != K6MaskIsFunctional(mask) ||
                relation.IsTotal != K6MaskIsTotal(mask) ||
                relation.IsInjective != K6MaskIsInjective(mask) ||
                !OriginRelation.Identity(a).ComposeOrigins(relation).Equals(relation) ||
                !relation.ComposeOrigins(OriginRelation.Identity(b)).Equals(relation))
            {
                Fail($"relation/identity mismatch at mask {mask}");
            }

            for (var nextMask = 0; nextMask < 16; nextMask++)
            {
                pairCases++;
                var expected = K6ComposeMask(mask, nextMask);
                var composed = relation.ComposeOrigins(bc[nextMask]);
                if (K6MaskOf(composed) != expected ||
                    !ReferenceEquals(a, composed.OutputBasis) ||
                    !ReferenceEquals(c, composed.SourceBasis))
                {
                    Fail($"composition mismatch at masks {mask}, {nextMask}");
                }

                if (relation.IsFunctional && relation.IsTotal &&
                    bc[nextMask].IsFunctional && bc[nextMask].IsTotal &&
                    (!composed.IsFunctional || !composed.IsTotal))
                {
                    Fail($"functional-total closure mismatch at masks {mask}, {nextMask}");
                }

                for (var lastMask = 0; lastMask < 16; lastMask++)
                {
                    tripleCases++;
                    var leftAssociated = composed.ComposeOrigins(cd[lastMask]);
                    var rightAssociated = relation.ComposeOrigins(
                        bc[nextMask].ComposeOrigins(cd[lastMask]));
                    var tripleExpected = K6ComposeMask(expected, lastMask);
                    if (!leftAssociated.Equals(rightAssociated) ||
                        K6MaskOf(leftAssociated) != tripleExpected)
                    {
                        Fail(
                            $"associativity mismatch at masks {mask}, {nextMask}, {lastMask}");
                    }
                }
            }
        }

        Equal(16, relationCases, "complete two-by-two origin-relation census");
        Equal(256, pairCases, "complete composable origin-relation pair census");
        Equal(4096, tripleCases, "complete composable origin-relation triple census");
        True(agrees, $"origin composition agrees with independent Boolean-matrix oracle; {failure}");

        var sameMasterClone = OriginBasis.Create(b.Slots);
        var sameValueNext = K6RelationFromMask(sameMasterClone, c, 9);
        Throws<InvalidOperationException>(
            () => ab[9].ComposeOrigins(sameValueNext),
            "value-identical middle-basis clone refused");

        var compatibleMasterClone = new TextMaster(
            masterB.DocumentId,
            masterB.Revision,
            masterB.Text);
        True(masterB.IsCompatibleWith(compatibleMasterClone), "middle-master adversary is compatible");
        var compatibleBasisClone = K6SingletonBasis("B", compatibleMasterClone);
        Throws<InvalidOperationException>(
            () => ab[9].ComposeOrigins(K6RelationFromMask(compatibleBasisClone, c, 9)),
            "compatible middle-master clone refused");
        Throws<ArgumentNullException>(
            () => ab[9].ComposeOrigins(null!),
            "null next origin relation refused");

        var duplicateWitnessLeft = K6RelationFromMask(a, b, 3);
        var duplicateWitnessRight = K6RelationFromMask(b, c, 5);
        Equal(
            K6PopCount(K6ComposeMask(3, 5)),
            duplicateWitnessLeft.ComposeOrigins(duplicateWitnessRight).Count,
            "composition forgets duplicate middle witnesses");
    }

    private static void OriginProjectionPreservesMaterialShapeAndSlotIdentity()
    {
        var outputMaster = new TextMaster("k6-projection-output", 0, "xyz");
        var source0 = new TextMaster("k6-projection-source", 4, "a😀bc");
        var source1 = new TextMaster("k6-projection-source", 4, "a😀bc");
        True(source0.IsCompatibleWith(source1), "projection source-slot masters are compatible clones");
        var output = K6SingletonBasis("output", outputMaster);
        var source = OriginBasis.Create(new[]
        {
            new OriginSlot("left", source0),
            new OriginSlot("right", source1),
        });
        var relation = OriginRelation.Create(output, source, new[]
        {
            new OriginEdge(new OriginAtom(0, 1), new OriginAtom(1, 2)),
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 3)),
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 1)),
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 0)),
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(1, 2)),
        });

        True(!relation.IsFunctional, "contraction is represented as one output with many origins");
        True(!relation.IsTotal, "an output atom may explicitly have zero declared origin");
        True(!relation.IsInjective, "duplication is represented as several outputs sharing an origin");

        var first = relation.ProjectSources(0, new TextSpan(0, 1));
        True(ReferenceEquals(relation, first.Relation), "projection retains exact relation stamp");
        Equal(0, first.OutputSlotOrdinal, "projection retains selected output slot");
        Equal(new TextSpan(0, 1), first.OutputSpan, "projection retains selected output span");
        Equal(2, first.Count, "projection retains one entry per source slot");
        True(ReferenceEquals(source0, first[0].Master), "first source slot retains exact master");
        True(ReferenceEquals(source1, first[1].Master), "compatible second slot remains distinct");
        Equal(2, first[0].Count, "disconnected source material is not replaced by its hull");
        Equal(new TextSpan(0, 3), first[0][0], "meeting source atoms normalize into one span");
        Equal(new TextSpan(4, 5), first[0][1], "disconnected source atom remains separate");
        Equal(1, first[1].Count, "second compatible slot has its own projection entry");
        Equal(new TextSpan(3, 4), first[1][0], "second slot projects its own source atom");
        True(
            ReferenceEquals(first[0], first.SourceRegions[0]),
            "source-region view exposes the frozen projection entries");

        var firstTwo = relation.ProjectSources(0, new TextSpan(0, 2));
        Equal(1, firstTwo[1].Count, "repeated source atom through two outputs coalesces in projection");
        var noOrigin = relation.ProjectSources(0, new TextSpan(2, 3));
        True(noOrigin.All(region => region.Count == 0), "zero-origin output projects to no source material");
        var empty = relation.ProjectSources(0, new TextSpan(1, 1));
        True(empty.All(region => region.Count == 0), "empty output span selects no atoms");

        Throws<ArgumentOutOfRangeException>(
            () => relation.ProjectSources(-1, new TextSpan(0, 0)),
            "negative projection output slot refused");
        Throws<ArgumentOutOfRangeException>(
            () => relation.ProjectSources(1, new TextSpan(0, 0)),
            "past-end projection output slot refused");
        Throws<ArgumentOutOfRangeException>(
            () => relation.ProjectSources(0, new TextSpan(0, 4)),
            "out-of-bounds projection span refused");

        var scalarOutput = K6SingletonBasis(
            "scalar-output",
            new TextMaster("k6-projection-scalar", 0, "😀"));
        var scalarRelation = OriginRelation.None(scalarOutput, OriginBasis.Create(Array.Empty<OriginSlot>()));
        Throws<ArgumentException>(
            () => scalarRelation.ProjectSources(0, new TextSpan(1, 1)),
            "projection span must be scalar-bounded even when empty");

        var zeroSourceRelation = OriginRelation.None(
            output,
            OriginBasis.Create(Array.Empty<OriginSlot>()));
        Equal(
            0,
            zeroSourceRelation.ProjectSources(0, new TextSpan(0, 1)).Count,
            "zero-slot source basis projects to a zero-entry image");
        var emptySourceMaster = new TextMaster("k6-projection-empty", 0, string.Empty);
        var emptySourceRelation = OriginRelation.None(
            output,
            K6SingletonBasis("empty", emptySourceMaster));
        var emptySourceProjection = emptySourceRelation.ProjectSources(0, new TextSpan(0, 1));
        Equal(1, emptySourceProjection.Count, "singleton empty source retains one projection entry");
        True(
            emptySourceProjection[0].Count == 0 &&
            ReferenceEquals(emptySourceMaster, emptySourceProjection[0].Master),
            "singleton empty source projection retains exact empty master");

        var oneOutput = K6SingletonBasis(
            "one-output",
            new TextMaster("k6-one-output", 0, "x"));
        var oneSource0 = new TextMaster("k6-one-source", 0, "q");
        var oneSource1 = new TextMaster("k6-one-source", 0, "q");
        var duplicateCompatibleSlots = OriginBasis.Create(new[]
        {
            new OriginSlot("first", oneSource0),
            new OriginSlot("second", oneSource1),
        });
        var bothSlots = OriginRelation.Create(oneOutput, duplicateCompatibleSlots, new[]
        {
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 0)),
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(1, 0)),
        });
        var bothProjection = bothSlots.ProjectSources(0, new TextSpan(0, 1));
        True(
            bothProjection.Count == 2 &&
            bothProjection[0].Count == 1 &&
            bothProjection[1].Count == 1,
            "compatible one-atom source slots remain distinct relation coordinates");
        True(
            ReferenceEquals(oneSource0, bothProjection[0].Master) &&
            ReferenceEquals(oneSource1, bothProjection[1].Master),
            "compatible projected slots retain their separate exact masters");
        True(
            bothSlots.IsTotal && !bothSlots.IsFunctional && bothSlots.IsInjective,
            "one-to-many contraction shape queries remain explicit");

        var duplicateOutput = K6SingletonBasis(
            "duplicate-output",
            new TextMaster("k6-duplicate-output", 0, "uv"));
        var duplicateSource = K6SingletonBasis(
            "duplicate-source",
            new TextMaster("k6-duplicate-source", 0, "q"));
        var duplication = OriginRelation.Create(duplicateOutput, duplicateSource, new[]
        {
            new OriginEdge(new OriginAtom(0, 0), new OriginAtom(0, 0)),
            new OriginEdge(new OriginAtom(0, 1), new OriginAtom(0, 0)),
        });
        True(
            duplication.IsFunctional && duplication.IsTotal && !duplication.IsInjective,
            "many-to-one duplication shape queries remain explicit");
    }

    private static void TextSliceEmbedsAsExactFunctionalOrigin()
    {
        var parent = new TextMaster("k6-slice-parent", 8, "xA😀\uD800By");
        var slice = TextSlice.Create(parent, new TextSpan(1, 6));
        var childBasis = K6SingletonBasis("child", slice.Child);
        var parentBasis = K6SingletonBasis("parent", parent);
        var relation = OriginRelation.FromTextSlice(slice, childBasis, parentBasis);

        Equal(slice.Child.Topology.AtomCount, relation.Count, "slice embeds every child atom once");
        True(relation.IsFunctional && relation.IsTotal && relation.IsInjective, "slice origin is bijective");
        True(
            ReferenceEquals(childBasis, relation.OutputBasis) &&
            ReferenceEquals(parentBasis, relation.SourceBasis),
            "slice origin retains exact supplied bases");
        var orderPreserved = true;
        for (var i = 0; i < relation.Count; i++)
        {
            var edge = relation[i];
            var childAtom = slice.Child.Topology.Atoms[edge.Output.AtomOrdinal];
            var parentAtom = parent.Topology.Atoms[edge.Source.AtomOrdinal];
            if (edge.Output.SlotOrdinal != 0 ||
                edge.Source.SlotOrdinal != 0 ||
                slice.ToParent(childAtom.Span) != parentAtom.Span ||
                (i > 0 && relation[i - 1].Source.AtomOrdinal >= edge.Source.AtomOrdinal))
            {
                orderPreserved = false;
            }
        }

        True(orderPreserved, "slice atom origins agree with rebase and preserve order");
        var projectedWindow = relation.ProjectSources(0, slice.Child.Extent);
        True(
            projectedWindow.Count == 1 &&
            projectedWindow[0].Count == 1 &&
            projectedWindow[0][0] == slice.Window,
            "whole child projection recovers the exact parent window");

        Throws<ArgumentNullException>(
            () => OriginRelation.FromTextSlice(null!, childBasis, parentBasis),
            "null slice origin adapter input refused");
        Throws<ArgumentNullException>(
            () => OriginRelation.FromTextSlice(slice, null!, parentBasis),
            "null child origin basis refused");
        Throws<ArgumentNullException>(
            () => OriginRelation.FromTextSlice(slice, childBasis, null!),
            "null parent origin basis refused");
        Throws<InvalidOperationException>(
            () => OriginRelation.FromTextSlice(
                slice,
                OriginBasis.Create(Array.Empty<OriginSlot>()),
                parentBasis),
            "slice adapter refuses zero-slot child basis");
        Throws<InvalidOperationException>(
            () => OriginRelation.FromTextSlice(
                slice,
                childBasis,
                OriginBasis.Create(new[]
                {
                    new OriginSlot("parent-0", parent),
                    new OriginSlot("parent-1", parent),
                })),
            "slice adapter refuses multi-slot parent basis");

        var compatibleChild = new TextMaster(
            slice.Child.DocumentId,
            slice.Child.Revision,
            slice.Child.Text);
        True(slice.Child.IsCompatibleWith(compatibleChild), "slice child adversary is compatible");
        Throws<InvalidOperationException>(
            () => OriginRelation.FromTextSlice(
                slice,
                K6SingletonBasis("child", compatibleChild),
                parentBasis),
            "compatible child-master clone refused by slice adapter");
        var compatibleParent = new TextMaster(parent.DocumentId, parent.Revision, parent.Text);
        True(parent.IsCompatibleWith(compatibleParent), "slice parent adversary is compatible");
        Throws<InvalidOperationException>(
            () => OriginRelation.FromTextSlice(
                slice,
                childBasis,
                K6SingletonBasis("parent", compatibleParent)),
            "compatible parent-master clone refused by slice adapter");

        var emptySlice = TextSlice.Create(parent, new TextSpan(1, 1));
        var emptyRelation = OriginRelation.FromTextSlice(
            emptySlice,
            K6SingletonBasis("empty-child", emptySlice.Child),
            parentBasis);
        True(
            emptyRelation.IsEmpty && emptyRelation.IsFunctional &&
            emptyRelation.IsTotal && emptyRelation.IsInjective,
            "empty slice embeds as empty relation on a zero-atom singleton output basis");

        var outer = TextSlice.Create(parent, new TextSpan(1, 6));
        var inner = TextSlice.Create(outer.Child, new TextSpan(1, 4));
        var innerBasis = K6SingletonBasis("inner", inner.Child);
        var middleBasis = K6SingletonBasis("middle", outer.Child);
        var rootBasis = K6SingletonBasis("root", parent);
        var innerToMiddle = OriginRelation.FromTextSlice(inner, innerBasis, middleBasis);
        var middleToRoot = OriginRelation.FromTextSlice(outer, middleBasis, rootBasis);
        var composed = innerToMiddle.ComposeOrigins(middleToRoot);
        var directEdges = new List<OriginEdge>();
        for (var atomOrdinal = 0; atomOrdinal < inner.Child.Topology.AtomCount; atomOrdinal++)
        {
            var innerSpan = inner.Child.Topology.Atoms[atomOrdinal].Span;
            var rootSpan = outer.ToParent(inner.ToParent(innerSpan));
            directEdges.Add(new OriginEdge(
                new OriginAtom(0, atomOrdinal),
                new OriginAtom(0, K6FindAtomOrdinal(parent, rootSpan))));
        }

        var direct = OriginRelation.Create(innerBasis, rootBasis, directEdges);
        True(composed.Equals(direct), "slice-chain composition equals direct atom translation");
        var directProjection = composed.ProjectSources(0, inner.Child.Extent);
        var expectedRootSpan = outer.ToParent(inner.ToParent(inner.Child.Extent));
        True(
            directProjection.Count == 1 &&
            directProjection[0].Count == 1 &&
            directProjection[0][0] == expectedRootSpan,
            "slice-chain projection recovers the directly rebased ancestor span");

        var middleClone = OriginBasis.Create(middleBasis.Slots);
        var clonedMiddleToRoot = OriginRelation.FromTextSlice(outer, middleClone, rootBasis);
        Throws<InvalidOperationException>(
            () => innerToMiddle.ComposeOrigins(clonedMiddleToRoot),
            "slice-chain composition requires reuse of the exact middle basis");
    }

    private static OriginBasis K6SingletonBasis(string tag, TextMaster master) =>
        OriginBasis.Create(new[] { new OriginSlot(tag, master) });

    private static OriginRelation K6RelationFromMask(
        OriginBasis outputBasis,
        OriginBasis sourceBasis,
        int mask)
    {
        var edges = new List<OriginEdge>();
        for (var output = 0; output < 2; output++)
        {
            for (var source = 0; source < 2; source++)
            {
                if ((mask & (1 << ((output * 2) + source))) != 0)
                {
                    edges.Add(new OriginEdge(
                        new OriginAtom(0, output),
                        new OriginAtom(0, source)));
                }
            }
        }

        return OriginRelation.Create(outputBasis, sourceBasis, edges);
    }

    private static int K6MaskOf(OriginRelation relation)
    {
        var mask = 0;
        foreach (var edge in relation)
        {
            if (edge.Output.SlotOrdinal != 0 || edge.Source.SlotOrdinal != 0 ||
                (uint)edge.Output.AtomOrdinal >= 2 || (uint)edge.Source.AtomOrdinal >= 2)
            {
                return -1;
            }

            mask |= 1 << ((edge.Output.AtomOrdinal * 2) + edge.Source.AtomOrdinal);
        }

        return mask;
    }

    private static int K6ComposeMask(int left, int right)
    {
        var result = 0;
        for (var output = 0; output < 2; output++)
        {
            for (var source = 0; source < 2; source++)
            {
                var related = false;
                for (var middle = 0; middle < 2; middle++)
                {
                    var leftBit = 1 << ((output * 2) + middle);
                    var rightBit = 1 << ((middle * 2) + source);
                    related |= (left & leftBit) != 0 && (right & rightBit) != 0;
                }

                if (related)
                {
                    result |= 1 << ((output * 2) + source);
                }
            }
        }

        return result;
    }

    private static bool K6MaskIsFunctional(int mask)
    {
        for (var output = 0; output < 2; output++)
        {
            var row = (mask >> (output * 2)) & 3;
            if (K6PopCount(row) > 1)
            {
                return false;
            }
        }

        return true;
    }

    private static bool K6MaskIsTotal(int mask) =>
        (mask & 3) != 0 && (mask & 12) != 0;

    private static bool K6MaskIsInjective(int mask)
    {
        for (var source = 0; source < 2; source++)
        {
            var count = ((mask >> source) & 1) + ((mask >> (2 + source)) & 1);
            if (count > 1)
            {
                return false;
            }
        }

        return true;
    }

    private static int K6PopCount(int value)
    {
        var count = 0;
        while (value != 0)
        {
            count += value & 1;
            value >>= 1;
        }

        return count;
    }

    private static int K6FindAtomOrdinal(TextMaster master, TextSpan span)
    {
        for (var atomOrdinal = 0; atomOrdinal < master.Topology.AtomCount; atomOrdinal++)
        {
            if (master.Topology.Atoms[atomOrdinal].Span == span)
            {
                return atomOrdinal;
            }
        }

        throw new InvalidOperationException($"No atom occupies {span}.");
    }
}
