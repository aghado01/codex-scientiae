using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.RegularExpressions;

namespace CodexSci.Doccer;

/// <summary>
/// A pattern inventory could not be read. Carries the origin and 1-based line the defect sits on,
/// so a malformed inventory names its own defect rather than surfacing as a bare parse error.
/// </summary>
public sealed class PatternRuleLoadException : Exception
{
    public PatternRuleLoadException(string origin, int lineNumber, string message, Exception? innerException = null)
        : base($"{origin}:{lineNumber}: {message}", innerException)
    {
        Origin = origin;
        LineNumber = lineNumber;
    }

    /// <summary>The file path, or another name for the stream the line came from.</summary>
    public string Origin { get; }

    /// <summary>1-based line number within the origin, counting blank lines.</summary>
    public int LineNumber { get; }
}

/// <summary>
/// Wire shape of one line in a JSONL pattern inventory. This is the loader's own record, not the
/// engine's <see cref="PatternRule"/>: the schema is declared once here and is the same shape a
/// command-line surface reads and writes, so an inventory never has two definitions that can drift.
/// </summary>
/// <remarks>
/// Property names are camelCase on the wire. Unknown properties are rejected rather than ignored,
/// so a misspelled field fails loudly at the line that carries it. Only <c>id</c>, <c>pattern</c>,
/// <c>kind</c> and <c>source</c> are required; every other field falls back to the engine default.
/// </remarks>
[JsonUnmappedMemberHandling(JsonUnmappedMemberHandling.Disallow)]
public sealed record PatternRuleDocument
{
    /// <summary>Rule identity, unique within an inventory. Recorded on every claim the rule emits.</summary>
    public string? Id { get; init; }

    /// <summary>
    /// The .NET regular expression. No syntactic obligations: a line-level rule need not anchor
    /// itself, because where a rule runs is <see cref="Scope"/>'s job.
    /// </summary>
    public string? Pattern { get; init; }

    /// <summary>Claim kind recorded on every match.</summary>
    public string? Kind { get; init; }

    /// <summary>Claim source (producer identity) recorded on every match.</summary>
    public string? Source { get; init; }

    /// <summary>Claim metadata: <c>Character</c>, <c>Line</c> or <c>MultiLine</c>. Not execution.</summary>
    public string? Level { get; init; }

    /// <summary>Execution scope: <c>WholeMaster</c> or <c>PerLine</c>. Not metadata.</summary>
    public string? Scope { get; init; }

    /// <summary>Default resolution evidence recorded on the claim; order remains query policy.</summary>
    public int? Priority { get; init; }

    /// <summary>
    /// Names of <see cref="RegexOptions"/> members. Parsed exactly as listed; the engine then
    /// unions <c>CultureInvariant</c> in at the <see cref="PatternRule"/> boundary (D18), as it
    /// does for every caller. <c>ECMAScript</c> is rejected there — options augment the engine's
    /// culture-invariant baseline, they never select a different matching profile.
    /// </summary>
    public string[]? Options { get; init; }

    /// <summary>Named capture group to claim instead of the whole match.</summary>
    public string? CaptureGroup { get; init; }

    /// <summary>Per-match regex timeout.</summary>
    public int? TimeoutMilliseconds { get; init; }
}

/// <summary>
/// The doccer wire format, declared once. Payload shapes are loader- and CLI-owned records rather
/// than engine types, and every payload a process boundary reads or writes is enumerated here.
/// </summary>
[JsonSourceGenerationOptions(PropertyNamingPolicy = JsonKnownNamingPolicy.CamelCase)]
[JsonSerializable(typeof(PatternRuleDocument))]
public sealed partial class DoccerJsonContext : JsonSerializerContext
{
}

/// <summary>
/// Reads a JSONL pattern inventory — one rule object per line — into <see cref="PatternRule"/>
/// instances. Domain knowledge arrives as data, so a collector never needs a domain-specific verb.
/// </summary>
/// <remarks>
/// <para>
/// Validation is per line and loud: a schema violation, an unknown enum value, a duplicate id, an
/// uncompilable pattern, or a pattern that can match the empty string all throw
/// <see cref="PatternRuleLoadException"/> naming the origin and line. The empty-match probe is the
/// same one in-code collection applies; raising it here simply lets the failure carry provenance.
/// </para>
/// <para>
/// Patterns carry no syntactic requirements. A rule intended to run per line does not have to
/// anchor itself with <c>^...$</c> — it sets <c>scope</c> to <c>PerLine</c> instead, and the
/// collector runs it within each line's content extent, terminator excluded (D15).
/// </para>
/// </remarks>
public static class PatternRuleLoader
{
    /// <summary>Loads an inventory from a UTF-8 JSONL file.</summary>
    public static IReadOnlyList<PatternRule> LoadFile(string path)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(path);
        return Load(File.ReadLines(path, Encoding.UTF8), path);
    }

    /// <summary>
    /// Loads an inventory from already-read lines. The origin is a name for the stream, used only
    /// in error provenance, so an inventory arriving over stdio reports as loudly as a file does.
    /// </summary>
    public static IReadOnlyList<PatternRule> Load(IEnumerable<string> lines, string origin)
    {
        ArgumentNullException.ThrowIfNull(lines);
        ArgumentException.ThrowIfNullOrWhiteSpace(origin);

        var rules = new List<PatternRule>();
        var firstDefinition = new Dictionary<string, int>(StringComparer.Ordinal);
        var lineNumber = 0;
        foreach (var line in lines)
        {
            lineNumber++;
            if (string.IsNullOrWhiteSpace(line))
            {
                // Blank separators are tolerated; they keep hand-edited inventories readable and
                // still count toward the line number so reported provenance matches an editor.
                continue;
            }

            PatternRuleDocument? document;
            try
            {
                document = JsonSerializer.Deserialize(line, DoccerJsonContext.Default.PatternRuleDocument);
            }
            catch (JsonException exception)
            {
                throw new PatternRuleLoadException(origin, lineNumber, exception.Message, exception);
            }

            if (document is null)
            {
                throw new PatternRuleLoadException(origin, lineNumber, "The line is not a rule object.");
            }

            var rule = Build(document, origin, lineNumber);
            if (firstDefinition.TryGetValue(rule.Id, out var earlier))
            {
                throw new PatternRuleLoadException(
                    origin,
                    lineNumber,
                    $"Duplicate rule id '{rule.Id}'; already defined on line {earlier}.");
            }

            firstDefinition.Add(rule.Id, lineNumber);
            rules.Add(rule);
        }

        return rules.AsReadOnly();
    }

    private static PatternRule Build(PatternRuleDocument document, string origin, int lineNumber)
    {
        var id = Required(document.Id, "id", origin, lineNumber);
        var pattern = Required(document.Pattern, "pattern", origin, lineNumber);
        var kind = Required(document.Kind, "kind", origin, lineNumber);
        var source = Required(document.Source, "source", origin, lineNumber);
        var level = ParseMember(document.Level, "level", SpanLevel.Character, origin, lineNumber);
        var scope = ParseMember(document.Scope, "scope", ExecutionScope.WholeMaster, origin, lineNumber);
        var options = ParseOptions(document.Options, origin, lineNumber);
        var timeout = document.TimeoutMilliseconds is null
            ? (TimeSpan?)null
            : TimeSpan.FromMilliseconds(document.TimeoutMilliseconds.Value);

        PatternRule rule;
        try
        {
            rule = new PatternRule(
                id,
                pattern,
                kind,
                source,
                level,
                scope,
                document.Priority ?? 0,
                options,
                document.CaptureGroup,
                timeout);
        }
        catch (ArgumentException exception)
        {
            throw new PatternRuleLoadException(origin, lineNumber, exception.Message, exception);
        }

        try
        {
            // RegexParseException derives from ArgumentException, so an uncompilable pattern and an
            // empty-capable one both arrive here and both get the line that declared them.
            RegexCollector.CompileAndProbe(rule);
        }
        catch (ArgumentException exception)
        {
            throw new PatternRuleLoadException(origin, lineNumber, exception.Message, exception);
        }

        return rule;
    }

    private static string Required(string? value, string field, string origin, int lineNumber)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            throw new PatternRuleLoadException(origin, lineNumber, $"Field '{field}' is required.");
        }

        return value;
    }

    private static TMember ParseMember<TMember>(
        string? value,
        string field,
        TMember fallback,
        string origin,
        int lineNumber)
        where TMember : struct, Enum
    {
        if (value is null)
        {
            return fallback;
        }

        var names = Enum.GetNames<TMember>();
        foreach (var name in names)
        {
            if (StringComparer.Ordinal.Equals(name, value))
            {
                return Enum.Parse<TMember>(name);
            }
        }

        throw new PatternRuleLoadException(
            origin,
            lineNumber,
            $"Field '{field}' has unknown value '{value}'; expected one of {string.Join(", ", names)}.");
    }

    private static RegexOptions ParseOptions(string[]? names, string origin, int lineNumber)
    {
        if (names is null)
        {
            // Matches the PatternRule default. An explicit list is passed through as written;
            // the PatternRule constructor is the one place that unions CultureInvariant in
            // (D18), so inventory rules and direct DLL callers share one collector contract.
            return RegexOptions.CultureInvariant;
        }

        var options = RegexOptions.None;
        var defined = Enum.GetNames<RegexOptions>();
        foreach (var name in names)
        {
            var matched = false;
            foreach (var candidate in defined)
            {
                if (StringComparer.Ordinal.Equals(candidate, name))
                {
                    options |= Enum.Parse<RegexOptions>(candidate);
                    matched = true;
                    break;
                }
            }

            if (!matched)
            {
                throw new PatternRuleLoadException(
                    origin,
                    lineNumber,
                    $"Unknown regex option '{name}'; expected one of {string.Join(", ", defined)}.");
            }
        }

        return options;
    }
}
