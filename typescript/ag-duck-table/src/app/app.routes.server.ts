import { PrerenderFallback, RenderMode, ServerRoute } from '@angular/ssr';

export const serverRoutes: ServerRoute[] = [
  {
    path: '', // root
    renderMode: RenderMode.Client,
  },
  {
    path: 'about/:id', // SSG
    renderMode: RenderMode.Prerender,
    getPrerenderParams: async () => {
      return Promise.resolve([{ id: '1' }, { id: '2' }]);
    },
    fallback: PrerenderFallback.Server
  },
  {
    path: 'profile/:id',
    renderMode: RenderMode.Server,
    status: 200,
  },
  {
    path: '**',
    renderMode: RenderMode.Client,
  }
];
