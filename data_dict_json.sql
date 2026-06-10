SELECT
    s.name  AS SchemaName,
    t.name  AS TableName,
    c.column_id AS ColumnId,
    c.name  AS ColumnName,
    ty.name AS DataType,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable
FROM sys.tables t
JOIN sys.schemas s ON s.schema_id = t.schema_id
JOIN sys.columns c ON c.object_id = t.object_id
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
ORDER BY s.name, t.name, c.column_id
FOR JSON PATH;

/*Copilot

You are documenting a SQL Server database.
Using ONLY the JSON metadata below, create a data dictionary.

For each table:
- 1-line purpose guess
- Key columns (based on names)
- Confidence score 1-5

For each column:
- Short description guess based on name + datatype
- Mark uncertain guesses with [ASSUMPTION]

Rules:
- Do NOT invent tables or columns.
- Prefer cautious language.

JSON metadata:
<PASTE JSON HERE>
*/
