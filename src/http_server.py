"""Serve the Mealie MCP server over Streamable HTTP.

Upstream ``server.py`` hardcodes ``mcp.run(transport="stdio")`` for Claude
Desktop. Importing it here runs all the module-level setup (client init, prompt
and tool registration) and hands us the configured ``mcp`` object, which we then
run over Streamable HTTP so it can be federated by an MCP gateway. Host/port come
from the FastMCP standard env vars (FASTMCP_HOST / FASTMCP_PORT); the endpoint is
served at /mcp.
"""

import os

from server import mcp  # registers prompts + tools as a side effect of import

mcp.settings.host = os.getenv("FASTMCP_HOST", "0.0.0.0")
mcp.settings.port = int(os.getenv("FASTMCP_PORT", "8000"))

if __name__ == "__main__":
    mcp.run(transport="streamable-http")
