WITH Edges AS (
    SELECT
        ps.name AS SourceSchema,
        pt.name AS SourceTable,
        rs.name AS TargetSchema,
        rt.name AS TargetTable
    FROM sys.foreign_keys fk
    JOIN sys.tables  pt ON pt.object_id = fk.parent_object_id
    JOIN sys.schemas ps ON ps.schema_id = pt.schema_id
    JOIN sys.tables  rt ON rt.object_id = fk.referenced_object_id
    JOIN sys.schemas rs ON rs.schema_id = rt.schema_id
),
Tree AS (
    SELECT
        CAST(SourceSchema + '.' + SourceTable AS nvarchar(4000)) AS Root,
        CAST('|' + SourceSchema + '.' + SourceTable + '|'
                  + TargetSchema + '.' + TargetTable + '|' AS nvarchar(4000)) AS Visited,
        1 AS Lvl,
        SourceSchema, SourceTable, TargetSchema, TargetTable
    FROM Edges

    UNION ALL

    SELECT
        t.Root,
        CAST(t.Visited + e.TargetSchema + '.' + e.TargetTable + '|' AS nvarchar(4000)),
        t.Lvl + 1,
        e.SourceSchema, e.SourceTable, e.TargetSchema, e.TargetTable
    FROM Tree t
    JOIN Edges e
      ON e.SourceSchema = t.TargetSchema
     AND e.SourceTable  = t.TargetTable
    WHERE t.Lvl < 10
      AND t.Visited NOT LIKE '%|' + e.TargetSchema + '.' + e.TargetTable + '|%'
)
SELECT
    Root,
    REPLICATE('  ', Lvl) +
    (SourceSchema + '.' + SourceTable + ' => ' + TargetSchema + '.' + TargetTable) AS TreeLine,
    Lvl
FROM Tree
ORDER BY Root, Lvl
OPTION (MAXRECURSION 32767);
