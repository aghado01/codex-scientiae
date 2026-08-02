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
/// <see cref="Options"/> always includes <see cref="RegexOptions.CultureInvariant"/>: the
/// constructor unions it into whatever the caller passes, so the same rule recognizes the same
/// claims on every machine regardless of ambient culture (D18). Supplied options augment that
/// baseline, never replace it — <see cref="RegexOptions.ECMAScript"/> is rejected because it is
/// a different matching profile, not an augmentation. The guarantee is independence from
/// ambient culture, not from runtime/Unicode-version changes to the case tables.
/// Positional-parameter compat note (T2-5): the constructor places <c>scope</c> before
/// <c>priority</c>; consumers binding positionally ahead of doccer's cross-project graduation
/// should prefer named arguments for both.
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

        if (!Enum.IsDefined(level))
        {
            throw new ArgumentOutOfRangeException(nameof(level), level, "Undefined SpanLevel value.");
        }

        if (!Enum.IsDefined(scope))
        {
            throw new ArgumentOutOfRangeException(nameof(scope), scope, "Undefined ExecutionScope value.");
        }

        if ((options & RegexOptions.ECMAScript) != 0)
        {
            // Not a runtime constraint (net10 permits ECMAScript|CultureInvariant) but a contract
            // choice: ECMAScript selects a different matching profile — ASCII-leaning \d/\w/\s,
            // its own case-folding special cases — and options augment the engine baseline, they
            // never replace the execution policy (D18).
            throw new ArgumentException(
                "RegexOptions.ECMAScript is not supported: doccer matching is culture-invariant " +
                "canonical .NET matching, and ECMAScript selects a different matching profile " +
                "rather than augmenting that baseline.",
                nameof(options));
        }

        Id = id;
        Pattern = pattern;
        Kind = kind;
        Source = source;
        Level = level;
        Scope = scope;
        Priority = priority;
        // The union happens here, at the engine boundary, not in the JSONL loader: an inventory
        // rule and a directly constructed rule must be the same collector contract, and matching
        // must never inherit the ambient culture. Culture-sensitive matching is simply not
        // offered at this boundary (D18). The guarantee is independence from ambient culture —
        // not from runtime or Unicode-version changes to the case tables themselves.
        Options = options | RegexOptions.CultureInvariant;
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
        if (builder.IsFrozen)
        {
            throw new InvalidOperationException("The span batch has already been frozen.");
        }

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

        // Load-time validation cannot catch every mid-sweep failure: a context-dependent
        // zero-width pattern passes the empty-input probe, a match can time out, and a match can
        // land on a non-scalar boundary. Staging every claim and committing only after the whole
        // sweep succeeds keeps the promise above unconditional — the caller's builder is either
        // extended by the complete collection or left untouched.
        var staged = new List<SpanClaim>();
        foreach (var (rule, regex) in materialized)
        {
            if (rule.Scope == ExecutionScope.WholeMaster && scope is null)
            {
                // The only case with no region decomposition, and the one worth keeping free of a
                // whole-document string copy.
                StageMatches(staged, builder.Master, regex, rule, builder.Master.Text, 0);
                continue;
            }

            foreach (var region in ExecutionRegions(builder.Master, rule.Scope, scope))
            {
                // Matching each region independently prevents a match from bridging an excluded gap
                // or a line break. Region-local anchor semantics are consequently explicit.
                StageMatches(staged, builder.Master, regex, rule, builder.Master.Slice(region), region.Start);
            }
        }

        foreach (var claim in staged)
        {
            builder.Add(claim);
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
    /// the mid-sweep backstop in <c>StageMatches</c>; because collection stages and commits, even
    /// that late failure leaves the caller's builder untouched.
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

        // A capture group the compiled pattern does not define is indistinguishable at match time
        // from a legitimate nonparticipating group, so an inventory typo would silently emit no
        // claims. Resolving the name (or number-as-string) here turns that into a loud failure
        // that the JSONL loader wraps with file-and-line provenance.
        if (rule.CaptureGroup is not null && regex.GroupNumberFromName(rule.CaptureGroup) < 0)
        {
            throw new ArgumentException(
                $"Pattern rule '{rule.Id}' names capture group '{rule.CaptureGroup}', which the " +
                $"pattern does not define; it defines {string.Join(", ", regex.GetGroupNames())}.");
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

    private static void StageMatches(
        List<SpanClaim> staged,
        TextMaster master,
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

            var span = TextSpan.FromStartLength(checked(baseOffset + group.Index), group.Length);
            // Validate now, while staging: a claim the builder would reject at commit time (a
            // match landing inside a surrogate pair, say) must fail before anything commits.
            master.ValidateSpan(span, allowEmpty: false);
            staged.Add(new SpanClaim(
                span,
                rule.Kind,
                rule.Level,
                rule.Source,
                rule.Priority,
                rule.Id));
        }
    }
}
