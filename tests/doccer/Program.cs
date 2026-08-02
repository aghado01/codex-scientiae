using System;
using System.Collections.Generic;
using System.Linq;
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
            RunViewsTileTheMasterUnderEveryBreakKey();
            LazySubstrateDefersUntouchedWork();
            FrozenBatchPreservesClaims();
            InternedColumnsRoundTripClaimStrings();
            SpanSetObeysBooleanLawsAndMasterIdentity();
            SpanSetRandomizedLawsHold();
            AllenRelationsAreCompleteAndInvertible();
            LaminarizationRetainsCrossingResidue();
            ScopedRegexCollectionCannotBridgeGaps();
            DefectiveRuleFailsAtLoadTimeWithoutSideEffects();
            DeclarativeValidationRunsWithoutDomainCode();
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
