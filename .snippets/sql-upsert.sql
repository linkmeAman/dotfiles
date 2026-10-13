INSERT INTO target_table (id, name, updated_at)
VALUES (1, 'example', CURRENT_TIMESTAMP)
ON CONFLICT (id) DO UPDATE
SET name = EXCLUDED.name,
    updated_at = EXCLUDED.updated_at;
