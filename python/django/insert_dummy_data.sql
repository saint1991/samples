-- PostgreSQL用のダミーデータ挿入SQL
-- DataSourcesテーブルに3万件、DataFramesテーブルに10万件を挿入
-- パフォーマンステスト用にproject_idの分布を最適化

-- トランザクション開始
BEGIN;

-- DataSourcesテーブルへ3万件挿入
INSERT INTO perf_datasource (
    datasource_name,
    type,
    created_at,
    updated_at,
    size
)
SELECT
    'datasource_' || generate_series AS datasource_name,
    CASE
        WHEN random() < 0.4 THEN 'file'
        WHEN random() < 0.7 THEN 'database'
        WHEN random() < 0.9 THEN 'url'
        ELSE 'folder'
    END AS type,
    NOW() - (random() * INTERVAL '365 days') AS created_at,
    NOW() - (random() * INTERVAL '30 days') AS updated_at,
    floor(random() * 1000000000 + 1000)::bigint AS size
FROM generate_series(1, 30000);

-- DataFramesテーブルへ10万件挿入
-- project_idの分布:
-- - project_id 1-10: 30% (3万件) = 各3,000件 (ホットなプロジェクト)
-- - project_id 11-50: 40% (4万件) = 各1,000件 (アクティブなプロジェクト)
-- - project_id 51-200: 20% (2万件) = 各133件 (通常のプロジェクト)
-- - project_id 201-1000: 10% (1万件) = 各12-13件 (低活動プロジェクト)

-- ホットなプロジェクト (1-10): 3万件
INSERT INTO perf_dataframes (
    dataframe_name,
    datasource_id,
    project_id,
    created_at,
    updated_at
)
SELECT
    'dataframe_hot_' || row_number() OVER () AS dataframe_name,
    floor(random() * 30000 + 1)::integer AS datasource_id,
    floor(random() * 10 + 1)::integer AS project_id,
    NOW() - (random() * INTERVAL '365 days') AS created_at,
    NOW() - (random() * INTERVAL '30 days') AS updated_at
FROM generate_series(1, 30000);

-- アクティブなプロジェクト (11-50): 4万件
INSERT INTO perf_dataframes (
    dataframe_name,
    datasource_id,
    project_id,
    created_at,
    updated_at
)
SELECT
    'dataframe_active_' || row_number() OVER () AS dataframe_name,
    floor(random() * 30000 + 1)::integer AS datasource_id,
    floor(random() * 40 + 11)::integer AS project_id,
    NOW() - (random() * INTERVAL '365 days') AS created_at,
    NOW() - (random() * INTERVAL '30 days') AS updated_at
FROM generate_series(1, 40000);

-- 通常のプロジェクト (51-200): 2万件
INSERT INTO perf_dataframes (
    dataframe_name,
    datasource_id,
    project_id,
    created_at,
    updated_at
)
SELECT
    'dataframe_normal_' || row_number() OVER () AS dataframe_name,
    floor(random() * 30000 + 1)::integer AS datasource_id,
    floor(random() * 150 + 51)::integer AS project_id,
    NOW() - (random() * INTERVAL '365 days') AS created_at,
    NOW() - (random() * INTERVAL '30 days') AS updated_at
FROM generate_series(1, 20000);

-- 低活動プロジェクト (201-1000): 1万件
INSERT INTO perf_dataframes (
    dataframe_name,
    datasource_id,
    project_id,
    created_at,
    updated_at
)
SELECT
    'dataframe_low_' || row_number() OVER () AS dataframe_name,
    floor(random() * 30000 + 1)::integer AS datasource_id,
    floor(random() * 800 + 201)::integer AS project_id,
    NOW() - (random() * INTERVAL '365 days') AS created_at,
    NOW() - (random() * INTERVAL '30 days') AS updated_at
FROM generate_series(1, 10000);

-- 統計情報の更新
ANALYZE perf_datasource;
ANALYZE perf_dataframes;

-- トランザクションコミット
COMMIT;

-- データ件数とproject_idの分布確認
SELECT 'DataSources count:' AS info, COUNT(*) AS count FROM perf_datasource
UNION ALL
SELECT 'DataFrames count:', COUNT(*) FROM perf_dataframes;

-- project_idの分布確認
SELECT
    CASE
        WHEN project_id BETWEEN 1 AND 10 THEN '1-10 (Hot)'
        WHEN project_id BETWEEN 11 AND 50 THEN '11-50 (Active)'
        WHEN project_id BETWEEN 51 AND 200 THEN '51-200 (Normal)'
        WHEN project_id BETWEEN 201 AND 1000 THEN '201-1000 (Low)'
        ELSE 'Other'
    END AS project_group,
    COUNT(*) AS dataframe_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM perf_dataframes), 2) AS percentage
FROM perf_dataframes
GROUP BY project_group
ORDER BY
    CASE project_group
        WHEN '1-10 (Hot)' THEN 1
        WHEN '11-50 (Active)' THEN 2
        WHEN '51-200 (Normal)' THEN 3
        WHEN '201-1000 (Low)' THEN 4
        ELSE 5
    END;

-- 上位10プロジェクトのデータフレーム数
SELECT
    project_id,
    COUNT(*) AS dataframe_count
FROM perf_dataframes
GROUP BY project_id
ORDER BY dataframe_count DESC
LIMIT 10;