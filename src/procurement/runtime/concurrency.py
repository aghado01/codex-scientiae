"""Cancellation-safe asynchronous operation boundaries."""

from __future__ import annotations

import asyncio
from typing import TypeVar

_T = TypeVar("_T")


async def await_boundary(future: asyncio.Future[_T]) -> _T:
    """Settle one shielded future before propagating caller cancellation."""

    cancelled = False
    while True:
        try:
            result = await asyncio.shield(future)
        except asyncio.CancelledError:
            cancelled = True
            if not future.done():
                continue
            try:
                future.result()
            except BaseException:
                pass
            raise
        except BaseException:
            if cancelled:
                raise asyncio.CancelledError()
            raise
        if cancelled:
            raise asyncio.CancelledError()
        return result


__all__ = ["await_boundary"]
