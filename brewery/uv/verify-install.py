"""Verify the installed procurement MCP runtime dependency group."""

from __future__ import annotations

import asyncio
import json
from importlib.metadata import distribution

import httpx
from mcp import Client

from procurement_mcp.server import create_server


async def _verify() -> dict[str, object]:
    package = distribution("codex-scientiae")
    entry_points = {
        entry.name: entry.value
        for entry in package.entry_points
        if entry.group == "console_scripts"
    }
    expected = "procurement_mcp.server:main"
    if entry_points.get("scientiae-procurement") != expected:
        raise RuntimeError("scientiae-procurement entry point is missing or incorrect")

    try:
        http_client = httpx.AsyncClient(http2=True, follow_redirects=False)
    except ImportError as exc:
        raise RuntimeError("httpx HTTP/2 extra is not installed") from exc
    await http_client.aclose()

    async with Client(create_server()) as client:
        tools = await client.list_tools()
        prompts = await client.list_prompts()

    tool_names = [tool.name for tool in tools.tools]
    prompt_names = [prompt.name for prompt in prompts.prompts]
    if len(tool_names) != 17 or sorted(prompt_names) != [
        "discovery_procedure",
        "procurement_request",
    ]:
        raise RuntimeError("procurement MCP registration census is incorrect")
    return {
        "distribution": package.metadata["Name"],
        "entry_point": entry_points["scientiae-procurement"],
        "tools": tool_names,
        "prompts": prompt_names,
    }


def main() -> None:
    """Run the installed-runtime verification."""

    print(json.dumps(asyncio.run(_verify()), separators=(",", ":")))


if __name__ == "__main__":
    main()
