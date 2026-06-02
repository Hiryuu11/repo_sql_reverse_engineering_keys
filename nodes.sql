SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    pk.PKColumns
FROM sys.tables t
JOIN sys.schemas s
    ON s.schema_id = t.schema_id
OUTER APPLY
(
    SELECT STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS PKColumns
    FROM sys.indexes i
    JOIN sys.index_columns ic
        ON ic.object_id = i.object_id
       AND ic.index_id  = i.index_id
    JOIN sys.columns c
        ON c.object_id  = ic.object_id
       AND c.column_id  = ic.column_id
    WHERE i.object_id = t.object_id
      AND i.is_primary_key = 1
) pk
ORDER BY s.name, t.name;
