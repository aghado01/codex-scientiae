using System;
using System.Collections.Frozen;
using System.Collections.Generic;
using System.Linq;

namespace CodexSci.Doccer;

public enum ValidationSeverity
{
    Information,
    Warning,
    Error,
}

public sealed record ValidationIssue(
    string Rule,
    ValidationSeverity Severity,
    string Message,
    int? LeftOrdinal = null,
    int? RightOrdinal = null);

/// <summary>Declarative relation/cardinality requirement evaluated for every matching left claim.</summary>
public sealed record RelationRequirement
{
    public RelationRequirement(
        string name,
        string leftKind,
        string rightKind,
        IEnumerable<AllenRelation> acceptedRelations,
        int minimumMatches = 1,
        int? maximumMatches = null,
        ValidationSeverity severity = ValidationSeverity.Error)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A validation rule name is required.", nameof(name));
        }

        if (string.IsNullOrWhiteSpace(leftKind) || string.IsNullOrWhiteSpace(rightKind))
        {
            throw new ArgumentException("Both claim kinds are required.");
        }

        ArgumentNullException.ThrowIfNull(acceptedRelations);
        if (minimumMatches < 0 || maximumMatches < minimumMatches)
        {
            throw new ArgumentOutOfRangeException(nameof(minimumMatches));
        }

        Name = name;
        LeftKind = leftKind;
        RightKind = rightKind;
        AcceptedRelations = acceptedRelations.ToFrozenSet();
        if (AcceptedRelations.Count == 0)
        {
            throw new ArgumentException("At least one accepted relation is required.", nameof(acceptedRelations));
        }

        MinimumMatches = minimumMatches;
        MaximumMatches = maximumMatches;
        Severity = severity;
    }

    public string Name { get; }
    public string LeftKind { get; }
    public string RightKind { get; }
    public IReadOnlySet<AllenRelation> AcceptedRelations { get; }
    public int MinimumMatches { get; }
    public int? MaximumMatches { get; }
    public ValidationSeverity Severity { get; }
}

/// <summary>Declarative relation that must never occur between two claim classes.</summary>
public sealed record ForbiddenRelation
{
    public ForbiddenRelation(
        string name,
        string leftKind,
        string rightKind,
        IEnumerable<AllenRelation> forbiddenRelations,
        ValidationSeverity severity = ValidationSeverity.Error)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("A validation rule name is required.", nameof(name));
        }

        if (string.IsNullOrWhiteSpace(leftKind) || string.IsNullOrWhiteSpace(rightKind))
        {
            throw new ArgumentException("Both claim kinds are required.");
        }

        ArgumentNullException.ThrowIfNull(forbiddenRelations);
        Name = name;
        LeftKind = leftKind;
        RightKind = rightKind;
        ForbiddenRelations = forbiddenRelations.ToFrozenSet();
        if (ForbiddenRelations.Count == 0)
        {
            throw new ArgumentException("At least one forbidden relation is required.", nameof(forbiddenRelations));
        }

        Severity = severity;
    }

    public string Name { get; }
    public string LeftKind { get; }
    public string RightKind { get; }
    public IReadOnlySet<AllenRelation> ForbiddenRelations { get; }
    public ValidationSeverity Severity { get; }
}

public static class DoccerValidation
{
    public static IReadOnlyList<ValidationIssue> ValidateIntrinsic(SpanBatch batch)
    {
        ArgumentNullException.ThrowIfNull(batch);
        var issues = new List<ValidationIssue>();

        var cursor = 0;
        foreach (var atom in batch.Master.Topology.Atoms)
        {
            if (atom.Span.Start != cursor)
            {
                issues.Add(new ValidationIssue(
                    "master.atom-coverage",
                    ValidationSeverity.Error,
                    $"Atom tiling has a gap or overlap at UTF-16 offset {cursor}."));
                break;
            }

            cursor = atom.Span.End;
        }

        if (cursor != batch.Master.Length)
        {
            issues.Add(new ValidationIssue(
                "master.atom-coverage",
                ValidationSeverity.Error,
                $"Atom tiling ends at {cursor}, not master length {batch.Master.Length}."));
        }

        foreach (var record in batch)
        {
            try
            {
                batch.Master.ValidateSpan(record.Span, allowEmpty: false);
            }
            catch (ArgumentException exception)
            {
                issues.Add(new ValidationIssue(
                    "batch.claim-bounds",
                    ValidationSeverity.Error,
                    exception.Message,
                    record.Ordinal));
            }
        }

        return issues.AsReadOnly();
    }

    public static IReadOnlyList<ValidationIssue> ValidateRelations(
        SpanBatch batch,
        IEnumerable<RelationRequirement>? requirements = null,
        IEnumerable<ForbiddenRelation>? impossibilities = null)
    {
        ArgumentNullException.ThrowIfNull(batch);
        var issues = new List<ValidationIssue>();
        var records = batch.ToArray();

        if (requirements is not null)
        {
            foreach (var rule in requirements)
            {
                var right = records.Where(record => StringComparer.Ordinal.Equals(record.Kind, rule.RightKind)).ToArray();
                foreach (var left in records.Where(record => StringComparer.Ordinal.Equals(record.Kind, rule.LeftKind)))
                {
                    var count = right.Count(candidate =>
                        candidate.Ordinal != left.Ordinal &&
                        rule.AcceptedRelations.Contains(AllenAlgebra.Relate(left.Span, candidate.Span)));
                    if (count < rule.MinimumMatches ||
                        (rule.MaximumMatches is not null && count > rule.MaximumMatches.Value))
                    {
                        var expectedMaximum = rule.MaximumMatches?.ToString() ?? "unbounded";
                        issues.Add(new ValidationIssue(
                            rule.Name,
                            rule.Severity,
                            $"Claim #{left.Ordinal} matched {count} '{rule.RightKind}' claims; expected " +
                            $"{rule.MinimumMatches}..{expectedMaximum}.",
                            left.Ordinal));
                    }
                }
            }
        }

        if (impossibilities is not null)
        {
            foreach (var rule in impossibilities)
            {
                var left = records.Where(record => StringComparer.Ordinal.Equals(record.Kind, rule.LeftKind));
                var right = records.Where(record => StringComparer.Ordinal.Equals(record.Kind, rule.RightKind)).ToArray();
                foreach (var leftRecord in left)
                {
                    foreach (var rightRecord in right)
                    {
                        if (leftRecord.Ordinal == rightRecord.Ordinal)
                        {
                            continue;
                        }

                        var relation = AllenAlgebra.Relate(leftRecord.Span, rightRecord.Span);
                        if (rule.ForbiddenRelations.Contains(relation))
                        {
                            issues.Add(new ValidationIssue(
                                rule.Name,
                                rule.Severity,
                                $"Forbidden relation {relation} between claims #{leftRecord.Ordinal} and #{rightRecord.Ordinal}.",
                                leftRecord.Ordinal,
                                rightRecord.Ordinal));
                        }
                    }
                }
            }
        }

        return issues.AsReadOnly();
    }
}
