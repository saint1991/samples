import { Component, OnInit, signal } from '@angular/core';
import { AgGridAngular } from 'ag-grid-angular';
import { AllCommunityModule, ModuleRegistry, type ColDef } from 'ag-grid-community';
import { DuckDBService } from '../services/duckdb.service';

ModuleRegistry.registerModules([AllCommunityModule]);

interface SalesData {
  region: string;
  product: string;
  quarter: string;
  sales: number;
}

@Component({
  selector: 'app-pivot-table',
  imports: [AgGridAngular],
  templateUrl: './pivot-table.component.html',
  styleUrl: './pivot-table.component.css'
})
export class PivotTableComponent implements OnInit {
  protected readonly themeClass = 'ag-theme-quartz';
  protected readonly columnDefs = signal<ColDef[]>([]);
  protected readonly rowData = signal<any[]>([]);
  protected readonly loading = signal(true);

  private readonly sampleData: SalesData[] = [
    { region: 'North', product: 'Product A', quarter: 'Q1', sales: 10000 },
    { region: 'North', product: 'Product A', quarter: 'Q2', sales: 15000 },
    { region: 'North', product: 'Product A', quarter: 'Q3', sales: 12000 },
    { region: 'North', product: 'Product A', quarter: 'Q4', sales: 18000 },
    { region: 'North', product: 'Product B', quarter: 'Q1', sales: 8000 },
    { region: 'North', product: 'Product B', quarter: 'Q2', sales: 9000 },
    { region: 'North', product: 'Product B', quarter: 'Q3', sales: 11000 },
    { region: 'North', product: 'Product B', quarter: 'Q4', sales: 13000 },
    { region: 'South', product: 'Product A', quarter: 'Q1', sales: 12000 },
    { region: 'South', product: 'Product A', quarter: 'Q2', sales: 14000 },
    { region: 'South', product: 'Product A', quarter: 'Q3', sales: 16000 },
    { region: 'South', product: 'Product A', quarter: 'Q4', sales: 20000 },
    { region: 'South', product: 'Product B', quarter: 'Q1', sales: 7000 },
    { region: 'South', product: 'Product B', quarter: 'Q2', sales: 8500 },
    { region: 'South', product: 'Product B', quarter: 'Q3', sales: 9500 },
    { region: 'South', product: 'Product B', quarter: 'Q4', sales: 11000 },
    { region: 'East', product: 'Product A', quarter: 'Q1', sales: 9000 },
    { region: 'East', product: 'Product A', quarter: 'Q2', sales: 11000 },
    { region: 'East', product: 'Product A', quarter: 'Q3', sales: 13000 },
    { region: 'East', product: 'Product A', quarter: 'Q4', sales: 15000 },
    { region: 'East', product: 'Product B', quarter: 'Q1', sales: 6000 },
    { region: 'East', product: 'Product B', quarter: 'Q2', sales: 7000 },
    { region: 'East', product: 'Product B', quarter: 'Q3', sales: 8000 },
    { region: 'East', product: 'Product B', quarter: 'Q4', sales: 9500 },
    { region: 'West', product: 'Product A', quarter: 'Q1', sales: 11000 },
    { region: 'West', product: 'Product A', quarter: 'Q2', sales: 13000 },
    { region: 'West', product: 'Product A', quarter: 'Q3', sales: 14000 },
    { region: 'West', product: 'Product A', quarter: 'Q4', sales: 17000 },
    { region: 'West', product: 'Product B', quarter: 'Q1', sales: 7500 },
    { region: 'West', product: 'Product B', quarter: 'Q2', sales: 8500 },
    { region: 'West', product: 'Product B', quarter: 'Q3', sales: 9500 },
    { region: 'West', product: 'Product B', quarter: 'Q4', sales: 12000 }
  ];

  constructor(private duckdbService: DuckDBService) {}

  async ngOnInit(): Promise<void> {
    try {
      await this.duckdbService.initialize();
      await this.duckdbService.createTableFromData('sales', this.sampleData);

      const pivotData = await this.duckdbService.pivot({
        tableName: 'sales',
        rowFields: ['region', 'product'],
        columnField: 'quarter',
        valueField: 'sales',
        aggregateFunc: 'SUM'
      });

      // Create column definitions dynamically
      const quarters = ['Q1', 'Q2', 'Q3', 'Q4'];
      const colDefs: ColDef[] = [
        { field: 'region', headerName: 'Region', pinned: 'left', width: 120 },
        { field: 'product', headerName: 'Product', pinned: 'left', width: 120 },
        ...quarters.map(q => ({
          field: q,
          headerName: q,
          type: 'numericColumn',
          valueFormatter: (params: any) => {
            const value = params.value;
            if (value == null || value === 0) return '$0';
            return `$${Number(value).toLocaleString('en-US')}`;
          }
        }))
      ];

      this.columnDefs.set(colDefs);
      this.rowData.set(pivotData);
    } catch (error) {
      console.error('Failed to initialize pivot table:', error);
    } finally {
      this.loading.set(false);
    }
  }

  protected readonly defaultColDef = signal<ColDef>({
    flex: 1,
    minWidth: 100,
    sortable: true,
    filter: true,
    resizable: true
  });
}
