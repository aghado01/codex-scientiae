using System;
using System.ComponentModel;
using System.Runtime.InteropServices;

namespace CodexScientiae.BatchExecutor.Native;

public sealed class WindowsJob : IDisposable
{
    private readonly SafeJobHandle _handle;
    private bool _disposed;

    private WindowsJob(SafeJobHandle handle)
    {
        _handle = handle;
    }

    public static WindowsJob Create()
    {
        if (!OperatingSystem.IsWindows())
        {
            throw new PlatformNotSupportedException("batch executor job-object containment requires Windows.");
        }

        IntPtr raw = NativeMethods.CreateJobObjectW(IntPtr.Zero, null);
        if (raw == IntPtr.Zero)
        {
            throw new Win32Exception(Marshal.GetLastWin32Error(), "CreateJobObjectW failed");
        }

        var handle = new SafeJobHandle(raw);
        var info = new NativeMethods.JOBOBJECT_EXTENDED_LIMIT_INFORMATION
        {
            BasicLimitInformation = new NativeMethods.JOBOBJECT_BASIC_LIMIT_INFORMATION
            {
                LimitFlags = NativeMethods.JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE
            }
        };

        if (!NativeMethods.SetInformationJobObject(
                handle,
                NativeMethods.JobObjectExtendedLimitInformation,
                ref info,
                Marshal.SizeOf<NativeMethods.JOBOBJECT_EXTENDED_LIMIT_INFORMATION>()))
        {
            int error = Marshal.GetLastWin32Error();
            handle.Dispose();
            throw new Win32Exception(error, "SetInformationJobObject failed");
        }

        return new WindowsJob(handle);
    }

    internal SafeJobHandle Handle => _handle;

    public bool Terminate(uint exitCode = 1)
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
        return NativeMethods.TerminateJobObject(_handle, exitCode);
    }

    public int[] GetProcessIds()
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
        const int bufferSize = 4096;
        IntPtr buffer = Marshal.AllocHGlobal(bufferSize);
        try
        {
            if (!NativeMethods.QueryInformationJobObject(
                    _handle,
                    NativeMethods.JobObjectBasicProcessIdList,
                    buffer,
                    bufferSize,
                    out _))
            {
                throw new Win32Exception(Marshal.GetLastWin32Error(), "QueryInformationJobObject failed");
            }

            int inList = Marshal.ReadInt32(buffer, 4);
            var ids = new int[Math.Max(0, inList)];
            int offset = 8;
            for (int i = 0; i < ids.Length; i++)
            {
                nint value = Marshal.ReadIntPtr(buffer, offset);
                ids[i] = (int)value;
                offset += IntPtr.Size;
            }

            return ids;
        }
        finally
        {
            Marshal.FreeHGlobal(buffer);
        }
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _disposed = true;
        _handle.Dispose();
    }
}
