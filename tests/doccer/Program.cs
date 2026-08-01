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
            FrozenBatchPreservesClaims();
            SpanSetObeysBooleanLawsAndMasterIdentity();
            SpanSetRandomizedLawsHold();
            AllenRelationsAreCompleteAndInvertible();
            LaminarizationRetainsCrossingResidue();
            ScopedRegexCollectionCannotBridgeGaps();
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
