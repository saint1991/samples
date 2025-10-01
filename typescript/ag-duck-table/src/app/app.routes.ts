import { Routes } from '@angular/router';
import { AboutComponent } from './about/about.component';
import { App } from './app';
import { Profile } from './profile/profile';

export const routes: Routes = [
  {
    path: '',
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
