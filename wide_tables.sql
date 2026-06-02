
SELECT TOP (20)
    s.name AS SchemaName,
    t.name AS TableName,
    COUNT(c.column_id) AS NbColumns
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.columns c ON c.object_id = t.object_id
GROUP BY s.name, t.name
ORDER BY NbColumns DESC;
