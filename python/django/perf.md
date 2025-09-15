
#Django
# 計測データ

DataSources: 30000件
DataFrames: 100000件

結論。試行錯誤してみたが、
- ForeignKeyなし
- RawQuerySetの利用なし
を満たしつつ、理想のクエリにするのは無理そう。

## 実装1. RawQuerySet 

おそらくこれがパフォーマンス的には理想だが、実装的にはイマイチ。

```sql
SELECT
  ds.*,
  COALESCE(df_counts.unique_project_count, 0) AS unique_project_count
FROM
  perf_datasource ds
  LEFT JOIN (
    SELECT
      datasource_id,
      COUNT(DISTINCT project_id) AS unique_project_count
    FROM
      perf_dataframes
    GROUP BY
      datasource_id
) df_counts 
  ON ds.datasource_id = df_counts.datasource_id
ORDER BY unique_project_count ASC
LIMIT 50
```
 
(LIMIT 50) 90 ~ 100ms程度
(LIMITなし)

## 実装2. 外部キー + JOIN 

これが理想実装だが、外部キーを足さないといけないのがネック。

```sql
SELECT
  "perf_datasource"."datasource_id",
  "perf_datasource"."datasource_name",
  "perf_datasource"."type",
  "perf_datasource"."created_at",
  "perf_datasource"."updated_at", 
  "perf_datasource"."size",
  COALESCE(COUNT(DISTINCT "perf_dataframes"."project_id"), 0) AS "unique_project_count"
FROM
  "perf_datasource"
LEFT OUTER JOIN "perf_dataframes" ON (
  "perf_datasource"."datasource_id" = "perf_dataframes"."datasource_id"
)
GROUP BY "perf_datasource"."datasource_id"
ORDER BY 7 ASC
LIMIT 50
```

モデル側をこうしないといけない
```python
from django.db import models

class DataSource(models.Model):
  datasource_id = models.AutoField(primary_key=True)
  datasource_name = models.CharField(max_length=100)
  type = models.CharField(max_length=20, choices=[("file", "file"), ("database", "database"), ("url", "url"), ("folder", "folder")])
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)
  size = models.BigIntegerField()

class DataFrames(models.Model):
  dataframe_id = models.AutoField(primary_key=True)
  dataframe_name = models.CharField(max_length=100)
  datasource = models.ForeignKey(DataSource, on_delete=models.CASCADE, to_field='datasource_id', db_column='datasource_id', related_name='dataframes', default=1)
  project_id = models.IntegerField()
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)
```

そうできればクエリ側はこれでいける
```python
queryset = DataSource.objects.annotate(
  unique_project_count=Coalesce(
    Count('dataframes__project_id',distinct=True), 
    Value(0)
  )
)
```

70 ~ 80ms

## 実装3 OuterRef + SubQuery

```python
queryset = DataSource.objects.annotate(
  unique_project_count=Coalesce(
    Subquery(
      DataFrames.objects.filter(
        datasource_id=OuterRef('datasource_id')
      ).values('datasource_id').annotate(
        count=Count('project_id', distinct=True)
      ).values('count')
    ),
    Value(0)
  )
)
```

現行の実装はこれ。一番実装のコスト的には軽い。
(LIMIT 50) 130 ~ 150ms
(LIMITなし) 210 ~ 240ms

少なくともLIMIT 50の範疇ではこれでも許容範囲

## 実装4 アプリケーションでJOIN (元実装)

DataSources、DataFramesそれぞれでクエリを発行して、DataSource側にカウントをくっつけるパターン。

110ms ~ 130ms