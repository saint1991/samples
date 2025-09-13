import time
from django.db.models import Count
from django.db.models import Subquery, OuterRef, IntegerField
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
        パフォーマンスの最適化のために、先にDataFrames側を集計してからDataSourceとJOINする。datasourcesの各行に対してDataFramesを集計するのはNG
    """

    ordering = request.GET.get('ordering', 'asc')
    limit = request.GET.get('limit', 50)
    
    if limit:
        try:
            limit = int(limit)
        except ValueError:
            limit = None
    
    order_by = 'unique_project_count'
    if ordering == 'desc':
        order_by = '-unique_project_count'

    # サブクエリで集計結果を作成（最適化版）
    project_counts = DataFrames.objects.values('datasource_id').annotate(
        count=Count('project_id', distinct=True)
    ).values('count')
    
    # QuerySetでannotateとorder_by、sliceが可能
    queryset = DataSource.objects.annotate(
        unique_project_count=Coalesce(
            Subquery(project_counts, output_field=IntegerField()),
            0
        )
    )
    query = str(queryset.query)
    
    if order_by:
        queryset = queryset.order_by(order_by)

    # LIMITの例（コメントアウト）
    if limit:
        queryset = queryset[:limit]  # 上位100件
    
    # クエリ実行時間を計測
    query_start = time.perf_counter()
    values = list(queryset.values())  # list()で強制的に評価
    query_end = time.perf_counter()
    
    return Response({
        'query': query,
        'execution_time_seconds': query_end - query_start,
        'execution_time_ms': (query_end - query_start) * 1000,
        'count': len(values),
        'data': values,
    })


