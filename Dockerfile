FROM python:3.13-slim-bookworm

WORKDIR /app

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    pkg-config \
    git \
    postgresql-client \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Clone LightRAG repository
RUN git clone https://github.com/HKUDS/LightRAG.git .

# Install dependencies and LightRAG with API support
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir -r lightrag/api/requirements.txt \
    && pip install --no-cache-dir -e ".[api]" \
    && pip install --no-cache-dir anthropic openai psycopg2-binary neo4j asyncpg

# Create necessary directories
RUN mkdir -p /app/data /app/config

# Copy the entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Expose the default port
EXPOSE 9621

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]
