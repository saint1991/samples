-- SQLite用: DataSourceテーブルに10,000レコード挿入
WITH RECURSIVE series(value) AS (
    SELECT 1
    UNION ALL
    SELECT value + 1 FROM series WHERE value < 10000
)
INSERT INTO blog_datasource (datasource_name, type, created_at, updated_at, size)
SELECT 
    'DataSource_' || value as datasource_name,
    CASE 
        WHEN value % 4 = 0 THEN 'file'
        WHEN value % 4 = 1 THEN 'database'
        WHEN value % 4 = 2 THEN 'url'
        ELSE 'folder'
    END as type,
    datetime('now', '-' || (ABS(RANDOM()) % 365) || ' days') as created_at,
    datetime('now', '-' || (ABS(RANDOM()) % 30) || ' days') as updated_at,
    ABS(RANDOM()) % 1000000000 + 1000 as size
FROM series;

-- DataFramesテーブルに10,000レコード挿入
WITH RECURSIVE series(value) AS (
    SELECT 1
    UNION ALL
    SELECT value + 1 FROM series WHERE value < 10000
)
INSERT INTO blog_dataframes (dataframe_name, datasource_id, project_id, created_at, updated_at)
SELECT 
    'DataFrame_' || value as dataframe_name,
    (ABS(RANDOM()) % 10000) + 1 as datasource_id,  -- 1-10000のDataSource IDをランダムに参照
    (ABS(RANDOM()) % 100) + 1 as project_id,  -- 1-100のProject IDをランダムに割り当て
    datetime('now', '-' || (ABS(RANDOM()) % 365) || ' days') as created_at,
    datetime('now', '-' || (ABS(RANDOM()) % 30) || ' days') as updated_at
FROM series;