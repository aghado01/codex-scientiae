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

internal static class Program
{
    private static int _checks;

    public static int Main()
    {
        try
        {
            MasterTopologyIsTotal();
            TilingReconstructsAndAgreesWithLines();
            ResolutionIsDeterministic();
            RunViewsTileTheMasterUnderEveryBreakKey();
            LazySubstrateDefersUntouchedWork();
            FrozenBatchPreservesClaims();
            InternedColumnsRoundTripClaimStrings();
            SpanSetObeysBooleanLawsAndMasterIdentity();
            SpanSetRandomizedLawsHold();
            AllenRelationsAreCompleteAndInvertible();
            LaminarizationRetainsCrossingResidue();
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

    private static void ResolutionIsDeterministic()
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
        var first = Laminarizer.Extract(batch);
        var second = Laminarizer.Extract(batch);

        Equal(Ordinals(first.Accepted), Ordinals(second.Accepted), "accepted ordering is reproducible");
        Equal(Ordinals(first.CrossingResidue), Ordinals(second.CrossingResidue), "residue ordering is reproducible");
        Equal(DescribeTree(first.Roots), DescribeTree(second.Roots), "tree shape and ordering are reproducible");
        True(first.Accepted.Count > 0 && first.CrossingResidue.Count > 0, "the fixture exercises both outcomes");

        // Accepted and residue partition the claim set, whichever run produced them.
        Equal(
            batch.Count,
            first.Accepted.Count + first.CrossingResidue.Count,
            "every claim is either accepted or residue");

        // The same claims in the same order over a fresh batch resolve identically: determinism is
        // a property of the ordering rules, not of one object's identity.
        var replayBuilder = new SpanBatchBuilder(master);
        foreach (var record in batch)
        {
            replayBuilder.Add(record.ToClaim());
        }

        var replay = Laminarizer.Extract(replayBuilder.Freeze());
        Equal(Ordinals(first.Accepted), Ordinals(replay.Accepted), "replayed batch accepts the same claims");
        Equal(DescribeTree(first.Roots), DescribeTree(replay.Roots), "replayed batch builds the same tree");

        // A filtered extraction is equally reproducible.
        var filteredFirst = Laminarizer.Extract(batch, record => record.Priority >= 2);
        var filteredSecond = Laminarizer.Extract(batch, record => record.Priority >= 2);
        Equal(
            DescribeTree(filteredFirst.Roots),
            DescribeTree(filteredSecond.Roots),
            "filtered extraction is reproducible");
    }

    private static string Ordinals(IReadOnlyList<SpanRecord> records) =>
        string.Join(",", records.Select(record => record.Ordinal));

    private static string DescribeTree(IReadOnlyList<LaminarNode> roots)
    {
        var description = new StringBuilder();
        AppendNodes(description, roots, 0);
        return description.ToString();
    }

    private static void AppendNodes(StringBuilder description, IReadOnlyList<LaminarNode> nodes, int depth)
    {
        foreach (var node in nodes)
        {
            description.Append(depth).Append(':').Append(node.Span);
            foreach (var claim in node.Claims)
            {
                description.Append('/').Append(claim.Ordinal);
            }

            description.Append(';');
            AppendNodes(description, node.Children, depth + 1);
        }
    }

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

    private static void LaminarizationRetainsCrossingResidue()
    {
        var master = new TextMaster("laminar", 0, "01234567890123456789");
        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(0, 20), "root", SpanLevel.MultiLine, "sweep", 100));
        builder.Add(new SpanClaim(new TextSpan(2, 12), "left", SpanLevel.MultiLine, "parser", 10));
        builder.Add(new SpanClaim(new TextSpan(8, 18), "crossing", SpanLevel.MultiLine, "heuristic", 5));
        builder.Add(new SpanClaim(new TextSpan(3, 6), "nested", SpanLevel.Character, "scanner", 1));
        builder.Add(new SpanClaim(new TextSpan(2, 12), "left-confirmation", SpanLevel.MultiLine, "human", 2));

        var view = Laminarizer.Extract(builder.Freeze());
        Equal(4, view.Accepted.Count, "accepted claim count preserves equal claims");
        Equal(1, view.CrossingResidue.Count, "crossing residue count");
        Equal("crossing", view.CrossingResidue[0].Kind, "crossing identity");
        Equal(1, view.Roots.Count, "forest root count");
        Equal(1, view.Roots[0].Children.Count, "root child geometry count");
        Equal(2, view.Roots[0].Children[0].Claims.Count, "equal-geometry claims grouped");
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
                new[] { AllenRelation.During },
                minimumMatches: 1,
                maximumMatches: 1),
        };
        var impossibilities = new[]
        {
            new ForbiddenRelation(
                "container-must-not-cross-forbidden",
                "container",
                "forbidden",
                new[] { AllenRelation.Overlaps }),
        };

        var issues = DoccerValidation.ValidateRelations(batch, requirements, impossibilities);
        Equal(1, issues.Count, "one impossibility detected");
        Equal("container-must-not-cross-forbidden", issues[0].Rule, "impossibility rule identity");
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
        Equal(left.Count * right.Count, joined.Count, "the unfiltered join relates every pair");
        Equal(AllenRelation.Meets, joined[0].Relation, "[0,5) meets [5,10)");
        Equal(AllenRelation.Equal, joined[2].Relation, "[0,5) equals [0,5)");
        Equal(AllenRelation.MetBy, joined[3].Relation, "[10,20) is met by [5,10)");
        Equal(AllenRelation.Contains, joined[4].Relation, "[10,20) contains [12,18)");
        Equal(0, joined[0].Left.Ordinal, "join rows carry the left record");
        Equal(0, joined[0].Right.Ordinal, "join rows carry the right record");

        var contains = IntervalJoins.Join(
            left, right, new HashSet<AllenRelation> { AllenRelation.Contains });
        Equal(1, contains.Count, "the filtered join keeps only the requested relations");
        Equal("b", contains[0].Left.Kind, "the filtered row's left claim");
        Equal("d", contains[0].Right.Kind, "the filtered row's right claim");

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
