
SELECT TOP (20)
    s.name AS SchemaName,
    t.name AS TableName,
    SUM(p.rows) AS ApproxRow_Count
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.partitions p ON p.object_id = t.object_id
WHERE p.index_id IN (0,1)
GROUP BY s.name, t.name
ORDER BY ApproxRow_Count DESC;
