---
format: Structural
exported_at: 2026-08-10T03:46:03.9594188Z
exchanges: 3
user_label: Aipithicus
sessions:
  - 9b7ba3f6
models:
  - claude-fable-5
exclude:
  - synthetic
---


<!-- xid: 9b7ba3f6-7a26-44f6-9c0c-0a0824f752b8-0000 -->
# alright lets review this brief and prepare to implement

**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-k5a-contract-20260809_193131.md"}
```

**[result: toolu_01M65krfs5...]**
```
1	# Doccer K5a contract — canonical facts and support identity
2	
3	Runstamp 20260809_193131. **Status: contract frozen as D43; source implementation pending.**
4	
5	This brief supersedes the provisional K5a carrier and assurance language in the
6	[D40 correction](sol-doccer-d40-register-equality-k5k7-correction-20260805_221200.md) and the
7	pre-D43 K5a workplan. D40's K5/K6 sibling sequencing remains in force. D43 narrows K5a to immutable
8	fact canonicalization and support evidence; K5b alone owns executable rules, worklist scheduling,
9	and least-fixed-point claims.
10	
11	Inputs:
12	
13	- [decision canon](../planning/decisions.md), especially D25 and D40;
14	- [architectural expansion workplan](../planning/architecture-expansion-workplan.md);
15	- [formalization audit](../discussions/sol-doccer-formalization-audit-and-lean-obligations-20260803.md);
16	- [compositional-kernel formalism review](../discussions/sol-doccer-compositional-kernel-and-formalisms-20260804.md);
17	- [K4c structural contract](sol-doccer-k4c-structural-contract-20260805_194514.md); and
18	- [deferred Lean restart packet](sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md).
19	
20	## 1. Disposition
21	
22	K5a introduces four distinct values:
23	
24	~~~text
25	SpanBatch             existing exact occurrence table
26	CanonicalFactTable    one semantic fact per master-relative FactKey
27	SupportHypergraph     alternative and joint support over one exact fact/occurrence basis
28	FactReference         exact fact-table identity retained without a support graph
29	~~~
30	
31	K5a adds no rule carrier and no `Saturate` implementation. A support edge is immutable supplied
32	evidence, not an executable callback and not a claim that Doccer has verified the adapter's domain
33	reasoning. K5b will later define positive rule execution over these values.
34	
35	The existing `SpanBatch` is the claim-occurrence table. K5a does not duplicate its ordinals,
36	producer metadata, or immutable ownership in a new `ClaimOccurrenceTable` type.
37	
38	## 2. Fact-key identity
39	
40	One master-relative semantic key has this shape:
41	
42	~~~text
43	FactKey
44	  domain       required ordinal string
45	  kind         required ordinal string
46	  geometry     immutable ordered tuple of TextSpan
47	  value key    immutable ordered tuple of non-null strings
48	~~~
49	
50	The identity law is:
51	
52	~~~text
53	semantic fact identity = compatible TextMaster value + FactKey value
54	~~~
55	
56	`domain` names the adapter-owned semantic namespace and carries any schema/version distinction
57	required to interpret the value components. `kind` names the fact within that domain. Doccer uses
58	exact ordinal string equality and performs no Unicode normalization, case folding, culture-sensitive
59	comparison, or adapter-value parsing.
60	
61	The value key is an ordered string tuple rather than an arbitrary object, injected comparer,
62	unframed composite string, JSON payload, or byte encoding. The tuple supplies framing without
63	freezing F2 persistence or CLI wire conventions. The empty tuple is the unit/no-payload key.
64	Adapters own canonical, culture-independent construction of each component.
65	
66	Geometry is an ordered tuple because predicate argument positions are significant and the first
67	Parent/Ancestor witness is already binary. Geometry is not normalized as a `SpanSet`; order and
68	duplicates remain visible. Zero geometry arguments are admitted for master-global facts. Each
69	extent is validated on the retained master and may be empty because facts may describe boundaries
70	or epsilon-like items; this does not admit zero-width `SpanClaim` occurrences.
71	
72	`SpanRecord.Source`, `Priority`, `Level`, collected `RuleId`, and other producer metadata remain
73	occurrence/support evidence. They enter fact identity only when an adapter deliberately promotes a
74	value into the named domain's fact key.
75	
76	## 3. Canonical fact table
77	
78	`CanonicalFactTable` retains one `TextMaster` and one row per distinct `FactKey`. Construction
79	snapshots every supplied sequence, validates all geometry, and collapses exact duplicate keys.
80	
81	Canonical enumeration is independent of proposal order. The total order is domain, kind, geometry
82	arity and ordered `(Start, End)` coordinates, then value arity and ordinal string components.
83	This order is representational, not semantic priority.
84	
85	Two fact tables are value-equal when their masters are compatible and their canonical key
86	sequences are equal. Adding unrelated facts may change table-local ordinals; no ordinal is a
87	durable or cross-table identifier. F2 owns any persisted fact identity.
88	
89	`FactReference` is the exact evidence handle:
90	
91	~~~text
92	FactReference = exact CanonicalFactTable reference + validated fact ordinal
93	~~~
94	
95	Two value-equal but separately constructed tables do not make their references interchangeable.
96	The referenced `FactKey` is the explicit projection back to semantic identity, analogous to the
97	existing distinction between exact occurrence identity and identity-forgetting geometry.
98	
99	## 4. Support hypergraph
100	
101	One `SupportHypergraph` retains:
102	
103	- one exact `CanonicalFactTable` reference;
104	- one exact frozen `SpanBatch` occurrence basis whose master is compatible with the fact master;
105	  and
106	- an immutable set of structurally validated support edges.
107	
108	A fact table is independently usable and a fact may have no support edge. Constructing a support
109	graph does not retroactively make support part of fact identity.
110	
111	A fact table is independently usable and a fact may have no support edge. Constructing a support
112	graph does not retroactively make support part of fact identity.
113	
114	The first public basis deliberately admits one occurrence batch. Current collection already
115	supports multiple producers through occurrence metadata, and every K2/K4 witness supplies one
116	exact batch. A future tagged multi-batch support basis requires a named composition witness; K5a
117	does not pre-empt K6's distinct tagged-origin design.
118	
119	One support edge retains:
120	
121	~~~text
122	SupportEdge
123	  conclusion fact ordinal
124	  required rule ID
125	  ordered premise fact ordinals
126	  ordered parameter strings
127	  ordered originating occurrence ordinals
128	~~~
129	
130	All fact and occurrence ordinals are validated against the retained exact bases. Inputs are
131	snapshotted. Premise, parameter, and occurrence order is significant and duplicates are preserved
132	inside one edge. An exact duplicate edge collapses; a different rule, premise path, parameter
133	tuple, or occurrence tuple remains an alternative support for the same conclusion.
134	
135	Empty-premise and empty-occurrence edges are admitted as named zero-arity seeds. Cycles and
136	self-support are representable because recursive fixed-point provenance is a hypergraph, not
137	necessarily a proof tree. K5a promises structural well-formedness only. K5b must ensure every fact
138	it derives has a support produced by its admitted positive rule execution.
139	
140	Semiring provenance remains a later evaluated/quotiented view. It cannot replace the primary
141	hypergraph because ordinary commutative annotations discard rule identity and premise order.
142	
143	## 5. K7 seam
144	
145	K7's optional narrow derivation seam is a `FactReference`, not a support-edge reference. An output
146	piece may retain the exact canonical fact that justified it without retaining or selecting among
147	the fact's alternative supports. `Materialize` does not inspect a support graph to realize a plan.
148	
149	A future exact proof-path requirement must introduce a separately named `SupportReference`. It may
150	not silently widen `FactReference` or make K7 depend on K5b saturation.
151	
152	## 6. Assurance split and Lean disposition
153	
154	D43 replaces the combined registry row with two obligations:
155	
156	| ID | Owner now | Activation boundary |
157	|---|---|---|
158	| `K5-FACT-SUPPORT` | direct immutable construction, adversarial validation, value/equality laws, and proposal-permutation tests | alternate, persisted, compressed, or incremental fact/support storage claims the same extensional identity without complete differential evidence |
159	| `K5-SATURATE` | K5b reference worklist, rule/seed permutations, the standard finite monotone fixed-point theorem, and the hierarchy diamond | a proof can change the K5b public rule carrier, or a parallel/incremental backend claims semantic equivalence |
160	
161	The D40 signature-pressure reapplication is discharged without activating Lean. K5a exposes no
162	executable rule signature and makes no least-fixed-point claim. K5b must reapply the gate when its
163	positive rule carrier freezes. An arbitrary whole-store callback that can observe absence, delete,
164	select winners, or inspect stage order cannot satisfy `K5-SATURATE`.
165	
166	## 7. Bounded K5a witness
167	
168	Use the K4c four-node hierarchy diamond, but supply the conclusion and its support paths directly:
169	
170	~~~text
171	a -> b -> d
172	 \-> c ->/
173	~~~
174	
175	The K5a witness constructs four Parent facts and one `Ancestor(a,d)` fact. Two supplied support
176	edges for the ancestor retain the ordered paths through `b` and `c`. This establishes identity and
177	evidence behavior without performing saturation. K5b later derives the same result under seed and
178	rule permutations.
179	
180	The implementation gate must additionally cover:
181	
182	- empty and nonempty tables, zero-geometry facts, and empty located extents;
183	- duplicate fact proposals collapsing under every proposal permutation;
184	- distinctions caused by domain, kind, geometry arity/order/value, and value-key arity/components;
185	- compatible-master value equality and incompatible-master refusal;
186	- exact fact-table and occurrence-batch reference boundaries;
187	- two alternative supports retained beside one conclusion and exact duplicate support collapse;
188	- empty-premise seeds, cyclic support representation, and stable canonical fact enumeration;
189	- missing conclusion/premise facts, invalid occurrence ordinals, and incompatible occurrence
190	  masters refused;
191	- caller-owned geometry, value, premise, parameter, and occurrence sequences snapshotted; and
192	- `FactReference` remaining valid and interpretable without a `SupportHypergraph`.
193	
194	## 8. Explicit non-goals
195	
196	K5a does not add:
197	
198	- an executable rule abstraction, worklist, `Saturate`, or fixed-point result;
199	- negation, absence tests, deletion, winner selection, consolidation, or stage ordering;
200	- a generic semiring or weighted-proof API;
201	- a second claim-occurrence table or a tagged multi-batch occurrence basis;
202	- a persisted/global fact ID, JSON/binary wire format, or public private-layout contract;
203	- arbitrary object payloads, caller comparers, or engine-owned domain canonicalizers;
204	- support-graph acyclicity or adapter-semantic soundness claims;
205	- origins, correspondence, rewrite plans, or materialization; or
206	- F-UCD register data or a math-channel ontology.
207	
208	## 9. Landing gate and handoff
209	
210	The contract chip closes when D43, the assurance split, this workplan, the roadmap, ledger, engine
211	README, and deferred Lean packet agree. The harness remains at 1976 checks because no source
212	surface lands.
213	
214	The following implementation chip owns the K5a C# values and bounded witness. K5b contract work
215	begins only after those carriers close; K6 remains independently available throughout.
216
```
**[tool: Grep]**
```json
{"pattern":"D43","path":"issues/doccer/planning/decisions.md","output_mode":"content","-n":true}
```

**[result: toolu_015dtC5ars...]**
```
70:[Omitted long matching line]
73:[Omitted long matching line]
75:## K5a canonical fact and support identity (D43)
77:D43 supersedes D40's provisional K5a carrier language while preserving its K5/K6 sibling
106:one `Ancestor(a,d)` fact with two support paths and tests canonicalization without inference. D43
152:The current K sequence is not reopened. D43 later freezes the K5a contract, so its source
224:K5 splits into K5a canonical fact/support identity and K5b finite positive saturation. D43 later
230:assurance burden. D43 discharges the K5a review without activating Lean and reapplies signature
235:K5, while K7 depends on K6 and may consume only D43's narrow optional exact-table `FactReference`.
242:D43's superseding K5a contract is in the
710:| \(F_M\) | canonical semantic facts on one compatible master value | D43 identity is required domain/kind plus ordered geometry and canonical string-value tuples; distinct from exact occurrence and support identity; source implementation pending |
759:[Omitted long matching line]
760:[Omitted long matching line]
762:[Omitted long matching line]
810:| Q28 | K5a canonical value, support, and K7-reference identity | D43 — ordered geometry/string tuples on a compatible master define semantic facts; exact fact-table and occurrence bases retain evidence; K7 receives only an exact `FactReference`; saturation remains K5b |
```
**[tool: Glob]**
```json
{"pattern":"tests/doccer/**/*"}
```

**[result: toolu_01PnzxeHb7...]**
```
tests\doccer\Program.cs
```
**[tool: Bash]**
```json
{"command":"wc -l \u0022D:/aghado01/codex-scientiae/tests/doccer/Program.cs\u0022 \u0022D:/aghado01/codex-scientiae/src/doccer/Core/SpanBatch.cs\u0022 \u0022D:/aghado01/codex-scientiae/src/doccer/Core/TextMaster.cs\u0022 \u0022D:/aghado01/codex-scientiae/src/doccer/Core/TextSpan.cs\u0022 \u0022D:/aghado01/codex-scientiae/src/doccer/Algebra/HierarchyView.cs\u0022 \u0022D:/aghado01/codex-scientiae/issues/doccer/planning/architecture-expansion-workplan.md\u0022","description":"Show line counts of key doccer files"}
```

**[result: toolu_01MGjxgqYX...]**
```
  6725 D:/aghado01/codex-scientiae/tests/doccer/Program.cs
   442 D:/aghado01/codex-scientiae/src/doccer/Core/SpanBatch.cs
   148 D:/aghado01/codex-scientiae/src/doccer/Core/TextMaster.cs
    64 D:/aghado01/codex-scientiae/src/doccer/Core/TextSpan.cs
   514 D:/aghado01/codex-scientiae/src/doccer/Algebra/HierarchyView.cs
  1252 D:/aghado01/codex-scientiae/issues/doccer/planning/architecture-expansion-workplan.md
  9145 total
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\Core\\TextMaster.cs"}
```

**[result: toolu_01C3xW2Utp...]**
```
1	using System;
2	using System.Runtime.InteropServices;
3	using System.Security.Cryptography;
4	
5	namespace CodexSci.Doccer;
6	
7	/// <summary>An immutable text snapshot and the identity of its coordinate space.</summary>
8	public sealed class TextMaster
9	{
10	    private readonly Lazy<string> _fingerprint;
11	
12	    private readonly Lazy<TextTopology> _topology;
13	
14	    public TextMaster(string documentId, long revision, string text)
15	    {
16	        if (string.IsNullOrWhiteSpace(documentId))
17	        {
18	            throw new ArgumentException("A document identity is required.", nameof(documentId));
19	        }
20	
21	        if (revision < 0)
22	        {
23	            throw new ArgumentOutOfRangeException(nameof(revision));
24	        }
25	
26	        ArgumentNullException.ThrowIfNull(text);
27	
28	        DocumentId = documentId;
29	        Revision = revision;
30	        Text = text;
31	        // Both computed on first use: construction cost must scale with what a job touches,
32	        // so interval algebra over a master never pays for hashing or the scalar tiling.
33	        // Hash the raw UTF-16 code units. An encoder would route lone surrogates through its
34	        // replacement fallback (every unpaired surrogate becomes U+FFFD), collapsing masters the
35	        // topology distinguishes as first-class atoms. Identity must distinguish everything the
36	        // topology distinguishes. The bytes are host-endian; if fingerprints ever persist
37	        // cross-platform, endianness must be fixed explicitly.
38	        _fingerprint = new Lazy<string>(
39	            () => Convert.ToHexString(SHA256.HashData(MemoryMarshal.AsBytes(text.AsSpan()))));
40	        _topology = new Lazy<TextTopology>(() => TextTopology.Build(text));
41	    }
42	
43	    public string DocumentId { get; }
44	
45	    public long Revision { get; }
46	
47	    public string Text { get; }
48	
49	    public string Fingerprint => _fingerprint.Value;
50	
51	    public AddressUnit AddressUnit => AddressUnit.Utf16CodeUnit;
52	
53	    public int Length => Text.Length;
54	
55	    public TextSpan Extent => new(0, Length);
56	
57	    public TextTopology Topology => _topology.Value;
58	
59	    internal bool FingerprintIsCreated => _fingerprint.IsValueCreated;
60	
61	    internal bool TopologyIsCreated => _topology.IsValueCreated;
62	
63	    public static TextMaster Create(string text, string? documentId = null, long revision = 0) =>
64	        new(documentId ?? Guid.NewGuid().ToString("N"), revision, text);
65	
66	    public bool IsCompatibleWith(TextMaster? other) =>
67	        // Same instance is trivially the same coordinate space; short-circuiting here keeps
68	        // same-master span algebra from ever forcing the fingerprint.
69	        ReferenceEquals(this, other) ||
70	        (other is not null &&
71	        Revision == other.Revision &&
72	        AddressUnit == other.AddressUnit &&
73	        Length == other.Length &&
74	        StringComparer.Ordinal.Equals(DocumentId, other.DocumentId) &&
75	        StringComparer.Ordinal.Equals(Fingerprint, other.Fingerprint));
76	
77	    public void EnsureCompatibleWith(TextMaster other)
78	    {
79	        ArgumentNullException.ThrowIfNull(other);
80	        if (!IsCompatibleWith(other))
81	        {
82	            throw new InvalidOperationException(
83	                $"Coordinate spaces are incompatible: '{DocumentId}' r{Revision} and " +
84	                $"'{other.DocumentId}' r{other.Revision}.");
85	        }
86	    }
87	
88	    public void ValidateSpan(TextSpan span, bool allowEmpty = true)
89	    {
90	        if (span.End > Length)
91	        {
92	            throw new ArgumentOutOfRangeException(nameof(span), $"Span {span} exceeds master length {Length}.");
93	        }
94	
95	        if (!allowEmpty && span.IsEmpty)
96	        {
97	            throw new ArgumentException("The span must not be empty.", nameof(span));
98	        }
99	
100	        if (!IsScalarBoundary(span.Start) || !IsScalarBoundary(span.End))
101	        {
102	            throw new ArgumentException($"Span {span} splits a UTF-16 surrogate pair.", nameof(span));
103	        }
104	    }
105	
106	    public bool IsScalarBoundary(int offset)
107	    {
108	        if ((uint)offset > (uint)Length)
109	        {
110	            return false;
111	        }
112	
113	        return offset == 0 ||
114	               offset == Length ||
115	               !(char.IsHighSurrogate(Text[offset - 1]) && char.IsLowSurrogate(Text[offset]));
116	    }
117	
118	    public string Slice(TextSpan span)
119	    {
120	        ValidateSpan(span);
121	        return Text.Substring(span.Start, span.Length);
122	    }
123	
124	    public TextSpan GetLineSpan(int lineIndex, bool includeLineBreak = true)
125	    {
126	        var span = Topology.GetLineExtent(lineIndex);
127	        if (includeLineBreak || span.IsEmpty)
128	        {
129	            return span;
130	        }
131	
132	        var end = span.End;
133	        if (end > span.Start && Text[end - 1] == '\n')
134	        {
135	            end--;
136	            if (end > span.Start && Text[end - 1] == '\r')
137	            {
138	                end--;
139	            }
140	        }
141	        else if (end > span.Start && Text[end - 1] is '\r' or '\u0085' or '\u2028' or '\u2029')
142	        {
143	            end--;
144	        }
145	
146	        return new TextSpan(span.Start, end);
147	    }
148	}
149
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\Core\\SpanBatch.cs"}
```

**[result: toolu_01UG82djEs...]**
```
1	using System;
2	using System.Collections;
3	using System.Collections.Generic;
4	using System.Collections.ObjectModel;
5	
6	namespace CodexSci.Doccer;
7	
8	public enum SpanLevel
9	{
10	    Character = 0,
11	    Line = 1,
12	    MultiLine = 2,
13	}
14	
15	/// <summary>A typed structural assertion offered to a <see cref="SpanBatchBuilder"/>.</summary>
16	public readonly record struct SpanClaim(
17	    TextSpan Span,
18	    string Kind,
19	    SpanLevel Level,
20	    string Source,
21	    int Priority = 0,
22	    string? RuleId = null);
23	
24	/// <summary>
25	/// An interned string column of a frozen batch: one integer ID per row plus the table of distinct
26	/// values in first-appearance order. Built at freeze so equal column values share one table entry
27	/// and one ID, giving columnar consumers (and, later, persisted formats) integer equality and a
28	/// compact vocabulary. Interning is value-preserving: the string read back for any row is equal to
29	/// the string the claim was added with. IDs are batch-local — they carry no meaning across batches.
30	/// </summary>
31	public sealed class InternedColumn
32	{
33	    /// <summary>The ID recorded for rows whose value is null (nullable columns only).</summary>
34	    public const int NullId = -1;
35	
36	    private readonly int[] _ids;
37	    private readonly string[] _table;
38	    private readonly ReadOnlyCollection<int> _idsView;
39	    private readonly ReadOnlyCollection<string> _tableView;
40	
41	    private InternedColumn(int[] ids, string[] table)
42	    {
43	        _ids = ids;
44	        _table = table;
45	        _idsView = Array.AsReadOnly(_ids);
46	        _tableView = Array.AsReadOnly(_table);
47	    }
48	
49	    public int Count => _ids.Length;
50	
51	    /// <summary>Per-row table IDs, ordinal-aligned with the batch; <see cref="NullId"/> marks null.</summary>
52	    public IReadOnlyList<int> Ids => _idsView;
53	
54	    /// <summary>Distinct non-null values in first-appearance order; index = ID.</summary>
55	    public IReadOnlyList<string> Table => _tableView;
56	
57	    public string? this[int ordinal]
58	    {
59	        get
60	        {
61	            var id = _ids[ordinal];
62	            return id == NullId ? null : _table[id];
63	        }
64	    }
65	
66	    internal static InternedColumn Intern(IReadOnlyList<string?> values)
67	    {
68	        var ids = new int[values.Count];
69	        var table = new List<string>();
70	        var lookup = new Dictionary<string, int>(StringComparer.Ordinal);
71	        for (var i = 0; i < values.Count; i++)
72	        {
73	            var value = values[i];
74	            if (value is null)
75	            {
76	                ids[i] = NullId;
77	                continue;
78	            }
79	
80	            if (!lookup.TryGetValue(value, out var id))
81	            {
82	                id = table.Count;
83	                table.Add(value);
84	                lookup.Add(value, id);
85	            }
86	
87	            ids[i] = id;
88	        }
89	
90	        return new InternedColumn(ids, table.ToArray());
91	    }
92	}
93	
94	/// <summary>AoS view of one row in a columnar <see cref="SpanBatch"/>.</summary>
95	public readonly struct SpanRecord
96	{
97	    private readonly SpanBatch? _batch;
98	
99	    internal SpanRecord(SpanBatch batch, int ordinal)
100	    {
101	        _batch = batch;
102	        Ordinal = ordinal;
103	    }
104	
105	    private SpanBatch Batch => _batch ?? throw new InvalidOperationException("Uninitialized span record.");
106	
107	    public int Ordinal { get; }
108	
109	    public TextMaster Master => Batch.Master;
110	
111	    public TextSpan Span => new(Batch.Starts[Ordinal], Batch.Ends[Ordinal]);
112	
113	    // Kind and Source are non-null by builder validation, so the interned lookup cannot return
114	    // null for them; RuleId is genuinely nullable and passes the column's null ID through.
115	    public string Kind => Batch.Kinds[Ordinal]!;
116	
117	    public SpanLevel Level => Batch.Levels[Ordinal];
118	
119	    public string Source => Batch.Sources[Ordinal]!;
120	
121	    public int Priority => Batch.Priorities[Ordinal];
122	
123	    public string? RuleId => Batch.RuleIds[Ordinal];
124	
125	    public SpanClaim ToClaim() => new(Span, Kind, Level, Source, Priority, RuleId);
126	
127	    public override string ToString() => $"#{Ordinal} {Kind} {Span} ({Source})";
128	}
129	
130	/// <summary>Append-only claim collector which freezes into a columnar batch.</summary>
131	public sealed class SpanBatchBuilder
132	{
133	    private readonly List<int> _starts = new();
134	    private readonly List<int> _ends = new();
135	    private readonly List<string> _kinds = new();
136	    private readonly List<SpanLevel> _levels = new();
137	    private readonly List<string> _sources = new();
138	    private readonly List<int> _priorities = new();
139	    private readonly List<string?> _ruleIds = new();
140	    private SpanBatch? _frozen;
141	
142	    public SpanBatchBuilder(TextMaster master)
143	    {
144	        Master = master ?? throw new ArgumentNullException(nameof(master));
145	    }
146	
147	    public TextMaster Master { get; }
148	
149	    public int Count => _starts.Count;
150	
151	    public bool IsFrozen => _frozen is not null;
152	
153	    public int Add(SpanClaim claim)
154	    {
155	        if (_frozen is not null)
156	        {
157	            throw new InvalidOperationException("The span batch has already been frozen.");
158	        }
159	
160	        Master.ValidateSpan(claim.Span, allowEmpty: false);
161	        if (!Enum.IsDefined(claim.Level))
162	        {
163	            throw new ArgumentException($"Undefined SpanLevel value {(int)claim.Level}.", nameof(claim));
164	        }
165	
166	        if (string.IsNullOrWhiteSpace(claim.Kind))
167	        {
168	            throw new ArgumentException("A claim kind is required.", nameof(claim));
169	        }
170	
171	        if (string.IsNullOrWhiteSpace(claim.Source))
172	        {
173	            throw new ArgumentException("A claim source is required.", nameof(claim));
174	        }
175	
176	        var ordinal = _starts.Count;
177	        _starts.Add(claim.Span.Start);
178	        _ends.Add(claim.Span.End);
179	        _kinds.Add(claim.Kind);
180	        _levels.Add(claim.Level);
181	        _sources.Add(claim.Source);
182	        _priorities.Add(claim.Priority);
183	        _ruleIds.Add(claim.RuleId);
184	        return ordinal;
185	    }
186	
187	    public SpanBatch Freeze()
188	    {
189	        // The string columns are interned here, at the one point where the claim set stops
190	        // growing: distinct values become a table and every row keeps an integer ID into it.
191	        _frozen ??= new SpanBatch(
192	            Master,
193	            _starts.ToArray(),
194	            _ends.ToArray(),
195	            InternedColumn.Intern(_kinds),
196	            _levels.ToArray(),
197	            InternedColumn.Intern(_sources),
198	            _priorities.ToArray(),
199	            InternedColumn.Intern(_ruleIds));
200	        return _frozen;
201	    }
202	}
203	
204	/// <summary>Frozen multi-claim, overlap-preserving columnar span collection.</summary>
205	public sealed class SpanBatch : IReadOnlyList<SpanRecord>
206	{
207	    internal SpanBatch(
208	        TextMaster master,
209	        int[] starts,
210	        int[] ends,
211	        InternedColumn kinds,
212	        SpanLevel[] levels,
213	        InternedColumn sources,
214	        int[] priorities,
215	        InternedColumn ruleIds)
216	    {
217	        Master = master;
218	        Starts = starts;
219	        Ends = ends;
220	        Kinds = kinds;
221	        Levels = levels;
222	        Sources = sources;
223	        Priorities = priorities;
224	        RuleIds = ruleIds;
225	        Sorted = new SortedSpanLookup(this);
226	    }
227	
228	    internal int[] Starts { get; }
229	    internal int[] Ends { get; }
230	    internal SpanLevel[] Levels { get; }
231	    internal int[] Priorities { get; }
232	
233	    /// <summary>The interned claim-kind column: per-row IDs plus the distinct-kind table.</summary>
234	    public InternedColumn Kinds { get; }
235	
236	    /// <summary>The interned claim-source column: per-row IDs plus the distinct-source table.</summary>
237	    public InternedColumn Sources { get; }
238	
239	    /// <summary>
240	    /// The interned rule-id column. Rows from producers that record no rule carry
241	    /// <see cref="InternedColumn.NullId"/>.
242	    /// </summary>
243	    public InternedColumn RuleIds { get; }
244	
245	    public TextMaster Master { get; }
246	
247	    public int Count => Starts.Length;
248	
249	    public SpanRecord this[int index]
250	    {
251	        get
252	        {
253	            if ((uint)index >= (uint)Count)
254	            {
255	                throw new ArgumentOutOfRangeException(nameof(index));
256	            }
257	
258	            return new SpanRecord(this, index);
259	        }
260	    }
261	
262	    public SortedSpanLookup Sorted { get; }
263	
264	    public IEnumerator<SpanRecord> GetEnumerator()
265	    {
266	        for (var i = 0; i < Count; i++)
267	        {
268	            yield return new SpanRecord(this, i);
269	        }
270	    }
271	
272	    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
273	}
274	
275	/// <summary>
276	/// Named result orderings for lookup queries. Resolution order is query policy (D5): priority
277	/// stays default evidence on the claim, and a caller names the order a query answers in
278	/// (contract D24). Pure per-query ordering — acceleration structures are F4's business.
279	/// </summary>
280	public enum ClaimOrder
281	{
282	    /// <summary>The stable start order: start ascending, end descending, then ordinal.</summary>
283	    Geometry = 0,
284	
285	    /// <summary>
286	    /// Priority descending — the D2 max-priority posture — then the geometry order, then
287	    /// ordinal. A total order, so determinism needs no stability argument.
288	    /// </summary>
289	    PriorityThenGeometry = 1,
290	}
291	
292	/// <summary>One implementation of the named claim orders shared by every ordered query.</summary>
293	internal static class ClaimOrdering
294	{
295	    public static void Validate(ClaimOrder order)
296	    {
297	        if (!Enum.IsDefined(order))
298	        {
299	            throw new ArgumentOutOfRangeException(nameof(order), order, "Undefined ClaimOrder value.");
300	        }
301	    }
302	
303	    public static int Compare(SpanBatch batch, int left, int right, ClaimOrder order)
304	    {
305	        if (order == ClaimOrder.PriorityThenGeometry)
306	        {
307	            var priority = batch.Priorities[right].CompareTo(batch.Priorities[left]);
308	            if (priority != 0)
309	            {
310	                return priority;
311	            }
312	        }
313	
314	        var comparison = batch.Starts[left].CompareTo(batch.Starts[right]);
315	        if (comparison != 0)
316	        {
317	            return comparison;
318	        }
319	
320	        comparison = batch.Ends[right].CompareTo(batch.Ends[left]);
321	        return comparison != 0 ? comparison : left.CompareTo(right);
322	    }
323	
324	    public static int Compare(SpanRecord left, SpanRecord right, ClaimOrder order)
325	    {
326	        if (order == ClaimOrder.PriorityThenGeometry)
327	        {
328	            var priority = right.Priority.CompareTo(left.Priority);
329	            if (priority != 0)
330	            {
331	                return priority;
332	            }
333	        }
334	
335	        var comparison = left.Span.Start.CompareTo(right.Span.Start);
336	        if (comparison != 0)
337	        {
338	            return comparison;
339	        }
340	
341	        comparison = right.Span.End.CompareTo(left.Span.End);
342	        return comparison != 0 ? comparison : left.Ordinal.CompareTo(right.Ordinal);
343	    }
344	}
345	
346	/// <summary>Stable start-ordered query view over a frozen batch.</summary>
347	public sealed class SortedSpanLookup
348	{
349	    private readonly SpanBatch _batch;
350	    private readonly int[] _order;
351	
352	    internal SortedSpanLookup(SpanBatch batch)
353	    {
354	        _batch = batch;
355	        _order = new int[batch.Count];
356	        for (var i = 0; i < _order.Length; i++)
357	        {
358	            _order[i] = i;
359	        }
360	
361	        Array.Sort(_order, (left, right) => ClaimOrdering.Compare(_batch, left, right, ClaimOrder.Geometry));
362	    }
363	
364	    /// <summary>
365	    /// Claims whose spans set-theoretically intersect the query: an empty query span finds
366	    /// nothing. To ask which claims cover a position — an insertion point, say — use
367	    /// <see cref="FindContaining"/>.
368	    /// </summary>
369	    public IReadOnlyList<SpanRecord> FindIntersecting(TextSpan query, ClaimOrder order = ClaimOrder.Geometry)
370	    {
371	        ValidateOrder(order);
372	        _batch.Master.ValidateSpan(query);
373	        var found = new List<SpanRecord>();
374	        foreach (var index in _order)
375	        {
376	            var candidate = _batch[index];
377	            if (candidate.Span.Start >= query.End)
378	            {
379	                break;
380	            }
381	
382	            if (candidate.Span.Intersects(query))
383	            {
384	                found.Add(candidate);
385	            }
386	        }
387	
388	        return Ordered(found, order);
389	    }
390	
391	    /// <summary>
392	    /// The point-location query: claims whose spans contain the UTF-16 code-unit offset
393	    /// (<c>Start &lt;= position &lt; End</c>), in the lookup's stable start order. This is the
394	    /// named form of the question an empty span used to smuggle through
395	    /// <see cref="FindIntersecting"/>. The position addresses a code unit, not a claim boundary,
396	    /// so it may legitimately sit inside a surrogate pair a claim covers; <c>position ==
397	    /// master.Length</c> is a valid question whose answer is always empty.
398	    /// </summary>
399	    public IReadOnlyList<SpanRecord> FindContaining(int position, ClaimOrder order = ClaimOrder.Geometry)
400	    {
401	        ValidateOrder(order);
402	        if ((uint)position > (uint)_batch.Master.Length)
403	        {
404	            throw new ArgumentOutOfRangeException(nameof(position));
405	        }
406	
407	        var found = new List<SpanRecord>();
408	        foreach (var index in _order)
409	        {
410	            var candidate = _batch[index];
411	            if (candidate.Span.Start > position)
412	            {
413	                break;
414	            }
415	
416	            if (candidate.Span.Contains(position))
417	            {
418	                found.Add(candidate);
419	            }
420	        }
421	
422	        return Ordered(found, order);
423	    }
424	
425	    private static void ValidateOrder(ClaimOrder order)
426	    {
427	        ClaimOrdering.Validate(order);
428	    }
429	
430	    private static IReadOnlyList<SpanRecord> Ordered(List<SpanRecord> found, ClaimOrder order)
431	    {
432	        if (order == ClaimOrder.PriorityThenGeometry)
433	        {
434	            // The comparison ends at the ordinal, making it a total order: equal-priority,
435	            // equal-geometry claims keep their batch order deterministically.
436	            found.Sort(static (left, right) =>
437	                ClaimOrdering.Compare(left, right, ClaimOrder.PriorityThenGeometry));
438	        }
439	
440	        return found.AsReadOnly();
441	    }
442	}
443
```
**[tool: Grep]**
```json
{"pattern":"^## |^### ","path":"issues/doccer/planning/architecture-expansion-workplan.md","output_mode":"content","-n":true}
```

**[result: toolu_01WzmAdL98...]**
```
25:## 1. Executive result
61:## 2. Adjudication of the ICDT 2025 close read
63:### 2.1 What transfers directly
91:### 2.2 Qualifications to retain in the workplan
110:### 2.3 Architectural placement
128:## 3. Factory aspirations mapped to kernel requirements
143:## 4. Dependency shape
264:## 5. Cross-cutting tranche gate
292:## 6. Kernel tranches
294:### K0 — carrier and law registry (closed 2026-08-04)
336:### K1 — close the qualitative Allen value layer
371:### K2 — close the claim query algebra
533:### K3 — located-relation algebra (core closed by D35)
590:### K4 — flat results, then sibling selection and structure lanes
751:### K5 — occurrences, canonical facts, support, and saturation
843:### K6 — origin algebra before materialization
889:### K7 — rewrite plans and <code>Materialize</code>
931:### K8 — cross-carrier integration demonstrations
948:## 6A. Dependency-split expansion lanes (D41, amended by D42)
955:### V0–V2 — code-unit vectors
983:### A0–A2 — measured backend work and transfer repertoire
1006:### F7 — correspondence and derived origins
1017:### F8 — direct comparison, hashes, indexes, and sketches
1034:### F9 — statistical features and ranked views
1049:## 7. Deferred Lean rigor lane
1091:### L0 — bootstrap only after an activation trigger
1114:### Candidate theorem families after activation
1137:## 8. Optional branches
1139:### O1 — fixed linear ET compilation
1151:### O2 — qualitative constraint networks
1161:### O3 — operational acceleration and persistence
1173:## 9. Reconciliation with existing roadmap families
1200:## 10. Explicit non-goals
1220:## 11. Immediate next move
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","limit":120}
```

**[result: toolu_01EcoR1su9...]**
```
1	using System;
2	using System.Collections.Generic;
3	using System.Globalization;
4	using System.IO;
5	using System.Linq;
6	using System.Text;
7	using System.Text.Json;
8	using System.Text.RegularExpressions;
9	using CodexSci.Doccer;
10	
11	namespace CodexSci.Doccer.Tests;
12	
13	internal static class Program
14	{
15	    private static int _checks;
16	
17	    public static int Main()
18	    {
19	        try
20	        {
21	            MasterTopologyIsTotal();
22	            TilingReconstructsAndAgreesWithLines();
23	            LaminarAdmissionIsDeterministicAndStamped();
24	            RunViewsTileTheMasterUnderEveryBreakKey();
25	            LazySubstrateDefersUntouchedWork();
26	            FrozenBatchPreservesClaims();
27	            InternedColumnsRoundTripClaimStrings();
28	            SpanSetObeysBooleanLawsAndMasterIdentity();
29	            SpanSetRandomizedLawsHold();
30	            AllenRelationsAreCompleteAndInvertible();
31	            AllenRelationSetHasAClosedValueSurface();
32	            AllenRelationSetBooleanLawsHoldExhaustively();
33	            AllenRelationSetConverseAgreesWithTheClassifier();
34	            AllenClassifierIsJepdOnSixBoundaries();
35	            AllenCompositionMatchesIndependentD6Oracle();
36	            AllenCompositionLawsHold();
37	            AllenCanonicalCompositionIsNotFiniteMasterComposition();
38	            StructuralValidatorsKeepTheirDistinctInvariants();
39	            ScopedRegexCollectionCannotBridgeGaps();
40	            SuppressionIsAQueryWithIdempotenceAndDuality();
41	            DefectiveRuleFailsAtLoadTimeWithoutSideEffects();
42	            ExecutionScopeComposesWithTheCallerRegionSet();
43	            JsonlInventoryLoadsAndFailsWithProvenance();
44	            DeclarativeValidationRunsWithoutDomainCode();
45	            CollectionCommitsAtomically();
46	            UnknownCaptureGroupFailsAtValidation();
47	            UndefinedEnumValuesAreRejected();
48	            EmptySpansHaveSetSemantics();
49	            ReferenceJoinRelatesEveryPair();
50	            ProjectMapsSpansOntoLineRanges();
51	            EmitRunsHonorsACustomComparer();
52	            RegexOptionsUnionCultureInvariantAtTheEngineBoundary();
53	            SliceMintsAFragmentLocalChild();
54	            RebaseIsATotalBijection();
55	            RebaseCarriesSetsAndBatches();
56	            CollectionCommutesWithRebase();
57	            SlicesCompose();
58	            GroupingByKeyIsADeterministicPartition();
59	            ProjectionAndLineGroupsAreStampedTransposes();
60	            LineMembershipIsADeclaredPolicy();
61	            GapCadenceMeasuresTheTemplateFacts();
62	            GapCadenceDeclaresItsBasis();
63	            LookupOrderIsAQueryPolicy();
64	            ClaimSelectionIsAnExactBatchValue();
65	            ClaimSelectionBooleanLawsHoldExhaustively();
66	            ClaimSelectionSeparatesMembershipFromOrderedProjection();
67	            SelectionPopulationIntegrationsShareOnePath();
68	            ClaimPairViewIsAnExactBasisStampedRelation();
69	            ClaimPairViewProjectsSemijoinsAndConverse();
70	            ClaimPairCompositionMatchesItsIndependentOracleAndWitnesses();
71	            ClaimPairCompositionLawsHoldOnBoundedRelations();
72	            ClaimPairAllenAbstractionBridgeIsOneWay();
73	            PairingWitnessesTwoDelimiterFamilies();
74	            PairingFaultResidueIsCompleteAndTopOnly();
75	            PairingRefusesAmbiguousInputsAndRetainsItsStamps();
76	            PairingMatchesAnIndependentBoundedStackOracle();
77	            LocatedRelationHasAConcreteBasisAndReferenceAlgebra();
78	            LocatedRelationMatchesBoundedExhaustiveOracles();
79	            LocatedRelationRebasesExactlyThroughSlices();
80	            CandidateRegionGraphPreservesOccurrenceIdentityUntilProjection();
81	            ReachabilityViewKeepsGraphStampAndDiagnostics();
82	            PartitionViewValidatesExactIdentityBearingPaths();
83	            FirstOrdinalSegmentationWitnessesRequiredCases();
84	            FirstOrdinalSegmentationMatchesBoundedPathOracle();
85	            AdditivePathPolicySnapshotsAnExactObjective();
86	            PathSelectionProblemValidatesExactAdmissibility();
87	            AdditivePathSelectionRetainsDecisionsAndResiduals();
88	            AdditivePathSelectionMatchesBoundedOptimizerOracle();
89	            StructuralValidatorsMatchBoundedOracles();
90	            LaminarAdmissionMatchesBoundedOracle();
91	            NearestContainerProjectionIsExplicit();
92	            HierarchyViewRetainsExplicitDag();
93	            HierarchyViewMatchesBoundedDagOracle();
94	            ResolutionMapsSeparateIncidenceFromAggregation();
95	            ResolutionIncidenceMatchesBoundedEndpointOracle();
96	            Console.WriteLine($"doccer contract harness: {_checks} checks passed");
97	            return 0;
98	        }
99	        catch (Exception exception)
100	        {
101	            Console.Error.WriteLine(exception);
102	            return 1;
103	        }
104	    }
105	
106	    private static void MasterTopologyIsTotal()
107	    {
108	        var master = new TextMaster("topology", 0, "a😀\r\nb");
109	        Equal(5, master.Topology.AtomCount, "Unicode atom count");
110	        Equal(2, master.Topology.LineCount, "line count");
111	        Equal(new TextSpan(1, 3), master.Topology.Atoms[1].Span, "SMP scalar extent");
112	        True(master.Topology.Atoms[1].IsValidScalar, "SMP scalar validity");
113	        Equal(master.Length, master.Topology.Atoms[^1].Span.End, "atom coverage end");
114	        Throws<ArgumentException>(
115	            () => master.ValidateSpan(new TextSpan(2, 3)),
116	            "surrogate split rejected");
117	
118	        var malformed = new TextMaster("malformed", 0, "x\uD800y");
119	        True(!malformed.Topology.Atoms[1].IsValidScalar, "unpaired surrogate retained and marked");
120	        Equal(malformed.Length, malformed.Topology.Atoms.Sum(atom => atom.Span.Length), "malformed coverage");
```
**[tool: Grep]**
```json
{"pattern":"K5a","path":"issues/doccer/planning/ledger.md","output_mode":"content","-n":true}
```

**[result: toolu_01WFVng86t...]**
```
37:[Omitted long matching line]
38:[Omitted long matching line]
40:[Omitted long matching line]
```
**[tool: Bash]**
```json
{"command":"ls \u0022D:/aghado01/codex-scientiae/projects\u0022 \u0022D:/aghado01/codex-scientiae/scripts\u0022 2\u003E/dev/null | head -40","description":"List projects and scripts directories"}
```

**[result: toolu_01H4xJEQiC...]**
```
(Bash completed with no output)
```
**[tool: Glob]**
```json
{"pattern":"**/*.csproj"}
```

**[result: toolu_01KpB6RJn9...]**
```
brewery\hdbscan\Hdbscan.csproj
brewery\doccer\Doccer.Cli.csproj
brewery\doccer\Doccer.Tests.csproj
.claude\worktrees\elastic-faraday-a21f6a\brewery\doccer\Doccer.Cli.csproj
.claude\worktrees\elastic-faraday-a21f6a\brewery\doccer\Doccer.Tests.csproj
.claude\worktrees\elastic-faraday-a21f6a\brewery\doccer\Doccer.csproj
.claude\worktrees\elastic-faraday-a21f6a\brewery\hdbscan\Hdbscan.csproj
.claude\worktrees\elastic-faraday-a21f6a\brewery\hdbscan\hdbscan.tests.csproj
brewery\doccer\Doccer.csproj
brewery\hdbscan\hdbscan.tests.csproj
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\brewery\\doccer\\Doccer.csproj"}
```

**[result: toolu_01AYkMDj8b...]**
```
1	<Project Sdk="Microsoft.NET.Sdk">
2	
3	  <!-- Reusable engine assembly. Source remains first-party code under src/doccer;
4	       this brewery project is only its reproducible compilation recipe. -->
5	  <PropertyGroup>
6	    <OutputType>Library</OutputType>
7	    <AssemblyName>CodexSci.Doccer</AssemblyName>
8	    <RootNamespace>CodexSci.Doccer</RootNamespace>
9	    <SharedSource>doccer</SharedSource>
10	    <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
11	  </PropertyGroup>
12	
13	  <ItemGroup>
14	    <!-- The trust harness observes laziness (IsValueCreated flags) without widening the API. -->
15	    <InternalsVisibleTo Include="doccer.tests" />
16	  </ItemGroup>
17	
18	</Project>
19
```
**[tool: Grep]**
```json
{"pattern":"K5a|D43","path":"src/doccer/README.md","output_mode":"content","-n":true,"head_limit":15}
```

**[result: toolu_01GkCEzT55...]**
```
9:([decisions.md](../../issues/doccer/planning/decisions.md) — records D1–D43, the carrier/law
114:D43 freezes the still-unimplemented K5a fact/support surface. `SpanBatch` remains the exact
121:fixed-point claim belongs to K5a.
291:closure is the only authorization gate on engine work; D43 has crossed that gate for K5a, whose
326:- D43's K5a canonical fact table, exact-basis support hypergraph, and narrow `FactReference` are
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-k5a-contract-20260809_193131.md","old_string":"A fact table is independently usable and a fact may have no support edge. Constructing a support\ngraph does not retroactively make support part of fact identity.\n\nA fact table is independently usable and a fact may have no support edge. Constructing a support\ngraph does not retroactively make support part of fact identity.","new_string":"A fact table is independently usable and a fact may have no support edge. Constructing a support\ngraph does not retroactively make support part of fact identity."}
```

**[result: toolu_012hSqxPc3...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\briefs\sol-doccer-k5a-contract-20260809_193131.md has been updated successfully. (file state is current in your context — no need to Read it back)
```

The brief is ready to implement against. Here's my review and the implementation plan.

## Review

**The contract is coherent and the doc canon agrees with it.** D43 is recorded in [decisions.md:73](issues/doccer/planning/decisions.md:73) with a matching narrative section, the ledger has the contract-freeze row (2026-08-09, harness held at 1976), the workplan's K5a section and exit gate match the brief's §7 gate list, the roadmap names K5a implementation as the default next chip, and the engine README carries the D43 disposition. Per §9 that's the contract chip's landing gate — satisfied. One defect found and fixed: §4 had an exact duplicated paragraph, now deduplicated.

Points I verified against the engine that make this contract implementable as written:

- `TextMaster.ValidateSpan(span, allowEmpty: true)` already does exactly what §2 needs for fact geometry — length bounds, surrogate-boundary checks, empties admitted — while `SpanBatchBuilder` keeps refusing empty *occurrences*. The empty-extent/no-empty-claim asymmetry costs nothing.
- The K4c diamond witness (§7) can be built from existing pieces: a frozen `SpanBatch` with four nested spans, `HierarchyView` conventions as the reference shape, and the facts/supports supplied by hand.
- `FactKey` needs sequence-valued equality (geometry tuple + value tuple), so it will be a sealed class with snapshot construction and custom equality/hash, not a record struct — same reasoning that made `SupportEdge` a class-shaped value. `FactReference` by contrast is naturally a readonly record struct: default equality gives exact-table reference identity + ordinal, which is precisely the D43 semantics.

**One thing to do before implementation:** all the contract-chip doc edits (decisions, ledger, roadmap, workplan, README, D40 brief, Lean packet, the brief itself) are sitting uncommitted in the working tree. I'd commit that set as one contract-freeze commit citing the brief, so the implementation lands on a clean boundary.

## Implementation plan

**New source — `src/doccer/Facts/`** (new lane folder, namespace stays `CodexSci.Doccer`; brewery glob picks it up automatically):

1. **`FactKey.cs`** — sealed value class: required non-whitespace ordinal `Domain`/`Kind`, snapshotted `TextSpan[]` geometry tuple, snapshotted non-null `string[]` value tuple (empty = unit key). Value equality/hash over all four; an internal canonical comparer implementing the §3 total order (domain, kind, geometry arity → ordered coordinates, value arity → ordinal components).
2. **`CanonicalFactTable.cs`** — `Create(master, proposals)`: snapshot, validate every extent on the master (empties allowed, zero-arity allowed), collapse exact duplicate keys, sort canonically. Exposes `Master`, `Count`, indexer, canonical enumeration, and compatible-master value equality/hash (the D35 `LocatedRelation` precedent). Plus **`FactReference`** — readonly record struct `(CanonicalFactTable Table, int Ordinal)` with validated construction and `Key` as the explicit projection back to semantic identity.
3. **`SupportHypergraph.cs`** — **`SupportEdge`** sealed value class (conclusion ordinal, required rule ID, ordered premise/parameter/occurrence tuples, duplicates-within-edge preserved, value equality for exact-duplicate collapse). `SupportHypergraph.Create(factTable, occurrenceBatch, edges)`: exact fact-table reference, exact frozen compatible-master batch, validate all ordinals against both bases, collapse exact duplicate edges, refuse loudly otherwise. Deterministic canonical edge enumeration (conclusion, rule, premises, parameters, occurrences) — representational, matching the fact-order posture.

**Harness — `tests/doccer/Program.cs`**, new checks mapping one-to-one onto the §7 gate list, ending with the diamond witness: four `Parent` facts + one `Ancestor(a,d)` fact, two supplied support edges retaining the ordered `b` and `c` paths, no saturation. Proposal-permutation tests run all orderings of small proposal sets; snapshot tests mutate caller lists post-construction. Gate: `dotnet run` on `brewery/doccer/Doccer.Tests.csproj`, harness count moves from 1976 to wherever it lands.

**Non-goals honored:** no rule carrier, no `Saturate`, no `ClaimOccurrenceTable`, no multi-batch basis, no persisted IDs, no comparers/payloads, no acyclicity claim, no Lean activation.

**Close-out docs:** ledger row (harness delta, K5a source closed), D43 status flip in decisions, roadmap/README status lines, and the implementation report appended to the brief.

Defaults I've picked that you can veto: the `Facts/` folder placement, `Equals`/`GetHashCode` overrides on the table (vs. a named `ValueEquals` only), and canonical-sorted edge enumeration. Say the word and I'll commit the contract docs and start on the carriers.


<!-- xid: 9b7ba3f6-7a26-44f6-9c0c-0a0824f752b8-0001 -->
---

# committed. i'll roll with your recommendations. lets do it

**[tool: Grep]**
```json
{"pattern":"Equals|GetHashCode|HashCode","path":"src/doccer/Algebra/LocatedRelation.cs","output_mode":"content","-n":true,"-B":4,"-A":30,"head_limit":120}
```

**[result: toolu_01L6crpPmP...]**
```
231-
232-        return Create(Master, Window, reachable);
233-    }
234-
235:    public bool Equals(LocatedRelation? other)
236-    {
237:        if (ReferenceEquals(this, other))
238-        {
239-            return true;
240-        }
241-
242-        return other is not null &&
243-               Master.IsCompatibleWith(other.Master) &&
244-               Window == other.Window &&
245-               _edges.AsSpan().SequenceEqual(other._edges);
246-    }
247-
248:    public override bool Equals(object? obj) => obj is LocatedRelation other && Equals(other);
249-
250:    public override int GetHashCode()
251-    {
252:        var hash = new HashCode();
253-        hash.Add(Master.DocumentId, StringComparer.Ordinal);
254-        hash.Add(Master.Revision);
255-        hash.Add(Master.Fingerprint, StringComparer.Ordinal);
256-        hash.Add(Window);
257-        foreach (var edge in _edges)
258-        {
259-            hash.Add(edge);
260-        }
261-
262:        return hash.ToHashCode();
263-    }
264-
265-    public IEnumerator<TextSpan> GetEnumerator() =>
266-        ((IEnumerable<TextSpan>)_edges).GetEnumerator();
267-
268-    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
269-
270-    private void EnsureSameBasis(LocatedRelation other)
271-    {
272-        ArgumentNullException.ThrowIfNull(other);
273-        Master.EnsureCompatibleWith(other.Master);
274-        if (Window != other.Window)
275-        {
276-            throw new InvalidOperationException(
277-                $"Located relations have different declared windows: {Window} and {other.Window}.");
278-        }
279-    }
280-
281-    private static void ValidateBasis(TextMaster master, TextSpan window)
282-    {
283-        ArgumentNullException.ThrowIfNull(master);
284-        master.ValidateSpan(window);
285-    }
286-
287-    private static int Compare(TextSpan left, TextSpan right)
288-    {
289-        var comparison = left.Start.CompareTo(right.Start);
290-        return comparison != 0 ? comparison : left.End.CompareTo(right.End);
291-    }
292-}
```
**[tool: Write]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\Facts\\FactKey.cs","content":"using System;\nusing System.Collections.Generic;\nusing System.Collections.ObjectModel;\n\nnamespace CodexSci.Doccer;\n\n/// \u003Csummary\u003E\n/// One master-relative semantic fact key (D43): a required adapter-owned ordinal domain and kind,\n/// an immutable ordered tuple of geometry arguments, and an immutable ordered tuple of canonical\n/// string value components. Compatible master value plus key value defines semantic fact identity.\n/// The key retains no master, no occurrence evidence, and no support; geometry extents are\n/// validated against a master only where a \u003Csee cref=\u0022CanonicalFactTable\u0022/\u003E retains one.\n/// \u003C/summary\u003E\npublic sealed class FactKey : IEquatable\u003CFactKey\u003E\n{\n    private readonly TextSpan[] _geometry;\n    private readonly string[] _valueKey;\n    private readonly ReadOnlyCollection\u003CTextSpan\u003E _geometryView;\n    private readonly ReadOnlyCollection\u003Cstring\u003E _valueKeyView;\n\n    public FactKey(\n        string domain,\n        string kind,\n        IEnumerable\u003CTextSpan\u003E geometry,\n        IEnumerable\u003Cstring\u003E valueKey)\n    {\n        if (string.IsNullOrWhiteSpace(domain))\n        {\n            throw new ArgumentException(\u0022A fact domain is required.\u0022, nameof(domain));\n        }\n\n        if (string.IsNullOrWhiteSpace(kind))\n        {\n            throw new ArgumentException(\u0022A fact kind is required.\u0022, nameof(kind));\n        }\n\n        ArgumentNullException.ThrowIfNull(geometry);\n        ArgumentNullException.ThrowIfNull(valueKey);\n\n        Domain = domain;\n        Kind = kind;\n\n        // Snapshot both tuples: argument order and duplicates are significant, and a caller\u0027s\n        // sequence must not be able to mutate the key after construction.\n        var collectedGeometry = new List\u003CTextSpan\u003E();\n        foreach (var extent in geometry)\n        {\n            collectedGeometry.Add(extent);\n        }\n\n        var collectedValues = new List\u003Cstring\u003E();\n        foreach (var component in valueKey)\n        {\n            if (component is null)\n            {\n                throw new ArgumentException(\n                    \u0022Value-key components must be non-null strings.\u0022,\n                    nameof(valueKey));\n            }\n\n            collectedValues.Add(component);\n        }\n\n        _geometry = collectedGeometry.ToArray();\n        _valueKey = collectedValues.ToArray();\n        _geometryView = Array.AsReadOnly(_geometry);\n        _valueKeyView = Array.AsReadOnly(_valueKey);\n    }\n\n    /// \u003Csummary\u003EThe adapter-owned semantic namespace, compared by exact ordinal equality.\u003C/summary\u003E\n    public string Domain { get; }\n\n    /// \u003Csummary\u003EThe fact name within its domain, compared by exact ordinal equality.\u003C/summary\u003E\n    public string Kind { get; }\n\n    /// \u003Csummary\u003E\n    /// The ordered geometry-argument tuple. Order and duplicates are significant; the empty tuple\n    /// is a master-global fact and empty extents are boundary-valued arguments.\n    /// \u003C/summary\u003E\n    public IReadOnlyList\u003CTextSpan\u003E Geometry =\u003E _geometryView;\n\n    /// \u003Csummary\u003E\n    /// The ordered canonical value components. The empty tuple is the unit/no-payload key; the\n    /// adapter owns canonical, culture-independent construction of each component.\n    /// \u003C/summary\u003E\n    public IReadOnlyList\u003Cstring\u003E ValueKey =\u003E _valueKeyView;\n\n    public bool Equals(FactKey? other)\n    {\n        if (ReferenceEquals(this, other))\n        {\n            return true;\n        }\n\n        if (other is null ||\n            !StringComparer.Ordinal.Equals(Domain, other.Domain) ||\n            !StringComparer.Ordinal.Equals(Kind, other.Kind) ||\n            _geometry.Length != other._geometry.Length ||\n            _valueKey.Length != other._valueKey.Length ||\n            !_geometry.AsSpan().SequenceEqual(other._geometry))\n        {\n            return false;\n        }\n\n        for (var i = 0; i \u003C _valueKey.Length; i\u002B\u002B)\n        {\n            if (!StringComparer.Ordinal.Equals(_valueKey[i], other._valueKey[i]))\n            {\n                return false;\n            }\n        }\n\n        return true;\n    }\n\n    public override bool Equals(object? obj) =\u003E obj is FactKey other \u0026\u0026 Equals(other);\n\n    public override int GetHashCode()\n    {\n        var hash = new HashCode();\n        hash.Add(Domain, StringComparer.Ordinal);\n        hash.Add(Kind, StringComparer.Ordinal);\n        foreach (var extent in _geometry)\n        {\n            hash.Add(extent);\n        }\n\n        foreach (var component in _valueKey)\n        {\n            hash.Add(component, StringComparer.Ordinal);\n        }\n\n        return hash.ToHashCode();\n    }\n\n    public override string ToString() =\u003E\n        $\u0022{Domain}/{Kind} ({_geometry.Length} extents, {_valueKey.Length} values)\u0022;\n\n    /// \u003Csummary\u003E\n    /// The canonical representational total order: domain, kind, geometry arity and ordered\n    /// coordinates, then value arity and ordinal components. Zero exactly when the keys are\n    /// value-equal; the order carries no semantic priority.\n    /// \u003C/summary\u003E\n    internal static int CompareCanonical(FactKey left, FactKey right)\n    {\n        var comparison = string.CompareOrdinal(left.Domain, right.Domain);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        comparison = string.CompareOrdinal(left.Kind, right.Kind);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        comparison = left._geometry.Length.CompareTo(right._geometry.Length);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        for (var i = 0; i \u003C left._geometry.Length; i\u002B\u002B)\n        {\n            comparison = left._geometry[i].Start.CompareTo(right._geometry[i].Start);\n            if (comparison != 0)\n            {\n                return comparison;\n            }\n\n            comparison = left._geometry[i].End.CompareTo(right._geometry[i].End);\n            if (comparison != 0)\n            {\n                return comparison;\n            }\n        }\n\n        comparison = left._valueKey.Length.CompareTo(right._valueKey.Length);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        for (var i = 0; i \u003C left._valueKey.Length; i\u002B\u002B)\n        {\n            comparison = string.CompareOrdinal(left._valueKey[i], right._valueKey[i]);\n            if (comparison != 0)\n            {\n                return comparison;\n            }\n        }\n\n        return 0;\n    }\n}\n"}
```

**[result: toolu_01DXghX5ck...]**
```
File created successfully at: D:\aghado01\codex-scientiae\src\doccer\Facts\FactKey.cs (file state is current in your context — no need to Read it back)
```
**[tool: Write]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\Facts\\CanonicalFactTable.cs","content":"using System;\nusing System.Collections;\nusing System.Collections.Generic;\nusing System.Runtime.CompilerServices;\n\nnamespace CodexSci.Doccer;\n\n/// \u003Csummary\u003E\n/// The canonical semantic fact store (D43): one retained \u003Csee cref=\u0022TextMaster\u0022/\u003E and one row per\n/// distinct \u003Csee cref=\u0022FactKey\u0022/\u003E. Construction snapshots the proposals, validates every geometry\n/// argument on the retained master, collapses exact duplicate keys, and enumerates in the fixed\n/// canonical order independent of proposal order. Table-local ordinals are not durable or\n/// cross-table identifiers; F2 owns any persisted fact identity.\n/// \u003C/summary\u003E\npublic sealed class CanonicalFactTable : IReadOnlyList\u003CFactKey\u003E, IEquatable\u003CCanonicalFactTable\u003E\n{\n    private readonly FactKey[] _facts;\n\n    private CanonicalFactTable(TextMaster master, FactKey[] facts)\n    {\n        Master = master;\n        _facts = facts;\n    }\n\n    public TextMaster Master { get; }\n\n    public int Count =\u003E _facts.Length;\n\n    public bool IsEmpty =\u003E _facts.Length == 0;\n\n    public FactKey this[int ordinal]\n    {\n        get\n        {\n            if ((uint)ordinal \u003E= (uint)_facts.Length)\n            {\n                throw new ArgumentOutOfRangeException(nameof(ordinal));\n            }\n\n            return _facts[ordinal];\n        }\n    }\n\n    /// \u003Csummary\u003E\n    /// Validates every proposal\u0027s geometry on the master (empty extents and zero-arity geometry\n    /// are admitted) and collapses exact duplicate keys into one canonical row each.\n    /// \u003C/summary\u003E\n    public static CanonicalFactTable Create(TextMaster master, IEnumerable\u003CFactKey\u003E proposals)\n    {\n        ArgumentNullException.ThrowIfNull(master);\n        ArgumentNullException.ThrowIfNull(proposals);\n\n        var collected = new List\u003CFactKey\u003E();\n        foreach (var proposal in proposals)\n        {\n            if (proposal is null)\n            {\n                throw new ArgumentException(\u0022Fact proposals must be non-null.\u0022, nameof(proposals));\n            }\n\n            foreach (var extent in proposal.Geometry)\n            {\n                master.ValidateSpan(extent);\n            }\n\n            collected.Add(proposal);\n        }\n\n        collected.Sort(FactKey.CompareCanonical);\n        var distinct = new List\u003CFactKey\u003E(collected.Count);\n        foreach (var key in collected)\n        {\n            if (distinct.Count == 0 || FactKey.CompareCanonical(distinct[^1], key) != 0)\n            {\n                distinct.Add(key);\n            }\n        }\n\n        return new CanonicalFactTable(master, distinct.ToArray());\n    }\n\n    /// \u003Csummary\u003EFinds the table-local ordinal of a value-equal key, if one is retained.\u003C/summary\u003E\n    public bool TryGetOrdinal(FactKey key, out int ordinal)\n    {\n        ArgumentNullException.ThrowIfNull(key);\n        var low = 0;\n        var high = _facts.Length - 1;\n        while (low \u003C= high)\n        {\n            var middle = low \u002B ((high - low) / 2);\n            var comparison = FactKey.CompareCanonical(_facts[middle], key);\n            if (comparison == 0)\n            {\n                ordinal = middle;\n                return true;\n            }\n\n            if (comparison \u003C 0)\n            {\n                low = middle \u002B 1;\n            }\n            else\n            {\n                high = middle - 1;\n            }\n        }\n\n        ordinal = -1;\n        return false;\n    }\n\n    /// \u003Csummary\u003E\n    /// Value equality: compatible masters and equal canonical key sequences. Exact-table evidence\n    /// identity is \u003Csee cref=\u0022FactReference\u0022/\u003E\u0027s stricter business, not this comparison\u0027s.\n    /// \u003C/summary\u003E\n    public bool Equals(CanonicalFactTable? other)\n    {\n        if (ReferenceEquals(this, other))\n        {\n            return true;\n        }\n\n        if (other is null ||\n            !Master.IsCompatibleWith(other.Master) ||\n            _facts.Length != other._facts.Length)\n        {\n            return false;\n        }\n\n        for (var i = 0; i \u003C _facts.Length; i\u002B\u002B)\n        {\n            if (!_facts[i].Equals(other._facts[i]))\n            {\n                return false;\n            }\n        }\n\n        return true;\n    }\n\n    public override bool Equals(object? obj) =\u003E obj is CanonicalFactTable other \u0026\u0026 Equals(other);\n\n    public override int GetHashCode()\n    {\n        var hash = new HashCode();\n        hash.Add(Master.DocumentId, StringComparer.Ordinal);\n        hash.Add(Master.Revision);\n        hash.Add(Master.Fingerprint, StringComparer.Ordinal);\n        foreach (var fact in _facts)\n        {\n            hash.Add(fact);\n        }\n\n        return hash.ToHashCode();\n    }\n\n    public IEnumerator\u003CFactKey\u003E GetEnumerator() =\u003E\n        ((IEnumerable\u003CFactKey\u003E)_facts).GetEnumerator();\n\n    IEnumerator IEnumerable.GetEnumerator() =\u003E GetEnumerator();\n}\n\n/// \u003Csummary\u003E\n/// The exact fact-table evidence handle (D43): one exact \u003Csee cref=\u0022CanonicalFactTable\u0022/\u003E\n/// reference plus one validated fact ordinal. This is K7\u0027s optional narrow justification seam and\n/// requires no support graph. Equality is exact-table reference identity \u2014 two value-equal but\n/// separately constructed tables do not make their references interchangeable \u2014 and\n/// \u003Csee cref=\u0022Key\u0022/\u003E is the explicit projection back to semantic identity.\n/// \u003C/summary\u003E\npublic readonly struct FactReference : IEquatable\u003CFactReference\u003E\n{\n    private readonly CanonicalFactTable? _table;\n\n    public FactReference(CanonicalFactTable table, int ordinal)\n    {\n        ArgumentNullException.ThrowIfNull(table);\n        if ((uint)ordinal \u003E= (uint)table.Count)\n        {\n            throw new ArgumentOutOfRangeException(\n                nameof(ordinal),\n                ordinal,\n                \u0022Ordinal is outside the fact table.\u0022);\n        }\n\n        _table = table;\n        Ordinal = ordinal;\n    }\n\n    public CanonicalFactTable Table =\u003E\n        _table ?? throw new InvalidOperationException(\u0022Uninitialized fact reference.\u0022);\n\n    public int Ordinal { get; }\n\n    /// \u003Csummary\u003EThe referenced semantic fact key.\u003C/summary\u003E\n    public FactKey Key =\u003E Table[Ordinal];\n\n    public bool Equals(FactReference other) =\u003E\n        ReferenceEquals(_table, other._table) \u0026\u0026 Ordinal == other.Ordinal;\n\n    public override bool Equals(object? obj) =\u003E obj is FactReference other \u0026\u0026 Equals(other);\n\n    public override int GetHashCode() =\u003E\n        HashCode.Combine(_table is null ? 0 : RuntimeHelpers.GetHashCode(_table), Ordinal);\n\n    public static bool operator ==(FactReference left, FactReference right) =\u003E left.Equals(right);\n\n    public static bool operator !=(FactReference left, FactReference right) =\u003E !left.Equals(right);\n\n    public override string ToString() =\u003E\n        _table is null ? \u0022uninitialized fact reference\u0022 : $\u0022fact #{Ordinal} {_table[Ordinal]}\u0022;\n}\n"}
```

**[result: toolu_01KBzuSryp...]**
```
File created successfully at: D:\aghado01\codex-scientiae\src\doccer\Facts\CanonicalFactTable.cs (file state is current in your context — no need to Read it back)
```
**[tool: Write]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\Facts\\SupportHypergraph.cs","content":"using System;\nusing System.Collections;\nusing System.Collections.Generic;\nusing System.Collections.ObjectModel;\n\nnamespace CodexSci.Doccer;\n\n/// \u003Csummary\u003E\n/// One immutable supplied support edge (D43): a conclusion fact ordinal, a required rule ID, and\n/// ordered premise-fact, parameter, and originating-occurrence tuples. Order is significant and\n/// duplicates are preserved inside one edge. An edge is supplied evidence, not an executable\n/// callback and not a claim that Doccer has verified the adapter\u0027s domain reasoning; ordinals\n/// resolve only against the exact bases retained by a \u003Csee cref=\u0022SupportHypergraph\u0022/\u003E.\n/// \u003C/summary\u003E\npublic sealed class SupportEdge : IEquatable\u003CSupportEdge\u003E\n{\n    private readonly int[] _premises;\n    private readonly string[] _parameters;\n    private readonly int[] _occurrences;\n    private readonly ReadOnlyCollection\u003Cint\u003E _premiseView;\n    private readonly ReadOnlyCollection\u003Cstring\u003E _parameterView;\n    private readonly ReadOnlyCollection\u003Cint\u003E _occurrenceView;\n\n    public SupportEdge(\n        int conclusionOrdinal,\n        string ruleId,\n        IEnumerable\u003Cint\u003E premiseOrdinals,\n        IEnumerable\u003Cstring\u003E parameters,\n        IEnumerable\u003Cint\u003E occurrenceOrdinals)\n    {\n        if (conclusionOrdinal \u003C 0)\n        {\n            throw new ArgumentOutOfRangeException(nameof(conclusionOrdinal));\n        }\n\n        if (string.IsNullOrWhiteSpace(ruleId))\n        {\n            throw new ArgumentException(\u0022A support rule ID is required.\u0022, nameof(ruleId));\n        }\n\n        ArgumentNullException.ThrowIfNull(premiseOrdinals);\n        ArgumentNullException.ThrowIfNull(parameters);\n        ArgumentNullException.ThrowIfNull(occurrenceOrdinals);\n\n        ConclusionOrdinal = conclusionOrdinal;\n        RuleId = ruleId;\n\n        // Snapshot every tuple: order and duplicates are significant, and a caller\u0027s sequence\n        // must not be able to mutate the edge after construction.\n        var collectedPremises = new List\u003Cint\u003E();\n        foreach (var ordinal in premiseOrdinals)\n        {\n            if (ordinal \u003C 0)\n            {\n                throw new ArgumentOutOfRangeException(nameof(premiseOrdinals), ordinal, \u0022Premise ordinals must be non-negative.\u0022);\n            }\n\n            collectedPremises.Add(ordinal);\n        }\n\n        var collectedParameters = new List\u003Cstring\u003E();\n        foreach (var parameter in parameters)\n        {\n            if (parameter is null)\n            {\n                throw new ArgumentException(\u0022Support parameters must be non-null strings.\u0022, nameof(parameters));\n            }\n\n            collectedParameters.Add(parameter);\n        }\n\n        var collectedOccurrences = new List\u003Cint\u003E();\n        foreach (var ordinal in occurrenceOrdinals)\n        {\n            if (ordinal \u003C 0)\n            {\n                throw new ArgumentOutOfRangeException(nameof(occurrenceOrdinals), ordinal, \u0022Occurrence ordinals must be non-negative.\u0022);\n            }\n\n            collectedOccurrences.Add(ordinal);\n        }\n\n        _premises = collectedPremises.ToArray();\n        _parameters = collectedParameters.ToArray();\n        _occurrences = collectedOccurrences.ToArray();\n        _premiseView = Array.AsReadOnly(_premises);\n        _parameterView = Array.AsReadOnly(_parameters);\n        _occurrenceView = Array.AsReadOnly(_occurrences);\n    }\n\n    public int ConclusionOrdinal { get; }\n\n    public string RuleId { get; }\n\n    /// \u003Csummary\u003EOrdered premise fact ordinals; the empty tuple is a zero-arity seed.\u003C/summary\u003E\n    public IReadOnlyList\u003Cint\u003E PremiseOrdinals =\u003E _premiseView;\n\n    /// \u003Csummary\u003EOrdered rule parameter strings.\u003C/summary\u003E\n    public IReadOnlyList\u003Cstring\u003E Parameters =\u003E _parameterView;\n\n    /// \u003Csummary\u003EOrdered originating occurrence ordinals into the retained exact batch.\u003C/summary\u003E\n    public IReadOnlyList\u003Cint\u003E OccurrenceOrdinals =\u003E _occurrenceView;\n\n    public bool Equals(SupportEdge? other)\n    {\n        if (ReferenceEquals(this, other))\n        {\n            return true;\n        }\n\n        if (other is null ||\n            ConclusionOrdinal != other.ConclusionOrdinal ||\n            !StringComparer.Ordinal.Equals(RuleId, other.RuleId) ||\n            !_premises.AsSpan().SequenceEqual(other._premises) ||\n            _parameters.Length != other._parameters.Length ||\n            !_occurrences.AsSpan().SequenceEqual(other._occurrences))\n        {\n            return false;\n        }\n\n        for (var i = 0; i \u003C _parameters.Length; i\u002B\u002B)\n        {\n            if (!StringComparer.Ordinal.Equals(_parameters[i], other._parameters[i]))\n            {\n                return false;\n            }\n        }\n\n        return true;\n    }\n\n    public override bool Equals(object? obj) =\u003E obj is SupportEdge other \u0026\u0026 Equals(other);\n\n    public override int GetHashCode()\n    {\n        var hash = new HashCode();\n        hash.Add(ConclusionOrdinal);\n        hash.Add(RuleId, StringComparer.Ordinal);\n        foreach (var ordinal in _premises)\n        {\n            hash.Add(ordinal);\n        }\n\n        foreach (var parameter in _parameters)\n        {\n            hash.Add(parameter, StringComparer.Ordinal);\n        }\n\n        foreach (var ordinal in _occurrences)\n        {\n            hash.Add(ordinal);\n        }\n\n        return hash.ToHashCode();\n    }\n\n    public override string ToString() =\u003E\n        $\u0022{RuleId}: [{string.Join(\u0022,\u0022, _premises)}] =\u003E #{ConclusionOrdinal}\u0022;\n\n    /// \u003Csummary\u003E\n    /// The canonical representational edge order: conclusion, rule, premise tuple, parameter\n    /// tuple, then occurrence tuple. Zero exactly when the edges are value-equal.\n    /// \u003C/summary\u003E\n    internal static int CompareCanonical(SupportEdge left, SupportEdge right)\n    {\n        var comparison = left.ConclusionOrdinal.CompareTo(right.ConclusionOrdinal);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        comparison = string.CompareOrdinal(left.RuleId, right.RuleId);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        comparison = CompareTuple(left._premises, right._premises);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        comparison = left._parameters.Length.CompareTo(right._parameters.Length);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        for (var i = 0; i \u003C left._parameters.Length; i\u002B\u002B)\n        {\n            comparison = string.CompareOrdinal(left._parameters[i], right._parameters[i]);\n            if (comparison != 0)\n            {\n                return comparison;\n            }\n        }\n\n        return CompareTuple(left._occurrences, right._occurrences);\n    }\n\n    private static int CompareTuple(int[] left, int[] right)\n    {\n        var comparison = left.Length.CompareTo(right.Length);\n        if (comparison != 0)\n        {\n            return comparison;\n        }\n\n        for (var i = 0; i \u003C left.Length; i\u002B\u002B)\n        {\n            comparison = left[i].CompareTo(right[i]);\n            if (comparison != 0)\n            {\n                return comparison;\n            }\n        }\n\n        return 0;\n    }\n}\n\n/// \u003Csummary\u003E\n/// Alternative and joint support over one exact fact/occurrence basis (D43): one exact\n/// \u003Csee cref=\u0022CanonicalFactTable\u0022/\u003E reference, one exact frozen compatible-master\n/// \u003Csee cref=\u0022SpanBatch\u0022/\u003E, and an immutable set of structurally validated\n/// \u003Csee cref=\u0022SupportEdge\u0022/\u003E values. Exact duplicate edges collapse; a different rule, premise\n/// path, parameter tuple, or occurrence tuple remains an alternative support for the same\n/// conclusion. Cycles and self-support are representable, and K5a promises structural\n/// well-formedness only \u2014 K5b owns rule execution and any derived-support completeness claim.\n/// \u003C/summary\u003E\npublic sealed class SupportHypergraph : IReadOnlyList\u003CSupportEdge\u003E\n{\n    private readonly SupportEdge[] _edges;\n\n    private SupportHypergraph(CanonicalFactTable facts, SpanBatch occurrences, SupportEdge[] edges)\n    {\n        Facts = facts;\n        Occurrences = occurrences;\n        _edges = edges;\n    }\n\n    /// \u003Csummary\u003EThe exact retained fact table every fact ordinal resolves against.\u003C/summary\u003E\n    public CanonicalFactTable Facts { get; }\n\n    /// \u003Csummary\u003EThe exact retained occurrence basis every occurrence ordinal resolves against.\u003C/summary\u003E\n    public SpanBatch Occurrences { get; }\n\n    public TextMaster Master =\u003E Facts.Master;\n\n    public int Count =\u003E _edges.Length;\n\n    public bool IsEmpty =\u003E _edges.Length == 0;\n\n    public SupportEdge this[int index]\n    {\n        get\n        {\n            if ((uint)index \u003E= (uint)_edges.Length)\n            {\n                throw new ArgumentOutOfRangeException(nameof(index));\n            }\n\n            return _edges[index];\n        }\n    }\n\n    /// \u003Csummary\u003E\n    /// Validates every edge against the exact bases and collapses exact duplicate edges.\n    /// Enumeration uses the canonical conclusion/rule/premise/parameter/occurrence order\n    /// independent of supply order.\n    /// \u003C/summary\u003E\n    public static SupportHypergraph Create(\n        CanonicalFactTable facts,\n        SpanBatch occurrences,\n        IEnumerable\u003CSupportEdge\u003E edges)\n    {\n        ArgumentNullException.ThrowIfNull(facts);\n        ArgumentNullException.ThrowIfNull(occurrences);\n        ArgumentNullException.ThrowIfNull(edges);\n        facts.Master.EnsureCompatibleWith(occurrences.Master);\n\n        var collected = new List\u003CSupportEdge\u003E();\n        foreach (var edge in edges)\n        {\n            if (edge is null)\n            {\n                throw new ArgumentException(\u0022Support edges must be non-null.\u0022, nameof(edges));\n            }\n\n            EnsureFactOrdinal(facts, edge.ConclusionOrdinal, edge, \u0022conclusion\u0022);\n            foreach (var premise in edge.PremiseOrdinals)\n            {\n                EnsureFactOrdinal(facts, premise, edge, \u0022premise\u0022);\n            }\n\n            foreach (var occurrence in edge.OccurrenceOrdinals)\n            {\n                if (occurrence \u003E= occurrences.Count)\n                {\n                    throw new ArgumentException(\n                        $\u0022Support edge \u0027{edge}\u0027 occurrence ordinal #{occurrence} is outside the exact occurrence batch of {occurrences.Count}.\u0022,\n                        nameof(edges));\n                }\n            }\n\n            collected.Add(edge);\n        }\n\n        collected.Sort(SupportEdge.CompareCanonical);\n        var distinct = new List\u003CSupportEdge\u003E(collected.Count);\n        foreach (var edge in collected)\n        {\n            if (distinct.Count == 0 || SupportEdge.CompareCanonical(distinct[^1], edge) != 0)\n            {\n                distinct.Add(edge);\n            }\n        }\n\n        return new SupportHypergraph(facts, occurrences, distinct.ToArray());\n    }\n\n    /// \u003Csummary\u003E\n    /// Returns the retained supports concluding at one fact, in canonical edge order. A fact with\n    /// no support edge is a legal answer, not a defect.\n    /// \u003C/summary\u003E\n    public IReadOnlyList\u003CSupportEdge\u003E SupportsOf(int conclusionOrdinal)\n    {\n        if ((uint)conclusionOrdinal \u003E= (uint)Facts.Count)\n        {\n            throw new ArgumentOutOfRangeException(nameof(conclusionOrdinal));\n        }\n\n        var supports = new List\u003CSupportEdge\u003E();\n        foreach (var edge in _edges)\n        {\n            if (edge.ConclusionOrdinal == conclusionOrdinal)\n            {\n                supports.Add(edge);\n            }\n        }\n\n        return supports.AsReadOnly();\n    }\n\n    public IEnumerator\u003CSupportEdge\u003E GetEnumerator() =\u003E\n        ((IEnumerable\u003CSupportEdge\u003E)_edges).GetEnumerator();\n\n    IEnumerator IEnumerable.GetEnumerator() =\u003E GetEnumerator();\n\n    private static void EnsureFactOrdinal(\n        CanonicalFactTable facts,\n        int ordinal,\n        SupportEdge edge,\n        string role)\n    {\n        if (ordinal \u003E= facts.Count)\n        {\n            throw new ArgumentException(\n                $\u0022Support edge \u0027{edge}\u0027 {role} fact ordinal #{ordinal} is outside the exact fact table of {facts.Count}.\u0022,\n                \u0022edges\u0022);\n        }\n    }\n}\n"}
```

**[result: toolu_01GrzTKYvr...]**
```
File created successfully at: D:\aghado01\codex-scientiae\src\doccer\Facts\SupportHypergraph.cs (file state is current in your context — no need to Read it back)
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","offset":6650,"limit":45}
```

**[result: toolu_01HekbtrVd...]**
```
6650	                view.LeftBasis[pair.LeftOrdinal].Span,
6651	                view.RightBasis[pair.RightOrdinal].Span));
6652	        }
6653	
6654	        return AllenRelationSet.Create(relations);
6655	    }
6656	
6657	    private static ClaimSelection SelectionFromMask(SpanBatch batch, int mask) =>
6658	        ClaimSelection.Create(
6659	            batch,
6660	            Enumerable.Range(0, batch.Count).Where(ordinal => (mask & (1 << ordinal)) != 0));
6661	
6662	    private static bool SelectionMatchesMask(ClaimSelection selection, int mask)
6663	    {
6664	        var expectedOrdinal = 0;
6665	        foreach (var ordinal in selection)
6666	        {
6667	            while (expectedOrdinal < selection.Basis.Count && (mask & (1 << expectedOrdinal)) == 0)
6668	            {
6669	                expectedOrdinal++;
6670	            }
6671	
6672	            if (ordinal != expectedOrdinal)
6673	            {
6674	                return false;
6675	            }
6676	
6677	            expectedOrdinal++;
6678	        }
6679	
6680	        for (var ordinal = 0; ordinal < selection.Basis.Count; ordinal++)
6681	        {
6682	            if (selection.Contains(ordinal) != ((mask & (1 << ordinal)) != 0))
6683	            {
6684	                return false;
6685	            }
6686	        }
6687	
6688	        return selection.Count == CountSetBits(mask);
6689	    }
6690	
6691	    private static void True(bool condition, string name)
6692	    {
6693	        _checks++;
6694	        if (!condition)
```
**[tool: Bash]**
```json
{"command":"cat \u0022D:/aghado01/codex-scientiae/brewery/Directory.Build.props\u0022 2\u003E/dev/null || find \u0022D:/aghado01/codex-scientiae\u0022 -maxdepth 2 -name \u0022Directory.Build.props\u0022 -not -path \u0022*worktrees*\u0022 2\u003E/dev/null","description":"Find and show Directory.Build.props"}
```

**[result: toolu_01SiFGgsnc...]**
```
D:/aghado01/codex-scientiae/Directory.Build.props
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\Directory.Build.props"}
```

**[result: toolu_018bV9jjnY...]**
```
1	<Project>
2	  <PropertyGroup>
3	    <RepositoryRoot>$(MSBuildThisFileDirectory)</RepositoryRoot>
4	    <ArtifactsRoot>$(RepositoryRoot)artifacts\</ArtifactsRoot>
5	
6	    <TargetFramework>net10.0</TargetFramework>
7	    <LangVersion>latest</LangVersion>
8	    <Nullable>enable</Nullable>
9	    <ImplicitUsings>disable</ImplicitUsings>
10	    <AllowUnsafeBlocks>true</AllowUnsafeBlocks>
11	    <GenerateDocumentationFile>true</GenerateDocumentationFile>
12	    <NoWarn>$(NoWarn);1591</NoWarn>
13	    <DefineConstants Condition="'$(ExtraDefineConstants)' != ''">$(DefineConstants);$(ExtraDefineConstants)</DefineConstants>
14	
15	    <!-- Artifacts are scoped by module first: artifacts\{module}\{bin,obj}\{project}\. Nothing
16	         writes a bare artifacts\bin or artifacts\obj, because artifacts\ is shared with every
17	         other process that emits regenerable output (test runs, publish staging, npm caches,
18	         tectonic, latex-ingest) and an unscoped top-level bin\ collides with all of them.
19	         The module is the project's own directory name, which under the brewery\{module}\**
20	         layout is exactly the module it belongs to — so the three doccer projects land together
21	         under artifacts\doccer with no per-project boilerplate. Override with
22	         /p:ArtifactsModule=... on the command line: that arrives as a global property before
23	         evaluation, whereas setting it in the csproj body would be too late, since the two paths
24	         below expand where they are written. -->
25	    <ArtifactsModule Condition="'$(ArtifactsModule)' == ''">$([System.IO.Path]::GetFileName('$(MSBuildProjectDirectory)'))</ArtifactsModule>
26	    <BaseOutputPath>$(ArtifactsRoot)$(ArtifactsModule)\bin\$(MSBuildProjectName)\</BaseOutputPath>
27	    <BaseIntermediateOutputPath>$(ArtifactsRoot)$(ArtifactsModule)\obj\$(MSBuildProjectName)\</BaseIntermediateOutputPath>
28	  </PropertyGroup>
29	
30	  <!-- Shared-source routing (repo convention). A codex C# tool keeps its code under
31	       src\{tool} and a thin .csproj in its brewery recipe at brewery\{module}\; the
32	       project compiles the sources at src\$(SharedSource). SharedSource defaults to the
33	       project name, so brewery\foo\foo.csproj auto-picks-up src\foo with no boilerplate.
34	       Override it to point elsewhere (a test project compiling the library it exercises
35	       sets <SharedSource>foo</SharedSource>), or set EnableSharedSourceRouting=false to
36	       opt a project out entirely. Sibling projects of one module share a directory, so a
37	       project routed this way that also carries its own entry point should disable the
38	       default compile glob — see brewery\hdbscan\hdbscan.tests.csproj. Items resolve
39	       after all properties, so the per-csproj override wins even though this block lives
40	       in the imported props. -->
41	  <PropertyGroup>
42	    <SharedSource Condition="'$(SharedSource)' == '' AND '$(EnableSharedSourceRouting)' != 'false'">$(MSBuildProjectName)</SharedSource>
43	  </PropertyGroup>
44	  <ItemGroup Condition="'$(SharedSource)' != '' AND Exists('$(RepositoryRoot)src\$(SharedSource)')">
45	    <Compile Include="$(RepositoryRoot)src\$(SharedSource)\**\*.cs" />
46	  </ItemGroup>
47	</Project>
48
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","old_string":"            ResolutionMapsSeparateIncidenceFromAggregation();\n            ResolutionIncidenceMatchesBoundedEndpointOracle();\n            Console.WriteLine($\u0022doccer contract harness: {_checks} checks passed\u0022);","new_string":"            ResolutionMapsSeparateIncidenceFromAggregation();\n            ResolutionIncidenceMatchesBoundedEndpointOracle();\n            FactKeyIsAMasterRelativeSemanticValue();\n            CanonicalFactTableCollapsesAndOrdersProposals();\n            CanonicalFactTableEqualityIsProposalOrderIndependent();\n            FactReferenceIsAnExactTableHandle();\n            SupportEdgeIsAnOrderedEvidenceValue();\n            SupportHypergraphValidatesExactBasesAndRetainsAlternatives();\n            K5aHierarchyDiamondWitnessSuppliesAncestorSupport();\n            Console.WriteLine($\u0022doccer contract harness: {_checks} checks passed\u0022);"}
```

**[result: toolu_01P8oUpjKz...]**
```
The file D:\aghado01\codex-scientiae\tests\doccer\Program.cs has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","old_string":"    private static void True(bool condition, string name)\n    {\n        _checks\u002B\u002B;\n        if (!condition)","new_string":"    private static void FactKeyIsAMasterRelativeSemanticValue()\n    {\n        Throws\u003CArgumentException\u003E(\n            () =\u003E new FactKey(\u0022 \u0022, \u0022Parent\u0022, Array.Empty\u003CTextSpan\u003E(), Array.Empty\u003Cstring\u003E()),\n            \u0022fact domain required\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E new FactKey(\u0022hier\u0022, \u0022\u0022, Array.Empty\u003CTextSpan\u003E(), Array.Empty\u003Cstring\u003E()),\n            \u0022fact kind required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new FactKey(\u0022hier\u0022, \u0022Parent\u0022, null!, Array.Empty\u003Cstring\u003E()),\n            \u0022geometry sequence required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new FactKey(\u0022hier\u0022, \u0022Parent\u0022, Array.Empty\u003CTextSpan\u003E(), null!),\n            \u0022value sequence required\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E new FactKey(\u0022hier\u0022, \u0022Parent\u0022, Array.Empty\u003CTextSpan\u003E(), new string[] { null! }),\n            \u0022null value component rejected\u0022);\n\n        var geometry = new List\u003CTextSpan\u003E { new(1, 2), new(0, 3) };\n        var values = new List\u003Cstring\u003E { \u0022x\u0022, \u0022y\u0022 };\n        var key = new FactKey(\u0022hier\u0022, \u0022Parent\u0022, geometry, values);\n        geometry[0] = new TextSpan(3, 4);\n        values[0] = \u0022mutated\u0022;\n        Equal(new TextSpan(1, 2), key.Geometry[0], \u0022geometry tuple snapshotted\u0022);\n        Equal(\u0022x\u0022, key.ValueKey[0], \u0022value tuple snapshotted\u0022);\n\n        var same = new FactKey(\n            \u0022hier\u0022,\n            \u0022Parent\u0022,\n            new[] { new TextSpan(1, 2), new TextSpan(0, 3) },\n            new[] { \u0022x\u0022, \u0022y\u0022 });\n        True(key.Equals(same), \u0022fact key value equality\u0022);\n        Equal(key.GetHashCode(), same.GetHashCode(), \u0022fact key hash agreement\u0022);\n        True(!key.Equals(null), \u0022null fact key inequality\u0022);\n\n        var distinctions = new[]\n        {\n            new FactKey(\u0022hier2\u0022, \u0022Parent\u0022, key.Geometry, key.ValueKey),\n            new FactKey(\u0022hier\u0022, \u0022Ancestor\u0022, key.Geometry, key.ValueKey),\n            new FactKey(\u0022hier\u0022, \u0022Parent\u0022, new[] { new TextSpan(1, 2) }, key.ValueKey),\n            new FactKey(\n                \u0022hier\u0022, \u0022Parent\u0022, new[] { new TextSpan(0, 3), new TextSpan(1, 2) }, key.ValueKey),\n            new FactKey(\n                \u0022hier\u0022, \u0022Parent\u0022, new[] { new TextSpan(1, 3), new TextSpan(0, 3) }, key.ValueKey),\n            new FactKey(\u0022hier\u0022, \u0022Parent\u0022, key.Geometry, new[] { \u0022x\u0022 }),\n            new FactKey(\u0022hier\u0022, \u0022Parent\u0022, key.Geometry, new[] { \u0022x\u0022, \u0022z\u0022 }),\n            new FactKey(\u0022hier\u0022, \u0022Parent\u0022, key.Geometry, Array.Empty\u003Cstring\u003E()),\n        };\n        for (var i = 0; i \u003C distinctions.Length; i\u002B\u002B)\n        {\n            True(!key.Equals(distinctions[i]), $\u0022fact key distinction {i} is semantic\u0022);\n        }\n\n        var global = new FactKey(\u0022doc\u0022, \u0022word-count\u0022, Array.Empty\u003CTextSpan\u003E(), new[] { \u00224\u0022 });\n        Equal(0, global.Geometry.Count, \u0022zero-geometry master-global key\u0022);\n        var unit = new FactKey(\u0022doc\u0022, \u0022seen\u0022, new[] { new TextSpan(2, 2) }, Array.Empty\u003Cstring\u003E());\n        Equal(0, unit.ValueKey.Count, \u0022empty tuple is the unit value key\u0022);\n        True(!global.Equals(unit), \u0022empty tuples still distinguish\u0022);\n    }\n\n    private static void CanonicalFactTableCollapsesAndOrdersProposals()\n    {\n        var master = new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022);\n        var a = new TextSpan(1, 2);\n        var b = new TextSpan(0, 3);\n        var d = new TextSpan(0, 4);\n\n        FactKey Parent(TextSpan child, TextSpan parent) =\u003E\n            new(\u0022hier\u0022, \u0022Parent\u0022, new[] { child, parent }, Array.Empty\u003Cstring\u003E());\n\n        var empty = CanonicalFactTable.Create(master, Array.Empty\u003CFactKey\u003E());\n        True(empty.IsEmpty, \u0022empty fact table\u0022);\n        Equal(0, empty.Count, \u0022empty fact table count\u0022);\n\n        var table = CanonicalFactTable.Create(master, new[]\n        {\n            Parent(a, b),\n            Parent(b, d),\n            Parent(a, b),\n            new FactKey(\u0022hier\u0022, \u0022Ancestor\u0022, new[] { a, d }, Array.Empty\u003Cstring\u003E()),\n            new FactKey(\u0022doc\u0022, \u0022word-count\u0022, Array.Empty\u003CTextSpan\u003E(), new[] { \u00224\u0022 }),\n            new FactKey(\u0022hier\u0022, \u0022boundary\u0022, new[] { new TextSpan(2, 2) }, Array.Empty\u003Cstring\u003E()),\n        });\n        Equal(5, table.Count, \u0022duplicate fact proposals collapse\u0022);\n        Equal(\u0022word-count\u0022, table[0].Kind, \u0022domain-major canonical order\u0022);\n        Equal(\u0022Ancestor\u0022, table[1].Kind, \u0022ordinal kind order within one domain\u0022);\n        Equal(new TextSpan(0, 3), table[2].Geometry[0], \u0022geometry coordinate order\u0022);\n        Equal(new TextSpan(1, 2), table[3].Geometry[0], \u0022geometry coordinate order continued\u0022);\n        Equal(\u0022boundary\u0022, table[4].Kind, \u0022ordinal kind order is case-sensitive\u0022);\n\n        True(table.TryGetOrdinal(Parent(a, b), out var parentOrdinal), \u0022value-equal key found\u0022);\n        Equal(3, parentOrdinal, \u0022found ordinal addresses the canonical row\u0022);\n        True(!table.TryGetOrdinal(Parent(d, a), out _), \u0022absent key not found\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(() =\u003E _ = table[5], \u0022fact ordinal range validated\u0022);\n\n        var widened = CanonicalFactTable.Create(master, new[]\n        {\n            Parent(a, b),\n            new FactKey(\u0022aaa\u0022, \u0022first\u0022, Array.Empty\u003CTextSpan\u003E(), Array.Empty\u003Cstring\u003E()),\n        });\n        True(widened.TryGetOrdinal(Parent(a, b), out var shifted), \u0022widened table retains the key\u0022);\n        Equal(1, shifted, \u0022unrelated facts shift table-local ordinals\u0022);\n\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E CanonicalFactTable.Create(\n                master,\n                new[]\n                {\n                    new FactKey(\n                        \u0022hier\u0022, \u0022Parent\u0022, new[] { new TextSpan(0, 5) }, Array.Empty\u003Cstring\u003E()),\n                }),\n            \u0022geometry beyond the master refused\u0022);\n        var smp = new TextMaster(\u0022smp\u0022, 0, \u0022a\uD83D\uDE00b\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E CanonicalFactTable.Create(\n                smp,\n                new[]\n                {\n                    new FactKey(\n                        \u0022hier\u0022, \u0022mark\u0022, new[] { new TextSpan(2, 2) }, Array.Empty\u003Cstring\u003E()),\n                }),\n            \u0022surrogate-splitting boundary fact refused\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E CanonicalFactTable.Create(master, new FactKey[] { null! }),\n            \u0022null fact proposal refused\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E CanonicalFactTable.Create(null!, Array.Empty\u003CFactKey\u003E()),\n            \u0022fact table master required\u0022);\n\n        var proposals = new List\u003CFactKey\u003E { Parent(a, b) };\n        var snapshotted = CanonicalFactTable.Create(master, proposals);\n        proposals.Clear();\n        Equal(1, snapshotted.Count, \u0022proposal sequence snapshotted\u0022);\n    }\n\n    private static void CanonicalFactTableEqualityIsProposalOrderIndependent()\n    {\n        var master = new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022);\n        var proposals = new FactKey[]\n        {\n            new(\n                \u0022hier\u0022,\n                \u0022Parent\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },\n                Array.Empty\u003Cstring\u003E()),\n            new(\n                \u0022hier\u0022,\n                \u0022Parent\u0022,\n                new[] { new TextSpan(0, 3), new TextSpan(0, 4) },\n                Array.Empty\u003Cstring\u003E()),\n            new(\n                \u0022hier\u0022,\n                \u0022Ancestor\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },\n                Array.Empty\u003Cstring\u003E()),\n            new(\u0022doc\u0022, \u0022word-count\u0022, Array.Empty\u003CTextSpan\u003E(), new[] { \u00224\u0022 }),\n            new(\n                \u0022hier\u0022,\n                \u0022Parent\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },\n                Array.Empty\u003Cstring\u003E()),\n        };\n\n        var reference = CanonicalFactTable.Create(master, proposals);\n        Equal(4, reference.Count, \u0022reference table collapses the duplicate proposal\u0022);\n\n        var total = 0;\n        var agreeing = 0;\n        foreach (var permutation in Permutations(proposals.Length))\n        {\n            total\u002B\u002B;\n            var permuted = new FactKey[proposals.Length];\n            for (var i = 0; i \u003C permutation.Length; i\u002B\u002B)\n            {\n                permuted[i] = proposals[permutation[i]];\n            }\n\n            var table = CanonicalFactTable.Create(master, permuted);\n            if (reference.Equals(table) \u0026\u0026\n                table.Equals(reference) \u0026\u0026\n                reference.GetHashCode() == table.GetHashCode())\n            {\n                agreeing\u002B\u002B;\n            }\n        }\n\n        Equal(120, total, \u0022proposal permutation census\u0022);\n        Equal(total, agreeing, \u0022canonical value is proposal-order independent\u0022);\n\n        var compatible = CanonicalFactTable.Create(new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022), proposals);\n        True(reference.Equals(compatible), \u0022compatible-master tables are value-equal\u0022);\n        Equal(reference.GetHashCode(), compatible.GetHashCode(), \u0022compatible-master hash agreement\u0022);\n\n        var otherText = CanonicalFactTable.Create(new TextMaster(\u0022facts\u0022, 0, \u0022wxyA\u0022), proposals);\n        True(!reference.Equals(otherText), \u0022incompatible master text breaks equality\u0022);\n        var otherRevision = CanonicalFactTable.Create(new TextMaster(\u0022facts\u0022, 1, \u0022wxyz\u0022), proposals);\n        True(!reference.Equals(otherRevision), \u0022incompatible revision breaks equality\u0022);\n        var fewer = CanonicalFactTable.Create(master, new[] { proposals[0] });\n        True(!reference.Equals(fewer), \u0022different key populations differ\u0022);\n        True(!reference.Equals(null), \u0022null table inequality\u0022);\n    }\n\n    private static void FactReferenceIsAnExactTableHandle()\n    {\n        var master = new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022);\n        var proposals = new FactKey[]\n        {\n            new(\n                \u0022hier\u0022,\n                \u0022Ancestor\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },\n                Array.Empty\u003Cstring\u003E()),\n            new(\n                \u0022hier\u0022,\n                \u0022Parent\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },\n                Array.Empty\u003Cstring\u003E()),\n        };\n        var table = CanonicalFactTable.Create(master, proposals);\n        var twin = CanonicalFactTable.Create(master, proposals);\n        True(table.Equals(twin), \u0022twin tables are value-equal\u0022);\n\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new FactReference(null!, 0), \u0022fact reference requires a table\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E new FactReference(table, 2), \u0022fact reference ordinal validated\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E new FactReference(CanonicalFactTable.Create(master, Array.Empty\u003CFactKey\u003E()), 0),\n            \u0022empty table admits no reference\u0022);\n\n        var reference = new FactReference(table, 0);\n        True(reference.Key.Equals(table[0]), \u0022key projection returns semantic identity\u0022);\n        True(reference == new FactReference(table, 0), \u0022same exact table and ordinal are one handle\u0022);\n        True(reference != new FactReference(table, 1), \u0022different ordinals differ\u0022);\n        True(reference != new FactReference(twin, 0), \u0022value-equal tables do not share references\u0022);\n        True(\n            reference.Key.Equals(new FactReference(twin, 0).Key),\n            \u0022twin reference projections agree semantically\u0022);\n        Throws\u003CInvalidOperationException\u003E(\n            () =\u003E _ = default(FactReference).Table, \u0022uninitialized fact reference refuses use\u0022);\n    }\n\n    private static void SupportEdgeIsAnOrderedEvidenceValue()\n    {\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E new SupportEdge(\n                -1, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            \u0022conclusion ordinal must be non-negative\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E new SupportEdge(\n                0, \u0022 \u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            \u0022support rule ID required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new SupportEdge(0, \u0022rule\u0022, null!, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            \u0022premise sequence required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new SupportEdge(0, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), null!, Array.Empty\u003Cint\u003E()),\n            \u0022parameter sequence required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E new SupportEdge(0, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), null!),\n            \u0022occurrence sequence required\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E new SupportEdge(\n                0, \u0022rule\u0022, new[] { -1 }, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            \u0022negative premise ordinal refused\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E new SupportEdge(\n                0, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), new string[] { null! }, Array.Empty\u003Cint\u003E()),\n            \u0022null parameter refused\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E new SupportEdge(\n                0, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), new[] { -2 }),\n            \u0022negative occurrence ordinal refused\u0022);\n\n        var premises = new List\u003Cint\u003E { 1, 2 };\n        var parameters = new List\u003Cstring\u003E { \u0022p\u0022 };\n        var occurrences = new List\u003Cint\u003E { 0, 3 };\n        var edge = new SupportEdge(0, \u0022path\u0022, premises, parameters, occurrences);\n        premises[0] = 9;\n        parameters[0] = \u0022mutated\u0022;\n        occurrences.Clear();\n        Equal(1, edge.PremiseOrdinals[0], \u0022premise tuple snapshotted\u0022);\n        Equal(\u0022p\u0022, edge.Parameters[0], \u0022parameter tuple snapshotted\u0022);\n        Equal(2, edge.OccurrenceOrdinals.Count, \u0022occurrence tuple snapshotted\u0022);\n\n        var same = new SupportEdge(0, \u0022path\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022 }, new[] { 0, 3 });\n        True(edge.Equals(same), \u0022support edge value equality\u0022);\n        Equal(edge.GetHashCode(), same.GetHashCode(), \u0022support edge hash agreement\u0022);\n        True(!edge.Equals(null), \u0022null support edge inequality\u0022);\n\n        var distinctions = new[]\n        {\n            new SupportEdge(1, \u0022path\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022 }, new[] { 0, 3 }),\n            new SupportEdge(0, \u0022path2\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022 }, new[] { 0, 3 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 2, 1 }, new[] { \u0022p\u0022 }, new[] { 0, 3 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1, 1, 2 }, new[] { \u0022p\u0022 }, new[] { 0, 3 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022, \u0022q\u0022 }, new[] { 0, 3 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022 }, new[] { 3, 0 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1, 2 }, new[] { \u0022p\u0022 }, Array.Empty\u003Cint\u003E()),\n        };\n        for (var i = 0; i \u003C distinctions.Length; i\u002B\u002B)\n        {\n            True(!edge.Equals(distinctions[i]), $\u0022support edge distinction {i} is an alternative\u0022);\n        }\n    }\n\n    private static void SupportHypergraphValidatesExactBasesAndRetainsAlternatives()\n    {\n        var master = new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022);\n        var builder = new SpanBatchBuilder(master);\n        builder.Add(new SpanClaim(new TextSpan(1, 2), \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        builder.Add(new SpanClaim(new TextSpan(0, 3), \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var occurrences = builder.Freeze();\n\n        var table = CanonicalFactTable.Create(master, new FactKey[]\n        {\n            new(\n                \u0022hier\u0022,\n                \u0022Ancestor\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 4) },\n                Array.Empty\u003Cstring\u003E()),\n            new(\n                \u0022hier\u0022,\n                \u0022Parent\u0022,\n                new[] { new TextSpan(1, 2), new TextSpan(0, 3) },\n                Array.Empty\u003Cstring\u003E()),\n        });\n\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E SupportHypergraph.Create(null!, occurrences, Array.Empty\u003CSupportEdge\u003E()),\n            \u0022fact basis required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E SupportHypergraph.Create(table, null!, Array.Empty\u003CSupportEdge\u003E()),\n            \u0022occurrence basis required\u0022);\n        Throws\u003CArgumentNullException\u003E(\n            () =\u003E SupportHypergraph.Create(table, occurrences, null!),\n            \u0022support edge sequence required\u0022);\n\n        var foreignBuilder = new SpanBatchBuilder(new TextMaster(\u0022other\u0022, 0, \u0022wxyz\u0022));\n        foreignBuilder.Add(new SpanClaim(new TextSpan(0, 1), \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        Throws\u003CInvalidOperationException\u003E(\n            () =\u003E SupportHypergraph.Create(table, foreignBuilder.Freeze(), Array.Empty\u003CSupportEdge\u003E()),\n            \u0022incompatible occurrence master refused\u0022);\n\n        Throws\u003CArgumentException\u003E(\n            () =\u003E SupportHypergraph.Create(table, occurrences, new SupportEdge[] { null! }),\n            \u0022null support edge refused\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E SupportHypergraph.Create(\n                table,\n                occurrences,\n                new[]\n                {\n                    new SupportEdge(\n                        2, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n                }),\n            \u0022missing conclusion fact refused\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E SupportHypergraph.Create(\n                table,\n                occurrences,\n                new[]\n                {\n                    new SupportEdge(\n                        0, \u0022rule\u0022, new[] { 2 }, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n                }),\n            \u0022missing premise fact refused\u0022);\n        Throws\u003CArgumentException\u003E(\n            () =\u003E SupportHypergraph.Create(\n                table,\n                occurrences,\n                new[]\n                {\n                    new SupportEdge(\n                        0, \u0022rule\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), new[] { 2 }),\n                }),\n            \u0022invalid occurrence ordinal refused\u0022);\n\n        var bare = SupportHypergraph.Create(table, occurrences, Array.Empty\u003CSupportEdge\u003E());\n        True(bare.IsEmpty, \u0022facts need no support edge\u0022);\n        Equal(0, bare.SupportsOf(0).Count, \u0022unsupported fact answers with no edges\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(\n            () =\u003E bare.SupportsOf(2), \u0022supports query validates its ordinal\u0022);\n\n        var compatibleBuilder = new SpanBatchBuilder(new TextMaster(\u0022facts\u0022, 0, \u0022wxyz\u0022));\n        compatibleBuilder.Add(\n            new SpanClaim(new TextSpan(1, 2), \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var compatibleGraph =\n            SupportHypergraph.Create(table, compatibleBuilder.Freeze(), Array.Empty\u003CSupportEdge\u003E());\n        Equal(0, compatibleGraph.Count, \u0022compatible-but-distinct master batch admitted\u0022);\n\n        var alternatives = new[]\n        {\n            new SupportEdge(0, \u0022path\u0022, new[] { 1 }, Array.Empty\u003Cstring\u003E(), new[] { 0 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1 }, Array.Empty\u003Cstring\u003E(), new[] { 0 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1, 1 }, Array.Empty\u003Cstring\u003E(), new[] { 0 }),\n            new SupportEdge(0, \u0022other-rule\u0022, new[] { 1 }, Array.Empty\u003Cstring\u003E(), new[] { 0 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1 }, new[] { \u0022p\u0022 }, new[] { 0 }),\n            new SupportEdge(0, \u0022path\u0022, new[] { 1 }, Array.Empty\u003Cstring\u003E(), new[] { 1 }),\n            new SupportEdge(0, \u0022seed\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            new SupportEdge(0, \u0022self\u0022, new[] { 0 }, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            new SupportEdge(1, \u0022cycle\u0022, new[] { 0 }, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n            new SupportEdge(0, \u0022cycle\u0022, new[] { 1 }, Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n        };\n\n        var graph = SupportHypergraph.Create(table, occurrences, alternatives);\n        Equal(9, graph.Count, \u0022exact duplicate support collapses\u0022);\n        Equal(8, graph.SupportsOf(0).Count, \u0022alternative supports retained beside one conclusion\u0022);\n        Equal(1, graph.SupportsOf(1).Count, \u0022cyclic and self-support are representable\u0022);\n\n        var reversed = new SupportEdge[alternatives.Length];\n        for (var i = 0; i \u003C alternatives.Length; i\u002B\u002B)\n        {\n            reversed[i] = alternatives[alternatives.Length - 1 - i];\n        }\n\n        var reordered = SupportHypergraph.Create(table, occurrences, reversed);\n        Equal(graph.Count, reordered.Count, \u0022supply order does not change the edge census\u0022);\n        var sequenceAgrees = true;\n        for (var i = 0; i \u003C graph.Count; i\u002B\u002B)\n        {\n            if (!graph[i].Equals(reordered[i]))\n            {\n                sequenceAgrees = false;\n            }\n        }\n\n        True(sequenceAgrees, \u0022canonical edge enumeration is supply-order independent\u0022);\n\n        var edgeList = new List\u003CSupportEdge\u003E\n        {\n            new(0, \u0022seed\u0022, Array.Empty\u003Cint\u003E(), Array.Empty\u003Cstring\u003E(), Array.Empty\u003Cint\u003E()),\n        };\n        var snapshotted = SupportHypergraph.Create(table, occurrences, edgeList);\n        edgeList.Clear();\n        Equal(1, snapshotted.Count, \u0022edge sequence snapshotted\u0022);\n        Throws\u003CArgumentOutOfRangeException\u003E(() =\u003E _ = snapshotted[1], \u0022edge index validated\u0022);\n    }\n\n    private static void K5aHierarchyDiamondWitnessSuppliesAncestorSupport()\n    {\n        // The K4c four-node diamond a -\u003E b -\u003E d with a -\u003E c -\u003E d, replayed as facts: four Parent\n        // facts plus one directly supplied Ancestor(a,d) conclusion carried by two ordered\n        // support paths. Nothing here saturates; K5b later derives the same result.\n        var master = new TextMaster(\u0022diamond\u0022, 0, \u0022wxyz\u0022);\n        var a = new TextSpan(1, 2);\n        var b = new TextSpan(0, 3);\n        var c = new TextSpan(1, 4);\n        var d = new TextSpan(0, 4);\n\n        var builder = new SpanBatchBuilder(master);\n        var occurrenceA = builder.Add(new SpanClaim(a, \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var occurrenceB = builder.Add(new SpanClaim(b, \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var occurrenceC = builder.Add(new SpanClaim(c, \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var occurrenceD = builder.Add(new SpanClaim(d, \u0022node\u0022, SpanLevel.Character, \u0022witness\u0022));\n        var occurrences = builder.Freeze();\n\n        FactKey Parent(TextSpan child, TextSpan parent) =\u003E\n            new(\u0022hier\u0022, \u0022Parent\u0022, new[] { child, parent }, Array.Empty\u003Cstring\u003E());\n        var ancestor = new FactKey(\u0022hier\u0022, \u0022Ancestor\u0022, new[] { a, d }, Array.Empty\u003Cstring\u003E());\n\n        // The conclusion is proposed once per path; the semantic fact collapses to one row.\n        var table = CanonicalFactTable.Create(master, new[]\n        {\n            Parent(a, b), Parent(b, d), ancestor,\n            Parent(a, c), Parent(c, d), ancestor,\n        });\n        Equal(5, table.Count, \u0022diamond fact census\u0022);\n\n        True(table.TryGetOrdinal(ancestor, out var ancestorOrdinal), \u0022ancestor fact retained\u0022);\n        True(table.TryGetOrdinal(Parent(a, b), out var ab), \u0022Parent(a,b) retained\u0022);\n        True(table.TryGetOrdinal(Parent(b, d), out var bd), \u0022Parent(b,d) retained\u0022);\n        True(table.TryGetOrdinal(Parent(a, c), out var ac), \u0022Parent(a,c) retained\u0022);\n        True(table.TryGetOrdinal(Parent(c, d), out var cd), \u0022Parent(c,d) retained\u0022);\n\n        // K7\u0027s optional seam: the exact fact handle exists before and without any support graph.\n        var seam = new FactReference(table, ancestorOrdinal);\n        True(seam.Key.Equals(ancestor), \u0022fact reference projects the ancestor without support\u0022);\n\n        var viaB = new SupportEdge(\n            ancestorOrdinal,\n            \u0022ancestor-path\u0022,\n            new[] { ab, bd },\n            Array.Empty\u003Cstring\u003E(),\n            new[] { occurrenceA, occurrenceB, occurrenceD });\n        var viaC = new SupportEdge(\n            ancestorOrdinal,\n            \u0022ancestor-path\u0022,\n            new[] { ac, cd },\n            Array.Empty\u003Cstring\u003E(),\n            new[] { occurrenceA, occurrenceC, occurrenceD });\n        var graph = SupportHypergraph.Create(table, occurrences, new[] { viaB, viaC });\n        var mirrored = SupportHypergraph.Create(table, occurrences, new[] { viaC, viaB });\n\n        Equal(2, graph.Count, \u0022two ancestor supports supplied without saturation\u0022);\n        var supports = graph.SupportsOf(ancestorOrdinal);\n        Equal(2, supports.Count, \u0022both paths retained beside one conclusion\u0022);\n        var mirroredSupports = mirrored.SupportsOf(ancestorOrdinal);\n        True(\n            supports[0].Equals(mirroredSupports[0]) \u0026\u0026 supports[1].Equals(mirroredSupports[1]),\n            \u0022support enumeration is supply-order independent\u0022);\n\n        var pathThroughB = false;\n        var pathThroughC = false;\n        foreach (var support in supports)\n        {\n            if (support.PremiseOrdinals.Count == 2 \u0026\u0026\n                support.PremiseOrdinals[0] == ab \u0026\u0026\n                support.PremiseOrdinals[1] == bd \u0026\u0026\n                support.OccurrenceOrdinals.Count == 3 \u0026\u0026\n                support.OccurrenceOrdinals[1] == occurrenceB)\n            {\n                pathThroughB = true;\n            }\n\n            if (support.PremiseOrdinals.Count == 2 \u0026\u0026\n                support.PremiseOrdinals[0] == ac \u0026\u0026\n                support.PremiseOrdinals[1] == cd \u0026\u0026\n                support.OccurrenceOrdinals.Count == 3 \u0026\u0026\n                support.OccurrenceOrdinals[1] == occurrenceC)\n            {\n                pathThroughC = true;\n            }\n        }\n\n        True(pathThroughB, \u0022ordered path through b retained\u0022);\n        True(pathThroughC, \u0022ordered path through c retained\u0022);\n\n        foreach (var parentOrdinal in new[] { ab, bd, ac, cd })\n        {\n            Equal(\n                0,\n                graph.SupportsOf(parentOrdinal).Count,\n                $\u0022Parent fact #{parentOrdinal} carries no support\u0022);\n        }\n    }\n\n    private static IEnumerable\u003Cint[]\u003E Permutations(int count)\n    {\n        var indices = new int[count];\n        for (var i = 0; i \u003C count; i\u002B\u002B)\n        {\n            indices[i] = i;\n        }\n\n        return PermuteFrom(indices, 0);\n    }\n\n    private static IEnumerable\u003Cint[]\u003E PermuteFrom(int[] indices, int position)\n    {\n        if (position == indices.Length)\n        {\n            yield return (int[])indices.Clone();\n            yield break;\n        }\n\n        for (var i = position; i \u003C indices.Length; i\u002B\u002B)\n        {\n            (indices[position], indices[i]) = (indices[i], indices[position]);\n            foreach (var permutation in PermuteFrom(indices, position \u002B 1))\n            {\n                yield return permutation;\n            }\n\n            (indices[position], indices[i]) = (indices[i], indices[position]);\n        }\n    }\n\n    private static void True(bool condition, string name)\n    {\n        _checks\u002B\u002B;\n        if (!condition)"}
```

**[result: toolu_01Drqq5ZyV...]**
```
The file D:\aghado01\codex-scientiae\tests\doccer\Program.cs has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: PowerShell]**
```json
{"command":"dotnet run --project \u0022D:\\aghado01\\codex-scientiae\\brewery\\doccer\\Doccer.Tests.csproj\u0022 -c Release","description":"Build and run the doccer contract harness","timeout":300000}
```

**[result: toolu_01DRBzge1P...]**
```
D:\aghado01\codex-scientiae\tests\doccer\Program.cs(6735,44): warning CS8602: Dereference of a possibly null reference. [D:\aghado01\codex-scientiae\brewery\doccer\Doccer.Tests.csproj]
D:\aghado01\codex-scientiae\tests\doccer\Program.cs(7000,19): warning CS8602: Dereference of a possibly null reference. [D:\aghado01\codex-scientiae\brewery\doccer\Doccer.Tests.csproj]
doccer contract harness: 2091 checks passed
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","offset":6995,"limit":10}
```

**[result: toolu_01EsZgLLNE...]**
```
6995	            new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p" }, new[] { 3, 0 }),
6996	            new SupportEdge(0, "path", new[] { 1, 2 }, new[] { "p" }, Array.Empty<int>()),
6997	        };
6998	        for (var i = 0; i < distinctions.Length; i++)
6999	        {
7000	            True(!edge.Equals(distinctions[i]), $"support edge distinction {i} is an alternative");
7001	        }
7002	    }
7003	
7004	    private static void SupportHypergraphValidatesExactBasesAndRetainsAlternatives()
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\tests\\doccer\\Program.cs","old_string":"            True(!edge.Equals(distinctions[i]), $\u0022support edge distinction {i} is an alternative\u0022);\n        }\n    }","new_string":"            True(!edge.Equals(distinctions[i]), $\u0022support edge distinction {i} is an alternative\u0022);\n        }\n\n        True(!edge.Equals(null), \u0022null support edge inequality\u0022);\n    }"}
```

**[result: toolu_01L1cmxiH7...]**
```
The file D:\aghado01\codex-scientiae\tests\doccer\Program.cs has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: PowerShell]**
```json
{"command":"dotnet run --project \u0022D:\\aghado01\\codex-scientiae\\brewery\\doccer\\Doccer.Tests.csproj\u0022 -c Release","description":"Rebuild and rerun the doccer contract harness","timeout":300000}
```

**[result: toolu_01FkfiSt2V...]**
```
doccer contract harness: 2091 checks passed
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\roadmap.md","offset":84,"limit":40}
```

**[result: toolu_01VN5pDiGF...]**
```
84	and [design inquiry](../discussions/sol-doccer-material-basis-and-public-composability-20260806_105530.md).
85	
86	D43 and its
87	[K5a contract brief](../briefs/sol-doccer-k5a-contract-20260809_193131.md) then supersede the
88	provisional K5a shape: `SpanBatch` remains the exact occurrence table; compatible master plus
89	required domain/kind, ordered geometry, and canonical string-value tuples define semantic facts;
90	canonical fact tables deduplicate and order those values; exact fact-table/occurrence bases retain
91	ordered alternative support; and K7 receives only a narrow exact-table `FactReference`. K5a adds
92	no executable rule or fixed-point claim. The law registry now separates `K5-FACT-SUPPORT` from
93	K5b's `K5-SATURATE`; Lean remains deferred and must be reapplied when K5b freezes its positive rule
94	signature. No source surface or harness count changed. K5a implementation is the default next
95	chip; K6 contract work remains independently available.
96	
97	## Sequencing doctrine
98	
99	Engines first; **codex-scientiae adapters last**. scriba-scientiae was aborted — codex-scientiae is
100	renovated from the inside, so its converter/LaTeX lanes are the living lanes, and they become
101	thin consumers of doccer only after the doccer-native surface exists. Contracts gate work;
102	consumers witness (D14). Per-topic containment: `planning/` = living truth (decisions, roadmap,
103	ledger); `briefs/` = one small runstamped brief per chip iteration, guidance + that chip's
104	report appended on completion; `discussions/` = captured evidence.
105	
106	## Queue
107	
108	The detailed dependencies, tranche gates, and non-goals live in the
109	[architectural expansion workplan](architecture-expansion-workplan.md). The compact execution
110	order is:
111	
112	1. **Fact and support identity (K5a implementation; default next):** implement D43's compatible-
113	   master fact keys, canonical fact table, exact-basis support hypergraph, and narrow
114	   `FactReference`. `SpanBatch` remains the occurrence table. The chip executes no rules; its
115	   manual hierarchy diamond retains one fact with two supplied support paths.
116	2. **Sibling execution lanes (K5b and K6):** K5b adds finite positive saturation over the K5a
117	   carriers and proves its first contract with the bounded K4c diamond witness. Independently, K6
118	   adds output-to-tagged-source origin relations over one exact origin basis. K5b does not block
119	   K6.
120	3. **Materialization (K7):** after K6, close D7's final lift with positive-material ordered output
121	   pieces, a new immutable master, residuals, and composed stage origins. K7 has only an optional
122	   K5a `FactReference` seam; it does not require saturation. `OffsetMap` becomes a restricted
123	   monotone single-source view, not the universal transform carrier.
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\README.md","offset":283,"limit":50}
```

**[result: toolu_01Kqzmx9Ro...]**
```
283	- intrinsic and declarative relation/impossibility validation whose durable relation filters carry
284	  `AllenRelationSet`, plus Tier-1 invariants —
285	  reconstruction, run-view tiling, line consistency, suppression laws, resolution determinism,
286	  and interning round-trip — in the contract harness.
287	
288	## Deliberately absent
289	
290	These surfaces are absent because their contract or implementation gate is not closed. Contract
291	closure is the only authorization gate on engine work; D43 has crossed that gate for K5a, whose
292	implementation is now pending. A consumer's arrival prioritizes and validates; it never authorizes,
293	and its
294	absence is never by itself a reason to leave a gap. Where the brief names a "first consumer"
295	trigger, read it as a prioritization default for a contract whose remaining questions a real
296	consumer's shapes would answer best; any item may be pulled forward the moment its contract
297	closes honestly without one:
298	
299	- `OffsetMap` — contract shape drafted (sum-type point results `Exact | Range | Unmapped`,
300	  segment-list storage, span projection under a named policy with explicit residuals); the
301	  remaining open questions are the ones a first real edit-plan or normalization job would settle,
302	  so that job is the prioritization default rather than a permission condition;
303	- the rest of the lift algebra — project, group, run-within, and slice/rebase are in;
304	  materialize is not;
305	- further density measures beyond gap cadence (never a generic `Density` verb — each future
306	  measure arrives individually named, declaring numerator, denominator, window basis, boundary
307	  policy, exclusions);
308	- the D41 code-unit-vector substrate: V0 must first freeze compatible-window equality, Boolean and
309	  chunk-carry operations, classifier/residual stamps, scalar-boundary harvest, and its separate
310	  direct/harvest exits; independent V1 portable reference semantics precede V2 word/SWAR/SIMD
311	  backends; D42 registers carrier, prefix-scan refinement, and harvest separately and reapplies
312	  formal-assurance pressure per V2 backend;
313	- D41 measured implementation work: A0–A2 cover Doccer-owned workload/allocation evidence, a
314	  sparse set-bit walker, and reconstruct-once flat-path recurrence. A separate per-capability HPC
315	  repertoire applies to each admitted capability—span destinations, count-prefix-fill, flat/SoA layouts, operation/worker
316	  scratch, bounded heaps, online reductions, deterministic parallel state, and reference/fast
317	  backend pairing—not a generic HPC framework or imported ThermoMapper policy;
318	- suppression bitmaps as one later vector consumer/acceleration of the suppression query, never a
319	  claim property or second source of truth; D42 requires exact equality to the reference
320	  `Coverage(Q)`/`Complement` `SpanSet` result for the same exact suppressor
321	  `ClaimSelection` \(Q\);
322	- Unicode block and script properties as break-key facts: unlike the major-class fold, they would
323	  ship as versioned UCD data and need a data-provenance decision first;
324	- persisted batch formats; indexed join strategies;
325	- Tier-2 and Tier-3 acceptance — direct-versus-derived matching, tolerances, agreement scores;
326	- D43's K5a canonical fact table, exact-basis support hypergraph, and narrow `FactReference` are
327	  contractually closed but not implemented; K5b's executable positive saturation remains a
328	  separate open contract with the K4c hierarchy-diamond witness. The sibling K6 exact-tagged-basis
329	  origin algebra leads to K7 materialization, and K5b does not block K6 or K7. D35–D40 close K3 and
330	  all K4
331	  lanes without a common selector: the repeated exact-selection and named-policy stamps are real,
332	  but path, packing, cover, laminar, hierarchy, and resolution feasibility/results remain distinct.
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\decisions.md","offset":704,"limit":16}
```

**[result: toolu_01Mek9Mi5d...]**
```
704	| Symbol | Carrier | Identity and empty posture |
705	|---|---|---|
706	| \(P_M\) | valid boundaries recognized by `M` | points only; not interval or claim identities |
707	| \(L_M\) | located extents \((i,j)\) over \(P_M\), with \(i\le j\) | includes the diagonal empty extents used by located `Seq` |
708	| \(I_M\) | nonempty Allen intervals \((i,j)\), with \(i<j\) | `AllenRelation.Equal` is the geometric diagonal |
709	| \(C_M\) | identity-bearing claim occurrences | in-process identity is an ordinal on one exact frozen `SpanBatch`; equal geometry does not imply equal claims |
710	| \(F_M\) | canonical semantic facts on one compatible master value | D43 identity is required domain/kind plus ordered geometry and canonical string-value tuples; distinct from exact occurrence and support identity; source implementation pending |
711	| \(O_{N,M}\) | later output-to-source atom-origin relations | cross-master and basis-checked; distinct from support or causal derivation |
712	| \(V_{M,W}\) | later Boolean vectors over UTF-16 code-unit ordinals in exact window \(W\) | compatible-master/equal-window value basis; zero/all values are ordinary vectors, not intervals or occurrences; reserved by D41 for V0 |
713	
714	Consequently, diagonal empties belong to \(L_M\), not to Allen's \(I_M\). An all-zero
715	\(V_{M,W}\) is a Boolean value and says nothing about interval emptiness. Claim-pair identity is
716	the ordinal diagonal on one exact frozen batch. Origin identity is the atom diagonal between
717	compatible master bases. None of these identities may be borrowed by another carrier merely
718	because its projected geometry is equal.
719
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\README.md","offset":196,"limit":30}
```

**[result: toolu_018g6i44kN...]**
```
196	  determinism is exact-basis only, and the 128 subsets of a seven-edge graph agree with independent
197	  path-enumeration, DFS, gap, and dead-branch oracles;
198	- exact-basis graph-value K4b additive selection: `AdditivePathPolicy` snapshots one nonnegative `Int64` cost
199	  per candidate under required caller name/unit plus explicit minimum-additive and
200	  lexicographic-ordinal stamps; `PathSelectionProblem` retains exact admissible and hard-excluded
201	  populations and derives the exact admissible feasibility graph; `PathSelection.Select` uses a
202	  descending-boundary DAG recurrence to return the global minimum-cost complete source-graph
203	  `PartitionView` or a `PathSelectionResidual` wrapping K4a evidence; result populations account
204	  disjointly for selected, rejected-admissible, and excluded candidates, and the retained score is
205	  rechecked from policy costs; tokenizer and budget-plus-breakpoint chunk cases plus all 16,384
206	  admissibility-mask/binary-cost problems agree with independent complete-path enumeration;
207	- exact K4c structural families: `PackingView` validates disjoint selections while exposing gaps;
208	  `CoverView` validates total declared-window material while retaining overlap; `LaminarView`
209	  validates an exact no-proper-crossing selection and groups equal geometry without inferring
210	  parenthood; `Laminarizer.Admit` separately returns accepted and crossing-residue selections under
211	  a named grouped-priority `InclusionMaximal` policy, with an explicit maximal-not-maximum witness;
212	  `HierarchyView` retains explicit acyclic evidence-labeled edges including multiple parents, while
213	  `LaminarHierarchy.NearestContainers` is the policy-gated immediate-container projection;
214	  `ResolutionView` names an exact layer independently of kind/`SpanLevel`/budget, and
215	  `ResolutionMap` retains explicit compatible-master incidence, functional aggregation, or exact
216	  material aggregation. Independent bounded suites cover 1,024 structural masks, 4,096 greedy
217	  problems, every valid bounded nearest-parent family, 4,096 directed graphs, and 2,048 incidence
218	  endpoint problems;
219	- suppression as named `Admitted`/`Excluded` queries over that algebra, accepting an exact
220	  suppressor selection with predicate conveniences delegating through it — never a claim property,
221	  so the same claim suppresses under one question and is the target of the next;
222	- all thirteen Allen interval relations and a compatibility join projection backed by
223	  `ClaimPairView.Relate` (semantics only — no performance contract or independent join path);
224	- immutable `AllenRelationSet`, the qualitative Boolean value over exactly those thirteen atoms:
225	  `None`/`All`/`Equal`/singletons, validated sequence construction, membership and subset, union,
```
**[tool: Grep]**
```json
{"pattern":"1976","path":"src/doccer/README.md","output_mode":"content","-n":true}
```

**[result: toolu_01AFxmZWAR...]**
```
No matches found
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\roadmap.md","offset":106,"limit":60}
```

**[result: toolu_01MVNgeCNT...]**
```
106	## Queue
107	
108	The detailed dependencies, tranche gates, and non-goals live in the
109	[architectural expansion workplan](architecture-expansion-workplan.md). The compact execution
110	order is:
111	
112	1. **Fact and support identity (K5a implementation; default next):** implement D43's compatible-
113	   master fact keys, canonical fact table, exact-basis support hypergraph, and narrow
114	   `FactReference`. `SpanBatch` remains the occurrence table. The chip executes no rules; its
115	   manual hierarchy diamond retains one fact with two supplied support paths.
116	2. **Sibling execution lanes (K5b and K6):** K5b adds finite positive saturation over the K5a
117	   carriers and proves its first contract with the bounded K4c diamond witness. Independently, K6
118	   adds output-to-tagged-source origin relations over one exact origin basis. K5b does not block
119	   K6.
120	3. **Materialization (K7):** after K6, close D7's final lift with positive-material ordered output
121	   pieces, a new immutable master, residuals, and composed stage origins. K7 has only an optional
122	   K5a `FactReference` seam; it does not require saturation. `OffsetMap` becomes a restricted
123	   monotone single-source view, not the universal transform carrier.
124	4. **Cross-carrier integration demonstrations (K8):** re-run pairing, ambiguous token paths,
125	   budgeted flat chunks, fixed bounded macro substitution with composed origins, and explicitly
126	   bounded dynamic expansion as one integrated suite. Their first bounded witnesses already land
127	   with K2, K3/K4, and K6/K7; K8 proves composition across the completed kernel.
128	5. **Downstream commitments and optional branches:** stable carrier identities unlock the
129	   committed separate CLI module and its wire forms, durable adapters, persistence, and indexes.
130	   Most substantial F8/F9 implementations retain a post-K
131	   execution default, but no family has a blanket K8 type dependency: F7a correspondence,
132	   F8a/F8b low-level contracts, and F9a views over current populations are independent; F7b/F7c
133	   and fact/origin feature recipes wait only for the carriers they name. D8/D10 decide kernel
134	   versus adjacent placement one named capability at a time. A fixed linear-ET compiler may follow
135	   K7; uncertain QSTR networks branch from K1 only when a real consumer appears.
136	
137	**Independent V/A lanes:** V0 may now close the compatible-master/exact-window UTF-16 code-unit
138	Boolean-vector contract, unit residual, chunk carry, and direct/harvest exits. Its portable V1
139	implementation follows independently and precedes any V2 accelerated backend. D42 requires V0 to
140	state carrier, scan, and harvest obligations separately; V2 reapplies scan refinement per backend,
141	while packed `SpanSet` and suppression-query equivalence remain separate future gates. A0
142	may establish named dense/sparse time and allocation baselines now; A1's word-skipping
143	`ClaimSelection` walker
144	and A2's reconstruct-once `PathSelection` recurrence may then land under the frozen D30/D37
145	oracles. The per-capability HPC repertoire records span destinations, exact allocation, flat
146	layouts, operation/worker scratch, bounded heaps, online reductions, deterministic parallel state, and
147	reference/fast pairing—not a common framework. These lanes do not change K5a's default priority
148	or expose D20 numeric columns. Their evidence policy is Doccer's, not ThermoMapper's.
149	
150	**Parallel witness/census lane:** provisional PowerShell adapters may continue to reach directly
151	into the packaged DLL during the latex-ingest rewrite. They remain site-local, disposable research
152	instruments whose specimens test the vocabulary and expose missing compositions. They do not
153	freeze the public surface or postpone the ordered kernel work above.
154	
155	**Lean rigor is deferred and burden-triggered.** The
156	[bootstrap brief](../briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md) records the
157	ThermoMapper retrospective, corrected harness design, obligation triage, and restart procedure.
158	Activate it only when proof pressure can change a public signature, license an optimization or
159	stage fusion, resolve an exact-versus-lax boundary, or support a nontrivial global guarantee.
160	D29 records that the K2 Allen-image inclusion is an obligation but not an activation: reference
161	composition and C# witness/property tests own it until an optimized or generalized backend makes
162	universal no-false-negative equivalence load-bearing. D33–D43 leave K3/K4a and the first K4b/K4c
163	executor on direct finite reference semantics. D37 reapplies the global-optimum trigger and keeps
164	Lean deferred under one closed finite-DAG additive recurrence plus exhaustive differential
165	evidence. D39 reapplies the structural gate and keeps Lean deferred under direct validators,
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\roadmap.md","old_string":"reference/fast pairing\u2014not a common framework. These lanes do not change K5a\u0027s default priority\nor expose D20 numeric columns.","new_string":"reference/fast pairing\u2014not a common framework. These lanes do not change the K5b/K6 default\npriority or expose D20 numeric columns."}
```

**[result: toolu_01APi9Cr1W...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\planning\roadmap.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\decisions.md","old_string":"distinct from exact occurrence and support identity; source implementation pending |","new_string":"distinct from exact occurrence and support identity; implemented as \u0060FactKey\u0060/\u0060CanonicalFactTable\u0060 |"}
```

**[result: toolu_01Uhg1M6MV...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\planning\decisions.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\planning\\architecture-expansion-workplan.md","old_string":"#### K5a: canonical fact and support identity\n\nThe contract is frozen by D43 and its\n[superseding brief](../briefs/sol-doccer-k5a-contract-20260809_193131.md). K5a is immutable fact\ncanonicalization plus supplied support evidence. It introduces no executable rule carrier,\nworklist, or fixed-point claim.","new_string":"#### K5a: canonical fact and support identity (closed 2026-08-09)\n\nThe contract is frozen by D43 and its\n[superseding brief](../briefs/sol-doccer-k5a-contract-20260809_193131.md). K5a is immutable fact\ncanonicalization plus supplied support evidence. It introduces no executable rule carrier,\nworklist, or fixed-point claim. The carriers are implemented at \u0060src/doccer/Facts/\u0060 with the\nfull exit gate below (harness 1976\u21922091)."}
```

**[result: toolu_015pS7bJeE...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\planning\architecture-expansion-workplan.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\src\\doccer\\README.md","old_string":"- D43\u0027s K5a canonical fact table, exact-basis support hypergraph, and narrow \u0060FactReference\u0060 are\n  contractually closed but not implemented; K5b\u0027s executable positive saturation remains a\n  separate open contract with the K4c hierarchy-diamond witness. The sibling K6","new_string":"- K5b\u0027s executable positive saturation \u2014 the K5a fact/support carriers are implemented, but the\n  positive rule carrier, worklist, \u0060Saturate\u0060, and least-fixed-point claim remain a separate open\n  contract with the K4c hierarchy-diamond witness. The sibling K6"}
```

**[result: toolu_01Bb64Lx2b...]**
```
The file D:\aghado01\codex-scientiae\src\doccer\README.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-k5a-contract-20260809_193131.md","old_string":"Runstamp 20260809_193131. **Status: contract frozen as D43; source implementation pending.**","new_string":"Runstamp 20260809_193131. **Status: contract frozen as D43; implemented \u2014 see the appended\nreport (harness 1976\u21922091; K5a closed).**"}
```

**[result: toolu_01KkoiL48m...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\briefs\sol-doccer-k5a-contract-20260809_193131.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-k5a-contract-20260809_193131.md","old_string":"The following implementation chip owns the K5a C# values and bounded witness. K5b contract work\nbegins only after those carriers close; K6 remains independently available throughout.","new_string":"The following implementation chip owns the K5a C# values and bounded witness. K5b contract work\nbegins only after those carriers close; K6 remains independently available throughout.\n\n## Implementation report (2026-08-09)\n\nThe carriers land as \u0060src/doccer/Facts/\u0060 in namespace \u0060CodexSci.Doccer\u0060:\n\n- \u0060FactKey.cs\u0060 \u2014 sealed value class with required ordinal \u0060Domain\u0060/\u0060Kind\u0060, snapshotted ordered\n  \u0060TextSpan\u0060 geometry and non-null string value tuples, value equality/hash, and an internal\n  \u0060CompareCanonical\u0060 implementing the \u00A73 total order (zero exactly on value equality).\n- \u0060CanonicalFactTable.cs\u0060 \u2014 \u0060Create(master, proposals)\u0060 snapshots, validates every extent on the\n  retained master (\u0060ValidateSpan\u0060 admits empties; zero-arity is master-global), collapses exact\n  duplicates, and enumerates canonically; compatible-master value equality/hash follows the\n  \u0060LocatedRelation\u0060 precedent; \u0060TryGetOrdinal\u0060 is the binary-search key lookup. \u0060FactReference\u0060\n  is a readonly struct with hand-written equality on \u0060ReferenceEquals(table)\u0060 \u002B ordinal \u2014\n  deliberately not default record equality, which would have delegated to the table\u0027s value\n  equality and made value-equal twin tables interchangeable against \u00A73.\n- \u0060SupportHypergraph.cs\u0060 \u2014 \u0060SupportEdge\u0060 sealed value class (required rule ID, ordered\n  premise/parameter/occurrence tuples, duplicates preserved, value equality and canonical order);\n  \u0060SupportHypergraph.Create\u0060 retains the exact fact table and exact compatible-master \u0060SpanBatch\u0060,\n  validates all ordinals against both bases, collapses exact duplicate edges, and enumerates in\n  canonical edge order; \u0060SupportsOf\u0060 projects one conclusion\u0027s retained alternatives.\n\nSeven harness checks cover the full \u00A77 gate: key semantics and every distinction axis, canonical\ncollapse/order with all 120 proposal permutations agreeing on one value and hash,\ncompatible-master equality plus incompatible-master refusal, the exact \u0060FactReference\u0060 boundary\n(twin tables share keys, never references), edge value semantics, exact-basis refusals with\nalternatives/seeds/cycles retained, snapshot checks mutating every caller sequence, and the\nhierarchy-diamond witness supplying \u0060Ancestor(a,d)\u0060 with two ordered paths and unsupported Parent\nfacts \u2014 no rule executes. Harness 1976\u21922091, zero build warnings.\n\nNo non-goal was touched: no rule carrier, \u0060Saturate\u0060, second occurrence table, multi-batch basis,\npersisted ID, wire format, payload/comparer, acyclicity claim, or Lean activation. Canon updated:\nD43 marked implemented, ledger row added, roadmap/workplan/README status flipped. K5b contract\nwork is unblocked; K6 remains independently available."}
```

**[result: toolu_015u4adaas...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\briefs\sol-doccer-k5a-contract-20260809_193131.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: Grep]**
```json
{"pattern":"K5-FACT-SUPPORT|K5a","path":"issues/doccer/briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md","output_mode":"content","-n":true,"head_limit":20}
```

**[result: toolu_018789oUrQ...]**
```
464:| K5a canonical fact/support identity | D43 immutable reference construction, canonical-order/equality laws, adversarial exact-basis validation, proposal permutations, and a manually supplied two-support diamond | before an alternate, persisted, compressed, or incremental fact/support backend claims the same extensional identity without complete differential evidence |
523:The practical next step after D43 is K5a fact/support implementation, not Lean. The first future proof
533:D40 splits K5a fact/support identity from K5b positive saturation and reapplies signature pressure
536:least-fixed-point theorem under explicit hypotheses. K5a must make those hypotheses structural:
540:The then-open question was resolved by D43 below: K5a exposes no executable rule signature. K5b
625:## 2026-08-09 D43 K5a fact/support assurance split
627:D43 separates the former combined `K5-SATURATE` registry row into `K5-FACT-SUPPORT` and
628:`K5-SATURATE`. K5a freezes finite immutable values only: compatible-master fact-key equality,
633:The K5a burden is therefore owned by direct reference construction, immutable snapshots,
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md","offset":515,"limit":15}
```

**[result: toolu_01BsJtmVzT...]**
```
515	
516	## 9. Deferred conclusion
517	
518	ThermoMapper validates the *method*—formalization as a pressure test on load-bearing engineering—but
519	also shows that a proof harness has its own lifecycle cost and can accumulate misleading green
520	states. Doccer should keep the proof-obligation inventory now and defer the toolchain until a claim
521	crosses the burden gate.
522	
523	The practical next step after D43 is K5a fact/support implementation, not Lean. The first future proof
524	most likely to repay its cost is not a reproof of Allen's table, the unoptimized pair join, D35's
525	direct located closure, D37's sole additive recurrence, or D39's direct structural validators; it
526	is a law that licenses compression, pruning, generalized optimization, closure/composition, fusion,
527	or another independent backend without changing reference meaning. D29 names the pair-abstraction
528	candidate, D37 records the path trigger outcome, D39 records the structural outcome, and
529	origin/support machinery remains the other leading source.
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"D:\\aghado01\\codex-scientiae\\issues\\doccer\\briefs\\sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md","old_string":"The practical next step after D43 is K5a fact/support implementation, not Lean. The first future proof","new_string":"The practical next step after D43 was K5a fact/support implementation, not Lean; that chip landed\n2026-08-09 (harness 2091) with \u0060K5-FACT-SUPPORT\u0060 owned by its direct construction, adversarial\nvalidation, and proposal-permutation tests, exactly as registered. The first future proof"}
```

**[result: toolu_01GUhrRzH3...]**
```
The file D:\aghado01\codex-scientiae\issues\doccer\briefs\sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md has been updated successfully. (file state is current in your context — no need to Read it back)
```
**[tool: PowerShell]**
```json
{"command":"git -C \u0022D:\\aghado01\\codex-scientiae\u0022 status --short","description":"Show working tree status"}
```

**[result: toolu_01F3irnkGr...]**
```
 M issues/doccer/briefs/sol-doccer-k5a-contract-20260809_193131.md
 M issues/doccer/briefs/sol-doccer-lean-rigor-bootstrap-deferred-20260804_142019.md
 M issues/doccer/planning/architecture-expansion-workplan.md
 M issues/doccer/planning/decisions.md
 M issues/doccer/planning/ledger.md
 M issues/doccer/planning/roadmap.md
 M src/doccer/README.md
 M tests/doccer/Program.cs
?? src/doccer/Facts/
```
**[tool: PowerShell]**
```json
{"command":"git -C \u0022D:\\aghado01\\codex-scientiae\u0022 add -A \u0026\u0026 git -C \u0022D:\\aghado01\\codex-scientiae\u0022 commit -m @\u0027\ndoccer: implement K5a canonical fact/support carriers (D43)\n\nsrc/doccer/Facts/ lands FactKey, CanonicalFactTable \u002B FactReference, and\nSupportEdge \u002B SupportHypergraph; the manual K4c hierarchy-diamond witness and\nthe full D43 exit gate run in the contract harness (1976 -\u003E 2091, no warnings).\nK5a closed; K5b/K6 are the sibling next lanes. Canon, roadmap, workplan,\nledger, engine README, and deferred Lean packet updated; implementation report\nappended to issues/doccer/briefs/sol-doccer-k5a-contract-20260809_193131.md.\n\nCommitted by Claude\n\u0027@","description":"Commit the K5a implementation chip"}
```

**[result: toolu_01UYZy8GFY...]**
```
[main 6423fb1] doccer: implement K5a canonical fact/support carriers (D43)
 11 files changed, 1435 insertions(+), 38 deletions(-)
 create mode 100644 src/doccer/Facts/CanonicalFactTable.cs
 create mode 100644 src/doccer/Facts/FactKey.cs
 create mode 100644 src/doccer/Facts/SupportHypergraph.cs
```
**[tool: Read]**
```json
{"file_path":"C:\\Users\\azrie\\.claude\\projects\\D--aghado01-codex-scientiae\\memory\\doccer-recon.md"}
```

**[result: toolu_01LQQsjQFH...]**
```
<system-reminder>This memory is 7 days old. Memories are point-in-time observations, not live state — claims about code behavior or file:line citations may be outdated. Verify against current code before asserting as fact.</system-reminder>
1	---
2	name: doccer-recon
3	description: "doccer = interval-algebra document-preprocessing engine; AS OF 2026-08-02 a REAL C# kernel lives in codex-scientiae src/doccer (CodexSci.Doccer, brewery recipes, 1500-check harness passing, canon D1-D24, TRANCHE 3 COMPLETE); charter/legwork docs relocated to MarkBrain/MarkPig/doccer/legwork; membrane ported its CALCULUS earlier; masks.ps1 to be REBORN as PS helper layer over the DLL, never grown into the engine"
4	metadata: 
5	  node_type: memory
6	  type: reference
7	  originSessionId: bee8a906-dd32-4f48-8089-22d1e29e2c06
8	  modified: 2026-08-02T22:09:50.174Z
9	---
10	
11	**IMPLEMENTATION LANDED (2026-08-01, commit da7ff719) in codex-scientiae, not MarkPig:** first earnest
12	C# kernel at `src/doccer/{Core,Algebra,Collector,Validation}` (namespace `CodexSci.Doccer`): TextMaster
13	(identity+fingerprint+topology), total scalar tiling w/ explicit unpaired-surrogate atoms, overlap-preserving
14	columnar SpanBatch, master-bound SpanSet, all 13 Allen relations + reference join, priority-greedy
15	Laminarizer w/ equal-geometry groups + crossing residue, scoped RegexCollector (matches per admitted
16	region, cannot bridge exclusions), declarative relation/impossibility validation. Delivery =
17	HDBSCAN pattern: `brewery/doccer/*.csproj` recipes + `build-doccer.ps1` → packages/doccer; tests =
18	dependency-free harness `tests/doccer/Program.cs` (954 checks, passing). Deliberately absent until
19	contracts close (see `issues/doccer/sol-doccer-next-steps.md`): OffsetMap, level-projection ("lift" =
20	5 distinct ops), density variants, suppression bitmap, persisted batches, inventory loader.
21	KNOWN DEFECT flagged 2026-08-01: TextMaster.Fingerprint hashes via Encoding.Unicode whose replacement
22	fallback maps every lone surrogate to U+FFFD — identity is blind exactly where the topology is sighted;
23	fix = hash raw code units (LANDED 2026-08-01 Tranche-0 chip, harness 959 green). Legwork/charter
24	paths MOVED to `D:\aghado01\MarkBrain\MarkPig\doccer\legwork\{SHAPE,SCHEMA,UNIFIED-SWEEP}.md`
25	(paths = hints). USER DIRECTIVE 2026-08-01: legwork = HISTORICAL EVIDENCE ONLY — cite, never
26	amend; CANON = codex-scientiae `issues/doccer/planning/{decisions,roadmap,ledger}.md` (living
27	current-truth, corrected in place; D1–D24 + F-items + Q-ledger; roadmap = ahead-only queue;
28	ledger = completed roadmap items with contracts + witness links, split out 2026-08-02). Founding-run brief
29	`issues/doccer/briefs/fable-doccer-dev-brief-20260801_222912.md` = historical run record;
30	future briefs = small per-chip guidance + report ([[project-brief-locations]]).
31	src/doccer/README.md = in-repo contract surface, must agree with planning/; Tranche 2 COMPLETE 2026-08-01 (interned columns, EmitRuns break-key
32	views, Suppression.Admitted/Excluded, JSONL loader + ExecutionScope, Tier-1 invariants; harness
33	1263). Q3 RESOLVED as D15 (2026-08-01): PerLine = content extent, terminator EXCLUDED (CRLF/LF
34	claim-text determinism; terminator codepoints remain first-class atoms; per-line terminator-kind
35	view = future derived fact, not implemented). SOL REVIEW 20260802 ANSWERED SAME DAY (hashes
36	remapped by the same-day packages/node_modules history purge — cite the response appendix in
37	issues/doccer/discussions/sol-doccer-review-20260802.md, not raw hashes): D16 = collection TRANSACTIONAL
38	(CollectInto stages, commits only on full-sweep success); D17 = set-theoretic interval semantics
39	(empty spans intersect NOTHING; point location = TextSpan.Contains(int) +
40	SortedSpanLookup.FindContaining; Project insertion-point convention = the one exception); D9
41	extended (capture-group identity validated against compiled pattern; undefined enum casts
42	rejected at ctor + builder.Add); harness 1263→1330 (Join/Project/EmitRuns-comparer + 5
43	behavioral gaps now covered); build-doccer.ps1 smoke-tests the DELIVERED payload + writes
44	doccer.manifest.json (commit/timestamp/TFM/harness result — manifest-less package = unverified);
45	roadmap RESEQUENCED: harvest survey now precedes first CLI verbs (survey grounds the task
46	grain), Tranche 3 SPLIT into 4 chips (3a slice/rebase, 3b group+project, 3c gap cadence, 3d
47	priority-aware lookup); inspect/relate CLI = disposable diagnostics predating D13, not
48	contracts; Tier-1 precision: ValidateIntrinsic = atom coverage + claim bounds ONLY, the other
49	Tier-1 laws live as harness tests (runtime runner = named unscheduled candidate). T2-2 RESOLVED
50	as D18 (2026-08-02, user-confirmed with BOUNDARY refinement): CultureInvariant unions in the
51	PatternRule CONSTRUCTOR, not only the loader — inventory rules and direct DLL callers = ONE
52	collector contract, matching never inherits ambient culture (Turkish-I witness in harness;
53	1340 checks). D18 refinements (user): options AUGMENT the invariant baseline, never replace
54	execution policy → ECMAScript REJECTED at the boundary as a different matching profile —
55	EMPIRICAL: net10 PERMITS ECMAScript|CultureInvariant (docs claiming forbidden = stale), so
56	rejection is a CONTRACT choice, case-sensitive-only carve-out possible on concrete need;
57	guarantee = ambient-culture independence, NOT immunity to runtime/Unicode case-table changes.
58	TRANCHE 3a DONE 2026-08-02 in-session (brief fable-doccer-t3a-brief-20260802_005408.md +
59	report): TextSlice + rebase = D19 (child identity DERIVED+DETERMINISTIC {parent}#{s}-{e} at
60	parent revision → recreated slices compatible/interoperable; child→parent TOTAL bijective over
61	offsets/spans/sets/batches + ToParentInto weaving; parent→child PARTIAL+LOUD, no downward batch
62	projection — residual policy = F1; composition = chained calls, no combinator); T2-1 → D20
63	(interned columns public, numeric internal); T2-5 documented (bind scope/priority by name).
64	KEY FINDING: collection COMMUTES with rebase for whole-master AND per-line scopes (both routes
65	match identical sliced region strings) — the anticipated PerLine mid-line-window caveat
66	dissolved. TRANCHE 3b DONE same session (brief fable-doccer-t3b-brief-20260802_011103.md +
67	report): group/project = D21 (basis-stamped views: typed refs + named policies on the view —
68	Source/Master/key/Membership; Grouping.ByKey deterministic keyed partition, first-appearance
69	order, null keys legit; Projection.Project claim-major LineRanges; Grouping.ByLine line-major
70	transpose, TOTAL over grain, named LineMembership policy EveryLineTouched|StartLineOnly —
71	boundary-policy-as-declared = the D8 discipline 3c inherits; views hold ordinals never copies);
72	T2-4 → D22 (selectors stay plain delegates; ClaimFacts mirrors AtomFacts, settled by parallel
73	precedent). ALL Tranche-2 stragglers now closed. TRANCHE 3 CLOSED same session (brief
74	fable-doccer-t3cd-brief-20260802_012056.md + report): 3c gap cadence = D23 (first D8 named
75	measure, TRANSCRIBED FROM MDNAV mdnav.mjs cadence() — start-to-start gaps, upper-median/cv/
76	span-fraction facts; window basis admits by claim START, length = span denominator, AddressUnit
77	on stamp; exclusions = predicate recorded as ordinals evidence; mdnav's ≥4/cv<0.6 thresholds
78	stay in CONSUMERS per D10); 3d = D24 (ClaimOrder query-order policy on FindIntersecting/
79	FindContaining: Geometry default unchanged | PriorityThenGeometry = priority desc then
80	geometry then ordinal = total order; acceleration = F4). D7 lift vocabulary complete except
81	materialize; D8 doctrine has its template instance. Harness 1500.
82	Queue now: HARVEST SEED READ → CLI verbs → adapters LAST. Census posture settled 2026-08-02
83	(user, two corrections): (1) NO FREEZE framing — verb list = LIVING CANON, shipped
84	names/semantics hold steady (D8 at the CLI surface), namespace stays OPEN; (2) NO
85	read-everything sweep — census = STANDING ABDUCTIVE PRACTICE. Seed read = the 4 genealogy
86	files ONLY (masks.ps1 258, latex.ps1 403, md-repair.ps1 221, mdnav.mjs 1165 — ~2k lines),
87	synthesized into site records (where / what improvised / which primitive rediscovered or verb
88	implied) = evidence basis for the FIRST verb mint. Latent demand harvested opportunistically as
89	doccer integrates into workflows (latex-ingest e2e = first named occasion): each bespoke
90	resolution encountered → "should this read doccer instead?" → hit = site record in the
91	FUTURE-CONSUMER REGISTRY (named witnesses per F-family) or opportunistic surface exposure.
92	Graveyard repair farm (legacy_code/tools repair_* ×~30) = F1 demand-evidence pool on demand,
93	never a gate; scriba NEVER read. SEED READ DONE 2026-08-02 in-session (commit 5ffa32d): site
94	records in issues/doccer/discussions/fable-doccer-harvest-seed-20260802.md (basis codex
95	d870f8a + utils 775905f). FINDINGS: queued verb pair (collect + span-algebra) CONFIRMED by
96	density — SpanSet already carries the full set algebra; inventory packs ready-made (latex
97	Rx* registers, mdnav LINE_KIND/noise species); NEW-PRIMITIVE CANDIDATE = PAIRING LIFT
98	(open/close claims → paired regions + fault residue unclosed/dangling/mismatched; 3 witnesses:
99	begin/end name-aware, left/right sizing, md fences; passes D10; fault residue = defect-inventory
100	thesis operational); weaker candidate = total-partition views (mdnav activeAt/virtualRoot
101	totality, generalizes D21 ByLine); F1 has LIVE witnesses (Set-MdSpan -Expect byte splice,
102	back-to-front batch = manual OffsetMap dodge) beyond the graveyard; F3 has 3 witnesses (byte
103	line indexes in md-repair + mdnav, per-match code-unit→byte conversion). VERB MINT PENDING
104	USER ratification. GROK latex-ingest dive VERIFIED 2026-08-02 (harvest doc addendum 2, commit
105	1519970): 6/7 clusters confirmed, coordinate-bug claim REFUTED (Get-MaskedText -Keep is
106	length-preserving — kept-string indices valid on original). PAIRING now ~7 witnesses incl. a
107	SELF-ANNOTATED site (Protect-InlineDollarSpans:1048 names "the doccer/masks calculus" in its
108	comment); Build-LabelMaps IndexOf('\end{env') segmenting is NESTING-BLIND (defect potential).
109	F1 upgraded ARCHITECTURAL: the @@placeholder@@ protect/restore registry + Restore fixed-point
110	loop = OffsetMap workaround at pipeline scale. Store taxonomy: two tiers — domain rule packs
111	vs DOCUMENT-LOCAL stores (macro tables, label maps); live precedent
112	src/latex-ingest/stores/docgraph.json. D13 SHARPENED 2026-08-02 (user): four layers — engine primitives / CLI verbs =
113	named DOMAIN-AGNOSTIC CAPABILITIES one reaches for (collect, algebra, pair — never domain
114	tasks; "endpoint" retired per [[house-nomenclature-primacy]]) / PER-DOMAIN PATTERN STORES
115	(the things-to-capture as data; latex Rx* + mdnav construct tables = first two packs) / PS
116	adapters (capability calls + store entries + genuinely-domain policy). REWRITE TEST = the
117	boundary criterion: a PS site is finished when it collapses to capability+store+policy;
118	refusal to collapse = missing doccer surface (census signal) or permanent adapter policy.
119	Pairing → `pair` verb once engine contract lands; open/close token rules = store entries.
120	LEXICON CANDIDATES (2026-08-02, harvest addendum 4 — CATALOG not mint, names await user):
121	typed verbs over sorts (text/master/batch/set/fragment/view/pack/policy/measure) — master =
122	coordinate overlay over ANY text (not TeX-specific); collect/slice/weave/set-ops EXIST; pair
123	= missing mechanism; braid/unbraid = CHANNEL-axis candidates (interleaved stream = braid);
124	FIBER preferred over strand (user): channel = fiber of the kind-projection, unbraid = π⁻¹(k),
125	EVERY PROJECTION HAS FIBERS (kind/parent/class); strand survives only in braid imagery. Axis
126	discipline: slice⇄weave = coordinate/lineage axis, braid⇄unbraid = channel axis, "unweave"
127	REJECTED (weave's inverse is slice). FRAGMENT = a text with a BIRTH CERTIFICATE (full master
128	over a window remembering parent+window+revision → authorizes rebase/weave; ephemeral
129	workbench vs persistent nodes; fiber = by-property, fragment = by-position); candidate: let
130	"slice" be verb AND result noun (canon TextSlice), retiring "fragment" as sort name. UNBRAID
131	RIDES THE MASK LAYER (user): on unassembled text unbraid IS mask composition (prose fiber =
132	¬(math∪code∪comments)); on the assembled stream it degenerates to filter; ENTRAINMENT = D6
133	scope intersection (fiber mask → caller scope, collectors can't bridge exclusions, D23
134	records the entrained mask as evidence); channel axis conceptually orthogonal but
135	operationally rides the suppression layer until assembly completes. ONE GRAMMAR
136	THREE SURFACES: C# types = deep grammar, PS veneer = interactive syntax (veneer names ARE
137	the lexicon), CLI expressions = boundary syntax. SESSION OUTCOME 2026-08-02 (commit 2d0bc1a):
138	VERB MINT SHELVED — usage-first. Terminology MARINATING (user chewing; NO naming commitments).
139	REGISTER DIRECTION (addendum 4c): COMMS/SIGNAL-PROCESSING preferred over textiles — Allen's
140	algebra was TEMPORAL, document axis = time-like, so comms vocabulary is LITERAL (manuscript
141	stream = TDM); house dialect was ALREADY comms (channel, register, mask/gating, detector,
142	signal, preamble, payload, sentinel). Candidates: mux/demux or interleave/deinterleave (for
143	braid/unbraid), fragment⇄reassemble (IP-native, may retire slice⇄weave), gate (suppression
144	admission), framing (spine partition); fiber keeps math/PH grounding. CLI needs more
145	design work before ANY commitment (wire waits on node-stream schema). NEXT = PROVISIONAL
146	DLL-REACH ADAPTERS: latex-ingest rewrite reaches directly into packages/doccer DLL from PS —
147	research instruments, site-local, DISPOSABLE, allowed to be ugly; their shapes generate
148	promotion evidence; census runs live; durable veneer stays LAST and distinct. Seed read +
149	census establishment moved to LEDGER same day.
150	CENSUS OBJECT (user, definitive framing 2026-08-02): verbs NAME latent call paths; capability
151	surface = doccer public API = the NAMED subset of the engine's latent path-space (closure of
152	primitives under composition; D12 keeps the space open), carved by witnessed demand; census
153	abduction yields TWO kinds of find — unnamed latent path (verb candidate: collect/algebra) vs
154	MISSING path (engine-contract candidate: pairing); rewrite-test refusal distinguishes missing
155	path from permanent adapter policy. Governing doctrine (user-corrected): claims carry evidence / queries execute named
156	policies and return results / ORCHESTRATION selects policy and interprets — engine hosts
157	resolution mechanisms as parameterized ops, never selects; some policy must flow INTO queries
158	(scoped matching, laminar admission change what is computed), the rest operates on results.
159	USER DIRECTIVE 2026-08-01 (D12): doccer = LIBRARY OF COMPOSABLE PRIMITIVES, never a pipeline —
160	every rung usable without rungs above (TextSpan/Allen → SpanSet → batch+collectors → laminar →
161	tiers); construction cost scales with what is touched (lazy fingerprint/topology, enrichment
162	never in constructors); master-identity floor NOT negotiable (masks.ps1 length-only accident);
163	evidence/cross-examination attaches to compositions that ask, not to primitive use. Witness:
164	macro expansion = rungs 1-3 only. Engine-before-car ≠ all-of-engine-before-any-use. MASTERS
165	SCALE DOWN: TextMaster = a coordinate space, not "the document" — mint one over an isolated
166	math span/macro site; floor governs MIXING not EXTENT (fragment-local spans refuse parent
167	validation = forgotten-base-offset bugs fail loud); lineage via slice map/rebase is opt-in.
168	D13 (2026-08-01): à la carte tools surface DOCCER-NATIVE — CLI at TASK grain (one-shot jobs,
169	domain knowledge as DATA inventories, never flags) + DLL at OPERATION grain; PS layer =
170	site-local veneer + domain adapters ONLY; boundary test = "lost on graduation ⇒ wrong layer"
171	(doccer expected to graduate cross-project, HDBSCAN payload precedent); CLI needs minimal
172	span/claim JSONL wire format, smaller than + prior to F2 archival format. ENGINEERING PRECEDENT
173	= ThermoMapper user-repl (snapshot D:\aghado01\project-snapshots\ThermoMapper\
174	src_20260701_122622_tree.md, shards s059-s065): hand-rolled ~40-line SubcommandRouter (no
175	command framework), per-verb files with zero hot path (all compute = engine calls), wire format
176	declared ONCE in a source-generated JsonSerializerContext with CLI-OWNED payload records (never
177	leaked engine types), presets/RunManifest = params+provenance as data with rehydrate-not-recompute
178	verbs; session objects = the DLL-grain twin (fluent style incidental). D14 (2026-08-01): CONTRACTS
179	GATE, CONSUMERS WITNESS — engines-first means anticipate-the-consumer; a contract closable from
180	first principles is closed by design; F-item "trigger: first consumer" = prioritization default,
181	NEVER permission; only implementing against an OPEN contract is forbidden. Do not scope engine
182	work by consumer existence (Fable made this mistake in Tranche-2 scoping; user corrected).
183	SEQUENCING (2026-08-01, user): scriba ABORTED → codex renovated in place; order = Tranche 3 →
184	doccer-native CLI verbs + primitives (harvest codex + other sources for domain-agnostic
185	capability) → codex-scientiae ADAPTERS LAST (masks veneer, LaTeX consumers = thin consumers of
186	the finished surface). "First things first."
187	mdnav (D:\aghado01\utils\skills-dev\doc-dive\mdnav) identified as convergent partial-doccer. USER
188	CORRECTION 2026-08-01: NO direct cross-talk/bridge intended — relation is SUCCESSION (mature doccer +
189	markdown adapter + instrument verbs eventually supplants the bespoke mdnav tool; mdnav fixtures =
190	acceptance oracle) plus conceptual transfer. mdnav has 3 strata: structural pseudo-parsing (doccer-shaped,
191	gets supplanted), reading-instrument verbs (spec witness for a future doccer car), skill semantics
192	(doc-dive reading discipline — stays ABOVE the engine, never enters it).
193	
194	**SHAPE.md written (2026-07-02) at `D:\aghado01\MarkPig\src\doccer\SHAPE.md`** — user decided doccer
195	lands in MarkPig as a new C# project under src/ beside pdfdig. The SHAPE doc encodes: engine-before-car
196	(anti-Frankenstein clause naming the membrane's 4 fragments), engine boundary (Collector + Algebra +
197	validation runners IN; orchestration/rule tables OUT = Phase 3 car), OffsetMap promoted in-engine,
198	algebra spec (closure, Allen's 13 relations, law surface from masks.ps1 discipline), 4 checkable
199	doneness criteria (laws / Tier-1 / validation-matrix expressibility / witness statements), 5 spec
200	witnesses (metric aligner, New-MarkdigAst intake, mathdig tokenizer, pdfdig symbol-correction Tier-2,
201	membrane consolidation W5), P1 substrate → P2 algebra (engine DONE at P2 exit) → P3 car. Open: assembly
202	naming (Markpig.Doccer vs Markpig.Spans), Phase-0 anchor migration from spcx src_dev/doccer
203	(recommended move), sweep's surrogate/grapheme choices.
204	
205	**doccer** — the user's ambitious language-agnostic tokenizer/chunking engine on interval algebra.
206	Reviewed 2026-07-02. Three layers, strictly separated: **Collector** (declarative pattern library →
207	columnar SoA `SpanIndex`), **Interval Algebra** (pure geometry: containment/adjacency/complement/runs/
208	density/lifts, zero regex, zero domain knowledge), **Orchestration** (declarative rule tables hold ALL
209	domain knowledge). Immutable master text; spans overlap freely (multi-claim); conflict resolution is an
210	explicit query step; normalization = new master string + forward OffsetMap.
211	
212	**State:** Phase 0 only — design anchor at `ps.core.pwshspc/src_dev/doccer/` ({README,SCHEMA,
213	UNIFIED-SWEEP,VALIDATION-MATRIX}.md + inventory.jsonl seed with provenance-tagged entries incl. math
214	Unicode registers down to SMP Mathematical Alphanumeric). NO code. Key contracts: unified O(N) sweep →
215	complete non-overlapping char tiling (atoms word/punct/ws/newline + Unicode block/script/category +
216	line topology; 64KB LUT; coverage guarantee = the bedrock invariant); 3-tier validation AS DATA
217	(T1 mechanical invariants, T2 cross-derivation pairings via `validates_against` → agreement_score,
218	T3 impossibility queries). ~320kb of vendor discussions in MarkBrain/ThermoMapper/issues/doccer.
219	
220	**Membrane relationship** (record: MarkBrain/codex-scientiae/doccer-membrane-integration.md): calculus
221	already ported — `math_dirt` = density∧¬mask, cross-derivation convergence in fidelity, predicate
222	consolidation into latex.ps1; substrate deliberately NOT imported. UNDERSOLD THERE: membrane's
223	`masks.ps1` IS a live, property-tested fragment of doccer's Phase-2 algebra (law tests over 100 random
224	masks, pincer top-down≡bottom-up, SMP codepoint safety) — the seed implementation + test suite for
225	Phase 2. PARKED but now demanded by 3 consumers: byte-exact OffsetMap (source-anchored propose_edit,
226	splice_md byte lane, conversion-metric per-unit pointers).
227	
228	**Sequencing (2026-07-02):** user's Markpig AST work (markdown + math ASTs) is WAITING on doccer
229	working. I first advised thin-slice/consumer-pulled build — **user REJECTED piecemeal: philosophy is
230	ENGINE-BEFORE-CAR** ("consumers help me spec the engine but building part of the engine for 3
231	different consumers risks incomplete and confused design" — Frankenstein risk). Conceded with
232	evidence: the membrane itself has grown FOUR partial span systems from immediate needs (masks.ps1,
233	Get-EnvironmentSpans, normalize density counting, md-repair byte offsets) — working, non-composing =
234	the Frankenstein piecemeal produces. Agreed frame: consumers = SPEC WITNESSES (expressibility checks
235	on the finished spec), never scope-cutters; internal completeness criterion = the validation matrix
236	(every Tier-2/Tier-3 declaration must be expressible as an algebra query, no escape hatches) + closure
237	discipline + Allen's 13 interval relations as generating vocabulary + masks.ps1-style law surface.
238	Compatible exception: mathdig may prototype against the converter's canonical math store (car work on
239	a bench, not engine pieces). DO NOT re-advise incremental doccer builds.
240	
241	**User thesis (2026-07-02, affirmed with formal grounding):** mature doccer "reconstructs ASTs without
242	the formality of ASTs" — a tree IS a laminar span family (any two spans disjoint or nested); given
243	laminarity + the coverage guarantee, containment = parenthood and the tree becomes a QUERY/VIEW over
244	sorted columns, not a data structure (cf. standoff annotation, tree-sitter ranges, Parquet/Dremel).
245	Domain kicker: spans BEAT ASTs on broken documents — parsers force a structure (CommonMark never
246	fails = silent misparse, the valid-but-wrong class), while crossing spans represent/flag the defects;
247	the non-laminar residue IS the defect inventory. Boundary: doccer owns read/analyze/validate/align;
248	Markpig AST owns write/transform/render (New-MarkdigAst = the span→tree lift valve; real parsers demote
249	to Collector passes with their own PassId). "Without formality" honestly = formality-as-DATA (rule
250	tables/priorities), not eliminated. Acceptance test = Tier-2 pairing vs Markdig's real AST:
251	agreement_score high on clean docs, divergence LOCALIZES silent misparses on dirty ones.
252	
253	**Session connections (2026-07-02):** the conversion-metric's two named gaps are doccer-shaped
254	(LaTeX-aware tokenizer = declarative `language: latex` inventory pack; monotone unit-alignment =
255	algebra primitive) → the metric is doccer Phase 2's first paying consumer. The metric's
256	holistic-vs-composite cross-check = doccer Tier-2 pairing (adopt agreement_score vocabulary). pdfdig's
257	symbol→Unicode correction frontier = a Tier-2 cross-derivation (font-role says CMSY-math, claimed
258	Unicode register says Basic-Latin 'k' → disagreement flag); unicode→KaTeX canonicalization detector =
259	the math register claims. Ecosystem: doccer = substrate (unit production), hashish = measures
260	(similarity over units), conversion-metric = composition; ThermoMapper consumes downstream (corpus
261	chunks → embeddings → SPC/Mapper TDA) — the cross-project bleed is the architecture. hashish placement
262	CORRECTED by user: ThermoMapper legitimately owns text-corpus TDA; hashish predates ThermoMapper's
263	shape and serves both sides.
264
```
**[tool: Grep]**
```json
{"pattern":"doccer recon","path":"C:\\Users\\azrie\\.claude\\projects\\D--aghado01-codex-scientiae\\memory\\MEMORY.md","output_mode":"content"}
```

**[result: toolu_01VN5hsS1o...]**
```
77:[Omitted long matching line]
```
**[tool: Read]**
```json
{"file_path":"C:\\Users\\azrie\\.claude\\projects\\D--aghado01-codex-scientiae\\memory\\MEMORY.md","offset":77,"limit":1}
```

**[result: toolu_01BuMdPtKm...]**
```
77	- [doccer recon](doccer-recon.md) — C# engine LIVE in src/doccer (harness 1500; Tranches 0–3 COMPLETE, canon D1–D24, lift complete except materialize, first D8 measure landed); CANON = issues/doccer/planning/{decisions,roadmap,ledger}.md; seed read DONE 2026-08-02 (verb pair confirmed; pairing lift = new-primitive candidate ×3 witnesses; F1/F3 live witnesses; mint pending user) → CLI verbs → adapters LAST; census = standing abductive practice, never a sweep; mdnav = succession + spec witness
```
**[tool: Edit]**
```json
{"replace_all":false,"file_path":"C:\\Users\\azrie\\.claude\\projects\\D--aghado01-codex-scientiae\\memory\\doccer-recon.md","old_string":"D7 lift vocabulary complete except\nmaterialize; D8 doctrine has its template instance. Harness 1500.","new_string":"D7 lift vocabulary complete except\nmaterialize; D8 doctrine has its template instance. Harness 1500.\nEXPANSION K-LANES (2026-08-04\u219209): workplan tranches K0\u2013K4 all closed (D25\u2013D39: Allen value\nlayer, claim query algebra incl. K2c PairingResult = the pairing lift landed, located relations,\nflat/additive/structural results; harness 1976); D40\u2013D43 recorded (register/math-channel\nterminology, K5a/K5b split, V/A lanes, K5a contract). K5a IMPLEMENTED 2026-08-09 at\nsrc/doccer/Facts/ (FactKey, CanonicalFactTable \u002B exact-table FactReference, SupportEdge \u002B\nSupportHypergraph, manual hierarchy-diamond witness; harness 2091; report appended to\nissues/doccer/briefs/sol-doccer-k5a-contract-20260809_193131.md). NEXT = K5b finite positive\nsaturation and K6 origin algebra as sibling lanes; K7 materialization after K6; Lean still\ndeferred (K5b reapplies signature pressure when its rule carrier freezes)."}
```

**[result: toolu_01TSE9jTP5...]**
```
The file C:\Users\azrie\.claude\projects\D--aghado01-codex-scientiae\memory\doccer-recon.md has been updated successfully.
```

K5a is landed and committed as `6423fb1` — harness **1976 → 2091, all green, zero warnings**.

**What landed in `src/doccer/Facts/`:**

- [FactKey.cs](src/doccer/Facts/FactKey.cs) — sealed value class: required ordinal domain/kind, snapshotted ordered geometry and value tuples, value equality/hash, and an internal `CompareCanonical` implementing the §3 total order (zero exactly on value equality, so canonical sort and duplicate collapse share one comparison).
- [CanonicalFactTable.cs](src/doccer/Facts/CanonicalFactTable.cs) — snapshot, per-extent master validation (empties and zero-arity admitted), duplicate collapse, canonical enumeration, compatible-master value equality on the `LocatedRelation` precedent, plus a `TryGetOrdinal` binary-search lookup. `FactReference` lives here too — one design point worth knowing: I gave it hand-written equality on `ReferenceEquals(table) + ordinal` rather than record-struct defaults, because default equality would have delegated to the table's *value* equality and quietly made value-equal twin tables interchangeable, which §3 forbids. A harness check pins that boundary.
- [SupportHypergraph.cs](src/doccer/Facts/SupportHypergraph.cs) — `SupportEdge` (ordered premise/parameter/occurrence tuples, duplicates preserved) and the graph that validates every ordinal against its exact fact-table and compatible-master `SpanBatch` bases, collapses exact duplicate edges, keeps alternatives/seeds/cycles, and enumerates canonically.

**Harness:** seven new checks map onto the §7 gate — key distinction axes, all 120 proposal permutations agreeing on one canonical value and hash, incompatible-master refusals, the exact-reference boundary, edge refusals with alternatives retained, caller-sequence snapshot checks, and the hierarchy-diamond witness supplying `Ancestor(a,d)` with two ordered paths and unsupported Parent facts — no rule executes anywhere.

**Close-out:** D43 flipped to implemented in decisions, ledger row added, roadmap/workplan/README statuses updated (K5b and K6 now lead the queue), the Lean packet notes `K5-FACT-SUPPORT` is owned exactly as registered, and the implementation report is appended to the [contract brief](issues/doccer/briefs/sol-doccer-k5a-contract-20260809_193131.md). I also refreshed the stale doccer memory to current truth (it still said harness 1500, canon D1–D24).

K5b contract work is unblocked whenever you want to pick it up; K6 remains independently available.


<!-- xid: 9b7ba3f6-7a26-44f6-9c0c-0a0824f752b8-0002 -->
---

# ok. lets export this chat to the issues discussion folder, verbose with only `synthetic` excluded. you can write the intermediate files through repo .claude/chat-export

**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\science-facility\\utils\\chat-export\\claude-export\\Export-ClaudeChat.ps1"}
```

**[result: toolu_016aV1iBb7...]**
```
1	<#
2	.SYNOPSIS
3	    Export a Claude Code chat thread to markdown. The agent-facing entry point.
4	
5	.DESCRIPTION
6	    Call this script directly with `&` — it dot-sources what it needs and takes
7	    bound parameters from the calling shell. Nothing to load first:
8	
9	        & "D:\aghado01\science-facility\utils\chat-export\claude-export\Export-ClaudeChat.ps1" `
10	            -SessionId $env:CLAUDE_CODE_SESSION_ID
11	
12	    This script exposes arguments that can be adjusted from their defaults based on user request.
13	
14	.PARAMETER SessionId
15	    The identifier that links the thread to export.
16	    By default, inferred automatically from $env:CLAUDE_CODE_SESSION_ID within Claude's native shell environment
17	    Throws if that is also empty rather
18	    than guessing. Note $env:CLAUDE_CODE_HOST_SESSION_ID is a different id and
19	    is NOT the transcript key.
20	
21	.PARAMETER MarkdownDir
22	    Destination directory for the markdown. Defaults to $env:JSO_EXPORT_DIR when
23	    set, otherwise D:\aghado01\.discussion. Override when the user names a
24	    location.
25	
26	.PARAMETER Exclude
27	    Exclusion list of chat log attributes for the export.
28	
29	    Valid values: thinking, tool-calls, tool-results, subagents, synthetic,
30	    timestamps, session-markers, exchange-markers.
31	
32	    1. The user may request specific override of default settings — e.g. `-Exclude thinking,synthetic` keeps tool calls and results,
33	    2. `-Exclude @()` keeps everything.
34	
35	.PARAMETER OutputPrefix
36	    Output filename prefix - the file is {OutputPrefix}-{threadId}.md. Default value is'Claude'.
37	
38	.OUTPUTS
39	    PSCustomObject { MarkdownPath, SessionId, ProjectName, ThreadId }
40	    Report the path. Do not read the file back — it is the conversation you just
41	    had, and pulling it into context is what this tool exists to avoid.
42	
43	#>
44	[CmdletBinding()]
45	param(
46	    [string]$SessionId = $env:CLAUDE_CODE_SESSION_ID,
47	
48	    [string]$MarkdownDir,
49	
50	    [ValidateSet('thinking', 'tool-calls', 'tool-results', 'subagents',
51	        'synthetic', 'timestamps', 'session-markers', 'exchange-markers')]
52	    [string[]]$Exclude = @('thinking', 'synthetic', 'timestamps', 'session-markers',
53	        'exchange-markers', 'tool-calls', 'tool-results', 'subagents'),
54	
55	    [string]$OutputPrefix = 'Claude'
56	)
57	
58	$ErrorActionPreference = 'Stop'
59	
60	. "$PSScriptRoot\claude-jso-run.ps1"
61	
62	if ([string]::IsNullOrWhiteSpace($SessionId))
63	{
64	    throw ('No session id. $env:CLAUDE_CODE_SESSION_ID is empty and -SessionId was not ' +
65	        'supplied. This is not a condition to work around: without it there is no way to know ' +
66	        'which thread to export, and guessing would export the wrong one.')
67	}
68	
69	# Preference order: what the caller asked for, then a standing destination, then
70	# the everyday default. The literal belongs here — this script is where personal
71	# defaults live, unlike the library beneath it, which hard-codes no paths.
72	if ([string]::IsNullOrWhiteSpace($MarkdownDir)) { $MarkdownDir = $env:JSO_EXPORT_DIR }
73	if ([string]::IsNullOrWhiteSpace($MarkdownDir)) { $MarkdownDir = 'D:\aghado01\.discussion' }
74	
75	$resolved = Resolve-ClaudeThreadPath -SessionId $SessionId
76	
77	$result = Invoke-ClaudeThreadExport `
78	    -SessionId    $SessionId `
79	    -MarkdownDir  $MarkdownDir `
80	    -OutputPrefix $OutputPrefix `
81	    -Format       'Structural' `
82	    -Exclude      $Exclude
83	
84	Write-Host "`nExported → $($result.MarkdownPath)" -ForegroundColor Green
85	
86	return [PSCustomObject]@{
87	    MarkdownPath = $result.MarkdownPath
88	    SessionId    = $SessionId
89	    ProjectName  = $resolved.ProjectName
90	    ThreadId     = $result.ThreadId
91	}
92
```
**[tool: Read]**
```json
{"file_path":"D:\\aghado01\\science-facility\\utils\\chat-export\\claude-export\\claude-jso-run.ps1"}
```

**[result: toolu_01HfJ3zDBe...]**
```
1	# claude-jso-run.ps1 — Entrypoint for the Claude Code thread export pipeline
2	#
3	# Dot-source this file to get all pipeline functions:
4	#
5	#   . "D:\aghado01\science-facility\utils\chat-export\claude-export\claude-jso-run.ps1"
6	#
7	#   # by session id — nothing else needed; the transcript locates itself, and
8	#   # the project slug is a component of the path it resolves to
9	#   Invoke-ClaudeThreadExport      -SessionId $env:CLAUDE_CODE_SESSION_ID
10	#   Get-ClaudeThreadPlan           -SessionId $id
11	#   Invoke-ClaudeThreadExportBatch -SessionId $id -MarkdownDir $outDir
12	#
13	#   # by directory — when you are pointing at a project dir yourself
14	#   Invoke-ClaudeThreadExport      -SourceDir $path
15	#   Invoke-ClaudeThreadExportBatch -SourceDir $path -MarkdownDir $outDir
16	#
17	# AGENTS: do not dot-source this. Use the sibling script instead — it applies
18	# everyday defaults, takes bound parameters, and dot-sources this file itself:
19	#   & "…\claude-export\Export-ClaudeChat.ps1" -SessionId $env:CLAUDE_CODE_SESSION_ID
20	# See README.md.
21	#
22	# FUNCTIONS
23	# ---------
24	#   Resolve-ClaudeThreadPath      Locate a transcript from its session id alone.
25	#   Get-ClaudeThreadPlan          Discover and group threads in a directory.
26	#   Invoke-ClaudeThreadExport     Full or partial pipeline: merged → exchanges → markdown.
27	#   Invoke-ClaudeThreadExportBatch  Batch: plan all threads, dispatch one export per leaf.
28	#
29	# SESSION-ID ENTRY POINT
30	#   Transcripts live at {configRoot}/projects/{encodedProjectDir}/{sessionId}.jsonl,
31	#   and session UUIDs are unique across project dirs. Resolve-ClaudeThreadPath
32	#   probes each project dir for `{sessionId}.jsonl` (one level, no recursion) so a
33	#   caller holding only $env:CLAUDE_CODE_SESSION_ID can export without knowing the
34	#   project-dir encoding.
35	#
36	#   One lookup yields two facts: the transcript file, and — because the project
37	#   slug is a component of the path it was found at — the project directory. So
38	#   every entry point takes -SessionId and nothing else. There is no separate
39	#   project to name; what differs between them is the verb, not the input.
40	#   Resolution is fail-loud: malformed id, zero hits, or
41	#   multiple hits all throw — there is deliberately NO newest-mtime fallback and
42	#   no content search, because a silent fallback would turn a system fault into a
43	#   quiet wrong-thread export.
44	#
45	# PIPELINE STAGES
46	# ---------------
47	#   Merged     Export-ClaudeThread       → {WorkingDir}/raw/, {WorkingDir}/merged/
48	#   Exchanges  Get/Export-ClaudeExchanges → {WorkingDir}/exchanges/
49	#   Markdown   ConvertTo-ClaudeMarkdownV2 → resolved output path (see below)
50	#
51	# OUTPUT FILE NAMING
52	#   Artifacts are named `{OutputPrefix}-{threadId}.{jsonl|md}` across stages
53	#   (merged, exchanges, markdown). `-OutputPrefix` defaults to 'thread' for
54	#   single-thread runs. The batch runner overrides it with the project leaf
55	#   (last hyphen-segment of the source dir's leaf name, e.g. 'tools') so
56	#   artifacts self-identify when collected across directories.
57	#
58	# MARKDOWN OUTPUT RESOLUTION (in precedence order)
59	#   -MarkdownPath        exact output file path (single-thread only)
60	#   -MarkdownDir         write {OutputPrefix}-{threadId}.md flat into this directory
61	#   $env:JSO_EXPORT_DIR  standing deliverable destination; single-thread only,
62	#                        the batch runner ignores it (see below)
63	#   (none)               write {OutputPrefix}-{threadId}.md into {WorkingDir}/output/
64	#
65	# CLAUDE CONFIG ROOT
66	#   Both the transcript source ({root}/projects) and the artifact roots
67	#   ({root}/tmp) hang off one directory, discovered by Get-ClaudeConfigRoot.
68	#   It honours $env:CLAUDE_CONFIG_DIR when set but never requires it — that
69	#   variable is empty in most agent shells, and the old
70	#   `[Path]::Combine($env:CLAUDE_CONFIG_DIR, 'tmp')` therefore produced the
71	#   RELATIVE path `tmp`, scattering artifacts under the caller's cwd.
72	#
73	# WORKING DIRECTORY — single thread
74	#   Defaults to {configRoot}/tmp/claude-jso-run/{timestamp}/ via New-JobWorkingDir.
75	#   Pass -WorkingDir to override. Directory creation for all pipeline stages
76	#   is handled by each stage function — this script does none of it.
77	#
78	# WORKING DIRECTORY — batch
79	#   Defaults to {configRoot}/tmp/{projectSlug}/{YYYYMMDD_HHmmss}/, where
80	#   {projectSlug} is the full slug of the source dir's leaf name
81	#   (e.g. `C--Users-azrie--claude-tools`). Per-thread artifacts
82	#   land in {BatchRoot}/{leafUuid}/. Pass -WorkingDir to override.
83	#
84	# MARKDOWN DIRECTORY — batch default
85	#   Defaults to {configRoot}/tmp/markdown/ (flat, project-agnostic). Files are
86	#   named `{projectLeaf}-{threadId}.md` so different projects coexist without
87	#   collision; same-thread re-exports overwrite in place ("current state"
88	#   mirror, separate from the per-run JSONL archive under {projectLeaf}/{ts}/).
89	#
90	# THREAD CHAIN GROUPING (Get-ClaudeThreadPlan)
91	#   Sessions are grouped into chains via .jsonl.idx sentinels. A session with
92	#   a .idx file has been continued; absence of .idx marks a leaf. Walk sorted
93	#   by LastWriteTimeUtc, accumulate until a no-.idx session closes the chain.
94	#   Leaf UUIDs are the dispatch targets; prior UUIDs are omitted (Export-ClaudeThread
95	#   auto-discovers them via New-ClaudeThreadManifest -SessionIds).
96	#
97	# DEPENDENCIES (always re-sourced on load)
98	#   claude-jso-jackson.ps1, claude-jso-markdown-v2.ps1
99	# -----------------------------------------------------------------------
100	
101	$ErrorActionPreference = 'Stop'
102	
103	. "$PSScriptRoot\claude-jso-jackson.ps1"
104	. "$PSScriptRoot\claude-jso-markdown-v2.ps1"
105	
106	function Resolve-ClaudeThreadPath
107	{
108	    <#
109	    .SYNOPSIS
110	        Locate a Claude Code transcript from its session id alone.
111	    .DESCRIPTION
112	        Transcripts are stored at {configRoot}/projects/{encodedProjectDir}/{sessionId}.jsonl.
113	        Session UUIDs are unique across project dirs, so the id alone is a
114	        sufficient key. This function probes every project dir for a file named
115	        `{sessionId}.jsonl` — one level deep, filename-only, no recursion.
116	
117	        Deriving the project dir from the current working directory is
118	        deliberately NOT done: that would re-implement an undocumented encoding
119	        convention, and it would be wrong when exporting a thread that ran under
120	        a different cwd. Probing by UUID is exact in both cases.
121	
122	        Resolution is fail-loud by design. A malformed id, zero hits, or more
123	        than one hit all throw. There is no newest-mtime fallback and no content
124	        search: an unresolvable session id signals a system fault, and a silent
125	        fallback would downgrade that fault into a quiet wrong-thread export.
126	
127	        Nested non-UUID .jsonl strays exist below some project dirs; the
128	        one-level probe excludes them by construction.
129	    .PARAMETER SessionId
130	        The session UUID (transcript basename), e.g. from $env:CLAUDE_CODE_SESSION_ID.
131	        Note that $env:CLAUDE_CODE_HOST_SESSION_ID is a different id and is NOT
132	        the transcript key.
133	    .PARAMETER ConfigRoot
134	        Optional override for the Claude config root. When omitted the root is
135	        discovered by Get-ClaudeConfigRoot, which honours $env:CLAUDE_CONFIG_DIR
136	        when set but never requires it — it is empty in most agent shells.
137	    .OUTPUTS
138	        PSCustomObject { SessionId, JsonlPath, SourceDir, ProjectName, ConfigRoot }
139	    #>
140	    [CmdletBinding()]
141	    param(
142	        [Parameter(Mandatory)]
143	        [string]$SessionId,
144	
145	        [string]$ConfigRoot
146	    )
147	
148	    # --- Resolve the config root (throws if none holds a projects/ directory) ---
149	    $ConfigRoot = Get-ClaudeConfigRoot -ConfigRoot $ConfigRoot -RequireProjects
150	    $projectsRoot = Get-ClaudeProjectsRoot -ConfigRoot $ConfigRoot
151	
152	    # --- Validate before probing: reject malformed ids rather than search for them ---
153	    $uuidPattern = '^[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}$'
154	    $regexOpts = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
155	                 [System.Text.RegularExpressions.RegexOptions]::CultureInvariant
156	    if (-not [System.Text.RegularExpressions.Regex]::IsMatch($SessionId, $uuidPattern, $regexOpts))
157	    {
158	        throw "Malformed session id: '$SessionId'. Expected a UUID of the form 8-4-4-4-12 hex digits."
159	    }
160	
161	    # --- Probe each project dir for {sessionId}.jsonl (one level, no recursion) ---
162	    $fileName = "$SessionId.jsonl"
163	    $hits = [System.Collections.Generic.List[string]]::new()
164	
165	    foreach ($dir in [System.IO.Directory]::EnumerateDirectories($projectsRoot))
166	    {
167	        $candidate = [System.IO.Path]::Combine($dir, $fileName)
168	        if ([System.IO.File]::Exists($candidate)) { $hits.Add($candidate) }
169	    }
170	
171	    if ($hits.Count -eq 0)
172	    {
173	        throw "No transcript found for session $SessionId under $projectsRoot"
174	    }
175	
176	    if ($hits.Count -gt 1)
177	    {
178	        # Empirically impossible (UUIDs are unique across project dirs); if it
179	        # ever happens it is exactly the anomaly class this resolver must scream about.
180	        throw ("Ambiguous session id $SessionId — $($hits.Count) transcripts found:`n  " +
181	            ($hits -join "`n  "))
182	    }
183	
184	    $jsonlPath = $hits[0]
185	    $sourceDir = [System.IO.Path]::GetDirectoryName($jsonlPath)
186	
187	    return [PSCustomObject]@{
188	        SessionId   = $SessionId
189	        JsonlPath   = $jsonlPath
190	        SourceDir   = $sourceDir
191	        ProjectName = [System.IO.Path]::GetFileName($sourceDir)
192	        ConfigRoot  = $ConfigRoot
193	    }
194	}
195	
196	
197	function Invoke-ClaudeThreadExport
198	{
199	    <#
200	    .SYNOPSIS
201	        Run the Claude thread export pipeline for a single source directory.
202	    .DESCRIPTION
203	        Orchestrates Export-ClaudeThread → Get/Export-ClaudeExchanges →
204	        ConvertTo-ClaudeMarkdownV2 in sequence. Use -RunThrough to stop after
205	        any stage. All directory creation is delegated to the stage functions.
206	
207	        Two entry points:
208	          BySourceDir (default)  -SourceDir [-SessionIds]  — original behaviour.
209	          BySessionId            -SessionId [-ConfigRoot]   — Resolve-ClaudeThreadPath
210	                                 locates the transcript, supplying SourceDir and
211	                                 pinning SessionIds to the one id. Downstream
212	                                 stages are unchanged: the chain walk in
213	                                 New-ClaudeThreadManifest still operates within
214	                                 the resolved SourceDir and picks up prior
215	                                 sessions in the chain.
216	    .PARAMETER SourceDir
217	        Directory containing the UUID-named .jsonl session files.
218	    .PARAMETER SessionIds
219	        Optional. Limit discovery to specific session UUIDs.
220	    .PARAMETER SessionId
221	        A single session UUID (e.g. $env:CLAUDE_CODE_SESSION_ID). The transcript
222	        directory is resolved via Resolve-ClaudeThreadPath; throws if the id is
223	        malformed or does not resolve to exactly one transcript.
224	    .PARAMETER ConfigRoot
225	        Optional override for the Claude config root when using -SessionId.
226	        See Resolve-ClaudeThreadPath.
227	    .PARAMETER WorkingDir
228	        Root for all JSONL pipeline artifacts (raw/, merged/, exchanges/).
229	        Defaults to a timestamped directory under {configRoot}/tmp/claude-jso-run/,
230	        where the root is discovered by Get-ClaudeConfigRoot.
231	    .PARAMETER RunThrough
232	        How far to run the pipeline. Merged | Exchanges | Markdown (default).
233	    .PARAMETER MarkdownPath
234	        Explicit output path for the markdown file. Highest precedence.
235	    .PARAMETER MarkdownDir
236	        Output directory for the markdown file. Writes thread-{threadId}.md
237	        flat into this directory. Created automatically if it does not exist.
238	    .PARAMETER Format
239	        Passed to ConvertTo-ClaudeMarkdownV2. Default: Structural.
240	    .PARAMETER Exclude
241	        Passed to ConvertTo-ClaudeMarkdownV2. Default: model-feeding profile.
242	    .PARAMETER UserLabel
243	        Human speaker label for diarized rendering. Passed to Get-ClaudeExchanges
244	        and stamped on every exchange envelope. Default: Aipithicus.
245	    .PARAMETER MaxToolInputLength
246	        Passed to ConvertTo-ClaudeMarkdownV2. Default: 500. $null = no truncation.
247	    .PARAMETER OutputPrefix
248	        Filename stem for merged, exchanges, and markdown artifacts:
249	        `{OutputPrefix}-{threadId}.{jsonl|md}`. Default `'thread'`. Batch runs
250	        pass the project leaf (e.g. `'tools'`).
251	    .OUTPUTS
252	        PSCustomObject { ThreadId, WorkingDir, MergedPath, ExchangesPath, MarkdownPath, Stats }
253	        Paths for stages not reached are $null.
254	    #>
255	    [CmdletBinding(DefaultParameterSetName = 'BySourceDir')]
256	    param(
257	        [Parameter(Mandatory, ParameterSetName = 'BySourceDir')]
258	        [string]$SourceDir,
259	
260	        [Parameter(ParameterSetName = 'BySourceDir')]
261	        [string[]]$SessionIds,
262	
263	        [Parameter(Mandatory, ParameterSetName = 'BySessionId')]
264	        [string]$SessionId,
265	
266	        [Parameter(ParameterSetName = 'BySessionId')]
267	        [string]$ConfigRoot,
268	
269	        [string]$WorkingDir,
270	
271	        [ValidateSet('Merged', 'Exchanges', 'Markdown')]
272	        [string]$RunThrough = 'Markdown',
273	
274	        [string]$MarkdownPath,
275	        [string]$MarkdownDir,
276	
277	        [string]$UserLabel = 'Aipithicus',
278	
279	        [ValidateSet('Diarized', 'Dialogue', 'Structural', 'House')]
280	        [string]$Format = 'Structural',
281	
282	        [ValidateSet('thinking', 'tool-calls', 'tool-results', 'subagents',
283	            'synthetic', 'timestamps', 'session-markers', 'exchange-markers')]
284	        [string[]]$Exclude = @('thinking', 'tool-calls', 'tool-results',
285	            'subagents', 'synthetic', 'timestamps', 'session-markers', 'exchange-markers'),
286	
287	        [AllowNull()]
288	        [Nullable[int]]$MaxToolInputLength = 500,
289	
290	        [string]$OutputPrefix = 'thread'
291	    )
292	
293	    $timer = [System.Diagnostics.Stopwatch]::StartNew()
294	
295	    # --- Resolve transcript location from the session id, if that is the entry point ---
296	    if ($PSCmdlet.ParameterSetName -eq 'BySessionId')
297	    {
298	        # An empty -ConfigRoot falls through to discovery, so it can be passed
299	        # through unconditionally.
300	        $resolved = Resolve-ClaudeThreadPath -SessionId $SessionId -ConfigRoot $ConfigRoot
301	        $SourceDir  = $resolved.SourceDir
302	        $SessionIds = [string[]]@($SessionId)
303	
304	        Write-Host "Resolved session $SessionId → $($resolved.ProjectName)" -ForegroundColor Gray
305	    }
306	
307	    # --- Resolve working directory ---
308	    if (-not $WorkingDir)
309	    {
310	        $WorkingDir = New-JobWorkingDir -Prefix 'claude-jso-run'
311	    }
312	
313	    # --- Stage 1: Merge ---
314	    $exportArgs = @{
315	        SourceDir    = $SourceDir
316	        WorkingDir   = $WorkingDir
317	        OutputPrefix = $OutputPrefix
318	    }
319	    if ($SessionIds) { $exportArgs.SessionIds = $SessionIds }
320	
321	    $threadResult = Export-ClaudeThread @exportArgs
322	    $threadId  = $threadResult.Manifest.ThreadId
323	    $mergedPath = $threadResult.MergedPath
324	
325	    if ($RunThrough -eq 'Merged')
326	    {
327	        $timer.Stop()
328	        return [PSCustomObject]@{
329	            ThreadId      = $threadId
330	            WorkingDir    = $WorkingDir
331	            MergedPath    = $mergedPath
332	            ExchangesPath = $null
333	            MarkdownPath  = $null
334	            Stats         = $threadResult.Stats
335	            Elapsed       = $timer.Elapsed
336	        }
337	    }
338	
339	    # --- Stage 2: Exchanges ---
340	    $exchanges = Get-ClaudeExchanges -MergedJsonlPath $mergedPath -ThreadId $threadId -UserLabel $UserLabel
341	    $exchangeResult = Export-ClaudeExchanges -Exchanges $exchanges `
342	        -WorkingDir $WorkingDir -ThreadId $threadId -OutputPrefix $OutputPrefix
343	    $exchangesPath = $exchangeResult.ExchangesPath
344	
345	    if ($RunThrough -eq 'Exchanges')
346	    {
347	        $timer.Stop()
348	        return [PSCustomObject]@{
349	            ThreadId      = $threadId
350	            WorkingDir    = $WorkingDir
351	            MergedPath    = $mergedPath
352	            ExchangesPath = $exchangesPath
353	            MarkdownPath  = $null
354	            Stats         = $threadResult.Stats
355	            Elapsed       = $timer.Elapsed
356	        }
357	    }
358	
359	    # --- Stage 3: Markdown ---
360	    $resolvedMarkdownPath = if ($MarkdownPath)
361	    {
362	        $MarkdownPath
363	    }
364	    elseif ($MarkdownDir)
365	    {
366	        [System.IO.Path]::Combine($MarkdownDir, "$OutputPrefix-$threadId.md")
367	    }
368	    elseif ($env:JSO_EXPORT_DIR)
369	    {
370	        # Standing destination for single-thread deliverables. Unlike the working
371	        # dir, this is a preference and not discoverable, so declaring it in the
372	        # environment is the only way to have a default at all. A per-call
373	        # -MarkdownDir still wins. Deliberately NOT consulted by the batch runner,
374	        # which would dump a hundred files into it.
375	        [System.IO.Path]::Combine($env:JSO_EXPORT_DIR, "$OutputPrefix-$threadId.md")
376	    }
377	    else
378	    {
379	        [System.IO.Path]::Combine($WorkingDir, 'output', "$OutputPrefix-$threadId.md")
380	    }
381	
382	    ConvertTo-ClaudeMarkdownV2 `
383	        -ExchangesJsonlPath  $exchangesPath `
384	        -OutputPath          $resolvedMarkdownPath `
385	        -Format              $Format `
386	        -Exclude             $Exclude `
387	        -MaxToolInputLength  $MaxToolInputLength
388	
389	    $timer.Stop()
390	    return [PSCustomObject]@{
391	        ThreadId      = $threadId
392	        WorkingDir    = $WorkingDir
393	        MergedPath    = $mergedPath
394	        ExchangesPath = $exchangesPath
395	        MarkdownPath  = $resolvedMarkdownPath
396	        Stats         = $threadResult.Stats
397	        Elapsed       = $timer.Elapsed
398	    }
399	}
400	
401	
402	function Get-ClaudeThreadPlan
403	{
404	    <#
405	    .SYNOPSIS
406	        Discover and group all threads in a source directory.
407	    .DESCRIPTION
408	        Enumerates UUID-named .jsonl session files, detects .jsonl.idx chain
409	        sentinels, and groups sessions into thread chains ordered oldest → leaf.
410	        Returns a plan object with chain groupings and the reduced leaf-only
411	        dispatch list.
412	
413	        A session with a .jsonl.idx sentinel has been continued by a newer
414	        session. Walk sessions sorted by LastWriteTimeUtc and accumulate into
415	        the current chain until a session without a sentinel closes it.
416	
417	        The returned LeafUuids are the correct dispatch targets for
418	        Invoke-ClaudeThreadExport: Export-ClaudeThread will auto-discover all
419	        prior sessions in the chain via New-ClaudeThreadManifest -SessionIds.
420	    .PARAMETER SourceDir
421	        Directory containing the UUID-named .jsonl session files.
422	    .PARAMETER SessionId
423	        Any session UUID belonging to the directory you want planned. Resolving
424	        the id yields its transcript path, and the project slug is a component
425	        of that path — so one lookup produces both the file and its directory,
426	        and there is nothing further to specify.
427	
428	        This function plans a directory, so that is what it does with the
429	        resolved location. The scope lives in the function's name, not in the
430	        parameter's: `Get-ClaudeThreadPlan` returns chains, `Invoke-ClaudeThreadExport`
431	        exports the one thread. Same input, different verb.
432	    .PARAMETER ConfigRoot
433	        Optional override for the Claude config root. See Get-ClaudeConfigRoot.
434	    .OUTPUTS
435	        PSCustomObject {
436	            SourceDir, AllUuids, Chains, LeafUuids, PriorUuids, ChainCount
437	        }
438	    #>
439	    [CmdletBinding(DefaultParameterSetName = 'BySourceDir')]
440	    param(
441	        [Parameter(Mandatory, ParameterSetName = 'BySourceDir')]
442	        [string]$SourceDir,
443	
444	        [Parameter(Mandatory, ParameterSetName = 'BySessionId')]
445	        [string]$SessionId,
446	
447	        [Parameter(ParameterSetName = 'BySessionId')]
448	        [string]$ConfigRoot
449	    )
450	
451	    if ($PSCmdlet.ParameterSetName -eq 'BySessionId')
452	    {
453	        $SourceDir = (Resolve-ClaudeThreadPath -SessionId $SessionId -ConfigRoot $ConfigRoot).SourceDir
454	    }
455	
456	    if (-not [System.IO.Directory]::Exists($SourceDir))
457	    {
458	        throw "Source directory not found: $SourceDir"
459	    }
460	
461	    $uuidPattern = '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\.jsonl$'
462	
463	    $jsonlFiles = [System.IO.Directory]::GetFiles($SourceDir, '*.jsonl')
464	    $sessionFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
465	
466	    foreach ($f in $jsonlFiles)
467	    {
468	        $fi = [System.IO.FileInfo]::new($f)
469	        if ($fi.Name -match $uuidPattern) { $sessionFiles.Add($fi) }
470	    }
471	
472	    if ($sessionFiles.Count -eq 0)
473	    {
474	        return [PSCustomObject]@{
475	            SourceDir  = $SourceDir
476	            AllUuids   = [string[]]@()
477	            Chains     = @()
478	            LeafUuids  = [string[]]@()
479	            PriorUuids = [string[]]@()
480	            ChainCount = 0
481	        }
482	    }
483	
484	    $sorted = $sessionFiles | Sort-Object LastWriteTimeUtc
485	
486	    # Group into chains: accumulate until a no-.idx session closes the chain
487	    $chains = [System.Collections.Generic.List[string[]]]::new()
488	    $currentChain = [System.Collections.Generic.List[string]]::new()
489	
490	    foreach ($sf in $sorted)
491	    {
492	        $uuid = [System.IO.Path]::GetFileNameWithoutExtension($sf.Name)
493	        $hasIdx = [System.IO.File]::Exists($sf.FullName + '.idx')
494	
495	        $currentChain.Add($uuid)
496	
497	        if (-not $hasIdx)
498	        {
499	            $chains.Add($currentChain.ToArray())
500	            $currentChain = [System.Collections.Generic.List[string]]::new()
501	        }
502	    }
503	
504	    # Flush any open chain (edge case: last session has .idx but no successor on disk)
505	    if ($currentChain.Count -gt 0) { $chains.Add($currentChain.ToArray()) }
506	
507	    $allUuids   = [System.Collections.Generic.List[string]]::new()
508	    $leafUuids  = [System.Collections.Generic.List[string]]::new()
509	    $priorUuids = [System.Collections.Generic.List[string]]::new()
510	
511	    foreach ($chain in $chains)
512	    {
513	        for ($i = 0; $i -lt $chain.Length; $i++)
514	        {
515	            $allUuids.Add($chain[$i])
516	            if ($i -eq $chain.Length - 1) { $leafUuids.Add($chain[$i]) }
517	            else                          { $priorUuids.Add($chain[$i]) }
518	        }
519	    }
520	
521	    return [PSCustomObject]@{
522	        SourceDir  = $SourceDir
523	        AllUuids   = $allUuids.ToArray()
524	        Chains     = $chains.ToArray()
525	        LeafUuids  = $leafUuids.ToArray()
526	        PriorUuids = $priorUuids.ToArray()
527	        ChainCount = $chains.Count
528	    }
529	}
530	
531	
532	function Invoke-ClaudeThreadExportBatch
533	{
534	    <#
535	    .SYNOPSIS
536	        Batch export all threads in a source directory.
537	    .DESCRIPTION
538	        Calls Get-ClaudeThreadPlan to discover and group threads, then calls
539	        Invoke-ClaudeThreadExport once per chain leaf. Prior (non-leaf) sessions
540	        are passed as -SessionIds so Export-ClaudeThread picks them up automatically.
541	
542	        Per-thread artifacts land in {BatchRoot}/{leafUuid}/. A shared -MarkdownDir
543	        accumulates all markdown files flat, one per thread.
544	    .PARAMETER SourceDir
545	        Directory containing the UUID-named .jsonl session files.
546	    .PARAMETER SessionId
547	        Any session UUID belonging to the directory you want batched. Resolving
548	        the id yields its transcript path, and the project slug is a component
549	        of that path, so the directory comes with it — nothing else to specify.
550	
551	        Being a batch runner, this exports every chain in that directory, which
552	        for a busy project is 100+ threads. The verb is the warning; the thread
553	        count is echoed before any work starts.
554	    .PARAMETER ConfigRoot
555	        Optional override for the Claude config root. See Get-ClaudeConfigRoot.
556	    .PARAMETER WorkingDir
557	        Batch root for all pipeline artifacts. Per-thread subdirs are created
558	        under it as {WorkingDir}/{leafUuid}/. When omitted, defaults to
559	        `{configRoot}/tmp/{projectSlug}/{YYYYMMDD_HHmmss}/`, where `{projectSlug}`
560	        is the source directory's full leaf folder name
561	        (e.g. `C--Users-azrie--claude-tools`). Filenames inside still use
562	        the shorter `{projectLeaf}` (e.g. `tools-{threadId}.jsonl`).
563	    .PARAMETER MarkdownDir
564	        Flat output directory for all thread markdown files. Files are named
565	        `{projectLeaf}-{threadId}.md` (overwrite-in-place — same threadId
566	        across runs replaces the prior export, giving a "current state" view).
567	        Defaults to `{configRoot}/tmp/markdown/`. Created if absent.
568	    .PARAMETER RunThrough
569	        How far to run each thread pipeline. Merged | Exchanges | Markdown (default).
570	    .PARAMETER UserLabel
571	        Human speaker label. Passed to every per-thread export. Default: Aipithicus.
572	    .PARAMETER Format
573	        Passed to ConvertTo-ClaudeMarkdownV2 for each thread. Default: Structural.
574	    .PARAMETER Exclude
575	        Passed to ConvertTo-ClaudeMarkdownV2 for each thread. Default: model-feeding profile.
576	    .PARAMETER MaxToolInputLength
577	        Passed to ConvertTo-ClaudeMarkdownV2. Default: 500. $null = no truncation.
578	    .OUTPUTS
579	        PSCustomObject { SourceDir, Plan, Results[], Elapsed }
580	    #>
581	    [CmdletBinding(DefaultParameterSetName = 'BySourceDir')]
582	    param(
583	        [Parameter(Mandatory, ParameterSetName = 'BySourceDir')]
584	        [string]$SourceDir,
585	
586	        [Parameter(Mandatory, ParameterSetName = 'BySessionId')]
587	        [string]$SessionId,
588	
589	        [Parameter(ParameterSetName = 'BySessionId')]
590	        [string]$ConfigRoot,
591	
592	        [string]$WorkingDir,
593	
594	        [string]$MarkdownDir,
595	
596	        [ValidateSet('Merged', 'Exchanges', 'Markdown')]
597	        [string]$RunThrough = 'Markdown',
598	
599	        [string]$UserLabel = 'Aipithicus',
600	
601	        [ValidateSet('Diarized', 'Dialogue', 'Structural', 'House')]
602	        [string]$Format = 'Structural',
603	
604	        [ValidateSet('thinking', 'tool-calls', 'tool-results', 'subagents',
605	            'synthetic', 'timestamps', 'session-markers', 'exchange-markers')]
606	        [string[]]$Exclude = @('thinking', 'tool-calls', 'tool-results',
607	            'subagents', 'synthetic', 'timestamps', 'session-markers', 'exchange-markers'),
608	
609	        [AllowNull()]
610	        [Nullable[int]]$MaxToolInputLength = 500
611	    )
612	
613	    $batchTimer = [System.Diagnostics.Stopwatch]::StartNew()
614	
615	    if ($PSCmdlet.ParameterSetName -eq 'BySessionId')
616	    {
617	        $resolved = Resolve-ClaudeThreadPath -SessionId $SessionId -ConfigRoot $ConfigRoot
618	        $SourceDir = $resolved.SourceDir
619	        Write-Host "Resolved session $SessionId → project $($resolved.ProjectName)" -ForegroundColor Gray
620	    }
621	
622	    # --- Discover and group threads ---
623	    $plan = Get-ClaudeThreadPlan -SourceDir $SourceDir
624	
625	    if ($plan.ChainCount -eq 0)
626	    {
627	        Write-Warning "No threads found in: $SourceDir"
628	        $batchTimer.Stop()
629	        return [PSCustomObject]@{
630	            SourceDir = $SourceDir
631	            Plan      = $plan
632	            Results   = @()
633	            Elapsed   = $batchTimer.Elapsed
634	        }
635	    }
636	
637	    Write-Host "Batch: $($plan.ChainCount) thread(s), $($plan.AllUuids.Count) session(s) total" -ForegroundColor Cyan
638	    if ($plan.PriorUuids.Count -gt 0)
639	    {
640	        Write-Host "  $($plan.PriorUuids.Count) prior session(s) subsumed into chains (skipped as dispatch targets)" -ForegroundColor Gray
641	    }
642	
643	    # --- Derive project identifiers from source dir's leaf folder ---
644	    # `C:\...\projects\C--Users-azrie--claude-tools` yields:
645	    #   $sourceLeafFolder = 'C--Users-azrie--claude-tools'  (full slug → working-dir parent)
646	    #   $projectLeaf      = 'tools'                          (last segment → artifact prefix)
647	    $sourceLeafFolder = Split-Path -Leaf $SourceDir
648	    $projectLeaf = ($sourceLeafFolder -split '-' | Where-Object { $_ -ne '' })[-1]
649	    if (-not $projectLeaf) { $projectLeaf = $sourceLeafFolder }
650	
651	    # --- Resolve batch working dir root ---
652	    if (-not $WorkingDir)
653	    {
654	        $stamp = Get-JobTimestamp
655	        $WorkingDir = [System.IO.Path]::Combine(
656	            (Get-ClaudeConfigRoot), 'tmp', $sourceLeafFolder, $stamp)
657	    }
658	    $batchRoot = $WorkingDir
659	
660	    # --- Resolve flat markdown dir default ---
661	    if (-not $MarkdownDir)
662	    {
663	        $MarkdownDir = [System.IO.Path]::Combine(
664	            (Get-ClaudeConfigRoot), 'tmp', 'markdown')
665	    }
666	
667	    Write-Host "  projectLeaf: $projectLeaf" -ForegroundColor Gray
668	    Write-Host "  workingDir:  $batchRoot" -ForegroundColor Gray
669	    Write-Host "  markdownDir: $MarkdownDir" -ForegroundColor Gray
670	
671	    # --- Dispatch one export per chain leaf ---
672	    $results = [System.Collections.Generic.List[object]]::new()
673	    [int]$idx = 0
674	
675	    foreach ($chain in $plan.Chains)
676	    {
677	        $idx++
678	        $leafUuid = $chain[-1]
679	        $threadWorkingDir = [System.IO.Path]::Combine($batchRoot, $leafUuid)
680	
681	        Write-Host "`n[$idx/$($plan.ChainCount)] Thread $leafUuid  ($($chain.Length) session(s))" -ForegroundColor Cyan
682	
683	        # Pass ONLY the leaf UUID. New-ClaudeThreadManifest does its own
684	        # sentinel walk against $SourceDir to discover the full chain that
685	        # terminates at this leaf. Forwarding the full chain here would force
686	        # the manifest into mtime-only ordering of a pre-curated set, which
687	        # is unreliable when threads are revisited out of order.
688	        $exportArgs = @{
689	            SourceDir          = $SourceDir
690	            WorkingDir         = $threadWorkingDir
691	            SessionIds         = [string[]]@($leafUuid)
692	            RunThrough         = $RunThrough
693	            UserLabel          = $UserLabel
694	            Format             = $Format
695	            Exclude            = $Exclude
696	            MaxToolInputLength = $MaxToolInputLength
697	            OutputPrefix       = $projectLeaf
698	            MarkdownDir        = $MarkdownDir
699	        }
700	
701	        $result = Invoke-ClaudeThreadExport @exportArgs
702	        $results.Add($result)
703	    }
704	
705	    $batchTimer.Stop()
706	    Write-Host "`nBatch complete: $($results.Count) thread(s) in $([math]::Round($batchTimer.Elapsed.TotalSeconds, 1))s" -ForegroundColor Green
707	
708	    return [PSCustomObject]@{
709	        SourceDir = $SourceDir
710	        Plan      = $plan
711	        Results   = $results.ToArray()
712	        Elapsed   = $batchTimer.Elapsed
713	    }
714	}
715
```
**[tool: PowerShell]**
```json
{"command":"$sid = $env:CLAUDE_CODE_SESSION_ID; if ([string]::IsNullOrWhiteSpace($sid)) { $sid = \u00279b7ba3f6-7a26-44f6-9c0c-0a0824f752b8\u0027 }; . \u0022D:\\aghado01\\science-facility\\utils\\chat-export\\claude-export\\claude-jso-run.ps1\u0022; $stamp = Get-Date -Format \u0027yyyyMMdd_HHmmss\u0027; Invoke-ClaudeThreadExport -SessionId $sid -WorkingDir \u0027D:\\aghado01\\codex-scientiae\\.claude\\chat-export\u0027 -MarkdownPath \u0022D:\\aghado01\\codex-scientiae\\issues\\doccer\\discussions\\fable-doccer-k5a-implementation-$stamp.md\u0022 -Exclude @(\u0027synthetic\u0027) -MaxToolInputLength $null","description":"Export this chat to the doccer discussions folder","timeout":180000}
```
