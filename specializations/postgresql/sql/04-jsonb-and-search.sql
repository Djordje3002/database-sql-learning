-- JSONB and full-text search / JSONB i full-text pretraga. Run after 00 / Pokreni posle 00.

CREATE INDEX catalog_items_attributes_gin_idx
ON academy.catalog_items USING GIN (attributes jsonb_path_ops);

CREATE INDEX catalog_items_author_expression_idx
ON academy.catalog_items ((attributes ->> 'author'));

ALTER TABLE academy.catalog_items
ADD COLUMN search_document tsvector GENERATED ALWAYS AS (
  to_tsvector('simple', coalesce(title, '') || ' ' || coalesce(attributes ->> 'author', ''))
) STORED;

CREATE INDEX catalog_items_search_document_gin_idx
ON academy.catalog_items USING GIN (search_document);

SELECT item_id, title
FROM academy.catalog_items
WHERE attributes @> '{"level":"advanced"}'::jsonb;

SELECT item_id, title
FROM academy.catalog_items
WHERE attributes ->> 'author' = 'M. Data';

SELECT item_id, title
FROM academy.catalog_items
WHERE search_document @@ plainto_tsquery('simple', 'PostgreSQL Practice');

-- Choose jsonb_path_ops only when @> containment is your access pattern / jsonb_path_ops koristi samo kada ti je @> stvarni obrazac pristupa.
