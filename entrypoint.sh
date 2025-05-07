#!/bin/bash
set -e

# Verify API keys are set
if [ -z "$LLM_BINDING_API_KEY" ] || [ -z "$EMBEDDING_BINDING_API_KEY" ]; then
  echo "ERROR: API keys for LLM and/or embedding services are not set!"
  echo "Please make sure to set the ANTHROPIC_API_KEY and OPENAI_API_KEY environment variables."
  exit 1
fi

# Verify API connectivity
echo "Verifying connectivity to Anthropic API..."
if curl -s -o /dev/null -w "%{http_code}" -H "x-api-key: $LLM_BINDING_API_KEY" -H "anthropic-version: 2023-06-01" "$LLM_BINDING_HOST/v1/models" | grep -q "20"; then
  echo "Successfully connected to Anthropic API!"
else
  echo "WARNING: Could not verify Anthropic API connection. Proceeding anyway, but there might be issues."
fi

echo "Verifying connectivity to OpenAI API (for embeddings)..."
if curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $EMBEDDING_BINDING_API_KEY" "$EMBEDDING_BINDING_HOST/models" | grep -q "20"; then
  echo "Successfully connected to OpenAI API for embeddings!"
else
  echo "WARNING: Could not verify OpenAI API connection for embeddings. Proceeding anyway, but there might be issues."
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $POSTGRES_DATABASE -c '\q' 2>/dev/null; do
  echo "PostgreSQL is unavailable - sleeping 2s"
  sleep 2
done
echo "PostgreSQL is up and running!"

# Wait for Neo4j to be ready
echo "Waiting for Neo4j to be ready..."
until curl -s http://neo4j-vcs0ogg80g000o0kksgos884:7474/browser/ > /dev/null; do
  echo "Neo4j is unavailable - sleeping 2s"
  sleep 2
done
echo "Neo4j is up and running!"

# Create necessary directories
mkdir -p /app/data/working_dir

# Start LightRAG server
echo "Starting LightRAG API server..."
exec lightrag-server
