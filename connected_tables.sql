WITH FKCounts AS (
    SELECT
        v.object_id,
        SUM(v.OutFK) AS OutFK,
        SUM(v.InFK)  AS InFK
    FROM sys.foreign_keys fk
    CROSS APPLY (VALUES
        (fk.parent_object_id,     1, 0),
        (fk.referenced_object_id, 0, 1)
    ) v(object_id, OutFK, InFK)
    GROUP BY v.object_id
)
SELECT TOP (30)
    s.name AS SchemaName,
    t.name AS TableName,
    COALESCE(fk.OutFK, 0) AS OutFK,
    COALESCE(fk.InFK,  0) AS InFK,
    COALESCE(fk.OutFK, 0) + COALESCE(fk.InFK, 0) AS TotalLinks
FROM sys.tables t
JOIN sys.schemas s
    ON s.schema_id = t.schema_id
LEFT JOIN FKCounts fk
    ON fk.object_id = t.object_id
ORDER BY
    TotalLinks DESC,
    InFK DESC,
    OutFK DESC,
    s.name,
    t.name;
