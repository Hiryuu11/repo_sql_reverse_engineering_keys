SELECT COUNT(*) AS NbPrimaryKeys
FROM sys.indexes
WHERE is_primary_key = 1;

SELECT COUNT(*) AS NbForeignKeys
FROM sys.foreign_keys;

SELECT
    COUNT(*) AS TotalFK,
    SUM(CASE WHEN fk.is_disabled = 1 THEN 1 ELSE 0 END) AS DisabledFK,
    SUM(CASE WHEN fk.is_not_trusted = 1 THEN 1 ELSE 0 END) AS NotTrustedFK
FROM sys.foreign_keys fk;

SELECT TOP (50)
    fk.name AS ForeignKeyName,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) + '.' + OBJECT_NAME(fk.parent_object_id) AS SourceTable,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' + OBJECT_NAME(fk.referenced_object_id) AS TargetTable,
    fk.is_disabled,
    fk.is_not_trusted
FROM sys.foreign_keys fk
WHERE fk.is_disabled = 1 OR fk.is_not_trusted = 1
ORDER BY fk.is_disabled DESC, fk.is_not_trusted DESC, ForeignKeyName;
``
