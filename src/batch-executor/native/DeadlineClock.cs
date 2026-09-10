using System;
using System.Threading;

namespace CodexScientiae.BatchExecutor.Native;

/// <summary>
/// Monotonic remaining-budget clock. A null or non-positive budget is unlimited.
/// Wait and cleanup clocks start only when the corresponding phase begins; the
/// execution clock starts at construction (executor admission).
/// </summary>
public sealed class DeadlineClock
{
    private readonly TimeProvider _time;
    private readonly long _admission;
    private readonly long? _executionTicks;
    private readonly long? _waitTicks;
    private readonly long? _cleanupTicks;
    private long? _waitStart;
    private long? _cleanupStart;

    public DeadlineClock(
        TimeProvider? timeProvider,
        TimeSpan? executionBudget,
        TimeSpan? waitBudget,
        TimeSpan? cleanupBudget)
    {
        _time = timeProvider ?? TimeProvider.System;
        _admission = _time.GetTimestamp();
        _executionTicks = ToTicks(executionBudget);
        _waitTicks = ToTicks(waitBudget);
        _cleanupTicks = ToTicks(cleanupBudget);
    }

    public TimeProvider TimeProvider => _time;

    public TimeSpan RemainingExecution => Remaining(_admission, _executionTicks);

    public TimeSpan RemainingWait =>
        _waitStart is long start ? Remaining(start, _waitTicks) : Timeout.InfiniteTimeSpan;

    public TimeSpan RemainingCleanup =>
        _cleanupStart is long start ? Remaining(start, _cleanupTicks) : Timeout.InfiniteTimeSpan;

    public TimeSpan RemainingJoin
    {
        get
        {
            TimeSpan execution = RemainingExecution;
            TimeSpan wait = RemainingWait;
            if (execution == Timeout.InfiniteTimeSpan)
            {
                return wait;
            }

            if (wait == Timeout.InfiniteTimeSpan)
            {
                return execution;
            }

            return execution < wait ? execution : wait;
        }
    }

    public bool ExecutionExpired =>
        _executionTicks is not null && RemainingExecution == TimeSpan.Zero;

    public bool WaitExpired =>
        _waitStart is not null && _waitTicks is not null && RemainingWait == TimeSpan.Zero;

    public bool CleanupExpired =>
        _cleanupStart is not null && _cleanupTicks is not null && RemainingCleanup == TimeSpan.Zero;

    public string? ExpiredScope
    {
        get
        {
            if (ExecutionExpired)
            {
                return "Execution";
            }

            if (WaitExpired)
            {
                return "Wait";
            }

            if (CleanupExpired)
            {
                return "Cleanup";
            }

            return null;
        }
    }

    public void StartWait()
    {
        _waitStart ??= _time.GetTimestamp();
    }

    public void StartCleanup()
    {
        _cleanupStart ??= _time.GetTimestamp();
    }

    public TimeSpan Slice(TimeSpan checkpoint)
    {
        return MinPositive(RemainingJoin, checkpoint);
    }

    public TimeSpan CleanupSlice(TimeSpan checkpoint)
    {
        return MinPositive(RemainingCleanup, checkpoint);
    }

    public TimeSpan ProcessSlice(TimeSpan processRemaining, TimeSpan checkpoint)
    {
        TimeSpan join = RemainingJoin;
        TimeSpan bounded = MinPositive(join, processRemaining);
        return MinPositive(bounded, checkpoint);
    }

    private TimeSpan Remaining(long startTimestamp, long? budgetTicks)
    {
        if (budgetTicks is null)
        {
            return Timeout.InfiniteTimeSpan;
        }

        TimeSpan elapsed = _time.GetElapsedTime(startTimestamp);
        TimeSpan left = TimeSpan.FromTicks(budgetTicks.Value) - elapsed;
        return left <= TimeSpan.Zero ? TimeSpan.Zero : left;
    }

    private static long? ToTicks(TimeSpan? budget)
    {
        if (budget is null || budget.Value <= TimeSpan.Zero)
        {
            return null;
        }

        return budget.Value.Ticks;
    }

    private static TimeSpan MinPositive(TimeSpan remaining, TimeSpan checkpoint)
    {
        if (remaining == Timeout.InfiniteTimeSpan)
        {
            return checkpoint;
        }

        if (remaining <= TimeSpan.Zero)
        {
            return TimeSpan.Zero;
        }

        return remaining < checkpoint ? remaining : checkpoint;
    }
}
