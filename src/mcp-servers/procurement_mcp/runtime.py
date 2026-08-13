"""Shared runtime state for procurement MCP handlers."""

from __future__ import annotations

import asyncio
from dataclasses import dataclass

from procurement.application import ProcurementApplication
from procurement.runtime.concurrency import await_boundary


async def finish_sync(function, *args, **kwargs):
    """Reach the synchronous operation boundary before propagating cancellation."""

    task = asyncio.create_task(asyncio.to_thread(function, *args, **kwargs))
    return await await_boundary(task)


@dataclass(slots=True)
class AppContext:
    """MCP-owned procurement application state."""

    application: ProcurementApplication
