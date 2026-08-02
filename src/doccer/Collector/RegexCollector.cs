using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace CodexSci.Doccer;

/// <summary>
/// Where a collector runs a recognizer. This is the "run-within" operation of the lift vocabulary,
/// assigned to collectors rather than left as one of several meanings of a single verb.
/// </summary>
public enum ExecutionScope
{
    /// <summary>Match once over the whole master (or, when the caller passes a region set, once per admitted region).</summary>
    WholeMaster = 0,

    /// <summary>
    /// Match independently within each line's content extent — the terminator is excluded (D15:
    /// a line break is a boundary, not content), so no match can span, capture, or vary with the
    /// line break, and anchors are line-local. The same content under LF and CRLF conventions
    /// yields identical claim text. A rule that needs the terminator itself uses
    /// <see cref="WholeMaster"/>; the terminator codepoints remain first-class atoms either way.
    /// </summary>
    PerLine = 1,
}

/// <summary>Declarative input for the generic regex collector; patterns remain data, not algebra.</summary>
/// <remarks>
/// A pattern carries no syntactic obligations: a line-level rule need not anchor itself with
/// <c>^...$</c>, because where a rule runs is <see cref="Scope"/>'s job, not the pattern's.
/// <see cref="Level"/> is claim metadata — what the resulting claim says about itself — and is
/// deliberately independent of <see cref="Scope"/>, which is execution.
/// </remarks>
public sealed record PatternRule
{
    public PatternRule(
        string id,
        string pattern,
        string kind,
        string source,
        SpanLevel level = SpanLevel.Character,
        ExecutionScope scope = ExecutionScope.WholeMaster,
        int priority = 0,
        RegexOptions options = RegexOptions.CultureInvariant,
        string? captureGroup = null,
        TimeSpan? timeout = null)
    {
        if (string.IsNullOrWhiteSpace(id))
        {
            throw new ArgumentException("A rule identity is required.", nameof(id));
        }

        if (string.IsNullOrWhiteSpace(pattern))
        {
            throw new ArgumentException("A regex pattern is required.", nameof(pattern));
        }

        if (string.IsNullOrWhiteSpace(kind))
        {
            throw new ArgumentException("A claim kind is required.", nameof(kind));
        }

        if (string.IsNullOrWhiteSpace(source))
        {
            throw new ArgumentException("A claim source is required.", nameof(source));
        }

        Id = id;
        Pattern = pattern;
        Kind = kind;
        Source = source;
        Level = level;
        Scope = scope;
        Priority = priority;
        Options = options;
        CaptureGroup = captureGroup;
        Timeout = timeout ?? TimeSpan.FromSeconds(1);
        if (Timeout <= TimeSpan.Zero)
        {
            throw new ArgumentOutOfRangeException(nameof(timeout));
        }
    }

    public string Id { get; }
    public string Pattern { get; }
    public string Kind { get; }
    public string Source { get; }
    public SpanLevel Level { get; }
    public ExecutionScope Scope { get; }
    public int Priority { get; }
    public RegexOptions Options { get; }
    public string? CaptureGroup { get; }
    public TimeSpan Timeout { get; }
}

/// <summary>
/// Generic declarative collection. Two independent scopes narrow where a rule runs, and they
/// compose by intersecting the regions each admits: the rule's own <see cref="ExecutionScope"/>
/// proposes regions (the whole master, or one per line extent), the caller's optional
/// <see cref="SpanSet"/> admits regions, and a rule executes over the pieces common to both. Each
/// resulting piece is matched independently, so a match can bridge neither an excluded gap nor —
/// for a per-line rule — a line break.
/// </summary>
public static class RegexCollector
{
    public static SpanBatch Collect(
        TextMaster master,
        IEnumerable<PatternRule> rules,
        SpanSet? scope = null)
    {
        var builder = new SpanBatchBuilder(master ?? throw new ArgumentNullException(nameof(master)));
        CollectInto(builder, rules, scope);
        return builder.Freeze();
    }

    public static void CollectInto(
        SpanBatchBuilder builder,
        IEnumerable<PatternRule> rules,
        SpanSet? scope = null)
    {
        ArgumentNullException.ThrowIfNull(builder);
        ArgumentNullException.ThrowIfNull(rules);
        if (scope is not null)
        {
            builder.Master.EnsureCompatibleWith(scope.Master);
        }

        // Materialize and validate every rule before any matching begins, so a defective rule
        // (e.g. "foo|") fails the batch atomically instead of throwing after earlier rules have
        // already added claims to the builder.
        var seenIds = new HashSet<string>(StringComparer.Ordinal);
        var materialized = new List<(PatternRule Rule, Regex Regex)>();
        foreach (var rule in rules)
        {
            if (!seenIds.Add(rule.Id))
            {
                throw new ArgumentException($"Duplicate pattern rule id '{rule.Id}'.", nameof(rules));
            }

            materialized.Add((rule, CompileAndProbe(rule)));
        }

        foreach (var (rule, regex) in materialized)
        {
            if (rule.Scope == ExecutionScope.WholeMaster && scope is null)
            {
                // The only case with no region decomposition, and the one worth keeping free of a
                // whole-document string copy.
                AddMatches(builder, regex, rule, builder.Master.Text, 0);
                continue;
            }

            foreach (var region in ExecutionRegions(builder.Master, rule.Scope, scope))
            {
                // Matching each region independently prevents a match from bridging an excluded gap
                // or a line break. Region-local anchor semantics are consequently explicit.
                AddMatches(builder, regex, rule, builder.Master.Slice(region), region.Start);
            }
        }
    }

    /// <summary>
    /// Compiles a rule's pattern and probes it for empty-match capability, which is the defect that
    /// would otherwise emit empty structural claims mid-sweep. Shared by in-code collection and the
    /// JSONL loader so one probe governs both; each caller wraps the failure in its own provenance.
    /// </summary>
    /// <remarks>
    /// The probe catches the common class — an empty alternative or an all-optional pattern.
    /// Patterns that match empty only under specific context (a bare lookaround, say) still reach
    /// the mid-sweep backstop in <c>AddMatches</c>.
    /// </remarks>
    internal static Regex CompileAndProbe(PatternRule rule)
    {
        var regex = new Regex(rule.Pattern, rule.Options, rule.Timeout);
        if (regex.Match(string.Empty).Success)
        {
            throw new ArgumentException(
                $"Pattern rule '{rule.Id}' can match the empty string and would emit empty " +
                "structural claims.");
        }

        return regex;
    }

    /// <summary>
    /// The regions one rule executes over: what its own execution scope proposes, intersected with
    /// what the caller's region set admits. Line extents stay separated through the intersection —
    /// a scope that cuts a line into pieces yields those pieces, each matched on its own.
    /// </summary>
    private static IEnumerable<TextSpan> ExecutionRegions(
        TextMaster master,
        ExecutionScope executionScope,
        SpanSet? admitted)
    {
        if (executionScope == ExecutionScope.WholeMaster)
        {
            if (admitted is null)
            {
                if (master.Length > 0)
                {
                    yield return master.Extent;
                }

                yield break;
            }

            foreach (var region in admitted)
            {
                yield return region;
            }

            yield break;
        }

        // Per-line execution is the one composition that asks the master for its line topology.
        // The proposed region is the line's content extent, terminator excluded (D15).
        var topology = master.Topology;
        for (var line = 0; line < topology.LineCount; line++)
        {
            var extent = master.GetLineSpan(line, includeLineBreak: false);
            if (extent.IsEmpty)
            {
                continue;
            }

            if (admitted is null)
            {
                yield return extent;
                continue;
            }

            foreach (var region in admitted)
            {
                if (region.Start >= extent.End)
                {
                    break;
                }

                if (region.End <= extent.Start)
                {
                    continue;
                }

                yield return new TextSpan(
                    Math.Max(region.Start, extent.Start),
                    Math.Min(region.End, extent.End));
            }
        }
    }

    private static void AddMatches(
        SpanBatchBuilder builder,
        Regex regex,
        PatternRule rule,
        string input,
        int baseOffset)
    {
        foreach (Match match in regex.Matches(input))
        {
            var group = rule.CaptureGroup is null ? match.Groups[0] : match.Groups[rule.CaptureGroup];
            if (!group.Success)
            {
                continue;
            }

            if (group.Length == 0)
            {
                throw new InvalidOperationException(
                    $"Pattern rule '{rule.Id}' emitted an empty structural claim.");
            }

            builder.Add(new SpanClaim(
                TextSpan.FromStartLength(checked(baseOffset + group.Index), group.Length),
                rule.Kind,
                rule.Level,
                rule.Source,
                rule.Priority,
                rule.Id));
        }
    }
}
