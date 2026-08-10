using System;
using System.Collections.Generic;
using System.Linq;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static void Utf16UnitMaskEnforcesBasisAndTypedContinuity()
    {
        var master = new TextMaster("unit-mask", 3, "a😀bc");
        var compatible = new TextMaster("unit-mask", 3, "a😀bc");
        var foreign = new TextMaster("unit-mask-foreign", 3, "a😀bc");
        var window = new TextSpan(2, 4);
        var vector = BooleanVector.Create(2, new[] { 0 });
        var mask = new Utf16UnitMask(master, window, vector);

        True(!master.TopologyIsCreated, "unit-mask construction does not force scalar topology");
        True(ReferenceEquals(master, mask.Master), "unit mask retains exact master");
        True(ReferenceEquals(vector, mask.Vector), "unit mask retains exact Boolean vector");
        Equal(window, mask.Window, "unit mask retains numeric window including surrogate interior");
        Equal(2, mask.Length, "unit-mask length follows vector/window");
        Equal(1, mask.Population, "unit-mask population delegates to vector");
        True(mask[0] && !mask[1], "unit-mask local bit lookup");
        True(mask.ContainsOffset(2) && !mask.ContainsOffset(3), "unit-mask absolute bit lookup");
        True(mask.SequenceEqual(new[] { 2 }), "unit mask enumerates ascending absolute offsets");
        True(!master.TopologyIsCreated, "direct offset exit does not force scalar topology");

        var twin = new Utf16UnitMask(compatible, window, BooleanVector.Create(2, new[] { 0 }));
        True(mask.Equals(twin), "compatible-master equal-window masks are equal values");
        Equal(mask.GetHashCode(), twin.GetHashCode(), "equal compatible-master masks hash equally");
        True(!master.TopologyIsCreated, "mask equality and hashing do not force scalar topology");

        var right = new Utf16UnitMask(compatible, window, BooleanVector.Create(2, new[] { 1 }));
        var union = mask.Union(right);
        True(ReferenceEquals(master, union.Master), "unit-mask binary algebra retains left exact master");
        True(union.SequenceEqual(new[] { 2, 3 }), "unit-mask union");
        True(mask.Intersect(right).IsEmpty, "unit-mask intersection");
        True(mask.SymmetricDifference(right).SequenceEqual(new[] { 2, 3 }), "unit-mask symmetric difference");
        True(mask.Subtract(right).Equals(mask), "unit-mask subtraction");
        True(mask.Complement().SequenceEqual(new[] { 3 }), "unit-mask complement stays in exact window");
        True(mask.ShiftTowardHigherOrdinals(1).SequenceEqual(new[] { 3 }), "unit-mask higher shift");
        True(mask.ShiftTowardLowerOrdinals(1).IsEmpty, "unit-mask lower shift");

        var otherWindow = new Utf16UnitMask(master, new TextSpan(1, 3), BooleanVector.None(2));
        var incompatibleMasks = new[]
        {
            new Utf16UnitMask(foreign, window, BooleanVector.None(2)),
            new Utf16UnitMask(new TextMaster("unit-mask", 4, "a😀bc"), window, BooleanVector.None(2)),
            new Utf16UnitMask(new TextMaster("unit-mask", 3, "a😀bd"), window, BooleanVector.None(2)),
            new Utf16UnitMask(new TextMaster("unit-mask", 3, "a😀b"), window, BooleanVector.None(2)),
        };
        Throws<InvalidOperationException>(() => mask.Union(otherWindow), "unequal unit windows refused");
        True(
            incompatibleMasks.All(candidate => V1RefusesInvalidOperation(() => mask.Union(candidate))),
            "document, revision, text, and length incompatible unit masters are refused");
        Throws<ArgumentNullException>(() => mask.Union(null!), "null unit-mask operand refused");
        Throws<ArgumentNullException>(
            () => new Utf16UnitMask(null!, new TextSpan(0, 0), BooleanVector.None(0)),
            "unit mask requires a master");
        Throws<ArgumentNullException>(() => new Utf16UnitMask(master, window, null!), "unit mask requires a vector");
        Throws<ArgumentOutOfRangeException>(
            () => new Utf16UnitMask(master, new TextSpan(0, master.Length + 1), BooleanVector.None(master.Length + 1)),
            "unit mask window must stay in range");
        Throws<ArgumentException>(
            () => new Utf16UnitMask(master, window, BooleanVector.None(1)),
            "unit mask vector length must equal window length");
        Throws<ArgumentOutOfRangeException>(() => mask.ContainsOffset(1), "absolute lookup before window refused");
        Throws<ArgumentOutOfRangeException>(() => mask.ContainsOffset(4), "absolute lookup at window end refused");

        var fullEvents = new Utf16UnitMask(
            master,
            master.Extent,
            BooleanVector.Create(master.Length, new[] { 0, 2, 4 }));
        var oneShot = fullEvents.PrefixParity(true);
        True(ReferenceEquals(fullEvents, oneShot.Input), "one-shot UTF-16 scan retains exact input");
        True(oneShot.States.SequenceEqual(new[] { 2, 3 }), "one-shot UTF-16 scan state offsets");
        True(!oneShot.CarryOut, "one-shot UTF-16 scan carry-out");
        True(ReferenceEquals(master, oneShot.Continuation.Master), "one-shot continuation retains exact master");
        Equal(master.Length, oneShot.Continuation.NextOffset, "one-shot continuation advances to window end");

        var firstChunk = new Utf16UnitMask(master, new TextSpan(0, 2), BooleanVector.Create(2, new[] { 0 }));
        var secondChunk = new Utf16UnitMask(
            compatible,
            new TextSpan(2, master.Length),
            BooleanVector.Create(master.Length - 2, new[] { 0, 2 }));
        var seed = Utf16PrefixParityContinuation.Seed(master, 0, true);
        var first = seed.Continue(firstChunk);
        var second = first.Continuation.Continue(secondChunk);
        var joinedStates = V1ConcatVectors(first.States.Vector, second.States.Vector);
        True(joinedStates.Equals(oneShot.States.Vector), "typed UTF-16 chunk scan equals one-shot scan");
        Equal(oneShot.CarryOut, second.CarryOut, "typed UTF-16 chunk carry equals one-shot carry");
        True(ReferenceEquals(master, second.Continuation.Master), "typed continuation retains seed master across compatible clone");
        Equal(master.Length, second.Continuation.NextOffset, "typed continuation advances exact end");
        True(ReferenceEquals(secondChunk, second.Input), "continued scan retains exact input chunk");

        var gap = new Utf16UnitMask(master, new TextSpan(3, 4), BooleanVector.None(1));
        var overlap = new Utf16UnitMask(master, new TextSpan(1, 3), BooleanVector.None(2));
        var wrongBasis = new Utf16UnitMask(foreign, new TextSpan(2, 3), BooleanVector.None(1));
        Throws<InvalidOperationException>(() => first.Continuation.Continue(gap), "typed continuation refuses gap");
        Throws<InvalidOperationException>(() => first.Continuation.Continue(overlap), "typed continuation refuses overlap");
        Throws<InvalidOperationException>(() => first.Continuation.Continue(wrongBasis), "typed continuation refuses wrong basis");
        Throws<ArgumentNullException>(() => first.Continuation.Continue(null!), "typed continuation requires next mask");

        var interiorSeed = Utf16PrefixParityContinuation.Seed(master, 2, true);
        Equal(2, interiorSeed.NextOffset, "typed continuation may seed inside surrogate pair");
        True(interiorSeed.Carry, "typed continuation retains entering carry");
        var emptyChunk = new Utf16UnitMask(master, new TextSpan(2, 2), BooleanVector.None(0));
        var emptyResult = interiorSeed.Continue(emptyChunk);
        True(emptyResult.States.IsEmpty && emptyResult.CarryOut, "empty UTF-16 chunk preserves carry");
        Equal(2, emptyResult.Continuation.NextOffset, "empty UTF-16 chunk preserves next offset");
        Throws<ArgumentOutOfRangeException>(
            () => Utf16PrefixParityContinuation.Seed(master, -1),
            "typed continuation refuses negative seed");
        Throws<ArgumentOutOfRangeException>(
            () => Utf16PrefixParityContinuation.Seed(master, master.Length + 1),
            "typed continuation refuses past-end seed");
        Throws<ArgumentNullException>(
            () => Utf16PrefixParityContinuation.Seed(null!, 0),
            "typed continuation requires a master");
        True(!master.TopologyIsCreated, "typed scans do not force scalar topology");
    }

    private static void Utf16UnitClassificationPropagatesUncertainty()
    {
        var stamp = new UnitClassifierStamp("word-boundary-events");
        var sameName = new UnitClassifierStamp("word-boundary-events");
        True(!stamp.Equals(sameName), "classifier stamps use exact reference identity");
        Equal("word-boundary-events", stamp.Name, "classifier stamp retains required name");
        Throws<ArgumentException>(() => new UnitClassifierStamp(" "), "classifier stamp requires a name");

        var master = new TextMaster("classified-units", 0, "abcdef");
        var window = new TextSpan(1, 6);
        var matches = new Utf16UnitMask(master, window, BooleanVector.Create(5, new[] { 0, 2, 4 }));
        var unknown = new Utf16UnitMask(master, window, BooleanVector.Create(5, new[] { 3 }));
        var classification = new Utf16UnitClassification(stamp, matches, unknown);
        True(ReferenceEquals(stamp, classification.Classifier), "classification retains exact classifier stamp");
        True(ReferenceEquals(matches, classification.Matches), "classification retains exact match mask");
        True(ReferenceEquals(unknown, classification.Unknown), "classification retains exact unknown mask");
        True(!classification.IsComplete, "nonempty classifier unknown population marks incompleteness");

        var falseScan = classification.PrefixParity(UnitTruthState.KnownFalse);
        True(ReferenceEquals(classification, falseScan.Source), "classified scan retains exact source classification");
        True(ReferenceEquals(stamp, falseScan.Classifier), "classified scan retains exact classifier stamp");
        True(falseScan.KnownTrueStates.SequenceEqual(new[] { 1, 2 }), "known-false scan reports known-true prefix");
        True(falseScan.UnknownStates.SequenceEqual(new[] { 4, 5 }), "first unknown event propagates uncertainty suffix");
        Equal(UnitTruthState.Unknown, falseScan.CarryOut, "unknown suffix produces unknown carry-out");
        True(
            falseScan.KnownTrueStates.Intersect(falseScan.UnknownStates).IsEmpty,
            "classified known and propagated-unknown states are disjoint");

        var trueScan = classification.PrefixParity(UnitTruthState.KnownTrue);
        True(trueScan.KnownTrueStates.SequenceEqual(new[] { 3 }), "known-true entering state is honored");
        True(trueScan.UnknownStates.SequenceEqual(new[] { 4, 5 }), "uncertainty suffix is carry-independent after entry");
        var unknownScan = classification.PrefixParity(UnitTruthState.Unknown);
        True(unknownScan.KnownTrueStates.IsEmpty, "unknown entering state yields no known-true states");
        True(unknownScan.UnknownStates.SequenceEqual(Enumerable.Range(1, 5)), "unknown entering state taints whole window");
        Equal(UnitTruthState.Unknown, unknownScan.CarryOut, "unknown entering state yields unknown carry-out");

        var complete = new Utf16UnitClassification(
            stamp,
            matches,
            new Utf16UnitMask(master, window, BooleanVector.None(5)));
        True(complete.IsComplete, "empty classifier unknown population marks completeness");
        var completeScan = complete.PrefixParity();
        True(completeScan.KnownTrueStates.SequenceEqual(new[] { 1, 2, 5 }), "complete classified scan matches Boolean scan");
        True(completeScan.UnknownStates.IsEmpty, "complete classified scan has no propagated unknowns");
        Equal(UnitTruthState.KnownTrue, completeScan.CarryOut, "complete classified scan has known carry-out");

        var overlap = new Utf16UnitMask(master, window, BooleanVector.Create(5, new[] { 2 }));
        Throws<ArgumentException>(
            () => new Utf16UnitClassification(stamp, matches, overlap),
            "classification match and unknown masks must be disjoint");
        Throws<InvalidOperationException>(
            () => new Utf16UnitClassification(
                stamp,
                matches,
                new Utf16UnitMask(master, new TextSpan(0, 5), BooleanVector.None(5))),
            "classification masks require equal windows");
        Throws<ArgumentNullException>(
            () => new Utf16UnitClassification(null!, matches, unknown),
            "classification requires a stamp");
        Throws<ArgumentNullException>(
            () => new Utf16UnitClassification(stamp, null!, unknown),
            "classification requires matches");
        Throws<ArgumentNullException>(
            () => new Utf16UnitClassification(stamp, matches, null!),
            "classification requires unknown mask");
        Throws<ArgumentOutOfRangeException>(
            () => classification.PrefixParity((UnitTruthState)99),
            "classified scan refuses undefined entering evidence");
        True(
            typeof(Utf16UnitClassification).GetMethod("Union") is null,
            "classifier result exposes no misleading Boolean algebra");
    }

    private static void Utf16UnitHarvestIsScalarSafeAndComplete()
    {
        var master = new TextMaster("unit-harvest", 0, "A😀BC\uD800D");
        var wholeWindow = master.Extent;
        var partialSource = new Utf16UnitMask(
            master,
            wholeWindow,
            BooleanVector.Create(master.Length, new[] { 0, 1, 3, 5 }));
        True(!master.TopologyIsCreated, "direct unit mask remains topology-lazy before harvest");
        var partial = partialSource.HarvestScalarSpans();
        True(master.TopologyIsCreated, "scalar-safe harvest explicitly consults topology atoms");
        True(ReferenceEquals(partialSource, partial.SourceMask), "plain harvest retains exact source mask");
        True(partial.SourceClassification is null, "plain harvest has no classifier source");
        Equal(3, partial.AdmittedSpans.Count, "complete separated atoms survive harvest");
        Equal(new TextSpan(0, 1), partial.AdmittedSpans[0], "BMP atom admitted");
        Equal(new TextSpan(3, 4), partial.AdmittedSpans[1], "later BMP atom admitted");
        Equal(new TextSpan(5, 6), partial.AdmittedSpans[2], "unpaired surrogate atom admitted");
        True(partial.BoundaryResidual.SequenceEqual(new[] { 1 }), "half-selected surrogate pair is boundary residue");
        True(partial.ClassifierUnknown.IsEmpty, "plain harvest has empty classifier-unknown residue");
        Equal(
            partialSource.Population,
            checked((int)partial.AdmittedSpans.Coverage) + partial.BoundaryResidual.Population,
            "plain harvest accounts for every selected code unit");

        var fullPair = new Utf16UnitMask(master, new TextSpan(1, 3), BooleanVector.All(2)).HarvestScalarSpans();
        Equal(1, fullPair.AdmittedSpans.Count, "full surrogate pair admitted as one topology atom");
        Equal(new TextSpan(1, 3), fullPair.AdmittedSpans[0], "full surrogate pair extent retained");
        True(fullPair.BoundaryResidual.IsEmpty, "full surrogate pair has no boundary residue");

        var splitWindow = new Utf16UnitMask(
            master,
            new TextSpan(2, 4),
            BooleanVector.All(2)).HarvestScalarSpans();
        Equal(1, splitWindow.AdmittedSpans.Count, "complete BMP atom admitted beside split pair");
        Equal(new TextSpan(3, 4), splitWindow.AdmittedSpans[0], "complete atom in split window retained");
        True(splitWindow.BoundaryResidual.SequenceEqual(new[] { 2 }), "window-cut pair remains boundary residue");

        var lone = new Utf16UnitMask(master, new TextSpan(5, 6), BooleanVector.All(1)).HarvestScalarSpans();
        Equal(new TextSpan(5, 6), lone.AdmittedSpans[0], "unpaired surrogate is a complete one-unit atom");
        True(lone.BoundaryResidual.IsEmpty, "complete unpaired-surrogate atom is not residue");

        var all = new Utf16UnitMask(master, wholeWindow, BooleanVector.All(master.Length)).HarvestScalarSpans();
        Equal(1, all.AdmittedSpans.Count, "adjacent admitted atoms normalize into one SpanSet member");
        Equal(wholeWindow, all.AdmittedSpans[0], "whole selected topology normalizes to master extent");

        var emptyMaster = new TextMaster("empty-harvest", 0, "X");
        var emptySource = new Utf16UnitMask(emptyMaster, new TextSpan(1, 1), BooleanVector.None(0));
        var empty = emptySource.HarvestScalarSpans();
        True(empty.AdmittedSpans.Count == 0 && empty.BoundaryResidual.IsEmpty, "empty mask has empty harvest");
        True(!emptyMaster.TopologyIsCreated, "empty harvest need not materialize scalar topology");

        var lazyMaster = new TextMaster("direct-offset-lazy", 0, "😀");
        var lazyMask = new Utf16UnitMask(lazyMaster, new TextSpan(1, 2), BooleanVector.All(1));
        True(lazyMask.SequenceEqual(new[] { 1 }), "direct offset exit translates split-pair unit");
        True(!lazyMaster.TopologyIsCreated, "direct offset exit has no topology dependency");
        var lazyHarvest = lazyMask.HarvestScalarSpans();
        True(lazyMaster.TopologyIsCreated, "harvest is the explicit topology-dependent exit");
        True(lazyHarvest.BoundaryResidual.SequenceEqual(new[] { 1 }), "split-pair direct offset becomes harvest residue");

        var stamp = new UnitClassifierStamp("classified-harvest");
        var knownMatches = new Utf16UnitMask(
            master,
            wholeWindow,
            BooleanVector.Create(master.Length, new[] { 0, 1, 3 }));
        var classifierUnknown = new Utf16UnitMask(
            master,
            wholeWindow,
            BooleanVector.Create(master.Length, new[] { 2, 4, 6 }));
        var classification = new Utf16UnitClassification(stamp, knownMatches, classifierUnknown);
        var classified = classification.HarvestScalarSpans();
        True(ReferenceEquals(classification, classified.SourceClassification), "classified harvest retains exact classification");
        True(ReferenceEquals(knownMatches, classified.SourceMask), "classified harvest retains exact known-match mask");
        True(ReferenceEquals(classifierUnknown, classified.ClassifierUnknown), "classified harvest retains exact unknown mask separately");
        Equal(2, classified.AdmittedSpans.Count, "classified harvest admits complete known-match atoms");
        Equal(new TextSpan(0, 1), classified.AdmittedSpans[0], "classified first known atom admitted");
        Equal(new TextSpan(3, 4), classified.AdmittedSpans[1], "classified second known atom admitted");
        True(classified.BoundaryResidual.SequenceEqual(new[] { 1 }), "classified partial known atom is boundary residue");
        Equal(
            knownMatches.Population,
            checked((int)classified.AdmittedSpans.Coverage) + classified.BoundaryResidual.Population,
            "classified harvest accounts for every known match");
        True(
            classified.AdmittedSpans.All(span =>
                Enumerable.Range(span.Start, span.Length).All(offset => !classifierUnknown.ContainsOffset(offset))),
            "classifier unknown units are never emitted as admitted matches");
    }

    private static void Utf16ClaimEmissionIsTransactionalAndEvidenceBearing()
    {
        var master = new TextMaster("unit-emission", 0, "A😀B");
        var compatible = new TextMaster("unit-emission", 0, "A😀B");
        var source = new Utf16UnitMask(
            master,
            master.Extent,
            BooleanVector.Create(master.Length, new[] { 0, 3 }));
        var harvest = source.HarvestScalarSpans();
        Equal(2, harvest.AdmittedSpans.Count, "emission fixture has two separated admitted spans");

        var evidence = new UnitMaskClaimStamp(
            "word",
            SpanLevel.Character,
            "unit-classifier",
            priority: 7,
            ruleId: "unit-rule");
        Equal("word", evidence.Kind, "claim stamp retains kind");
        Equal(SpanLevel.Character, evidence.Level, "claim stamp retains level");
        Equal("unit-classifier", evidence.Source, "claim stamp retains source");
        Equal(7, evidence.Priority, "claim stamp retains priority");
        Equal("unit-rule", evidence.RuleId, "claim stamp retains optional rule ID");

        var builder = new SpanBatchBuilder(master);
        builder.Add(new SpanClaim(new TextSpan(1, 3), "existing", SpanLevel.Character, "fixture"));
        var emission = harvest.EmitClaims(builder, evidence);
        True(ReferenceEquals(harvest, emission.Harvest), "claim emission retains exact harvest");
        True(ReferenceEquals(builder, emission.Builder), "claim emission retains exact destination builder");
        True(ReferenceEquals(evidence, emission.Evidence), "claim emission retains exact evidence stamp");
        True(emission.Ordinals.SequenceEqual(new[] { 1, 2 }), "claim emission returns created ordinals in span order");
        Equal(3, builder.Count, "claim emission appends every admitted span");

        var batch = builder.Freeze();
        Equal(new TextSpan(0, 1), batch[1].Span, "first emitted claim span ascending");
        Equal(new TextSpan(3, 4), batch[2].Span, "second emitted claim span ascending");
        Equal(evidence.Kind, batch[1].Kind, "emitted claim kind copied from evidence");
        Equal(evidence.Level, batch[1].Level, "emitted claim level copied from evidence");
        Equal(evidence.Source, batch[1].Source, "emitted claim source copied from evidence");
        Equal(evidence.Priority, batch[1].Priority, "emitted claim priority copied from evidence");
        Equal(evidence.RuleId, batch[1].RuleId, "emitted claim rule ID copied from evidence");
        Throws<InvalidOperationException>(() => harvest.EmitClaims(builder, evidence), "emission refuses frozen builder");
        Equal(3, builder.Count, "frozen-builder refusal has no partial mutation");

        var twinBuilder = new SpanBatchBuilder(compatible);
        var twinEmission = harvest.EmitClaims(twinBuilder, evidence);
        True(twinEmission.Ordinals.SequenceEqual(new[] { 0, 1 }), "compatible-master builder accepts emission");
        True(ReferenceEquals(twinBuilder, twinEmission.Builder), "compatible emission retains exact destination");

        var foreignBuilder = new SpanBatchBuilder(new TextMaster("foreign-emission", 0, "A😀B"));
        Throws<InvalidOperationException>(
            () => harvest.EmitClaims(foreignBuilder, evidence),
            "emission refuses incompatible builder basis");
        Equal(0, foreignBuilder.Count, "incompatible-builder refusal precedes every add");
        Throws<ArgumentNullException>(() => harvest.EmitClaims(null!, evidence), "emission requires builder");
        Throws<ArgumentNullException>(() => harvest.EmitClaims(new SpanBatchBuilder(master), null!), "emission requires evidence");

        var residualSource = new Utf16UnitMask(
            master,
            master.Extent,
            BooleanVector.Create(master.Length, new[] { 0, 1 }));
        var residualHarvest = residualSource.HarvestScalarSpans();
        True(residualHarvest.BoundaryResidual.SequenceEqual(new[] { 1 }), "residual emission fixture retains partial atom");
        var residualBuilder = new SpanBatchBuilder(master);
        var residualEmission = residualHarvest.EmitClaims(residualBuilder, evidence);
        True(residualEmission.Ordinals.SequenceEqual(new[] { 0 }), "emission writes admitted span despite retained residue");
        True(residualHarvest.BoundaryResidual.SequenceEqual(new[] { 1 }), "claim emission does not clear boundary residue");

        var residueOnly = new Utf16UnitMask(
            master,
            master.Extent,
            BooleanVector.Create(master.Length, new[] { 1 })).HarvestScalarSpans();
        var emptyBuilder = new SpanBatchBuilder(master);
        var emptyEmission = residueOnly.EmitClaims(emptyBuilder, evidence);
        Equal(0, emptyEmission.Ordinals.Count, "residue-only harvest emits no claims");
        Equal(0, emptyBuilder.Count, "residue-only emission leaves builder unchanged");
        emptyBuilder.Freeze();
        Throws<InvalidOperationException>(
            () => residueOnly.EmitClaims(emptyBuilder, evidence),
            "even empty emission requires an unfrozen builder");

        Throws<ArgumentException>(
            () => new UnitMaskClaimStamp(" ", SpanLevel.Character, "source"),
            "claim stamp requires kind");
        Throws<ArgumentOutOfRangeException>(
            () => new UnitMaskClaimStamp("kind", (SpanLevel)99, "source"),
            "claim stamp requires defined level");
        Throws<ArgumentException>(
            () => new UnitMaskClaimStamp("kind", SpanLevel.Character, " "),
            "claim stamp requires source");
    }

    private static void BooleanVectorSupportsATestLocalByteBasis()
    {
        var bytes = new byte[] { 9, 0, 1, 0, 1, 1, 0, 8 };
        var events = BooleanVector.Create(6, new[] { 1, 3, 4 });
        var probe = new ByteUnitMaskProbe(bytes, start: 1, events);
        bytes[2] = 0;

        Equal(1, probe.Start, "test-local byte mask retains numeric start");
        Equal(6, probe.Length, "test-local byte mask length follows raw vector");
        var complementProbe = new ByteUnitMaskProbe(bytes, probe.Start, events.Not());
        True(
            probe.EventOffsets().SequenceEqual(new[] { 2, 4, 5 }) &&
            complementProbe.EventOffsets().SequenceEqual(new[] { 1, 3, 6 }),
            "raw Boolean algebra translates over byte offsets");
        True(probe.Units.SequenceEqual(new byte[] { 0, 1, 0, 1, 1, 0 }), "test-local byte basis is snapshotted");

        var scan = probe.PrefixParity(true);
        var expected = new[] { true, false, false, true, false, false };
        True(V1VectorMatchesBits(scan.Vector, expected), "raw prefix scan is basis-neutral over byte units");
        True(!scan.CarryOut, "byte-backed raw scan carry agrees with per-bit oracle");
        var firstEvents = BooleanVector.Create(3, new[] { 1 });
        var secondEvents = BooleanVector.Create(3, new[] { 0, 1 });
        var firstProbe = new ByteUnitMaskProbe(probe.Units, 0, firstEvents);
        var secondProbe = new ByteUnitMaskProbe(probe.Units, 3, secondEvents);
        var firstScan = firstProbe.PrefixParity(true);
        var secondScan = secondProbe.PrefixParity(firstScan.CarryOut);
        True(
            scan.Vector.AdjacentTransitions(true).Equals(events) &&
            V1ConcatVectors(firstScan.Vector, secondScan.Vector).Equals(scan.Vector) &&
            secondScan.CarryOut == scan.CarryOut,
            "byte-backed raw scan inverse and chunk law hold");

        True(
            typeof(BooleanVector).GetMethods().All(method =>
                method.ReturnType != typeof(TextMaster) &&
                method.GetParameters().All(parameter => parameter.ParameterType != typeof(TextMaster))),
            "BooleanVector public methods carry no TextMaster dependency");
        True(
            typeof(BooleanVector).Assembly.GetType("CodexSci.Doccer.ByteUnitMask") is null,
            "byte neutrality probe does not widen the public engine surface");
    }

    private sealed class ByteUnitMaskProbe
    {
        private readonly byte[] _units;

        public ByteUnitMaskProbe(IReadOnlyList<byte> basis, int start, BooleanVector events)
        {
            ArgumentNullException.ThrowIfNull(basis);
            ArgumentNullException.ThrowIfNull(events);
            if (start < 0 || start > basis.Count || events.Length > basis.Count - start)
            {
                throw new ArgumentOutOfRangeException(nameof(start));
            }

            Start = start;
            Events = events;
            _units = new byte[events.Length];
            for (var i = 0; i < _units.Length; i++)
            {
                _units[i] = basis[start + i];
            }
        }

        public int Start { get; }

        public int Length => Events.Length;

        public BooleanVector Events { get; }

        public IReadOnlyList<byte> Units => Array.AsReadOnly(_units);

        public IEnumerable<int> EventOffsets() => Events.Select(ordinal => Start + ordinal);

        public BooleanPrefixParityResult PrefixParity(bool carryIn) => Events.PrefixParity(carryIn);
    }

    private static bool V1RefusesInvalidOperation(Action action)
    {
        try
        {
            action();
            return false;
        }
        catch (InvalidOperationException)
        {
            return true;
        }
    }
}
