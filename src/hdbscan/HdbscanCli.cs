using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace CodexSci.Hdbscan;

/// <summary>
/// Domain-agnostic command-line surface over <see cref="HdbscanRunner"/>: points in
/// (CSV or JSONL), labels + membership + dendrogram out. No domain assumptions — the
/// pdf-converter figure lane is the first consumer, not the owner. The entry-point
/// <c>Main</c> lives in the CLI project (projects/hdbscan); this class exposes only
/// <see cref="Run"/> so the same sources also compile into the smoke-test assembly
/// without a second entry point.
///
/// Serialization honors the archivory conventions WITHOUT vendoring the engine:
/// snake_case property naming, <see cref="JsonNumberHandling.AllowNamedFloatingPointLiterals"/>
/// (degenerate clusterings emit NaN/Infinity — default STJ throws), atomic .tmp+Move writes,
/// and RFC-4180 CSV field escaping. Every artifact is UTF-8 without BOM.
/// </summary>
public static class HdbscanCli
{
    /// <summary>Runs the CLI. Returns 0 on success, 1 on I/O or runtime error, 2 on usage error.</summary>
    public static int Run(string[] args)
    {
        try
        {
            if (args.Length == 0) { PrintUsage(Console.Error); return 2; }
            if (HasHelp(args))    { PrintUsage(Console.Out);  return 0; }

            Dictionary<string, string> cli = ParseArgs(args, out string? configPath);
            Settings settings = Settings.Resolve(cli, configPath);
            Dataset dataset   = DataLoader.Load(settings);
            HdbscanResult result = Cluster(dataset, settings);
            RunMeta paths = WriteOutputs(dataset, result, settings);

            int noise = CountNoise(result.Labels);
            Console.Error.WriteLine(
                $"hdbscan: {result.ClusterCount} cluster(s), {noise} noise point(s) of {dataset.N} → {settings.OutDir}");
            return 0;
        }
        catch (UsageException ue)
        {
            Console.Error.WriteLine("hdbscan: " + ue.Message);
            Console.Error.WriteLine("hdbscan: run with --help for usage.");
            return 2;
        }
        catch (Exception ex)
        {
            Console.Error.WriteLine("hdbscan: " + ex.Message);
            return 1;
        }
    }

    // ── Clustering ──────────────────────────────────────────────────────────────

    private static HdbscanResult Cluster(Dataset ds, Settings s)
    {
        if (ds.N < 2)
            throw new UsageException($"need at least 2 points, got {ds.N}.");
        if (s.MinPts > ds.N)
            throw new UsageException($"--min-pts ({s.MinPts}) exceeds point count ({ds.N}).");

        var runner = new HdbscanRunner(ds.N);
        return DispatchMetric(s.Metric, runner, ds.Data, ds.Dim, s.MinPts, s.MinClusterSize, s.AllowSingleCluster);
    }

    /// <summary>
    /// Parses the metric spec and dispatches to the matching struct so each
    /// <c>Run&lt;TMetric&gt;</c> stays JIT-inlined. An unknown metric fails loudly
    /// rather than silently defaulting to Euclidean.
    /// </summary>
    private static HdbscanResult DispatchMetric(
        string metricSpec, HdbscanRunner runner, ReadOnlySpan<double> data, int dim,
        int minPts, int minClusterSize, bool allowSingle)
    {
        string spec = metricSpec.Trim().ToLowerInvariant();

        if (spec.StartsWith("minkowski", StringComparison.Ordinal))
        {
            double p = ParseMinkowskiOrder(spec);
            return runner.Run(data, dim, minPts, new MinkowskiMetric(p), minClusterSize, allowSingle);
        }

        if (spec is "rectangle-gap" or "rect-gap" or "bbox-gap")
        {
            if ((dim & 1) != 0)
                throw new UsageException(
                    $"--distance-metric rectangle-gap needs even-length box vectors [x0,y0,x1,y1,…]; got dim {dim}.");
            return runner.Run(data, dim, minPts, new RectangleGapMetric(), minClusterSize, allowSingle);
        }

        return spec switch
        {
            "euclidean" or "l2"                    => runner.Run(data, dim, minPts, new EuclideanMetric(), minClusterSize, allowSingle),
            "manhattan" or "l1" or "cityblock"     => runner.Run(data, dim, minPts, new ManhattanMetric(), minClusterSize, allowSingle),
            "chebyshev" or "chebychev" or "linf"   => runner.Run(data, dim, minPts, new ChebyshevMetric(), minClusterSize, allowSingle),
            "cosine"                               => runner.Run(data, dim, minPts, new CosineMetric(), minClusterSize, allowSingle),
            "hamming"                              => runner.Run(data, dim, minPts, new HammingMetric(), minClusterSize, allowSingle),
            "poincare" or "poincaré"               => runner.Run(data, dim, minPts, new PoincareMetric(), minClusterSize, allowSingle),
            "hyperboloid" or "lorentz"             => runner.Run(data, dim, minPts, new HyperboloidMetric(), minClusterSize, allowSingle),
            _                                      => throw new UsageException($"unknown --distance-metric '{metricSpec}'."),
        };
    }

    private static double ParseMinkowskiOrder(string spec)
    {
        // Accept "minkowski", "minkowski:p=3", "minkowski:3".
        int colon = spec.IndexOf(':');
        if (colon < 0) return 2.0;
        string tail = spec[(colon + 1)..].Trim();
        if (tail.StartsWith("p=", StringComparison.Ordinal)) tail = tail[2..];
        if (!double.TryParse(tail, NumberStyles.Float, CultureInfo.InvariantCulture, out double p))
            throw new UsageException($"could not parse Minkowski order from '{spec}' (expected e.g. minkowski:p=3).");
        return p;
    }

    // ── Output ──────────────────────────────────────────────────────────────────

    private static RunMeta WriteOutputs(Dataset ds, HdbscanResult result, Settings s)
    {
        Directory.CreateDirectory(s.OutDir);
        string partitionPath  = Path.Combine(s.OutDir, "hdbscan_partition.csv");
        string dendrogramPath = Path.Combine(s.OutDir, "hdbscan_dendrogram.json");
        string summaryPath    = Path.Combine(s.OutDir, "summary.json");

        WritePartitionCsv(partitionPath, ds, result);
        WriteDendrogramJson(dendrogramPath, result.Dendrogram);

        var run = new RunMeta(s.OutDir, partitionPath, dendrogramPath, summaryPath);
        WriteSummaryJson(summaryPath, ds, result, s, run);
        return run;
    }

    private static void WritePartitionCsv(string path, Dataset ds, HdbscanResult result)
    {
        bool hasLabels = ds.Labels is not null;
        var sb = new StringBuilder();

        // Header
        for (int d = 0; d < ds.Dim; d++)
        {
            if (d > 0) sb.Append(',');
            sb.Append("feature_").Append(d.ToString(CultureInfo.InvariantCulture));
        }
        sb.Append(",label,membership_probability");
        if (hasLabels) sb.Append(",true_label");
        sb.Append('\n');

        // Rows (input order)
        for (int x = 0; x < ds.N; x++)
        {
            int baseIdx = x * ds.Dim;
            for (int d = 0; d < ds.Dim; d++)
            {
                if (d > 0) sb.Append(',');
                sb.Append(FormatDouble(ds.Data[baseIdx + d]));
            }
            sb.Append(',').Append(result.Labels[x].ToString(CultureInfo.InvariantCulture));
            sb.Append(',').Append(FormatDouble(result.MembershipProbabilities[x]));
            if (hasLabels) sb.Append(',').Append(CsvField(ds.Labels![x]));
            sb.Append('\n');
        }

        WriteAtomicText(path, sb.ToString());
    }

    private static void WriteDendrogramJson(string path, Dendrogram dendrogram)
    {
        var merges = new List<MergeJson>(dendrogram.Merges.Length);
        foreach (DendrogramNode m in dendrogram.Merges)
        {
            double lambda = m.Distance > 0.0 ? 1.0 / m.Distance : double.PositiveInfinity;
            merges.Add(new MergeJson(m.LeftChild, m.RightChild, m.Distance, m.Size, lambda));
        }
        var doc = new DendrogramJson(dendrogram.LeafCount, dendrogram.CostAxis, merges);
        WriteAtomicJson(path, doc);
    }

    private static void WriteSummaryJson(string path, Dataset ds, HdbscanResult result, Settings s, RunMeta run)
    {
        // Per-cluster aggregates.
        var sizes = new int[result.ClusterCount];
        var probSum = new double[result.ClusterCount];
        for (int x = 0; x < ds.N; x++)
        {
            int lbl = result.Labels[x];
            if (lbl >= 0)
            {
                sizes[lbl]++;
                probSum[lbl] += result.MembershipProbabilities[x];
            }
        }
        var clusters = new List<ClusterMeta>(result.ClusterCount);
        for (int c = 0; c < result.ClusterCount; c++)
        {
            double mean = sizes[c] > 0 ? probSum[c] / sizes[c] : 0.0;
            clusters.Add(new ClusterMeta(c, sizes[c], mean));
        }

        // External evaluators run whenever the input carried ground-truth labels.
        // Noise (label −1) is treated as its own cluster, matching sklearn.metrics.
        EvaluatorScores? evalScores = ds.Labels is not null
            ? ClusterEvaluators.Compute(EncodeLabels(ds.Labels), result.Labels)
            : null;

        var summary = new SummaryJson(
            Algorithm: "hdbscan",
            Dataset:   new DatasetMeta(ds.SourcePath, ds.N, ds.Dim, ds.Format),
            Hdbscan:   new HdbscanParams(s.MinPts, s.MinClusterSize, s.AllowSingleCluster, s.Metric),
            ReferenceLabels: ds.LabelSource,   // null when the input carried no labels
            Result:    new ResultMeta(
                           ClusterCount: result.ClusterCount,
                           NoiseCount:   CountNoise(result.Labels),
                           EvaluatorScores: evalScores,
                           Clusters:     clusters),
            Run:       run);

        WriteAtomicJson(path, summary);
    }

    /// <summary>Dense-encodes ground-truth label strings to ints (first-appearance order).</summary>
    private static int[] EncodeLabels(string[] labels)
    {
        var map = new Dictionary<string, int>(StringComparer.Ordinal);
        var outp = new int[labels.Length];
        for (int i = 0; i < labels.Length; i++)
        {
            if (!map.TryGetValue(labels[i], out int id)) { id = map.Count; map[labels[i]] = id; }
            outp[i] = id;
        }
        return outp;
    }

    private static int CountNoise(int[] labels)
    {
        int n = 0;
        for (int i = 0; i < labels.Length; i++)
            if (labels[i] < 0) n++;
        return n;
    }

    // ── Serialization conventions (inlined archivory) ───────────────────────────

    private static readonly JsonSerializerOptions JsonOpts = new()
    {
        WriteIndented        = true,
        PropertyNamingPolicy = JsonNamingPolicy.SnakeCaseLower,
        // REQUIRED: a degenerate clustering (coincident points, zero-variance column,
        // all-noise) yields lambda = 1/0 = Infinity in dendrogram.json. Default STJ throws.
        NumberHandling       = JsonNumberHandling.AllowNamedFloatingPointLiterals,
    };

    private static readonly UTF8Encoding Utf8NoBom = new(encoderShouldEmitUTF8Identifier: false);

    private static void WriteAtomicJson<T>(string path, T value)
    {
        string tmp = path + ".tmp";
        using (var fs = new FileStream(tmp, FileMode.Create, FileAccess.Write, FileShare.None))
            JsonSerializer.Serialize(fs, value, JsonOpts);
        File.Move(tmp, path, overwrite: true);
    }

    private static void WriteAtomicText(string path, string content)
    {
        string tmp = path + ".tmp";
        File.WriteAllText(tmp, content, Utf8NoBom);
        File.Move(tmp, path, overwrite: true);
    }

    private static string FormatDouble(double v) => v.ToString("R", CultureInfo.InvariantCulture);

    private static readonly char[] CsvSpecials = { ',', '"', '\r', '\n' };

    private static string CsvField(string s)
        => s.IndexOfAny(CsvSpecials) >= 0 ? "\"" + s.Replace("\"", "\"\"") + "\"" : s;

    // ── Argument parsing ────────────────────────────────────────────────────────

    private static bool HasHelp(string[] args)
    {
        foreach (string a in args)
            if (a == "-h" || a == "--help") return true;
        return false;
    }

    /// <summary>
    /// Parses argv into a canonical option map (kebab keys). Boolean flags map to
    /// "true"/"false"; value flags consume the next token. <c>--config</c> is returned
    /// separately so the preset loads first and explicit flags override it.
    /// </summary>
    private static Dictionary<string, string> ParseArgs(string[] args, out string? configPath)
    {
        configPath = null;
        var map = new Dictionary<string, string>(StringComparer.Ordinal);

        for (int i = 0; i < args.Length; i++)
        {
            string a = args[i];
            switch (a)
            {
                case "--in":                       map["in"] = Next(args, ref i, a); break;
                case "--out-dir":                  map["out-dir"] = Next(args, ref i, a); break;
                case "--min-pts":                  map["min-pts"] = Next(args, ref i, a); break;
                case "--min-cluster-size":         map["min-cluster-size"] = Next(args, ref i, a); break;
                case "--distance-metric":
                case "--metric":                   map["distance-metric"] = Next(args, ref i, a); break;
                case "--label-column":             map["label-column"] = Next(args, ref i, a); break;
                case "--delimiter":                map["delimiter"] = Next(args, ref i, a); break;
                case "--format":                   map["format"] = Next(args, ref i, a); break;
                case "--allow-single-cluster":     map["allow-single-cluster"] = "true"; break;
                case "--no-allow-single-cluster":  map["allow-single-cluster"] = "false"; break;
                case "--no-header":                map["no-header"] = "true"; break;
                case "--config":                   configPath = Next(args, ref i, a); break;
                default:
                    throw new UsageException($"unknown argument '{a}'.");
            }
        }
        return map;
    }

    private static string Next(string[] args, ref int i, string flag)
    {
        if (i + 1 >= args.Length)
            throw new UsageException($"{flag} requires a value.");
        return args[++i];
    }

    private static void PrintUsage(TextWriter w)
    {
        w.WriteLine(@"hdbscan — standalone HDBSCAN* clustering

USAGE
  hdbscan --in <points.csv|jsonl> --out-dir <dir> [options]

OPTIONS
  --in <path>                  Input points (CSV or JSONL; format sniffed from extension).
  --out-dir <dir>              Output directory (created if absent).
  --min-pts <int>              Core-distance smoothing / density (default 5).
  --min-cluster-size <int>     Minimum real-cluster size (default: --min-pts).
  --allow-single-cluster       Let the root be selected (default ON).
  --no-allow-single-cluster    Datasets with no real split return all-noise (sklearn default).
  --distance-metric <spec>     euclidean(default)|manhattan|chebyshev|cosine|minkowski:p=N|
                               hamming|poincare|hyperboloid|rectangle-gap.
                                 hamming        discrete/categorical features (exact-equality)
                                 poincare       hyperbolic, points in the open unit ball
                                 hyperboloid    hyperbolic, Lorentz model (x0 = time component)
                                 rectangle-gap  min gap between axis-aligned boxes, v=[x0,y0,x1,y1]
  --label-column <name|idx>    CSV ground-truth column → true_label + reference_labels.
  --delimiter <char|tab>       CSV delimiter (default: ',', or tab for .tsv).
  --no-header                  CSV has no header row.
  --format <csv|jsonl>         Override the sniffed input format.
  --config <preset.json>       JSON preset (snake_case keys); explicit flags override.
  -h, --help                   This message.

OUTPUTS (in --out-dir)
  hdbscan_partition.csv        feature_0..d, label, membership_probability[, true_label].
  hdbscan_dendrogram.json      { leaf_count, cost_axis, merges:[{left_child,right_child,distance,size,lambda}] }.
  summary.json                 params + result (cluster/noise counts, per-cluster sizes, run paths).
                               evaluator_scores (purity/nmi/ari/homogeneity/completeness/v_measure,
                               sklearn-compatible) is populated when the input carries labels.

EXIT  0 ok · 1 I/O or runtime error · 2 usage error.  stdout stays clean; status → stderr.");
    }

    // ── Settings ────────────────────────────────────────────────────────────────

    private sealed class Settings
    {
        public required string In;
        public required string OutDir;
        public int    MinPts;
        public int    MinClusterSize;
        public bool   AllowSingleCluster;
        public required string Metric;
        public string? LabelColumn;
        public char   Delimiter;
        public bool   HasHeader;
        public required string Format;   // "csv" | "jsonl"

        public static Settings Resolve(Dictionary<string, string> cli, string? configPath)
        {
            // Preset first (kebab-normalized keys), CLI overrides.
            var merged = new Dictionary<string, string>(StringComparer.Ordinal);
            if (configPath is not null)
                LoadPreset(configPath, merged);
            foreach (var kv in cli)
                merged[kv.Key] = kv.Value;

            string @in   = Require(merged, "in", "--in");
            string outDir = Require(merged, "out-dir", "--out-dir");

            string format = merged.TryGetValue("format", out var fmt)
                ? NormalizeFormat(fmt)
                : SniffFormat(@in);

            int minPts = GetInt(merged, "min-pts", 5);
            if (minPts < 2) throw new UsageException("--min-pts must be >= 2.");
            int minClusterSize = merged.ContainsKey("min-cluster-size")
                ? GetInt(merged, "min-cluster-size", minPts)
                : minPts;
            if (minClusterSize < 2) throw new UsageException("--min-cluster-size must be >= 2.");

            bool allowSingle = GetBool(merged, "allow-single-cluster", true);
            string metric = merged.TryGetValue("distance-metric", out var mv) ? mv : "euclidean";
            merged.TryGetValue("label-column", out var labelCol);

            bool hasHeader = !GetBool(merged, "no-header", false);
            char delim = ResolveDelimiter(merged, format, @in);

            return new Settings
            {
                In = @in, OutDir = outDir,
                MinPts = minPts, MinClusterSize = minClusterSize,
                AllowSingleCluster = allowSingle, Metric = metric,
                LabelColumn = labelCol, Delimiter = delim,
                HasHeader = hasHeader, Format = format,
            };
        }

        private static void LoadPreset(string path, Dictionary<string, string> into)
        {
            if (!File.Exists(path))
                throw new UsageException($"--config file not found: {path}");
            using JsonDocument doc = JsonDocument.Parse(File.ReadAllText(path, Encoding.UTF8));
            if (doc.RootElement.ValueKind != JsonValueKind.Object)
                throw new UsageException("--config must be a JSON object.");
            foreach (JsonProperty p in doc.RootElement.EnumerateObject())
            {
                string key = p.Name.Replace('_', '-');
                string val = p.Value.ValueKind switch
                {
                    JsonValueKind.True   => "true",
                    JsonValueKind.False  => "false",
                    JsonValueKind.String => p.Value.GetString() ?? "",
                    JsonValueKind.Number => p.Value.GetRawText(),
                    JsonValueKind.Null   => "",
                    _ => throw new UsageException($"--config key '{p.Name}' has an unsupported value type."),
                };
                into[key] = val;
            }
        }

        private static string Require(Dictionary<string, string> m, string key, string flag)
            => m.TryGetValue(key, out var v) && v.Length > 0 ? v : throw new UsageException($"{flag} is required.");

        private static int GetInt(Dictionary<string, string> m, string key, int fallback)
        {
            if (!m.TryGetValue(key, out var v)) return fallback;
            if (!int.TryParse(v, NumberStyles.Integer, CultureInfo.InvariantCulture, out int i))
                throw new UsageException($"--{key} must be an integer, got '{v}'.");
            return i;
        }

        private static bool GetBool(Dictionary<string, string> m, string key, bool fallback)
        {
            if (!m.TryGetValue(key, out var v)) return fallback;
            return v switch
            {
                "true" or "1" or "yes" or "on"  => true,
                "false" or "0" or "no" or "off" => false,
                _ => throw new UsageException($"--{key} must be a boolean, got '{v}'."),
            };
        }

        private static string NormalizeFormat(string fmt) => fmt.Trim().ToLowerInvariant() switch
        {
            "csv" or "tsv"            => "csv",
            "jsonl" or "ndjson" or "json" => "jsonl",
            _ => throw new UsageException($"--format must be csv or jsonl, got '{fmt}'."),
        };

        private static string SniffFormat(string path)
        {
            string ext = Path.GetExtension(path).ToLowerInvariant();
            return ext switch
            {
                ".jsonl" or ".ndjson" or ".json" => "jsonl",
                ".csv" or ".tsv" or ".txt" or "" => "csv",
                _ => "csv",   // default; --format overrides
            };
        }

        private static char ResolveDelimiter(Dictionary<string, string> m, string format, string path)
        {
            if (m.TryGetValue("delimiter", out var d))
            {
                if (d is "tab" or "\\t" or "\t") return '\t';
                if (d.Length == 1) return d[0];
                throw new UsageException($"--delimiter must be a single character or 'tab', got '{d}'.");
            }
            return Path.GetExtension(path).Equals(".tsv", StringComparison.OrdinalIgnoreCase) ? '\t' : ',';
        }
    }

    // ── Data loading ────────────────────────────────────────────────────────────

    private sealed class Dataset
    {
        public required double[] Data;   // row-major, length N * Dim
        public int N;
        public int Dim;
        public string[]? Ids;            // JSONL "id"; null otherwise
        public string[]? Labels;         // ground-truth strings; null when absent
        public required string Format;   // "csv" | "jsonl"
        public required string SourcePath;
        public string? LabelSource;      // e.g. "label-column:species" / "jsonl:label" / null
    }

    private static class DataLoader
    {
        public static Dataset Load(Settings s)
        {
            if (!File.Exists(s.In))
                throw new UsageException($"input not found: {s.In}");
            return s.Format == "jsonl" ? LoadJsonl(s) : LoadCsv(s);
        }

        private static Dataset LoadCsv(Settings s)
        {
            string[] lines = File.ReadAllLines(s.In, Encoding.UTF8);
            var rows = new List<double[]>();
            var labels = new List<string>();

            int labelIdx = -1;
            bool labelByName = false;
            string? labelName = null;
            bool headerConsumed = false;
            int dim = -1;

            for (int li = 0; li < lines.Length; li++)
            {
                string line = lines[li];
                if (line.Length == 0) continue;

                List<string> fields = SplitCsv(line, s.Delimiter);

                if (s.HasHeader && !headerConsumed)
                {
                    headerConsumed = true;
                    labelIdx = ResolveLabelColumn(s.LabelColumn, fields, out labelByName, out labelName);
                    continue;
                }

                if (labelIdx < 0 && s.LabelColumn is not null && !s.HasHeader)
                    labelIdx = ResolveLabelColumn(s.LabelColumn, fields, out labelByName, out labelName);

                var feats = new List<double>(fields.Count);
                string? rowLabel = null;
                for (int c = 0; c < fields.Count; c++)
                {
                    if (c == labelIdx) { rowLabel = fields[c]; continue; }
                    string cell = fields[c];
                    if (!double.TryParse(cell, NumberStyles.Float, CultureInfo.InvariantCulture, out double val))
                        throw new UsageException($"non-numeric feature '{cell}' at line {li + 1}, column {c}.");
                    feats.Add(val);
                }

                if (dim < 0) dim = feats.Count;
                else if (feats.Count != dim)
                    throw new UsageException($"inconsistent dimension at line {li + 1}: expected {dim}, got {feats.Count}.");

                rows.Add(feats.ToArray());
                if (labelIdx >= 0) labels.Add(rowLabel ?? "");
            }

            if (rows.Count == 0) throw new UsageException("no data rows found.");
            if (dim <= 0) throw new UsageException("no feature columns found (is the label column the only column?).");

            return Assemble(rows, dim, ids: null,
                labels: labelIdx >= 0 ? labels.ToArray() : null,
                format: "csv", source: s.In,
                labelSource: labelIdx >= 0 ? (labelByName ? $"label-column:{labelName}" : $"label-column:{labelIdx}") : null);
        }

        private static Dataset LoadJsonl(Settings s)
        {
            string[] lines = File.ReadAllLines(s.In, Encoding.UTF8);
            var rows = new List<double[]>();
            var ids = new List<string>();
            var labels = new List<string>();
            bool anyId = false, anyLabel = false;
            int dim = -1;

            for (int li = 0; li < lines.Length; li++)
            {
                string line = lines[li].Trim();
                if (line.Length == 0) continue;

                using JsonDocument doc = JsonDocument.Parse(line);
                JsonElement root = doc.RootElement;
                if (root.ValueKind != JsonValueKind.Object)
                    throw new UsageException($"line {li + 1}: expected a JSON object.");
                if (!root.TryGetProperty("v", out JsonElement v) || v.ValueKind != JsonValueKind.Array)
                    throw new UsageException($"line {li + 1}: missing numeric array field 'v'.");

                var feats = new List<double>();
                foreach (JsonElement e in v.EnumerateArray())
                    feats.Add(e.GetDouble());

                if (dim < 0) dim = feats.Count;
                else if (feats.Count != dim)
                    throw new UsageException($"line {li + 1}: inconsistent dimension, expected {dim}, got {feats.Count}.");

                rows.Add(feats.ToArray());

                if (root.TryGetProperty("id", out JsonElement idEl) && idEl.ValueKind == JsonValueKind.String)
                { ids.Add(idEl.GetString() ?? ""); anyId = true; }
                else ids.Add("");

                if (root.TryGetProperty("label", out JsonElement lblEl) && lblEl.ValueKind != JsonValueKind.Null)
                { labels.Add(lblEl.ToString()); anyLabel = true; }
                else labels.Add("");
            }

            if (rows.Count == 0) throw new UsageException("no data rows found.");

            return Assemble(rows, dim,
                ids: anyId ? ids.ToArray() : null,
                labels: anyLabel ? labels.ToArray() : null,
                format: "jsonl", source: s.In,
                labelSource: anyLabel ? "jsonl:label" : null);
        }

        private static Dataset Assemble(
            List<double[]> rows, int dim, string[]? ids, string[]? labels,
            string format, string source, string? labelSource)
        {
            int n = rows.Count;
            var data = new double[n * dim];
            for (int i = 0; i < n; i++)
                Array.Copy(rows[i], 0, data, i * dim, dim);
            return new Dataset
            {
                Data = data, N = n, Dim = dim,
                Ids = ids, Labels = labels,
                Format = format, SourcePath = source, LabelSource = labelSource,
            };
        }

        private static int ResolveLabelColumn(string? spec, List<string> fields, out bool byName, out string? name)
        {
            byName = false; name = null;
            if (spec is null) return -1;
            if (int.TryParse(spec, NumberStyles.Integer, CultureInfo.InvariantCulture, out int idx))
            {
                if (idx < 0 || idx >= fields.Count)
                    throw new UsageException($"--label-column index {idx} out of range (row has {fields.Count} columns).");
                return idx;
            }
            int found = fields.IndexOf(spec);
            if (found < 0)
                throw new UsageException($"--label-column '{spec}' not found in header (needs a header row).");
            byName = true; name = spec;
            return found;
        }

        private static List<string> SplitCsv(string line, char delim)
        {
            var fields = new List<string>();
            var sb = new StringBuilder();
            bool inQuotes = false;
            for (int i = 0; i < line.Length; i++)
            {
                char c = line[i];
                if (inQuotes)
                {
                    if (c == '"')
                    {
                        if (i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
                        else inQuotes = false;
                    }
                    else sb.Append(c);
                }
                else
                {
                    if (c == '"') inQuotes = true;
                    else if (c == delim) { fields.Add(sb.ToString()); sb.Clear(); }
                    else sb.Append(c);
                }
            }
            fields.Add(sb.ToString());
            return fields;
        }
    }

    // ── DTOs (snake_case via naming policy; no per-property attributes needed) ───

    private sealed record DendrogramJson(int LeafCount, string CostAxis, IReadOnlyList<MergeJson> Merges);
    private sealed record MergeJson(int LeftChild, int RightChild, double Distance, int Size, double Lambda);

    private sealed record SummaryJson(
        string Algorithm,
        DatasetMeta Dataset,
        HdbscanParams Hdbscan,
        string? ReferenceLabels,
        ResultMeta Result,
        RunMeta Run);

    private sealed record DatasetMeta(string Source, int PointCount, int Dimension, string Format);
    private sealed record HdbscanParams(int MinPts, int MinClusterSize, bool AllowSingleCluster, string Metric);
    private sealed record ResultMeta(
        int ClusterCount, int NoiseCount,
        EvaluatorScores? EvaluatorScores,
        IReadOnlyList<ClusterMeta> Clusters);
    private sealed record ClusterMeta(int Id, int Size, double MeanMembershipProbability);
    private sealed record RunMeta(string OutDir, string PartitionPath, string DendrogramPath, string SummaryPath);

    private sealed class UsageException : Exception
    {
        public UsageException(string message) : base(message) { }
    }
}
