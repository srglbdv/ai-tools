# LightRAG MCP Server with PostgreSQL and Neo4j

This repository contains a complete Dockerized setup for running a LightRAG Message Control Program (MCP) server that uses PostgreSQL for document storage and Neo4j for knowledge graph management. It's designed to integrate easily with n8n for workflow automation, and uses Claude (Sonnet) and OpenAI models via their standard APIs.

## What is LightRAG?

LightRAG is a powerful Retrieval-Augmented Generation (RAG) system developed by the HKU Data Science Lab. It combines knowledge graphs with vector retrieval, efficiently processing textual knowledge while capturing structured relationships between information by incorporating graph structures into text indexing and retrieval processes.

Key features:
- Graph-based text indexing for comprehensive information retrieval
- Dual-level retrieval mechanism that handles both specific and abstract queries
- Multiple retrieval modes for different use cases
- Integration with cloud-based LLM models from OpenAI and Anthropic
- PostgreSQL for document storage and vector embeddings
- Neo4j for knowledge graph storage and querying

## Components

This setup includes:

1. **LightRAG API Server**: Provides Web UI and API support for document indexing, knowledge graph exploration, and RAG queries
2. **PostgreSQL with pgvector**: Stores documents, chunks, and vector embeddings
3. **Neo4j**: Stores and manages the knowledge graph with entities and relationships

## Quick Start

### Prerequisites

- Docker and Docker Compose
- Git
- OpenAI API key
- Anthropic API key (optional, as backup LLM)
- n8n instance running (external to this setup)

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/lightrag-mcp-n8n.git
   cd lightrag-mcp-n8n
   ```

2. Create the necessary directories:
   ```bash
   mkdir -p data config postgres-init
   ```

3. Copy the Postgres initialization script:
   ```bash
   cp postgres-init.sql postgres-init/
   ```

4. Create and configure your environment variables:
   ```bash
   cp .env.template .env
   ```
   
   Edit the `.env` file and add your API keys and database credentials:
   ```
   OPENAI_API_KEY=your-openai-api-key-here
   ANTHROPIC_API_KEY=your-anthropic-api-key-here
   LIGHTRAG_API_KEY=your-secure-lightrag-api-key
   ADMIN_PASSWORD=strong-admin-password
   TOKEN_SECRET=random-secret-key-for-jwt-tokens
   POSTGRES_PASSWORD=secure-postgres-password
   NEO4J_PASSWORD=secure-neo4j-password
   ```

5. Start the containers:
   ```bash
   docker compose up -d
   ```

6. The services will be available at:
   - LightRAG API Server: http://localhost:9621
   - LightRAG Web UI: http://localhost:9621/ui
   - Neo4j Browser: http://localhost:7474 (login with neo4j/your-password)
   - PostgreSQL: localhost:5432 (connect with your preferred client)

### Initializing LightRAG with Documents

1. Access the LightRAG Web UI at http://localhost:9621/ui
2. Log in using the admin credentials you set in the .env file
3. Upload your documents through the interface
4. Monitor the document indexing process

## Integrating with n8n

Since you already have n8n running, you can integrate it with LightRAG using HTTP Requests:

1. In n8n, create a new workflow
2. Add an HTTP Request node
3. Configure it to point to the LightRAG API endpoint: `http://your-server-ip:9621/api/query`
4. Set the method to POST and body to JSON with the following structure:
   ```json
   {
     "query": "Your question here",
     "mode": "hybrid"
   }
   ```
5. Add the X-API-Key header with your LIGHTRAG_API_KEY value
6. Connect this node to other actions in your workflow

## Database Schema

### PostgreSQL

The PostgreSQL database includes several tables:
- `lightrag_doc_status`: Tracks document processing status
- `lightrag_full_docs`: Stores original documents
- `lightrag_doc_chunks`: Stores document chunks for processing
- `lightrag_llm_response_cache`: Caches LLM responses for efficiency
- `lightrag_vectors`: Stores vector embeddings with pgvector for similarity search

### Neo4j

The Neo4j database stores:
- Entities as nodes with properties like entity type, description, and source
- Relationships between entities with properties like weight, description, and keywords

## Configuration Options

### API Models

This setup uses the following models by default:
- Primary LLM: `gpt-4o` from OpenAI
- Backup LLM: `claude-3-sonnet-20240229` from Anthropic
- Embedding: `text-embedding-3-large` from OpenAI

You can modify these in the `.env` file or `docker-compose.yml` to use different models:
- For cheaper usage: Switch to `gpt-4o-mini` or `gpt-3.5-turbo`
- For embedding: Use `text-embedding-3-small` for lower cost
- You can also adjust token limits to manage API costs

### Authentication

The LightRAG server is protected with:
1. API key authentication for API endpoints
2. JWT-based user authentication for the Web UI

Configuration is done via the `.env` file.

## Query Modes

LightRAG supports different retrieval modes for various use cases , depending on the specific scenario:

- **local**: Focus on retrieving specific entities
- **global**: Focus on finding relationship patterns
- **hybrid**: Combine both local and global retrieval (recommended for most cases)
- **mix**: Use both approaches in parallel
- **naive**: Simple vector-based retrieval without graph enhancement

You can specify the mode in your API requests to LightRAG.

## Troubleshooting

### Common Issues

1. **API key issues**: Verify your API keys are correctly set in the .env file
2. **Rate limiting**: If you hit OpenAI or Anthropic rate limits, consider adjusting the MAX_ASYNC parameter
3. **Connection problems**: Check network configurations and firewall settings
4. **Database connectivity**: Ensure PostgreSQL and Neo4j are running and accessible

### Logs

Access logs for debugging:
```bash
# LightRAG server logs
docker logs lightrag-mcp-server

# PostgreSQL logs
docker logs lightrag-postgres

# Neo4j logs
docker logs lightrag-neo4j
```

## Advanced Usage

### Custom Knowledge Graphs

LightRAG allows importing custom knowledge graphs. Create a JSON file with your entities and relationships, then import it using the API or Web UI.

### Cost Management

To manage API costs:
- Use smaller embedding models for less critical applications
- Reduce token limits for cheaper API usage
- Enable caching to reuse previous LLM responses
- Adjust MAX_PARALLEL_INSERT to control the rate of document processing

## References

- LightRAG GitHub Repository: https://github.com/HKUDS/LightRAG
- LightRAG API Documentation
- Use of Neo4j and PostgreSQL together
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [Anthropic API Documentation](https://docs.anthropic.com/en/api/)
- [n8n Documentation](https://docs.n8n.io)
- [PostgreSQL pgvector Documentation](https://github.com/pgvector/pgvector)
- [Neo4j Documentation](https://neo4j.com/docs/)_KEY=your-openai-api-key-here
   ANTHROPIC_API_KEY=your-anthropic-api-key-here
   LIGHTRAG_API_KEY=your-secure-lightrag-api-key
   ADMIN_PASSWORD=strong-admin-password
   TOKEN_SECRET=random-secret-key-for-jwt-tokens
   ```

4. Start the containers:
   ```bash
   docker compose up -d
   ```

5. The services will be available at:
   - LightRAG API Server: http://localhost:9621
   - LightRAG Web UI: http://localhost:9621/ui
   - n8n: http://localhost:5678

### Initializing LightRAG with Documents

1. Access the LightRAG Web UI at http://localhost:9621/ui
2. Log in using the admin credentials you set in the .env file
3. Upload your documents through the interface
4. Monitor the document indexing process

## Integrating with n8n

### Method 1: Using HTTP Requests Node

1. In n8n, create a new workflow
2. Add an HTTP Request node
3. Configure it to point to the LightRAG API endpoint: `http://lightrag-mcp-server:9621/api/query`
4. Set the method to POST and body to JSON with the following structure:
   ```json
   {
     "query": "Your question here",
     "mode": "hybrid"
   }
   ```
5. Add the X-API-Key header with your LIGHTRAG_API_KEY value
6. Connect this node to other actions in your workflow

### Method 2: Using the Custom LightRAG n8n Node

A custom n8n node for LightRAG is included in this repository. To use it:

1. In n8n, go to Settings > Community Nodes
2. Install the node by providing the path to the node directory
3. Add the LightRAG node to your workflow
4. Configure the node's credentials with your LightRAG API URL and API key
5. Select the desired operation (query, document management, etc.)

## Configuration Options

### API Models

This setup uses the following models by default:
- Primary LLM: `gpt-4o` from OpenAI
- Backup LLM: `claude-3-sonnet-20240229` from Anthropic
- Embedding: `text-embedding-3-large` from OpenAI

You can modify these in the `.env` file or `docker-compose.yml` to use different models:
- For cheaper usage: Switch to `gpt-4o-mini` or `gpt-3.5-turbo`
- For embedding: Use `text-embedding-3-small` for lower cost
- You can also adjust token limits to manage API costs

### Authentication

The LightRAG server is protected with:
1. API key authentication for API endpoints
2. JWT-based user authentication for the Web UI

Configuration is done via the `.env` file.

## Query Modes

LightRAG supports different retrieval modes for various use cases:

- **local**: Focus on retrieving specific entities
- **global**: Focus on finding relationship patterns
- **hybrid**: Combine both local and global retrieval (recommended for most cases)
- **mix**: Use both approaches in parallel
- **naive**: Simple vector-based retrieval without graph enhancement

You can specify the mode in your API requests to LightRAG.

## Troubleshooting

### Common Issues

1. **API key issues**: Verify your API keys are correctly set in the .env file
2. **Rate limiting**: If you hit OpenAI or Anthropic rate limits, consider adjusting the MAX_ASYNC parameter
3. **Connection problems**: Check network configurations and firewall settings

### Logs

Access logs for debugging:
```bash
# LightRAG server logs
docker logs lightrag-mcp-server

# n8n logs
docker logs n8n
```

## Advanced Usage

### Custom Knowledge Graphs

LightRAG allows importing custom knowledge graphs. Create a JSON file with your entities and relationships, then import it using the API or Web UI.

### Cost Management

To manage API costs:
- Use smaller embedding models for less critical applications
- Reduce token limits for cheaper API usage
- Enable caching to reuse previous LLM responses
- Adjust MAX_PARALLEL_INSERT to control the rate of document processing

## References

- [LightRAG GitHub Repository](https://github.com/HKUDS/LightRAG)
- [n8n Documentation](https://docs.n8n.io)
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [Anthropic API Documentation](https://docs.anthropic.com/en/api/)