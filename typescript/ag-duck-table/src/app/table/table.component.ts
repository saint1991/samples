import { Component, signal } from '@angular/core';
import { AgGridAngular } from 'ag-grid-angular';
import { AllCommunityModule, ModuleRegistry, type ColDef } from 'ag-grid-community';

ModuleRegistry.registerModules([AllCommunityModule]);

interface RowData {
  make: string;
  model: string;
  price: number;
  year: number;
}

@Component({
  selector: 'app-table',
  imports: [AgGridAngular],
  templateUrl: './table.component.html',
  styleUrl: './table.component.css'
})
export class TableComponent {
  protected readonly themeClass = 'ag-theme-quartz';

  protected readonly columnDefs = signal<ColDef<RowData>[]>([
    { field: 'make', headerName: 'Make', sortable: true, filter: true },
    { field: 'model', headerName: 'Model', sortable: true, filter: true },
    { field: 'price', headerName: 'Price', sortable: true, filter: true },
    { field: 'year', headerName: 'Year', sortable: true, filter: true }
  ]);

  protected readonly rowData = signal<RowData[]>([
    { make: 'Toyota', model: 'Celica', price: 35000, year: 2020 },
    { make: 'Ford', model: 'Mondeo', price: 32000, year: 2019 },
    { make: 'Porsche', model: 'Boxster', price: 72000, year: 2021 },
    { make: 'BMW', model: 'M50', price: 60000, year: 2022 },
    { make: 'Audi', model: 'A4', price: 45000, year: 2021 }
  ]);

  protected readonly defaultColDef = signal<ColDef>({
    flex: 1,
    minWidth: 100
  });
}
