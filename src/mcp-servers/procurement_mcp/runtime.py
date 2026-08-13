"""Shared runtime state for procurement MCP handlers."""

from __future__ import annotations

import asyncio
from dataclasses import dataclass

from procurement.application import ProcurementApplication


async def finish_sync(function, *args, **kwargs):
    """Reach the synchronous operation boundary before propagating cancellation."""

    task = asyncio.create_task(asyncio.to_thread(function, *args, **kwargs))
    try:
        return await asyncio.shield(task)
    except asyncio.CancelledError:
        try:
            await task
        except Exception:
            pass
        raise


@dataclass(slots=True)
class AppContext:
    """MCP-owned procurement application state."""

    application: ProcurementApplication
