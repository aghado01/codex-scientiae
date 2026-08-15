"""Verify the installed procurement MCP runtime dependency group."""

from __future__ import annotations

import asyncio
import json
from importlib.metadata import distribution

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

    async with Client(create_server()) as client:
        tools = await client.list_tools()
        prompts = await client.list_prompts()

    tool_names = [tool.name for tool in tools.tools]
    prompt_names = [prompt.name for prompt in prompts.prompts]
    if len(tool_names) != 16 or prompt_names != ["discovery_procedure"]:
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
