using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static int _checks;

    public static int Main()
    {
        try
        {
            MasterTopologyIsTotal();
            TilingReconstructsAndAgreesWithLines();
            LaminarAdmissionIsDeterministicAndStamped();
            RunViewsTileTheMasterUnderEveryBreakKey();
            LazySubstrateDefersUntouchedWork();
            FrozenBatchPreservesClaims();
            InternedColumnsRoundTripClaimStrings();
            SpanSetObeysBooleanLawsAndMasterIdentity();
            SpanSetRandomizedLawsHold();
            AllenRelationsAreCompleteAndInvertible();
            AllenRelationSetHasAClosedValueSurface();
            AllenRelationSetBooleanLawsHoldExhaustively();
            AllenRelationSetConverseAgreesWithTheClassifier();
            AllenClassifierIsJepdOnSixBoundaries();
            AllenCompositionMatchesIndependentD6Oracle();
            AllenCompositionLawsHold();
            AllenCanonicalCompositionIsNotFiniteMasterComposition();
            StructuralValidatorsKeepTheirDistinctInvariants();
            ScopedRegexCollectionCannotBridgeGaps();
            SuppressionIsAQueryWithIdempotenceAndDuality();
            DefectiveRuleFailsAtLoadTimeWithoutSideEffects();
            ExecutionScopeComposesWithTheCallerRegionSet();
            JsonlInventoryLoadsAndFailsWithProvenance();
            DeclarativeValidationRunsWithoutDomainCode();
            CollectionCommitsAtomically();
            UnknownCaptureGroupFailsAtValidation();
            UndefinedEnumValuesAreRejected();
            EmptySpansHaveSetSemantics();
            ReferenceJoinRelatesEveryPair();
            ProjectMapsSpansOntoLineRanges();
            EmitRunsHonorsACustomComparer();
            RegexOptionsUnionCultureInvariantAtTheEngineBoundary();
            SliceMintsAFragmentLocalChild();
            RebaseIsATotalBijection();
            RebaseCarriesSetsAndBatches();
            CollectionCommutesWithRebase();
            SlicesCompose();
            GroupingByKeyIsADeterministicPartition();
            ProjectionAndLineGroupsAreStampedTransposes();
            LineMembershipIsADeclaredPolicy();
            GapCadenceMeasuresTheTemplateFacts();
            GapCadenceDeclaresItsBasis();
            LookupOrderIsAQueryPolicy();
            ClaimSelectionIsAnExactBatchValue();
            ClaimSelectionBooleanLawsHoldExhaustively();
            ClaimSelectionSeparatesMembershipFromOrderedProjection();
            SelectionPopulationIntegrationsShareOnePath();
            ClaimPairViewIsAnExactBasisStampedRelation();
            ClaimPairViewProjectsSemijoinsAndConverse();
            ClaimPairCompositionMatchesItsIndependentOracleAndWitnesses();
            ClaimPairCompositionLawsHoldOnBoundedRelations();
            ClaimPairAllenAbstractionBridgeIsOneWay();
            PairingWitnessesTwoDelimiterFamilies();
            PairingFaultResidueIsCompleteAndTopOnly();
            PairingRefusesAmbiguousInputsAndRetainsItsStamps();
            PairingMatchesAnIndependentBoundedStackOracle();
            LocatedRelationHasAConcreteBasisAndReferenceAlgebra();
            LocatedRelationMatchesBoundedExhaustiveOracles();
            LocatedRelationRebasesExactlyThroughSlices();
            CandidateRegionGraphPreservesOccurrenceIdentityUntilProjection();
            ReachabilityViewKeepsGraphStampAndDiagnostics();
            PartitionViewValidatesExactIdentityBearingPaths();
            FirstOrdinalSegmentationWitnessesRequiredCases();
            FirstOrdinalSegmentationMatchesBoundedPathOracle();
            AdditivePathPolicySnapshotsAnExactObjective();
            PathSelectionProblemValidatesExactAdmissibility();
            AdditivePathSelectionRetainsDecisionsAndResiduals();
            AdditivePathSelectionMatchesBoundedOptimizerOracle();
            StructuralValidatorsMatchBoundedOracles();
            LaminarAdmissionMatchesBoundedOracle();
            NearestContainerProjectionIsExplicit();
            HierarchyViewRetainsExplicitDag();
            HierarchyViewMatchesBoundedDagOracle();
            ResolutionMapsSeparateIncidenceFromAggregation();
            ResolutionIncidenceMatchesBoundedEndpointOracle();
            FactKeyIsAMasterRelativeSemanticValue();
            CanonicalFactTableCollapsesAndOrdersProposals();
            CanonicalFactTableEqualityIsProposalOrderIndependent();
            FactReferenceIsAnExactTableHandle();
            SupportEdgeIsAnOrderedEvidenceValue();
            SupportHypergraphValidatesExactBasesAndRetainsAlternatives();
            K5aHierarchyDiamondWitnessSuppliesAncestorSupport();
            GroundRuleIsAnOrderedGroundEvidenceValue();
            SaturationProblemValidatesAndCanonicalizesRules();
            FactSaturationHandlesFinitePositiveClosure();
            FactSaturationRetainsCompleteEnabledSupport();
            FactSaturationRebasesThroughKeyOrderShifts();
            FactSaturationIsPermutationIndependent();
            K5bHierarchyDiamondSaturatesCanonically();
            FactSaturationMatchesIndependentBoundedOracle();
            BooleanVectorIsALogicalSequenceValue();
            BooleanVectorAlgebraMatchesIndependentOracle();
            BooleanPrefixParityMatchesIndependentOracle();
            BooleanVectorLongAndTailCasesMatchOracle();
            Utf16UnitMaskEnforcesBasisAndTypedContinuity();
            Utf16UnitClassificationPropagatesUncertainty();
            Utf16UnitHarvestIsScalarSafeAndComplete();
            Utf16ClaimEmissionIsTransactionalAndEvidenceBearing();
            BooleanVectorSupportsATestLocalByteBasis();
            Console.WriteLine($"doccer contract harness: {_checks} checks passed");
            return 0;
        }
        catch (Exception exception)
        {
            Console.Error.WriteLine(exception);
            return 1;
        }
    }

    private static void MasterTopologyIsTotal()
    {
        var master = new TextMaster("topology", 0, "a😀\r\nb");
        Equal(5, master.Topology.AtomCount, "Unicode atom count");
        Equal(2, master.Topology.LineCount, "line count");
        Equal(new TextSpan(1, 3), master.Topology.Atoms[1].Span, "SMP scalar extent");
        True(master.Topology.Atoms[1].IsValidScalar, "SMP scalar validity");
        Equal(master.Length, master.Topology.Atoms[^1].Span.End, "atom coverage end");
        Throws<ArgumentException>(
            () => master.ValidateSpan(new TextSpan(2, 3)),
            "surrogate split rejected");

        var malformed = new TextMaster("malformed", 0, "x\uD800y");
        True(!malformed.Topology.Atoms[1].IsValidScalar, "unpaired surrogate retained and marked");
        Equal(malformed.Length, malformed.Topology.Atoms.Sum(atom => atom.Span.Length), "malformed coverage");

        var loneHigh = new TextMaster("surrogate-identity", 0, "x\uD800y");
        var loneLow = new TextMaster("surrogate-identity", 0, "x\uDC00y");
        True(
            !StringComparer.Ordinal.Equals(loneHigh.Fingerprint, loneLow.Fingerprint),
            "lone-surrogate fingerprints differ");
        True(!loneHigh.IsCompatibleWith(loneLow), "lone-surrogate masters incompatible");
    }

    /// <summary>
    /// Tier-1 reconstruction and line consistency over texts chosen for their boundary behaviour:
    /// every line-terminator form, CRLF as one break, SMP scalars, both lone surrogates, a
    /// combining sequence, and the empty and trailing-break degenerate cases.
    /// </summary>
    private static readonly string[] Tier1Fixtures =
    {
        string.Empty,
        "a",
        "\n",
        "\r\n",
        "\r",
        "a\r\nb\nc\rd\u0085e\u2028f\u2029g",
        "Hello, world!",
        "x\uD800y\uDC00z",
        "e\u0301 versus \u00e9",
        "\U0001F600\r\n\U0001F600",
        "line one\nline two\n",
        "  \t \u00a0 ",
    };

    private static void TilingReconstructsAndAgreesWithLines()
    {
        for (var fixture = 0; fixture < Tier1Fixtures.Length; fixture++)
        {
            var text = Tier1Fixtures[fixture];
            var master = new TextMaster($"tier1-{fixture}", 0, text);
            var topology = master.Topology;

            // (a) Reconstruction: the atom tiling is total, gapless, and concatenates to the master.
            var reconstructed = new StringBuilder();
            var cursor = 0;
            var contiguous = true;
            foreach (var atom in topology.Atoms)
            {
                if (atom.Span.Start != cursor)
                {
                    contiguous = false;
                }

                cursor = atom.Span.End;
                reconstructed.Append(master.Slice(atom.Span));
            }

            True(contiguous, $"fixture {fixture}: atoms tile without gap or overlap");
            Equal(master.Length, cursor, $"fixture {fixture}: atoms tile to the master end");
            Equal(text, reconstructed.ToString(), $"fixture {fixture}: atoms reconstruct the master text");

            // (b) Line consistency: each atom's recorded line is the line its start resolves to.
            var agrees = true;
            foreach (var atom in topology.Atoms)
            {
                if (topology.GetLineIndex(atom.Span.Start) != atom.LineIndex)
                {
                    agrees = false;
                }
            }

            True(agrees, $"fixture {fixture}: every atom's line index matches its start offset");

            // Line extents partition [0, length): contiguous, from zero, reaching the end.
            var lineCursor = 0;
            var partitions = true;
            for (var line = 0; line < topology.LineCount; line++)
            {
                var extent = topology.GetLineExtent(line);
                if (extent.Start != lineCursor)
                {
                    partitions = false;
                }

                lineCursor = extent.End;
            }

            True(partitions, $"fixture {fixture}: line extents are contiguous from zero");
            Equal(master.Length, lineCursor, $"fixture {fixture}: line extents reach the master end");

            // And every offset resolves into the extent of the line it reports.
            var consistent = true;
            for (var offset = 0; offset < master.Length; offset++)
            {
                if (!topology.GetLineExtent(topology.GetLineIndex(offset)).Contains(offset))
                {
                    consistent = false;
                }
            }

            True(consistent, $"fixture {fixture}: every offset lies in its own line's extent");
        }
    }

    private static void LaminarAdmissionIsDeterministicAndStamped()
    {
        var master = new TextMaster("determinism", 0, new string('x', 64));
        var random = new Random(20260801);
        var builder = new SpanBatchBuilder(master);
        for (var i = 0; i < 60; i++)
        {
            var start = random.Next(0, master.Length - 1);
            var end = random.Next(start + 1, master.Length + 1);
            builder.Add(new SpanClaim(
                new TextSpan(start, end),
                $"kind-{random.Next(0, 4)}",
                SpanLevel.MultiLine,
                $"source-{random.Next(0, 3)}",
                random.Next(0, 4)));
        }

        var batch = builder.Freeze();
        var familyPolicy = new LaminarFamilyPolicy("no-proper-crossing");
        var admissionPolicy = LaminarAdmissionPolicy.PriorityThenGeometry(
            "priority-then-geometry",
            familyPolicy);
        var candidates = ClaimSelection.All(batch);
        var first = Laminarizer.Admit(candidates, master.Extent, admissionPolicy);
        var second = Laminarizer.Admit(candidates, master.Extent, admissionPolicy);

        Equal(
            Ordinals(first.AcceptedCandidates),
            Ordinals(second.AcceptedCandidates),
            "accepted membership is reproducible");
        Equal(Ordinals(first.CrossingResidue), Ordinals(second.CrossingResidue), "residue ordering is reproducible");
        True(first.Accepted.Count > 0 && first.CrossingResidue.Count > 0,
            "the fixture exercises both admission outcomes");
        True(ReferenceEquals(first.Candidates, candidates) &&
             ReferenceEquals(first.Basis, batch) &&
             ReferenceEquals(first.Policy, admissionPolicy) &&
             ReferenceEquals(first.Accepted.Policy, familyPolicy) &&
             first.Window == master.Extent &&
             first.Guarantee == LaminarAdmissionGuarantee.InclusionMaximal &&
             first.Order == LaminarAdmissionOrder.PriorityThenGeometry,
            "laminar admission retains exact population, basis, window, and policy stamps");

        True(first.AcceptedCandidates.Intersect(first.CrossingResidue).IsEmpty &&
             first.AcceptedCandidates.Union(first.CrossingResidue).Equals(candidates),
            "accepted claims and crossing residue partition the candidate selection");

        // The same claims in the same order over a fresh batch resolve identically: determinism is
        // a property of the ordering rules, not of one object's identity.
        var replayBuilder = new SpanBatchBuilder(master);
        foreach (var record in batch)
        {
            replayBuilder.Add(record.ToClaim());
        }

        var replayBatch = replayBuilder.Freeze();
        var replay = Laminarizer.Admit(
            ClaimSelection.All(replayBatch),
            replayBatch.Master.Extent,
            admissionPolicy);
        Equal(Ordinals(first.AcceptedCandidates), Ordinals(replay.AcceptedCandidates),
            "replayed batch accepts the same ordinal population");

        var filtered = ClaimSelection.FromPredicate(batch, record => record.Priority >= 2);
        var filteredFirst = Laminarizer.Admit(filtered, master.Extent, admissionPolicy);
        var filteredSecond = Laminarizer.Admit(filtered, master.Extent, admissionPolicy);
        Equal(
            Ordinals(filteredFirst.AcceptedCandidates),
            Ordinals(filteredSecond.AcceptedCandidates),
            "selection-backed filtered admission is reproducible");

        var empty = ClaimSelection.None(batch);
        var emptyResult = Laminarizer.Admit(empty, new TextSpan(8, 8), admissionPolicy);
        True(emptyResult.Accepted.IsEmpty && emptyResult.CrossingResidue.IsEmpty &&
             ReferenceEquals(emptyResult.Basis, batch) &&
             ReferenceEquals(emptyResult.Policy, admissionPolicy),
            "empty laminar admission retains exact basis and policy stamps");

        Throws<ArgumentException>(
            () => new LaminarFamilyPolicy(" "),
            "laminar validation policy requires a name");
        Throws<ArgumentException>(
            () => LaminarAdmissionPolicy.PriorityThenGeometry(" ", familyPolicy),
            "laminar admission policy requires a name");
        Throws<ArgumentNullException>(
            () => LaminarAdmissionPolicy.PriorityThenGeometry("x", null!),
            "laminar admission policy requires a family policy");
    }

    private static string Ordinals(IReadOnlyList<SpanRecord> records) =>
        string.Join(",", records.Select(record => record.Ordinal));

    private static string Ordinals(IEnumerable<int> ordinals) => string.Join(",", ordinals);

    private static void RunViewsTileTheMasterUnderEveryBreakKey()
    {
        var master = new TextMaster("runs", 0, "Hello, world!\r\n123 x\uD800y 😀\n\tend");
        var topology = master.Topology;

        AssertRunsTile(master, topology.EmitRuns(AtomFacts.Category), "category");
        AssertRunsTile(master, topology.EmitRuns(AtomFacts.CategoryClass), "category class");
        AssertRunsTile(master, topology.EmitRuns(AtomFacts.IsValidScalar), "scalar validity");
        AssertRunsTile(master, topology.EmitRuns(AtomFacts.LineIndex), "line index");
        AssertRunsTile(
            master,
            topology.EmitRuns(atom => (atom.LineIndex, AtomFacts.CategoryClass(atom))),
            "composite line and class");
        AssertRunsTile(master, topology.EmitRuns(static _ => 0), "constant key");

        // One key evaluation per atom, regardless of how many runs the key produces.
        var evaluations = 0;
        var counted = topology.EmitRuns(atom =>
        {
            evaluations++;
            return atom.Category;
        });
        Equal(topology.AtomCount, evaluations, "break-key evaluated once per atom");
        True(counted.Count > 1, "category key produced several runs");

        // The Lu/Ll case D4 dissolved: one tiling, two legitimate run views, neither intrinsic.
        var mixedCase = new TextMaster("run-keys", 0, "aB");
        Equal(2, mixedCase.Topology.EmitRuns(AtomFacts.Category).Count, "exact category splits Ll from Lu");
        Equal(1, mixedCase.Topology.EmitRuns(AtomFacts.CategoryClass).Count, "major class joins Ll and Lu");

        var mixed = new TextMaster("run-classes", 0, "ab, 12");
        var classes = mixed.Topology.EmitRuns(AtomFacts.CategoryClass);
        Equal(4, classes.Count, "class run count");
        Equal(new TextSpan(0, 2), classes[0].Span, "letter run extent");
        Equal(UnicodeCategoryClass.Letter, classes[0].Key, "letter run key");
        Equal(2, classes[0].AtomCount, "letter run atom count");
        Equal(UnicodeCategoryClass.Punctuation, classes[1].Key, "punctuation run key");
        Equal(UnicodeCategoryClass.Separator, classes[2].Key, "separator run key");
        Equal(UnicodeCategoryClass.Number, classes[3].Key, "number run key");

        var malformed = new TextMaster("run-validity", 0, "x\uD800y");
        var validity = malformed.Topology.EmitRuns(AtomFacts.IsValidScalar);
        Equal(3, validity.Count, "validity run count");
        Equal(false, validity[1].Key, "unpaired surrogate breaks its own run");

        // Line-keyed runs are the line extents, but only for lines that contain atoms: a trailing
        // line break opens a final empty line, and an empty line has no atoms to run over.
        var twoLines = new TextMaster("run-lines", 0, "ab\ncd");
        var lineRuns = twoLines.Topology.EmitRuns(AtomFacts.LineIndex);
        Equal(twoLines.Topology.LineCount, lineRuns.Count, "line runs match line count");
        for (var i = 0; i < lineRuns.Count; i++)
        {
            Equal(twoLines.Topology.GetLineExtent(i), lineRuns[i].Span, $"line run {i} equals line extent");
            Equal(i, lineRuns[i].Key, $"line run {i} key");
        }

        var trailing = new TextMaster("run-trailing", 0, "ab\n");
        Equal(2, trailing.Topology.LineCount, "trailing break opens an empty final line");
        Equal(1, trailing.Topology.EmitRuns(AtomFacts.LineIndex).Count, "the empty final line has no run");

        var empty = new TextMaster("run-empty", 0, string.Empty);
        Equal(0, empty.Topology.EmitRuns(AtomFacts.Category).Count, "empty master emits no runs");

        Throws<ArgumentNullException>(
            () => topology.EmitRuns((Func<TextAtom, int>)null!),
            "null break-key rejected");
    }

    private static void AssertRunsTile<TKey>(
        TextMaster master,
        IReadOnlyList<AtomRun<TKey>> runs,
        string name)
    {
        var cursor = 0;
        var atoms = 0;
        var contiguous = true;
        var maximal = true;
        var reconstructed = new System.Text.StringBuilder();
        for (var i = 0; i < runs.Count; i++)
        {
            if (runs[i].Span.Start != cursor)
            {
                contiguous = false;
            }

            if (i > 0 && EqualityComparer<TKey>.Default.Equals(runs[i].Key, runs[i - 1].Key))
            {
                maximal = false;
            }

            cursor = runs[i].Span.End;
            atoms += runs[i].AtomCount;
            reconstructed.Append(master.Slice(runs[i].Span));
        }

        True(contiguous, $"{name} runs are contiguous");
        Equal(master.Length, cursor, $"{name} runs reach the master end");
        Equal(master.Topology.AtomCount, atoms, $"{name} run atom counts sum to the tiling");
        True(maximal, $"{name} adjacent runs carry different keys");
        Equal(master.Text, reconstructed.ToString(), $"{name} runs reconstruct the master text");
    }

    private static void LazySubstrateDefersUntouchedWork()
    {
        var master = TextMaster.Create("0123456789");
        var a = SpanSet.Create(master, new[] { new TextSpan(1, 5), new TextSpan(6, 8) });
        var b = SpanSet.Create(master, new[] { new TextSpan(3, 7) });
        _ = a.Union(b);
        _ = a.Intersect(b);
        _ = a.Subtract(b);
        _ = a.Complement();
        True(master.IsCompatibleWith(master), "same-instance compatibility fast-path");
        True(!master.TopologyIsCreated, "primitive span algebra leaves topology unbuilt");
        True(!master.FingerprintIsCreated, "same-master algebra leaves fingerprint uncomputed");

        _ = master.GetLineSpan(0);
        True(master.TopologyIsCreated, "line query forces topology");
        True(!master.FingerprintIsCreated, "topology access does not force fingerprint");

        var twin = new TextMaster("lazy-twin", 0, master.Text);
        var twinPeer = new TextMaster("lazy-twin", 0, master.Text);
        True(twin.IsCompatibleWith(twinPeer), "distinct-instance compatibility still full");
        True(twin.FingerprintIsCreated, "cross-instance comparison forces fingerprint");
        True(!twin.TopologyIsCreated, "cross-instance comparison does not force topology");
    }

    private static void FrozenBatchPreservesClaims()
    {
        var master = new TextMaster("claims", 0, "0123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(1, 7), "outer", SpanLevel.MultiLine, "scanner", 1));
        builder.Add(new SpanClaim(new TextSpan(3, 9), "crossing", SpanLevel.MultiLine, "parser", 2));
        builder.Add(new SpanClaim(new TextSpan(1, 7), "second-opinion", SpanLevel.MultiLine, "human", 3));
        var batch = builder.Freeze();

        Equal(3, batch.Count, "multi-claim count");
        Equal(new TextSpan(1, 7), batch[2].Span, "equal geometry retained");
        Equal("human", batch[2].Source, "provenance retained");
        Equal(3, batch.Sorted.FindIntersecting(new TextSpan(4, 5)).Count, "sorted lookup");
        Throws<InvalidOperationException>(
            () => builder.Add(new SpanClaim(new TextSpan(0, 1), "late", SpanLevel.Character, "test")),
            "frozen builder rejected mutation");
        Equal(0, DoccerValidation.ValidateIntrinsic(batch).Count, "intrinsic validation");
    }

    private static void InternedColumnsRoundTripClaimStrings()
    {
        var master = new TextMaster("interning", 0, "0123456789");
        var claims = new[]
        {
            new SpanClaim(new TextSpan(0, 2), "heading", SpanLevel.Line, "scanner", 1, "atx"),
            new SpanClaim(new TextSpan(2, 4), "heading", SpanLevel.Line, "scanner", 1, "setext"),
            new SpanClaim(new TextSpan(4, 6), "fence", SpanLevel.MultiLine, "scanner", 2, "atx"),
            new SpanClaim(new TextSpan(6, 8), "heading", SpanLevel.Line, "human", 3),
            new SpanClaim(new TextSpan(8, 10), "fence", SpanLevel.MultiLine, "human", 0),
        };

        var builder = new SpanBatchBuilder(master);
        foreach (var claim in claims)
        {
            builder.Add(claim);
        }

        var batch = builder.Freeze();

        for (var i = 0; i < claims.Length; i++)
        {
            Equal(claims[i].Kind, batch[i].Kind, $"kind round-trips #{i}");
            Equal(claims[i].Source, batch[i].Source, $"source round-trips #{i}");
            Equal(claims[i].RuleId, batch[i].RuleId, $"rule id round-trips #{i}");
            Equal(claims[i].Span, batch[i].Span, $"span preserved #{i}");
            Equal(claims[i].ToString(), batch[i].ToClaim().ToString(), $"whole claim round-trips #{i}");
        }

        Equal(2, batch.Kinds.Table.Count, "distinct kinds interned once");
        Equal(2, batch.Sources.Table.Count, "distinct sources interned once");
        Equal(2, batch.RuleIds.Table.Count, "distinct rule ids interned once");
        Equal("heading", batch.Kinds.Table[0], "kind table keeps first-appearance order");
        Equal("fence", batch.Kinds.Table[1], "kind table second entry");

        Equal(batch.Kinds.Ids[0], batch.Kinds.Ids[1], "equal kinds share one id");
        True(batch.Kinds.Ids[0] != batch.Kinds.Ids[2], "distinct kinds get distinct ids");
        Equal(batch.RuleIds.Ids[0], batch.RuleIds.Ids[2], "equal rule ids share one id across kinds");
        Equal(InternedColumn.NullId, batch.RuleIds.Ids[3], "absent rule id records the null id");
        Equal(null, batch.RuleIds[3], "null id reads back as null");
        Equal(claims.Length, batch.Kinds.Count, "column length matches batch length");

        for (var i = 0; i < batch.Count; i++)
        {
            Equal(batch[i].Kind, batch.Kinds.Table[batch.Kinds.Ids[i]], $"id indexes the kind table #{i}");
            Equal(batch[i].Source, batch.Sources[i], $"column indexer agrees with record #{i}");
        }
    }

    private static void SpanSetObeysBooleanLawsAndMasterIdentity()
    {
        var master = new TextMaster("sets", 0, "0123456789");
        var a = SpanSet.Create(master, new[] { new TextSpan(1, 4), new TextSpan(3, 6) });
        var b = SpanSet.Create(master, new[] { new TextSpan(5, 8) });
        Equal(1, a.Count, "overlap coalescence");
        Equal(new TextSpan(1, 6), a[0], "coalesced extent");
        True(a.Union(b).Equals(b.Union(a)), "union commutativity");
        True(a.Intersect(a).Equals(a), "intersection idempotence");
        True(a.Union(a.Complement()).Equals(SpanSet.Whole(master)), "complement coverage");
        Equal(4L, a.Subtract(b).Coverage, "subtraction coverage");

        var foreign = new TextMaster("foreign", 0, master.Text);
        Throws<InvalidOperationException>(
            () => a.Union(SpanSet.Whole(foreign)),
            "cross-master operation rejected");
    }

    private static void AllenRelationsAreCompleteAndInvertible()
    {
        var reference = new TextSpan(10, 20);
        var examples = new Dictionary<AllenRelation, TextSpan>
        {
            [AllenRelation.Before] = new(0, 5),
            [AllenRelation.Meets] = new(0, 10),
            [AllenRelation.Overlaps] = new(5, 15),
            [AllenRelation.FinishedBy] = new(5, 20),
            [AllenRelation.Contains] = new(5, 25),
            [AllenRelation.Starts] = new(10, 15),
            [AllenRelation.Equal] = new(10, 20),
            [AllenRelation.StartedBy] = new(10, 25),
            [AllenRelation.During] = new(12, 18),
            [AllenRelation.Finishes] = new(12, 20),
            [AllenRelation.OverlappedBy] = new(15, 25),
            [AllenRelation.MetBy] = new(20, 25),
            [AllenRelation.After] = new(25, 30),
        };

        foreach (var pair in examples)
        {
            Equal(pair.Key, AllenAlgebra.Relate(pair.Value, reference), $"Allen {pair.Key}");
            Equal(
                AllenAlgebra.Inverse(pair.Key),
                AllenAlgebra.Relate(reference, pair.Value),
                $"Allen inverse {pair.Key}");
        }
    }

    /// <summary>
    /// K1a: the value is exactly a deterministic set over the thirteen defined atoms. Its bit
    /// representation is private, duplicate atoms collapse, and undefined enum casts are refused.
    /// </summary>
    private static void AllenRelationSetHasAClosedValueSurface()
    {
        var atoms = Enum.GetValues<AllenRelation>();
        Equal(13, atoms.Length, "Allen has exactly thirteen public atoms");
        True(
            atoms.Select(static relation => (int)relation).SequenceEqual(Enumerable.Range(0, 13)),
            "Allen enum ordinals form the frozen thirteen-bit index");

        Equal(0, AllenRelationSet.None.Count, "None has no atoms");
        True(AllenRelationSet.None.IsEmpty, "None is empty");
        Equal(13, AllenRelationSet.All.Count, "All has every atom");
        Equal(1, AllenRelationSet.Equal.Count, "Equal is a singleton");
        True(AllenRelationSet.Equal.Contains(AllenRelation.Equal), "Equal contains geometric equality");

        foreach (var atom in atoms)
        {
            var singleton = AllenRelationSet.Singleton(atom);
            Equal(1, singleton.Count, $"{atom} singleton count");
            True(singleton.Contains(atom), $"{atom} singleton membership");
            True(singleton.IsSubsetOf(AllenRelationSet.All), $"{atom} singleton is a subset of All");
        }

        var sample = AllenRelationSet.Create(new[]
        {
            AllenRelation.After,
            AllenRelation.Before,
            AllenRelation.Equal,
            AllenRelation.Before,
        });
        Equal(3, sample.Count, "duplicate atoms collapse during construction");
        Equal("Before,Equal,After", string.Join(",", sample), "enumeration follows Allen ordinal order");
        True(AllenRelationSet.Equal.IsSubsetOf(sample), "singleton subset membership is recognized");
        True(!sample.IsSubsetOf(AllenRelationSet.Equal), "subset direction is preserved");
        True(sample == AllenRelationSet.Create(sample), "equal values compare equal");
        True(sample != AllenRelationSet.All, "different values compare unequal");
        Equal(sample.GetHashCode(), AllenRelationSet.Create(sample).GetHashCode(), "equal values hash equally");

        Throws<ArgumentNullException>(
            () => AllenRelationSet.Create(null!),
            "null relation input is refused");
        Throws<ArgumentOutOfRangeException>(
            () => AllenRelationSet.Singleton((AllenRelation)(-1)),
            "a negative relation cast is refused");
        Throws<ArgumentOutOfRangeException>(
            () => AllenRelationSet.Singleton((AllenRelation)13),
            "a relation cast above the thirteen atoms is refused");
        Throws<ArgumentOutOfRangeException>(
            () => AllenRelationSet.Create(new[] { AllenRelation.Before, (AllenRelation)99 }),
            "construction refuses an undefined relation anywhere in the input");
        Throws<ArgumentOutOfRangeException>(
            () => sample.Contains((AllenRelation)99),
            "membership refuses an undefined relation");
    }

    /// <summary>
    /// K1a: all 2^13 values are checked against an independent element-wise mask oracle. Unary
    /// Boolean laws are exhaustive; binary laws use a deterministic permutation covering every
    /// value in both operand positions.
    /// </summary>
    private static void AllenRelationSetBooleanLawsHoldExhaustively()
    {
        const int valueCount = 1 << 13;
        const int allMask = valueCount - 1;
        var lawsHold = true;

        for (var mask = 0; mask < valueCount && lawsHold; mask++)
        {
            var value = AllenSetFromMask(mask);
            var complementMask = allMask ^ mask;
            var complement = value.Complement();
            var otherMask = ((mask * 4051) + 7919) & allMask;
            var thirdMask = ((mask * 2081) + 1237) & allMask;
            var other = AllenSetFromMask(otherMask);
            var third = AllenSetFromMask(thirdMask);

            lawsHold =
                AllenSetMatchesMask(value, mask) &&
                value.Count == CountSetBits(mask) &&
                value.Union(AllenRelationSet.None) == value &&
                value.Intersect(AllenRelationSet.All) == value &&
                value.Union(complement) == AllenRelationSet.All &&
                value.Intersect(complement) == AllenRelationSet.None &&
                complement.Complement() == value &&
                AllenRelationSet.None.IsSubsetOf(value) &&
                value.IsSubsetOf(AllenRelationSet.All) &&
                value.IsSubsetOf(value) &&
                AllenSetMatchesMask(value.Union(other), mask | otherMask) &&
                AllenSetMatchesMask(value.Intersect(other), mask & otherMask) &&
                value.Union(other) == other.Union(value) &&
                value.Intersect(other) == other.Intersect(value) &&
                value.Intersect(other.Union(third)) ==
                    value.Intersect(other).Union(value.Intersect(third)) &&
                value.IsSubsetOf(other) == ((mask & otherMask) == mask);
        }

        True(lawsHold, "all 8192 Allen relation-set values satisfy the Boolean value laws");
    }

    /// <summary>
    /// K1a: converse is checked on all 2^13 values, and the atom mapping is independently bridged
    /// to argument reversal for every nonempty interval pair on the six-boundary finite model.
    /// </summary>
    private static void AllenRelationSetConverseAgreesWithTheClassifier()
    {
        const int valueCount = 1 << 13;
        var converseLawsHold = true;
        for (var mask = 0; mask < valueCount && converseLawsHold; mask++)
        {
            var value = AllenSetFromMask(mask);
            var converse = value.Converse();
            var other = AllenSetFromMask(((mask * 4051) + 7919) & (valueCount - 1));
            converseLawsHold =
                converse.Converse() == value &&
                converse.Count == value.Count &&
                value.Complement().Converse() == converse.Complement() &&
                value.Union(other).Converse() == converse.Union(other.Converse());
        }

        True(converseLawsHold, "converse laws hold on all 8192 Allen relation-set values");

        var intervals = new List<TextSpan>();
        for (var start = 0; start < 6; start++)
        {
            for (var end = start + 1; end < 6; end++)
            {
                intervals.Add(new TextSpan(start, end));
            }
        }

        var classifierBridgeHolds = true;
        foreach (var left in intervals)
        {
            foreach (var right in intervals)
            {
                var relation = AllenAlgebra.Relate(left, right);
                var reversed = AllenAlgebra.Relate(right, left);
                var singleton = AllenRelationSet.Singleton(relation);
                classifierBridgeHolds &=
                    singleton.Contains(relation) &&
                    singleton.Converse() == AllenRelationSet.Singleton(reversed) &&
                    AllenAlgebra.Inverse(relation) == reversed &&
                    AllenAlgebra.Inverse(reversed) == relation;
            }
        }

        True(
            classifierBridgeHolds,
            "set converse agrees with classifier argument reversal on every six-boundary interval pair");
    }

    /// <summary>
    /// K1b: an endpoint-predicate oracle, written independently of Relate's decision tree, assigns
    /// exactly one atom to every ordered pair of nonempty D6 intervals. Relate agrees everywhere
    /// and all thirteen atoms are witnessed.
    /// </summary>
    private static void AllenClassifierIsJepdOnSixBoundaries()
    {
        var atoms = Enum.GetValues<AllenRelation>();
        var intervals = CreateNonEmptyAllenIntervals(6);
        var seen = AllenRelationSet.None;
        var jointlyExhaustiveAndPairwiseDisjoint = true;

        foreach (var left in intervals)
        {
            foreach (var right in intervals)
            {
                var matching = atoms.Where(relation => AllenPredicateHolds(relation, left, right)).ToArray();
                if (matching.Length != 1)
                {
                    jointlyExhaustiveAndPairwiseDisjoint = false;
                    continue;
                }

                var relation = matching[0];
                jointlyExhaustiveAndPairwiseDisjoint &= AllenAlgebra.Relate(left, right) == relation;
                seen = seen.Union(AllenRelationSet.Singleton(relation));
            }
        }

        True(
            jointlyExhaustiveAndPairwiseDisjoint,
            "the thirteen endpoint predicates are JEPD and Relate satisfies them on D6");
        Equal(AllenRelationSet.All, seen, "the D6 classifier witness realizes all thirteen atoms");
        Throws<ArgumentException>(
            () => AllenAlgebra.Relate(new TextSpan(0, 0), new TextSpan(0, 1)),
            "Allen classification keeps empty extents outside its carrier");
    }

    /// <summary>
    /// K1b: derive the complete 13x13 oracle from 3,375 triples of the fifteen nonempty intervals
    /// over six boundaries. The production table is literal mask data; this oracle knows only the
    /// independent endpoint predicates below.
    /// </summary>
    private static void AllenCompositionMatchesIndependentD6Oracle()
    {
        var intervals = CreateNonEmptyAllenIntervals(6);
        var expected = new AllenRelationSet[13, 13];
        var evaluatedTriples = 0;

        foreach (var left in intervals)
        {
            foreach (var middle in intervals)
            {
                foreach (var right in intervals)
                {
                    var first = ClassifyAllenByPredicates(left, middle);
                    var second = ClassifyAllenByPredicates(middle, right);
                    var outer = ClassifyAllenByPredicates(left, right);
                    expected[(int)first, (int)second] = expected[(int)first, (int)second]
                        .Union(AllenRelationSet.Singleton(outer));
                    evaluatedTriples++;
                }
            }
        }

        var tableMatches = true;
        var atomicTriads = 0;
        foreach (var first in Enum.GetValues<AllenRelation>())
        {
            foreach (var second in Enum.GetValues<AllenRelation>())
            {
                var oracleCell = expected[(int)first, (int)second];
                var tableCell = AllenRelationSet.Singleton(first)
                    .AllenCompose(AllenRelationSet.Singleton(second));
                tableMatches &= tableCell == oracleCell;
                atomicTriads += oracleCell.Count;
            }
        }

        Equal(15, intervals.Count, "D6 has fifteen nonempty intervals");
        Equal(3375, evaluatedTriples, "the D6 oracle evaluates every interval triple");
        True(tableMatches, "all 169 literal composition cells equal the independent D6 oracle");
        Equal(409, atomicTriads, "the canonical table contains 409 atomic triads");
    }

    /// <summary>
    /// K1b: composition is the additive lift of the canonical atomic table. Lifted identity,
    /// annihilation, distributivity, and converse laws are swept across all 2^13 values; the
    /// associativity kernel is checked on every ordered triple of atoms.
    /// </summary>
    private static void AllenCompositionLawsHold()
    {
        const int valueCount = 1 << 13;
        const int allMask = valueCount - 1;
        var liftedLawsHold = true;

        for (var mask = 0; mask < valueCount && liftedLawsHold; mask++)
        {
            var value = AllenSetFromMask(mask);
            var other = AllenSetFromMask(((mask * 4051) + 7919) & allMask);
            var third = AllenSetFromMask(((mask * 2081) + 1237) & allMask);

            liftedLawsHold =
                value.AllenCompose(AllenRelationSet.None) == AllenRelationSet.None &&
                AllenRelationSet.None.AllenCompose(value) == AllenRelationSet.None &&
                value.AllenCompose(AllenRelationSet.Equal) == value &&
                AllenRelationSet.Equal.AllenCompose(value) == value &&
                value.AllenCompose(other.Union(third)) ==
                    value.AllenCompose(other).Union(value.AllenCompose(third)) &&
                value.Union(other).AllenCompose(third) ==
                    value.AllenCompose(third).Union(other.AllenCompose(third)) &&
                value.AllenCompose(other).Converse() ==
                    other.Converse().AllenCompose(value.Converse());
        }

        True(liftedLawsHold, "Allen composition lift laws hold across all 8192 relation sets");

        var atomicAssociativityHolds = true;
        foreach (var first in Enum.GetValues<AllenRelation>())
        {
            foreach (var second in Enum.GetValues<AllenRelation>())
            {
                foreach (var third in Enum.GetValues<AllenRelation>())
                {
                    var firstSet = AllenRelationSet.Singleton(first);
                    var secondSet = AllenRelationSet.Singleton(second);
                    var thirdSet = AllenRelationSet.Singleton(third);
                    atomicAssociativityHolds &=
                        firstSet.AllenCompose(secondSet).AllenCompose(thirdSet) ==
                        firstSet.AllenCompose(secondSet.AllenCompose(thirdSet));
                }
            }
        }

        True(atomicAssociativityHolds, "all 2197 atomic composition triples are associative");
    }

    /// <summary>
    /// K1b: canonical qualitative composition is not exact composition inside one finite master.
    /// With adjacent integer boundaries, [0,1) is Before [2,3), but there is no nonempty interval
    /// strictly between them even though canonical Before o Before contains Before.
    /// </summary>
    private static void AllenCanonicalCompositionIsNotFiniteMasterComposition()
    {
        var before = AllenRelationSet.Singleton(AllenRelation.Before);
        Equal(before, before.AllenCompose(before), "canonical Before composed with Before is Before");

        var left = new TextSpan(0, 1);
        var right = new TextSpan(2, 3);
        var finiteIntervals = CreateNonEmptyAllenIntervals(4);
        var hasMiddle = finiteIntervals.Any(middle =>
            AllenAlgebra.Relate(left, middle) == AllenRelation.Before &&
            AllenAlgebra.Relate(middle, right) == AllenRelation.Before);

        Equal(AllenRelation.Before, AllenAlgebra.Relate(left, right), "the adjacent-gap endpoints are Before");
        True(!hasMiddle, "the four-boundary finite carrier has no Before-Before middle witness");
    }

    private static List<TextSpan> CreateNonEmptyAllenIntervals(int boundaryCount)
    {
        var intervals = new List<TextSpan>();
        for (var start = 0; start < boundaryCount; start++)
        {
            for (var end = start + 1; end < boundaryCount; end++)
            {
                intervals.Add(new TextSpan(start, end));
            }
        }

        return intervals;
    }

    private static AllenRelation ClassifyAllenByPredicates(TextSpan left, TextSpan right)
    {
        var found = false;
        var classified = default(AllenRelation);
        foreach (var relation in Enum.GetValues<AllenRelation>())
        {
            if (!AllenPredicateHolds(relation, left, right))
            {
                continue;
            }

            if (found)
            {
                throw new InvalidOperationException($"Independent Allen predicates overlap for {left} and {right}.");
            }

            found = true;
            classified = relation;
        }

        return found
            ? classified
            : throw new InvalidOperationException($"Independent Allen predicates leave {left} and {right} unclassified.");
    }

    private static bool AllenPredicateHolds(AllenRelation relation, TextSpan left, TextSpan right) => relation switch
    {
        AllenRelation.Before => left.End < right.Start,
        AllenRelation.Meets => left.End == right.Start,
        AllenRelation.Overlaps =>
            left.Start < right.Start && right.Start < left.End && left.End < right.End,
        AllenRelation.FinishedBy => left.Start < right.Start && left.End == right.End,
        AllenRelation.Contains => left.Start < right.Start && right.End < left.End,
        AllenRelation.Starts => left.Start == right.Start && left.End < right.End,
        AllenRelation.Equal => left.Start == right.Start && left.End == right.End,
        AllenRelation.StartedBy => left.Start == right.Start && right.End < left.End,
        AllenRelation.During => right.Start < left.Start && left.End < right.End,
        AllenRelation.Finishes => right.Start < left.Start && left.End == right.End,
        AllenRelation.OverlappedBy =>
            right.Start < left.Start && left.Start < right.End && right.End < left.End,
        AllenRelation.MetBy => left.Start == right.End,
        AllenRelation.After => right.End < left.Start,
        _ => throw new ArgumentOutOfRangeException(nameof(relation)),
    };

    private static AllenRelationSet AllenSetFromMask(int mask)
    {
        var atoms = new List<AllenRelation>(13);
        for (var index = 0; index < 13; index++)
        {
            if ((mask & (1 << index)) != 0)
            {
                atoms.Add((AllenRelation)index);
            }
        }

        return AllenRelationSet.Create(atoms);
    }

    private static bool AllenSetMatchesMask(AllenRelationSet value, int mask)
    {
        for (var index = 0; index < 13; index++)
        {
            if (value.Contains((AllenRelation)index) != ((mask & (1 << index)) != 0))
            {
                return false;
            }
        }

        return true;
    }

    private static int CountSetBits(int value)
    {
        var count = 0;
        while (value != 0)
        {
            value &= value - 1;
            count++;
        }

        return count;
    }

    private static void SpanSetRandomizedLawsHold()
    {
        var master = new TextMaster("random-sets", 0, new string('x', 96));
        var random = new Random(20260802);
        for (var trial = 0; trial < 128; trial++)
        {
            var a = RandomSet(master, random);
            var b = RandomSet(master, random);
            True(a.Union(b).Equals(b.Union(a)), $"random union commutativity {trial}");
            True(a.Intersect(b).Equals(b.Intersect(a)), $"random intersection commutativity {trial}");
            True(a.Union(a).Equals(a), $"random union idempotence {trial}");
            True(a.Intersect(a).Equals(a), $"random intersection idempotence {trial}");
            True(a.Subtract(a).Count == 0, $"random self-subtraction {trial}");
            True(a.Union(a.Complement()).Equals(SpanSet.Whole(master)), $"random complement {trial}");
            True(
                a.Union(b).Complement().Equals(a.Complement().Intersect(b.Complement())),
                $"random De Morgan {trial}");
        }
    }

    private static SpanSet RandomSet(TextMaster master, Random random)
    {
        var spans = new List<TextSpan>();
        var count = random.Next(0, 12);
        for (var i = 0; i < count; i++)
        {
            var start = random.Next(0, master.Length);
            var end = random.Next(start + 1, master.Length + 1);
            spans.Add(new TextSpan(start, end));
        }

        return SpanSet.Create(master, spans);
    }

    private static void StructuralValidatorsKeepTheirDistinctInvariants()
    {
        var master = new TextMaster("laminar", 0, "01234567890123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 20), "root", SpanLevel.MultiLine, "sweep", 100));
        builder.Add(new SpanClaim(new TextSpan(2, 12), "left", SpanLevel.MultiLine, "parser", 10));
        builder.Add(new SpanClaim(new TextSpan(8, 18), "crossing", SpanLevel.MultiLine, "heuristic", 5));
        builder.Add(new SpanClaim(new TextSpan(3, 6), "nested", SpanLevel.Character, "scanner", 1));
        builder.Add(new SpanClaim(new TextSpan(2, 12), "left-confirmation", SpanLevel.MultiLine, "human", 2));

        var batch = builder.Freeze();
        var familyPolicy = new LaminarFamilyPolicy("validated-no-crossing");
        var laminarSelection = ClaimSelection.Create(batch, new[] { 0, 1, 3, 4 });
        var family = LaminarView.Create(laminarSelection, master.Extent, familyPolicy);

        True(ReferenceEquals(family.Selection, laminarSelection) &&
             ReferenceEquals(family.Basis, batch) &&
             ReferenceEquals(family.Policy, familyPolicy) &&
             family.Window == master.Extent,
            "laminar validation retains exact selection, basis, window, and policy stamps");
        Equal(4, family.Count, "laminar validation preserves every selected occurrence");
        Equal(3, family.GroupCount, "equal laminar geometry is grouped without losing occurrences");
        True(family.Groups[1].Span == new TextSpan(2, 12) &&
             family.Groups[1].Members.SequenceEqual(new[] { 1, 4 }),
            "laminar equal-geometry group retains exact source ordinals");
        Throws<ArgumentException>(
            () => LaminarView.Create(ClaimSelection.All(batch), master.Extent, familyPolicy),
            "laminar validation refuses a crossing instead of silently selecting a subset");

        var admissionPolicy = LaminarAdmissionPolicy.PriorityThenGeometry(
            "default-priority-admission",
            familyPolicy);
        var admission = Laminarizer.Admit(ClaimSelection.All(batch), master.Extent, admissionPolicy);
        True(admission.AcceptedCandidates.SequenceEqual(new[] { 0, 1, 3, 4 }) &&
             admission.CrossingResidue.SequenceEqual(new[] { 2 }),
            "greedy laminar admission keeps equal geometry and retains exact crossing residue");

        var structuralBuilder = new SpanBatchBuilder(master);
        structuralBuilder.Add(new SpanClaim(new TextSpan(0, 3), "pack-left", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(3, 5), "pack-right", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(7, 9), "pack-tail", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(2, 5), "packing-overlap", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(0, 3), "parallel", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(0, 4), "cover-left", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(3, 8), "cover-right", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(0, 2), "hole-left", SpanLevel.Character, "test"));
        structuralBuilder.Add(new SpanClaim(new TextSpan(4, 8), "hole-right", SpanLevel.Character, "test"));
        var structuralBatch = structuralBuilder.Freeze();
        var packingPolicy = new PackingPolicy("disjoint-with-gaps");
        var packingSelection = ClaimSelection.Create(structuralBatch, new[] { 0, 1, 2 });
        var packing = PackingView.Create(
            packingSelection,
            new TextSpan(0, 9),
            packingPolicy);
        True(ReferenceEquals(packing.Selection, packingSelection) &&
             ReferenceEquals(packing.Policy, packingPolicy) &&
             packing.Coverage.SequenceEqual(new[] { new TextSpan(0, 5), new TextSpan(7, 9) }) &&
             packing.Gaps.SequenceEqual(new[] { new TextSpan(5, 7) }),
            "packing accepts meeting spans and gaps while retaining exact stamps");
        Throws<ArgumentException>(
            () => PackingView.Create(
                ClaimSelection.Create(structuralBatch, new[] { 0, 3 }),
                new TextSpan(0, 9),
                packingPolicy),
            "packing refuses material overlap");
        Throws<ArgumentException>(
            () => PackingView.Create(
                ClaimSelection.Create(structuralBatch, new[] { 0, 4 }),
                new TextSpan(0, 9),
                packingPolicy),
            "packing refuses parallel equal-geometry occurrences");

        var coverPolicy = new CoverPolicy("overlap-allowed-total-cover");
        var coverSelection = ClaimSelection.Create(structuralBatch, new[] { 5, 6 });
        var cover = CoverView.Create(coverSelection, new TextSpan(0, 8), coverPolicy);
        True(ReferenceEquals(cover.Selection, coverSelection) &&
             ReferenceEquals(cover.Policy, coverPolicy) &&
             cover.Coverage.SequenceEqual(new[] { new TextSpan(0, 8) }),
            "cover accepts declared overlap and retains exact total-window evidence");
        var parallelCover = CoverView.Create(
            ClaimSelection.Create(structuralBatch, new[] { 0, 4, 6 }),
            new TextSpan(0, 8),
            coverPolicy);
        True(parallelCover.Selection.Count == 3 &&
             parallelCover.Coverage.SequenceEqual(new[] { new TextSpan(0, 8) }),
            "cover retains parallel equal-geometry occurrences while normalizing coverage");
        Throws<ArgumentException>(
            () => CoverView.Create(
                ClaimSelection.Create(structuralBatch, new[] { 7, 8 }),
                new TextSpan(0, 8),
                coverPolicy),
            "cover refuses a material hole even when its selected spans have substantial length");
        Throws<ArgumentException>(
            () => CoverView.Create(
                ClaimSelection.Create(structuralBatch, new[] { 2 }),
                new TextSpan(0, 8),
                coverPolicy),
            "cover refuses a selected occurrence outside its declared window");

        var empty = ClaimSelection.None(structuralBatch);
        var emptyPacking = PackingView.Create(empty, new TextSpan(6, 6), packingPolicy);
        var emptyCover = CoverView.Create(empty, new TextSpan(6, 6), coverPolicy);
        var emptyFamily = LaminarView.Create(empty, new TextSpan(6, 6), familyPolicy);
        True(emptyPacking.Selection.IsEmpty && emptyCover.Selection.IsEmpty && emptyFamily.IsEmpty &&
             ReferenceEquals(emptyPacking.Basis, structuralBatch) &&
             ReferenceEquals(emptyCover.Basis, structuralBatch) &&
             ReferenceEquals(emptyFamily.Basis, structuralBatch),
            "empty structural validators retain their exact frozen-batch basis");

        Throws<ArgumentException>(() => new PackingPolicy(" "), "packing policy requires a name");
        Throws<ArgumentException>(() => new CoverPolicy(" "), "cover policy requires a name");
    }

    private static void ScopedRegexCollectionCannotBridgeGaps()
    {
        var master = new TextMaster("regex", 0, "foo HIDDEN bar");
        var scope = SpanSet.Create(master, new[] { new TextSpan(0, 3), new TextSpan(11, 14) });
        var rules = new[]
        {
            new PatternRule("word", @"\w+", "word", "test"),
            new PatternRule("bridge", @"foo\s+bar", "bridge", "test"),
        };

        var batch = RegexCollector.Collect(master, rules, scope);
        Equal(2, batch.Count, "two region-local words");
        True(batch.All(record => record.Kind == "word"), "no match bridged excluded gap");
        Equal(new TextSpan(11, 14), batch[1].Span, "local match lifted to master");
    }

    private static void SuppressionIsAQueryWithIdempotenceAndDuality()
    {
        var master = new TextMaster("suppression", 0, "aaa BBB ccc BBB ddd");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(4, 7), "mask", SpanLevel.Character, "scanner"));
        builder.Add(new SpanClaim(new TextSpan(12, 15), "mask", SpanLevel.Character, "scanner"));
        builder.Add(new SpanClaim(new TextSpan(0, 3), "note", SpanLevel.Character, "human"));
        var batch = builder.Freeze();

        static bool IsMask(SpanRecord record) => record.Kind == "mask";

        var excluded = Suppression.Excluded(batch, IsMask);
        var admitted = Suppression.Admitted(batch, IsMask);

        Equal(2, excluded.Count, "suppressed region count");
        Equal(new TextSpan(4, 7), excluded[0], "first suppressed extent");
        Equal(3, admitted.Count, "admitted region count");
        Equal(new TextSpan(0, 4), admitted[0], "first admitted extent");

        // Duality: the two queries partition the master extent.
        True(admitted.Union(excluded).Equals(SpanSet.Whole(master)), "admitted and excluded cover the master");
        Equal(0, admitted.Intersect(excluded).Count, "admitted and excluded are disjoint");
        True(admitted.Equals(excluded.Complement()), "admitted is the complement of excluded");
        True(excluded.Equals(admitted.Complement()), "excluded is the complement of admitted");
        Equal(master.Length, admitted.Coverage + excluded.Coverage, "coverage sums to the master length");

        // Idempotence: suppressing again inside an already-admitted region changes nothing.
        True(admitted.Subtract(excluded).Equals(admitted), "re-suppressing an admitted set is a no-op");
        True(admitted.Intersect(admitted).Equals(admitted), "re-admitting an admitted set is a no-op");
        True(excluded.Union(excluded).Equals(excluded), "re-excluding an excluded set is a no-op");
        True(
            Suppression.Admitted(batch, IsMask).Equals(admitted),
            "the query is deterministic over one batch");

        // The policy is the caller's, not the claim's: the same batch answers differently under a
        // different predicate, which is precisely what an is_mask flag would have foreclosed.
        var notesExcluded = Suppression.Excluded(batch, record => record.Kind == "note");
        True(!notesExcluded.Equals(excluded), "a different predicate suppresses a different region");
        True(
            Suppression.Admitted(batch, static _ => false).Equals(SpanSet.Whole(master)),
            "suppressing nothing admits the whole master");
        True(
            Suppression.Excluded(batch, static _ => true).Equals(SpanSet.FromClaims(batch)),
            "suppressing every claim excludes exactly the claim coverage");
        var nothingClaimed = Suppression.Admitted(batch, static _ => true);
        foreach (var record in batch)
        {
            var claimRegion = SpanSet.Create(master, new[] { record.Span });
            Equal(
                0,
                nothingClaimed.Intersect(claimRegion).Count,
                $"claim {record.Span} lies outside the all-suppressed admission");
        }

        // Integration with scoped collection: recognition inside the admitted region never reaches
        // the suppressors, and no match bridges a suppressed gap.
        var rules = new[] { new PatternRule("word", @"\w+", "word", "test") };
        var scoped = RegexCollector.Collect(master, rules, admitted);
        Equal(3, scoped.Count, "three words survive suppression");
        Equal(5, RegexCollector.Collect(master, rules).Count, "unscoped collection sees the suppressed words");
        foreach (var collected in scoped)
        {
            foreach (var suppressor in batch)
            {
                if (IsMask(suppressor))
                {
                    True(
                        !collected.Span.Intersects(suppressor.Span),
                        $"collected {collected.Span} avoids suppressor {suppressor.Span}");
                }
            }
        }

        Equal("aaa", master.Slice(scoped[0].Span), "first surviving word");
        Equal("ccc", master.Slice(scoped[1].Span), "second surviving word");
        Equal("ddd", master.Slice(scoped[2].Span), "third surviving word");

        Throws<ArgumentNullException>(
            () => Suppression.Admitted(batch, null!),
            "suppression requires a named predicate");
    }

    private static void DefectiveRuleFailsAtLoadTimeWithoutSideEffects()
    {
        var master = new TextMaster("defective-rule", 0, "foo bar foo");
        var builder = new SpanBatchBuilder(master);
        var rules = new[]
        {
            new PatternRule("word", @"\w+", "word", "test"),
            new PatternRule("poison", "foo|", "poison", "test"),
        };

        var thrown = (ArgumentException?)null;
        try
        {
            RegexCollector.CollectInto(builder, rules);
        }
        catch (ArgumentException exception)
        {
            thrown = exception;
        }

        True(thrown is not null, "empty-capable rule rejected at load time");
        True(
            thrown!.Message.Contains("'poison'", StringComparison.Ordinal),
            "rejection names the rule id");
        Equal(0, builder.Count, "no claims added before load-time rejection");
    }

    private static void ExecutionScopeComposesWithTheCallerRegionSet()
    {
        var master = new TextMaster("execution-scope", 0, "foo\nbar\nfoo bar");
        var bridging = @"foo\s+bar";

        var wholeMaster = RegexCollector.Collect(
            master,
            new[] { new PatternRule("pair", bridging, "pair", "test") });
        Equal(2, wholeMaster.Count, "whole-master matching crosses line breaks");
        Equal(new TextSpan(0, 7), wholeMaster[0].Span, "whole-master match spans the break");

        var perLine = RegexCollector.Collect(
            master,
            new[]
            {
                new PatternRule("pair", bridging, "pair", "test", SpanLevel.Character, ExecutionScope.PerLine),
            });
        Equal(1, perLine.Count, "per-line matching cannot cross a line break");
        Equal(new TextSpan(8, 15), perLine[0].Span, "surviving per-line match");

        // Level is claim metadata and scope is execution: a Line-level rule may still run over the
        // whole master, and a Character-level rule may still run per line.
        var levelIndependent = RegexCollector.Collect(
            master,
            new[] { new PatternRule("pair", bridging, "pair", "test", SpanLevel.Line) });
        Equal(2, levelIndependent.Count, "SpanLevel.Line does not imply per-line execution");
        Equal(SpanLevel.Line, levelIndependent[0].Level, "level rides through as claim metadata");
        Equal(ExecutionScope.WholeMaster, new PatternRule("d", "a", "k", "s").Scope, "default scope");

        // The two scopes compose by intersecting admitted regions, and each resulting piece is
        // matched on its own.
        var composed = new TextMaster("scope-composition", 0, "aa bb\ncc dd");
        var callerScope = SpanSet.Create(composed, new[] { new TextSpan(0, 2), new TextSpan(3, 11) });
        var words = new[]
        {
            new PatternRule("word", @"\w+", "word", "test", SpanLevel.Character, ExecutionScope.PerLine),
        };
        var pieces = RegexCollector.Collect(composed, words, callerScope);
        Equal(4, pieces.Count, "per-line rule within a caller scope");
        Equal(new TextSpan(0, 2), pieces[0].Span, "first intersected piece");
        Equal(new TextSpan(3, 5), pieces[1].Span, "line one, second admitted piece");
        Equal(new TextSpan(6, 8), pieces[2].Span, "line two, first word");
        Equal(new TextSpan(9, 11), pieces[3].Span, "line two, second word");

        var joined = new[] { new PatternRule("adjacent", @"\w+\s+\w+", "adjacent", "test") };
        var joinedPerLine = new[]
        {
            new PatternRule(
                "adjacent",
                @"\w+\s+\w+",
                "adjacent",
                "test",
                SpanLevel.Character,
                ExecutionScope.PerLine),
        };
        var acrossBreak = RegexCollector.Collect(composed, joined, callerScope);
        var withinLine = RegexCollector.Collect(composed, joinedPerLine, callerScope);
        Equal(1, acrossBreak.Count, "whole-master rule matches across the break inside one region");
        Equal(new TextSpan(3, 8), acrossBreak[0].Span, "the bridged extent");
        Equal(1, withinLine.Count, "per-line rule matches only within a line");
        Equal(new TextSpan(6, 11), withinLine[0].Span, "the line-local extent");

        // D12: only the composition that needs lines asks for the topology.
        var untouched = TextMaster.Create("alpha beta");
        _ = RegexCollector.Collect(untouched, new[] { new PatternRule("word", @"\w+", "word", "test") });
        True(!untouched.TopologyIsCreated, "whole-master collection leaves the topology unbuilt");

        var lineAware = TextMaster.Create("alpha beta");
        _ = RegexCollector.Collect(lineAware, words);
        True(lineAware.TopologyIsCreated, "per-line collection asks for the line topology");

        // D15: the per-line region is the content extent, terminator excluded. `.` matches '\r'
        // but not '\n', so with the terminator inside the region the same content would claim a
        // trailing '\r' under CRLF and not under LF.
        var greedy = new[]
        {
            new PatternRule("head", "#.*$", "head", "test", SpanLevel.Character, ExecutionScope.PerLine),
        };
        var lf = RegexCollector.Collect(new TextMaster("d15-lf", 0, "# T\nx"), greedy);
        var crlf = RegexCollector.Collect(new TextMaster("d15-crlf", 0, "# T\r\nx"), greedy);
        Equal(1, lf.Count, "greedy line rule fires once under LF");
        Equal(1, crlf.Count, "greedy line rule fires once under CRLF");
        Equal("# T", lf.Master.Slice(lf[0].Span), "LF claim text is the content");
        Equal("# T", crlf.Master.Slice(crlf[0].Span), "CRLF claim text matches LF — no captured '\\r'");

        // D15: the terminator is unreachable under PerLine and remains reachable as content only
        // by choosing WholeMaster; either way its codepoints stay first-class atoms.
        var breakPattern = new PatternRule("brk", "\\n", "brk", "test");
        var breakPerLine = new PatternRule("brk", "\\n", "brk", "test", SpanLevel.Character, ExecutionScope.PerLine);
        var terminated = new TextMaster("d15-terminator", 0, "a\nb\n");
        Equal(2, RegexCollector.Collect(terminated, new[] { breakPattern }).Count, "whole-master reaches the terminators");
        Equal(0, RegexCollector.Collect(terminated, new[] { breakPerLine }).Count, "per-line never sees a terminator");
    }

    private static void JsonlInventoryLoadsAndFailsWithProvenance()
    {
        var inventory = new[]
        {
            """{"id":"heading","pattern":"^#+ .*$","kind":"heading","source":"markdown","level":"Line","scope":"PerLine","priority":10}""",
            string.Empty,
            """{"id":"word","pattern":"\\w+","kind":"word","source":"markdown","options":["IgnoreCase","CultureInvariant"],"captureGroup":"0","timeoutMilliseconds":250}""",
        };

        var rules = PatternRuleLoader.Load(inventory, "inventory.jsonl");
        Equal(2, rules.Count, "blank lines are not rules");

        Equal("heading", rules[0].Id, "rule id");
        Equal("^#+ .*$", rules[0].Pattern, "rule pattern is taken verbatim");
        Equal("heading", rules[0].Kind, "rule kind");
        Equal("markdown", rules[0].Source, "rule source");
        Equal(SpanLevel.Line, rules[0].Level, "rule level");
        Equal(ExecutionScope.PerLine, rules[0].Scope, "rule execution scope");
        Equal(10, rules[0].Priority, "rule priority");
        Equal(RegexOptions.CultureInvariant, rules[0].Options, "absent options fall back to the engine default");
        Equal(TimeSpan.FromSeconds(1), rules[0].Timeout, "absent timeout falls back to the engine default");
        Equal(null, rules[0].CaptureGroup, "absent capture group");

        Equal(SpanLevel.Character, rules[1].Level, "absent level falls back to Character");
        Equal(ExecutionScope.WholeMaster, rules[1].Scope, "absent scope falls back to WholeMaster");
        Equal(0, rules[1].Priority, "absent priority falls back to zero");
        Equal(RegexOptions.IgnoreCase | RegexOptions.CultureInvariant, rules[1].Options, "listed options");
        Equal("0", rules[1].CaptureGroup, "capture group");
        Equal(TimeSpan.FromMilliseconds(250), rules[1].Timeout, "timeout");

        // A loaded inventory drives collection with no domain code in the engine.
        var master = new TextMaster("inventory", 0, "# Title\nbody text\n");
        var batch = RegexCollector.Collect(master, rules);
        var headings = batch.Where(record => record.Kind == "heading").ToArray();
        Equal(1, headings.Length, "the per-line heading rule fired once");
        Equal(new TextSpan(0, 7), headings[0].Span, "the heading claim stops at the line break");
        Equal(3, batch.Count(record => record.Kind == "word"), "the whole-master word rule swept the master");
        Equal("heading", batch.RuleIds[0], "the rule id rides onto the claim");

        // A line-level pattern need not anchor itself: D6 dropped the syntactic loader rules.
        var unanchored = PatternRuleLoader.Load(
            new[] { """{"id":"bare","pattern":"item","kind":"item","source":"t","scope":"PerLine"}""" },
            "unanchored.jsonl");
        Equal(1, unanchored.Count, "an unanchored per-line pattern loads");

        var missingField = LoadFails(
            """{"pattern":"a","kind":"k","source":"s"}""",
            "missing id rejected");
        Equal("inventory.jsonl", missingField.Origin, "error carries the origin");
        Equal(2, missingField.LineNumber, "blank lines count toward the reported line");
        True(
            missingField.Message.StartsWith("inventory.jsonl:2: ", StringComparison.Ordinal),
            "error message leads with file and line");
        True(missingField.Message.Contains("'id'", StringComparison.Ordinal), "error names the missing field");

        var unknownProperty = LoadFails(
            """{"id":"a","pattern":"a","kind":"k","source":"s","levl":"Line"}""",
            "unknown property rejected");
        True(unknownProperty.InnerException is JsonException, "schema violation wraps the parse error");

        var badLevel = LoadFails(
            """{"id":"a","pattern":"a","kind":"k","source":"s","level":"Lines"}""",
            "unknown level rejected");
        True(badLevel.Message.Contains("MultiLine", StringComparison.Ordinal), "the error lists the valid levels");

        var badScope = LoadFails(
            """{"id":"a","pattern":"a","kind":"k","source":"s","scope":"PerFile"}""",
            "unknown scope rejected");
        True(badScope.Message.Contains("PerLine", StringComparison.Ordinal), "the error lists the valid scopes");

        var badOption = LoadFails(
            """{"id":"a","pattern":"a","kind":"k","source":"s","options":["Fast"]}""",
            "unknown regex option rejected");
        True(badOption.Message.Contains("'Fast'", StringComparison.Ordinal), "the error names the unknown option");

        var badPattern = LoadFails(
            """{"id":"a","pattern":"(","kind":"k","source":"s"}""",
            "uncompilable pattern rejected");
        True(badPattern.InnerException is ArgumentException, "compile failure is wrapped, not raw");

        var emptyCapable = LoadFails(
            """{"id":"poison","pattern":"foo|","kind":"k","source":"s"}""",
            "empty-capable pattern rejected at load");
        True(
            emptyCapable.Message.Contains("'poison'", StringComparison.Ordinal),
            "the empty-match probe names the rule id");

        var malformed = LoadFails("{not json", "malformed JSON rejected");
        True(malformed.InnerException is JsonException, "malformed JSON wraps the parse error");

        var notAnObject = LoadFails("null", "a null line rejected");
        Equal(2, notAnObject.LineNumber, "null line provenance");

        var duplicate = (PatternRuleLoadException?)null;
        try
        {
            PatternRuleLoader.Load(
                new[]
                {
                    """{"id":"same","pattern":"a","kind":"k","source":"s"}""",
                    """{"id":"same","pattern":"b","kind":"k","source":"s"}""",
                },
                "dup.jsonl");
        }
        catch (PatternRuleLoadException exception)
        {
            duplicate = exception;
        }

        True(duplicate is not null, "duplicate rule id rejected");
        Equal(2, duplicate!.LineNumber, "duplicate reported at its own line");
        True(
            duplicate.Message.Contains("already defined on line 1", StringComparison.Ordinal),
            "duplicate error names the first definition");

        var path = Path.Combine(Path.GetTempPath(), $"doccer-inventory-{Guid.NewGuid():N}.jsonl");
        try
        {
            File.WriteAllLines(path, inventory, new UTF8Encoding(false));
            var fromFile = PatternRuleLoader.LoadFile(path);
            Equal(2, fromFile.Count, "rules load from a UTF-8 JSONL file");
            Equal("heading", fromFile[0].Id, "file-loaded rule identity");

            File.WriteAllLines(path, new[] { """{"id":"a","kind":"k","source":"s"}""" }, new UTF8Encoding(false));
            var fileFailure = (PatternRuleLoadException?)null;
            try
            {
                PatternRuleLoader.LoadFile(path);
            }
            catch (PatternRuleLoadException exception)
            {
                fileFailure = exception;
            }

            True(fileFailure is not null, "a defective file fails loudly");
            Equal(path, fileFailure!.Origin, "file failure carries the path");
            Equal(1, fileFailure.LineNumber, "file failure carries the line");
        }
        finally
        {
            File.Delete(path);
        }
    }

    private static PatternRuleLoadException LoadFails(string line, string name)
    {
        _checks++;
        try
        {
            // The leading blank line makes every reported provenance line 2, which also proves
            // blank lines are skipped without being uncounted.
            PatternRuleLoader.Load(new[] { string.Empty, line }, "inventory.jsonl");
        }
        catch (PatternRuleLoadException exception)
        {
            return exception;
        }

        throw new InvalidOperationException($"Check failed: {name}; expected PatternRuleLoadException.");
    }

    private static void DeclarativeValidationRunsWithoutDomainCode()
    {
        var master = new TextMaster("validation", 0, "0123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(1, 9), "container", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(2, 4), "member", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(8, 10), "forbidden", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var requirements = new[]
        {
            new RelationRequirement(
                "member-has-container",
                "member",
                "container",
                AllenRelationSet.Singleton(AllenRelation.During),
                minimumMatches: 1,
                maximumMatches: 1),
        };
        var impossibilities = new[]
        {
            new ForbiddenRelation(
                "container-must-not-cross-forbidden",
                "container",
                "forbidden",
                AllenRelationSet.Singleton(AllenRelation.Overlaps)),
        };

        var issues = DoccerValidation.ValidateRelations(batch, requirements, impossibilities);
        Equal(1, issues.Count, "one impossibility detected");
        Equal("container-must-not-cross-forbidden", issues[0].Rule, "impossibility rule identity");
        Equal(
            AllenRelationSet.Singleton(AllenRelation.During),
            requirements[0].AcceptedRelations,
            "relation requirements retain the closed Allen relation-set value");
        Equal(
            AllenRelationSet.Singleton(AllenRelation.Overlaps),
            impossibilities[0].ForbiddenRelations,
            "forbidden relations retain the closed Allen relation-set value");
        Throws<ArgumentException>(
            () => new RelationRequirement("empty", "left", "right", AllenRelationSet.None),
            "a validation requirement refuses the empty relation union");
        Throws<ArgumentException>(
            () => new ForbiddenRelation("empty", "left", "right", AllenRelationSet.None),
            "a forbidden-relation rule refuses the empty relation union");
    }

    /// <summary>
    /// Collection is transactional: a failure the load-time probe cannot see — here a
    /// context-dependent zero-width lookaround, which matches nothing on empty input but emits an
    /// empty claim mid-sweep — must leave the caller's builder exactly as it found it, even when
    /// a valid rule ahead of it already recognized claims.
    /// </summary>
    private static void CollectionCommitsAtomically()
    {
        var master = new TextMaster("atomic", 0, "a b a");
        var builder = new SpanBatchBuilder(master);
        var rules = new[]
        {
            new PatternRule("word", @"\w+", "word", "test"),
            new PatternRule("peek", "(?=a)", "peek", "test"),
        };

        True(
            !RegexCollector.CompileAndProbe(rules[1]).Match(string.Empty).Success,
            "the context-dependent zero-width pattern passes the empty-input probe");

        var thrown = (InvalidOperationException?)null;
        try
        {
            RegexCollector.CollectInto(builder, rules);
        }
        catch (InvalidOperationException exception)
        {
            thrown = exception;
        }

        True(thrown is not null, "the zero-width match still fails mid-sweep");
        True(thrown!.Message.Contains("'peek'", StringComparison.Ordinal), "the failure names the rule");
        Equal(0, builder.Count, "no claim from the earlier valid rule was committed");

        // The same builder remains usable, and a clean sweep commits everything it staged.
        RegexCollector.CollectInto(builder, new[] { rules[0] });
        Equal(3, builder.Count, "a clean sweep over the surviving rule commits all claims");

        // A pre-populated builder is extended, never rebuilt, and a frozen one is refused before
        // any matching starts.
        var seeded = new SpanBatchBuilder(master);
        seeded.Add(new SpanClaim(new TextSpan(0, 1), "seed", SpanLevel.Character, "test"));
        RegexCollector.CollectInto(seeded, new[] { rules[0] });
        Equal(4, seeded.Count, "collection appends to a pre-populated builder");

        seeded.Freeze();
        Throws<InvalidOperationException>(
            () => RegexCollector.CollectInto(seeded, new[] { rules[0] }),
            "a frozen builder is rejected up front");
    }

    private static void UnknownCaptureGroupFailsAtValidation()
    {
        var master = new TextMaster("capture", 0, "x abc");
        var misspelled = new PatternRule(
            "title", @"(?<title>\w+)", "title", "test", captureGroup: "titel");

        var builder = new SpanBatchBuilder(master);
        var thrown = (ArgumentException?)null;
        try
        {
            RegexCollector.CollectInto(builder, new[] { misspelled });
        }
        catch (ArgumentException exception)
        {
            thrown = exception;
        }

        True(thrown is not null, "an undefined capture group is rejected at validation");
        True(thrown!.Message.Contains("'titel'", StringComparison.Ordinal), "the rejection names the group");
        True(thrown.Message.Contains("'title'", StringComparison.Ordinal), "the rejection names the rule");
        Equal(0, builder.Count, "capture-group rejection adds nothing");

        // Numeric groups resolve by their string name: "1" exists, "2" does not.
        var numeric = RegexCollector.Collect(
            master,
            new[] { new PatternRule("num", @"x (\w+)", "num", "test", captureGroup: "1") });
        Equal(1, numeric.Count, "a defined numeric group collects");
        Equal(new TextSpan(2, 5), numeric[0].Span, "the numeric group's extent is claimed");
        Throws<ArgumentException>(
            () => RegexCollector.Collect(
                master,
                new[] { new PatternRule("num", @"x (\w+)", "num", "test", captureGroup: "2") }),
            "an undefined numeric group is rejected");

        // The loader wraps the same probe with file-and-line provenance.
        var loadFailure = (PatternRuleLoadException?)null;
        try
        {
            PatternRuleLoader.Load(
                new[] { """{"id":"t","pattern":"(?<title>\\w+)","kind":"k","source":"s","captureGroup":"titel"}""" },
                "capture.jsonl");
        }
        catch (PatternRuleLoadException exception)
        {
            loadFailure = exception;
        }

        True(loadFailure is not null, "the loader rejects the misspelled group");
        Equal(1, loadFailure!.LineNumber, "the loader failure carries the line");
        True(
            loadFailure.Message.Contains("'titel'", StringComparison.Ordinal),
            "the loader failure names the group");
    }

    private static void UndefinedEnumValuesAreRejected()
    {
        Throws<ArgumentOutOfRangeException>(
            () => new PatternRule("x", "a", "k", "s", (SpanLevel)99),
            "an undefined SpanLevel cast is rejected by the rule constructor");
        Throws<ArgumentOutOfRangeException>(
            () => new PatternRule("x", "a", "k", "s", SpanLevel.Character, (ExecutionScope)7),
            "an undefined ExecutionScope cast is rejected by the rule constructor");

        var builder = new SpanBatchBuilder(new TextMaster("enums", 0, "abc"));
        Throws<ArgumentException>(
            () => builder.Add(new SpanClaim(new TextSpan(0, 1), "k", (SpanLevel)99, "s")),
            "an undefined SpanLevel on a direct claim is rejected by the builder");
        Equal(0, builder.Count, "the rejected claim was not added");
    }

    private static void EmptySpansHaveSetSemantics()
    {
        var contained = new TextSpan(5, 5);
        var container = new TextSpan(0, 10);
        True(!contained.Intersects(container), "an empty span intersects nothing");
        True(!container.Intersects(contained), "nothing intersects an empty span");
        True(!contained.Intersects(contained), "an empty span does not intersect itself");
        True(!new TextSpan(0, 5).Intersects(new TextSpan(5, 9)), "meeting spans do not intersect");
        True(new TextSpan(0, 6).Intersects(new TextSpan(5, 9)), "overlapping spans intersect");
        True(container.Contains(contained), "the subset relation keeps empty-set semantics");
        True(container.Contains(5), "the point query is the named operation");

        var master = new TextMaster("point-query", 0, "0123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 10), "outer", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(4, 6), "inner", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        Equal(0, batch.Sorted.FindIntersecting(new TextSpan(5, 5)).Count, "an empty query finds nothing");
        Equal(2, batch.Sorted.FindContaining(5).Count, "the point query finds the covering claims");
        Equal("outer", batch.Sorted.FindContaining(5)[0].Kind, "point results keep the stable start order");
        Equal(1, batch.Sorted.FindContaining(2).Count, "a point outside the inner claim finds only the outer");
        Equal(0, batch.Sorted.FindContaining(master.Length).Count, "the end-of-master position is covered by nothing");
        Throws<ArgumentOutOfRangeException>(
            () => batch.Sorted.FindContaining(master.Length + 1),
            "a position beyond the master is rejected");
    }

    private static void ReferenceJoinRelatesEveryPair()
    {
        var master = new TextMaster("joins", 0, "01234567890123456789");
        var leftBuilder = new SpanBatchBuilder(master);
        leftBuilder.Add(new SpanClaim(new TextSpan(0, 5), "a", SpanLevel.Character, "test"));
        leftBuilder.Add(new SpanClaim(new TextSpan(10, 20), "b", SpanLevel.Character, "test"));
        var left = leftBuilder.Freeze();

        var rightBuilder = new SpanBatchBuilder(master);
        rightBuilder.Add(new SpanClaim(new TextSpan(5, 10), "c", SpanLevel.Character, "test"));
        rightBuilder.Add(new SpanClaim(new TextSpan(12, 18), "d", SpanLevel.Character, "test"));
        rightBuilder.Add(new SpanClaim(new TextSpan(0, 5), "e", SpanLevel.Character, "test"));
        var right = rightBuilder.Freeze();

        var joined = IntervalJoins.Join(left, right);
        var pairView = ClaimPairView.Relate(left, right, AllenRelationSet.All);
        Equal(left.Count * right.Count, joined.Count, "the unfiltered join relates every pair");
        Equal(pairView.Count, joined.Count, "the compatibility join projects the exact pair view");
        Equal(AllenRelation.Meets, joined[0].Relation, "[0,5) meets [5,10)");
        Equal(AllenRelation.Equal, joined[2].Relation, "[0,5) equals [0,5)");
        Equal(AllenRelation.MetBy, joined[3].Relation, "[10,20) is met by [5,10)");
        Equal(AllenRelation.Contains, joined[4].Relation, "[10,20) contains [12,18)");
        Equal(0, joined[0].Left.Ordinal, "join rows carry the left record");
        Equal(0, joined[0].Right.Ordinal, "join rows carry the right record");

        var projectedExactly = true;
        var pairRows = pairView.ToArray();
        for (var i = 0; i < pairRows.Length; i++)
        {
            projectedExactly &=
                joined[i].Left.Ordinal == pairRows[i].LeftOrdinal &&
                joined[i].Right.Ordinal == pairRows[i].RightOrdinal &&
                joined[i].Relation == pairRows[i].Relation;
        }

        True(projectedExactly, "every terminal join row is the corresponding pair-view edge");

        var contains = IntervalJoins.Join(
            left, right, AllenRelationSet.Singleton(AllenRelation.Contains));
        var containsView = ClaimPairView.Relate(
            left, right, AllenRelationSet.Singleton(AllenRelation.Contains));
        Equal(1, contains.Count, "the filtered join keeps only the requested relations");
        Equal(containsView.Count, contains.Count, "the filtered compatibility projection shares pair semantics");
        Equal("b", contains[0].Left.Kind, "the filtered row's left claim");
        Equal("d", contains[0].Right.Kind, "the filtered row's right claim");
        Equal(0, IntervalJoins.Join(left, right, AllenRelationSet.None).Count, "the closed empty filter joins nothing");

        var foreignBuilder = new SpanBatchBuilder(new TextMaster("join-foreign", 0, master.Text));
        foreignBuilder.Add(new SpanClaim(new TextSpan(0, 5), "f", SpanLevel.Character, "test"));
        Throws<InvalidOperationException>(
            () => IntervalJoins.Join(left, foreignBuilder.Freeze()),
            "a cross-master join is rejected");
    }

    private static void ProjectMapsSpansOntoLineRanges()
    {
        var master = new TextMaster("project", 0, "ab\ncd\nef");
        var topology = master.Topology;

        Equal(new LineRange(0, 1), topology.Project(new TextSpan(0, 2)), "a one-line span projects to its line");
        Equal(new LineRange(0, 1), topology.Project(new TextSpan(2, 3)), "the terminator belongs to its line");
        Equal(new LineRange(0, 2), topology.Project(new TextSpan(0, 5)), "a bridging span projects to both lines");
        Equal(new LineRange(1, 3), topology.Project(new TextSpan(4, 8)), "a mid-start span projects to its line range");
        Equal(new LineRange(0, 3), topology.Project(master.Extent), "the whole extent projects to every line");

        // The documented insertion-point convention: an empty span projects to the one-line range
        // containing its position, never to an empty range.
        Equal(new LineRange(1, 2), topology.Project(new TextSpan(3, 3)), "a line-start insertion point names its line");
        Equal(new LineRange(0, 1), topology.Project(new TextSpan(2, 2)), "a pre-terminator insertion point stays on its line");
        Equal(new LineRange(2, 3), topology.Project(new TextSpan(8, 8)), "the end-of-text insertion point names the last line");

        var trailing = new TextMaster("project-trailing", 0, "ab\n");
        Equal(
            new LineRange(1, 2),
            trailing.Topology.Project(new TextSpan(3, 3)),
            "the empty final line is a real projection target");

        Throws<ArgumentOutOfRangeException>(
            () => topology.Project(new TextSpan(0, 9)),
            "a span beyond the text is rejected");
    }

    private static void EmitRunsHonorsACustomComparer()
    {
        var master = new TextMaster("custom-comparer", 0, "aA bB");
        var slice = (Func<TextAtom, string>)(atom => master.Slice(atom.Span));

        var exact = master.Topology.EmitRuns(slice);
        Equal(5, exact.Count, "the default comparer breaks on exact ordinal keys");

        var folded = master.Topology.EmitRuns(slice, StringComparer.OrdinalIgnoreCase);
        AssertRunsTile(master, folded, "case-folded");
        Equal(3, folded.Count, "a case-insensitive comparer joins the case-variant runs");
        Equal(new TextSpan(0, 2), folded[0].Span, "the folded letter run spans both cases");
        Equal("a", folded[0].Key, "a run carries the first key it broke on");
        Equal(2, folded[0].AtomCount, "the folded run counts both atoms");
        Equal(" ", folded[1].Key, "the separator run key");
        Equal("b", folded[2].Key, "the second folded run key");
    }

    /// <summary>
    /// D18: the CultureInvariant union happens in the PatternRule constructor — the engine
    /// boundary — not in the JSONL loader, so an inventory rule and a directly constructed rule
    /// are one collector contract and neither ever inherits the ambient culture.
    /// </summary>
    private static void RegexOptionsUnionCultureInvariantAtTheEngineBoundary()
    {
        Equal(
            RegexOptions.CultureInvariant,
            new PatternRule("d", "a", "k", "s").Options,
            "the default option set is culture-invariant");
        Equal(
            RegexOptions.CultureInvariant,
            new PatternRule("d", "a", "k", "s", options: RegexOptions.None).Options,
            "an explicit None still unions the invariant");
        Equal(
            RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
            new PatternRule("d", "a", "k", "s", options: RegexOptions.IgnoreCase).Options,
            "a direct DLL caller's options are unioned, not replaced");

        var loaded = PatternRuleLoader.Load(
            new[] { """{"id":"i","pattern":"I","kind":"k","source":"s","options":["IgnoreCase"]}""" },
            "options.jsonl");
        Equal(
            RegexOptions.IgnoreCase | RegexOptions.CultureInvariant,
            loaded[0].Options,
            "an inventory's option list is unioned at the same boundary");

        // Options augment the baseline, never replace the execution policy: ECMAScript is a
        // different matching profile, so it is rejected even though net10 itself would accept
        // ECMAScript|CultureInvariant.
        Throws<ArgumentException>(
            () => new PatternRule("d", "a", "k", "s", options: RegexOptions.ECMAScript),
            "ECMAScript is rejected at the engine boundary");
        Throws<ArgumentException>(
            () => new PatternRule(
                "d", "a", "k", "s",
                options: RegexOptions.ECMAScript | RegexOptions.IgnoreCase),
            "ECMAScript is rejected in combination too");
        var ecma = LoadFails(
            """{"id":"e","pattern":"a","kind":"k","source":"s","options":["ECMAScript"]}""",
            "an ECMAScript inventory fails at load");
        True(
            ecma.Message.Contains("ECMAScript", StringComparison.Ordinal),
            "the load failure names the rejected option");

        // The Turkish-I witness: under tr-TR, culture-sensitive IgnoreCase folds 'I' onto the
        // dotless 'ı'; the invariant fold does not. Collection must give the invariant answer
        // even while the ambient culture would have said otherwise.
        var original = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = CultureInfo.GetCultureInfo("tr-TR");
            True(
                new Regex("I", RegexOptions.IgnoreCase).IsMatch("ı"),
                "the ambient tr-TR culture would have matched the dotless ı");

            var master = new TextMaster("turkish-i", 0, "ı");
            var collected = RegexCollector.Collect(
                master,
                new[] { new PatternRule("i", "I", "k", "s", options: RegexOptions.IgnoreCase) });
            Equal(0, collected.Count, "collection never inherits the ambient culture");
        }
        finally
        {
            CultureInfo.CurrentCulture = original;
        }
    }

    /// <summary>
    /// D19: a slice mints a fragment-local child master with derived, deterministic identity.
    /// The slice object carries the lineage; the identity floor still keeps child and parent
    /// unmixable, and slicing forces neither topology nor fingerprint on either side.
    /// </summary>
    private static void SliceMintsAFragmentLocalChild()
    {
        var parent = new TextMaster("doc", 3, "abc \U0001F600 def\nghi");
        var slice = TextSlice.Create(parent, new TextSpan(4, 10));

        Equal("\U0001F600 def", slice.Child.Text, "the child is the window's text");
        Equal("doc#4-10", slice.Child.DocumentId, "child identity is derived and deterministic");
        Equal(3L, slice.Child.Revision, "the child carries the parent's revision");
        Equal(new TextSpan(4, 10), slice.Window, "the window is recorded in parent coordinates");
        True(ReferenceEquals(slice.Parent, parent), "the lineage names its parent");
        True(!slice.Child.IsCompatibleWith(parent), "child and parent are distinct coordinate spaces");

        // Deterministic identity makes recreated slices interoperable coordinate spaces.
        var again = TextSlice.Create(parent, new TextSpan(4, 10));
        True(slice.Child.IsCompatibleWith(again.Child), "recreating the slice mints a compatible child");

        // Even a whole-extent child is its own coordinate space: lineage is explicit, not
        // structural, and mixing stays loud.
        var whole = TextSlice.Create(parent, parent.Extent);
        Equal(parent.Text, whole.Child.Text, "a whole-extent child carries the whole text");
        True(!whole.Child.IsCompatibleWith(parent), "a whole-extent child still refuses the parent");

        var empty = TextSlice.Create(parent, new TextSpan(7, 7));
        Equal(0, empty.Child.Length, "an empty window mints an empty child");
        Equal("doc#7-7", empty.Child.DocumentId, "the empty child's identity still names its window");

        Throws<ArgumentNullException>(
            () => TextSlice.Create(null!, new TextSpan(0, 1)),
            "a null parent is rejected");
        Throws<ArgumentOutOfRangeException>(
            () => TextSlice.Create(parent, new TextSpan(0, parent.Length + 1)),
            "an out-of-bounds window is rejected");
        Throws<ArgumentException>(
            () => TextSlice.Create(parent, new TextSpan(0, 5)),
            "a surrogate-splitting window is rejected");

        // D12: slicing is substring work; neither master pays for topology or fingerprint.
        var lazyParent = new TextMaster("lazy-slice", 0, "alpha beta gamma");
        var lazySlice = TextSlice.Create(lazyParent, new TextSpan(6, 10));
        True(!lazyParent.TopologyIsCreated, "slicing leaves the parent topology unbuilt");
        True(!lazyParent.FingerprintIsCreated, "slicing leaves the parent fingerprint uncomputed");
        True(!lazySlice.Child.TopologyIsCreated, "the child topology is not built by minting");
    }

    /// <summary>
    /// D19: child → parent rebase is a total bijection on the child's domain — offsets and
    /// spans round-trip, lengths are preserved, Allen relations are invariant — and
    /// parent → child refuses out-of-window geometry loudly rather than clamping.
    /// </summary>
    private static void RebaseIsATotalBijection()
    {
        var parent = new TextMaster("bijection", 0, "xx\U0001F600yy\nzz\U0001F600ww");
        var slice = TextSlice.Create(parent, new TextSpan(2, 11));
        Equal("\U0001F600yy\nzz\U0001F600", slice.Child.Text, "fixture window");

        var offsetsRoundTrip = true;
        for (var offset = 0; offset <= slice.Child.Length; offset++)
        {
            if (slice.ToChild(slice.ToParent(offset)) != offset)
            {
                offsetsRoundTrip = false;
            }
        }

        True(offsetsRoundTrip, "offset rebase round-trips over the whole child domain");

        var windowRoundTrips = true;
        for (var offset = slice.Window.Start; offset <= slice.Window.End; offset++)
        {
            if (slice.ToParent(slice.ToChild(offset)) != offset)
            {
                windowRoundTrips = false;
            }
        }

        True(windowRoundTrips, "offset rebase round-trips over the whole window domain");
        Equal(slice.Window.End, slice.ToParent(slice.Child.Length), "the child end maps to the window end");
        Equal(slice.Window, slice.ToParent(slice.Child.Extent), "the child extent maps to the window");
        Equal(slice.Child.Extent, slice.ToChild(slice.Window), "the window maps to the child extent");

        // Every valid child span: length preserved, round-trip identity, parent-valid image.
        var validSpans = new List<TextSpan>();
        for (var start = 0; start <= slice.Child.Length; start++)
        {
            for (var end = start; end <= slice.Child.Length; end++)
            {
                if (slice.Child.IsScalarBoundary(start) && slice.Child.IsScalarBoundary(end))
                {
                    validSpans.Add(new TextSpan(start, end));
                }
            }
        }

        var spansPreserved = true;
        foreach (var span in validSpans)
        {
            var image = slice.ToParent(span);
            if (image.Length != span.Length || slice.ToChild(image) != span)
            {
                spansPreserved = false;
            }
        }

        True(spansPreserved, "span rebase preserves length and round-trips for every valid span");

        var allenInvariant = true;
        foreach (var left in validSpans)
        {
            if (left.IsEmpty)
            {
                continue;
            }

            foreach (var right in validSpans)
            {
                if (right.IsEmpty)
                {
                    continue;
                }

                if (AllenAlgebra.Relate(left, right) !=
                    AllenAlgebra.Relate(slice.ToParent(left), slice.ToParent(right)))
                {
                    allenInvariant = false;
                }
            }
        }

        True(allenInvariant, "Allen relations are invariant under rebase");

        Throws<ArgumentOutOfRangeException>(
            () => slice.ToParent(slice.Child.Length + 1),
            "a beyond-child offset is refused going up");
        Throws<ArgumentOutOfRangeException>(
            () => slice.ToChild(slice.Window.Start - 1),
            "a pre-window offset is refused going down");
        Throws<ArgumentOutOfRangeException>(
            () => slice.ToChild(slice.Window.End + 1),
            "a post-window offset is refused going down");
        Throws<ArgumentException>(
            () => slice.ToParent(new TextSpan(0, 1)),
            "a surrogate-splitting child span is refused going up");
        Throws<ArgumentException>(
            () => slice.ToChild(new TextSpan(0, 4)),
            "a window-crossing parent span is refused, never clamped");
        Throws<ArgumentException>(
            () => slice.ToChild(new TextSpan(11, 13)),
            "an outside parent span is refused going down");
    }

    /// <summary>
    /// D19: sets and batches rebase as plain coordinate arithmetic — claims keep their kind,
    /// level, source, priority and rule identity — and the weaving form composes several
    /// fragments' collections into one parent batch. Parent → child set rebase demands
    /// containment; the recipe is to intersect with the window first.
    /// </summary>
    private static void RebaseCarriesSetsAndBatches()
    {
        var parent = new TextMaster("carry", 0, "foo bar baz qux");
        var slice = TextSlice.Create(parent, new TextSpan(4, 11));
        Equal("bar baz", slice.Child.Text, "fixture window");

        var childSet = SpanSet.Create(slice.Child, new[] { new TextSpan(0, 3), new TextSpan(4, 7) });
        var lifted = slice.ToParent(childSet);
        True(ReferenceEquals(lifted.Master, parent), "the lifted set is parent-bound");
        Equal(2, lifted.Count, "the lifted set keeps its regions");
        Equal(new TextSpan(4, 7), lifted[0], "the first region is re-addressed");
        Equal(new TextSpan(8, 11), lifted[1], "the second region is re-addressed");
        Equal(childSet.Coverage, lifted.Coverage, "coverage is preserved");
        True(slice.ToChild(lifted).Equals(childSet), "set rebase round-trips");

        var mixed = SpanSet.Create(parent, new[] { new TextSpan(0, 3), new TextSpan(8, 11) });
        Throws<ArgumentException>(
            () => slice.ToChild(mixed),
            "an out-of-window region is refused going down");
        var scoped = mixed.Intersect(SpanSet.Create(parent, new[] { slice.Window }));
        True(
            slice.ToChild(scoped).Equals(SpanSet.Create(slice.Child, new[] { new TextSpan(4, 7) })),
            "intersect-with-window then rebase is the scoping recipe");

        var rules = new[] { new PatternRule("word", @"\w+", "word", "test", priority: 2) };
        var childBatch = RegexCollector.Collect(slice.Child, rules);
        Equal(2, childBatch.Count, "the child collection sees its two words");

        var rebased = slice.ToParent(childBatch);
        True(ReferenceEquals(rebased.Master, parent), "the rebased batch is parent-bound");
        Equal(2, rebased.Count, "every claim is carried");
        Equal("bar", parent.Slice(rebased[0].Span), "the first claim re-addresses to its text");
        Equal("baz", parent.Slice(rebased[1].Span), "the second claim re-addresses to its text");
        Equal("word", rebased[0].Kind, "kind rides through untouched");
        Equal("test", rebased[0].Source, "source rides through untouched");
        Equal(2, rebased[0].Priority, "priority rides through untouched");
        Equal("word", rebased[0].RuleId, "rule identity rides through untouched");
        Equal(SpanLevel.Character, rebased[0].Level, "level rides through untouched");

        // The weaving form: collect on several fragments, rebase each into one parent batch.
        var tail = TextSlice.Create(parent, new TextSpan(12, 15));
        var weave = new SpanBatchBuilder(parent);
        slice.ToParentInto(weave, childBatch);
        tail.ToParentInto(weave, RegexCollector.Collect(tail.Child, rules));
        var woven = weave.Freeze();
        Equal(3, woven.Count, "two fragments weave into one parent batch");
        Equal("qux", parent.Slice(woven[2].Span), "the second fragment's claim lands after the first's");

        // Deterministic identity pays off: a recreated slice rebases another lineage's batch.
        var again = TextSlice.Create(parent, new TextSpan(4, 11));
        Equal(2, again.ToParent(childBatch).Count, "a recreated slice rebases the original child's batch");

        Throws<InvalidOperationException>(
            () => slice.ToParentInto(weave, childBatch),
            "a frozen weaving builder is refused up front");
        Throws<InvalidOperationException>(
            () => slice.ToParentInto(new SpanBatchBuilder(slice.Child), childBatch),
            "a child-bound builder is refused — weaving targets the parent");
        Throws<InvalidOperationException>(
            () => slice.ToParent(SpanSet.Whole(parent)),
            "a parent-bound set is refused going up");
        Throws<InvalidOperationException>(
            () => tail.ToParent(childBatch),
            "another slice's child batch is refused");
    }

    /// <summary>
    /// The D12 witness: collecting on the fragment and rebasing equals collecting on the parent
    /// scoped to the window — for whole-master and per-line rules alike, because both match the
    /// same sliced region strings; the child's line topology is the parent's, clipped at the
    /// window edges exactly as the scoped intersection clips.
    /// </summary>
    private static void CollectionCommutesWithRebase()
    {
        var parent = new TextMaster("witness", 0, "alpha beta\ngamma delta\nepsilon");
        var window = new TextSpan(6, 22);
        var slice = TextSlice.Create(parent, window);
        Equal("beta\ngamma delta", slice.Child.Text, "the window cuts mid-line at both edges");

        var rules = new[]
        {
            new PatternRule("word", @"\w+", "word", "test"),
            new PatternRule("line-word", @"\w+", "line-word", "test", SpanLevel.Character, ExecutionScope.PerLine),
        };

        var viaChild = slice.ToParent(RegexCollector.Collect(slice.Child, rules));
        var viaParent = RegexCollector.Collect(parent, rules, SpanSet.Create(parent, new[] { window }));

        Equal(viaParent.Count, viaChild.Count, "both routes see the same number of claims");
        var agreement = new StringBuilder();
        var expectation = new StringBuilder();
        for (var i = 0; i < viaParent.Count; i++)
        {
            expectation.Append(viaParent[i].Kind).Append('@').Append(viaParent[i].Span).Append(';');
            agreement.Append(viaChild[i].Kind).Append('@').Append(viaChild[i].Span).Append(';');
        }

        Equal(expectation.ToString(), agreement.ToString(), "collection commutes with rebase, claim for claim");
        True(viaParent.Count(record => record.Kind == "line-word") == 3, "the per-line route exercises clipped lines");
    }

    /// <summary>D19: slices compose by chaining rebases; nested identity encodes the chain.</summary>
    private static void SlicesCompose()
    {
        var parent = new TextMaster("compose", 0, "0123456789");
        var outer = TextSlice.Create(parent, new TextSpan(2, 9));
        var inner = TextSlice.Create(outer.Child, new TextSpan(1, 5));

        Equal("2345678", outer.Child.Text, "outer window text");
        Equal("3456", inner.Child.Text, "inner window text");
        Equal("compose#2-9#1-5", inner.Child.DocumentId, "nested identity encodes the chain");

        var chained = true;
        for (var offset = 0; offset <= inner.Child.Length; offset++)
        {
            if (outer.ToParent(inner.ToParent(offset)) != 3 + offset)
            {
                chained = false;
            }
        }

        True(chained, "chained rebase is offset addition");
        Equal(
            new TextSpan(3, 7),
            outer.ToParent(inner.ToParent(new TextSpan(0, 4))),
            "a nested span lifts through both lineages");
        Equal(
            new TextSpan(0, 4),
            inner.ToChild(outer.ToChild(new TextSpan(3, 7))),
            "the descent inverts the chained lift");
    }

    /// <summary>
    /// D21/D22: keyed grouping is a deterministic partition — groups in first-appearance order,
    /// ordinals ascending, the key carried on the group, caller comparers honored, null a
    /// legitimate key — and key-only grouping never forces the line topology.
    /// </summary>
    private static void GroupingByKeyIsADeterministicPartition()
    {
        var master = new TextMaster("group-key", 0, "0123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 2), "heading", SpanLevel.Line, "scanner", 3, "atx"));
        builder.Add(new SpanClaim(new TextSpan(2, 4), "word", SpanLevel.Character, "scanner", 1));
        builder.Add(new SpanClaim(new TextSpan(4, 6), "heading", SpanLevel.Line, "human", 3, "setext"));
        builder.Add(new SpanClaim(new TextSpan(6, 8), "note", SpanLevel.Character, "human", 1));
        var batch = builder.Freeze();

        var byKind = Grouping.ByKey(batch, ClaimFacts.Kind);
        Equal(3, byKind.Count, "distinct kinds group once each");
        Equal("heading", byKind[0].Key, "groups appear in first-appearance order");
        Equal("word", byKind[1].Key, "second-appearing kind is second");
        Equal("note", byKind[2].Key, "third-appearing kind is third");
        Equal("0,2", string.Join(",", byKind[0].Ordinals), "ordinals ascend within a group");
        Equal("1", string.Join(",", byKind[1].Ordinals), "singleton group membership");

        // Partition: every ordinal lands in exactly one group.
        var seen = new HashSet<int>();
        var partition = true;
        foreach (var group in byKind)
        {
            foreach (var ordinal in group.Ordinals)
            {
                if (!seen.Add(ordinal))
                {
                    partition = false;
                }
            }
        }

        True(partition && seen.Count == batch.Count, "keyed grouping partitions the batch");

        var byPriority = Grouping.ByKey(batch, ClaimFacts.Priority);
        Equal(2, byPriority.Count, "an int-keyed fact groups");
        Equal(3, byPriority[0].Key, "the int group carries its key");

        var byRule = Grouping.ByKey(batch, ClaimFacts.RuleId);
        Equal(3, byRule.Count, "rule ids group with null as a legitimate key");
        Equal(null, byRule[1].Key, "the null group carries the null key");
        Equal("1,3", string.Join(",", byRule[1].Ordinals), "rule-less claims share the null group");

        // A caller comparer changes the grouping, exactly as with EmitRuns (D22: one selector
        // shape, plain delegates, comparers on the same footing).
        var caseBuilder = new SpanBatchBuilder(master);
        caseBuilder.Add(new SpanClaim(new TextSpan(0, 1), "Heading", SpanLevel.Line, "test"));
        caseBuilder.Add(new SpanClaim(new TextSpan(1, 2), "heading", SpanLevel.Line, "test"));
        var caseBatch = caseBuilder.Freeze();
        Equal(2, Grouping.ByKey(caseBatch, ClaimFacts.Kind).Count, "ordinal keys split case variants");
        Equal(
            1,
            Grouping.ByKey(caseBatch, ClaimFacts.Kind, StringComparer.OrdinalIgnoreCase).Count,
            "a case-insensitive comparer joins them");

        // Composite keys via tuples, mirroring the AtomFacts idiom.
        Equal(
            4,
            Grouping.ByKey(batch, record => (record.Kind, record.Source)).Count,
            "a tuple selector groups on both facts");

        // Determinism on repeat.
        var replay = Grouping.ByKey(batch, ClaimFacts.Kind);
        var stable = replay.Count == byKind.Count;
        for (var i = 0; stable && i < replay.Count; i++)
        {
            if (!StringComparer.Ordinal.Equals(replay[i].Key, byKind[i].Key) ||
                string.Join(",", replay[i].Ordinals) != string.Join(",", byKind[i].Ordinals))
            {
                stable = false;
            }
        }

        True(stable, "repeated grouping reproduces the same groups");

        Equal(0, Grouping.ByKey(new SpanBatchBuilder(master).Freeze(), ClaimFacts.Kind).Count, "an empty batch has no groups");

        // D12: grouping by claim facts is columnar work; the line topology stays unbuilt.
        var lazy = TextMaster.Create("lazy grouping text");
        var lazyBuilder = new SpanBatchBuilder(lazy);
        lazyBuilder.Add(new SpanClaim(new TextSpan(0, 4), "k", SpanLevel.Character, "s"));
        _ = Grouping.ByKey(lazyBuilder.Freeze(), ClaimFacts.Kind);
        True(!lazy.TopologyIsCreated, "key-only grouping leaves the topology unbuilt");

        Throws<ArgumentNullException>(
            () => Grouping.ByKey(batch, (Func<SpanRecord, string>)null!),
            "a null selector is rejected");
    }

    /// <summary>
    /// D21: the claim-major projection and the line-major grouping are basis-stamped transposes
    /// of one another — the view answers "over what was I computed" with typed references, and
    /// under EveryLineTouched, ordinal o touches line i exactly when line i lists ordinal o.
    /// </summary>
    private static void ProjectionAndLineGroupsAreStampedTransposes()
    {
        var master = new TextMaster("group-lines", 0, "ab\ncd\nef");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 2), "one-line", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(1, 4), "crosser", SpanLevel.MultiLine, "test"));
        builder.Add(new SpanClaim(new TextSpan(3, 8), "tail", SpanLevel.MultiLine, "test"));
        builder.Add(new SpanClaim(new TextSpan(6, 8), "last", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var projection = Projection.Project(batch);
        Equal(batch.Count, projection.Ranges.Count, "one range per claim, ordinal-aligned");
        True(ReferenceEquals(projection.Source, batch), "the projection is stamped with its source batch");
        True(ReferenceEquals(projection.Master, master), "the projection is stamped with its master");
        Equal(new LineRange(0, 1), projection.Ranges[0], "a one-line claim projects to its line");
        Equal(new LineRange(0, 2), projection.Ranges[1], "a crossing claim projects to both lines");
        Equal(new LineRange(1, 3), projection.Ranges[2], "the tail claim projects to its range");

        var agrees = true;
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            if (projection.Ranges[ordinal] != master.Topology.Project(batch[ordinal].Span))
            {
                agrees = false;
            }
        }

        True(agrees, "the batch projection agrees with the span-level Project");

        var view = Grouping.ByLine(batch);
        Equal(LineMembership.EveryLineTouched, view.Membership, "the membership policy is stamped");
        True(ReferenceEquals(view.Source, batch), "the view is stamped with its source batch");
        True(ReferenceEquals(view.Master, master), "the view is stamped with its master");
        Equal(master.Topology.LineCount, view.Lines.Count, "the view is total over the line grain");

        var extentsMatch = true;
        var indexed = true;
        for (var line = 0; line < view.Lines.Count; line++)
        {
            if (view.Lines[line].Extent != master.Topology.GetLineExtent(line))
            {
                extentsMatch = false;
            }

            if (view.Lines[line].LineIndex != line)
            {
                indexed = false;
            }
        }

        True(extentsMatch, "each line carries its full partition extent");
        True(indexed, "line groups are index-aligned with the topology");

        Equal("0,1", string.Join(",", view.Lines[0].Ordinals), "line 0 holds its claims in ascending order");
        Equal("1,2", string.Join(",", view.Lines[1].Ordinals), "the crossing claim appears on every touched line");
        Equal("2,3", string.Join(",", view.Lines[2].Ordinals), "the last line holds the tail and the local claim");

        // The transpose law, both directions.
        var transpose = true;
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            for (var line = 0; line < view.Lines.Count; line++)
            {
                var projected = projection.Ranges[ordinal].Start <= line && line < projection.Ranges[ordinal].End;
                var listed = view.Lines[line].Ordinals.Contains(ordinal);
                if (projected != listed)
                {
                    transpose = false;
                }
            }
        }

        True(transpose, "projection and line grouping are transposes under EveryLineTouched");

        // Totality includes claimless lines and the empty final line.
        var sparse = new TextMaster("group-sparse", 0, "ab\n\ncd\n");
        var sparseBuilder = new SpanBatchBuilder(sparse);
        sparseBuilder.Add(new SpanClaim(new TextSpan(0, 2), "k", SpanLevel.Character, "test"));
        var sparseView = Grouping.ByLine(sparseBuilder.Freeze());
        Equal(4, sparseView.Lines.Count, "empty and final lines are present in the partition");
        Equal(0, sparseView.Lines[1].Ordinals.Count, "a claimless empty line carries an empty group");
        Equal(0, sparseView.Lines[3].Ordinals.Count, "the empty final line carries an empty group");
        Equal(new TextSpan(7, 7), sparseView.Lines[3].Extent, "the empty final line still states its extent");
    }

    /// <summary>
    /// D21: line membership is a declared policy. StartLineOnly attributes each claim exactly
    /// once, at its start line; the two policies differ exactly on multi-line claims; undefined
    /// policy values are refused.
    /// </summary>
    private static void LineMembershipIsADeclaredPolicy()
    {
        var master = new TextMaster("membership", 0, "ab\ncd\nef");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 2), "one-line", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(1, 4), "crosser", SpanLevel.MultiLine, "test"));
        builder.Add(new SpanClaim(new TextSpan(3, 8), "tail", SpanLevel.MultiLine, "test"));
        builder.Add(new SpanClaim(new TextSpan(6, 8), "last", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var touched = Grouping.ByLine(batch, LineMembership.EveryLineTouched);
        var attributed = Grouping.ByLine(batch, LineMembership.StartLineOnly);
        Equal(LineMembership.StartLineOnly, attributed.Membership, "the attribution policy is stamped");

        Equal("0,1", string.Join(",", attributed.Lines[0].Ordinals), "start-line attribution for line 0");
        Equal("2", string.Join(",", attributed.Lines[1].Ordinals), "the crosser is not re-attributed to line 1");
        Equal("3", string.Join(",", attributed.Lines[2].Ordinals), "the tail is not re-attributed to line 2");

        // Attribution is a partition: each claim exactly once, at its start line.
        var counts = new int[batch.Count];
        var startLines = true;
        foreach (var line in attributed.Lines)
        {
            foreach (var ordinal in line.Ordinals)
            {
                counts[ordinal]++;
                if (master.Topology.GetLineIndex(batch[ordinal].Span.Start) != line.LineIndex)
                {
                    startLines = false;
                }
            }
        }

        True(Array.TrueForAll(counts, count => count == 1), "attribution assigns each claim exactly once");
        True(startLines, "attribution lands each claim on its start line");

        // The policies differ exactly on multi-line claims.
        var policiesAgreeOnSingles = true;
        var policiesDifferOnCrossers = true;
        var projection = Projection.Project(batch);
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            var touchedCount = 0;
            var attributedCount = 0;
            for (var line = 0; line < touched.Lines.Count; line++)
            {
                if (touched.Lines[line].Ordinals.Contains(ordinal))
                {
                    touchedCount++;
                }

                if (attributed.Lines[line].Ordinals.Contains(ordinal))
                {
                    attributedCount++;
                }
            }

            var lineSpan = projection.Ranges[ordinal].Count;
            if (lineSpan == 1 && (touchedCount != 1 || attributedCount != 1))
            {
                policiesAgreeOnSingles = false;
            }

            if (lineSpan > 1 && (touchedCount != lineSpan || attributedCount != 1))
            {
                policiesDifferOnCrossers = false;
            }
        }

        True(policiesAgreeOnSingles, "single-line claims are identical under both policies");
        True(policiesDifferOnCrossers, "multi-line claims occupy every touched line yet attribute once");

        Throws<ArgumentOutOfRangeException>(
            () => Grouping.ByLine(batch, (LineMembership)9),
            "an undefined membership policy is refused");
    }

    /// <summary>
    /// D23: gap cadence reports the mdnav template's facts — median gap (upper-median
    /// convention), cv (0 for even spacing, large for bursts), span fraction — computed
    /// whenever defined, with no meaning thresholds in the engine.
    /// </summary>
    private static void GapCadenceMeasuresTheTemplateFacts()
    {
        var master = new TextMaster("cadence-facts", 0, new string('x', 100));
        var builder = new SpanBatchBuilder(master);
        foreach (var start in new[] { 10, 30, 50, 70, 90 })
        {
            builder.Add(new SpanClaim(new TextSpan(start, start + 5), "h", SpanLevel.Line, "test"));
        }

        builder.Add(new SpanClaim(new TextSpan(3, 9), "w", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var even = GapCadence.Measure(batch, record => record.Kind == "h");
        Equal(5, even.Ordinals.Count, "the predicate selects the population");
        Equal(4, even.GapCount, "five occurrences give four gaps");
        Equal(20, even.MedianGap, "even spacing has its spacing as the median gap");
        Equal(20.0, even.MeanGap, "even spacing has its spacing as the mean gap");
        Equal(0.0, even.GapCv, "even spacing has zero cv");
        Equal(0.8, even.SpanFraction, "the population stretches (90-10)/100 of the window");

        var noisy = GapCadence.Measure(batch);
        Equal(6, noisy.Ordinals.Count, "without a predicate every start in the window counts");
        True(noisy.GapCv > 0, "the noise claim breaks the even cadence");

        var burstyBuilder = new SpanBatchBuilder(master);
        foreach (var start in new[] { 0, 1, 2, 50 })
        {
            burstyBuilder.Add(new SpanClaim(new TextSpan(start, start + 1), "b", SpanLevel.Character, "test"));
        }

        var bursty = GapCadence.Measure(burstyBuilder.Freeze());
        Equal(1, bursty.MedianGap, "a bursty population has a small median gap");
        True(bursty.GapCv > 1, "a bursty population has cv above one");

        // The template's upper-median convention on an even gap count.
        var pairBuilder = new SpanBatchBuilder(master);
        foreach (var start in new[] { 0, 1, 4 })
        {
            pairBuilder.Add(new SpanClaim(new TextSpan(start, start + 1), "m", SpanLevel.Character, "test"));
        }

        Equal(3, GapCadence.Measure(pairBuilder.Freeze()).MedianGap, "an even gap count takes the upper median");

        // Insertion order does not matter: the population is measured in start order.
        var shuffledBuilder = new SpanBatchBuilder(master);
        foreach (var start in new[] { 90, 10, 50, 70, 30 })
        {
            shuffledBuilder.Add(new SpanClaim(new TextSpan(start, start + 5), "h", SpanLevel.Line, "test"));
        }

        var shuffled = GapCadence.Measure(shuffledBuilder.Freeze());
        Equal(20, shuffled.MedianGap, "insertion order does not change the gaps");
        Equal(0.0, shuffled.GapCv, "insertion order does not change the cv");
        Equal("1,4,2,3,0", string.Join(",", shuffled.Ordinals), "ordinals report the start-order population");

        var replay = GapCadence.Measure(batch, record => record.Kind == "h");
        True(
            replay.MedianGap == even.MedianGap &&
            replay.GapCv == even.GapCv &&
            string.Join(",", replay.Ordinals) == string.Join(",", even.Ordinals),
            "the measure is deterministic on repeat");
    }

    /// <summary>
    /// D23: every D8 component is declared and stamped — the window admits by claim start, its
    /// length is the span-fraction denominator, exclusions are recorded as the measured
    /// ordinals, and degenerate populations report absent statistics rather than judgments.
    /// </summary>
    private static void GapCadenceDeclaresItsBasis()
    {
        var master = new TextMaster("cadence-basis", 0, new string('x', 100));
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(10, 15), "k", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(30, 50), "straddler", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(40, 45), "k", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(60, 65), "k", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(95, 100), "k", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var window = new TextSpan(35, 90);
        var measure = GapCadence.Measure(batch, null, window);
        True(ReferenceEquals(measure.Source, batch), "the measure is stamped with its source batch");
        True(ReferenceEquals(measure.Master, master), "the measure is stamped with its master");
        Equal(window, measure.Window, "the measure is stamped with its window basis");
        Equal(AddressUnit.Utf16CodeUnit, measure.Unit, "the measure declares its unit");

        Equal("2,3", string.Join(",", measure.Ordinals), "the window admits by claim start");
        True(
            !((IReadOnlyList<int>)measure.Ordinals).Contains(1),
            "a straddler starting before the window is excluded, not clamped in");
        Equal(1, measure.GapCount, "two admitted claims give one gap");
        Equal(20, measure.MedianGap, "the single gap is the median");
        Equal(0.0, measure.GapCv, "a single gap has zero cv");
        Equal(20 / 55.0, measure.SpanFraction, "the span fraction divides by the window length");

        // Degenerate populations: facts are absent, never judged.
        var empty = GapCadence.Measure(new SpanBatchBuilder(master).Freeze());
        Equal(0, empty.Ordinals.Count, "an empty batch measures an empty population");
        Equal(0, empty.GapCount, "no population, no gaps");
        Equal(null, empty.MedianGap, "no gaps, no median");
        Equal(null, empty.SpanFraction, "no population, no span fraction");

        var single = GapCadence.Measure(batch, record => record.Kind == "straddler");
        Equal(1, single.Ordinals.Count, "a singleton population is measured");
        Equal(null, single.GapCv, "a singleton has no gaps and no cv");

        var emptyWindow = GapCadence.Measure(batch, null, new TextSpan(35, 35));
        Equal(0, emptyWindow.Ordinals.Count, "an empty window admits nothing");

        Throws<ArgumentOutOfRangeException>(
            () => GapCadence.Measure(batch, null, new TextSpan(0, master.Length + 1)),
            "an out-of-bounds window is rejected");
        Throws<ArgumentNullException>(
            () => GapCadence.Measure((SpanBatch)null!),
            "a null batch is rejected");
    }

    /// <summary>
    /// D24: resolution order is query policy — the lookup answers in a named order. Geometry
    /// stays the default; PriorityThenGeometry is priority descending with geometry then
    /// ordinal completing a total order.
    /// </summary>
    private static void LookupOrderIsAQueryPolicy()
    {
        var master = new TextMaster("claim-order", 0, "01234567890123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 10), "a", SpanLevel.Character, "test", 1));
        builder.Add(new SpanClaim(new TextSpan(2, 8), "b", SpanLevel.Character, "test", 5));
        builder.Add(new SpanClaim(new TextSpan(2, 8), "c", SpanLevel.Character, "test", 5));
        builder.Add(new SpanClaim(new TextSpan(4, 6), "d", SpanLevel.Character, "test", 3));
        builder.Add(new SpanClaim(new TextSpan(12, 15), "e", SpanLevel.Character, "test", 9));
        var batch = builder.Freeze();

        var query = new TextSpan(3, 7);
        var geometry = batch.Sorted.FindIntersecting(query);
        Equal("0,1,2,3", Ordinals(geometry), "the default answer is the stable geometry order");
        Equal(
            Ordinals(batch.Sorted.FindIntersecting(query, ClaimOrder.Geometry)),
            Ordinals(geometry),
            "naming the default changes nothing");

        var byPriority = batch.Sorted.FindIntersecting(query, ClaimOrder.PriorityThenGeometry);
        Equal("1,2,3,0", Ordinals(byPriority), "priority descends, geometry then ordinal break ties");
        Equal(5, byPriority[0].Priority, "the max-priority claim answers first");
        True(byPriority[0].Ordinal < byPriority[1].Ordinal, "equal priority and geometry fall to ordinal order");

        Equal(
            "1,2,3,0",
            Ordinals(batch.Sorted.FindContaining(5, ClaimOrder.PriorityThenGeometry)),
            "the point query honors the same policy");
        Equal(
            "0,1,2,3",
            Ordinals(batch.Sorted.FindContaining(5)),
            "the point query default is unchanged");

        Equal(
            Ordinals(batch.Sorted.FindIntersecting(query, ClaimOrder.PriorityThenGeometry)),
            Ordinals(byPriority),
            "the ordered query is deterministic on repeat");

        Throws<ArgumentOutOfRangeException>(
            () => batch.Sorted.FindIntersecting(query, (ClaimOrder)7),
            "an undefined order is refused");
        Throws<ArgumentOutOfRangeException>(
            () => batch.Sorted.FindContaining(5, (ClaimOrder)7),
            "the point query refuses an undefined order too");
    }

    /// <summary>
    /// K2a: a selection is an immutable value over one exact frozen-batch basis. Construction
    /// coalesces repeated ordinals, canonical enumeration ascends across bitset words, and neither
    /// master compatibility nor equal membership permits cross-batch algebra.
    /// </summary>
    private static void ClaimSelectionIsAnExactBatchValue()
    {
        var master = new TextMaster("selection-value", 0, new string('x', 80));
        var builder = new SpanBatchBuilder(master);
        for (var ordinal = 0; ordinal < 70; ordinal++)
        {
            builder.Add(new SpanClaim(
                new TextSpan(ordinal, ordinal + 1),
                ordinal % 2 == 0 ? "even" : "odd",
                SpanLevel.Character,
                "test"));
        }

        var batch = builder.Freeze();
        True(!master.FingerprintIsCreated && !master.TopologyIsCreated, "selection setup leaves lazy master work untouched");

        var none = ClaimSelection.None(batch);
        var all = ClaimSelection.All(batch);
        True(none.IsEmpty, "None is empty");
        Equal(0, none.Count, "None count");
        Equal(batch.Count, all.Count, "All covers the complete ordinal universe");
        True(all.Contains(69), "All retains the final ordinal beyond the first bitset word");

        var created = ClaimSelection.Create(batch, new[] { 69, 0, 64, 69 });
        Equal(3, created.Count, "repeated construction ordinals coalesce");
        Equal("0,64,69", string.Join(",", created), "canonical enumeration crosses word boundaries in ascending order");
        True(ReferenceEquals(created.Basis, batch), "the exact batch basis is retained");
        True(ReferenceEquals(created.Master, master), "the master is reached through the exact basis");

        var evaluations = 0;
        var evens = ClaimSelection.FromPredicate(batch, record =>
        {
            evaluations++;
            return record.Kind == "even";
        });
        Equal(batch.Count, evaluations, "predicate selection evaluates once per basis ordinal");
        Equal(35, evens.Count, "predicate selection retains the named occurrences");
        True(evens.Contains(0) && evens.Contains(68) && !evens.Contains(69), "predicate membership is exact");

        var replay = ClaimSelection.Create(batch, new[] { 0, 64, 69 });
        True(created.Equals(replay), "equal basis and membership give value equality");
        Equal(created.GetHashCode(), replay.GetHashCode(), "equal selection values hash equally");
        True(created.Complement().Complement().Equals(created), "relative complement stays on the same universe");

        var foreignBuilder = new SpanBatchBuilder(master);
        for (var ordinal = 0; ordinal < 70; ordinal++)
        {
            foreignBuilder.Add(new SpanClaim(
                new TextSpan(ordinal, ordinal + 1),
                ordinal % 2 == 0 ? "even" : "odd",
                SpanLevel.Character,
                "test"));
        }

        var foreign = ClaimSelection.Create(foreignBuilder.Freeze(), new[] { 0, 64, 69 });
        True(!created.Equals(foreign), "equal ordinals over a different frozen batch are not equal");
        Throws<InvalidOperationException>(() => created.Union(foreign), "cross-basis union is refused");
        Throws<InvalidOperationException>(() => created.Intersect(foreign), "cross-basis intersection is refused");
        Throws<InvalidOperationException>(() => created.Subtract(foreign), "cross-basis difference is refused");

        Throws<ArgumentOutOfRangeException>(() => created.Contains(-1), "negative membership is undefined");
        Throws<ArgumentOutOfRangeException>(() => created.Contains(batch.Count), "membership beyond the basis is undefined");
        Throws<ArgumentOutOfRangeException>(
            () => ClaimSelection.Create(batch, new[] { 0, batch.Count }),
            "construction refuses an undefined ordinal anywhere in the input");
        Throws<ArgumentNullException>(() => ClaimSelection.None(null!), "None requires a frozen basis");
        Throws<ArgumentNullException>(() => ClaimSelection.Create(batch, null!), "construction requires ordinals");
        Throws<ArgumentNullException>(() => ClaimSelection.FromPredicate(batch, null!), "predicate selection requires a predicate");
        Throws<ArgumentNullException>(() => created.Union(null!), "binary algebra requires another selection");

        var emptyBatch = new SpanBatchBuilder(new TextMaster("selection-empty", 0, string.Empty)).Freeze();
        True(ClaimSelection.All(emptyBatch).Equals(ClaimSelection.None(emptyBatch)), "All and None coincide on an empty basis");
        True(!master.FingerprintIsCreated && !master.TopologyIsCreated, "selection value algebra forces no fingerprint or topology");
    }

    /// <summary>
    /// K2a gate: every subset of a six-claim basis and every ordered pair of those subsets is
    /// checked against an independent integer-mask oracle, including relative complement,
    /// difference, De Morgan, commutativity, and a deterministic distributive third operand.
    /// </summary>
    private static void ClaimSelectionBooleanLawsHoldExhaustively()
    {
        const int ordinalCount = 6;
        const int valueCount = 1 << ordinalCount;
        const int allMask = valueCount - 1;

        var master = new TextMaster("selection-laws", 0, new string('x', ordinalCount));
        var builder = new SpanBatchBuilder(master);
        for (var ordinal = 0; ordinal < ordinalCount; ordinal++)
        {
            builder.Add(new SpanClaim(
                new TextSpan(ordinal, ordinal + 1),
                "claim",
                SpanLevel.Character,
                "test"));
        }

        var batch = builder.Freeze();
        var values = new ClaimSelection[valueCount];
        for (var mask = 0; mask < valueCount; mask++)
        {
            values[mask] = SelectionFromMask(batch, mask);
        }

        var lawsHold = true;
        for (var leftMask = 0; leftMask < valueCount && lawsHold; leftMask++)
        {
            var left = values[leftMask];
            var complementMask = allMask ^ leftMask;
            lawsHold =
                SelectionMatchesMask(left, leftMask) &&
                left.Count == CountSetBits(leftMask) &&
                left.Union(values[0]).Equals(left) &&
                left.Intersect(values[allMask]).Equals(left) &&
                left.Union(values[complementMask]).Equals(values[allMask]) &&
                left.Intersect(values[complementMask]).Equals(values[0]) &&
                left.Complement().Equals(values[complementMask]) &&
                left.Complement().Complement().Equals(left) &&
                left.Subtract(left).Equals(values[0]);

            for (var rightMask = 0; rightMask < valueCount && lawsHold; rightMask++)
            {
                var right = values[rightMask];
                var thirdMask = ((leftMask * 17) + (rightMask * 29) + 11) & allMask;
                var third = values[thirdMask];
                lawsHold =
                    left.Union(right).Equals(values[leftMask | rightMask]) &&
                    left.Intersect(right).Equals(values[leftMask & rightMask]) &&
                    left.Subtract(right).Equals(values[leftMask & (allMask ^ rightMask)]) &&
                    left.Union(right).Equals(right.Union(left)) &&
                    left.Intersect(right).Equals(right.Intersect(left)) &&
                    left.Union(right).Complement().Equals(left.Complement().Intersect(right.Complement())) &&
                    left.Intersect(right.Union(third)).Equals(
                        left.Intersect(right).Union(left.Intersect(third)));
            }
        }

        True(lawsHold, "all subsets and binary operations on the bounded claim basis satisfy the selection laws");
    }

    /// <summary>
    /// K2a/D27: canonical set enumeration is ordinal order, while record order is an explicit
    /// ClaimOrder projection. Coverage is separately explicit because it collapses occurrence
    /// identity into normalized geometry.
    /// </summary>
    private static void ClaimSelectionSeparatesMembershipFromOrderedProjection()
    {
        var master = new TextMaster("selection-order", 0, new string('x', 20));
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(10, 12), "tail", SpanLevel.Character, "test", 3));
        builder.Add(new SpanClaim(new TextSpan(0, 8), "outer", SpanLevel.Character, "test", 1));
        builder.Add(new SpanClaim(new TextSpan(4, 6), "inner-a", SpanLevel.Character, "test", 9));
        builder.Add(new SpanClaim(new TextSpan(0, 4), "excluded", SpanLevel.Character, "test", 20));
        builder.Add(new SpanClaim(new TextSpan(4, 6), "inner-b", SpanLevel.Character, "test", 2));
        var batch = builder.Freeze();

        var selection = ClaimSelection.Create(batch, new[] { 4, 0, 2, 1 });
        Equal("0,1,2,4", string.Join(",", selection), "selection identity enumerates ascending ordinals");
        Equal("1,2,4,0", Ordinals(selection.Records()), "geometry projection follows the shared named order");
        Equal(
            "2,0,4,1",
            Ordinals(selection.Records(ClaimOrder.PriorityThenGeometry)),
            "priority projection is explicit and total");
        Equal("0,1,2,4", string.Join(",", selection), "ordered projections do not mutate canonical enumeration");
        True(
            selection.Equals(ClaimSelection.Create(batch, new[] { 1, 2, 0, 4 })),
            "construction and projection order are absent from set equality");

        var coverage = selection.Coverage();
        True(ReferenceEquals(coverage.Master, master), "coverage remains in the basis coordinate space");
        Equal(2, coverage.Count, "equal and contained selected geometry collapses during coverage");
        Equal(new TextSpan(0, 8), coverage[0], "coverage normalizes the overlapping population");
        Equal(new TextSpan(10, 12), coverage[1], "coverage retains the disjoint tail");
        Equal(0, ClaimSelection.None(batch).Coverage().Count, "empty selection has empty coverage");
        Equal(0, ClaimSelection.None(batch).Records().Count, "empty selection has no ordered records");
        Throws<ArgumentOutOfRangeException>(
            () => selection.Records((ClaimOrder)99),
            "ordered projection refuses an undefined order");
    }

    /// <summary>
    /// K2a: grouping, gap cadence, suppression, and the legacy predicate conveniences all converge
    /// on selection semantics. Key grouping stays lazy; line grouping alone touches topology.
    /// </summary>
    private static void SelectionPopulationIntegrationsShareOnePath()
    {
        var master = new TextMaster("selection-integrations", 0, "0123456789\n0123456789\n0123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(1, 3), "mask", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(5, 7), "keep", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(12, 14), "mask", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(9, 24), "bridge", SpanLevel.MultiLine, "test"));
        builder.Add(new SpanClaim(new TextSpan(25, 27), "mask", SpanLevel.Character, "test"));
        builder.Add(new SpanClaim(new TextSpan(15, 17), "keep", SpanLevel.Character, "test"));
        var batch = builder.Freeze();

        var selected = ClaimSelection.Create(batch, new[] { 0, 3, 4 });
        var keyEvaluations = 0;
        var groups = Grouping.ByKey(selected, record =>
        {
            keyEvaluations++;
            return record.Kind;
        });
        Equal(selected.Count, keyEvaluations, "key grouping evaluates only selected occurrences");
        Equal(2, groups.Count, "selected key grouping excludes every unselected group");
        Equal("mask", groups[0].Key, "selected group order follows first selected ordinal");
        Equal("0,4", string.Join(",", groups[0].Ordinals), "selected group membership retains basis ordinals");
        Equal("3", string.Join(",", groups[1].Ordinals), "the crossing selection remains a separate group");
        True(!master.TopologyIsCreated, "selection and key grouping do not force line topology");

        var batchGroups = Grouping.ByKey(batch, ClaimFacts.Kind);
        var allGroups = Grouping.ByKey(ClaimSelection.All(batch), ClaimFacts.Kind);
        Equal(batchGroups.Count, allGroups.Count, "batch grouping delegates to the all-selection path");
        Equal(
            string.Join(";", batchGroups.Select(group => $"{group.Key}:{string.Join(',', group.Ordinals)}")),
            string.Join(";", allGroups.Select(group => $"{group.Key}:{string.Join(',', group.Ordinals)}")),
            "batch and all-selection keyed groupings agree extensionally");

        var touched = Grouping.ByLine(selected, LineMembership.EveryLineTouched);
        Equal(3, touched.Lines.Count, "selection line grouping stays total over the line grain");
        Equal("0,3", string.Join(",", touched.Lines[0].Ordinals), "selected line zero membership");
        Equal("3", string.Join(",", touched.Lines[1].Ordinals), "only the selected bridge occupies line one");
        Equal("3,4", string.Join(",", touched.Lines[2].Ordinals), "selected line two membership");
        True(ReferenceEquals(touched.Source, batch), "selection line groups retain the exact source basis");
        True(master.TopologyIsCreated, "line grouping is the integration that touches topology");

        var attributed = Grouping.ByLine(selected, LineMembership.StartLineOnly);
        Equal("0,3", string.Join(",", attributed.Lines[0].Ordinals), "selected start-line attribution on line zero");
        Equal(0, attributed.Lines[1].Ordinals.Count, "unselected line one claims do not leak into attribution");
        Equal("4", string.Join(",", attributed.Lines[2].Ordinals), "selected start-line attribution on line two");

        var suppressors = ClaimSelection.FromPredicate(batch, record => record.Kind == "mask");
        var cadence = GapCadence.Measure(suppressors);
        var predicateCadence = GapCadence.Measure(batch, record => record.Kind == "mask");
        True(cadence.Population.Equals(suppressors), "cadence retains its exact measured selection");
        True(ReferenceEquals(cadence.Source, batch), "selection cadence retains the exact source batch");
        Equal("0,2,4", string.Join(",", cadence.Ordinals), "selection cadence reports start order");
        Equal(13, cadence.MedianGap, "selection cadence measures the selected start gaps");
        Equal(cadence.MedianGap, predicateCadence.MedianGap, "predicate cadence delegates to selection cadence");
        Equal(
            string.Join(",", cadence.Ordinals),
            string.Join(",", predicateCadence.Ordinals),
            "predicate and selection cadence retain the same population");

        var windowed = GapCadence.Measure(suppressors, new TextSpan(10, 30));
        True(
            windowed.Population.Equals(ClaimSelection.Create(batch, new[] { 2, 4 })),
            "window admission narrows and records the exact selected population");
        Equal("2,4", string.Join(",", windowed.Ordinals), "windowed selection cadence retains query order separately");

        var excluded = Suppression.Excluded(suppressors);
        var predicateExcluded = Suppression.Excluded(batch, record => record.Kind == "mask");
        True(excluded.Equals(suppressors.Coverage()), "selection suppression projects exactly through coverage");
        True(excluded.Equals(predicateExcluded), "predicate suppression delegates to selection suppression");
        True(
            Suppression.Admitted(suppressors).Equals(Suppression.Admitted(batch, record => record.Kind == "mask")),
            "admitted suppression has one selection-backed meaning");
        True(
            SpanSet.FromClaims(batch, record => record.Kind == "mask").Equals(suppressors.Coverage()),
            "the legacy claim-to-region convenience shares selection coverage");

        Throws<ArgumentNullException>(
            () => Grouping.ByKey((ClaimSelection)null!, ClaimFacts.Kind),
            "selected key grouping requires a selection");
        Throws<ArgumentNullException>(
            () => Grouping.ByLine((ClaimSelection)null!),
            "selected line grouping requires a selection");
        Throws<ArgumentNullException>(
            () => GapCadence.Measure((ClaimSelection)null!),
            "selected cadence requires a selection");
        Throws<ArgumentNullException>(
            () => Suppression.Excluded((ClaimSelection)null!),
            "selected suppression requires a selection");
    }

    /// <summary>
    /// K2b: exact pair identity is two frozen-batch references plus extensional ordinal-pair
    /// membership. Geometry labels are derived, canonical enumeration is lexicographic, and the
    /// ordinal diagonal remains narrower than geometric equality over duplicate spans.
    /// </summary>
    private static void ClaimPairViewIsAnExactBasisStampedRelation()
    {
        var master = new TextMaster("pair-value", 0, new string('x', 20));
        var left = PairBatch(
            master,
            new TextSpan(0, 5),
            new TextSpan(0, 5),
            new TextSpan(10, 15));
        var right = PairBatch(
            master,
            new TextSpan(0, 5),
            new TextSpan(5, 10),
            new TextSpan(12, 14));

        var all = ClaimPairView.Relate(left, right, AllenRelationSet.All);
        True(ReferenceEquals(all.LeftBasis, left), "pair view retains the exact left basis");
        True(ReferenceEquals(all.RightBasis, right), "pair view retains the exact right basis");
        Equal(left.Count * right.Count, all.Count, "All relates every occurrence pair");
        Equal(
            "0:0,0:1,0:2,1:0,1:1,1:2,2:0,2:1,2:2",
            PairKeys(all),
            "pair enumeration is lexicographic by exact ordinals");
        True(all.Contains(0, 0) && all.Contains(2, 2), "exact membership finds retained edges");

        var labelsAreDerived = all.All(pair =>
            pair.Relation == AllenAlgebra.Relate(
                left[pair.LeftOrdinal].Span,
                right[pair.RightOrdinal].Span));
        True(labelsAreDerived, "every edge label is derived from its retained occurrence bases");

        var equal = ClaimPairView.Relate(left, right, AllenRelationSet.Equal);
        Equal(2, equal.Count, "equal geometry preserves two distinct left occurrences");
        Equal("0:0,1:0", PairKeys(equal), "equal geometry does not merge occurrence identities");
        Equal(0, ClaimPairView.Relate(left, right, AllenRelationSet.None).Count, "None retains no edges");

        var created = ClaimPairView.Create(
            left,
            right,
            new[] { (2, 2), (0, 1), (0, 1) });
        Equal(2, created.Count, "duplicate input edges coalesce");
        Equal("0:1,2:2", PairKeys(created), "arbitrary construction canonicalizes input order");
        Equal(AllenRelation.Meets, created.First().Relation, "constructed edge relation is derived, not supplied");

        var replay = ClaimPairView.Create(left, right, new[] { (0, 1), (2, 2) });
        True(created.Equals(replay), "equal bases and edge membership give value equality");
        Equal(created.GetHashCode(), replay.GetHashCode(), "equal pair relations hash equally");
        True(ClaimPairView.None(left, right).Equals(ClaimPairView.Relate(left, right, AllenRelationSet.None)),
            "empty construction paths agree on one exact pair basis");

        var foreignLeft = PairBatch(
            master,
            new TextSpan(0, 5),
            new TextSpan(0, 5),
            new TextSpan(10, 15));
        var foreign = ClaimPairView.Create(foreignLeft, right, new[] { (0, 1), (2, 2) });
        True(!created.Equals(foreign), "equal rows and edges on a separately frozen batch are not equal");

        var identity = ClaimPairView.Identity(left);
        Equal(3, identity.Count, "occurrence identity is the complete ordinal diagonal");
        Equal("0:0,1:1,2:2", PairKeys(identity), "identity contains diagonal ordinals only");
        var geometricEqual = ClaimPairView.Relate(left, left, AllenRelationSet.Equal);
        Equal(5, geometricEqual.Count, "geometric equality includes duplicate-span cross-ordinals");
        True(geometricEqual.Contains(0, 1) && !identity.Contains(0, 1),
            "Allen Equal is distinct from claim occurrence identity");

        True(!master.FingerprintIsCreated && !master.TopologyIsCreated,
            "same-master pair algebra forces no fingerprint or topology");

        var compatibleMaster = new TextMaster(master.DocumentId, master.Revision, master.Text);
        var compatibleRight = PairBatch(compatibleMaster, new TextSpan(0, 5));
        Equal(left.Count, ClaimPairView.Relate(left, compatibleRight, AllenRelationSet.All).Count,
            "different but compatible masters may be related on explicit exact bases");

        Throws<ArgumentOutOfRangeException>(() => all.Contains(-1, 0), "negative left membership is undefined");
        Throws<ArgumentOutOfRangeException>(() => all.Contains(0, right.Count), "right membership beyond the basis is undefined");
        Throws<ArgumentOutOfRangeException>(
            () => ClaimPairView.Create(left, right, new[] { (0, 0), (left.Count, 0) }),
            "construction refuses an undefined ordinal anywhere in the input");
        Throws<ArgumentNullException>(
            () => ClaimPairView.Create(left, right, null!),
            "pair construction requires an edge population");
        Throws<ArgumentNullException>(
            () => ClaimPairView.Relate(null!, right, AllenRelationSet.All),
            "pair relation requires a left basis");

        var incompatible = PairBatch(
            new TextMaster("pair-incompatible", 0, master.Text),
            new TextSpan(0, 5));
        Throws<InvalidOperationException>(
            () => ClaimPairView.Relate(left, incompatible, AllenRelationSet.All),
            "pair geometry refuses incompatible coordinate spaces");
    }

    /// <summary>
    /// K2b: projections and semijoins retain exact occurrence bases, while converse swaps those
    /// bases, ordinals, and Allen labels without changing extensional edge identity.
    /// </summary>
    private static void ClaimPairViewProjectsSemijoinsAndConverse()
    {
        var master = new TextMaster("pair-relational", 0, new string('x', 20));
        var left = PairBatch(master, new TextSpan(0, 3), new TextSpan(4, 7), new TextSpan(8, 12));
        var right = PairBatch(master, new TextSpan(1, 2), new TextSpan(5, 9), new TextSpan(12, 15));
        var relation = ClaimPairView.Create(
            left,
            right,
            new[] { (0, 1), (0, 2), (2, 0), (2, 2) });

        var leftProjection = relation.ProjectLeft();
        var rightProjection = relation.ProjectRight();
        True(leftProjection.Equals(ClaimSelection.Create(left, new[] { 0, 2 })),
            "left projection deduplicates exact left occurrences");
        True(rightProjection.Equals(ClaimSelection.All(right)),
            "right projection retains every reached right occurrence");

        var selectedLeft = ClaimSelection.Create(left, new[] { 2 });
        var selectedRight = ClaimSelection.Create(right, new[] { 2 });
        var leftSemi = relation.SemiJoinLeft(selectedLeft);
        var rightSemi = relation.SemiJoinRight(selectedRight);
        Equal("2:0,2:2", PairKeys(leftSemi), "left semijoin filters only the left endpoint");
        Equal("0:2,2:2", PairKeys(rightSemi), "right semijoin filters only the right endpoint");
        True(leftSemi.ProjectLeft().Equals(leftProjection.Intersect(selectedLeft)),
            "left projection-semijoin law holds");
        True(rightSemi.ProjectRight().Equals(rightProjection.Intersect(selectedRight)),
            "right projection-semijoin law holds");
        True(relation.SemiJoinLeft(ClaimSelection.All(left)).Equals(relation),
            "left semijoin by All is identity");
        True(relation.SemiJoinRight(ClaimSelection.None(right)).IsEmpty,
            "right semijoin by None annihilates the relation");

        var converse = relation.Converse();
        True(ReferenceEquals(converse.LeftBasis, right) && ReferenceEquals(converse.RightBasis, left),
            "converse swaps exact bases");
        Equal("0:2,1:0,2:0,2:2", PairKeys(converse), "converse re-canonicalizes swapped ordinals");
        True(converse.Converse().Equals(relation), "converse is involutive on exact pair relations");
        True(
            relation.SemiJoinLeft(selectedLeft).Converse().Equals(
                relation.Converse().SemiJoinRight(selectedLeft)),
            "converse exchanges left and right semijoins");

        var converseLabels = true;
        foreach (var pair in relation)
        {
            var reverse = converse.Single(candidate =>
                candidate.LeftOrdinal == pair.RightOrdinal &&
                candidate.RightOrdinal == pair.LeftOrdinal);
            converseLabels &= reverse.Relation == AllenAlgebra.Inverse(pair.Relation);
        }

        True(converseLabels, "converse maps every exact Allen label pointwise");

        var foreignLeft = PairBatch(master, new TextSpan(0, 3), new TextSpan(4, 7), new TextSpan(8, 12));
        Throws<InvalidOperationException>(
            () => relation.SemiJoinLeft(ClaimSelection.All(foreignLeft)),
            "left semijoin refuses a selection on an equal but different batch");
        Throws<InvalidOperationException>(
            () => relation.SemiJoinRight(ClaimSelection.All(left)),
            "right semijoin refuses the wrong exact side basis");
        Throws<ArgumentNullException>(
            () => relation.SemiJoinLeft(null!),
            "semijoin requires a selection");
    }

    /// <summary>
    /// K2b: reference composition is a direct exact middle-ordinal join. An independently written
    /// nested oracle agrees extensionally, duplicate outer pairs collapse, and the separate witness
    /// query is sound, complete, ascending, and basis-stamped for this composition only.
    /// </summary>
    private static void ClaimPairCompositionMatchesItsIndependentOracleAndWitnesses()
    {
        var master = new TextMaster("pair-compose", 0, new string('x', 12));
        var a = PairBatch(master, new TextSpan(0, 2), new TextSpan(8, 10));
        var b = PairBatch(master, new TextSpan(2, 4), new TextSpan(4, 6), new TextSpan(6, 8));
        var c = PairBatch(master, new TextSpan(0, 5), new TextSpan(5, 10));

        var left = ClaimPairView.Create(
            a,
            b,
            new[] { (0, 0), (0, 1), (1, 1), (1, 2) });
        var right = ClaimPairView.Create(
            b,
            c,
            new[] { (0, 0), (1, 0), (1, 1), (2, 1) });

        var composed = left.ComposePairs(right);
        var oracle = ComposePairOracle(left, right);
        True(PairViewMatchesKeys(composed, oracle),
            "direct composition agrees with the independent nested relation oracle");
        Equal("0:0,0:1,1:0,1:1", PairKeys(composed),
            "composition deduplicates outer pairs in lexicographic order");
        Equal(4, composed.Count, "six exact paths collapse to four extensional outer edges");

        var witnesses = left.GroupMiddleWitnesses(right);
        True(ReferenceEquals(witnesses.LeftBasis, a), "witness query retains the outer left basis");
        True(ReferenceEquals(witnesses.MiddleBasis, b), "witness query retains the exact middle basis");
        True(ReferenceEquals(witnesses.RightBasis, c), "witness query retains the outer right basis");
        Equal(4, witnesses.Count, "one witness group is reported per composed outer edge");
        Equal("0,1", string.Join(",", witnesses[0].MiddleOrdinals),
            "multiple middle witnesses are complete and ascending");
        Equal("1,2", string.Join(",", witnesses[3].MiddleOrdinals),
            "the last outer edge retains both of its middle occurrences");
        True(WitnessViewMatchesOracle(witnesses, left, right),
            "middle witness groups are sound and complete for the independent oracle");

        True(ClaimPairView.Identity(a).ComposePairs(left).Equals(left),
            "ordinal identity is a left identity for exact composition");
        True(left.ComposePairs(ClaimPairView.Identity(b)).Equals(left),
            "ordinal identity is a right identity for exact composition");
        True(left.ComposePairs(ClaimPairView.None(b, c)).Equals(ClaimPairView.None(a, c)),
            "empty right relation annihilates exact composition");
        Equal(0, left.GroupMiddleWitnesses(ClaimPairView.None(b, c)).Count,
            "empty composition has no witness groups");

        var bClone = PairBatch(master, new TextSpan(2, 4), new TextSpan(4, 6), new TextSpan(6, 8));
        var foreignRight = ClaimPairView.Create(
            bClone,
            c,
            new[] { (0, 0), (1, 0), (1, 1), (2, 1) });
        Throws<InvalidOperationException>(
            () => left.ComposePairs(foreignRight),
            "composition refuses an equal but nonidentical middle batch");
        Throws<InvalidOperationException>(
            () => left.GroupMiddleWitnesses(foreignRight),
            "witness grouping enforces the same exact middle basis");
        Throws<ArgumentNullException>(
            () => left.ComposePairs(null!),
            "composition requires a right relation");
    }

    /// <summary>
    /// K2b gate: all sixteen relations between two two-claim bases are exercised as values. Every
    /// ordered composition pair is checked against an independent oracle; projection, semijoin,
    /// identity, converse reversal, and all 4096 relation triples satisfy their extensional laws.
    /// </summary>
    private static void ClaimPairCompositionLawsHoldOnBoundedRelations()
    {
        var master = new TextMaster("pair-laws", 0, new string('x', 12));
        var a = PairBatch(master, new TextSpan(0, 2), new TextSpan(8, 10));
        var b = PairBatch(master, new TextSpan(1, 3), new TextSpan(7, 9));
        var c = PairBatch(master, new TextSpan(2, 4), new TextSpan(6, 8));
        var d = PairBatch(master, new TextSpan(3, 5), new TextSpan(5, 7));

        const int relationCount = 1 << 4;
        var ab = new ClaimPairView[relationCount];
        var bc = new ClaimPairView[relationCount];
        var cd = new ClaimPairView[relationCount];
        for (var mask = 0; mask < relationCount; mask++)
        {
            ab[mask] = PairViewFromMask(a, b, mask);
            bc[mask] = PairViewFromMask(b, c, mask);
            cd[mask] = PairViewFromMask(c, d, mask);
        }

        var valueLawsHold = true;
        for (var mask = 0; mask < relationCount && valueLawsHold; mask++)
        {
            var relation = ab[mask];
            var leftProjectionMask = 0;
            var rightProjectionMask = 0;
            foreach (var pair in relation)
            {
                leftProjectionMask |= 1 << pair.LeftOrdinal;
                rightProjectionMask |= 1 << pair.RightOrdinal;
            }

            valueLawsHold =
                relation.Converse().Converse().Equals(relation) &&
                ClaimPairView.Identity(a).ComposePairs(relation).Equals(relation) &&
                relation.ComposePairs(ClaimPairView.Identity(b)).Equals(relation) &&
                SelectionMatchesMask(relation.ProjectLeft(), leftProjectionMask) &&
                SelectionMatchesMask(relation.ProjectRight(), rightProjectionMask);

            for (var selectionMask = 0; selectionMask < 4 && valueLawsHold; selectionMask++)
            {
                var leftSelection = SelectionFromMask(a, selectionMask);
                var rightSelection = SelectionFromMask(b, selectionMask);
                valueLawsHold =
                    PairViewMatchesKeys(
                        relation.SemiJoinLeft(leftSelection),
                        relation
                            .Where(pair => (selectionMask & (1 << pair.LeftOrdinal)) != 0)
                            .Select(pair => (pair.LeftOrdinal, pair.RightOrdinal))) &&
                    PairViewMatchesKeys(
                        relation.SemiJoinRight(rightSelection),
                        relation
                            .Where(pair => (selectionMask & (1 << pair.RightOrdinal)) != 0)
                            .Select(pair => (pair.LeftOrdinal, pair.RightOrdinal)));
            }
        }

        True(valueLawsHold,
            "all sixteen bounded pair relations satisfy identity, converse, projection, and semijoin laws");

        var binaryLawsHold = true;
        for (var leftMask = 0; leftMask < relationCount && binaryLawsHold; leftMask++)
        {
            for (var rightMask = 0; rightMask < relationCount && binaryLawsHold; rightMask++)
            {
                var left = ab[leftMask];
                var right = bc[rightMask];
                binaryLawsHold =
                    PairViewMatchesKeys(left.ComposePairs(right), ComposePairOracle(left, right)) &&
                    left.ComposePairs(right).Converse().Equals(
                        right.Converse().ComposePairs(left.Converse()));
            }
        }

        True(binaryLawsHold,
            "all 256 bounded composition pairs match the oracle and reverse under converse");

        var associativityHolds = true;
        for (var firstMask = 0; firstMask < relationCount && associativityHolds; firstMask++)
        {
            for (var secondMask = 0; secondMask < relationCount && associativityHolds; secondMask++)
            {
                for (var thirdMask = 0; thirdMask < relationCount && associativityHolds; thirdMask++)
                {
                    associativityHolds =
                        ab[firstMask]
                            .ComposePairs(bc[secondMask])
                            .ComposePairs(cd[thirdMask])
                            .Equals(
                                ab[firstMask].ComposePairs(
                                    bc[secondMask].ComposePairs(cd[thirdMask])));
                }
            }
        }

        True(associativityHolds, "all 4096 bounded exact-relation triples compose associatively");
    }

    /// <summary>
    /// K2b/D29: every exact composition edge has a middle witness whose atomic Allen triad lies in
    /// canonical composition. Unioning gives the one-way image inclusion. Separate correlation and
    /// adjacent finite-gap witnesses refute the converse without ever generating an exact edge from
    /// a qualitative table cell.
    /// </summary>
    private static void ClaimPairAllenAbstractionBridgeIsOneWay()
    {
        var master = new TextMaster("pair-allen-bridge", 0, new string('x', 5));
        var intervals = PairBatch(master, CreateNonEmptyAllenIntervals(6).ToArray());
        var all = ClaimPairView.Relate(intervals, intervals, AllenRelationSet.All);
        var composed = all.ComposePairs(all);
        Equal(225, all.Count, "the six-boundary carrier exposes every ordered interval pair");
        Equal(225, composed.Count, "the full exact relation composes to every outer pair");

        var perWitnessHolds = true;
        var witnessCount = 0;
        foreach (var leftPair in all)
        {
            foreach (var rightPair in all)
            {
                if (leftPair.RightOrdinal != rightPair.LeftOrdinal)
                {
                    continue;
                }

                witnessCount++;
                var first = AllenAlgebra.Relate(
                    intervals[leftPair.LeftOrdinal].Span,
                    intervals[leftPair.RightOrdinal].Span);
                var second = AllenAlgebra.Relate(
                    intervals[rightPair.LeftOrdinal].Span,
                    intervals[rightPair.RightOrdinal].Span);
                var outer = AllenAlgebra.Relate(
                    intervals[leftPair.LeftOrdinal].Span,
                    intervals[rightPair.RightOrdinal].Span);
                perWitnessHolds &= AllenRelationSet
                    .Singleton(first)
                    .AllenCompose(AllenRelationSet.Singleton(second))
                    .Contains(outer);
            }
        }

        Equal(3375, witnessCount, "every ordered interval triple is checked as an exact middle witness");
        True(perWitnessHolds, "every exact middle witness satisfies the atomic Allen bridge");
        True(
            AllenImageOracle(composed).IsSubsetOf(
                AllenImageOracle(all).AllenCompose(AllenImageOracle(all))),
            "the exact composition image is contained in canonical composition of actual edge images");

        var filteredLeft = ClaimPairView.Relate(
            intervals,
            intervals,
            AllenRelationSet.Create(new[]
            {
                AllenRelation.Before,
                AllenRelation.Meets,
                AllenRelation.Overlaps,
            }));
        var filteredRight = ClaimPairView.Relate(
            intervals,
            intervals,
            AllenRelationSet.Create(new[]
            {
                AllenRelation.During,
                AllenRelation.Finishes,
                AllenRelation.After,
            }));
        True(
            AllenImageOracle(filteredLeft.ComposePairs(filteredRight)).IsSubsetOf(
                AllenImageOracle(filteredLeft).AllenCompose(AllenImageOracle(filteredRight))),
            "the union-level bridge holds for filtered actual relations too");

        var sparseMaster = new TextMaster("pair-image", 0, "xxx");
        var sparseLeft = PairBatch(sparseMaster, new TextSpan(0, 1));
        var sparseRight = PairBatch(sparseMaster, new TextSpan(2, 3));
        var requestedAll = ClaimPairView.Relate(sparseLeft, sparseRight, AllenRelationSet.All);
        Equal(
            AllenRelationSet.Singleton(AllenRelation.Before),
            AllenImageOracle(requestedAll),
            "Allen image records actual edges rather than the requested construction filter");
        True(AllenImageOracle(requestedAll) != AllenRelationSet.All,
            "an unrealized requested atom is absent from the actual image");

        var finiteMiddle = PairBatch(sparseMaster, CreateNonEmptyAllenIntervals(4).ToArray());
        var before = AllenRelationSet.Singleton(AllenRelation.Before);
        var leftBefore = ClaimPairView.Relate(sparseLeft, finiteMiddle, before);
        var rightBefore = ClaimPairView.Relate(finiteMiddle, sparseRight, before);
        var finiteComposition = leftBefore.ComposePairs(rightBefore);
        Equal(1, leftBefore.Count, "the adjacent carrier realizes an input Before edge on the left");
        Equal(1, rightBefore.Count, "the adjacent carrier realizes an input Before edge on the right");
        True(finiteComposition.IsEmpty,
            "no one finite middle interval realizes both Before edges across the adjacent gap");
        True(
            AllenImageOracle(leftBefore)
                .AllenCompose(AllenImageOracle(rightBefore))
                .Contains(AllenRelation.Before) &&
            !finiteComposition.Contains(0, 0),
            "canonical permission does not create the missing exact adjacent-gap edge");

        var correlationMaster = new TextMaster("pair-correlation", 0, new string('x', 12));
        var correlationLeft = PairBatch(correlationMaster, new TextSpan(0, 1));
        var correlationMiddle = PairBatch(
            correlationMaster,
            new TextSpan(2, 3),
            new TextSpan(5, 6));
        var correlationRight = PairBatch(correlationMaster, new TextSpan(10, 11));
        var firstOnly = ClaimPairView.Create(correlationLeft, correlationMiddle, new[] { (0, 1) });
        var secondOnly = ClaimPairView.Create(correlationMiddle, correlationRight, new[] { (0, 0) });
        True(firstOnly.ComposePairs(secondOnly).IsEmpty,
            "different middle identities cannot be combined into an exact path");
        True(
            AllenImageOracle(firstOnly)
                .AllenCompose(AllenImageOracle(secondOnly))
                .Contains(AllenRelation.Before),
            "qualitative images forget the middle-identity correlation they overapproximate");
    }

    /// <summary>
    /// K2c: nested environments and sequential fences exercise two independent caller key
    /// policies. Results retain their exact input and policy stamps, while paired-region
    /// projection advertises and exhibits its identity-forgetting normalization.
    /// </summary>
    private static void PairingWitnessesTwoDelimiterFamilies()
    {
        var environmentMaster = new TextMaster(
            "pairing-environments",
            0,
            new string('x', 40));
        var environments = PairingBatch(
            environmentMaster,
            (new TextSpan(30, 31), "close", "outer"),
            (new TextSpan(10, 11), "open", "inner"),
            (new TextSpan(20, 21), "close", "inner"),
            (new TextSpan(0, 1), "open", "outer"));
        var environmentOpens = ClaimSelection.FromPredicate(
            environments,
            static record => record.Kind == "open");
        var environmentCloses = ClaimSelection.FromPredicate(
            environments,
            static record => record.Kind == "close");
        var environmentPolicy = PairingPolicy.ByKey<string?>(
            "environment-name",
            static record => record.RuleId);

        var nested = Pairing.Pair(
            environmentOpens,
            environmentCloses,
            environmentPolicy);
        True(ReferenceEquals(nested.OpenInput, environmentOpens),
            "pairing retains the exact open input selection");
        True(ReferenceEquals(nested.CloseInput, environmentCloses),
            "pairing retains the exact close input selection");
        True(ReferenceEquals(nested.Policy, environmentPolicy),
            "pairing retains the exact policy object");
        True(ReferenceEquals(nested.MatchEdges.LeftBasis, environments) &&
            ReferenceEquals(nested.MatchEdges.RightBasis, environments),
            "environment match edges retain both exact role bases");
        Equal("1:2,3:0", PairKeys(nested.MatchEdges),
            "geometric stack order is independent of batch insertion order");
        True(nested.Faults.IsEmpty, "properly nested environments have no fault residue");
        Equal(2, nested.MatchEdges.Count, "both nested environment families match");

        var nestedRegions = nested.PairedRegions();
        True(ReferenceEquals(nestedRegions.Master, environmentMaster),
            "paired regions retain the input coordinate space");
        Equal(1, nestedRegions.Count,
            "normalizing nested match envelopes deliberately forgets the inner occurrence");
        Equal(new TextSpan(0, 31), nestedRegions[0],
            "environment envelope includes both delimiter tokens");

        var openMaster = new TextMaster("pairing-fences", 0, new string('x', 40));
        var closeMaster = new TextMaster("pairing-fences", 0, new string('x', 40));
        var fenceOpensBasis = PairingBatch(
            openMaster,
            (new TextSpan(20, 23), "open", "TILDE"),
            (new TextSpan(0, 3), "open", "BACKTICK"));
        var fenceClosesBasis = PairingBatch(
            closeMaster,
            (new TextSpan(30, 33), "close", "tilde"),
            (new TextSpan(10, 13), "close", "backtick"));
        var fencePolicy = PairingPolicy.ByKey(
            "fence-character-and-length",
            static (SpanRecord record) => record.RuleId!,
            StringComparer.OrdinalIgnoreCase);
        var fences = Pairing.Pair(
            ClaimSelection.All(fenceOpensBasis),
            ClaimSelection.All(fenceClosesBasis),
            fencePolicy);

        Equal("0:0,1:1", PairKeys(fences.MatchEdges),
            "sequential fence families match across distinct compatible bases");
        True(fences.Faults.IsEmpty, "compatible fence pairs leave no residue");
        Equal(2, fences.PairedRegions().Count,
            "sequential paired envelopes remain two geometry regions");
        True(ReferenceEquals(fences.PairedRegions().Master, openMaster),
            "compatible cross-master projection chooses the open coordinate-space object");
        True(openMaster.FingerprintIsCreated && closeMaster.FingerprintIsCreated,
            "distinct-master pairing performs the required coordinate fingerprint check");
        True(!openMaster.TopologyIsCreated && !closeMaster.TopologyIsCreated,
            "distinct-master pairing still forces no text topology");
    }

    /// <summary>
    /// K2c: a mismatched closer consumes exactly the stack top into correlated pair evidence; it
    /// never searches below for a compatible opener. Match and named residue remain disjoint,
    /// complete partitions of both exact role populations.
    /// </summary>
    private static void PairingFaultResidueIsCompleteAndTopOnly()
    {
        var master = new TextMaster("pairing-faults", 0, new string('x', 12));
        var batch = PairingBatch(
            master,
            (new TextSpan(0, 1), "close", "A"),
            (new TextSpan(2, 3), "open", "A"),
            (new TextSpan(4, 5), "open", "B"),
            (new TextSpan(6, 7), "close", "A"),
            (new TextSpan(8, 9), "close", "A"),
            (new TextSpan(10, 11), "open", "C"));
        var opens = ClaimSelection.Create(batch, new[] { 1, 2, 5 });
        var closes = ClaimSelection.Create(batch, new[] { 0, 3, 4 });
        var comparisons = 0;
        var policy = new PairingPolicy(
            "fault-key",
            (opener, closer) =>
            {
                comparisons++;
                return StringComparer.Ordinal.Equals(opener.RuleId, closer.RuleId);
            });

        var result = Pairing.Pair(opens, closes, policy);
        Equal(2, comparisons,
            "compatibility runs once for each closer that encounters a stack top");
        Equal("1:4", PairKeys(result.MatchEdges),
            "a later closer still matches the outer opener left below the mismatch");
        Equal("2:3", PairKeys(result.Faults.MismatchedPairs),
            "the incompatible closer records only the current top opener");
        True(result.Faults.UnclosedOpens.SequenceEqual(new[] { 5 }),
            "the final stack population becomes exact unclosed residue");
        True(result.Faults.DanglingCloses.SequenceEqual(new[] { 0 }),
            "a closer on the empty stack becomes exact dangling residue");
        True(result.Faults.MismatchedOpens.SequenceEqual(new[] { 2 }) &&
            result.Faults.MismatchedCloses.SequenceEqual(new[] { 3 }),
            "mismatch pair projections retain both exact endpoint identities");
        True(result.Faults.OpenResidue.SequenceEqual(new[] { 2, 5 }),
            "open residue combines disjoint mismatched and unclosed categories");
        True(result.Faults.CloseResidue.SequenceEqual(new[] { 0, 3 }),
            "close residue combines disjoint dangling and mismatched categories");
        True(!result.Faults.IsEmpty, "adversarial pairing advertises nonempty faults");

        var matchedOpens = result.MatchEdges.ProjectLeft();
        var matchedCloses = result.MatchEdges.ProjectRight();
        True(matchedOpens.Intersect(result.Faults.OpenResidue).IsEmpty &&
            matchedOpens.Union(result.Faults.OpenResidue).Equals(opens),
            "match and open residue form a disjoint complete input partition");
        True(matchedCloses.Intersect(result.Faults.CloseResidue).IsEmpty &&
            matchedCloses.Union(result.Faults.CloseResidue).Equals(closes),
            "match and close residue form a disjoint complete input partition");
        True(result.Faults.UnclosedOpens.Intersect(result.Faults.MismatchedOpens).IsEmpty &&
            result.Faults.UnclosedOpens.Union(result.Faults.MismatchedOpens)
                .Equals(result.Faults.OpenResidue),
            "open fault categories partition open residue");
        True(result.Faults.DanglingCloses.Intersect(result.Faults.MismatchedCloses).IsEmpty &&
            result.Faults.DanglingCloses.Union(result.Faults.MismatchedCloses)
                .Equals(result.Faults.CloseResidue),
            "close fault categories partition close residue");
        Equal(new TextSpan(2, 9), result.PairedRegions().Single(),
            "paired region projection includes the accepted delimiter envelope only");
    }

    /// <summary>
    /// K2c boundaries: roles and geometric word order must be unambiguous, coordinate spaces must
    /// be compatible, null keys remain legitimate policy values, and empty execution still
    /// returns a fully stamped result without forcing topology.
    /// </summary>
    private static void PairingRefusesAmbiguousInputsAndRetainsItsStamps()
    {
        var master = new TextMaster("pairing-boundaries", 0, new string('x', 8));
        var batch = PairingBatch(
            master,
            (new TextSpan(0, 1), "open", null),
            (new TextSpan(2, 3), "close", null),
            (new TextSpan(4, 5), "other", "unused"));
        var nullKeyPolicy = PairingPolicy.ByKey<string?>(
            "nullable-key",
            static record => record.RuleId);
        var nullKeyResult = Pairing.Pair(
            ClaimSelection.Create(batch, new[] { 0 }),
            ClaimSelection.Create(batch, new[] { 1 }),
            nullKeyPolicy);
        Equal("0:1", PairKeys(nullKeyResult.MatchEdges),
            "two null keys are a legitimate compatible policy value");

        var noOpens = ClaimSelection.None(batch);
        var noCloses = ClaimSelection.None(batch);
        var empty = Pairing.Pair(noOpens, noCloses, nullKeyPolicy);
        True(ReferenceEquals(empty.OpenInput, noOpens) &&
            ReferenceEquals(empty.CloseInput, noCloses) &&
            ReferenceEquals(empty.Policy, nullKeyPolicy),
            "empty pairing retains exact input and policy stamps");
        True(empty.MatchEdges.IsEmpty && empty.Faults.IsEmpty && empty.PairedRegions().Count == 0,
            "empty pairing is total and produces empty matches, faults, and geometry");
        True(!master.FingerprintIsCreated && !master.TopologyIsCreated,
            "same-master pairing touches neither fingerprint nor topology");

        var sharedRole = ClaimSelection.Create(batch, new[] { 0 });
        Throws<ArgumentException>(
            () => Pairing.Pair(sharedRole, sharedRole, nullKeyPolicy),
            "one occurrence cannot carry both pairing roles");

        var overlapBatch = PairingBatch(
            master,
            (new TextSpan(0, 3), "open", "A"),
            (new TextSpan(2, 4), "close", "A"));
        Throws<InvalidOperationException>(
            () => Pairing.Pair(
                ClaimSelection.Create(overlapBatch, new[] { 0 }),
                ClaimSelection.Create(overlapBatch, new[] { 1 }),
                nullKeyPolicy),
            "overlapping token claims cannot acquire an arbitrary reading order");

        var foreignMaster = new TextMaster("pairing-foreign", 0, master.Text);
        var foreign = PairingBatch(
            foreignMaster,
            (new TextSpan(6, 7), "close", null));
        Throws<InvalidOperationException>(
            () => Pairing.Pair(
                ClaimSelection.Create(batch, new[] { 0 }),
                ClaimSelection.All(foreign),
                nullKeyPolicy),
            "pairing refuses incompatible coordinate spaces");

        Throws<ArgumentException>(
            () => new PairingPolicy(" ", static (_, _) => true),
            "pairing policy requires a diagnostic name");
        Throws<ArgumentNullException>(
            () => new PairingPolicy("null-rule", null!),
            "pairing policy requires a compatibility rule");
        Throws<ArgumentNullException>(
            () => PairingPolicy.ByKey<string>("null-key", null!),
            "key pairing policy requires a selector");
        Throws<ArgumentNullException>(
            () => Pairing.Pair(null!, noCloses, nullKeyPolicy),
            "pairing requires an open selection");
        Throws<ArgumentNullException>(
            () => Pairing.Pair(noOpens, null!, nullKeyPolicy),
            "pairing requires a close selection");
        Throws<ArgumentNullException>(
            () => Pairing.Pair(noOpens, noCloses, null!),
            "pairing requires a policy stamp");
    }

    /// <summary>
    /// K2c gate: all 5,461 words of length zero through six over open-A, open-B, close-A,
    /// and close-B are checked against an independently written abstract stack oracle. Every
    /// result also satisfies exact partition, compatibility, forwardness, one-to-one, and
    /// noncrossing laws.
    /// </summary>
    private static void PairingMatchesAnIndependentBoundedStackOracle()
    {
        var policy = PairingPolicy.ByKey<string?>(
            "bounded-key",
            static record => record.RuleId);
        var oracleAgreement = true;
        var resultLawsHold = true;
        var wordCount = 0;

        for (var length = 0; length <= 6 && oracleAgreement && resultLawsHold; length++)
        {
            var possibilities = 1 << (length * 2);
            for (var encoded = 0; encoded < possibilities; encoded++)
            {
                wordCount++;
                var master = new TextMaster(
                    $"pairing-word-{length}-{encoded}",
                    0,
                    new string('x', length * 2));
                var tokenClaims = new (TextSpan Span, string Role, string? Key)[length];
                var oracleTokens = new PairingOracleToken[length];
                for (var position = 0; position < length; position++)
                {
                    var symbol = (encoded >> (position * 2)) & 3;
                    var isOpen = symbol < 2;
                    var key = (symbol & 1) == 0 ? "A" : "B";
                    tokenClaims[position] = (
                        new TextSpan(position * 2, (position * 2) + 1),
                        isOpen ? "open" : "close",
                        key);
                    oracleTokens[position] = new PairingOracleToken(isOpen, key);
                }

                var batch = PairingBatch(master, tokenClaims);
                var opens = ClaimSelection.FromPredicate(
                    batch,
                    static record => record.Kind == "open");
                var closes = ClaimSelection.FromPredicate(
                    batch,
                    static record => record.Kind == "close");
                var actual = Pairing.Pair(opens, closes, policy);
                var expected = PairingOracle(oracleTokens);
                oracleAgreement &= PairingResultMatchesOracle(actual, expected);
                resultLawsHold &= PairingResultObeysLaws(actual, opens, closes, policy);
            }
        }

        Equal(5461, wordCount,
            "bounded pairing oracle covers every two-key word through length six");
        True(oracleAgreement,
            "every bounded pairing result agrees with the independent abstract stack oracle");
        True(resultLawsHold,
            "every bounded pairing result satisfies stamps, partitions, and match invariants");
    }

    /// <summary>
    /// Joint K3/K4a-core gate: the located carrier admits diagonal empties, uses the exact window
    /// as algebraic state, composes by endpoint equality, and weakens master identity only to
    /// explicit value compatibility.
    /// </summary>
    private static void LocatedRelationHasAConcreteBasisAndReferenceAlgebra()
    {
        var master = new TextMaster("located-reference", 2, "a😀b");
        var window = master.Extent;
        var relation = LocatedRelation.Create(
            master,
            window,
            new[]
            {
                new TextSpan(4, 4),
                new TextSpan(1, 3),
                new TextSpan(0, 1),
                new TextSpan(1, 3),
            });

        Equal(3, relation.Count,
            "located construction collapses duplicate geometry and canonicalizes enumeration");
        True(relation.SequenceEqual(new[]
            {
                new TextSpan(0, 1),
                new TextSpan(1, 3),
                new TextSpan(4, 4),
            }),
            "located geometry enumerates by start then end");
        True(ReferenceEquals(relation.Master, master) && relation.Window == window,
            "located relation retains its representative master and exact window");
        True(relation.Contains(new TextSpan(1, 3)) &&
             !relation.Contains(new TextSpan(3, 4)),
            "located membership is extensional geometry on the retained basis");

        var identity = LocatedRelation.Identity(master, window);
        True(identity.SequenceEqual(new[]
            {
                new TextSpan(0, 0),
                new TextSpan(1, 1),
                new TextSpan(3, 3),
                new TextSpan(4, 4),
            }),
            "located identity contains every scalar-valid declared-window boundary");
        True(identity.Seq(relation).Equals(relation) &&
             relation.Seq(identity).Equals(relation),
            "diagonal empties are two-sided Seq identity edges");

        var chain = LocatedRelation.Create(
            master,
            window,
            new[]
            {
                new TextSpan(0, 1),
                new TextSpan(1, 1),
                new TextSpan(1, 3),
                new TextSpan(3, 4),
            });
        var reachability = chain.Reachability();
        Equal(10, reachability.Count,
            "three consuming links reach every ordered pair of four scalar boundaries");
        True(reachability.Contains(new TextSpan(0, 4)) &&
             chain.Consuming().Reachability().Equals(reachability),
            "reachability is the consuming closure plus the complete diagonal");
        True(LocatedRelation.Empty(master, window).Reachability().Equals(identity),
            "empty relation reachability is the declared-window identity");

        var compatible = new TextMaster(master.DocumentId, master.Revision, master.Text);
        var compatibleRelation = LocatedRelation.Create(
            compatible,
            window,
            new[] { new TextSpan(0, 1), new TextSpan(1, 3), new TextSpan(4, 4) });
        True(relation.Equals(compatibleRelation) &&
             relation.GetHashCode() == compatibleRelation.GetHashCode(),
            "located value equality follows compatible master identity");
        True(relation.Union(compatibleRelation).Equals(relation),
            "located binary operations admit compatible master representatives");

        var emptyWindow = new TextSpan(1, 1);
        var emptyIdentity = LocatedRelation.Identity(master, emptyWindow);
        Equal(1, emptyIdentity.Count,
            "an empty declared window has one diagonal identity extent");
        True(LocatedRelation.Empty(master, emptyWindow).Reachability().Equals(emptyIdentity),
            "empty-window reachability preserves the one-point identity");

        Throws<ArgumentNullException>(
            () => LocatedRelation.Empty(null!, window),
            "located basis requires a master");
        Throws<ArgumentNullException>(
            () => LocatedRelation.Create(master, window, null!),
            "located construction requires an edge population");
        Throws<ArgumentException>(
            () => LocatedRelation.Create(
                master,
                new TextSpan(1, 3),
                new[] { new TextSpan(0, 1) }),
            "located construction refuses out-of-window geometry");
        Throws<ArgumentException>(
            () => LocatedRelation.Empty(master, new TextSpan(0, 2)),
            "located windows cannot split a surrogate pair");
        Throws<InvalidOperationException>(
            () => relation.Seq(LocatedRelation.Empty(master, new TextSpan(0, 1))),
            "located composition refuses unequal windows");
        Throws<InvalidOperationException>(
            () => relation.Union(LocatedRelation.Empty(
                new TextMaster("located-foreign", 2, master.Text),
                window)),
            "located operations refuse incompatible coordinate spaces");
        Throws<ArgumentNullException>(
            () => relation.Seq(null!),
            "located composition requires another relation");
    }

    /// <summary>
    /// K3 assurance: all 64 relation values on the three-boundary chain agree with an independent
    /// pair-composition and Floyd-Warshall oracle. Cached production results then certify identity,
    /// associativity, both distributive laws, consuming projection, and the finite path bound over
    /// all 262,144 triples.
    /// </summary>
    private static void LocatedRelationMatchesBoundedExhaustiveOracles()
    {
        var master = new TextMaster("located-bounded", 0, "ab");
        var window = master.Extent;
        var boundaries = new[] { 0, 1, 2 };
        var extents = new[]
        {
            new TextSpan(0, 0),
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 1),
            new TextSpan(1, 2),
            new TextSpan(2, 2),
        };
        var valueCount = 1 << extents.Length;
        var values = new LocatedRelation[valueCount];
        for (var mask = 0; mask < valueCount; mask++)
        {
            values[mask] = LocatedFromMask(master, window, extents, mask);
        }

        var seqMasks = new int[valueCount, valueCount];
        var seqOracleAgreement = true;
        for (var left = 0; left < valueCount; left++)
        {
            for (var right = 0; right < valueCount; right++)
            {
                var actual = LocatedMask(values[left].Seq(values[right]), extents);
                seqMasks[left, right] = actual;
                seqOracleAgreement &= actual == LocatedSeqOracleMask(left, right, extents);
            }
        }

        True(seqOracleAgreement,
            "all bounded located Seq values agree with the independent nested-pair oracle");

        var identityMask = LocatedMask(LocatedRelation.Identity(master, window), extents);
        var identityHolds = true;
        var closureOracleAgreement = true;
        var consumingProjectionHolds = true;
        var finiteStarHolds = true;
        for (var relation = 0; relation < valueCount; relation++)
        {
            identityHolds &= seqMasks[identityMask, relation] == relation &&
                             seqMasks[relation, identityMask] == relation;

            var consumingMask = relation & ~identityMask;
            consumingProjectionHolds &=
                LocatedMask(values[relation].Consuming(), extents) == consumingMask;

            var expectedClosure = LocatedReachabilityOracleMask(
                relation,
                boundaries,
                extents);
            closureOracleAgreement &=
                LocatedMask(values[relation].Reachability(), extents) == expectedClosure;

            var boundedStar = identityMask;
            var power = consumingMask;
            for (var length = 1; length < boundaries.Length; length++)
            {
                boundedStar |= power;
                power = seqMasks[power, consumingMask];
            }

            finiteStarHolds &= boundedStar == expectedClosure && power == 0;
        }

        True(identityHolds,
            "the complete diagonal is identity for every bounded located relation");
        True(consumingProjectionHolds,
            "consuming projection removes exactly the bounded diagonal edges");
        True(closureOracleAgreement,
            "all bounded reachability values agree with independent Floyd-Warshall closure");
        True(finiteStarHolds,
            "consuming star closes within boundary-count minus one and is then nilpotent");

        var associativityHolds = true;
        var leftDistributivityHolds = true;
        var rightDistributivityHolds = true;
        var tripleCount = 0;
        for (var left = 0; left < valueCount; left++)
        {
            for (var middle = 0; middle < valueCount; middle++)
            {
                for (var right = 0; right < valueCount; right++)
                {
                    tripleCount++;
                    associativityHolds &=
                        seqMasks[seqMasks[left, middle], right] ==
                        seqMasks[left, seqMasks[middle, right]];
                    leftDistributivityHolds &=
                        seqMasks[left, middle | right] ==
                        (seqMasks[left, middle] | seqMasks[left, right]);
                    rightDistributivityHolds &=
                        seqMasks[left | middle, right] ==
                        (seqMasks[left, right] | seqMasks[middle, right]);
                }
            }
        }

        Equal(262144, tripleCount,
            "bounded located laws cover every relation triple on three boundaries");
        True(associativityHolds, "located Seq is associative on every bounded relation triple");
        True(leftDistributivityHolds,
            "located Seq distributes over union in its right argument");
        True(rightDistributivityHolds,
            "located Seq distributes over union in its left argument");
    }

    /// <summary>
    /// K3 rebase gate: an injective TextSlice map moves the declared window and edges together and
    /// commutes exactly with union, Seq, and reachability. A local collapsing-map counterexample
    /// retains the reason no generalized exact map surface lands with this chip.
    /// </summary>
    private static void LocatedRelationRebasesExactlyThroughSlices()
    {
        var parent = new TextMaster("located-rebase", 4, "xxa😀byy");
        var slice = TextSlice.Create(parent, new TextSpan(2, 6));
        var childWindow = slice.Child.Extent;
        var left = LocatedRelation.Create(
            slice.Child,
            childWindow,
            new[]
            {
                new TextSpan(0, 1),
                new TextSpan(1, 1),
                new TextSpan(1, 3),
            });
        var right = LocatedRelation.Create(
            slice.Child,
            childWindow,
            new[]
            {
                new TextSpan(1, 3),
                new TextSpan(3, 4),
            });

        var parentLeft = slice.ToParent(left);
        True(ReferenceEquals(parentLeft.Master, parent) &&
             parentLeft.Window == new TextSpan(2, 6) &&
             parentLeft.SequenceEqual(new[]
             {
                 new TextSpan(2, 3),
                 new TextSpan(3, 3),
                 new TextSpan(3, 5),
             }),
            "child-to-parent located rebase maps the exact window and every edge");
        True(slice.ToChild(parentLeft).Equals(left),
            "located relation rebase round-trips through one slice");
        True(slice.ToParent(left.Union(right)).Equals(
                slice.ToParent(left).Union(slice.ToParent(right))),
            "injective located rebase commutes with union");
        True(slice.ToParent(left.Seq(right)).Equals(
                slice.ToParent(left).Seq(slice.ToParent(right))),
            "injective located rebase commutes with Seq");
        True(slice.ToParent(left.Reachability()).Equals(
                slice.ToParent(left).Reachability()),
            "injective located rebase commutes with reachability");
        True(slice.ToParent(LocatedRelation.Identity(slice.Child, childWindow)).Equals(
                LocatedRelation.Identity(parent, slice.Window)),
            "located rebase maps the complete declared-window diagonal exactly");

        var compatibleChild = new TextMaster(
            slice.Child.DocumentId,
            slice.Child.Revision,
            slice.Child.Text);
        var compatibleRelation = LocatedRelation.Create(
            compatibleChild,
            childWindow,
            new[] { new TextSpan(0, 1) });
        True(slice.ToParent(compatibleRelation).Equals(LocatedRelation.Create(
                parent,
                slice.Window,
                new[] { new TextSpan(2, 3) })),
            "TextSlice accepts a compatible located master representative");

        var nestedParent = LocatedRelation.Create(
            parent,
            new TextSpan(3, 6),
            new[] { new TextSpan(3, 5), new TextSpan(5, 6) });
        True(slice.ToChild(nestedParent).Window == new TextSpan(1, 4),
            "parent-to-child located rebase preserves a nested exact window");
        Throws<ArgumentException>(
            () => slice.ToChild(LocatedRelation.Empty(parent, new TextSpan(0, 3))),
            "parent-to-child located rebase refuses a window crossing the slice boundary");
        Throws<InvalidOperationException>(
            () => slice.ToParent(LocatedRelation.Empty(
                new TextMaster("located-unrelated", 0, slice.Child.Text),
                childWindow)),
            "located rebase refuses an unrelated coordinate space");
        Throws<ArgumentNullException>(
            () => slice.ToParent((LocatedRelation)null!),
            "located rebase requires a relation");

        var pointImage = new[] { 0, 1, 1, 2 };
        var sourceLeft = new HashSet<(int Start, int End)> { (0, 1) };
        var sourceRight = new HashSet<(int Start, int End)> { (2, 3) };
        var imageOfComposition = ImagePointRelation(
            ComposePointRelations(sourceLeft, sourceRight),
            pointImage);
        var compositionOfImages = ComposePointRelations(
            ImagePointRelation(sourceLeft, pointImage),
            ImagePointRelation(sourceRight, pointImage));
        True(imageOfComposition.IsSubsetOf(compositionOfImages) &&
             !imageOfComposition.SetEquals(compositionOfImages) &&
             compositionOfImages.Contains((0, 2)),
            "non-injective point image preserves only lax Seq inclusion");
    }

    /// <summary>
    /// Joint K3/K4a-core graph gate: candidate identity is an exact selection on one frozen batch,
    /// while the explicit located projection collapses parallel equal-geometry ordinals and admits
    /// compatible value equality only after that boundary.
    /// </summary>
    private static void CandidateRegionGraphPreservesOccurrenceIdentityUntilProjection()
    {
        var master = new TextMaster("candidate-graph", 1, "abcd");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2),
            new TextSpan(0, 2),
            new TextSpan(2, 4));
        var candidates = ClaimSelection.Create(batch, new[] { 0, 1, 2 });
        var graph = CandidateRegionGraph.Create(candidates, new TextSpan(0, 2));

        True(ReferenceEquals(graph.Source, batch) &&
             ReferenceEquals(graph.Candidates, candidates) &&
             ReferenceEquals(graph.Master, master),
            "candidate graph retains the exact batch and selection objects");
        True(graph.SequenceEqual(new[] { 0, 1, 2 }) && graph.Count == 3,
            "candidate graph enumerates distinct edge ordinals canonically");
        True(graph.Contains(0) && graph.Contains(1) && !graph.Contains(3),
            "parallel equal-geometry claim ordinals remain distinct graph edges");

        var projection = graph.ToLocatedRelation();
        True(projection.SequenceEqual(new[]
            {
                new TextSpan(0, 1),
                new TextSpan(1, 2),
            }),
            "parallel claim edges collapse only at explicit located projection");
        True(projection.Reachability().Contains(new TextSpan(0, 2)),
            "projected candidate geometry feeds the one located reachability implementation");

        var equalGraph = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 2, 1, 0, 1 }),
            graph.Window);
        True(graph.Equals(equalGraph) && graph.GetHashCode() == equalGraph.GetHashCode(),
            "candidate graph equality is extensional only inside one exact batch basis");
        True(!graph.Equals(CandidateRegionGraph.Create(
                ClaimSelection.Create(batch, new[] { 0, 2 }),
                graph.Window)),
            "candidate graph equality retains ordinal membership");

        var compatibleMaster = new TextMaster(master.DocumentId, master.Revision, master.Text);
        var compatibleBatch = PairBatch(
            compatibleMaster,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2),
            new TextSpan(0, 2),
            new TextSpan(2, 4));
        var compatibleGraph = CandidateRegionGraph.Create(
            ClaimSelection.Create(compatibleBatch, new[] { 0, 1, 2 }),
            graph.Window);
        True(!graph.Equals(compatibleGraph),
            "compatible equal-row batches remain different occurrence graph bases");
        True(graph.ToLocatedRelation().Equals(compatibleGraph.ToLocatedRelation()),
            "different occurrence graphs may project to one compatible located value");

        var empty = CandidateRegionGraph.Create(
            ClaimSelection.None(batch),
            new TextSpan(2, 2));
        True(empty.IsEmpty && empty.ToLocatedRelation().IsEmpty &&
             empty.Window == new TextSpan(2, 2),
            "empty-window graph coherently retains an empty candidate selection");

        Throws<ArgumentException>(
            () => CandidateRegionGraph.Create(
                ClaimSelection.Create(batch, new[] { 4 }),
                new TextSpan(0, 2)),
            "candidate graph refuses out-of-window selected claims");
        Throws<ArgumentException>(
            () => CandidateRegionGraph.Create(
                ClaimSelection.Create(batch, new[] { 0 }),
                new TextSpan(2, 2)),
            "empty graph windows admit only an empty candidate selection");
        Throws<ArgumentNullException>(
            () => CandidateRegionGraph.Create(null!, master.Extent),
            "candidate graph requires an exact selection basis");

        var unicodeMaster = new TextMaster("candidate-unicode", 0, "😀");
        var unicodeBatch = PairBatch(unicodeMaster, unicodeMaster.Extent);
        Throws<ArgumentException>(
            () => CandidateRegionGraph.Create(
                ClaimSelection.None(unicodeBatch),
                new TextSpan(0, 1)),
            "candidate graph validates its window even when no edges are selected");
    }

    /// <summary>
    /// K4a reachability gate: the view retains one exact graph, delegates every path fact to the
    /// K3 geometry closure, and reports a dead alternative branch without turning a successful
    /// graph into a failed segmentation.
    /// </summary>
    private static void ReachabilityViewKeepsGraphStampAndDiagnostics()
    {
        var master = new TextMaster("reachability-view", 0, "abcd");
        var batch = PairBatch(
            master,
            new TextSpan(0, 4),
            new TextSpan(0, 2),
            new TextSpan(1, 4));
        var graph = CandidateRegionGraph.Create(ClaimSelection.All(batch), master.Extent);
        var view = ReachabilityView.Create(graph);

        True(ReferenceEquals(view.Graph, graph) &&
             ReferenceEquals(view.Source, batch) &&
             ReferenceEquals(view.Master, master) &&
             view.Window == master.Extent,
            "reachability view retains its exact graph, batch, master, and window stamps");
        True(view.Closure.Equals(graph.ToLocatedRelation().Reachability()) &&
             view.HasCompletePath &&
             view.CanReach(0, 4),
            "reachability view delegates complete-path facts to the projected K3 closure");
        True(view.ForwardReachableBoundaries.SequenceEqual(new[] { 0, 2, 4 }) &&
             view.BackwardReachableBoundaries.SequenceEqual(new[] { 0, 1, 4 }),
            "reachability view derives ordered forward and backward boundary diagnostics");
        True(view.DeadEndCandidates.SequenceEqual(new[] { 1 }) &&
             view.DeadEndBoundaries.SequenceEqual(new[] { 2 }),
            "a reachable alternative branch that cannot complete remains exact ordinal evidence");
        True(view.IsReachableFromWindowStart(2) &&
             !view.IsReachableFromWindowStart(1) &&
             view.CanReachWindowEnd(1) &&
             !view.CanReachWindowEnd(2),
            "boundary query conveniences agree with the retained closure");

        var result = Segmentation.FirstOrdinalCompletePath(graph);
        True(result.IsComplete && result.Residual is null &&
             result.Partition is not null && result.Partition.SequenceEqual(new[] { 0 }),
            "dead alternative diagnostics coexist with a successful complete partition");
        True(ReferenceEquals(result.Graph, graph) &&
             ReferenceEquals(result.Reachability.Graph, graph) &&
             result.Policy == SegmentationPolicy.FirstOrdinalCompletePath,
            "a successful segmentation retains its exact graph and named reference policy");

        Throws<ArgumentOutOfRangeException>(
            () => view.CanReach(-1, 0),
            "reachability queries refuse extents outside the graph window");
        Throws<ArgumentOutOfRangeException>(
            () => view.IsReachableFromWindowStart(5),
            "forward boundary queries refuse positions outside the graph window");
        Throws<ArgumentNullException>(
            () => ReachabilityView.Create(null!),
            "reachability construction requires a graph");
    }

    /// <summary>
    /// K4a partition gate: an ordinal path is immutable and exact-graph stamped, and construction
    /// refuses every way a candidate list can fail to be a disjoint gap-free total window cover.
    /// </summary>
    private static void PartitionViewValidatesExactIdentityBearingPaths()
    {
        var master = new TextMaster("partition-view", 0, "abc");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(1, 3),
            new TextSpan(0, 2),
            new TextSpan(2, 3),
            new TextSpan(1, 2));
        var graph = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 0, 1, 2, 3 }),
            master.Extent);
        var input = new[] { 0, 1 };
        var partition = PartitionView.Create(graph, input);
        input[0] = 2;

        True(ReferenceEquals(partition.Graph, graph) &&
             ReferenceEquals(partition.Source, batch) &&
             partition.Window == master.Extent,
            "partition retains its exact graph, batch, and window stamps");
        True(partition.SequenceEqual(new[] { 0, 1 }) &&
             partition.Ordinals.SequenceEqual(new[] { 0, 1 }) &&
             partition.Selection.SequenceEqual(new[] { 0, 1 }),
            "partition copies and preserves its ordered identity-bearing path");
        True(partition.Equals(PartitionView.Create(graph, new[] { 0, 1 })) &&
             partition.GetHashCode() == PartitionView.Create(graph, new[] { 0, 1 }).GetHashCode(),
            "partition value equality combines exact-basis graph value with ordinal order");

        var equalGraphObject = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 0, 1, 2, 3 }),
            master.Extent);
        var equalGraphPartition = PartitionView.Create(equalGraphObject, new[] { 0, 1 });
        True(graph.Equals(equalGraphObject) &&
             partition.Equals(equalGraphPartition) &&
             partition.GetHashCode() == equalGraphPartition.GetHashCode(),
            "partition equality uses graph value equality without weakening the exact batch basis");

        var alternative = PartitionView.Create(graph, new[] { 2, 3 });
        True(alternative.SequenceEqual(new[] { 2, 3 }) &&
             !partition.Equals(alternative),
            "parallel complete partitions retain their distinct ordinal paths");

        var emptyGraph = CandidateRegionGraph.Create(
            ClaimSelection.None(batch),
            new TextSpan(2, 2));
        var empty = PartitionView.Create(emptyGraph, Array.Empty<int>());
        True(empty.IsEmpty && empty.Count == 0 &&
             ReferenceEquals(empty.Graph, emptyGraph),
            "an empty window has the coherent exact-graph-stamped zero-edge partition");

        Throws<ArgumentNullException>(
            () => PartitionView.Create(null!, Array.Empty<int>()),
            "partition construction requires a graph");
        Throws<ArgumentNullException>(
            () => PartitionView.Create(graph, null!),
            "partition construction requires an ordinal path");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, Array.Empty<int>()),
            "a nonempty window refuses an empty partition");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 4 }),
            "partition construction refuses an unselected source-batch ordinal");
        Throws<ArgumentOutOfRangeException>(
            () => PartitionView.Create(graph, new[] { 99 }),
            "partition construction refuses an ordinal outside the source batch");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 0, 0, 1 }),
            "partition construction refuses repeated ordinal identity");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 1 }),
            "partition construction refuses a path starting after the graph window");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 0, 3 }),
            "partition construction refuses nonmeeting adjacent edges");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 2, 1 }),
            "partition construction refuses overlapping adjacent edges");
        Throws<ArgumentException>(
            () => PartitionView.Create(graph, new[] { 0 }),
            "partition construction refuses a path ending before the graph window");
    }

    /// <summary>
    /// K4a fixture gate: ambiguous token and parallel occurrence paths retain identity; an
    /// external budget may admit chunk candidates without becoming graph state; gap, full-cover
    /// dead-end, and empty-window outcomes remain distinct.
    /// </summary>
    private static void FirstOrdinalSegmentationWitnessesRequiredCases()
    {
        var tokenMaster = new TextMaster("ambiguous-token", 0, "abc");
        var tokenBatch = PairBatch(
            tokenMaster,
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(2, 3));
        var tokenGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(tokenBatch),
            tokenMaster.Extent);
        var tokenResult = Segmentation.FirstOrdinalCompletePath(tokenGraph);
        True(tokenResult.IsComplete && tokenResult.Partition is not null &&
             tokenResult.Partition.SequenceEqual(new[] { 0, 2 }),
            "ambiguous token graph chooses the first viable ordinal at each boundary");

        var reorderedBatch = PairBatch(
            tokenMaster,
            new TextSpan(0, 2),
            new TextSpan(0, 1),
            new TextSpan(2, 3),
            new TextSpan(1, 3));
        var reorderedGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(reorderedBatch),
            tokenMaster.Extent);
        var reorderedResult = Segmentation.FirstOrdinalCompletePath(reorderedGraph);
        True(reorderedResult.Partition is not null &&
             reorderedResult.Partition.SequenceEqual(new[] { 0, 2 }) &&
             tokenBatch[tokenResult.Partition![0]].Span !=
                 reorderedBatch[reorderedResult.Partition[0]].Span,
            "first-ordinal determinism is exact-basis reproducibility, not recollection invariance");

        var parallelMaster = new TextMaster("parallel-path", 0, "ab");
        var parallelBatch = PairBatch(
            parallelMaster,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2));
        var parallelResult = Segmentation.FirstOrdinalCompletePath(
            CandidateRegionGraph.Create(ClaimSelection.All(parallelBatch), parallelMaster.Extent));
        True(parallelResult.Partition is not null &&
             parallelResult.Partition.SequenceEqual(new[] { 0, 2 }) &&
             parallelResult.Reachability.Closure.Count == 6,
            "parallel equal-geometry alternatives remain ordinals while closure collapses geometry");

        const int budget = 3;
        var chunkMaster = new TextMaster("budget-chunks", 0, "abcde");
        var chunkBatch = PairBatch(
            chunkMaster,
            new TextSpan(0, 2),
            new TextSpan(0, 3),
            new TextSpan(2, 5),
            new TextSpan(3, 5),
            new TextSpan(0, 5));
        var admittedChunks = ClaimSelection.FromPredicate(
            chunkBatch,
            record => record.Span.Length <= budget);
        var chunkGraph = CandidateRegionGraph.Create(admittedChunks, chunkMaster.Extent);
        var chunkResult = Segmentation.FirstOrdinalCompletePath(chunkGraph);
        True(admittedChunks.SequenceEqual(new[] { 0, 1, 2, 3 }) &&
             chunkResult.Partition is not null &&
             chunkResult.Partition.SequenceEqual(new[] { 0, 2 }),
            "externally budget-admissible chunk candidates produce a path without costed graph state");

        var failureMaster = new TextMaster("segmentation-failures", 0, "abcd");
        var gapBatch = PairBatch(
            failureMaster,
            new TextSpan(0, 1),
            new TextSpan(2, 4));
        var gapGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(gapBatch),
            failureMaster.Extent);
        var gapResult = Segmentation.FirstOrdinalCompletePath(gapGraph);
        True(!gapResult.IsComplete && gapResult.Partition is null &&
             gapResult.Residual is not null &&
             gapResult.Residual.CoverageGaps.SequenceEqual(new[] { new TextSpan(1, 2) }) &&
             gapResult.Residual.HasCoverageGaps,
            "coverage-gap failure retains the exact normalized missing material");
        True(ReferenceEquals(gapResult.Graph, gapGraph) &&
             ReferenceEquals(gapResult.Residual!.Graph, gapGraph) &&
             ReferenceEquals(gapResult.Residual.Reachability, gapResult.Reachability) &&
             gapResult.Policy == SegmentationPolicy.FirstOrdinalCompletePath,
            "failed segmentation retains one exact graph, reachability view, and policy stamp");

        var deadBatch = PairBatch(
            failureMaster,
            new TextSpan(0, 2),
            new TextSpan(1, 4));
        var deadGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(deadBatch),
            failureMaster.Extent);
        var deadResult = Segmentation.FirstOrdinalCompletePath(deadGraph);
        True(!deadResult.IsComplete && deadResult.Residual is not null &&
             !deadResult.Residual.HasCoverageGaps &&
             deadResult.Residual.HasConnectivityDeadEnds &&
             deadResult.Residual.DeadEndCandidates.SequenceEqual(new[] { 0 }) &&
             deadResult.Residual.DeadEndBoundaries.SequenceEqual(new[] { 2 }),
            "full material coverage does not hide an endpoint-connectivity dead end");

        var emptyGraph = CandidateRegionGraph.Create(
            ClaimSelection.None(gapBatch),
            new TextSpan(2, 2));
        var emptyResult = Segmentation.FirstOrdinalCompletePath(emptyGraph);
        True(emptyResult.IsComplete && emptyResult.Partition is not null &&
             emptyResult.Partition.IsEmpty && emptyResult.Residual is null &&
             emptyResult.Reachability.Closure.SequenceEqual(new[] { new TextSpan(2, 2) }),
            "empty graph window returns a zero-edge partition and one-point geometry identity");

        Throws<ArgumentNullException>(
            () => Segmentation.FirstOrdinalCompletePath(null!),
            "reference segmentation requires a graph");
    }

    /// <summary>
    /// K4a assurance: every one of 128 candidate subsets on a seven-edge basis agrees with an
    /// independently enumerated complete-path oracle, independent DFS reachability, material-gap
    /// scan, and exact dead-branch projection.
    /// </summary>
    private static void FirstOrdinalSegmentationMatchesBoundedPathOracle()
    {
        var master = new TextMaster("segmentation-bounded", 0, "abc");
        var window = master.Extent;
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2),
            new TextSpan(2, 3),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(0, 3));
        var boundaries = new[] { 0, 1, 2, 3 };
        var valueCount = 1 << batch.Count;
        var pathAgreement = true;
        var reachabilityAgreement = true;
        var diagnosticsAgreement = true;
        var resultLawsHold = true;

        for (var mask = 0; mask < valueCount; mask++)
        {
            var graph = CandidateRegionGraph.Create(SelectionFromMask(batch, mask), window);
            var result = Segmentation.FirstOrdinalCompletePath(graph);
            var paths = SegmentationPathOracle(batch, mask, window);
            var expectedPath = paths.Count == 0 ? null : paths[0];

            pathAgreement &= result.IsComplete == (expectedPath is not null);
            if (expectedPath is not null)
            {
                pathAgreement &= result.Partition is not null &&
                                 result.Partition.SequenceEqual(expectedPath);
            }

            var expectedForward = new List<int>();
            var expectedBackward = new List<int>();
            foreach (var boundary in boundaries)
            {
                if (SegmentationCanReachOracle(batch, mask, window.Start, boundary))
                {
                    expectedForward.Add(boundary);
                }

                if (SegmentationCanReachOracle(batch, mask, boundary, window.End))
                {
                    expectedBackward.Add(boundary);
                }
            }

            reachabilityAgreement &=
                result.Reachability.ForwardReachableBoundaries.SequenceEqual(expectedForward) &&
                result.Reachability.BackwardReachableBoundaries.SequenceEqual(expectedBackward);
            for (var start = 0; start < boundaries.Length; start++)
            {
                for (var end = start; end < boundaries.Length; end++)
                {
                    reachabilityAgreement &= result.Reachability.CanReach(
                        boundaries[start],
                        boundaries[end]) == SegmentationCanReachOracle(
                            batch,
                            mask,
                            boundaries[start],
                            boundaries[end]);
                }
            }

            var expectedDeadOrdinals = new List<int>();
            var expectedDeadBoundaries = new SortedSet<int>();
            for (var ordinal = 0; ordinal < batch.Count; ordinal++)
            {
                if ((mask & (1 << ordinal)) == 0)
                {
                    continue;
                }

                var edge = batch[ordinal].Span;
                if (SegmentationCanReachOracle(batch, mask, window.Start, edge.Start) &&
                    !SegmentationCanReachOracle(batch, mask, edge.End, window.End))
                {
                    expectedDeadOrdinals.Add(ordinal);
                    expectedDeadBoundaries.Add(edge.End);
                }
            }

            diagnosticsAgreement &=
                result.Reachability.DeadEndCandidates.SequenceEqual(expectedDeadOrdinals) &&
                result.Reachability.DeadEndBoundaries.SequenceEqual(expectedDeadBoundaries);

            resultLawsHold &= ReferenceEquals(result.Graph, graph) &&
                              ReferenceEquals(result.Reachability.Graph, graph) &&
                              result.Policy == SegmentationPolicy.FirstOrdinalCompletePath &&
                              ((result.Partition is not null) != (result.Residual is not null));
            if (result.Partition is not null)
            {
                resultLawsHold &= ReferenceEquals(result.Partition.Graph, graph) &&
                                  SegmentationPathIsCompleteOracle(
                                      batch,
                                      mask,
                                      window,
                                      result.Partition);
            }
            else
            {
                var residual = result.Residual!;
                resultLawsHold &= ReferenceEquals(residual.Graph, graph) &&
                                  ReferenceEquals(residual.Reachability, result.Reachability) &&
                                  !residual.IsEmpty;
                diagnosticsAgreement &= residual.CoverageGaps.SequenceEqual(
                    SegmentationGapOracle(batch, mask, window));
            }
        }

        Equal(128, valueCount,
            "bounded segmentation oracle covers every subset of the seven-edge basis");
        True(pathAgreement,
            "first-ordinal traversal agrees with independently enumerated complete paths");
        True(reachabilityAgreement,
            "graph-stamped closure agrees with independent DFS on every bounded endpoint pair");
        True(diagnosticsAgreement,
            "bounded gap and dead-branch diagnostics agree with independent projections");
        True(resultLawsHold,
            "every bounded segmentation result satisfies exact stamps and exclusive outcome laws");
    }

    /// <summary>
    /// K4b policy gate: caller costs are evaluated once and frozen on one exact graph with an
    /// explicit additive-minimum guarantee, lexicographic tie rule, and opaque unit stamp.
    /// </summary>
    private static void AdditivePathPolicySnapshotsAnExactObjective()
    {
        var master = new TextMaster("path-policy", 0, "abc");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(2, 3),
            new TextSpan(1, 2));
        var graph = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 0, 1, 2, 3 }),
            master.Extent);
        var costs = new long[] { 5, 1, 5, 1, 99 };
        var evaluations = 0;
        var policy = AdditivePathPolicy.Create(
            graph,
            "token-penalty",
            "penalty-points",
            record =>
            {
                evaluations++;
                return costs[record.Ordinal];
            });

        Equal(graph.Count, evaluations,
            "additive policy evaluates caller cost exactly once per graph candidate");
        True(ReferenceEquals(policy.Graph, graph) &&
             policy.Name == "token-penalty" &&
             policy.Unit == "penalty-points" &&
             policy.Guarantee == PathSelectionGuarantee.MinimumAdditiveCost &&
             policy.TieBreak == PathTieBreak.LexicographicOrdinal,
            "additive policy retains exact graph, name, unit, guarantee, and tie stamps");
        True(graph.All(ordinal => policy.CostOf(ordinal) == costs[ordinal]),
            "additive policy exposes the frozen exact-ordinal cost table");
        Equal(graph.Count, evaluations,
            "reading retained costs never re-enters caller code");

        Throws<ArgumentNullException>(
            () => AdditivePathPolicy.Create(null!, "x", "u", static _ => 0),
            "additive policy requires a graph");
        Throws<ArgumentException>(
            () => AdditivePathPolicy.Create(graph, " ", "u", static _ => 0),
            "additive policy requires a diagnostic name");
        Throws<ArgumentException>(
            () => AdditivePathPolicy.Create(graph, "x", " ", static _ => 0),
            "additive policy requires a score unit");
        Throws<ArgumentNullException>(
            () => AdditivePathPolicy.Create(graph, "x", "u", null!),
            "additive policy requires an edge-cost function");
        Throws<ArgumentOutOfRangeException>(
            () => AdditivePathPolicy.Create(
                graph,
                "negative",
                "u",
                record => record.Ordinal == 2 ? -1 : 0),
            "additive policy refuses a negative candidate cost");
        Throws<ArgumentException>(
            () => AdditivePathPolicy.Create(
                graph,
                "overflow",
                "u",
                record => record.Ordinal == 0 ? long.MaxValue : 1),
            "additive policy refuses a candidate-cost table whose total cannot fit Int64");
        Throws<ArgumentException>(
            () => policy.CostOf(4),
            "additive policy refuses an in-batch ordinal outside its graph candidates");
        Throws<ArgumentOutOfRangeException>(
            () => policy.CostOf(99),
            "additive policy refuses an ordinal outside its source batch");
    }

    /// <summary>
    /// K4b problem gate: hard constraints are one retained exact-batch subset, while policy,
    /// source graph, and derived admissible graph remain separately inspectable exact stamps.
    /// </summary>
    private static void PathSelectionProblemValidatesExactAdmissibility()
    {
        var master = new TextMaster("path-problem", 0, "abc");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(2, 3),
            new TextSpan(1, 2));
        var graph = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 0, 1, 2, 3 }),
            master.Extent);
        var policy = AdditivePathPolicy.Create(
            graph,
            "problem-policy",
            "points",
            static record => record.Ordinal + 1);
        var admissible = ClaimSelection.Create(batch, new[] { 0, 2 });
        var problem = PathSelectionProblem.Create(graph, admissible, policy);

        True(ReferenceEquals(problem.Graph, graph) &&
             ReferenceEquals(problem.Source, batch) &&
             ReferenceEquals(problem.AdmissibleCandidates, admissible) &&
             ReferenceEquals(problem.Policy, policy),
            "path problem retains exact source graph, batch, admissible selection, and policy");
        True(ReferenceEquals(problem.AdmissibleGraph.Candidates, admissible) &&
             ReferenceEquals(problem.AdmissibleGraph.Source, batch) &&
             problem.AdmissibleGraph.Window == graph.Window,
            "path problem derives an exact admissible graph on the retained source window");
        True(problem.ExcludedCandidates.SequenceEqual(new[] { 1, 3 }) &&
             problem.Feasibility == PathFeasibility.CompletePath,
            "path problem exposes hard exclusions and the explicit complete-path contract");

        Throws<ArgumentNullException>(
            () => PathSelectionProblem.Create(null!, admissible, policy),
            "path problem requires a graph");
        Throws<ArgumentNullException>(
            () => PathSelectionProblem.Create(graph, null!, policy),
            "path problem requires an admissible selection");
        Throws<ArgumentNullException>(
            () => PathSelectionProblem.Create(graph, admissible, null!),
            "path problem requires a policy");
        Throws<ArgumentException>(
            () => PathSelectionProblem.Create(
                graph,
                ClaimSelection.Create(batch, new[] { 0, 4 }),
                policy),
            "path problem refuses an admissible ordinal outside the source graph");

        var equalGraphObject = CandidateRegionGraph.Create(
            ClaimSelection.Create(batch, new[] { 0, 1, 2, 3 }),
            master.Extent);
        var equalGraphPolicy = AdditivePathPolicy.Create(
            equalGraphObject,
            "equal-graph-object",
            "points",
            static _ => 0);
        var equalGraphProblem = PathSelectionProblem.Create(graph, admissible, equalGraphPolicy);
        True(ReferenceEquals(equalGraphProblem.Graph, graph) &&
             ReferenceEquals(equalGraphProblem.Policy, equalGraphPolicy) &&
             equalGraphProblem.Policy.Graph.Equals(graph),
            "path problem accepts an equal graph definition while retaining its supplied graph and policy objects");

        var compatibleMaster = new TextMaster(master.DocumentId, master.Revision, master.Text);
        var foreignBatch = PairBatch(
            compatibleMaster,
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(2, 3),
            new TextSpan(1, 2));
        Throws<InvalidOperationException>(
            () => PathSelectionProblem.Create(
                graph,
                ClaimSelection.Create(foreignBatch, new[] { 0, 2 }),
                policy),
            "path problem refuses a compatible but different frozen-batch basis");
    }

    /// <summary>
    /// K4b result gate: an additive objective can defeat the K4a baseline, ties retain ordinal
    /// identity, hard exclusions remain distinct from rejected alternatives, and infeasibility
    /// reuses K4a evidence on the exact admissible graph.
    /// </summary>
    private static void AdditivePathSelectionRetainsDecisionsAndResiduals()
    {
        var master = new TextMaster("path-selection", 0, "abc");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(2, 3));
        var graph = CandidateRegionGraph.Create(ClaimSelection.All(batch), master.Extent);
        var costs = new long[] { 5, 1, 5, 1 };
        var policy = AdditivePathPolicy.Create(
            graph,
            "minimum-token-penalty",
            "penalty-points",
            record => costs[record.Ordinal]);
        var problem = PathSelectionProblem.Create(graph, graph.Candidates, policy);
        var result = PathSelection.Select(problem);
        var baseline = Segmentation.FirstOrdinalCompletePath(graph);

        True(result.IsComplete && result.Partition is not null &&
             result.Partition.SequenceEqual(new[] { 1, 3 }) &&
             baseline.Partition is not null && baseline.Partition.SequenceEqual(new[] { 0, 2 }),
            "minimum additive selection may intentionally differ from the first-ordinal baseline");
        True(ReferenceEquals(result.Problem, problem) &&
             ReferenceEquals(result.Graph, graph) &&
             ReferenceEquals(result.Partition!.Graph, graph) &&
             ReferenceEquals(result.Policy, policy),
            "successful path selection retains exact problem, graph, partition, and policy stamps");
        True(result.Score == 2 && result.ScoreUnit == "penalty-points" &&
             result.Guarantee == PathSelectionGuarantee.MinimumAdditiveCost &&
             result.TieBreak == PathTieBreak.LexicographicOrdinal &&
             result.Feasibility == PathFeasibility.CompletePath,
            "successful path selection exposes its mechanically checkable score and contract stamps");
        True(result.SelectedCandidates.SequenceEqual(new[] { 1, 3 }) &&
             result.RejectedCandidates.SequenceEqual(new[] { 0, 2 }) &&
             result.ExcludedCandidates.IsEmpty && result.Residual is null,
            "successful path selection retains selected and rejected admissible alternatives");

        var lexicalMaster = new TextMaster("path-tokenizer", 0, "a b");
        var lexicalBuilder = new SpanBatchBuilder(lexicalMaster);
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(0, 1), "token", SpanLevel.Character, "tokenizer"));
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(0, 2), "token-with-trivia", SpanLevel.Character, "tokenizer"));
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(1, 2), "trivia", SpanLevel.Character, "tokenizer"));
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(1, 3), "recovery", SpanLevel.Character, "tokenizer"));
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(2, 3), "token", SpanLevel.Character, "tokenizer"));
        lexicalBuilder.Add(new SpanClaim(
            new TextSpan(0, 3), "recovery", SpanLevel.Character, "tokenizer"));
        var lexicalBatch = lexicalBuilder.Freeze();
        var lexicalGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(lexicalBatch),
            lexicalMaster.Extent);
        var lexicalAdmissible = ClaimSelection.FromPredicate(
            lexicalBatch,
            static record => record.Kind != "recovery");
        var lexicalPolicy = AdditivePathPolicy.Create(
            lexicalGraph,
            "explicit-trivia-no-recovery",
            "token-penalty",
            static record => record.Kind switch
            {
                "trivia" => 0,
                "token" => 1,
                "token-with-trivia" => 5,
                _ => 50,
            });
        var lexical = PathSelection.Select(PathSelectionProblem.Create(
            lexicalGraph,
            lexicalAdmissible,
            lexicalPolicy));
        True(lexical.Partition is not null &&
             lexical.Partition.SequenceEqual(new[] { 0, 2, 4 }) && lexical.Score == 2 &&
             lexical.RejectedCandidates.SequenceEqual(new[] { 1 }) &&
             lexical.ExcludedCandidates.SequenceEqual(new[] { 3, 5 }),
            "labeled token selection makes trivia admission and recovery exclusion explicit");

        var tiedPolicy = AdditivePathPolicy.Create(
            graph,
            "tied-token-penalty",
            "penalty-points",
            static _ => 1);
        var tied = PathSelection.Select(
            PathSelectionProblem.Create(graph, graph.Candidates, tiedPolicy));
        True(tied.Score == 2 && tied.Partition is not null &&
             tied.Partition.SequenceEqual(new[] { 0, 2 }),
            "equal additive scores choose the lexicographically smallest full ordinal path");

        var forcedAdmissible = ClaimSelection.Create(batch, new[] { 0, 2 });
        var forcedProblem = PathSelectionProblem.Create(graph, forcedAdmissible, policy);
        var forced = PathSelection.Select(forcedProblem);
        True(forced.Partition is not null && forced.Partition.SequenceEqual(new[] { 0, 2 }) &&
             forced.Score == 10 && forced.RejectedCandidates.IsEmpty &&
             forced.ExcludedCandidates.SequenceEqual(new[] { 1, 3 }),
            "hard exclusion remains distinct from objective rejection and can force another path");

        var gapAdmissible = ClaimSelection.Create(batch, new[] { 0, 3 });
        var gapProblem = PathSelectionProblem.Create(graph, gapAdmissible, policy);
        var gap = PathSelection.Select(gapProblem);
        True(!gap.IsComplete && gap.Partition is null && gap.Score is null &&
             gap.SelectedCandidates.IsEmpty &&
             gap.RejectedCandidates.SequenceEqual(new[] { 0, 3 }) &&
             gap.ExcludedCandidates.SequenceEqual(new[] { 1, 2 }),
            "failed path selection retains a total selected/rejected/excluded population account");
        True(gap.Residual is not null &&
             ReferenceEquals(gap.Residual.Problem, gapProblem) &&
             ReferenceEquals(gap.Residual.Graph, graph) &&
             ReferenceEquals(gap.Residual.AdmissibleGraph, gapProblem.AdmissibleGraph) &&
             ReferenceEquals(gap.Residual.Feasibility.Graph, gapProblem.AdmissibleGraph) &&
             gap.Residual.CoverageGaps.SequenceEqual(new[] { new TextSpan(1, 2) }),
            "selection failure wraps K4a feasibility evidence on the exact admissible graph");

        var deadAdmissible = ClaimSelection.Create(batch, new[] { 1, 2 });
        var deadProblem = PathSelectionProblem.Create(graph, deadAdmissible, policy);
        var dead = PathSelection.Select(deadProblem);
        True(dead.Residual is not null && dead.Residual.CoverageGaps.Count == 0 &&
             dead.Residual.DeadEndCandidates.SequenceEqual(new[] { 1 }) &&
             dead.Residual.DeadEndBoundaries.SequenceEqual(new[] { 2 }),
            "full-coverage selection failure retains connectivity-dead-end evidence separately");

        var parallelMaster = new TextMaster("path-parallel", 0, "ab");
        var parallelBatch = PairBatch(
            parallelMaster,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2));
        var parallelGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(parallelBatch),
            parallelMaster.Extent);
        var parallelPolicy = AdditivePathPolicy.Create(
            parallelGraph,
            "parallel-tie",
            "points",
            static _ => 0);
        var parallel = PathSelection.Select(PathSelectionProblem.Create(
            parallelGraph,
            parallelGraph.Candidates,
            parallelPolicy));
        True(parallel.Partition is not null && parallel.Partition.SequenceEqual(new[] { 0, 2 }),
            "equal-geometry parallel candidates remain distinct and tie by exact ordinal");

        const int chunkBudget = 4;
        var chunkMaster = new TextMaster("path-chunks", 0, "abcdef");
        var chunkBatch = PairBatch(
            chunkMaster,
            new TextSpan(0, 2),
            new TextSpan(0, 3),
            new TextSpan(2, 6),
            new TextSpan(3, 6),
            new TextSpan(0, 6));
        var chunkGraph = CandidateRegionGraph.Create(
            ClaimSelection.All(chunkBatch),
            chunkMaster.Extent);
        var chunkAdmissible = ClaimSelection.FromPredicate(
            chunkBatch,
            record => record.Span.Length <= chunkBudget);
        var chunkCosts = new long[] { 5, 1, 5, 1, 0 };
        var chunkPolicy = AdditivePathPolicy.Create(
            chunkGraph,
            "minimum-breakpoint-penalty",
            "breakpoint-points",
            record => chunkCosts[record.Ordinal]);
        var chunks = PathSelection.Select(PathSelectionProblem.Create(
            chunkGraph,
            chunkAdmissible,
            chunkPolicy));
        True(chunks.Partition is not null && chunks.Partition.SequenceEqual(new[] { 1, 3 }) &&
             chunks.Score == 2 && chunks.ScoreUnit == "breakpoint-points" &&
             chunks.RejectedCandidates.SequenceEqual(new[] { 0, 2 }) &&
             chunks.ExcludedCandidates.SequenceEqual(new[] { 4 }),
            "chunk selection separates a hard size budget from additive breakpoint costs");

        var emptyGraph = CandidateRegionGraph.Create(
            ClaimSelection.None(batch),
            new TextSpan(2, 2));
        var emptyPolicy = AdditivePathPolicy.Create(
            emptyGraph,
            "empty-path",
            "points",
            static _ => throw new InvalidOperationException("No candidate should be evaluated."));
        var empty = PathSelection.Select(PathSelectionProblem.Create(
            emptyGraph,
            emptyGraph.Candidates,
            emptyPolicy));
        True(empty.IsComplete && empty.Partition is not null && empty.Partition.IsEmpty &&
             empty.Score == 0 && empty.SelectedCandidates.IsEmpty &&
             empty.RejectedCandidates.IsEmpty && empty.ExcludedCandidates.IsEmpty,
            "empty-window selection returns the complete zero-edge path with zero score");

        Throws<ArgumentNullException>(
            () => PathSelection.Select(null!),
            "path selection requires a problem");
    }

    /// <summary>
    /// K4b assurance: all 16,384 combinations of an admissible-edge subset and binary cost table
    /// agree with independent complete-path enumeration, additive scoring, and lexicographic
    /// minimization on the seven-edge K4a basis.
    /// </summary>
    private static void AdditivePathSelectionMatchesBoundedOptimizerOracle()
    {
        var master = new TextMaster("path-selection-bounded", 0, "abc");
        var window = master.Extent;
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(0, 1),
            new TextSpan(1, 2),
            new TextSpan(2, 3),
            new TextSpan(0, 2),
            new TextSpan(1, 3),
            new TextSpan(0, 3));
        var graph = CandidateRegionGraph.Create(ClaimSelection.All(batch), window);
        var valueCount = 1 << batch.Count;
        var optimizationAgreement = true;
        var populationLawsHold = true;
        var stampsHold = true;
        var costSnapshotHolds = true;
        var problemCount = 0;

        for (var costMask = 0; costMask < valueCount; costMask++)
        {
            var evaluations = 0;
            var capturedCostMask = costMask;
            var policy = AdditivePathPolicy.Create(
                graph,
                $"bounded-binary-{costMask}",
                "binary-points",
                record =>
                {
                    evaluations++;
                    return (capturedCostMask >> record.Ordinal) & 1;
                });

            for (var admissibleMask = 0; admissibleMask < valueCount; admissibleMask++)
            {
                problemCount++;
                var admissible = SelectionFromMask(batch, admissibleMask);
                var problem = PathSelectionProblem.Create(graph, admissible, policy);
                var actual = PathSelection.Select(problem);
                var expected = MinimumCostPathOracle(
                    SegmentationPathOracle(batch, admissibleMask, window),
                    costMask);

                optimizationAgreement &= actual.IsComplete == (expected is not null);
                if (expected is not null)
                {
                    optimizationAgreement &= actual.Partition is not null &&
                                             actual.Partition.SequenceEqual(expected.Path) &&
                                             actual.Score == expected.Score;
                }
                else
                {
                    optimizationAgreement &= actual.Partition is null &&
                                             actual.Score is null &&
                                             actual.Residual is not null;
                }

                populationLawsHold &=
                    actual.SelectedCandidates.Intersect(actual.RejectedCandidates).IsEmpty &&
                    actual.SelectedCandidates.Union(actual.RejectedCandidates).Equals(admissible) &&
                    admissible.Intersect(actual.ExcludedCandidates).IsEmpty &&
                    admissible.Union(actual.ExcludedCandidates).Equals(graph.Candidates);

                stampsHold &= ReferenceEquals(actual.Problem, problem) &&
                              ReferenceEquals(actual.Graph, graph) &&
                              ReferenceEquals(actual.Policy, policy) &&
                              actual.Guarantee == PathSelectionGuarantee.MinimumAdditiveCost &&
                              actual.TieBreak == PathTieBreak.LexicographicOrdinal &&
                              actual.Feasibility == PathFeasibility.CompletePath &&
                              ((actual.Partition is not null) != (actual.Residual is not null));
                if (actual.Partition is not null)
                {
                    stampsHold &= ReferenceEquals(actual.Partition.Graph, graph);
                }
                else
                {
                    stampsHold &= ReferenceEquals(
                        actual.Residual!.Feasibility.Graph,
                        problem.AdmissibleGraph);
                }
            }

            costSnapshotHolds &= evaluations == graph.Count;
        }

        Equal(16384, problemCount,
            "bounded optimizer oracle crosses every admissible subset with every binary cost table");
        True(optimizationAgreement,
            "additive path selection agrees with independent all-path minimum and tie resolution");
        True(populationLawsHold,
            "every bounded result partitions source candidates into selected, rejected, and excluded");
        True(stampsHold,
            "every bounded result retains exact problem, graph, policy, feasibility, and outcome stamps");
        True(costSnapshotHolds,
            "bounded selection never re-enters a caller cost function after policy construction");
    }

    /// <summary>
    /// K4c validator assurance: packing, total cover, and laminar-family construction agree with
    /// independent pairwise and unit-cell predicates on every subset of the ten nonempty
    /// intervals over five boundaries.
    /// </summary>
    private static void StructuralValidatorsMatchBoundedOracles()
    {
        var master = new TextMaster("structural-validator-bounded", 0, "abcd");
        var intervals = NonemptyIntervals(4);
        var batch = PairBatch(master, intervals);
        var window = master.Extent;
        var packingPolicy = new PackingPolicy("bounded-packing");
        var coverPolicy = new CoverPolicy("bounded-cover");
        var laminarPolicy = new LaminarFamilyPolicy("bounded-laminar");
        var valueCount = 1 << batch.Count;
        var packingAgreement = true;
        var coverAgreement = true;
        var laminarAgreement = true;
        var validViewsRetainStamps = true;

        for (var mask = 0; mask < valueCount; mask++)
        {
            var selection = SelectionFromMask(batch, mask);
            PackingView? packing = null;
            CoverView? cover = null;
            LaminarView? laminar = null;
            var packingAccepted = ValidationAccepts(() =>
                packing = PackingView.Create(selection, window, packingPolicy));
            var coverAccepted = ValidationAccepts(() =>
                cover = CoverView.Create(selection, window, coverPolicy));
            var laminarAccepted = ValidationAccepts(() =>
                laminar = LaminarView.Create(selection, window, laminarPolicy));

            packingAgreement &= packingAccepted == PackingMaskOracle(batch, mask);
            coverAgreement &= coverAccepted == CoverMaskOracle(batch, mask, window);
            laminarAgreement &= laminarAccepted == LaminarMaskOracle(batch, mask);
            if (packing is not null)
            {
                validViewsRetainStamps &= ReferenceEquals(packing.Selection, selection) &&
                                         ReferenceEquals(packing.Policy, packingPolicy);
            }

            if (cover is not null)
            {
                validViewsRetainStamps &= ReferenceEquals(cover.Selection, selection) &&
                                         ReferenceEquals(cover.Policy, coverPolicy);
            }

            if (laminar is not null)
            {
                validViewsRetainStamps &= ReferenceEquals(laminar.Selection, selection) &&
                                         ReferenceEquals(laminar.Policy, laminarPolicy);
            }
        }

        Equal(1024, valueCount,
            "bounded structural validator carrier contains every five-boundary interval subset");
        True(packingAgreement,
            "packing validation agrees with an independent pairwise-disjointness oracle");
        True(coverAgreement,
            "cover validation agrees with an independent unit-cell total-coverage oracle");
        True(laminarAgreement,
            "laminar validation agrees with an independent alternating-endpoint oracle");
        True(validViewsRetainStamps,
            "every accepted bounded structural view retains its exact selection and policy objects");
    }

    /// <summary>
    /// K4c admission assurance: all 4,096 candidate-mask × binary-priority problems agree with an
    /// independent greedy policy oracle, while a direct witness proves maximal does not mean maximum.
    /// </summary>
    private static void LaminarAdmissionMatchesBoundedOracle()
    {
        var master = new TextMaster("laminar-admission-bounded", 0, "abc");
        var intervals = NonemptyIntervals(3);
        var familyPolicy = new LaminarFamilyPolicy("bounded-admission-family");
        var admissionPolicy = LaminarAdmissionPolicy.PriorityThenGeometry(
            "bounded-priority-admission",
            familyPolicy);
        var problemCount = 0;
        var oracleAgreement = true;
        var populationLawsHold = true;
        var maximalityHolds = true;

        for (var priorityMask = 0; priorityMask < (1 << intervals.Length); priorityMask++)
        {
            var builder = new SpanBatchBuilder(master);
            for (var ordinal = 0; ordinal < intervals.Length; ordinal++)
            {
                builder.Add(new SpanClaim(
                    intervals[ordinal],
                    $"candidate-{ordinal}",
                    SpanLevel.Character,
                    "bounded",
                    (priorityMask >> ordinal) & 1));
            }

            var batch = builder.Freeze();
            for (var candidateMask = 0; candidateMask < (1 << intervals.Length); candidateMask++)
            {
                problemCount++;
                var candidates = SelectionFromMask(batch, candidateMask);
                var actual = Laminarizer.Admit(candidates, master.Extent, admissionPolicy);
                var expectedMask = LaminarAdmissionMaskOracle(batch, candidateMask);
                oracleAgreement &= SelectionMatchesMask(actual.AcceptedCandidates, expectedMask);
                populationLawsHold &=
                    actual.AcceptedCandidates.Intersect(actual.CrossingResidue).IsEmpty &&
                    actual.AcceptedCandidates.Union(actual.CrossingResidue).Equals(candidates) &&
                    ReferenceEquals(actual.Candidates, candidates) &&
                    ReferenceEquals(actual.Policy, admissionPolicy) &&
                    ReferenceEquals(actual.Accepted.Policy, familyPolicy);
                maximalityHolds &= LaminarMaskOracle(batch, expectedMask) &&
                                   LaminarAdmissionIsMaximalOracle(
                                       batch,
                                       expectedMask,
                                       candidateMask & ~expectedMask);
            }
        }

        Equal(4096, problemCount,
            "bounded laminar oracle crosses every candidate subset with every binary priority table");
        True(oracleAgreement,
            "laminar admission agrees with the independent grouped priority-greedy oracle");
        True(populationLawsHold,
            "every bounded admission retains exact stamps and a complete accepted/residue partition");
        True(maximalityHolds,
            "every bounded greedy result is laminar and inclusion-maximal inside its candidates");

        var counterexampleMaster = new TextMaster("laminar-not-maximum", 0, "0123456789");
        var counterexampleBuilder = new SpanBatchBuilder(counterexampleMaster);
        counterexampleBuilder.Add(new SpanClaim(
            new TextSpan(2, 8), "high-middle", SpanLevel.Character, "test", 10));
        counterexampleBuilder.Add(new SpanClaim(
            new TextSpan(0, 4), "left", SpanLevel.Character, "test", 1));
        counterexampleBuilder.Add(new SpanClaim(
            new TextSpan(6, 10), "right", SpanLevel.Character, "test", 1));
        var counterexampleBatch = counterexampleBuilder.Freeze();
        var greedy = Laminarizer.Admit(
            ClaimSelection.All(counterexampleBatch),
            counterexampleMaster.Extent,
            admissionPolicy);
        var largerFamily = LaminarView.Create(
            ClaimSelection.Create(counterexampleBatch, new[] { 1, 2 }),
            counterexampleMaster.Extent,
            familyPolicy);
        True(greedy.AcceptedCandidates.SequenceEqual(new[] { 0 }) &&
             largerFamily.Count == 2 &&
             greedy.Guarantee == LaminarAdmissionGuarantee.InclusionMaximal,
            "greedy laminar admission is explicitly maximal but not maximum-cardinality");
    }

    /// <summary>
    /// K4c parenthood gate: containment produces parents only through the named nearest-container
    /// projection, including a lowest-ordinal tie for equal parent geometry.
    /// </summary>
    private static void NearestContainerProjectionIsExplicit()
    {
        var master = new TextMaster("nearest-containers", 0, "0123456789012345");
        var batch = PairBatch(
            master,
            new TextSpan(0, 12),
            new TextSpan(0, 12),
            new TextSpan(0, 10),
            new TextSpan(2, 10),
            new TextSpan(3, 5),
            new TextSpan(3, 5),
            new TextSpan(6, 8),
            new TextSpan(12, 16));
        var familyPolicy = new LaminarFamilyPolicy("nearest-source-family");
        var family = LaminarView.Create(
            ClaimSelection.All(batch),
            master.Extent,
            familyPolicy);
        var nearestPolicy = HierarchyPolicy.NearestContainer("nearest-strict-container");
        var hierarchy = LaminarHierarchy.NearestContainers(family, nearestPolicy);
        var expected = new[]
        {
            new HierarchyEdge(2, 0, nearestPolicy.Name),
            new HierarchyEdge(3, 2, nearestPolicy.Name),
            new HierarchyEdge(4, 3, nearestPolicy.Name),
            new HierarchyEdge(5, 3, nearestPolicy.Name),
            new HierarchyEdge(6, 3, nearestPolicy.Name),
        };

        True(hierarchy.SequenceEqual(expected) &&
             ReferenceEquals(hierarchy.Nodes, family.Selection) &&
             ReferenceEquals(hierarchy.Policy, nearestPolicy) &&
             ReferenceEquals(hierarchy.SourceLaminarFamily, family),
            "nearest-container projection retains immediate edges and exact source/policy stamps");
        True(hierarchy.Roots.SequenceEqual(new[] { 0, 1, 7 }) &&
             hierarchy.ParentsOf(4).SequenceEqual(new[] { 3 }) &&
             hierarchy.ChildrenOf(3).SequenceEqual(new[] { 4, 5, 6 }),
            "nearest-container projection exposes roots and direct parent/child incidence");
        True(hierarchy.Policy.Construction == HierarchyConstruction.NearestStrictContainer &&
             hierarchy.Policy.TieBreak == HierarchyTieBreak.LowestOrdinal,
            "nearest-container policy makes construction and equal-geometry tie semantics explicit");

        var explicitPolicy = HierarchyPolicy.Explicit("no-inference");
        var explicitEmpty = HierarchyView.Create(
            family.Selection,
            family.Window,
            explicitPolicy,
            Array.Empty<HierarchyEdge>());
        True(explicitEmpty.Count == 0 && explicitEmpty.Roots.Equals(family.Selection),
            "general hierarchy construction infers no edges from nested geometry");
        Throws<ArgumentException>(
            () => LaminarHierarchy.NearestContainers(family, explicitPolicy),
            "nearest-container projection requires its explicit derivation policy");

        var boundedMaster = new TextMaster("nearest-bounded", 0, "abcd");
        var boundedBatch = PairBatch(boundedMaster, NonemptyIntervals(4));
        var boundedPolicy = new LaminarFamilyPolicy("nearest-bounded-family");
        var boundedNearestPolicy = HierarchyPolicy.NearestContainer("nearest-bounded-policy");
        var validFamilyCount = 0;
        var oracleAgreement = true;
        for (var mask = 0; mask < (1 << boundedBatch.Count); mask++)
        {
            if (!LaminarMaskOracle(boundedBatch, mask))
            {
                continue;
            }

            validFamilyCount++;
            var boundedFamily = LaminarView.Create(
                SelectionFromMask(boundedBatch, mask),
                boundedMaster.Extent,
                boundedPolicy);
            var actual = LaminarHierarchy.NearestContainers(boundedFamily, boundedNearestPolicy);
            var expectedEdges = NearestContainerOracle(
                boundedBatch,
                mask,
                boundedNearestPolicy.Name);
            oracleAgreement &= actual.SequenceEqual(expectedEdges);
        }

        True(validFamilyCount > 0,
            "nearest-container bounded assurance exercises nonempty valid laminar families");
        True(oracleAgreement,
            "nearest-container projection agrees on every bounded valid laminar family");
    }

    /// <summary>
    /// K4c hierarchy gate: explicit DAGs retain multiple parents, disconnected nodes, and supplied
    /// transitive edges while refusing malformed edge evidence.
    /// </summary>
    private static void HierarchyViewRetainsExplicitDag()
    {
        var master = new TextMaster("hierarchy", 0, "0123456789");
        var batch = PairBatch(
            master,
            new TextSpan(4, 6),
            new TextSpan(2, 8),
            new TextSpan(0, 7),
            new TextSpan(0, 10));
        var nodes = ClaimSelection.All(batch);
        var policy = HierarchyPolicy.Explicit("caller-parent-edges");
        var diamond = HierarchyView.Create(
            nodes,
            master.Extent,
            policy,
            new[]
            {
                new HierarchyEdge(0, 1, "left-parent"),
                new HierarchyEdge(0, 2, "right-parent"),
                new HierarchyEdge(1, 3, "root"),
                new HierarchyEdge(2, 3, "root"),
            });

        True(ReferenceEquals(diamond.Nodes, nodes) &&
             ReferenceEquals(diamond.Basis, batch) &&
             ReferenceEquals(diamond.Policy, policy) &&
             diamond.Policy.Construction == HierarchyConstruction.ExplicitEdges &&
             diamond.Policy.TieBreak == HierarchyTieBreak.None &&
             diamond.SourceLaminarFamily is null,
            "explicit hierarchy retains exact node, basis, window, and policy stamps");
        True(diamond.ParentsOf(0).SequenceEqual(new[] { 1, 2 }) &&
             diamond.ChildrenOf(3).SequenceEqual(new[] { 1, 2 }) &&
             diamond.Roots.SequenceEqual(new[] { 3 }) &&
             diamond.Leaves.SequenceEqual(new[] { 0 }),
            "explicit hierarchy permits a multiple-parent diamond across crossing parent geometry");

        var withTransitive = HierarchyView.Create(
            nodes,
            master.Extent,
            policy,
            diamond.Concat(new[] { new HierarchyEdge(0, 3, "explicit-transitive") }));
        True(withTransitive.Count == 5 && withTransitive.ContainsEdge(0, 3),
            "explicit hierarchy retains a supplied transitive edge without closure or reduction");

        var disconnected = HierarchyView.Create(
            nodes,
            master.Extent,
            policy,
            Array.Empty<HierarchyEdge>());
        True(disconnected.Roots.Equals(nodes) && disconnected.Leaves.Equals(nodes),
            "explicit hierarchy retains disconnected selected nodes");

        Throws<ArgumentException>(
            () => HierarchyView.Create(
                nodes,
                master.Extent,
                policy,
                new[] { new HierarchyEdge(0, 0, "self") }),
            "explicit hierarchy refuses self edges");
        Throws<ArgumentException>(
            () => HierarchyView.Create(
                nodes,
                master.Extent,
                policy,
                new[]
                {
                    new HierarchyEdge(0, 1, "a"),
                    new HierarchyEdge(0, 1, "b"),
                }),
            "explicit hierarchy refuses duplicate child/parent pairs");
        Throws<ArgumentException>(
            () => HierarchyView.Create(
                nodes,
                master.Extent,
                policy,
                new[] { new HierarchyEdge(0, 1, " ") }),
            "explicit hierarchy requires edge derivation labels");
        Throws<ArgumentException>(
            () => HierarchyView.Create(
                ClaimSelection.Create(batch, new[] { 0, 1 }),
                master.Extent,
                policy,
                new[] { new HierarchyEdge(0, 2, "outside-selection") }),
            "explicit hierarchy refuses an endpoint outside its exact node selection");
        Throws<ArgumentException>(
            () => HierarchyView.Create(
                nodes,
                master.Extent,
                policy,
                new[]
                {
                    new HierarchyEdge(0, 1, "cycle-a"),
                    new HierarchyEdge(1, 0, "cycle-b"),
                }),
            "explicit hierarchy refuses directed cycles");
        Throws<ArgumentException>(
            () => HierarchyView.Create(
                nodes,
                master.Extent,
                HierarchyPolicy.NearestContainer("wrong-construction"),
                Array.Empty<HierarchyEdge>()),
            "explicit hierarchy construction refuses a nearest-container policy");
        Throws<ArgumentException>(
            () => HierarchyPolicy.Explicit(" "),
            "hierarchy policy requires a name");
    }

    /// <summary>K4c hierarchy assurance: every directed non-self graph on four nodes matches an independent DAG oracle.</summary>
    private static void HierarchyViewMatchesBoundedDagOracle()
    {
        var master = new TextMaster("hierarchy-bounded", 0, "abcd");
        var batch = PairBatch(
            master,
            new TextSpan(0, 1),
            new TextSpan(1, 2),
            new TextSpan(2, 3),
            new TextSpan(3, 4));
        var nodes = ClaimSelection.All(batch);
        var policy = HierarchyPolicy.Explicit("bounded-explicit-dag");
        var possibleEdges = new List<(int Child, int Parent)>();
        for (var child = 0; child < 4; child++)
        {
            for (var parent = 0; parent < 4; parent++)
            {
                if (child != parent)
                {
                    possibleEdges.Add((child, parent));
                }
            }
        }

        var graphCount = 1 << possibleEdges.Count;
        var agreement = true;
        var stampsHold = true;
        for (var mask = 0; mask < graphCount; mask++)
        {
            var edges = new List<HierarchyEdge>();
            for (var edgeIndex = 0; edgeIndex < possibleEdges.Count; edgeIndex++)
            {
                if ((mask & (1 << edgeIndex)) != 0)
                {
                    var edge = possibleEdges[edgeIndex];
                    edges.Add(new HierarchyEdge(edge.Child, edge.Parent, "bounded"));
                }
            }

            HierarchyView? actual = null;
            var accepted = ValidationAccepts(() =>
                actual = HierarchyView.Create(nodes, master.Extent, policy, edges));
            agreement &= accepted == DirectedAcyclicOracle(4, possibleEdges, mask);
            if (actual is not null)
            {
                stampsHold &= ReferenceEquals(actual.Nodes, nodes) &&
                              ReferenceEquals(actual.Policy, policy) &&
                              actual.SequenceEqual(edges.OrderBy(edge => edge.ChildOrdinal)
                                  .ThenBy(edge => edge.ParentOrdinal));
            }
        }

        Equal(4096, graphCount,
            "bounded hierarchy oracle covers every directed non-self edge subset on four nodes");
        True(agreement,
            "explicit hierarchy DAG validation agrees with the independent topological oracle");
        True(stampsHold,
            "every accepted bounded hierarchy retains exact stamps and canonical explicit edges");
    }

    /// <summary>
    /// K4c resolution gate: many-to-many incidence, functional aggregation, and exact material
    /// aggregation are distinct same-master contracts with exact layer stamps.
    /// </summary>
    private static void ResolutionMapsSeparateIncidenceFromAggregation()
    {
        var fineMaster = new TextMaster("resolution", 0, "abcdef");
        var fineBuilder = new SpanBatchBuilder(fineMaster);
        fineBuilder.Add(new SpanClaim(new TextSpan(0, 2), "token", SpanLevel.Character, "lexer"));
        fineBuilder.Add(new SpanClaim(new TextSpan(2, 4), "sentence", SpanLevel.Line, "parser"));
        fineBuilder.Add(new SpanClaim(new TextSpan(4, 6), "token", SpanLevel.MultiLine, "lexer"));
        var fineBatch = fineBuilder.Freeze();
        var coarseMaster = new TextMaster("resolution", 0, "abcdef");
        var coarseBatch = PairBatch(
            coarseMaster,
            new TextSpan(0, 4),
            new TextSpan(2, 6),
            new TextSpan(0, 6));
        var finePolicy = new ResolutionLayerPolicy("fine-v1");
        var coarsePolicy = new ResolutionLayerPolicy("coarse-v1");
        var fine = ResolutionView.Create(
            ClaimSelection.All(fineBatch),
            fineMaster.Extent,
            finePolicy);
        var coarse = ResolutionView.Create(
            ClaimSelection.Create(coarseBatch, new[] { 0, 1 }),
            coarseMaster.Extent,
            coarsePolicy);
        var incidencePolicy = ResolutionMapPolicy.Incidence("overlapping-membership");
        var incidence = ResolutionMap.Create(
            fine,
            coarse,
            incidencePolicy,
            new[]
            {
                new ResolutionEdge(0, 0),
                new ResolutionEdge(1, 0),
                new ResolutionEdge(1, 1),
                new ResolutionEdge(2, 1),
            });

        True(ReferenceEquals(incidence.Fine, fine) &&
             ReferenceEquals(incidence.Coarse, coarse) &&
             ReferenceEquals(incidence.Policy, incidencePolicy) &&
             incidence.Contract == ResolutionMapContract.Incidence,
            "resolution incidence retains exact compatible layer and policy objects");
        True(incidence.CoarseTargets(1).SequenceEqual(new[] { 0, 1 }) &&
             incidence.FineMembers(0).SequenceEqual(new[] { 0, 1 }) &&
             incidence.ProjectFine().Equals(fine.Selection) &&
             incidence.ProjectCoarse().Equals(coarse.Selection),
            "resolution incidence retains explicit many-to-many occurrence relationships");
        True(fine.Name == "fine-v1" &&
             fine.Basis[0].Kind == fine.Basis[2].Kind &&
             fine.Basis[0].Level != fine.Basis[2].Level,
            "resolution name remains separate from claim kind and SpanLevel metadata");

        var noInference = ResolutionMap.Create(
            fine,
            coarse,
            incidencePolicy,
            Array.Empty<ResolutionEdge>());
        True(noInference.IsEmpty && noInference.ProjectFine().IsEmpty && noInference.ProjectCoarse().IsEmpty,
            "resolution incidence infers no edge from containment geometry");

        var functionalPolicy = ResolutionMapPolicy.FunctionalAggregation("functional-membership");
        var functional = ResolutionMap.Create(
            fine,
            coarse,
            functionalPolicy,
            new[]
            {
                new ResolutionEdge(0, 0),
                new ResolutionEdge(1, 0),
                new ResolutionEdge(2, 1),
            });
        True(functional.Contract == ResolutionMapContract.FunctionalAggregation &&
             functional.Count == 3,
            "functional aggregation requires one coarse target per fine member and uses every coarse member");
        Throws<ArgumentException>(
            () => ResolutionMap.Create(
                fine,
                coarse,
                functionalPolicy,
                new[]
                {
                    new ResolutionEdge(0, 0),
                    new ResolutionEdge(1, 0),
                    new ResolutionEdge(1, 1),
                    new ResolutionEdge(2, 1),
                }),
            "functional aggregation refuses multiple coarse targets for one fine member");

        var exactCoarseBatch = PairBatch(
            coarseMaster,
            new TextSpan(0, 4),
            new TextSpan(4, 6));
        var exactCoarse = ResolutionView.Create(
            ClaimSelection.All(exactCoarseBatch),
            coarseMaster.Extent,
            new ResolutionLayerPolicy("exact-coarse"));
        var exactPolicy = ResolutionMapPolicy.ExactAggregation("exact-material");
        var exact = ResolutionMap.Create(
            fine,
            exactCoarse,
            exactPolicy,
            new[]
            {
                new ResolutionEdge(0, 0),
                new ResolutionEdge(1, 0),
                new ResolutionEdge(2, 1),
            });
        True(exact.Contract == ResolutionMapContract.ExactAggregation && exact.Count == 3,
            "exact aggregation validates normalized fine material for each coarse occurrence");

        var holeFine = PairBatch(
            fineMaster,
            new TextSpan(0, 2),
            new TextSpan(3, 5));
        var holeCoarse = PairBatch(coarseMaster, new TextSpan(0, 5));
        var holeFineView = ResolutionView.Create(
            ClaimSelection.All(holeFine),
            new TextSpan(0, 5),
            new ResolutionLayerPolicy("hole-fine"));
        var holeCoarseView = ResolutionView.Create(
            ClaimSelection.All(holeCoarse),
            new TextSpan(0, 5),
            new ResolutionLayerPolicy("hole-coarse"));
        Throws<ArgumentException>(
            () => ResolutionMap.Create(
                holeFineView,
                holeCoarseView,
                exactPolicy,
                new[] { new ResolutionEdge(0, 0), new ResolutionEdge(1, 0) }),
            "exact aggregation rejects an envelope that hides a material hole");

        Throws<ArgumentException>(
            () => ResolutionMap.Create(
                fine,
                coarse,
                incidencePolicy,
                new[] { new ResolutionEdge(0, 0), new ResolutionEdge(0, 0) }),
            "resolution map refuses duplicate explicit edges");
        Throws<ArgumentException>(
            () => ResolutionMap.Create(
                fine,
                coarse,
                incidencePolicy,
                new[] { new ResolutionEdge(0, 1) }),
            "resolution map refuses an explicit edge whose coarse span does not contain its fine span");

        var shorterCoarse = ResolutionView.Create(
            ClaimSelection.Create(coarseBatch, new[] { 0 }),
            new TextSpan(0, 4),
            coarsePolicy);
        Throws<InvalidOperationException>(
            () => ResolutionMap.Create(
                fine,
                shorterCoarse,
                incidencePolicy,
                Array.Empty<ResolutionEdge>()),
            "resolution map refuses unequal declared layer windows");

        var incompatibleMaster = new TextMaster("other-resolution", 0, "abcdef");
        var incompatibleBatch = PairBatch(incompatibleMaster, new TextSpan(0, 6));
        var incompatibleLayer = ResolutionView.Create(
            ClaimSelection.All(incompatibleBatch),
            incompatibleMaster.Extent,
            new ResolutionLayerPolicy("incompatible"));
        Throws<InvalidOperationException>(
            () => ResolutionMap.Create(
                fine,
                incompatibleLayer,
                incidencePolicy,
                Array.Empty<ResolutionEdge>()),
            "resolution map refuses incompatible same-coordinate-looking masters");

        var emptyFine = ResolutionView.Create(
            ClaimSelection.None(fineBatch),
            new TextSpan(3, 3),
            finePolicy);
        var emptyCoarse = ResolutionView.Create(
            ClaimSelection.None(coarseBatch),
            new TextSpan(3, 3),
            coarsePolicy);
        var emptyMap = ResolutionMap.Create(
            emptyFine,
            emptyCoarse,
            ResolutionMapPolicy.ExactAggregation("empty-exact"),
            Array.Empty<ResolutionEdge>());
        True(emptyMap.IsEmpty && ReferenceEquals(emptyMap.Fine, emptyFine) &&
             ReferenceEquals(emptyMap.Coarse, emptyCoarse),
            "empty exact aggregation retains both exact layer objects");

        Throws<ArgumentException>(() => new ResolutionLayerPolicy(" "),
            "resolution layer policy requires a name");
        Throws<ArgumentOutOfRangeException>(
            () => new ResolutionMapPolicy("bad", (ResolutionMapContract)99),
            "resolution map policy refuses an undefined contract");
    }

    /// <summary>
    /// K4c resolution assurance: bounded exact-layer selection and six-edge masks agree with an
    /// endpoint-membership oracle while compatible-but-distinct master objects remain supported.
    /// </summary>
    private static void ResolutionIncidenceMatchesBoundedEndpointOracle()
    {
        var fineMaster = new TextMaster("resolution-bounded", 0, "abcd");
        var coarseMaster = new TextMaster("resolution-bounded", 0, "abcd");
        var fineBatch = PairBatch(
            fineMaster,
            new TextSpan(1, 2),
            new TextSpan(1, 2),
            new TextSpan(1, 2));
        var coarseBatch = PairBatch(
            coarseMaster,
            new TextSpan(0, 3),
            new TextSpan(0, 3));
        var finePolicy = new ResolutionLayerPolicy("bounded-fine");
        var coarsePolicy = new ResolutionLayerPolicy("bounded-coarse");
        var mapPolicy = ResolutionMapPolicy.Incidence("bounded-incidence");
        var problemCount = 0;
        var agreement = true;
        var stampsHold = true;

        for (var fineMask = 0; fineMask < 8; fineMask++)
        {
            var fine = ResolutionView.Create(
                SelectionFromMask(fineBatch, fineMask),
                new TextSpan(0, 3),
                finePolicy);
            for (var coarseMask = 0; coarseMask < 4; coarseMask++)
            {
                var coarse = ResolutionView.Create(
                    SelectionFromMask(coarseBatch, coarseMask),
                    new TextSpan(0, 3),
                    coarsePolicy);
                for (var edgeMask = 0; edgeMask < 64; edgeMask++)
                {
                    problemCount++;
                    var edges = ResolutionEdgesFromMask(edgeMask);
                    ResolutionMap? actual = null;
                    var accepted = ValidationAccepts(() =>
                        actual = ResolutionMap.Create(fine, coarse, mapPolicy, edges));
                    var expected = ResolutionEndpointMaskOracle(fineMask, coarseMask, edgeMask);
                    agreement &= accepted == expected;
                    if (actual is not null)
                    {
                        stampsHold &= ReferenceEquals(actual.Fine, fine) &&
                                      ReferenceEquals(actual.Coarse, coarse) &&
                                      ReferenceEquals(actual.Policy, mapPolicy) &&
                                      actual.SequenceEqual(edges);
                    }
                }
            }
        }

        Equal(2048, problemCount,
            "bounded resolution oracle covers every fine/coarse selection and incidence-edge mask");
        True(agreement,
            "resolution incidence validation agrees with exact endpoint-membership oracle");
        True(stampsHold,
            "every accepted bounded resolution map retains its exact layer and policy objects");
    }

    private static TextSpan[] NonemptyIntervals(int maximumBoundary)
    {
        var intervals = new List<TextSpan>();
        for (var start = 0; start < maximumBoundary; start++)
        {
            for (var end = start + 1; end <= maximumBoundary; end++)
            {
                intervals.Add(new TextSpan(start, end));
            }
        }

        return intervals.ToArray();
    }

    private static bool ValidationAccepts(Action validation)
    {
        try
        {
            validation();
            return true;
        }
        catch (ArgumentException)
        {
            return false;
        }
        catch (InvalidOperationException)
        {
            return false;
        }
    }

    private static bool PackingMaskOracle(SpanBatch batch, int mask)
    {
        for (var left = 0; left < batch.Count; left++)
        {
            if ((mask & (1 << left)) == 0)
            {
                continue;
            }

            var a = batch[left].Span;
            for (var right = left + 1; right < batch.Count; right++)
            {
                if ((mask & (1 << right)) == 0)
                {
                    continue;
                }

                var b = batch[right].Span;
                if (!(a.End <= b.Start || b.End <= a.Start))
                {
                    return false;
                }
            }
        }

        return true;
    }

    private static bool CoverMaskOracle(SpanBatch batch, int mask, TextSpan window)
    {
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            if ((mask & (1 << ordinal)) != 0 && !window.Contains(batch[ordinal].Span))
            {
                return false;
            }
        }

        for (var position = window.Start; position < window.End; position++)
        {
            var covered = false;
            for (var ordinal = 0; ordinal < batch.Count; ordinal++)
            {
                var span = batch[ordinal].Span;
                if ((mask & (1 << ordinal)) != 0 &&
                    span.Start <= position && position < span.End)
                {
                    covered = true;
                    break;
                }
            }

            if (!covered)
            {
                return false;
            }
        }

        return true;
    }

    private static bool LaminarMaskOracle(SpanBatch batch, int mask)
    {
        for (var left = 0; left < batch.Count; left++)
        {
            if ((mask & (1 << left)) == 0)
            {
                continue;
            }

            var a = batch[left].Span;
            for (var right = left + 1; right < batch.Count; right++)
            {
                if ((mask & (1 << right)) == 0)
                {
                    continue;
                }

                var b = batch[right].Span;
                var alternating =
                    (a.Start < b.Start && b.Start < a.End && a.End < b.End) ||
                    (b.Start < a.Start && a.Start < b.End && b.End < a.End);
                if (alternating)
                {
                    return false;
                }
            }
        }

        return true;
    }

    private static int LaminarAdmissionMaskOracle(SpanBatch batch, int candidateMask)
    {
        var groups = Enumerable.Range(0, batch.Count)
            .Where(ordinal => (candidateMask & (1 << ordinal)) != 0)
            .GroupBy(ordinal => batch[ordinal].Span)
            .Select(group => new
            {
                Span = group.Key,
                Ordinals = group.OrderBy(ordinal => ordinal).ToArray(),
                Priority = group.Max(ordinal => batch[ordinal].Priority),
            })
            .OrderByDescending(group => group.Priority)
            .ThenBy(group => group.Span.Start)
            .ThenByDescending(group => group.Span.End)
            .ThenBy(group => group.Ordinals[0])
            .ToArray();
        var acceptedSpans = new List<TextSpan>();
        var acceptedMask = 0;
        foreach (var group in groups)
        {
            var crosses = false;
            foreach (var accepted in acceptedSpans)
            {
                var alternating =
                    (group.Span.Start < accepted.Start &&
                     accepted.Start < group.Span.End &&
                     group.Span.End < accepted.End) ||
                    (accepted.Start < group.Span.Start &&
                     group.Span.Start < accepted.End &&
                     accepted.End < group.Span.End);
                crosses |= alternating;
            }

            if (crosses)
            {
                continue;
            }

            acceptedSpans.Add(group.Span);
            foreach (var ordinal in group.Ordinals)
            {
                acceptedMask |= 1 << ordinal;
            }
        }

        return acceptedMask;
    }

    private static bool LaminarAdmissionIsMaximalOracle(
        SpanBatch batch,
        int acceptedMask,
        int rejectedMask)
    {
        for (var rejected = 0; rejected < batch.Count; rejected++)
        {
            if ((rejectedMask & (1 << rejected)) == 0)
            {
                continue;
            }

            var blocked = false;
            var rejectedSpan = batch[rejected].Span;
            for (var accepted = 0; accepted < batch.Count; accepted++)
            {
                if ((acceptedMask & (1 << accepted)) == 0)
                {
                    continue;
                }

                var acceptedSpan = batch[accepted].Span;
                blocked |=
                    (rejectedSpan.Start < acceptedSpan.Start &&
                     acceptedSpan.Start < rejectedSpan.End &&
                     rejectedSpan.End < acceptedSpan.End) ||
                    (acceptedSpan.Start < rejectedSpan.Start &&
                     rejectedSpan.Start < acceptedSpan.End &&
                     acceptedSpan.End < rejectedSpan.End);
            }

            if (!blocked)
            {
                return false;
            }
        }

        return true;
    }

    private static IReadOnlyList<HierarchyEdge> NearestContainerOracle(
        SpanBatch batch,
        int mask,
        string derivation)
    {
        var groups = Enumerable.Range(0, batch.Count)
            .Where(ordinal => (mask & (1 << ordinal)) != 0)
            .GroupBy(ordinal => batch[ordinal].Span)
            .Select(group => new
            {
                Span = group.Key,
                Ordinals = group.OrderBy(ordinal => ordinal).ToArray(),
            })
            .ToArray();
        var edges = new List<HierarchyEdge>();
        foreach (var child in groups)
        {
            var parent = groups
                .Where(candidate => candidate.Span.Contains(child.Span) &&
                                    candidate.Span != child.Span)
                .OrderBy(candidate => candidate.Span.Length)
                .ThenBy(candidate => candidate.Span.Start)
                .ThenBy(candidate => candidate.Ordinals[0])
                .FirstOrDefault();
            if (parent is null)
            {
                continue;
            }

            foreach (var childOrdinal in child.Ordinals)
            {
                edges.Add(new HierarchyEdge(
                    childOrdinal,
                    parent.Ordinals[0],
                    derivation));
            }
        }

        return edges
            .OrderBy(edge => edge.ChildOrdinal)
            .ThenBy(edge => edge.ParentOrdinal)
            .ToArray();
    }

    private static bool DirectedAcyclicOracle(
        int nodeCount,
        IReadOnlyList<(int Child, int Parent)> possibleEdges,
        int mask)
    {
        var reachable = new bool[nodeCount, nodeCount];
        for (var edgeIndex = 0; edgeIndex < possibleEdges.Count; edgeIndex++)
        {
            if ((mask & (1 << edgeIndex)) != 0)
            {
                var edge = possibleEdges[edgeIndex];
                reachable[edge.Child, edge.Parent] = true;
            }
        }

        for (var middle = 0; middle < nodeCount; middle++)
        {
            for (var start = 0; start < nodeCount; start++)
            {
                for (var end = 0; end < nodeCount; end++)
                {
                    reachable[start, end] |= reachable[start, middle] && reachable[middle, end];
                }
            }
        }

        for (var node = 0; node < nodeCount; node++)
        {
            if (reachable[node, node])
            {
                return false;
            }
        }

        return true;
    }

    private static IReadOnlyList<ResolutionEdge> ResolutionEdgesFromMask(int mask)
    {
        var edges = new List<ResolutionEdge>();
        for (var fine = 0; fine < 3; fine++)
        {
            for (var coarse = 0; coarse < 2; coarse++)
            {
                var edgeIndex = (fine * 2) + coarse;
                if ((mask & (1 << edgeIndex)) != 0)
                {
                    edges.Add(new ResolutionEdge(fine, coarse));
                }
            }
        }

        return edges;
    }

    private static bool ResolutionEndpointMaskOracle(
        int fineSelectionMask,
        int coarseSelectionMask,
        int edgeMask)
    {
        for (var fine = 0; fine < 3; fine++)
        {
            for (var coarse = 0; coarse < 2; coarse++)
            {
                var edgeIndex = (fine * 2) + coarse;
                if ((edgeMask & (1 << edgeIndex)) == 0)
                {
                    continue;
                }

                if ((fineSelectionMask & (1 << fine)) == 0 ||
                    (coarseSelectionMask & (1 << coarse)) == 0)
                {
                    return false;
                }
            }
        }

        return true;
    }

    private static LocatedRelation LocatedFromMask(
        TextMaster master,
        TextSpan window,
        IReadOnlyList<TextSpan> extents,
        int mask)
    {
        var selected = new List<TextSpan>();
        for (var index = 0; index < extents.Count; index++)
        {
            if ((mask & (1 << index)) != 0)
            {
                selected.Add(extents[index]);
            }
        }

        return LocatedRelation.Create(master, window, selected);
    }

    private static int LocatedMask(
        LocatedRelation relation,
        IReadOnlyList<TextSpan> extents)
    {
        var mask = 0;
        foreach (var edge in relation)
        {
            var index = -1;
            for (var candidate = 0; candidate < extents.Count; candidate++)
            {
                if (extents[candidate] == edge)
                {
                    index = candidate;
                    break;
                }
            }

            if (index < 0)
            {
                throw new InvalidOperationException($"Oracle extent inventory omitted {edge}.");
            }

            mask |= 1 << index;
        }

        return mask;
    }

    private static int LocatedSeqOracleMask(
        int leftMask,
        int rightMask,
        IReadOnlyList<TextSpan> extents)
    {
        var result = 0;
        for (var left = 0; left < extents.Count; left++)
        {
            if ((leftMask & (1 << left)) == 0)
            {
                continue;
            }

            for (var right = 0; right < extents.Count; right++)
            {
                if ((rightMask & (1 << right)) == 0 ||
                    extents[left].End != extents[right].Start)
                {
                    continue;
                }

                var composed = new TextSpan(extents[left].Start, extents[right].End);
                for (var output = 0; output < extents.Count; output++)
                {
                    if (extents[output] == composed)
                    {
                        result |= 1 << output;
                        break;
                    }
                }
            }
        }

        return result;
    }

    private static int LocatedReachabilityOracleMask(
        int relationMask,
        IReadOnlyList<int> boundaries,
        IReadOnlyList<TextSpan> extents)
    {
        var reachable = new bool[boundaries.Count, boundaries.Count];
        for (var edge = 0; edge < extents.Count; edge++)
        {
            if ((relationMask & (1 << edge)) == 0 || extents[edge].IsEmpty)
            {
                continue;
            }

            var start = -1;
            var end = -1;
            for (var boundary = 0; boundary < boundaries.Count; boundary++)
            {
                if (boundaries[boundary] == extents[edge].Start)
                {
                    start = boundary;
                }

                if (boundaries[boundary] == extents[edge].End)
                {
                    end = boundary;
                }
            }

            reachable[start, end] = true;
        }

        for (var boundary = 0; boundary < boundaries.Count; boundary++)
        {
            reachable[boundary, boundary] = true;
        }

        for (var middle = 0; middle < boundaries.Count; middle++)
        {
            for (var start = 0; start < boundaries.Count; start++)
            {
                for (var end = 0; end < boundaries.Count; end++)
                {
                    reachable[start, end] |=
                        reachable[start, middle] && reachable[middle, end];
                }
            }
        }

        var result = 0;
        for (var edge = 0; edge < extents.Count; edge++)
        {
            var start = -1;
            var end = -1;
            for (var boundary = 0; boundary < boundaries.Count; boundary++)
            {
                if (boundaries[boundary] == extents[edge].Start)
                {
                    start = boundary;
                }

                if (boundaries[boundary] == extents[edge].End)
                {
                    end = boundary;
                }
            }

            if (reachable[start, end])
            {
                result |= 1 << edge;
            }
        }

        return result;
    }

    private static HashSet<(int Start, int End)> ComposePointRelations(
        IEnumerable<(int Start, int End)> left,
        IEnumerable<(int Start, int End)> right)
    {
        var result = new HashSet<(int Start, int End)>();
        foreach (var leftEdge in left)
        {
            foreach (var rightEdge in right)
            {
                if (leftEdge.End == rightEdge.Start)
                {
                    result.Add((leftEdge.Start, rightEdge.End));
                }
            }
        }

        return result;
    }

    private static HashSet<(int Start, int End)> ImagePointRelation(
        IEnumerable<(int Start, int End)> relation,
        IReadOnlyList<int> pointImage)
    {
        var result = new HashSet<(int Start, int End)>();
        foreach (var edge in relation)
        {
            result.Add((pointImage[edge.Start], pointImage[edge.End]));
        }

        return result;
    }

    private static List<int[]> SegmentationPathOracle(
        SpanBatch batch,
        int mask,
        TextSpan window)
    {
        var paths = new List<int[]>();
        var path = new List<int>();
        if (window.IsEmpty)
        {
            paths.Add(Array.Empty<int>());
            return paths;
        }

        void EnumerateFrom(int boundary)
        {
            for (var ordinal = 0; ordinal < batch.Count; ordinal++)
            {
                if ((mask & (1 << ordinal)) == 0)
                {
                    continue;
                }

                var edge = batch[ordinal].Span;
                if (edge.Start != boundary)
                {
                    continue;
                }

                path.Add(ordinal);
                if (edge.End == window.End)
                {
                    paths.Add(path.ToArray());
                }
                else if (edge.End < window.End)
                {
                    EnumerateFrom(edge.End);
                }

                path.RemoveAt(path.Count - 1);
            }
        }

        EnumerateFrom(window.Start);
        paths.Sort(static (left, right) =>
        {
            var shared = Math.Min(left.Length, right.Length);
            for (var index = 0; index < shared; index++)
            {
                var comparison = left[index].CompareTo(right[index]);
                if (comparison != 0)
                {
                    return comparison;
                }
            }

            return left.Length.CompareTo(right.Length);
        });
        return paths;
    }

    private static PathCostOracleResult? MinimumCostPathOracle(
        IEnumerable<int[]> paths,
        int binaryCostMask)
    {
        PathCostOracleResult? best = null;
        foreach (var path in paths)
        {
            long score = 0;
            foreach (var ordinal in path)
            {
                score += (binaryCostMask >> ordinal) & 1;
            }

            if (best is null ||
                score < best.Score ||
                (score == best.Score && CompareOrdinalPaths(path, best.Path) < 0))
            {
                best = new PathCostOracleResult(path, score);
            }
        }

        return best;
    }

    private static int CompareOrdinalPaths(
        IReadOnlyList<int> left,
        IReadOnlyList<int> right)
    {
        var shared = Math.Min(left.Count, right.Count);
        for (var index = 0; index < shared; index++)
        {
            var comparison = left[index].CompareTo(right[index]);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        return left.Count.CompareTo(right.Count);
    }

    private static bool SegmentationCanReachOracle(
        SpanBatch batch,
        int mask,
        int start,
        int end)
    {
        if (start == end)
        {
            return true;
        }

        var visited = new HashSet<int> { start };
        var pending = new Stack<int>();
        pending.Push(start);
        while (pending.Count > 0)
        {
            var boundary = pending.Pop();
            for (var ordinal = 0; ordinal < batch.Count; ordinal++)
            {
                if ((mask & (1 << ordinal)) == 0)
                {
                    continue;
                }

                var edge = batch[ordinal].Span;
                if (edge.Start != boundary)
                {
                    continue;
                }

                if (edge.End == end)
                {
                    return true;
                }

                if (edge.End < end && visited.Add(edge.End))
                {
                    pending.Push(edge.End);
                }
            }
        }

        return false;
    }

    private static bool SegmentationPathIsCompleteOracle(
        SpanBatch batch,
        int mask,
        TextSpan window,
        IReadOnlyList<int> path)
    {
        if (window.IsEmpty)
        {
            return path.Count == 0;
        }

        var cursor = window.Start;
        var seen = new HashSet<int>();
        foreach (var ordinal in path)
        {
            if ((uint)ordinal >= (uint)batch.Count ||
                (mask & (1 << ordinal)) == 0 ||
                !seen.Add(ordinal))
            {
                return false;
            }

            var edge = batch[ordinal].Span;
            if (edge.Start != cursor)
            {
                return false;
            }

            cursor = edge.End;
        }

        return cursor == window.End;
    }

    private static IReadOnlyList<TextSpan> SegmentationGapOracle(
        SpanBatch batch,
        int mask,
        TextSpan window)
    {
        var covered = new bool[window.Length];
        for (var ordinal = 0; ordinal < batch.Count; ordinal++)
        {
            if ((mask & (1 << ordinal)) == 0)
            {
                continue;
            }

            var edge = batch[ordinal].Span;
            for (var offset = edge.Start; offset < edge.End; offset++)
            {
                covered[offset - window.Start] = true;
            }
        }

        var gaps = new List<TextSpan>();
        var index = 0;
        while (index < covered.Length)
        {
            if (covered[index])
            {
                index++;
                continue;
            }

            var start = index;
            while (index < covered.Length && !covered[index])
            {
                index++;
            }

            gaps.Add(new TextSpan(window.Start + start, window.Start + index));
        }

        return gaps;
    }

    private static SpanBatch PairBatch(TextMaster master, params TextSpan[] spans)
    {
        var builder = new SpanBatchBuilder(master);
        for (var ordinal = 0; ordinal < spans.Length; ordinal++)
        {
            builder.Add(new SpanClaim(
                spans[ordinal],
                $"pair-{ordinal}",
                SpanLevel.Character,
                "pair-test"));
        }

        return builder.Freeze();
    }

    private static SpanBatch PairingBatch(
        TextMaster master,
        params (TextSpan Span, string Role, string? Key)[] tokens)
    {
        var builder = new SpanBatchBuilder(master);
        foreach (var token in tokens)
        {
            builder.Add(new SpanClaim(
                token.Span,
                token.Role,
                SpanLevel.Character,
                "pairing-test",
                RuleId: token.Key));
        }

        return builder.Freeze();
    }

    private static PairingOracleResult PairingOracle(
        IReadOnlyList<PairingOracleToken> tokens)
    {
        var stack = new Stack<(int Ordinal, string Key)>();
        var matches = new SortedSet<(int LeftOrdinal, int RightOrdinal)>();
        var mismatches = new SortedSet<(int LeftOrdinal, int RightOrdinal)>();
        var dangling = new SortedSet<int>();

        for (var ordinal = 0; ordinal < tokens.Count; ordinal++)
        {
            var token = tokens[ordinal];
            if (token.IsOpen)
            {
                stack.Push((ordinal, token.Key));
            }
            else if (stack.Count == 0)
            {
                dangling.Add(ordinal);
            }
            else
            {
                var opener = stack.Pop();
                if (StringComparer.Ordinal.Equals(opener.Key, token.Key))
                {
                    matches.Add((opener.Ordinal, ordinal));
                }
                else
                {
                    mismatches.Add((opener.Ordinal, ordinal));
                }
            }
        }

        var unclosed = new SortedSet<int>();
        while (stack.Count > 0)
        {
            unclosed.Add(stack.Pop().Ordinal);
        }

        return new PairingOracleResult(matches, mismatches, unclosed, dangling);
    }

    private static bool PairingResultMatchesOracle(
        PairingResult actual,
        PairingOracleResult expected) =>
        PairViewMatchesKeys(actual.MatchEdges, expected.Matches) &&
        PairViewMatchesKeys(actual.Faults.MismatchedPairs, expected.Mismatches) &&
        actual.Faults.UnclosedOpens.SequenceEqual(expected.UnclosedOpens) &&
        actual.Faults.DanglingCloses.SequenceEqual(expected.DanglingCloses);

    private static bool PairingResultObeysLaws(
        PairingResult result,
        ClaimSelection opens,
        ClaimSelection closes,
        PairingPolicy policy)
    {
        if (!ReferenceEquals(result.OpenInput, opens) ||
            !ReferenceEquals(result.CloseInput, closes) ||
            !ReferenceEquals(result.Policy, policy) ||
            !ReferenceEquals(result.MatchEdges.LeftBasis, opens.Basis) ||
            !ReferenceEquals(result.MatchEdges.RightBasis, closes.Basis) ||
            !ReferenceEquals(result.Faults.MismatchedPairs.LeftBasis, opens.Basis) ||
            !ReferenceEquals(result.Faults.MismatchedPairs.RightBasis, closes.Basis))
        {
            return false;
        }

        var matchedOpens = result.MatchEdges.ProjectLeft();
        var matchedCloses = result.MatchEdges.ProjectRight();
        if (!matchedOpens.Intersect(result.Faults.OpenResidue).IsEmpty ||
            !matchedCloses.Intersect(result.Faults.CloseResidue).IsEmpty ||
            !matchedOpens.Union(result.Faults.OpenResidue).Equals(opens) ||
            !matchedCloses.Union(result.Faults.CloseResidue).Equals(closes) ||
            !result.Faults.UnclosedOpens.Intersect(result.Faults.MismatchedOpens).IsEmpty ||
            !result.Faults.DanglingCloses.Intersect(result.Faults.MismatchedCloses).IsEmpty ||
            !result.Faults.UnclosedOpens.Union(result.Faults.MismatchedOpens)
                .Equals(result.Faults.OpenResidue) ||
            !result.Faults.DanglingCloses.Union(result.Faults.MismatchedCloses)
                .Equals(result.Faults.CloseResidue) ||
            !result.Faults.MismatchedOpens.Equals(
                result.Faults.MismatchedPairs.ProjectLeft()) ||
            !result.Faults.MismatchedCloses.Equals(
                result.Faults.MismatchedPairs.ProjectRight()) ||
            result.Faults.IsEmpty !=
                (result.Faults.OpenResidue.IsEmpty && result.Faults.CloseResidue.IsEmpty))
        {
            return false;
        }

        var leftEndpoints = new HashSet<int>();
        var rightEndpoints = new HashSet<int>();
        var edges = result.MatchEdges.ToArray();
        foreach (var edge in edges)
        {
            var opener = opens.Basis[edge.LeftOrdinal];
            var closer = closes.Basis[edge.RightOrdinal];
            if (!leftEndpoints.Add(edge.LeftOrdinal) ||
                !rightEndpoints.Add(edge.RightOrdinal) ||
                opener.Span.End > closer.Span.Start ||
                !policy.IsCompatible(opener, closer))
            {
                return false;
            }
        }

        foreach (var mismatch in result.Faults.MismatchedPairs)
        {
            if (policy.IsCompatible(
                opens.Basis[mismatch.LeftOrdinal],
                closes.Basis[mismatch.RightOrdinal]))
            {
                return false;
            }
        }

        for (var first = 0; first < edges.Length; first++)
        {
            var firstOpen = opens.Basis[edges[first].LeftOrdinal].Span.Start;
            var firstClose = closes.Basis[edges[first].RightOrdinal].Span.Start;
            for (var second = first + 1; second < edges.Length; second++)
            {
                var secondOpen = opens.Basis[edges[second].LeftOrdinal].Span.Start;
                var secondClose = closes.Basis[edges[second].RightOrdinal].Span.Start;
                if ((firstOpen < secondOpen &&
                        secondOpen < firstClose &&
                        firstClose < secondClose) ||
                    (secondOpen < firstOpen &&
                        firstOpen < secondClose &&
                        secondClose < firstClose))
                {
                    return false;
                }
            }
        }

        return true;
    }

    private readonly record struct PairingOracleToken(bool IsOpen, string Key);

    private sealed record PathCostOracleResult(int[] Path, long Score);

    private sealed record PairingOracleResult(
        IReadOnlyCollection<(int LeftOrdinal, int RightOrdinal)> Matches,
        IReadOnlyCollection<(int LeftOrdinal, int RightOrdinal)> Mismatches,
        IReadOnlyCollection<int> UnclosedOpens,
        IReadOnlyCollection<int> DanglingCloses);

    private static ClaimPairView PairViewFromMask(
        SpanBatch leftBasis,
        SpanBatch rightBasis,
        int mask)
    {
        var pairs = new List<(int LeftOrdinal, int RightOrdinal)>();
        for (var left = 0; left < leftBasis.Count; left++)
        {
            for (var right = 0; right < rightBasis.Count; right++)
            {
                var bit = (left * rightBasis.Count) + right;
                if ((mask & (1 << bit)) != 0)
                {
                    pairs.Add((left, right));
                }
            }
        }

        return ClaimPairView.Create(leftBasis, rightBasis, pairs);
    }

    private static string PairKeys(IEnumerable<ClaimPair> pairs) =>
        string.Join(",", pairs.Select(pair => $"{pair.LeftOrdinal}:{pair.RightOrdinal}"));

    private static bool PairViewMatchesKeys(
        ClaimPairView view,
        IEnumerable<(int LeftOrdinal, int RightOrdinal)> expected)
    {
        var remaining = new HashSet<(int LeftOrdinal, int RightOrdinal)>(expected);
        if (remaining.Count != view.Count)
        {
            return false;
        }

        var hasPrevious = false;
        var previousLeft = 0;
        var previousRight = 0;
        foreach (var pair in view)
        {
            if (!remaining.Remove((pair.LeftOrdinal, pair.RightOrdinal)))
            {
                return false;
            }

            if (hasPrevious &&
                (pair.LeftOrdinal < previousLeft ||
                 (pair.LeftOrdinal == previousLeft && pair.RightOrdinal <= previousRight)))
            {
                return false;
            }

            if (pair.Relation != AllenAlgebra.Relate(
                    view.LeftBasis[pair.LeftOrdinal].Span,
                    view.RightBasis[pair.RightOrdinal].Span))
            {
                return false;
            }

            hasPrevious = true;
            previousLeft = pair.LeftOrdinal;
            previousRight = pair.RightOrdinal;
        }

        return remaining.Count == 0;
    }

    private static HashSet<(int LeftOrdinal, int RightOrdinal)> ComposePairOracle(
        ClaimPairView left,
        ClaimPairView right)
    {
        var result = new HashSet<(int LeftOrdinal, int RightOrdinal)>();
        foreach (var leftPair in left)
        {
            foreach (var rightPair in right)
            {
                if (leftPair.RightOrdinal == rightPair.LeftOrdinal)
                {
                    result.Add((leftPair.LeftOrdinal, rightPair.RightOrdinal));
                }
            }
        }

        return result;
    }

    private static bool WitnessViewMatchesOracle(
        ClaimPairWitnessView witnesses,
        ClaimPairView left,
        ClaimPairView right)
    {
        if (!ReferenceEquals(witnesses.LeftBasis, left.LeftBasis) ||
            !ReferenceEquals(witnesses.MiddleBasis, left.RightBasis) ||
            !ReferenceEquals(witnesses.MiddleBasis, right.LeftBasis) ||
            !ReferenceEquals(witnesses.RightBasis, right.RightBasis))
        {
            return false;
        }

        var expected = new SortedDictionary<
            (int LeftOrdinal, int RightOrdinal),
            SortedSet<int>>();
        foreach (var leftPair in left)
        {
            foreach (var rightPair in right)
            {
                if (leftPair.RightOrdinal != rightPair.LeftOrdinal)
                {
                    continue;
                }

                var key = (leftPair.LeftOrdinal, rightPair.RightOrdinal);
                if (!expected.TryGetValue(key, out var middles))
                {
                    middles = new SortedSet<int>();
                    expected.Add(key, middles);
                }

                middles.Add(leftPair.RightOrdinal);
            }
        }

        if (expected.Count != witnesses.Count)
        {
            return false;
        }

        var index = 0;
        foreach (var entry in expected)
        {
            var actual = witnesses[index++];
            if (actual.LeftOrdinal != entry.Key.LeftOrdinal ||
                actual.RightOrdinal != entry.Key.RightOrdinal ||
                !actual.MiddleOrdinals.SequenceEqual(entry.Value))
            {
                return false;
            }
        }

        return true;
    }

    private static AllenRelationSet AllenImageOracle(ClaimPairView view)
    {
        var relations = new List<AllenRelation>();
        foreach (var pair in view)
        {
            relations.Add(AllenAlgebra.Relate(
                view.LeftBasis[pair.LeftOrdinal].Span,
                view.RightBasis[pair.RightOrdinal].Span));
        }

        return AllenRelationSet.Create(relations);
    }

    private static ClaimSelection SelectionFromMask(SpanBatch batch, int mask) =>
        ClaimSelection.Create(
            batch,
            Enumerable.Range(0, batch.Count).Where(ordinal => (mask & (1 << ordinal)) != 0));

    private static bool SelectionMatchesMask(ClaimSelection selection, int mask)
    {
        var expectedOrdinal = 0;
        foreach (var ordinal in selection)
        {
            while (expectedOrdinal < selection.Basis.Count && (mask & (1 << expectedOrdinal)) == 0)
            {
                expectedOrdinal++;
            }

            if (ordinal != expectedOrdinal)
            {
                return false;
            }

            expectedOrdinal++;
        }

        for (var ordinal = 0; ordinal < selection.Basis.Count; ordinal++)
        {
            if (selection.Contains(ordinal) != ((mask & (1 << ordinal)) != 0))
            {
                return false;
            }
        }

        return selection.Count == CountSetBits(mask);
    }

    private static void FactKeyIsAMasterRelativeSemanticValue()
    {
        Throws<ArgumentException>(
            () => new FactKey(" ", "Parent", Array.Empty<TextSpan>(), Array.Empty<string>()),
            "fact domain required");
        Throws<ArgumentException>(
            () => new FactKey("hier", "", Array.Empty<TextSpan>(), Array.Empty<string>()),
            "fact kind required");
        Throws<ArgumentNullException>(
            () => new FactKey("hier", "Parent", null!, Array.Empty<string>()),
            "geometry sequence required");
        Throws<ArgumentNullException>(
            () => new FactKey("hier", "Parent", Array.Empty<TextSpan>(), null!),
            "value sequence required");
        Throws<ArgumentException>(
            () => new FactKey("hier", "Parent", Array.Empty<TextSpan>(), new string[] { null! }),
            "null value component rejected");

        var geometry = new List<TextSpan> { new(1, 2), new(0, 3) };
        var values = new List<string> { "x", "y" };
        var key = new FactKey("hier", "Parent", geometry, values);
        geometry[0] = new TextSpan(3, 4);
        values[0] = "mutated";
        Equal(new TextSpan(1, 2), key.Geometry[0], "geometry tuple snapshotted");
        Equal("x", key.ValueKey[0], "value tuple snapshotted");

        var same = new FactKey(
            "hier",
            "Parent",
            new[] { new TextSpan(1, 2), new TextSpan(0, 3) },
            new[] { "x", "y" });
        True(key.Equals(same), "fact key value equality");
        Equal(key.GetHashCode(), same.GetHashCode(), "fact key hash agreement");

        var distinctions = new[]
        {
            new FactKey("hier2", "Parent", key.Geometry, key.ValueKey),
            new FactKey("hier", "Ancestor", key.Geometry, key.ValueKey),
            new FactKey("hier", "Parent", new[] { new TextSpan(1, 2) }, key.ValueKey),
            new FactKey(
                "hier", "Parent", new[] { new TextSpan(0, 3), new TextSpan(1, 2) }, key.ValueKey),
            new FactKey(
                "hier", "Parent", new[] { new TextSpan(1, 3), new TextSpan(0, 3) }, key.ValueKey),
            new FactKey("hier", "Parent", key.Geometry, new[] { "x" }),
            new FactKey("hier", "Parent", key.Geometry, new[] { "x", "z" }),
            new FactKey("hier", "Parent", key.Geometry, Array.Empty<string>()),
        };
        for (var i = 0; i < distinctions.Length; i++)
        {
            True(!key.Equals(distinctions[i]), $"fact key distinction {i} is semantic");
        }

        var global = new FactKey("doc", "word-count", Array.Empty<TextSpan>(), new[] { "4" });
        Equal(0, global.Geometry.Count, "zero-geometry master-global key");
        var unit = new FactKey("doc", "seen", new[] { new TextSpan(2, 2) }, Array.Empty<string>());
        Equal(0, unit.ValueKey.Count, "empty tuple is the unit value key");
        True(!global.Equals(unit), "empty tuples still distinguish");
        True(!key.Equals(null), "null fact key inequality");
    }

    private static void CanonicalFactTableCollapsesAndOrdersProposals()
    {
        var master = new TextMaster("facts", 0, "wxyz");
        var a = new TextSpan(1, 2);
        var b = new TextSpan(0, 3);
        var d = new TextSpan(0, 4);

        FactKey Parent(TextSpan child, TextSpan parent) =>
            new("hier", "Parent", new[] { child, parent }, Array.Empty<string>());

        var empty = CanonicalFactTable.Create(master, Array.Empty<FactKey>());
        True(empty.IsEmpty, "empty fact table");
        Equal(0, empty.Count, "empty fact table count");

        var table = CanonicalFactTable.Create(master, new[]
        {
            Parent(a, b),
            Parent(b, d),
            Parent(a, b),
            new FactKey("hier", "Ancestor", new[] { a, d }, Array.Empty<string>()),
            new FactKey("doc", "word-count", Array.Empty<TextSpan>(), new[] { "4" }),
            new FactKey("hier", "boundary", new[] { new TextSpan(2, 2) }, Array.Empty<string>()),
        });
        Equal(5, table.Count, "duplicate fact proposals collapse");
        Equal("word-count", table[0].Kind, "domain-major canonical order");
        Equal("Ancestor", table[1].Kind, "ordinal kind order within one domain");
        Equal(new TextSpan(0, 3), table[2].Geometry[0], "geometry coordinate order");
        Equal(new TextSpan(1, 2), table[3].Geometry[0], "geometry coordinate order continued");
        Equal("boundary", table[4].Kind, "ordinal kind order is case-sensitive");

        True(table.TryGetOrdinal(Parent(a, b), out var parentOrdinal), "value-equal key found");
        Equal(3, parentOrdinal, "found ordinal addresses the canonical row");
        True(!table.TryGetOrdinal(Parent(d, a), out _), "absent key not found");
        Throws<ArgumentOutOfRangeException>(() => _ = table[5], "fact ordinal range validated");

        var widened = CanonicalFactTable.Create(master, new[]
        {
            Parent(a, b),
            new FactKey("aaa", "first", Array.Empty<TextSpan>(), Array.Empty<string>()),
        });
        True(widened.TryGetOrdinal(Parent(a, b), out var shifted), "widened table retains the key");
        Equal(1, shifted, "unrelated facts shift table-local ordinals");

        Throws<ArgumentOutOfRangeException>(
            () => CanonicalFactTable.Create(
                master,
                new[]
                {
                    new FactKey(
                        "hier", "Parent", new[] { new TextSpan(0, 5) }, Array.Empty<string>()),
                }),
            "geometry beyond the master refused");
        var smp = new TextMaster("smp", 0, "a😀b");
        Throws<ArgumentException>(
            () => CanonicalFactTable.Create(
                smp,
                new[]
                {
                    new FactKey(
                        "hier", "mark", new[] { new TextSpan(2, 2) }, Array.Empty<string>()),
                }),
            "surrogate-splitting boundary fact refused");
        Throws<ArgumentException>(
            () => CanonicalFactTable.Create(master, new FactKey[] { null! }),
            "null fact proposal refused");
        Throws<ArgumentNullException>(
            () => CanonicalFactTable.Create(null!, Array.Empty<FactKey>()),
            "fact table master required");

        var proposals = new List<FactKey> { Parent(a, b) };
        var snapshotted = CanonicalFactTable.Create(master, proposals);
        proposals.Clear();
        Equal(1, snapshotted.Count, "proposal sequence snapshotted");
    }

    private static void CanonicalFactTableEqualityIsProposalOrderIndependent()
    {
        var master = new TextMaster("facts", 0, "wxyz");
        var proposals = new FactKey[]
        {
            new(
                "hier",
                "Parent",
                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },
                Array.Empty<string>()),
            new(
                "hier",
                "Parent",
                new[] { new TextSpan(0, 3), new TextSpan(0, 4) },
                Array.Empty<string>()),
            new(
                "hier",
                "Ancestor",
                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },
                Array.Empty<string>()),
            new("doc", "word-count", Array.Empty<TextSpan>(), new[] { "4" }),
            new(
                "hier",
                "Parent",
                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },
                Array.Empty<string>()),
        };

        var reference = CanonicalFactTable.Create(master, proposals);
        Equal(4, reference.Count, "reference table collapses the duplicate proposal");

        var total = 0;
        var agreeing = 0;
        foreach (var permutation in Permutations(proposals.Length))
        {
            total++;
            var permuted = new FactKey[proposals.Length];
            for (var i = 0; i < permutation.Length; i++)
            {
                permuted[i] = proposals[permutation[i]];
            }

            var table = CanonicalFactTable.Create(master, permuted);
            if (reference.Equals(table) &&
                table.Equals(reference) &&
                reference.GetHashCode() == table.GetHashCode())
            {
                agreeing++;
            }
        }

        Equal(120, total, "proposal permutation census");
        Equal(total, agreeing, "canonical value is proposal-order independent");

        var compatible = CanonicalFactTable.Create(new TextMaster("facts", 0, "wxyz"), proposals);
        True(reference.Equals(compatible), "compatible-master tables are value-equal");
        Equal(reference.GetHashCode(), compatible.GetHashCode(), "compatible-master hash agreement");

        var otherText = CanonicalFactTable.Create(new TextMaster("facts", 0, "wxyA"), proposals);
        True(!reference.Equals(otherText), "incompatible master text breaks equality");
        var otherRevision = CanonicalFactTable.Create(new TextMaster("facts", 1, "wxyz"), proposals);
        True(!reference.Equals(otherRevision), "incompatible revision breaks equality");
        var fewer = CanonicalFactTable.Create(master, new[] { proposals[0] });
        True(!reference.Equals(fewer), "different key populations differ");
        True(!reference.Equals(null), "null table inequality");
    }

    private static void FactReferenceIsAnExactTableHandle()
    {
        var master = new TextMaster("facts", 0, "wxyz");
        var proposals = new FactKey[]
        {
            new(
                "hier",
                "Ancestor",
                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },
                Array.Empty<string>()),
            new(
                "hier",
                "Parent",
                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },
                Array.Empty<string>()),
        };
        var table = CanonicalFactTable.Create(master, proposals);
        var twin = CanonicalFactTable.Create(master, proposals);
        True(table.Equals(twin), "twin tables are value-equal");

        Throws<ArgumentNullException>(
            () => new FactReference(null!, 0), "fact reference requires a table");
        Throws<ArgumentOutOfRangeException>(
            () => new FactReference(table, 2), "fact reference ordinal validated");
        Throws<ArgumentOutOfRangeException>(
            () => new FactReference(CanonicalFactTable.Create(master, Array.Empty<FactKey>()), 0),
            "empty table admits no reference");

        var reference = new FactReference(table, 0);
        True(reference.Key.Equals(table[0]), "key projection returns semantic identity");
        True(reference == new FactReference(table, 0), "same exact table and ordinal are one handle");
        True(reference != new FactReference(table, 1), "different ordinals differ");
        True(reference != new FactReference(twin, 0), "value-equal tables do not share references");
        True(
            reference.Key.Equals(new FactReference(twin, 0).Key),
            "twin reference projections agree semantically");
        Throws<InvalidOperationException>(
            () => _ = default(FactReference).Table, "uninitialized fact reference refuses use");
    }

    private static void SupportEdgeIsAnOrderedEvidenceValue()
    {
        Throws<ArgumentOutOfRangeException>(
            () => new SupportEdge(
                -1, "rule", Array.Empty<int>(), Array.Empty<string>(), Array.Empty<int>()),
            "conclusion ordinal must be non-negative");
        Throws<ArgumentException>(
            () => new SupportEdge(
                0, " ", Array.Empty<int>(), Array.Empty<string>(), Array.Empty<int>()),
            "support rule ID required");
        Throws<ArgumentNullException>(
            () => new SupportEdge(0, "rule", null!, Array.Empty<string>(), Array.Empty<int>()),
            "premise sequence required");
        Throws<ArgumentNullException>(
            () => new SupportEdge(0, "rule", Array.Empty<int>(), null!, Array.Empty<int>()),
            "parameter sequence required");
        Throws<ArgumentNullException>(
            () => new SupportEdge(0, "rule", Array.Empty<int>(), Array.Empty<string>(), null!),
            "occurrence sequence required");
        Throws<ArgumentOutOfRangeException>(
            () => new SupportEdge(
                0, "rule", new[] { -1 }, Array.Empty<string>(), Array.Empty<int>()),
            "negative premise ordinal refused");
        Throws<ArgumentException>(
            () => new SupportEdge(
                0, "rule", Array.Empty<int>(), new string[] { null! }, Array.Empty<int>()),
            "null parameter refused");
        Throws<ArgumentOutOfRangeException>(
            () => new SupportEdge(
                0, "rule", Array.Empty<int>(), Array.Empty<string>(), new[] { -2 }),
            "negative occurrence ordinal refused");

        var premises = new List<int> { 1, 2 };
        var parameters = new List<string> { "p" };
        var occurrences = new List<int> { 0, 3 };
        var edge = new SupportEdge(0, "path", premises, parameters, occurrences);
        premises[0] = 9;
        parameters[0] = "mutated";
        occurrences.Clear();
        Equal(1, edge.PremiseOrdinals[0], "premise tuple snapshotted");
        Equal("p", edge.Parameters[0], "parameter tuple snapshotted");
        Equal(2, edge.OccurrenceOrdinals.Count, "occurrence tuple snapshotted");

        var same = new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p" }, new[] { 0, 3 });
        True(edge.Equals(same), "support edge value equality");
        Equal(edge.GetHashCode(), same.GetHashCode(), "support edge hash agreement");

        var distinctions = new[]
        {
            new SupportEdge(1, "path", new[] { 1, 2 }, new[] { "p" }, new[] { 0, 3 }),
            new SupportEdge(0, "path2", new[] { 1, 2 }, new[] { "p" }, new[] { 0, 3 }),
            new SupportEdge(0, "path", new[] { 2, 1 }, new[] { "p" }, new[] { 0, 3 }),
            new SupportEdge(0, "path", new[] { 1, 1, 2 }, new[] { "p" }, new[] { 0, 3 }),
            new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p", "q" }, new[] { 0, 3 }),
            new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p" }, new[] { 3, 0 }),
            new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p" }, Array.Empty<int>()),
        };
        for (var i = 0; i < distinctions.Length; i++)
        {
            True(!edge.Equals(distinctions[i]), $"support edge distinction {i} is an alternative");
        }

        True(!edge.Equals(null), "null support edge inequality");
    }

    private static void SupportHypergraphValidatesExactBasesAndRetainsAlternatives()
    {
        var master = new TextMaster("facts", 0, "wxyz");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(1, 2), "node", SpanLevel.Character, "witness"));
        builder.Add(new SpanClaim(new TextSpan(0, 3), "node", SpanLevel.Character, "witness"));
        var occurrences = builder.Freeze();

        var table = CanonicalFactTable.Create(master, new FactKey[]
        {
            new(
                "hier",
                "Ancestor",
                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },
                Array.Empty<string>()),
            new(
                "hier",
                "Parent",
                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },
                Array.Empty<string>()),
        });

        Throws<ArgumentNullException>(
            () => SupportHypergraph.Create(null!, occurrences, Array.Empty<SupportEdge>()),
            "fact basis required");
        Throws<ArgumentNullException>(
            () => SupportHypergraph.Create(table, null!, Array.Empty<SupportEdge>()),
            "occurrence basis required");
        Throws<ArgumentNullException>(
            () => SupportHypergraph.Create(table, occurrences, null!),
            "support edge sequence required");

        var foreignBuilder = new SpanBatchBuilder(new TextMaster("other", 0, "wxyz"));
        foreignBuilder.Add(new SpanClaim(new TextSpan(0, 1), "node", SpanLevel.Character, "witness"));
        Throws<InvalidOperationException>(
            () => SupportHypergraph.Create(table, foreignBuilder.Freeze(), Array.Empty<SupportEdge>()),
            "incompatible occurrence master refused");

        Throws<ArgumentException>(
            () => SupportHypergraph.Create(table, occurrences, new SupportEdge[] { null! }),
            "null support edge refused");
        Throws<ArgumentException>(
            () => SupportHypergraph.Create(
                table,
                occurrences,
                new[]
                {
                    new SupportEdge(
                        2, "rule", Array.Empty<int>(), Array.Empty<string>(), Array.Empty<int>()),
                }),
            "missing conclusion fact refused");
        Throws<ArgumentException>(
            () => SupportHypergraph.Create(
                table,
                occurrences,
                new[]
                {
                    new SupportEdge(
                        0, "rule", new[] { 2 }, Array.Empty<string>(), Array.Empty<int>()),
                }),
            "missing premise fact refused");
        Throws<ArgumentException>(
            () => SupportHypergraph.Create(
                table,
                occurrences,
                new[]
                {
                    new SupportEdge(
                        0, "rule", Array.Empty<int>(), Array.Empty<string>(), new[] { 2 }),
                }),
            "invalid occurrence ordinal refused");

        var bare = SupportHypergraph.Create(table, occurrences, Array.Empty<SupportEdge>());
        True(bare.IsEmpty, "facts need no support edge");
        Equal(0, bare.SupportsOf(0).Count, "unsupported fact answers with no edges");
        Throws<ArgumentOutOfRangeException>(
            () => bare.SupportsOf(2), "supports query validates its ordinal");

        var compatibleBuilder = new SpanBatchBuilder(new TextMaster("facts", 0, "wxyz"));
        compatibleBuilder.Add(
            new SpanClaim(new TextSpan(1, 2), "node", SpanLevel.Character, "witness"));
        var compatibleGraph =
            SupportHypergraph.Create(table, compatibleBuilder.Freeze(), Array.Empty<SupportEdge>());
        Equal(0, compatibleGraph.Count, "compatible-but-distinct master batch admitted");

        var alternatives = new[]
        {
            new SupportEdge(0, "path", new[] { 1 }, Array.Empty<string>(), new[] { 0 }),
            new SupportEdge(0, "path", new[] { 1 }, Array.Empty<string>(), new[] { 0 }),
            new SupportEdge(0, "path", new[] { 1, 1 }, Array.Empty<string>(), new[] { 0 }),
            new SupportEdge(0, "other-rule", new[] { 1 }, Array.Empty<string>(), new[] { 0 }),
            new SupportEdge(0, "path", new[] { 1 }, new[] { "p" }, new[] { 0 }),
            new SupportEdge(0, "path", new[] { 1 }, Array.Empty<string>(), new[] { 1 }),
            new SupportEdge(0, "seed", Array.Empty<int>(), Array.Empty<string>(), Array.Empty<int>()),
            new SupportEdge(0, "self", new[] { 0 }, Array.Empty<string>(), Array.Empty<int>()),
            new SupportEdge(1, "cycle", new[] { 0 }, Array.Empty<string>(), Array.Empty<int>()),
            new SupportEdge(0, "cycle", new[] { 1 }, Array.Empty<string>(), Array.Empty<int>()),
        };

        var graph = SupportHypergraph.Create(table, occurrences, alternatives);
        Equal(9, graph.Count, "exact duplicate support collapses");
        Equal(8, graph.SupportsOf(0).Count, "alternative supports retained beside one conclusion");
        Equal(1, graph.SupportsOf(1).Count, "cyclic and self-support are representable");

        var reversed = new SupportEdge[alternatives.Length];
        for (var i = 0; i < alternatives.Length; i++)
        {
            reversed[i] = alternatives[alternatives.Length - 1 - i];
        }

        var reordered = SupportHypergraph.Create(table, occurrences, reversed);
        Equal(graph.Count, reordered.Count, "supply order does not change the edge census");
        var sequenceAgrees = true;
        for (var i = 0; i < graph.Count; i++)
        {
            if (!graph[i].Equals(reordered[i]))
            {
                sequenceAgrees = false;
            }
        }

        True(sequenceAgrees, "canonical edge enumeration is supply-order independent");

        var edgeList = new List<SupportEdge>
        {
            new(0, "seed", Array.Empty<int>(), Array.Empty<string>(), Array.Empty<int>()),
        };
        var snapshotted = SupportHypergraph.Create(table, occurrences, edgeList);
        edgeList.Clear();
        Equal(1, snapshotted.Count, "edge sequence snapshotted");
        Throws<ArgumentOutOfRangeException>(() => _ = snapshotted[1], "edge index validated");
    }

    private static void K5aHierarchyDiamondWitnessSuppliesAncestorSupport()
    {
        // The K4c four-node diamond a -> b -> d with a -> c -> d, replayed as facts: four Parent
        // facts plus one directly supplied Ancestor(a,d) conclusion carried by two ordered
        // support paths. Nothing here saturates; K5b later derives the same result.
        var master = new TextMaster("diamond", 0, "wxyz");
        var a = new TextSpan(1, 2);
        var b = new TextSpan(0, 3);
        var c = new TextSpan(1, 4);
        var d = new TextSpan(0, 4);

        var builder = new SpanBatchBuilder(master);
        var occurrenceA = builder.Add(new SpanClaim(a, "node", SpanLevel.Character, "witness"));
        var occurrenceB = builder.Add(new SpanClaim(b, "node", SpanLevel.Character, "witness"));
        var occurrenceC = builder.Add(new SpanClaim(c, "node", SpanLevel.Character, "witness"));
        var occurrenceD = builder.Add(new SpanClaim(d, "node", SpanLevel.Character, "witness"));
        var occurrences = builder.Freeze();

        FactKey Parent(TextSpan child, TextSpan parent) =>
            new("hier", "Parent", new[] { child, parent }, Array.Empty<string>());
        var ancestor = new FactKey("hier", "Ancestor", new[] { a, d }, Array.Empty<string>());

        // The conclusion is proposed once per path; the semantic fact collapses to one row.
        var table = CanonicalFactTable.Create(master, new[]
        {
            Parent(a, b), Parent(b, d), ancestor,
            Parent(a, c), Parent(c, d), ancestor,
        });
        Equal(5, table.Count, "diamond fact census");

        True(table.TryGetOrdinal(ancestor, out var ancestorOrdinal), "ancestor fact retained");
        True(table.TryGetOrdinal(Parent(a, b), out var ab), "Parent(a,b) retained");
        True(table.TryGetOrdinal(Parent(b, d), out var bd), "Parent(b,d) retained");
        True(table.TryGetOrdinal(Parent(a, c), out var ac), "Parent(a,c) retained");
        True(table.TryGetOrdinal(Parent(c, d), out var cd), "Parent(c,d) retained");

        // K7's optional seam: the exact fact handle exists before and without any support graph.
        var seam = new FactReference(table, ancestorOrdinal);
        True(seam.Key.Equals(ancestor), "fact reference projects the ancestor without support");

        var viaB = new SupportEdge(
            ancestorOrdinal,
            "ancestor-path",
            new[] { ab, bd },
            Array.Empty<string>(),
            new[] { occurrenceA, occurrenceB, occurrenceD });
        var viaC = new SupportEdge(
            ancestorOrdinal,
            "ancestor-path",
            new[] { ac, cd },
            Array.Empty<string>(),
            new[] { occurrenceA, occurrenceC, occurrenceD });
        var graph = SupportHypergraph.Create(table, occurrences, new[] { viaB, viaC });
        var mirrored = SupportHypergraph.Create(table, occurrences, new[] { viaC, viaB });

        Equal(2, graph.Count, "two ancestor supports supplied without saturation");
        var supports = graph.SupportsOf(ancestorOrdinal);
        Equal(2, supports.Count, "both paths retained beside one conclusion");
        var mirroredSupports = mirrored.SupportsOf(ancestorOrdinal);
        True(
            supports[0].Equals(mirroredSupports[0]) && supports[1].Equals(mirroredSupports[1]),
            "support enumeration is supply-order independent");

        var pathThroughB = false;
        var pathThroughC = false;
        foreach (var support in supports)
        {
            if (support.PremiseOrdinals.Count == 2 &&
                support.PremiseOrdinals[0] == ab &&
                support.PremiseOrdinals[1] == bd &&
                support.OccurrenceOrdinals.Count == 3 &&
                support.OccurrenceOrdinals[1] == occurrenceB)
            {
                pathThroughB = true;
            }

            if (support.PremiseOrdinals.Count == 2 &&
                support.PremiseOrdinals[0] == ac &&
                support.PremiseOrdinals[1] == cd &&
                support.OccurrenceOrdinals.Count == 3 &&
                support.OccurrenceOrdinals[1] == occurrenceC)
            {
                pathThroughC = true;
            }
        }

        True(pathThroughB, "ordered path through b retained");
        True(pathThroughC, "ordered path through c retained");

        foreach (var parentOrdinal in new[] { ab, bd, ac, cd })
        {
            Equal(
                0,
                graph.SupportsOf(parentOrdinal).Count,
                $"Parent fact #{parentOrdinal} carries no support");
        }
    }

    private static IEnumerable<int[]> Permutations(int count)
    {
        var indices = new int[count];
        for (var i = 0; i < count; i++)
        {
            indices[i] = i;
        }

        return PermuteFrom(indices, 0);
    }

    private static IEnumerable<int[]> PermuteFrom(int[] indices, int position)
    {
        if (position == indices.Length)
        {
            yield return (int[])indices.Clone();
            yield break;
        }

        for (var i = position; i < indices.Length; i++)
        {
            (indices[position], indices[i]) = (indices[i], indices[position]);
            foreach (var permutation in PermuteFrom(indices, position + 1))
            {
                yield return permutation;
            }

            (indices[position], indices[i]) = (indices[i], indices[position]);
        }
    }

    private static void True(bool condition, string name)
    {
        _checks++;
        if (!condition)
        {
            throw new InvalidOperationException($"Check failed: {name}");
        }
    }

    private static void Equal<T>(T expected, T actual, string name)
    {
        _checks++;
        if (!EqualityComparer<T>.Default.Equals(expected, actual))
        {
            throw new InvalidOperationException(
                $"Check failed: {name}; expected '{expected}', actual '{actual}'.");
        }
    }

    private static void Throws<TException>(Action action, string name)
        where TException : Exception
    {
        _checks++;
        try
        {
            action();
        }
        catch (TException)
        {
            return;
        }

        throw new InvalidOperationException($"Check failed: {name}; expected {typeof(TException).Name}.");
    }
}
