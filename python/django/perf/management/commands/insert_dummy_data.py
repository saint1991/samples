from django.core.management.base import BaseCommand
from django.utils import timezone
from perf.models import DataSource, DataFrames
import random
from datetime import timedelta
from django.db import transaction

class Command(BaseCommand):
    help = 'Insert large dummy records into DataSource and DataFrames tables'

    def add_arguments(self, parser):
        parser.add_argument(
            '--batch-size',
            type=int,
            default=1000,
            help='Batch size for bulk insert (default: 1000)'
        )
        parser.add_argument(
            '--datasources',
            type=int,
            default=30000,
            help='Number of DataSource records (default: 30000)'
        )
        parser.add_argument(
            '--dataframes',
            type=int,
            default=500000,
            help='Number of DataFrames records (default: 500000)'
        )

    def handle(self, *args, **options):
        batch_size = options['batch_size']
        num_datasources = options['datasources']
        num_dataframes = options['dataframes']
        
        self.stdout.write(f'Inserting {num_datasources:,} DataSource records...')
        
        # DataSourceのダミーデータ生成
        datasources = []
        types = ['file', 'database', 'url', 'folder']
        
        for i in range(1, num_datasources + 1):
            datasource = DataSource(
                datasource_name=f'DataSource_{i}',
                type=types[i % 4],
                size=random.randint(1000, 1000000000)
            )
            datasources.append(datasource)
            
            if len(datasources) >= batch_size:
                DataSource.objects.bulk_create(datasources)
                datasources = []
                if i % 5000 == 0:  # 5000件ごとに進捗表示
                    self.stdout.write(f'Inserted {i:,} DataSource records...')
        
        # 残りを挿入
        if datasources:
            DataSource.objects.bulk_create(datasources)
        
        self.stdout.write(self.style.SUCCESS(f'Successfully inserted {num_datasources:,} DataSource records'))
        
        # DataFramesのダミーデータ生成
        self.stdout.write(f'Inserting {num_dataframes:,} DataFrames records...')
        
        # 挿入されたDataSourceのIDを取得
        datasource_ids = list(DataSource.objects.values_list('datasource_id', flat=True))
        
        if not datasource_ids:
            self.stdout.write(self.style.ERROR('No DataSource records found. Please insert DataSource records first.'))
            return
        
        dataframes = []
        for i in range(1, num_dataframes + 1):
            dataframe = DataFrames(
                dataframe_name=f'DataFrame_{i}',
                datasource_id=random.choice(datasource_ids),
                project_id=random.randint(1, 500)  # 1-500のプロジェクトID（プロジェクト数を増やす）
            )
            dataframes.append(dataframe)
            
            if len(dataframes) >= batch_size:
                DataFrames.objects.bulk_create(dataframes)
                dataframes = []
                if i % 50000 == 0:  # 50000件ごとに進捗表示
                    self.stdout.write(f'Inserted {i:,} DataFrames records...')
        
        # 残りを挿入
        if dataframes:
            DataFrames.objects.bulk_create(dataframes)
        
        self.stdout.write(self.style.SUCCESS(f'Successfully inserted {num_dataframes:,} DataFrames records'))
        
        # 統計情報を表示
        total_datasources = DataSource.objects.count()
        total_dataframes = DataFrames.objects.count()
        
        self.stdout.write(f'\nTotal DataSource records: {total_datasources:,}')
        self.stdout.write(f'Total DataFrames records: {total_dataframes:,}')
        
        # DataFramesの統計
        from django.db.models import Count, Avg
        stats = DataFrames.objects.aggregate(
            unique_projects=Count('project_id', distinct=True),
            avg_dataframes_per_datasource=Count('dataframe_id') / float(total_datasources)
        )
        self.stdout.write(f'Unique projects: {stats["unique_projects"]}')
        self.stdout.write(f'Average DataFrames per DataSource: {stats["avg_dataframes_per_datasource"]:.2f}')