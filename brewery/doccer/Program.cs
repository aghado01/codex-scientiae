using System;
using System.IO;
using System.Text.Json;
using CodexSci.Doccer;

return Run(args);

static int Run(string[] args)
{
    if (args.Length == 0 || args[0] is "-h" or "--help")
    {
        Console.WriteLine("doccer inspect <text-file>");
        Console.WriteLine("doccer relate <a-start> <a-end> <b-start> <b-end>");
        return 0;
    }

    try
    {
        return args[0] switch
        {
            "inspect" => Inspect(args),
            "relate" => Relate(args),
            _ => throw new ArgumentException($"Unknown command '{args[0]}'."),
        };
    }
    catch (Exception exception)
    {
        Console.Error.WriteLine($"doccer: {exception.Message}");
        return 2;
    }
}

static int Inspect(string[] args)
{
    if (args.Length != 2)
    {
        throw new ArgumentException("Usage: doccer inspect <text-file>");
    }

    var path = Path.GetFullPath(args[1]);
    var master = new TextMaster(path, 0, File.ReadAllText(path));
    var report = new
    {
        document_id = master.DocumentId,
        revision = master.Revision,
        address_unit = "utf16-code-unit",
        utf16_length = master.Length,
        scalar_atoms = master.Topology.AtomCount,
        lines = master.Topology.LineCount,
        fingerprint = master.Fingerprint,
    };

    Console.WriteLine(JsonSerializer.Serialize(report, new JsonSerializerOptions { WriteIndented = true }));
    return 0;
}

static int Relate(string[] args)
{
    if (args.Length != 5 ||
        !int.TryParse(args[1], out var aStart) ||
        !int.TryParse(args[2], out var aEnd) ||
        !int.TryParse(args[3], out var bStart) ||
        !int.TryParse(args[4], out var bEnd))
    {
        throw new ArgumentException("Usage: doccer relate <a-start> <a-end> <b-start> <b-end>");
    }

    Console.WriteLine(AllenAlgebra.Relate(new TextSpan(aStart, aEnd), new TextSpan(bStart, bEnd)));
    return 0;
}
