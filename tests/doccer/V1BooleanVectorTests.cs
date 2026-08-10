using System;
using System.Collections.Generic;
using System.Linq;
using CodexSci.Doccer;

namespace CodexSci.Doccer.Tests;

internal static partial class Program
{
    private static void BooleanVectorIsALogicalSequenceValue()
    {
        var supplied = new List<int> { 64, 0, 2, 2 };
        var vector = BooleanVector.Create(65, supplied);
        supplied.Clear();

        Equal(65, vector.Length, "Boolean vector retains logical length");
        Equal(3, vector.Population, "Boolean vector coalesces repeated set ordinals");
        Equal(vector.Population, vector.Count, "Boolean vector collection count is population");
        True(!vector.IsEmpty, "populated Boolean vector is not empty");
        True(vector[0] && vector[2] && vector[64] && !vector[1], "Boolean vector bit lookup");
        True(vector.SequenceEqual(new[] { 0, 2, 64 }), "Boolean vector enumerates set ordinals ascending");

        var equal = BooleanVector.Create(65, new[] { 2, 64, 0 });
        True(vector.Equals(equal), "Boolean vector identity ignores proposal order");
        Equal(vector.GetHashCode(), equal.GetHashCode(), "equal Boolean vectors hash equally");
        True(!vector.Equals(BooleanVector.Create(66, new[] { 0, 2, 64 })), "logical length participates in identity");

        var poisoned = BooleanVector.FromPhysicalWordsForTesting(65, new[] { 5UL, ulong.MaxValue });
        True(poisoned.Equals(vector), "unused physical tail is absent from Boolean identity");
        Equal(vector.GetHashCode(), poisoned.GetHashCode(), "unused physical tail is absent from hashing");
        Equal(3, poisoned.Population, "unused physical tail is absent from population");
        True(poisoned.SequenceEqual(vector), "unused physical tail is absent from enumeration");
        Equal(vector.Parity(), poisoned.Parity(), "unused physical tail is absent from parity");
        True(poisoned.Not().Equals(vector.Not()), "unused physical tail is absent from complement");
        True(
            poisoned.ShiftTowardLowerOrdinals(1).Equals(vector.ShiftTowardLowerOrdinals(1)),
            "unused physical tail is absent from shifts");
        True(
            poisoned.PrefixParity(true).Vector.Equals(vector.PrefixParity(true).Vector),
            "unused physical tail is absent from scans");

        var none = BooleanVector.None(0);
        var all = BooleanVector.All(0);
        Equal(0, none.Length, "zero-length Boolean vector exists");
        True(none.IsEmpty && none.Equals(all), "zero-length none and all coincide");
        True(!none.Parity(), "zero-length parity is false");
        True(!none.GetEnumerator().MoveNext(), "zero-length enumeration is empty");
        var emptyFalse = none.PrefixParity(false);
        var emptyTrue = none.PrefixParity(true);
        True(emptyFalse.Vector.IsEmpty && !emptyFalse.CarryOut, "empty scan preserves false carry");
        True(emptyTrue.Vector.IsEmpty && emptyTrue.CarryOut, "empty scan preserves true carry");
        True(none.AdjacentTransitions(true).IsEmpty, "empty transition inverse is empty");

        Equal(65, BooleanVector.All(65).Population, "all-vector population includes only logical bits");
        True(vector.ShiftTowardHigherOrdinals(0).Equals(vector), "zero higher shift is a value no-op");
        True(vector.ShiftTowardLowerOrdinals(65).IsEmpty, "full-width lower shift clears the vector");
        True(vector.ShiftTowardHigherOrdinals(66).IsEmpty, "over-width higher shift clears the vector");

        Throws<ArgumentOutOfRangeException>(() => BooleanVector.None(-1), "negative vector length refused");
        Throws<ArgumentNullException>(() => BooleanVector.Create(1, null!), "null set population refused");
        Throws<ArgumentOutOfRangeException>(() => BooleanVector.Create(1, new[] { -1 }), "negative set ordinal refused");
        Throws<ArgumentOutOfRangeException>(() => BooleanVector.Create(1, new[] { 1 }), "past-end set ordinal refused");
        Throws<ArgumentOutOfRangeException>(() => _ = vector[-1], "negative bit lookup refused");
        Throws<ArgumentOutOfRangeException>(() => _ = vector[65], "past-end bit lookup refused");
        Throws<ArgumentOutOfRangeException>(
            () => vector.ShiftTowardHigherOrdinals(-1),
            "negative higher shift refused");
        Throws<ArgumentOutOfRangeException>(
            () => vector.ShiftTowardLowerOrdinals(-1),
            "negative lower shift refused");
        Throws<ArgumentException>(() => vector.Or(BooleanVector.None(64)), "unequal OR lengths refused");
        Throws<ArgumentException>(() => vector.And(BooleanVector.None(64)), "unequal AND lengths refused");
        Throws<ArgumentException>(() => vector.Xor(BooleanVector.None(64)), "unequal XOR lengths refused");
        Throws<ArgumentException>(() => vector.AndNot(BooleanVector.None(64)), "unequal AND-NOT lengths refused");
        Throws<ArgumentNullException>(() => vector.Or(null!), "null binary vector refused");
        Throws<ArgumentException>(
            () => BooleanVector.FromPhysicalWordsForTesting(65, new[] { 0UL }),
            "physical assurance seam validates word count");
    }

    private static void BooleanVectorAlgebraMatchesIndependentOracle()
    {
        var agrees = true;
        var failure = string.Empty;
        var vectorCases = 0;
        var orderedPairs = 0;

        void Fail(string message)
        {
            if (agrees)
            {
                agrees = false;
                failure = message;
            }
        }

        for (var length = 0; length <= 8; length++)
        {
            var valueCount = 1 << length;
            var logicalMask = valueCount - 1;
            var vectors = new BooleanVector[valueCount];
            for (var bits = 0; bits < valueCount; bits++)
            {
                var vector = V1VectorFromMask(length, bits);
                vectors[bits] = vector;
                vectorCases++;
                if (!V1VectorMatchesMask(vector, length, bits))
                {
                    Fail($"raw value mismatch at length {length}, bits {bits}");
                }

                if (vector.Parity() != ((V1PopCount(bits) & 1) != 0))
                {
                    Fail($"parity mismatch at length {length}, bits {bits}");
                }

                for (var distance = 0; distance <= length + 1; distance++)
                {
                    var higher = distance >= length ? 0 : (bits << distance) & logicalMask;
                    var lower = distance >= length ? 0 : bits >> distance;
                    if (!V1VectorMatchesMask(
                            vector.ShiftTowardHigherOrdinals(distance),
                            length,
                            higher) ||
                        !V1VectorMatchesMask(
                            vector.ShiftTowardLowerOrdinals(distance),
                            length,
                            lower))
                    {
                        Fail($"shift mismatch at length {length}, bits {bits}, distance {distance}");
                    }
                }
            }

            var all = BooleanVector.All(length);
            for (var left = 0; left < valueCount; left++)
            {
                var a = vectors[left];
                var notA = a.Not();
                if (!V1VectorMatchesMask(notA, length, (~left) & logicalMask) ||
                    !a.Or(a).Equals(a) ||
                    !a.And(a).Equals(a) ||
                    !a.Xor(a).IsEmpty ||
                    !a.Or(notA).Equals(all) ||
                    !a.And(notA).IsEmpty)
                {
                    Fail($"unary/identity law mismatch at length {length}, left {left}");
                }

                for (var right = 0; right < valueCount; right++)
                {
                    orderedPairs++;
                    var b = vectors[right];
                    if (!V1VectorMatchesMask(a.Or(b), length, left | right) ||
                        !V1VectorMatchesMask(a.And(b), length, left & right) ||
                        !V1VectorMatchesMask(a.Xor(b), length, left ^ right) ||
                        !V1VectorMatchesMask(a.AndNot(b), length, left & ~right & logicalMask) ||
                        !a.Or(b).Equals(b.Or(a)) ||
                        !a.And(b).Equals(b.And(a)) ||
                        !a.Xor(b).Equals(b.Xor(a)) ||
                        !a.Or(b).Not().Equals(a.Not().And(b.Not())) ||
                        !a.And(b).Not().Equals(a.Not().Or(b.Not())))
                    {
                        Fail($"binary law mismatch at length {length}, left {left}, right {right}");
                    }
                }
            }
        }

        Equal(511, vectorCases, "exhaustive Boolean-vector value census through length eight");
        Equal(87381, orderedPairs, "exhaustive Boolean-vector ordered-pair census through length eight");
        True(agrees, $"Boolean-vector algebra agrees with independent integer oracle; {failure}");
    }

    private static void BooleanPrefixParityMatchesIndependentOracle()
    {
        var agrees = true;
        var failure = string.Empty;
        var scanCases = 0;
        var splitCases = 0;
        var linearCases = 0;

        void Fail(string message)
        {
            if (agrees)
            {
                agrees = false;
                failure = message;
            }
        }

        for (var length = 0; length <= 10; length++)
        {
            var valueCount = 1 << length;
            for (var bits = 0; bits < valueCount; bits++)
            {
                var input = V1VectorFromMask(length, bits);
                var falseScan = input.PrefixParity(false);
                var trueScan = input.PrefixParity(true);
                if (!trueScan.Vector.Equals(falseScan.Vector.Not()))
                {
                    Fail($"P1 complement law mismatch at length {length}, bits {bits}");
                }

                foreach (var carryIn in new[] { false, true })
                {
                    scanCases++;
                    var expected = V1PrefixOracle(length, bits, carryIn, out var expectedCarry);
                    var result = input.PrefixParity(carryIn);
                    if (!V1VectorMatchesMask(result.Vector, length, expected) ||
                        result.CarryOut != expectedCarry ||
                        result.CarryOut != (carryIn ^ input.Parity()) ||
                        !result.Vector.AdjacentTransitions(carryIn).Equals(input))
                    {
                        Fail($"prefix/inverse mismatch at length {length}, bits {bits}, carry {carryIn}");
                    }

                    var inverse = input.AdjacentTransitions(carryIn).PrefixParity(carryIn);
                    if (!inverse.Vector.Equals(input))
                    {
                        Fail($"transition/prefix inverse mismatch at length {length}, bits {bits}, carry {carryIn}");
                    }

                    for (var split = 0; split <= length; split++)
                    {
                        splitCases++;
                        var left = V1SliceVector(input, 0, split);
                        var right = V1SliceVector(input, split, length);
                        var leftResult = left.PrefixParity(carryIn);
                        var rightResult = right.PrefixParity(leftResult.CarryOut);
                        var joined = V1ConcatVectors(leftResult.Vector, rightResult.Vector);
                        if (!joined.Equals(result.Vector) || rightResult.CarryOut != result.CarryOut)
                        {
                            Fail(
                                $"chunk law mismatch at length {length}, bits {bits}, " +
                                $"carry {carryIn}, split {split}");
                        }
                    }
                }
            }
        }

        for (var length = 0; length <= 8; length++)
        {
            var valueCount = 1 << length;
            var scans = new BooleanVector[valueCount];
            var carries = new bool[valueCount];
            for (var bits = 0; bits < valueCount; bits++)
            {
                var scan = V1VectorFromMask(length, bits).PrefixParity(false);
                scans[bits] = scan.Vector;
                carries[bits] = scan.CarryOut;
            }

            for (var left = 0; left < valueCount; left++)
            {
                for (var right = 0; right < valueCount; right++)
                {
                    linearCases++;
                    var xorScan = V1VectorFromMask(length, left ^ right).PrefixParity(false);
                    if (!xorScan.Vector.Equals(scans[left].Xor(scans[right])) ||
                        xorScan.CarryOut != (carries[left] ^ carries[right]))
                    {
                        Fail($"P0 linearity mismatch at length {length}, left {left}, right {right}");
                    }
                }
            }
        }

        Equal(4094, scanCases, "prefix oracle covers every vector through length ten and both carries");
        Equal(40962, splitCases, "prefix chunk oracle covers every split through length ten");
        Equal(87381, linearCases, "P0 linearity covers every ordered pair through length eight");
        True(agrees, $"prefix, inverse, complement, linearity, and chunk laws hold; {failure}");
    }

    private static void BooleanVectorLongAndTailCasesMatchOracle()
    {
        var random = new Random(4601);
        var lengths = new List<int> { 0, 63, 64, 65, 127, 128, 129 };
        for (var i = 0; i < 12; i++)
        {
            lengths.Add(160 + (i * 73) + random.Next(31));
        }

        var agrees = true;
        var failure = string.Empty;
        foreach (var length in lengths)
        {
            var leftBits = V1RandomBits(random, length);
            var rightBits = V1RandomBits(random, length);
            var left = V1VectorFromBits(leftBits);
            var right = V1VectorFromBits(rightBits);

            if (!V1VectorMatchesBits(left, leftBits) ||
                !V1VectorMatchesBits(right, rightBits) ||
                !V1VectorMatchesBits(left.Or(right), V1CombineBits(leftBits, rightBits, static (a, b) => a || b)) ||
                !V1VectorMatchesBits(left.And(right), V1CombineBits(leftBits, rightBits, static (a, b) => a && b)) ||
                !V1VectorMatchesBits(left.Xor(right), V1CombineBits(leftBits, rightBits, static (a, b) => a != b)) ||
                !V1VectorMatchesBits(left.AndNot(right), V1CombineBits(leftBits, rightBits, static (a, b) => a && !b)) ||
                !V1VectorMatchesBits(left.Not(), leftBits.Select(static bit => !bit).ToArray()))
            {
                agrees = false;
                failure = $"long algebra mismatch at length {length}";
            }

            var distances = new[] { 0, 1, 63, 64, 65, Math.Max(0, length - 1), length, length + 3 };
            foreach (var distance in distances.Distinct())
            {
                var expectedHigher = new bool[length];
                var expectedLower = new bool[length];
                for (var ordinal = 0; ordinal < length; ordinal++)
                {
                    if (ordinal >= distance)
                    {
                        expectedHigher[ordinal] = leftBits[ordinal - distance];
                    }

                    if (ordinal + distance < length)
                    {
                        expectedLower[ordinal] = leftBits[ordinal + distance];
                    }
                }

                if (!V1VectorMatchesBits(left.ShiftTowardHigherOrdinals(distance), expectedHigher) ||
                    !V1VectorMatchesBits(left.ShiftTowardLowerOrdinals(distance), expectedLower))
                {
                    agrees = false;
                    failure = $"long shift mismatch at length {length}, distance {distance}";
                }
            }

            var expectedStates = new bool[length];
            var state = true;
            for (var ordinal = 0; ordinal < length; ordinal++)
            {
                state ^= leftBits[ordinal];
                expectedStates[ordinal] = state;
            }

            var scan = left.PrefixParity(true);
            var chunkStates = BooleanVector.None(0);
            var chunkCarry = true;
            var cursor = 0;
            while (cursor < length)
            {
                var chunkLength = Math.Min(length - cursor, 1 + (((cursor * 17) + 13) % 79));
                var chunk = V1SliceVector(left, cursor, cursor + chunkLength);
                var chunkScan = chunk.PrefixParity(chunkCarry);
                chunkStates = V1ConcatVectors(chunkStates, chunkScan.Vector);
                chunkCarry = chunkScan.CarryOut;
                cursor += chunkLength;
            }

            if (!V1VectorMatchesBits(scan.Vector, expectedStates) ||
                scan.CarryOut != state ||
                !scan.Vector.AdjacentTransitions(true).Equals(left) ||
                !chunkStates.Equals(scan.Vector) ||
                chunkCarry != scan.CarryOut)
            {
                agrees = false;
                failure = $"long prefix mismatch at length {length}";
            }

            var physicalWords = Enumerable.Repeat(ulong.MaxValue, (length + 63) / 64).ToArray();
            var poisonedAll = BooleanVector.FromPhysicalWordsForTesting(length, physicalWords);
            if (!poisonedAll.Equals(BooleanVector.All(length)) || poisonedAll.Population != length)
            {
                agrees = false;
                failure = $"poisoned-tail mismatch at length {length}";
            }
        }

        Equal(19, lengths.Count, "long-vector edge and deterministic random case census");
        True(agrees, $"long and multiword vectors agree with per-bit oracle; {failure}");
    }

    private static BooleanVector V1VectorFromMask(int length, int bits) =>
        BooleanVector.Create(length, Enumerable.Range(0, length).Where(ordinal => (bits & (1 << ordinal)) != 0));

    private static bool V1VectorMatchesMask(BooleanVector vector, int length, int bits)
    {
        if (vector.Length != length || vector.Population != V1PopCount(bits))
        {
            return false;
        }

        var enumeration = new List<int>();
        for (var ordinal = 0; ordinal < length; ordinal++)
        {
            var expected = (bits & (1 << ordinal)) != 0;
            if (vector[ordinal] != expected)
            {
                return false;
            }

            if (expected)
            {
                enumeration.Add(ordinal);
            }
        }

        return vector.SequenceEqual(enumeration);
    }

    private static int V1PrefixOracle(int length, int bits, bool carryIn, out bool carryOut)
    {
        var states = 0;
        var state = carryIn;
        for (var ordinal = 0; ordinal < length; ordinal++)
        {
            state ^= (bits & (1 << ordinal)) != 0;
            if (state)
            {
                states |= 1 << ordinal;
            }
        }

        carryOut = state;
        return states;
    }

    private static BooleanVector V1SliceVector(BooleanVector source, int start, int end)
    {
        var selected = new List<int>();
        for (var ordinal = start; ordinal < end; ordinal++)
        {
            if (source[ordinal])
            {
                selected.Add(ordinal - start);
            }
        }

        return BooleanVector.Create(end - start, selected);
    }

    private static BooleanVector V1ConcatVectors(BooleanVector left, BooleanVector right)
    {
        var selected = new List<int>(left.Population + right.Population);
        selected.AddRange(left);
        selected.AddRange(right.Select(ordinal => left.Length + ordinal));
        return BooleanVector.Create(left.Length + right.Length, selected);
    }

    private static int V1PopCount(int value)
    {
        var count = 0;
        while (value != 0)
        {
            value &= value - 1;
            count++;
        }

        return count;
    }

    private static bool[] V1RandomBits(Random random, int length)
    {
        var bits = new bool[length];
        for (var i = 0; i < bits.Length; i++)
        {
            bits[i] = random.Next(2) != 0;
        }

        return bits;
    }

    private static BooleanVector V1VectorFromBits(IReadOnlyList<bool> bits)
    {
        var selected = new List<int>();
        for (var i = 0; i < bits.Count; i++)
        {
            if (bits[i])
            {
                selected.Add(i);
            }
        }

        return BooleanVector.Create(bits.Count, selected);
    }

    private static bool V1VectorMatchesBits(BooleanVector vector, IReadOnlyList<bool> bits)
    {
        if (vector.Length != bits.Count)
        {
            return false;
        }

        var selected = new List<int>();
        for (var i = 0; i < bits.Count; i++)
        {
            if (vector[i] != bits[i])
            {
                return false;
            }

            if (bits[i])
            {
                selected.Add(i);
            }
        }

        return vector.Population == selected.Count && vector.SequenceEqual(selected);
    }

    private static bool[] V1CombineBits(
        IReadOnlyList<bool> left,
        IReadOnlyList<bool> right,
        Func<bool, bool, bool> operation)
    {
        var result = new bool[left.Count];
        for (var i = 0; i < result.Length; i++)
        {
            result[i] = operation(left[i], right[i]);
        }

        return result;
    }
}
