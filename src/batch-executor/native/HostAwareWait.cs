using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace CodexScientiae.BatchExecutor.Native;

public enum WaitSliceStatus
{
    AllCompleted = 0,
    SliceElapsed = 1,
    Cancelled = 2
}

/// <summary>
/// Bounded wait over already-running tasks. Intended to be called from the owning
/// PowerShell thread in short slices so host Stop() can land between waits.
/// Does not run PowerShell script on thread-pool threads.
/// </summary>
public static class HostAwareWait
{
    public static WaitSliceStatus Wait(
        IReadOnlyList<Task> tasks,
        TimeSpan slice,
        CancellationToken cancellationToken)
    {
        if (tasks is null || tasks.Count == 0)
        {
            return WaitSliceStatus.AllCompleted;
        }

        var incomplete = new List<Task>(tasks.Count);
        for (int i = 0; i < tasks.Count; i++)
        {
            Task task = tasks[i];
            if (task is not null && !task.IsCompleted)
            {
                incomplete.Add(task);
            }
        }

        if (incomplete.Count == 0)
        {
            return WaitSliceStatus.AllCompleted;
        }

        if (cancellationToken.IsCancellationRequested)
        {
            return WaitSliceStatus.Cancelled;
        }

        int milliseconds = ToWaitMilliseconds(slice);
        try
        {
            bool all = Task.WaitAll(incomplete.ToArray(), milliseconds, cancellationToken);
            if (all)
            {
                return WaitSliceStatus.AllCompleted;
            }

            return cancellationToken.IsCancellationRequested
                ? WaitSliceStatus.Cancelled
                : WaitSliceStatus.SliceElapsed;
        }
        catch (OperationCanceledException)
        {
            return WaitSliceStatus.Cancelled;
        }
        catch (AggregateException)
        {
            for (int i = 0; i < incomplete.Count; i++)
            {
                if (!incomplete[i].IsCompleted)
                {
                    return cancellationToken.IsCancellationRequested
                        ? WaitSliceStatus.Cancelled
                        : WaitSliceStatus.SliceElapsed;
                }
            }

            return WaitSliceStatus.AllCompleted;
        }
    }

    public static int ToWaitMilliseconds(TimeSpan slice)
    {
        if (slice <= TimeSpan.Zero)
        {
            return 0;
        }

        if (slice == Timeout.InfiniteTimeSpan)
        {
            return Timeout.Infinite;
        }

        double ms = slice.TotalMilliseconds;
        if (ms >= int.MaxValue)
        {
            return int.MaxValue;
        }

        return Math.Max(1, (int)ms);
    }
}
