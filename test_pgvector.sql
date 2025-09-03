-- Test pgvector installation
CREATE EXTENSION IF NOT EXISTS vector;

-- Test vector data type
CREATE TABLE IF NOT EXISTS test_vectors (
  id SERIAL PRIMARY KEY,
  embedding vector(3)
);

INSERT INTO test_vectors (embedding) VALUES ('[1,2,3]');

SELECT * FROM test_vectors;

-- Verify extension is loaded
SELECT * FROM pg_extension WHERE extname = 'vector';

-- Clean up test
DROP TABLE IF EXISTS test_vectors;

-- Show success
SELECT 'pgvector is working correctly!' as status;