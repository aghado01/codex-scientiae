using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace CodexSci.Doccer;

/// <summary>Declarative input for the generic regex collector; patterns remain data, not algebra.</summary>
public sealed record PatternRule
{
    public PatternRule(
        string id,
        string pattern,
        string kind,
        string source,
        SpanLevel level = SpanLevel.Character,
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
    public int Priority { get; }
    public RegexOptions Options { get; }
    public string? CaptureGroup { get; }
    public TimeSpan Timeout { get; }
}

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

            var regex = new Regex(rule.Pattern, rule.Options, rule.Timeout);

            // Probe for empty-match capability. This catches the common defect class (an empty
            // alternative or all-optional pattern) at load time; patterns that only match empty
            // under specific context (e.g. lookarounds) still hit the mid-sweep backstop in
            // AddMatches.
            if (regex.Match(string.Empty).Success)
            {
                throw new ArgumentException(
                    $"Pattern rule '{rule.Id}' can match the empty string and would emit empty " +
                    "structural claims.",
                    nameof(rules));
            }

            materialized.Add((rule, regex));
        }

        foreach (var (rule, regex) in materialized)
        {
            if (scope is null)
            {
                AddMatches(builder, regex, rule, builder.Master.Text, 0);
            }
            else
            {
                foreach (var region in scope)
                {
                    // Matching each admitted interval independently prevents a match from bridging an
                    // excluded gap. Region-local anchor semantics are consequently explicit.
                    AddMatches(builder, regex, rule, builder.Master.Slice(region), region.Start);
                }
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
