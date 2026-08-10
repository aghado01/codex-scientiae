using System;
using System.Collections.Generic;
using System.Linq;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static void GroundRuleIsAnOrderedGroundEvidenceValue()
    {
        var a = SaturationFact("a");
        var b = SaturationFact("b");
        var c = SaturationFact("c");
        var premises = new List<FactKey> { a, b };
        var parameters = new List<string> { "", "parameter" };
        var occurrences = new List<int> { 1, 1, 0 };
        var rule = new GroundRule(c, "rule", premises, parameters, occurrences);

        premises.Clear();
        parameters.Clear();
        occurrences.Clear();
        Equal(2, rule.Premises.Count, "ground rule snapshots premise sequence");
        Equal(2, rule.Parameters.Count, "ground rule snapshots parameter sequence");
        Equal(3, rule.OccurrenceOrdinals.Count, "ground rule snapshots occurrence sequence");
        True(rule.Premises[0].Equals(a), "ground rule retains first premise position");
        True(rule.Premises[1].Equals(b), "ground rule retains second premise position");
        Equal(string.Empty, rule.Parameters[0], "blank ground-rule parameter is evidence");
        Equal(1, rule.OccurrenceOrdinals[1], "duplicate ground-rule occurrence retained");

        var equal = new GroundRule(
            SaturationFact("c"),
            "rule",
            new[] { SaturationFact("a"), SaturationFact("b") },
            new[] { "", "parameter" },
            new[] { 1, 1, 0 });
        True(rule.Equals(equal), "ground-rule equality uses semantic fact values");
        Equal(rule.GetHashCode(), equal.GetHashCode(), "equal ground rules hash equally");
        True(
            !rule.Equals(new GroundRule(c, "other", new[] { a, b }, new[] { "", "parameter" }, new[] { 1, 1, 0 })),
            "ground-rule ID distinguishes evidence");
        True(
            !rule.Equals(new GroundRule(c, "rule", new[] { b, a }, new[] { "", "parameter" }, new[] { 1, 1, 0 })),
            "ground-rule premise order distinguishes evidence");
        True(
            !rule.Equals(new GroundRule(c, "rule", new[] { a, b, b }, new[] { "", "parameter" }, new[] { 1, 1, 0 })),
            "ground-rule duplicate premise distinguishes evidence");
        True(
            !rule.Equals(new GroundRule(c, "rule", new[] { a, b }, new[] { "parameter", "" }, new[] { 1, 1, 0 })),
            "ground-rule parameter order distinguishes evidence");
        True(
            !rule.Equals(new GroundRule(c, "rule", new[] { a, b }, new[] { "", "parameter" }, new[] { 1, 0, 1 })),
            "ground-rule occurrence order distinguishes evidence");
        True(
            !rule.Equals(new GroundRule(b, "rule", new[] { a, b }, new[] { "", "parameter" }, new[] { 1, 1, 0 })),
            "ground-rule conclusion distinguishes implications");

        Throws<ArgumentNullException>(
            () => new GroundRule(null!, "rule", Array.Empty<FactKey>(), Array.Empty<string>(), Array.Empty<int>()),
            "ground rule requires a conclusion");
        Throws<ArgumentException>(
            () => new GroundRule(a, " ", Array.Empty<FactKey>(), Array.Empty<string>(), Array.Empty<int>()),
            "ground rule requires a nonblank ID");
        Throws<ArgumentNullException>(
            () => new GroundRule(a, "rule", null!, Array.Empty<string>(), Array.Empty<int>()),
            "ground rule requires a premise sequence");
        Throws<ArgumentNullException>(
            () => new GroundRule(a, "rule", Array.Empty<FactKey>(), null!, Array.Empty<int>()),
            "ground rule requires a parameter sequence");
        Throws<ArgumentNullException>(
            () => new GroundRule(a, "rule", Array.Empty<FactKey>(), Array.Empty<string>(), null!),
            "ground rule requires an occurrence sequence");
        Throws<ArgumentException>(
            () => new GroundRule(a, "rule", new FactKey[] { null! }, Array.Empty<string>(), Array.Empty<int>()),
            "ground rule refuses null premises");
        Throws<ArgumentException>(
            () => new GroundRule(a, "rule", Array.Empty<FactKey>(), new string[] { null! }, Array.Empty<int>()),
            "ground rule refuses null parameters");
        Throws<ArgumentOutOfRangeException>(
            () => new GroundRule(a, "rule", Array.Empty<FactKey>(), Array.Empty<string>(), new[] { -1 }),
            "ground rule refuses negative occurrence ordinals");
    }

    private static void SaturationProblemValidatesAndCanonicalizesRules()
    {
        var master = new TextMaster("saturation-problem", 0, "xy");
        var occurrenceBuilder = new SpanBatchBuilder(master);
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(0, 1), "witness", SpanLevel.Character, "fixture"));
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(1, 2), "witness", SpanLevel.Character, "fixture"));
        var occurrences = occurrenceBuilder.Freeze();
        var a = new FactKey("sat", "Fact", new[] { new TextSpan(0, 1) }, new[] { "a" });
        var b = new FactKey("sat", "Fact", new[] { new TextSpan(1, 2) }, new[] { "b" });
        var c = SaturationFact("c");
        var d = SaturationFact("d");
        var missing = SaturationFact("missing");
        var table = CanonicalFactTable.Create(master, new[] { a });
        var initial = SupportHypergraph.Create(table, occurrences, Array.Empty<SupportEdge>());

        var deriveB = new GroundRule(b, "derive-b", new[] { a }, new[] { "p" }, new[] { 0 });
        var duplicateB = new GroundRule(
            new FactKey("sat", "Fact", new[] { new TextSpan(1, 2) }, new[] { "b" }),
            "derive-b",
            new[] { new FactKey("sat", "Fact", new[] { new TextSpan(0, 1) }, new[] { "a" }) },
            new[] { "p" },
            new[] { 0 });
        var parameterAlternative = new GroundRule(
            b,
            "derive-b",
            new[] { a },
            new[] { "other" },
            new[] { 0 });
        var occurrenceAlternative = new GroundRule(
            b,
            "derive-b",
            new[] { a },
            new[] { "p" },
            new[] { 1 });
        var deriveC = new GroundRule(c, "derive-c", new[] { b }, Array.Empty<string>(), new[] { 1 });
        var disabled = new GroundRule(d, "disabled", new[] { missing }, Array.Empty<string>(), Array.Empty<int>());
        var supplied = new List<GroundRule>
        {
            disabled,
            occurrenceAlternative,
            deriveC,
            parameterAlternative,
            duplicateB,
            deriveB,
        };
        var problem = SaturationProblem.Create(initial, supplied);
        supplied.Clear();

        True(ReferenceEquals(initial, problem.Initial), "saturation problem retains exact initial graph");
        True(ReferenceEquals(table, problem.InitialFacts), "saturation problem retains exact initial table");
        True(ReferenceEquals(occurrences, problem.Occurrences), "saturation problem retains exact occurrence batch");
        True(ReferenceEquals(master, problem.Master), "saturation problem exposes initial table master");
        Equal(5, problem.Rules.Count, "saturation problem collapses only exact duplicate rules");
        var rulesAreCanonical = true;
        for (var i = 1; i < problem.Rules.Count; i++)
        {
            rulesAreCanonical &= GroundRule.CompareCanonical(problem.Rules[i - 1], problem.Rules[i]) < 0;
        }

        True(rulesAreCanonical, "ground rules enumerate in canonical order");
        True(problem.Rules.Any(rule => rule.Equals(deriveB)), "canonical rules retain present-key derivation");
        True(problem.Rules.Any(rule => rule.Equals(parameterAlternative)), "parameter distinction survives rule deduplication");
        True(problem.Rules.Any(rule => rule.Equals(occurrenceAlternative)), "occurrence distinction survives rule deduplication");
        True(problem.Rules.Any(rule => rule.Equals(deriveC)), "canonical rules retain chained derivation");
        True(problem.Rules.Any(rule => rule.Equals(disabled)), "canonical rules retain disabled universe members");

        var reordered = SaturationProblem.Create(
            initial,
            new[] { deriveB, disabled, parameterAlternative, deriveC, occurrenceAlternative });
        var canonicalRulesAgree = problem.Rules.Count == reordered.Rules.Count;
        for (var i = 0; canonicalRulesAgree && i < problem.Rules.Count; i++)
        {
            canonicalRulesAgree = problem.Rules[i].Equals(reordered.Rules[i]);
        }

        True(canonicalRulesAgree, "canonical ground-rule sequence is supply-order independent");
        var result = FactSaturation.Saturate(problem);
        True(result.Facts.TryGetOrdinal(b, out var bOrdinal), "present premise enables missing conclusion");
        Equal(3, result.Graph.SupportsOf(bOrdinal).Count, "parameter and occurrence alternatives remain distinct supports");
        True(result.Facts.TryGetOrdinal(c, out _), "rules may name conclusions absent from initial facts");
        True(!result.Facts.TryGetOrdinal(d, out _), "disabled conclusion remains outside reached facts");
        True(!result.Facts.TryGetOrdinal(missing, out _), "premise-only universe key is not an initial fact");

        Throws<ArgumentNullException>(
            () => SaturationProblem.Create(null!, Array.Empty<GroundRule>()),
            "saturation problem requires an initial graph");
        Throws<ArgumentNullException>(
            () => SaturationProblem.Create(initial, null!),
            "saturation problem requires a rule sequence");
        Throws<ArgumentException>(
            () => SaturationProblem.Create(initial, new GroundRule[] { null! }),
            "saturation problem refuses null rule elements");

        var outside = new FactKey(
            "sat", "Fact", new[] { new TextSpan(0, master.Length + 1) }, new[] { "outside" });
        Throws<ArgumentOutOfRangeException>(
            () => SaturationProblem.Create(
                initial,
                new[] { new GroundRule(outside, "bad-conclusion", Array.Empty<FactKey>(), Array.Empty<string>(), Array.Empty<int>()) }),
            "saturation problem validates conclusion geometry");
        Throws<ArgumentOutOfRangeException>(
            () => SaturationProblem.Create(
                initial,
                new[] { new GroundRule(a, "bad-premise", new[] { outside }, Array.Empty<string>(), Array.Empty<int>()) }),
            "saturation problem validates premise geometry");
        Throws<ArgumentException>(
            () => SaturationProblem.Create(
                initial,
                new[] { new GroundRule(b, "bad-occurrence", new[] { a }, Array.Empty<string>(), new[] { 2 }) }),
            "saturation problem validates exact-batch occurrence ordinals");
    }

    private static void FactSaturationHandlesFinitePositiveClosure()
    {
        Throws<ArgumentNullException>(
            () => FactSaturation.Saturate(null!),
            "saturation requires a problem");

        var emptyMaster = new TextMaster("saturation-empty", 0, string.Empty);
        var emptyOccurrences = new SpanBatchBuilder(emptyMaster).Freeze();
        var emptyTable = CanonicalFactTable.Create(emptyMaster, Array.Empty<FactKey>());
        var emptyInitial = SupportHypergraph.Create(
            emptyTable,
            emptyOccurrences,
            Array.Empty<SupportEdge>());
        var emptyProblem = SaturationProblem.Create(emptyInitial, Array.Empty<GroundRule>());
        var emptyResult = FactSaturation.Saturate(emptyProblem);
        True(ReferenceEquals(emptyProblem, emptyResult.Problem), "empty result retains exact problem");
        Equal(0, emptyResult.Facts.Count, "empty saturation has no facts");
        Equal(0, emptyResult.Graph.Count, "empty saturation has no support");
        True(!ReferenceEquals(emptyTable, emptyResult.Facts), "empty saturation freezes a new fact table");
        True(!ReferenceEquals(emptyInitial, emptyResult.Graph), "empty saturation freezes a new support graph");
        True(ReferenceEquals(emptyOccurrences, emptyResult.Graph.Occurrences), "empty saturation retains exact occurrence batch");
        True(ReferenceEquals(emptyResult.Facts, emptyResult.Graph.Facts), "result facts alias graph facts exactly");

        var master = new TextMaster("saturation-positive", 0, "x");
        var occurrences = new SpanBatchBuilder(master).Freeze();
        var a = SaturationFact("a");
        var b = SaturationFact("b");
        var c = SaturationFact("c");
        var d = SaturationFact("d");
        var missing = SaturationFact("missing");
        var initialTable = CanonicalFactTable.Create(master, new[] { a });
        var unsupported = SupportHypergraph.Create(
            initialTable,
            occurrences,
            Array.Empty<SupportEdge>());
        var problem = SaturationProblem.Create(
            unsupported,
            new[]
            {
                new GroundRule(b, "zero", Array.Empty<FactKey>(), Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(c, "duplicate-premise", new[] { b, b }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(d, "disabled", new[] { missing }, Array.Empty<string>(), Array.Empty<int>()),
            });
        var result = FactSaturation.Saturate(problem);
        Equal(3, result.Facts.Count, "zero-arity and duplicate-premise closure fact census");
        Equal(2, result.Graph.Count, "only enabled rules contribute support");
        True(result.Facts.TryGetOrdinal(a, out var aOrdinal), "unsupported initial fact retained");
        True(result.Facts.TryGetOrdinal(b, out var bOrdinal), "zero-arity conclusion reached");
        True(result.Facts.TryGetOrdinal(c, out var cOrdinal), "duplicate premise does not consume a resource");
        True(!result.Facts.TryGetOrdinal(d, out _), "disabled conclusion not reached");
        True(!result.Facts.TryGetOrdinal(missing, out _), "disabled premise-only key not reached");
        Equal(0, result.Graph.SupportsOf(aOrdinal).Count, "initial facts may remain unsupported");
        var zeroSupport = result.Graph.SupportsOf(bOrdinal);
        Equal(1, zeroSupport.Count, "zero-arity rule contributes one support");
        Equal(0, zeroSupport[0].PremiseOrdinals.Count, "zero-arity support has no premises");
        var duplicateSupport = result.Graph.SupportsOf(cOrdinal);
        Equal(1, duplicateSupport.Count, "duplicate-premise rule contributes one support");
        Equal(2, duplicateSupport[0].PremiseOrdinals.Count, "duplicate premise positions retained");
        Equal(bOrdinal, duplicateSupport[0].PremiseOrdinals[0], "first duplicate premise resolves");
        Equal(bOrdinal, duplicateSupport[0].PremiseOrdinals[1], "second duplicate premise resolves");

        var collisionEdge = new SupportEdge(
            0,
            "collision",
            Array.Empty<int>(),
            Array.Empty<string>(),
            Array.Empty<int>());
        var collisionInitial = SupportHypergraph.Create(
            initialTable,
            occurrences,
            new[] { collisionEdge });
        var collisionProblem = SaturationProblem.Create(
            collisionInitial,
            new[]
            {
                new GroundRule(a, "collision", Array.Empty<FactKey>(), Array.Empty<string>(), Array.Empty<int>()),
            });
        var collisionResult = FactSaturation.Saturate(collisionProblem);
        Equal(1, collisionResult.Graph.Count, "identical initial and enabled-rule support collapses");
    }

    private static void FactSaturationRetainsCompleteEnabledSupport()
    {
        var master = new TextMaster("saturation-support", 0, string.Empty);
        var occurrences = new SpanBatchBuilder(master).Freeze();
        var a = SaturationFact("a");
        var b = SaturationFact("b");
        var c = SaturationFact("c");
        var d = SaturationFact("d");
        var e = SaturationFact("e");
        var f = SaturationFact("f");
        var initial = SupportHypergraph.Create(
            CanonicalFactTable.Create(master, new[] { a }),
            occurrences,
            Array.Empty<SupportEdge>());

        var deriveTwo = new GroundRule(b, "derive-2", new[] { a }, Array.Empty<string>(), Array.Empty<int>());
        var problem = SaturationProblem.Create(
            initial,
            new[]
            {
                new GroundRule(b, "derive-1", new[] { a }, Array.Empty<string>(), Array.Empty<int>()),
                deriveTwo,
                new GroundRule(SaturationFact("b"), "derive-2", new[] { SaturationFact("a") }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(b, "self", new[] { b }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(c, "forward", new[] { b }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(b, "back", new[] { c }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(a, "initial", new[] { a }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(c, "forward", new[] { b }, new[] { "alternative" }, Array.Empty<int>()),
                new GroundRule(d, "unreachable-a", new[] { e }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(e, "unreachable-b", new[] { d }, Array.Empty<string>(), Array.Empty<int>()),
                new GroundRule(f, "unreachable-self", new[] { f }, Array.Empty<string>(), Array.Empty<int>()),
            });
        Equal(10, problem.Rules.Count, "exact duplicate rule collapses before execution");

        var result = FactSaturation.Saturate(problem);
        Equal(3, result.Facts.Count, "reachable cycle closes without admitting unreachable cycle");
        Equal(7, result.Graph.Count, "every distinct finally enabled rule contributes support");
        True(result.Facts.TryGetOrdinal(a, out var aOrdinal), "cycle result retains seed");
        True(result.Facts.TryGetOrdinal(b, out var bOrdinal), "cycle result reaches b");
        True(result.Facts.TryGetOrdinal(c, out var cOrdinal), "cycle result reaches c");
        True(!result.Facts.TryGetOrdinal(d, out _), "unseeded cycle does not reach d");
        True(!result.Facts.TryGetOrdinal(e, out _), "unseeded cycle does not reach e");
        True(!result.Facts.TryGetOrdinal(f, out _), "unseeded self-rule does not reach f");
        Equal(1, result.Graph.SupportsOf(aOrdinal).Count, "enabled rule supports an initial conclusion");
        Equal(4, result.Graph.SupportsOf(bOrdinal).Count, "earlier conclusion retains all late and alternative supports");
        Equal(2, result.Graph.SupportsOf(cOrdinal).Count, "parameter distinction retains both conclusion supports");

        var supportIds = result.Graph.Select(edge => edge.RuleId).ToArray();
        True(supportIds.Contains("self", StringComparer.Ordinal), "reachable self-rule contributes support");
        True(supportIds.Contains("back", StringComparer.Ordinal), "reached cycle contributes back-edge support");
        True(!supportIds.Contains("unreachable-a", StringComparer.Ordinal), "unreached cycle contributes no support");
        Equal(2, supportIds.Count(id => StringComparer.Ordinal.Equals(id, "forward")), "parameter alternative remains distinct");
    }

    private static void FactSaturationRebasesThroughKeyOrderShifts()
    {
        var master = new TextMaster("saturation-shift", 0, "xy");
        var occurrenceBuilder = new SpanBatchBuilder(master);
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(0, 1), "witness", SpanLevel.Character, "fixture"));
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(1, 2), "witness", SpanLevel.Character, "fixture"));
        var occurrences = occurrenceBuilder.Freeze();
        var oldConclusion = new FactKey("shift", "Z", Array.Empty<TextSpan>(), new[] { "conclusion" });
        var oldPremise = new FactKey("shift", "Z", Array.Empty<TextSpan>(), new[] { "premise" });
        var insertedBefore = new FactKey("shift", "A", Array.Empty<TextSpan>(), new[] { "derived" });
        var initialFacts = CanonicalFactTable.Create(master, new[] { oldPremise, oldConclusion });
        True(initialFacts.TryGetOrdinal(oldConclusion, out var oldConclusionOrdinal), "shift fixture conclusion retained");
        True(initialFacts.TryGetOrdinal(oldPremise, out var oldPremiseOrdinal), "shift fixture premise retained");
        var originalReference = new FactReference(initialFacts, oldConclusionOrdinal);
        var initialEdge = new SupportEdge(
            oldConclusionOrdinal,
            "initial-edge",
            new[] { oldPremiseOrdinal },
            new[] { "kept" },
            new[] { 1, 0 });
        var initial = SupportHypergraph.Create(initialFacts, occurrences, new[] { initialEdge });
        var problem = SaturationProblem.Create(
            initial,
            new[]
            {
                new GroundRule(insertedBefore, "derive-before", new[] { oldPremise }, Array.Empty<string>(), new[] { 0 }),
                new GroundRule(oldConclusion, "enabled-late", new[] { insertedBefore }, Array.Empty<string>(), new[] { 1 }),
            });
        var result = FactSaturation.Saturate(problem);

        True(ReferenceEquals(problem, result.Problem), "saturation result retains exact problem reference");
        True(ReferenceEquals(occurrences, result.Graph.Occurrences), "saturation result retains exact occurrence batch");
        True(!ReferenceEquals(initial, result.Graph), "saturation result graph is newly frozen");
        True(!ReferenceEquals(initialFacts, result.Facts), "saturation result fact table is newly frozen");
        True(result.Facts.TryGetOrdinal(insertedBefore, out var insertedOrdinal), "order-shifting derived fact retained");
        True(result.Facts.TryGetOrdinal(oldConclusion, out var newConclusionOrdinal), "initial conclusion remapped");
        True(result.Facts.TryGetOrdinal(oldPremise, out var newPremiseOrdinal), "initial premise remapped");
        Equal(0, insertedOrdinal, "derived key sorts before initial keys");
        True(newConclusionOrdinal != oldConclusionOrdinal, "initial conclusion ordinal shifts after final freeze");
        True(newPremiseOrdinal != oldPremiseOrdinal, "initial premise ordinal shifts after final freeze");

        var rebased = result.Graph.Single(edge => StringComparer.Ordinal.Equals(edge.RuleId, "initial-edge"));
        Equal(newConclusionOrdinal, rebased.ConclusionOrdinal, "initial support conclusion rebased by semantic key");
        Equal(newPremiseOrdinal, rebased.PremiseOrdinals[0], "initial support premise rebased by semantic key");
        Equal("kept", rebased.Parameters[0], "initial support parameters preserved");
        Equal(1, rebased.OccurrenceOrdinals[0], "initial support occurrence order preserved");
        Equal(0, rebased.OccurrenceOrdinals[1], "initial support occurrence tail preserved");
        var derived = result.Graph.Single(edge => StringComparer.Ordinal.Equals(edge.RuleId, "derive-before"));
        Equal(insertedOrdinal, derived.ConclusionOrdinal, "derived support conclusion resolves in final table");
        Equal(newPremiseOrdinal, derived.PremiseOrdinals[0], "derived support premise resolves in final table");
        var late = result.Graph.Single(edge => StringComparer.Ordinal.Equals(edge.RuleId, "enabled-late"));
        Equal(newConclusionOrdinal, late.ConclusionOrdinal, "late support may conclude an initial fact");
        Equal(insertedOrdinal, late.PremiseOrdinals[0], "late support retains reached derived premise");

        True(originalReference.Key.Equals(oldConclusion), "original fact reference remains valid on original table");
        var resultReference = new FactReference(result.Facts, newConclusionOrdinal);
        True(originalReference != resultReference, "saturation does not rebind an original fact reference");
        True(originalReference.Key.Equals(resultReference.Key), "old and new references project the same semantic key");
    }

    private static void FactSaturationIsPermutationIndependent()
    {
        var master = new TextMaster("saturation-permutation", 0, "xy");
        var occurrenceBuilder = new SpanBatchBuilder(master);
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(0, 1), "witness", SpanLevel.Character, "fixture"));
        occurrenceBuilder.Add(new SpanClaim(new TextSpan(1, 2), "witness", SpanLevel.Character, "fixture"));
        var occurrences = occurrenceBuilder.Freeze();
        var a = SaturationFact("a");
        var b = SaturationFact("b");
        var c = SaturationFact("c");
        var d = SaturationFact("d");
        var seeds = new[] { a, b };
        var rules = new[]
        {
            new GroundRule(c, "a-to-c", new[] { a }, Array.Empty<string>(), new[] { 0 }),
            new GroundRule(c, "b-to-c", new[] { b }, Array.Empty<string>(), new[] { 1 }),
            new GroundRule(d, "c-to-d", new[] { c }, Array.Empty<string>(), new[] { 0, 1 }),
        };

        SaturationResult? reference = null;
        var caseCount = 0;
        foreach (var seedOrder in Permutations(seeds.Length))
        {
            var table = CanonicalFactTable.Create(master, seedOrder.Select(index => seeds[index]));
            int Ordinal(FactKey key)
            {
                if (!table.TryGetOrdinal(key, out var ordinal))
                {
                    throw new InvalidOperationException("Permutation fixture fact was not retained.");
                }

                return ordinal;
            }

            var supports = new[]
            {
                new SupportEdge(Ordinal(a), "initial-seed", Array.Empty<int>(), Array.Empty<string>(), new[] { 0 }),
                new SupportEdge(Ordinal(b), "initial-support", new[] { Ordinal(a) }, Array.Empty<string>(), new[] { 1 }),
            };
            foreach (var supportOrder in Permutations(supports.Length))
            {
                var initial = SupportHypergraph.Create(
                    table,
                    occurrences,
                    supportOrder.Select(index => supports[index]));
                foreach (var ruleOrder in Permutations(rules.Length))
                {
                    var problem = SaturationProblem.Create(
                        initial,
                        ruleOrder.Select(index => rules[index]));
                    var result = FactSaturation.Saturate(problem);
                    reference ??= result;
                    True(reference.Facts.Equals(result.Facts), "seed/rule/support permutation preserves facts");
                    Equal(reference.Graph.Count, result.Graph.Count, "seed/rule/support permutation preserves edge census");
                    var edgesAgree = true;
                    for (var i = 0; edgesAgree && i < reference.Graph.Count; i++)
                    {
                        edgesAgree = reference.Graph[i].Equals(result.Graph[i]);
                    }

                    True(edgesAgree, "seed/rule/support permutation preserves canonical edge sequence");
                    True(ReferenceEquals(occurrences, result.Graph.Occurrences), "permutation result retains exact occurrence batch");
                    caseCount++;
                }
            }
        }

        Equal(24, caseCount, "all seed, initial-support, and rule permutations exercised");
        Equal(4, reference!.Facts.Count, "permutation fixture reaches full fact closure");
        Equal(5, reference.Graph.Count, "permutation fixture retains initial and enabled support");
    }

    private static void K5bHierarchyDiamondSaturatesCanonically()
    {
        var master = new TextMaster("saturation-diamond", 0, "wxyz");
        var a = new TextSpan(1, 2);
        var b = new TextSpan(0, 3);
        var c = new TextSpan(1, 4);
        var d = new TextSpan(0, 4);
        var occurrenceBuilder = new SpanBatchBuilder(master);
        var occurrenceA = occurrenceBuilder.Add(new SpanClaim(a, "node", SpanLevel.Character, "witness"));
        var occurrenceB = occurrenceBuilder.Add(new SpanClaim(b, "node", SpanLevel.Character, "witness"));
        var occurrenceC = occurrenceBuilder.Add(new SpanClaim(c, "node", SpanLevel.Character, "witness"));
        var occurrenceD = occurrenceBuilder.Add(new SpanClaim(d, "node", SpanLevel.Character, "witness"));
        var occurrences = occurrenceBuilder.Freeze();

        FactKey Parent(TextSpan child, TextSpan parent) =>
            new("hier", "Parent", new[] { child, parent }, Array.Empty<string>());
        FactKey Ancestor(TextSpan child, TextSpan ancestor) =>
            new("hier", "Ancestor", new[] { child, ancestor }, Array.Empty<string>());

        var parentAb = Parent(a, b);
        var parentBd = Parent(b, d);
        var parentAc = Parent(a, c);
        var parentCd = Parent(c, d);
        var ancestorAb = Ancestor(a, b);
        var ancestorBd = Ancestor(b, d);
        var ancestorAc = Ancestor(a, c);
        var ancestorCd = Ancestor(c, d);
        var ancestorAd = Ancestor(a, d);
        var initial = SupportHypergraph.Create(
            CanonicalFactTable.Create(master, new[] { parentAb, parentBd, parentAc, parentCd }),
            occurrences,
            Array.Empty<SupportEdge>());
        var problem = SaturationProblem.Create(
            initial,
            new[]
            {
                new GroundRule(ancestorAb, "parent-is-ancestor", new[] { parentAb }, Array.Empty<string>(), new[] { occurrenceA, occurrenceB }),
                new GroundRule(ancestorBd, "parent-is-ancestor", new[] { parentBd }, Array.Empty<string>(), new[] { occurrenceB, occurrenceD }),
                new GroundRule(ancestorAc, "parent-is-ancestor", new[] { parentAc }, Array.Empty<string>(), new[] { occurrenceA, occurrenceC }),
                new GroundRule(ancestorCd, "parent-is-ancestor", new[] { parentCd }, Array.Empty<string>(), new[] { occurrenceC, occurrenceD }),
                new GroundRule(ancestorAd, "ancestor-parent-transitive", new[] { ancestorAb, parentBd }, Array.Empty<string>(), new[] { occurrenceA, occurrenceB, occurrenceD }),
                new GroundRule(ancestorAd, "ancestor-parent-transitive", new[] { ancestorAc, parentCd }, Array.Empty<string>(), new[] { occurrenceA, occurrenceC, occurrenceD }),
            });
        var result = FactSaturation.Saturate(problem);

        Equal(9, result.Facts.Count, "diamond retains four Parent and derives five Ancestor facts");
        Equal(6, result.Graph.Count, "diamond retains one edge per enabled ground rule");
        foreach (var parent in new[] { parentAb, parentBd, parentAc, parentCd })
        {
            True(result.Facts.TryGetOrdinal(parent, out var ordinal), "diamond Parent fact retained");
            Equal(0, result.Graph.SupportsOf(ordinal).Count, "diamond Parent fact remains unsupported");
        }

        foreach (var directAncestor in new[] { ancestorAb, ancestorBd, ancestorAc, ancestorCd })
        {
            True(result.Facts.TryGetOrdinal(directAncestor, out var ordinal), "diamond direct Ancestor derived");
            Equal(1, result.Graph.SupportsOf(ordinal).Count, "diamond direct Ancestor has one support");
        }

        True(result.Facts.TryGetOrdinal(ancestorAd, out var outerOrdinal), "diamond outer Ancestor derived once");
        var outerSupports = result.Graph.SupportsOf(outerOrdinal);
        Equal(2, outerSupports.Count, "diamond outer Ancestor retains two alternative supports");
        var viaB = outerSupports.Any(edge =>
            result.Facts[edge.PremiseOrdinals[0]].Equals(ancestorAb) &&
            result.Facts[edge.PremiseOrdinals[1]].Equals(parentBd));
        var viaC = outerSupports.Any(edge =>
            result.Facts[edge.PremiseOrdinals[0]].Equals(ancestorAc) &&
            result.Facts[edge.PremiseOrdinals[1]].Equals(parentCd));
        True(viaB, "diamond outer support through b retained in premise order");
        True(viaC, "diamond outer support through c retained in premise order");
        True(ReferenceEquals(occurrences, result.Graph.Occurrences), "diamond result retains exact occurrence basis");
    }

    private static void FactSaturationMatchesIndependentBoundedOracle()
    {
        var master = new TextMaster("saturation-census", 0, string.Empty);
        var occurrences = new SpanBatchBuilder(master).Freeze();
        var keys = new[] { SaturationFact("a"), SaturationFact("b") };
        var conclusions = new[] { 0, 1, 0, 1, 0, 1 };
        var premiseIndices = new[]
        {
            Array.Empty<int>(),
            Array.Empty<int>(),
            new[] { 0 },
            new[] { 0 },
            new[] { 1 },
            new[] { 1 },
        };
        var allRules = new GroundRule[conclusions.Length];
        for (var rule = 0; rule < allRules.Length; rule++)
        {
            allRules[rule] = new GroundRule(
                keys[conclusions[rule]],
                $"oracle-{rule}",
                premiseIndices[rule].Select(index => keys[index]),
                Array.Empty<string>(),
                Array.Empty<int>());
        }

        var initialGraphs = new SupportHypergraph[4];
        for (var seedMask = 0; seedMask < initialGraphs.Length; seedMask++)
        {
            var seeds = Enumerable.Range(0, keys.Length)
                .Where(index => (seedMask & (1 << index)) != 0)
                .Select(index => keys[index]);
            initialGraphs[seedMask] = SupportHypergraph.Create(
                CanonicalFactTable.Create(master, seeds),
                occurrences,
                Array.Empty<SupportEdge>());
        }

        string? failure = null;
        var cases = 0;
        for (var seedMask = 0; seedMask < initialGraphs.Length && failure is null; seedMask++)
        {
            for (var programMask = 0; programMask < (1 << allRules.Length); programMask++)
            {
                var selectedRules = Enumerable.Range(0, allRules.Length)
                    .Where(index => (programMask & (1 << index)) != 0)
                    .Select(index => allRules[index]);
                var problem = SaturationProblem.Create(initialGraphs[seedMask], selectedRules);
                var result = FactSaturation.Saturate(problem);
                var expectedMask = ClosedSupersetIntersectionOracle(
                    seedMask,
                    programMask,
                    conclusions,
                    premiseIndices,
                    keys.Length);
                var actualMask = 0;
                foreach (var fact in result.Facts)
                {
                    var index = Array.FindIndex(keys, key => key.Equals(fact));
                    if (index < 0)
                    {
                        failure = $"seed {seedMask}, program {programMask}: unexpected fact {fact}";
                        break;
                    }

                    actualMask |= 1 << index;
                }

                if (failure is not null)
                {
                    break;
                }

                if (actualMask != expectedMask)
                {
                    failure = $"seed {seedMask}, program {programMask}: expected fact mask {expectedMask}, actual {actualMask}";
                    break;
                }

                var expectedEnabled = new HashSet<int>();
                for (var rule = 0; rule < allRules.Length; rule++)
                {
                    if ((programMask & (1 << rule)) != 0 &&
                        OracleRuleEnabled(expectedMask, premiseIndices[rule]))
                    {
                        expectedEnabled.Add(rule);
                    }
                }

                var actualEnabled = new HashSet<int>();
                foreach (var edge in result.Graph)
                {
                    var rule = Array.FindIndex(
                        allRules,
                        candidate => StringComparer.Ordinal.Equals(candidate.RuleId, edge.RuleId));
                    if (rule < 0 || !expectedEnabled.Contains(rule) || !actualEnabled.Add(rule))
                    {
                        failure = $"seed {seedMask}, program {programMask}: unexpected or duplicate support {edge}";
                        break;
                    }

                    if (!result.Facts[edge.ConclusionOrdinal].Equals(keys[conclusions[rule]]) ||
                        edge.PremiseOrdinals.Count != premiseIndices[rule].Length)
                    {
                        failure = $"seed {seedMask}, program {programMask}: malformed support {edge}";
                        break;
                    }

                    for (var position = 0; position < premiseIndices[rule].Length; position++)
                    {
                        if (!result.Facts[edge.PremiseOrdinals[position]].Equals(
                                keys[premiseIndices[rule][position]]))
                        {
                            failure = $"seed {seedMask}, program {programMask}: support premise mismatch {edge}";
                            break;
                        }
                    }

                    if (failure is not null)
                    {
                        break;
                    }
                }

                if (failure is not null)
                {
                    break;
                }

                if (!actualEnabled.SetEquals(expectedEnabled))
                {
                    failure = $"seed {seedMask}, program {programMask}: enabled support set mismatch";
                    break;
                }

                cases++;
            }
        }

        True(failure is null, $"bounded powerset closure/support oracle agreement ({failure ?? "all cases"})");
        Equal(256, cases, "all two-fact zero/unary finite programs censused");
    }

    private static int ClosedSupersetIntersectionOracle(
        int seedMask,
        int programMask,
        IReadOnlyList<int> conclusions,
        IReadOnlyList<int[]> premises,
        int factCount)
    {
        var allFactsMask = (1 << factCount) - 1;
        var intersection = allFactsMask;
        var closedSupersetFound = false;
        for (var candidate = 0; candidate <= allFactsMask; candidate++)
        {
            if ((candidate & seedMask) != seedMask)
            {
                continue;
            }

            var closed = true;
            for (var rule = 0; rule < conclusions.Count; rule++)
            {
                if ((programMask & (1 << rule)) != 0 &&
                    OracleRuleEnabled(candidate, premises[rule]) &&
                    (candidate & (1 << conclusions[rule])) == 0)
                {
                    closed = false;
                    break;
                }
            }

            if (closed)
            {
                intersection &= candidate;
                closedSupersetFound = true;
            }
        }

        if (!closedSupersetFound)
        {
            throw new InvalidOperationException("The finite universe must itself be a closed seed superset.");
        }

        return intersection;
    }

    private static bool OracleRuleEnabled(int factMask, IReadOnlyList<int> premises)
    {
        foreach (var premise in premises)
        {
            if ((factMask & (1 << premise)) == 0)
            {
                return false;
            }
        }

        return true;
    }

    private static FactKey SaturationFact(string value) =>
        new("sat", "Fact", Array.Empty<TextSpan>(), new[] { value });
}
