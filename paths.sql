WITH Relations AS (
    SELECT
        ps.name + '.' + pt.name AS SourceTableFull,
        rs.name + '.' + rt.name AS TargetTableFull,
        fk.name AS FKName,
        STRING_AGG(
            (ps.name + '.' + pt.name + '.' + pc.name) +
            ' = ' +
            (rs.name + '.' + rt.name + '.' + rc.name),
            ' AND '
        ) WITHIN GROUP (ORDER BY fkc.constraint_column_id) AS JoinCondition
    FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc
        ON fkc.constraint_object_id = fk.object_id
    JOIN sys.tables pt ON pt.object_id = fkc.parent_object_id
    JOIN sys.schemas ps ON ps.schema_id = pt.schema_id
    JOIN sys.columns pc
        ON pc.object_id = fkc.parent_object_id
       AND pc.column_id = fkc.parent_column_id
    JOIN sys.tables rt ON rt.object_id = fkc.referenced_object_id
    JOIN sys.schemas rs ON rs.schema_id = rt.schema_id
    JOIN sys.columns rc
        ON rc.object_id = fkc.referenced_object_id
       AND rc.column_id = fkc.referenced_column_id
    GROUP BY ps.name, pt.name, rs.name, rt.name, fk.name
),
Paths AS (
    SELECT
        CAST(r.SourceTableFull AS nvarchar(max)) AS Root,
        CAST(r.SourceTableFull + ' => ' + r.TargetTableFull AS nvarchar(max)) AS TablePath,
        CAST(r.JoinCondition AS nvarchar(max)) AS JoinPath,
        CAST('|' + r.SourceTableFull + '|' + r.TargetTableFull + '|' AS nvarchar(max)) AS Visited,
        1 AS Lvl,
        r.TargetTableFull AS CurrentTable,
        r.FKName
    FROM Relations r

    UNION ALL

    SELECT
        p.Root,
        CAST(p.TablePath + ' => ' + r.TargetTableFull AS nvarchar(max)),
        CAST(p.JoinPath  + ' | '  + r.JoinCondition AS nvarchar(max)),
        CAST(p.Visited   + r.TargetTableFull + '|' AS nvarchar(max)),
        p.Lvl + 1,
        r.TargetTableFull,
        r.FKName
    FROM Paths p
    JOIN Relations r
      ON r.SourceTableFull = p.CurrentTable
    WHERE p.Lvl < 10
      AND p.Visited NOT LIKE '%|' + r.TargetTableFull + '|%'
)
SELECT
    Root, Lvl, TablePath, JoinPath, FKName
FROM Paths
ORDER BY Root, Lvl, TablePath
OPTION (MAXRECURSION 32767);

/*Copilot

You are a data architect.
Using ONLY the edges and tree excerpt below, produce:
1) A high-level model summary with 3–7 domains/clusters.
2) The 5 most central tables and why (based on relationships shown).
3) A recommended onboarding path for a new engineer.
4) Likely business processes represented (mark with [ASSUMPTION]).

Rules:
- Use ONLY the objects present in the pasted data.
- Do NOT invent tables/columns.
- Mark uncertain items with [ASSUMPTION].

Edges:
<PASTE EDGES HERE>

Tree excerpt:
<OPTIONAL: PASTE TREE HERE>
*/
