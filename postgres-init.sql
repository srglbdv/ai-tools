-- Enable the vector extension for storing embeddings
CREATE EXTENSION IF NOT EXISTS vector;

-- Create tables if they don't exist
-- Table for document status tracking
CREATE TABLE IF NOT EXISTS lightrag_doc_status (
    id TEXT PRIMARY KEY,
    workspace TEXT NOT NULL,
    status TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table for storing full documents
CREATE TABLE IF NOT EXISTS lightrag_full_docs (
    id TEXT PRIMARY KEY,
    workspace TEXT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table for storing document chunks
CREATE TABLE IF NOT EXISTS lightrag_doc_chunks (
    id TEXT PRIMARY KEY,
    workspace TEXT NOT NULL,
    chunk_id TEXT NOT NULL,
    content TEXT NOT NULL,
    doc_id TEXT NOT NULL,
    chunk_index INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Table for storing LLM response cache
CREATE TABLE IF NOT EXISTS lightrag_llm_response_cache (
    id TEXT NOT NULL,
    workspace TEXT NOT NULL,
    mode TEXT NOT NULL,
    original_prompt TEXT NOT NULL,
    return_value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id, mode, workspace)
);

-- Table for storing vector embeddings
CREATE TABLE IF NOT EXISTS lightrag_vectors (
    id TEXT NOT NULL,
    workspace TEXT NOT NULL,
    vector_type TEXT NOT NULL,
    embedding VECTOR(1536) NOT NULL,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (id, vector_type, workspace)
);

-- Add indices for better query performance
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_status_workspace ON lightrag_doc_status (workspace);
CREATE INDEX IF NOT EXISTS idx_lightrag_full_docs_workspace ON lightrag_full_docs (workspace);
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_chunks_workspace ON lightrag_doc_chunks (workspace);
CREATE INDEX IF NOT EXISTS idx_lightrag_doc_chunks_doc_id ON lightrag_doc_chunks (doc_id);
CREATE INDEX IF NOT EXISTS idx_lightrag_llm_response_cache_workspace ON lightrag_llm_response_cache (workspace);
CREATE INDEX IF NOT EXISTS idx_lightrag_vectors_workspace ON lightrag_vectors (workspace);
CREATE INDEX IF NOT EXISTS idx_lightrag_vectors_vector_type ON lightrag_vectors (vector_type);

-- Create an IVFFLAT index for vector similarity search
-- This is more efficient for large datasets than the default HNSW index
CREATE INDEX IF NOT EXISTS lightrag_vectors_embedding_idx ON lightrag_vectors 
USING ivfflat (embedding vector_cosine_ops) 
WITH (lists = 100);

-- Grant permissions to the postgres user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
