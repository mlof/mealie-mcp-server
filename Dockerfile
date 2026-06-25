# Container image for running mealie-mcp-server over Streamable HTTP so it can be
# federated by an MCP gateway (the upstream entrypoint is stdio-only). Deps are
# installed from the committed uv.lock for reproducibility; the app itself is not
# a package (no build-system), so we run it straight from src/ via PYTHONPATH.
FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app

# Resolve deps from the lockfile only (no dev, skip the local project) and install
# them system-wide.
COPY pyproject.toml uv.lock ./
RUN uv export --frozen --no-dev --no-emit-project --format requirements-txt -o requirements.txt \
    && uv pip install --system --no-cache -r requirements.txt

COPY src ./src

ENV PYTHONPATH=/app/src \
    PYTHONUNBUFFERED=1 \
    FASTMCP_HOST=0.0.0.0 \
    FASTMCP_PORT=8000 \
    LOG_LEVEL=INFO

WORKDIR /app/src
EXPOSE 8000

CMD ["python", "http_server.py"]
