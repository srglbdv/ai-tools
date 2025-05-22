# AI Tools Collection

This repository contains a collection of various AI-related tools and projects. Each subfolder contains a separate project with its own documentation and setup instructions.

## Projects

### [LightRAG for Coolify with PostgreSQL, DozerDB, and MCP Integration](./lightrag-coolify-mcp)

A complete Dockerized setup for running LightRAG on Coolify. It uses PostgreSQL for document storage and vector embeddings, DozerDB (a Neo4j variant) for knowledge graph management, and includes a Model Context Protocol (MCP) server for AI assistant integration.

**Key Features:**
- Complete RAG system with knowledge graph capabilities
- MCP server for direct integration with AI assistants like Claude
- Support for existing PostgreSQL/Supabase databases
- n8n integration for workflow automation
- Coolify deployment with automatic domain generation

The MCP server provides 17 tools for interacting with the LightRAG system programmatically, including querying the knowledge base, managing documents, and working with the knowledge graph.

## Getting Started

Each project folder contains its own README with detailed setup instructions and documentation. Navigate to the project you're interested in to learn more.

## Contributing

If you'd like to contribute to any of these projects, please feel free to submit a pull request or open an issue.

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
