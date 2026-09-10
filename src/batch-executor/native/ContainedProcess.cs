using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Win32.SafeHandles;

namespace CodexScientiae.BatchExecutor.Native;

public sealed class ContainedProcessStartInfo
{
    public string FileName { get; set; } = string.Empty;

    public string WorkingDirectory { get; set; } = string.Empty;

    public List<string> Arguments { get; } = new();

    public Dictionary<string, string?> Environment { get; } =
        new(StringComparer.OrdinalIgnoreCase);

    public bool CreateNoWindow { get; set; } = true;

    public string WindowStyle { get; set; } = "Hidden";
}

public sealed class ContainedProcess : IDisposable
{
    private readonly SafeProcessHandleOwned _processHandle;
    private readonly WindowsJob _job;
    private readonly FileStream _stdin;
    private readonly FileStream _stdout;
    private readonly FileStream _stderr;
    private int? _exitCode;
    private bool _disposed;

    private ContainedProcess(
        int id,
        SafeProcessHandleOwned processHandle,
        WindowsJob job,
        FileStream stdin,
        FileStream stdout,
        FileStream stderr)
    {
        Id = id;
        _processHandle = processHandle;
        _job = job;
        _stdin = stdin;
        _stdout = stdout;
        _stderr = stderr;
    }

    public int Id { get; }

    public WindowsJob Job => _job;

    public Stream StandardInput => _stdin;

    public Stream StandardOutput => _stdout;

    public Stream StandardError => _stderr;

    public bool HasExited
    {
        get
        {
            if (_exitCode is not null)
            {
                return true;
            }

            if (!NativeMethods.GetExitCodeProcess(_processHandle.DangerousGetHandle(), out uint code))
            {
                return false;
            }

            if (code == NativeMethods.STILL_ACTIVE)
            {
                return false;
            }

            _exitCode = unchecked((int)code);
            return true;
        }
    }

    public int? ExitCode => HasExited ? _exitCode : null;

    public bool ConfirmedRelease => HasExited && !JobHasLiveProcesses();

    public static ContainedProcess Start(ContainedProcessStartInfo startInfo)
    {
        if (!OperatingSystem.IsWindows())
        {
            throw new PlatformNotSupportedException("batch executor contained processes require Windows.");
        }

        ArgumentNullException.ThrowIfNull(startInfo);
        if (string.IsNullOrWhiteSpace(startInfo.FileName))
        {
            throw new ArgumentException("FileName is required.", nameof(startInfo));
        }

        WindowsJob job = WindowsJob.Create();
        IntPtr stdinRead = IntPtr.Zero;
        IntPtr stdinWrite = IntPtr.Zero;
        IntPtr stdoutRead = IntPtr.Zero;
        IntPtr stdoutWrite = IntPtr.Zero;
        IntPtr stderrRead = IntPtr.Zero;
        IntPtr stderrWrite = IntPtr.Zero;
        IntPtr environment = IntPtr.Zero;
        NativeMethods.PROCESS_INFORMATION processInfo = default;
        bool processCreated = false;
        bool transferred = false;
        try
        {
            CreateInheritablePipe(out stdinRead, out stdinWrite, parentHoldsWrite: true);
            CreateInheritablePipe(out stdoutRead, out stdoutWrite, parentHoldsWrite: false);
            CreateInheritablePipe(out stderrRead, out stderrWrite, parentHoldsWrite: false);

            var startup = new NativeMethods.STARTUPINFO
            {
                cb = Marshal.SizeOf<NativeMethods.STARTUPINFO>(),
                dwFlags = NativeMethods.STARTF_USESTDHANDLES | NativeMethods.STARTF_USESHOWWINDOW,
                hStdInput = stdinRead,
                hStdOutput = stdoutWrite,
                hStdError = stderrWrite,
                wShowWindow = MapWindowStyle(startInfo.WindowStyle, startInfo.CreateNoWindow)
            };

            uint flags = NativeMethods.CREATE_SUSPENDED | NativeMethods.CREATE_UNICODE_ENVIRONMENT;
            if (startInfo.CreateNoWindow)
            {
                flags |= NativeMethods.CREATE_NO_WINDOW;
            }

            string commandLine = BuildCommandLine(startInfo.FileName, startInfo.Arguments);
            environment = BuildEnvironmentBlock(startInfo.Environment);
            string? directory = string.IsNullOrWhiteSpace(startInfo.WorkingDirectory)
                ? null
                : startInfo.WorkingDirectory;

            if (!NativeMethods.CreateProcessW(
                    startInfo.FileName,
                    commandLine,
                    IntPtr.Zero,
                    IntPtr.Zero,
                    bInheritHandles: true,
                    flags,
                    environment,
                    directory,
                    ref startup,
                    out processInfo))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "CreateProcessW failed");
            }

            processCreated = true;
            NativeMethods.CloseHandle(stdinRead);
            stdinRead = IntPtr.Zero;
            NativeMethods.CloseHandle(stdoutWrite);
            stdoutWrite = IntPtr.Zero;
            NativeMethods.CloseHandle(stderrWrite);
            stderrWrite = IntPtr.Zero;

            if (!NativeMethods.AssignProcessToJobObject(job.Handle, processInfo.hProcess))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "AssignProcessToJobObject failed");
            }

            if (NativeMethods.ResumeThread(processInfo.hThread) == uint.MaxValue)
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "ResumeThread failed");
            }

            NativeMethods.CloseHandle(processInfo.hThread);
            processInfo.hThread = IntPtr.Zero;

            var processHandle = new SafeProcessHandleOwned(processInfo.hProcess);
            processInfo.hProcess = IntPtr.Zero;
            var stdin = new FileStream(new SafeFileHandle(stdinWrite, ownsHandle: true), FileAccess.Write);
            stdinWrite = IntPtr.Zero;
            var stdout = new FileStream(new SafeFileHandle(stdoutRead, ownsHandle: true), FileAccess.Read);
            stdoutRead = IntPtr.Zero;
            var stderr = new FileStream(new SafeFileHandle(stderrRead, ownsHandle: true), FileAccess.Read);
            stderrRead = IntPtr.Zero;
            transferred = true;
            return new ContainedProcess(processInfo.dwProcessId, processHandle, job, stdin, stdout, stderr);
        }
        catch
        {
            if (processCreated)
            {
                NativeMethods.TerminateJobObject(job.Handle, 1);
            }

            job.Dispose();
            throw;
        }
        finally
        {
            if (environment != IntPtr.Zero)
            {
                Marshal.FreeHGlobal(environment);
            }

            if (processCreated && !transferred)
            {
                CloseIfSet(processInfo.hProcess);
                CloseIfSet(processInfo.hThread);
            }

            CloseIfSet(stdinRead);
            CloseIfSet(stdinWrite);
            CloseIfSet(stdoutRead);
            CloseIfSet(stdoutWrite);
            CloseIfSet(stderrRead);
            CloseIfSet(stderrWrite);
        }
    }

    public void SetPriorityClass(string priorityClass)
    {
        if (string.IsNullOrWhiteSpace(priorityClass) ||
            string.Equals(priorityClass, "Normal", StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        try
        {
            using Process process = Process.GetProcessById(Id);
            process.PriorityClass = Enum.Parse<ProcessPriorityClass>(priorityClass, ignoreCase: true);
        }
        catch (Exception)
        {
            // Priority is advisory; caller records a warning.
            throw;
        }
    }

    public Task WaitForExitAsync(CancellationToken cancellationToken)
    {
        if (HasExited)
        {
            return Task.CompletedTask;
        }

        return WaitUsingProcessHandleAsync(cancellationToken);
    }

    public bool Terminate(TimeSpan wait)
    {
        _job.Terminate(1);
        uint milliseconds = wait <= TimeSpan.Zero
            ? 0
            : wait == Timeout.InfiniteTimeSpan
                ? NativeMethods.INFINITE
                : (uint)Math.Min(int.MaxValue, Math.Max(0, (int)wait.TotalMilliseconds));
        NativeMethods.WaitForSingleObject(_processHandle.DangerousGetHandle(), milliseconds);
        if (milliseconds == NativeMethods.INFINITE)
        {
            while (JobHasLiveProcesses())
            {
                Thread.Sleep(20);
            }
        }
        else if (milliseconds > 0)
        {
            var remaining = TimeSpan.FromMilliseconds(milliseconds);
            var watch = Stopwatch.StartNew();
            while (JobHasLiveProcesses() && watch.Elapsed < remaining)
            {
                Thread.Sleep(20);
            }
        }

        return HasExited && !JobHasLiveProcesses();
    }

    private bool JobHasLiveProcesses()
    {
        try
        {
            return _job.GetProcessIds().Length > 0;
        }
        catch
        {
            return !HasExited;
        }
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        _stdin.Dispose();
        _stdout.Dispose();
        _stderr.Dispose();
        _processHandle.Dispose();
        _job.Dispose();
    }

    private Task WaitUsingProcessHandleAsync(CancellationToken cancellationToken)
    {
        var tcs = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        if (!NativeMethods.DuplicateHandle(
                NativeMethods.GetCurrentProcess(),
                _processHandle.DangerousGetHandle(),
                NativeMethods.GetCurrentProcess(),
                out IntPtr duplicated,
                0,
                false,
                NativeMethods.DUPLICATE_SAME_ACCESS))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "DuplicateHandle failed");
        }

        var waitHandle = new ProcessWaitHandle(duplicated);
        RegisteredWaitHandle? registration = null;
        CancellationTokenRegistration cancellation = default;
        registration = ThreadPool.RegisterWaitForSingleObject(
            waitHandle,
            (_, _) =>
            {
                tcs.TrySetResult();
                registration?.Unregister(null);
                waitHandle.Dispose();
                cancellation.Dispose();
            },
            null,
            -1,
            executeOnlyOnce: true);
        cancellation = cancellationToken.Register(() =>
        {
            tcs.TrySetCanceled(cancellationToken);
            registration?.Unregister(null);
            waitHandle.Dispose();
        });
        if (cancellationToken.IsCancellationRequested)
        {
            tcs.TrySetCanceled(cancellationToken);
        }

        return tcs.Task;
    }

    private static void CreateInheritablePipe(out IntPtr read, out IntPtr write, bool parentHoldsWrite)
    {
        var security = new NativeMethods.SECURITY_ATTRIBUTES
        {
            nLength = Marshal.SizeOf<NativeMethods.SECURITY_ATTRIBUTES>(),
            bInheritHandle = true
        };

        if (!NativeMethods.CreatePipe(out read, out write, ref security, 0))
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "CreatePipe failed");
        }

        IntPtr parentEnd = parentHoldsWrite ? write : read;
        if (!NativeMethods.SetHandleInformation(parentEnd, NativeMethods.HANDLE_FLAG_INHERIT, 0))
        {
            int error = Marshal.GetLastWin32Error();
            NativeMethods.CloseHandle(read);
            NativeMethods.CloseHandle(write);
            throw new Win32Exception(error, "SetHandleInformation failed");
        }
    }

    private static string BuildCommandLine(string fileName, IList<string> arguments)
    {
        var builder = new StringBuilder();
        builder.Append(QuoteArgument(fileName));
        foreach (string argument in arguments)
        {
            builder.Append(' ');
            builder.Append(QuoteArgument(argument));
        }

        return builder.ToString();
    }

    private static string QuoteArgument(string argument)
    {
        if (argument.Length > 0 && argument.IndexOfAny(new[] { ' ', '\t', '\n', '\v', '"' }) < 0)
        {
            return argument;
        }

        var builder = new StringBuilder();
        builder.Append('"');
        int backslashes = 0;
        foreach (char c in argument)
        {
            if (c == '\\')
            {
                backslashes++;
                continue;
            }

            if (c == '"')
            {
                builder.Append('\\', (backslashes * 2) + 1);
                builder.Append('"');
                backslashes = 0;
                continue;
            }

            builder.Append('\\', backslashes);
            builder.Append(c);
            backslashes = 0;
        }

        builder.Append('\\', backslashes * 2);
        builder.Append('"');
        return builder.ToString();
    }

    private static IntPtr BuildEnvironmentBlock(IDictionary<string, string?> overrides)
    {
        var env = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        foreach (DictionaryEntry entry in System.Environment.GetEnvironmentVariables())
        {
            env[(string)entry.Key!] = (string)entry.Value!;
        }

        foreach (KeyValuePair<string, string?> pair in overrides)
        {
            if (pair.Value is null)
            {
                env.Remove(pair.Key);
            }
            else
            {
                env[pair.Key] = pair.Value;
            }
        }

        var builder = new StringBuilder();
        foreach (KeyValuePair<string, string> pair in env.OrderBy(p => p.Key, StringComparer.OrdinalIgnoreCase))
        {
            builder.Append(pair.Key).Append('=').Append(pair.Value).Append('\0');
        }

        builder.Append('\0');
        byte[] bytes = Encoding.Unicode.GetBytes(builder.ToString());
        IntPtr pointer = Marshal.AllocHGlobal(bytes.Length);
        Marshal.Copy(bytes, 0, pointer, bytes.Length);
        return pointer;
    }

    private static ushort MapWindowStyle(string windowStyle, bool createNoWindow)
    {
        if (createNoWindow)
        {
            return NativeMethods.SW_HIDE;
        }

        return windowStyle switch
        {
            "Normal" => NativeMethods.SW_SHOWNORMAL,
            "Minimized" => NativeMethods.SW_SHOWMINIMIZED,
            "Maximized" => NativeMethods.SW_SHOWMAXIMIZED,
            _ => NativeMethods.SW_HIDE
        };
    }

    private static void CloseIfSet(IntPtr handle)
    {
        if (handle != IntPtr.Zero)
        {
            NativeMethods.CloseHandle(handle);
        }
    }

    private sealed class ProcessWaitHandle : WaitHandle
    {
        public ProcessWaitHandle(IntPtr handle)
        {
            SafeWaitHandle = new SafeWaitHandle(handle, ownsHandle: true);
        }
    }
}
