from django.core.management.base import BaseCommand
from django.utils import timezone
from blog.models import DataSource, DataFrames
import random
from datetime import timedelta
from django.db import transaction

class Command(BaseCommand):
    help = 'Insert 10,000 dummy records into DataSource and DataFrames tables'

    def add_arguments(self, parser):
        parser.add_argument(
            '--batch-size',
            type=int,
            default=1000,
            help='Batch size for bulk insert (default: 1000)'
        )

    def handle(self, *args, **options):
        batch_size = options['batch_size']
        
        self.stdout.write('Inserting 10,000 DataSource records...')
        
        # DataSourceのダミーデータ生成
        datasources = []
        types = ['file', 'database', 'url', 'folder']
        
        for i in range(1, 10001):
            datasource = DataSource(
                datasource_name=f'DataSource_{i}',
                type=types[i % 4],
                size=random.randint(1000, 1000000000)
            )
            datasources.append(datasource)
            
            if len(datasources) >= batch_size:
                DataSource.objects.bulk_create(datasources)
                datasources = []
                self.stdout.write(f'Inserted {i} DataSource records...')
        
        # 残りを挿入
        if datasources:
            DataSource.objects.bulk_create(datasources)
        
        self.stdout.write(self.style.SUCCESS('Successfully inserted 10,000 DataSource records'))
        
        # DataFramesのダミーデータ生成
        self.stdout.write('Inserting 10,000 DataFrames records...')
        
        # 挿入されたDataSourceのIDを取得
        datasource_ids = list(DataSource.objects.values_list('datasource_id', flat=True))
        
        dataframes = []
        for i in range(1, 10001):
            dataframe = DataFrames(
                dataframe_name=f'DataFrame_{i}',
                datasource_id=random.choice(datasource_ids),
                project_id=random.randint(1, 100)  # 1-100のプロジェクトID
            )
            dataframes.append(dataframe)
            
            if len(dataframes) >= batch_size:
                DataFrames.objects.bulk_create(dataframes)
                dataframes = []
                self.stdout.write(f'Inserted {i} DataFrames records...')
        
        # 残りを挿入
        if dataframes:
            DataFrames.objects.bulk_create(dataframes)
        
        self.stdout.write(self.style.SUCCESS('Successfully inserted 10,000 DataFrames records'))
        
        # 統計情報を表示
        total_datasources = DataSource.objects.count()
        total_dataframes = DataFrames.objects.count()
        
        self.stdout.write(f'\nTotal DataSource records: {total_datasources}')
        self.stdout.write(f'Total DataFrames records: {total_dataframes}')