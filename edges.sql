SELECT
    ps.name + '.' + pt.name AS [From],
    rs.name + '.' + rt.name AS [To],
    STRING_AGG(
        ps.name + '.' + pt.name + '.' + pc.name
        + ' = ' +
        rs.name + '.' + rt.name + '.' + rc.name,
        ' AND '
    ) WITHIN GROUP (ORDER BY fkc.constraint_column_id) AS JoinCondition,
    fk.name AS FKName
FROM sys.foreign_keys fk
JOIN sys.foreign_key_columns fkc
    ON fkc.constraint_object_id = fk.object_id
JOIN sys.tables pt
    ON pt.object_id = fkc.parent_object_id
JOIN sys.schemas ps
    ON ps.schema_id = pt.schema_id
JOIN sys.columns pc
    ON pc.object_id = pt.object_id
   AND pc.column_id = fkc.parent_column_id
JOIN sys.tables rt
    ON rt.object_id = fkc.referenced_object_id
JOIN sys.schemas rs
    ON rs.schema_id = rt.schema_id
JOIN sys.columns rc
    ON rc.object_id = rt.object_id
   AND rc.column_id = fkc.referenced_column_id
GROUP BY ps.name, pt.name, rs.name, rt.name, fk.name
ORDER BY [From], [To], FKName;
