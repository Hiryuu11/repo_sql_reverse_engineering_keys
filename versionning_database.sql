
-- 1) Check server version + current database
SELECT
    @@VERSION AS SqlServerVersion,
    DB_NAME() AS CurrentDatabase;

-- 2) Check database compatibility level
SELECT
    name AS DatabaseName,
    compatibility_level
FROM sys.databases
WHERE name = DB_NAME();
