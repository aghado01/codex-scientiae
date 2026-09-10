using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Pipes;
using System.Security.AccessControl;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace CodexScientiae.BatchExecutor.Native;

public static class ControlProtocol
{
    public const byte Version = 1;
    public const byte KindObject = 1;
    public const byte KindError = 2;
    public const byte KindWarning = 3;
    public const byte KindInformation = 4;
    public const byte KindFinal = 5;

    public static string KindName(byte kind)
    {
        return kind switch
        {
            KindObject => "obj",
            KindError => "err",
            KindWarning => "warn",
            KindInformation => "info",
            KindFinal => "final",
            _ => "unknown"
        };
    }

    public static byte KindFromName(string name)
    {
        return name switch
        {
            "obj" => KindObject,
            "err" => KindError,
            "warn" => KindWarning,
            "info" => KindInformation,
            "final" => KindFinal,
            _ => 0
        };
    }
}

public sealed class ControlFrame
{
    public byte Kind { get; init; }

    public string KindName { get; init; } = "unknown";

    public byte[] Payload { get; init; } = Array.Empty<byte>();

    public string PayloadText => Encoding.UTF8.GetString(Payload);
}

public sealed class ControlReadResult
{
    public List<ControlFrame> Frames { get; } = new();

    public ControlFrame? Final { get; set; }

    public bool EndOfStream { get; set; }

    public bool Malformed { get; set; }

    public bool Truncated { get; set; }

    public long Bytes { get; set; }

    public string? Failure { get; set; }
}

public sealed class ControlServer : IDisposable
{
    private readonly NamedPipeServerStream _pipe;
    private readonly CaptureLimits _limits;
    private bool _disposed;

    private ControlServer(NamedPipeServerStream pipe, string pipeName, CaptureLimits limits)
    {
        _pipe = pipe;
        PipeName = pipeName;
        _limits = limits;
    }

    public string PipeName { get; }

    public static ControlServer Create(string pipeName, CaptureLimits limits)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(pipeName);
        ArgumentNullException.ThrowIfNull(limits);
        if (!OperatingSystem.IsWindows())
        {
            throw new PlatformNotSupportedException("batch executor control pipes require Windows.");
        }

        var security = new PipeSecurity();
        SecurityIdentifier user = WindowsIdentity.GetCurrent().User
            ?? throw new InvalidOperationException("cannot ACL the control pipe without a user SID");
        security.AddAccessRule(new PipeAccessRule(user, PipeAccessRights.FullControl, AccessControlType.Allow));
        NamedPipeServerStream pipe = NamedPipeServerStreamAcl.Create(
            pipeName,
            PipeDirection.In,
            1,
            PipeTransmissionMode.Byte,
            PipeOptions.Asynchronous,
            inBufferSize: 0,
            outBufferSize: 0,
            security);
        return new ControlServer(pipe, pipeName, limits);
    }

    public Task WaitForConnectionAsync(CancellationToken cancellationToken)
    {
        return _pipe.WaitForConnectionAsync(cancellationToken);
    }

    public async Task<ControlReadResult> ReadToEndAsync(CancellationToken cancellationToken)
    {
        var result = new ControlReadResult();
        var header = new byte[5];
        try
        {
            while (true)
            {
                int headerRead = await ReadExactAsync(_pipe, header, 0, 5, cancellationToken, allowEof: true)
                    .ConfigureAwait(false);
                if (headerRead == 0)
                {
                    result.EndOfStream = true;
                    break;
                }

                if (headerRead < 5)
                {
                    result.Malformed = true;
                    result.Failure = "truncated control-frame header";
                    break;
                }

                int payloadLength = BitConverter.ToInt32(header, 0);
                byte kind = header[4];
                if (payloadLength < 0 || payloadLength > _limits.MaxFrameBytes)
                {
                    result.Malformed = true;
                    result.Failure = "control-frame length " + payloadLength + " exceeds max frame size";
                    break;
                }

                long nextBytes = result.Bytes + 5 + payloadLength;
                if (nextBytes > _limits.MaxProtocolBytes)
                {
                    result.Truncated = true;
                    await DrainAsync(_pipe, cancellationToken).ConfigureAwait(false);
                    result.EndOfStream = true;
                    break;
                }

                var payload = payloadLength == 0 ? Array.Empty<byte>() : new byte[payloadLength];
                if (payloadLength > 0)
                {
                    int bodyRead = await ReadExactAsync(_pipe, payload, 0, payloadLength, cancellationToken, allowEof: false)
                        .ConfigureAwait(false);
                    if (bodyRead < payloadLength)
                    {
                        result.Malformed = true;
                        result.Failure = "truncated control-frame payload";
                        break;
                    }
                }

                result.Bytes = nextBytes;
                var frame = new ControlFrame
                {
                    Kind = kind,
                    KindName = ControlProtocol.KindName(kind),
                    Payload = payload
                };
                result.Frames.Add(frame);
                if (kind == ControlProtocol.KindFinal)
                {
                    result.Final = frame;
                }
            }
        }
        catch (OperationCanceledException)
        {
            result.Failure = "control-channel read cancelled";
            throw;
        }
        catch (Exception exception)
        {
            result.Malformed = true;
            result.Failure = exception.Message;
        }

        return result;
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        _pipe.Dispose();
    }

    private static async Task<int> ReadExactAsync(
        Stream stream,
        byte[] buffer,
        int offset,
        int count,
        CancellationToken cancellationToken,
        bool allowEof)
    {
        int total = 0;
        while (total < count)
        {
            int read = await stream.ReadAsync(buffer.AsMemory(offset + total, count - total), cancellationToken)
                .ConfigureAwait(false);
            if (read == 0)
            {
                return allowEof ? total : total;
            }

            total += read;
        }

        return total;
    }

    private static async Task DrainAsync(Stream stream, CancellationToken cancellationToken)
    {
        var buffer = new byte[8192];
        while (true)
        {
            int read = await stream.ReadAsync(buffer.AsMemory(), cancellationToken).ConfigureAwait(false);
            if (read == 0)
            {
                return;
            }
        }
    }
}
