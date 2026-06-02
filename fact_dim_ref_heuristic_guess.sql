SELECT
    s.name AS SchemaName,
    t.name AS TableName,
    rc.Row_Count,
    COALESCE(fk.OutFK, 0) AS OutFK,
    COALESCE(fk.InFK,  0) AS InFK,
    CASE
        WHEN rc.Row_Count > 100000 AND COALESCE(fk.OutFK, 0) > 2 THEN 'FACT (likely)'
        WHEN rc.Row_Count < 10000  AND COALESCE(fk.InFK,  0) > 5 THEN 'DIMENSION / REF (likely)'
        WHEN rc.Row_Count < 1000   AND COALESCE(fk.InFK,  0) = 0 THEN 'REFERENCE (small static)'
        ELSE 'UNKNOWN / MIXED'
    END AS TableTypeGuess
FROM sys.tables t
JOIN sys.schemas s
    ON s.schema_id = t.schema_id
OUTER APPLY (
    SELECT SUM(CONVERT(bigint, p.rows)) AS Row_Count
    FROM sys.partitions p
    WHERE p.object_id = t.object_id
      AND p.index_id IN (0, 1)
) rc
OUTER APPLY (
    SELECT
        (SELECT COUNT(*) FROM sys.foreign_keys fk1 WHERE fk1.parent_object_id     = t.object_id) AS OutFK,
        (SELECT COUNT(*) FROM sys.foreign_keys fk2 WHERE fk2.referenced_object_id = t.object_id) AS InFK
) fk
ORDER BY rc.Row_Count DESC, s.name, t.name;

/* Copilot script:


You are a senior data consultant.
Using ONLY the table stats below (Row_Count, InFK, OutFK, TableTypeGuess):
1) Validate or challenge the guess (FACT/DIM/REF). If you disagree, explain why.
2) Propose a candidate star schema: list likely FACT tables and their likely DIM tables.
3) Give an onboarding path: the first 5 tables to inspect and in what order.
4) List risks/red flags (hubs, missing keys, suspicious patterns).

Rules:
- Use ONLY the information provided.
- Do NOT invent tables or columns.
- Mark uncertain items with [ASSUMPTION].

Table stats:
<PASTE 20 ROWS HERE>
*/
