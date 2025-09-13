import time
from django.db.models import Count, OuterRef, Subquery, Q, Value
from django.db.models.functions import Coalesce
from rest_framework.decorators import api_view
from rest_framework.request import Request
from rest_framework.response import Response

from .models import DataSource, DataFrames

@api_view(['GET'])
def list_datasources(request: Request) -> Response:
    """
    要件:
        unique_project_countでソートした後、上位N件を取得するためPython側でのJOINは不可
    """

    ordering = request.GET.get('ordering', 'asc')
    limit = request.GET.get('limit', 50)

    if limit:
        try:
            limit = int(limit)
        except ValueError:
            limit = 50

    # クエリ実行時間を計測
    query_start = time.perf_counter()

    # パフォーマンス最適化されたアプローチ（純粋なQuerySet API）：
    # DataFramesから各datasource_idのユニークproject_idをカウントしてSubqueryで注入

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

    # ソート順を適用
    if ordering == 'desc':
        queryset = queryset.order_by('-unique_project_count')
    else:
        queryset = queryset.order_by('unique_project_count')

    # LIMIT適用
    queryset = queryset[:limit]

    # データを辞書形式に変換
    values = list(queryset.values(
        'datasource_id',
        'datasource_name',
        'type',
        'created_at',
        'updated_at',
        'size',
        'unique_project_count'
    ))

    query_end = time.perf_counter()

    # 実行されたSQLクエリを取得（デバッグ用）
    executed_query = str(queryset.query) if hasattr(queryset, 'query') else 'Query not available'

    return Response({
        'query': executed_query,
        'execution_time_seconds': query_end - query_start,
        'execution_time_ms': (query_end - query_start) * 1000,
        'count': len(values),
        'data': values,
    })


