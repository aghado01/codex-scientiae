Everything else is explicitly deferred and requires a new decision:

- Retry/backoff.
- Stronger child cancellation and parent-death containment.
- Detached/durable execution.
- Typed runtime-profile/process-spec constructors.
- DAGs or phase barriers.
- Fairness/priority scheduling beyond cost ordering.
- Persistent results and resume.
- Native non-PowerShell processes.
- C# plan-model port.
- Public worker-budget preview.
- Compatibility-facade removal.

So, aside from the testing work, BEX-403 is the only active obligation. It can likely be closed against the existing Pester and LaTeX adapters before beginning the broader test-system refactor.
