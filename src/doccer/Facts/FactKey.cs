using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace CodexSci.Doccer;

/// <summary>
/// One master-relative semantic fact key (D43): a required adapter-owned ordinal domain and kind,
/// an immutable ordered tuple of geometry arguments, and an immutable ordered tuple of canonical
/// string value components. Compatible master value plus key value defines semantic fact identity.
/// The key retains no master, no occurrence evidence, and no support; geometry extents are
/// validated against a master only where a <see cref="CanonicalFactTable"/> retains one.
/// </summary>
public sealed class FactKey : IEquatable<FactKey>
{
    private readonly TextSpan[] _geometry;
    private readonly string[] _valueKey;
    private readonly ReadOnlyCollection<TextSpan> _geometryView;
    private readonly ReadOnlyCollection<string> _valueKeyView;

    public FactKey(
        string domain,
        string kind,
        IEnumerable<TextSpan> geometry,
        IEnumerable<string> valueKey)
    {
        if (string.IsNullOrWhiteSpace(domain))
        {
            throw new ArgumentException("A fact domain is required.", nameof(domain));
        }

        if (string.IsNullOrWhiteSpace(kind))
        {
            throw new ArgumentException("A fact kind is required.", nameof(kind));
        }

        ArgumentNullException.ThrowIfNull(geometry);
        ArgumentNullException.ThrowIfNull(valueKey);

        Domain = domain;
        Kind = kind;

        // Snapshot both tuples: argument order and duplicates are significant, and a caller's
        // sequence must not be able to mutate the key after construction.
        var collectedGeometry = new List<TextSpan>();
        foreach (var extent in geometry)
        {
            collectedGeometry.Add(extent);
        }

        var collectedValues = new List<string>();
        foreach (var component in valueKey)
        {
            if (component is null)
            {
                throw new ArgumentException(
                    "Value-key components must be non-null strings.",
                    nameof(valueKey));
            }

            collectedValues.Add(component);
        }

        _geometry = collectedGeometry.ToArray();
        _valueKey = collectedValues.ToArray();
        _geometryView = Array.AsReadOnly(_geometry);
        _valueKeyView = Array.AsReadOnly(_valueKey);
    }

    /// <summary>The adapter-owned semantic namespace, compared by exact ordinal equality.</summary>
    public string Domain { get; }

    /// <summary>The fact name within its domain, compared by exact ordinal equality.</summary>
    public string Kind { get; }

    /// <summary>
    /// The ordered geometry-argument tuple. Order and duplicates are significant; the empty tuple
    /// is a master-global fact and empty extents are boundary-valued arguments.
    /// </summary>
    public IReadOnlyList<TextSpan> Geometry => _geometryView;

    /// <summary>
    /// The ordered canonical value components. The empty tuple is the unit/no-payload key; the
    /// adapter owns canonical, culture-independent construction of each component.
    /// </summary>
    public IReadOnlyList<string> ValueKey => _valueKeyView;

    public bool Equals(FactKey? other)
    {
        if (ReferenceEquals(this, other))
        {
            return true;
        }

        if (other is null ||
            !StringComparer.Ordinal.Equals(Domain, other.Domain) ||
            !StringComparer.Ordinal.Equals(Kind, other.Kind) ||
            _geometry.Length != other._geometry.Length ||
            _valueKey.Length != other._valueKey.Length ||
            !_geometry.AsSpan().SequenceEqual(other._geometry))
        {
            return false;
        }

        for (var i = 0; i < _valueKey.Length; i++)
        {
            if (!StringComparer.Ordinal.Equals(_valueKey[i], other._valueKey[i]))
            {
                return false;
            }
        }

        return true;
    }

    public override bool Equals(object? obj) => obj is FactKey other && Equals(other);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        hash.Add(Domain, StringComparer.Ordinal);
        hash.Add(Kind, StringComparer.Ordinal);
        foreach (var extent in _geometry)
        {
            hash.Add(extent);
        }

        foreach (var component in _valueKey)
        {
            hash.Add(component, StringComparer.Ordinal);
        }

        return hash.ToHashCode();
    }

    public override string ToString() =>
        $"{Domain}/{Kind} ({_geometry.Length} extents, {_valueKey.Length} values)";

    /// <summary>
    /// The canonical representational total order: domain, kind, geometry arity and ordered
    /// coordinates, then value arity and ordinal components. Zero exactly when the keys are
    /// value-equal; the order carries no semantic priority.
    /// </summary>
    internal static int CompareCanonical(FactKey left, FactKey right)
    {
        var comparison = string.CompareOrdinal(left.Domain, right.Domain);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = string.CompareOrdinal(left.Kind, right.Kind);
        if (comparison != 0)
        {
            return comparison;
        }

        comparison = left._geometry.Length.CompareTo(right._geometry.Length);
        if (comparison != 0)
        {
            return comparison;
        }

        for (var i = 0; i < left._geometry.Length; i++)
        {
            comparison = left._geometry[i].Start.CompareTo(right._geometry[i].Start);
            if (comparison != 0)
            {
                return comparison;
            }

            comparison = left._geometry[i].End.CompareTo(right._geometry[i].End);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        comparison = left._valueKey.Length.CompareTo(right._valueKey.Length);
        if (comparison != 0)
        {
            return comparison;
        }

        for (var i = 0; i < left._valueKey.Length; i++)
        {
            comparison = string.CompareOrdinal(left._valueKey[i], right._valueKey[i]);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        return 0;
    }
}
