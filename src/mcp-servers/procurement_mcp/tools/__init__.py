"""Ordered procurement MCP tool registration."""

from __future__ import annotations

from mcp.server import MCPServer

from procurement_mcp.tools.acquisition import register_acquisition_tools
from procurement_mcp.tools.catalogs import register_catalog_tools
from procurement_mcp.tools.discovery import register_discovery_tools
from procurement_mcp.tools.materialization import register_materialization_tools
from procurement_mcp.tools.metadata import register_metadata_tools
from procurement_mcp.tools.procure import register_procure_tools
from procurement_mcp.tools.providers import register_provider_tools


def register_tools(server: MCPServer) -> None:
    """Register the complete procurement tool surface in protocol order."""

    register_discovery_tools(server)
    register_metadata_tools(server)
    register_acquisition_tools(server)
    register_materialization_tools(server)
    register_procure_tools(server)
    register_catalog_tools(server)
    register_provider_tools(server)
