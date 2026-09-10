using System;
using System.IO;
using System.Text;
using System.Text.Unicode;
using System.Threading;
using System.Threading.Tasks;

namespace CodexScientiae.BatchExecutor.Native;

public sealed class CaptureLimits
{
    public const long DefaultStreamBytes = 8L * 1024 * 1024;
    public const long DefaultProtocolBytes = 16L * 1024 * 1024;
    public const int DefaultFrameBytes = 1024 * 1024;

    public long MaxStdOutBytes { get; init; } = DefaultStreamBytes;

    public long MaxStdErrBytes { get; init; } = DefaultStreamBytes;

    public long MaxProtocolBytes { get; init; } = DefaultProtocolBytes;

    public int MaxFrameBytes { get; init; } = DefaultFrameBytes;

    public CaptureLimits()
    {
    }

    public CaptureLimits(long maxStdOutBytes, long maxStdErrBytes, long maxProtocolBytes, int maxFrameBytes)
    {
        MaxStdOutBytes = maxStdOutBytes;
        MaxStdErrBytes = maxStdErrBytes;
        MaxProtocolBytes = maxProtocolBytes;
        MaxFrameBytes = maxFrameBytes;
    }
}

public sealed class BoundedCapture
{
    private readonly long _maxBytes;
    private readonly MemoryStream _buffer = new();

    public BoundedCapture(long maxBytes)
    {
        if (maxBytes < 1)
        {
            throw new ArgumentOutOfRangeException(nameof(maxBytes));
        }

        _maxBytes = maxBytes;
    }

    public bool Truncated { get; private set; }

    public bool EndOfStream { get; set; }

    public long Bytes => _buffer.Length;

    public void Add(ReadOnlySpan<byte> data)
    {
        if (Truncated || data.Length == 0)
        {
            return;
        }

        long room = _maxBytes - _buffer.Length;
        if (data.Length <= room)
        {
            _buffer.Write(data);
            return;
        }

        if (room > 0)
        {
            _buffer.Write(data[..(int)room]);
        }

        Truncated = true;
    }

    public byte[] ToArray()
    {
        return _buffer.ToArray();
    }

    public static string[] DecodeLines(byte[] data, out bool lossy)
    {
        lossy = data.Length > 0 && !Utf8.IsValid(data);
        string text = Encoding.UTF8.GetString(data);
        if (text.Length == 0)
        {
            return Array.Empty<string>();
        }

        string[] raw = text.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
        int count = 0;
        for (int i = 0; i < raw.Length; i++)
        {
            if (i == raw.Length - 1 && raw[i].Length == 0)
            {
                continue;
            }

            if (raw[i].Length > 0)
            {
                raw[count++] = raw[i];
            }
        }

        if (count == raw.Length)
        {
            return raw;
        }

        var trimmed = new string[count];
        Array.Copy(raw, trimmed, count);
        return trimmed;
    }
}

public static class StreamPump
{
    public static async Task PumpAsync(
        Stream source,
        BoundedCapture destination,
        CancellationToken cancellationToken)
    {
        var buffer = new byte[8192];
        while (true)
        {
            int read = await source.ReadAsync(buffer.AsMemory(0, buffer.Length), cancellationToken)
                .ConfigureAwait(false);
            if (read == 0)
            {
                destination.EndOfStream = true;
                return;
            }

            if (destination.Truncated)
            {
                continue;
            }

            destination.Add(buffer.AsSpan(0, read));
        }
    }
}
