import { Routes } from '@angular/router';
import { AboutComponent } from './about/about.component';
import { App } from './app';
import { Profile } from './profile/profile';
import { TableComponent } from './table/table.component';
import { PivotTableComponent } from './pivot-table/pivot-table.component';

export const routes: Routes = [
  {
    path: '',
    component: PivotTableComponent
  },
  {
    path: 'table',
    component: TableComponent
  },
  {
    path: 'home',
    component: App
  },
  {
    path: 'about/:id',
    component: AboutComponent
  },
  {
    path: 'profile/:id',
    component: Profile
  }
];
