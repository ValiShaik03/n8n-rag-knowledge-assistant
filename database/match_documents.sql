CREATE OR REPLACE FUNCTION public.match_documents(
    query_embedding extensions.vector(768),
    match_count integer,
    filter jsonb
)
RETURNS TABLE (id bigint, content text, metadata jsonb, similarity float)
LANGUAGE sql STABLE AS $$
    SELECT r.id, r.content, r.metadata,
           1 - (r.embedding <=> query_embedding) AS similarity
    FROM public.rag_documents AS r
    WHERE filter = '{}'::jsonb OR r.metadata @> filter
    ORDER BY r.embedding <=> query_embedding
    LIMIT match_count;
$$;
