import {
  AngularNodeAppEngine,
  createNodeRequestHandler,
  isMainModule,
  writeResponseToNodeResponse,
} from '@angular/ssr/node';
import express from 'express';
import { join } from 'node:path';

const browserDistFolder = join(import.meta.dirname, '../browser');

const app = express();
const angularApp = new AngularNodeAppEngine();

// CORS middleware
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
    return;
  }

  next();
});

// Logging middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.url} - User-Agent: ${req.get('User-Agent')}`);
  next();
});

/**
 * Example Express Rest API endpoints can be defined here.
 * Uncomment and define endpoints as necessary.
 *
 * Example:
 * ```ts
 * app.get('/api/{*splat}', (req, res) => {
 *   // Handle API request
 * });
 * ```
 */

// User info API endpoint
app.get('/user-info', (req, res) => {
  const userId = req.query['userId'] as string;
  const startTime = Date.now();

  console.log(`[API] User info request for userId: ${userId}`);

  if (!userId) {
    const duration = Date.now() - startTime;
    console.error(`[API] Missing userId parameter after ${duration}ms`);
    res.status(400).json({ error: 'userId parameter is required' });
    return;
  }

  // Mock user data - replace with actual database/service call
  const userInfo = {
    userId,
    userName: `User ${userId}`,
    email: `user${userId}@example.com`,
    createdAt: new Date().toISOString()
  };

  const duration = Date.now() - startTime;
  console.log(`[API] Returning user info for ${userId} in ${duration}ms`);

  res.json(userInfo);
});

/**
 * Serve static files from /browser
 */
app.use(
  express.static(browserDistFolder, {
    maxAge: '1y',
    index: false,
    redirect: false,
  }),
);

/**
 * Handle all other requests by rendering the Angular application.
 */
app.use((req, res, next) => {
  const startTime = Date.now();
  console.log(`[SSR] Starting Angular rendering for: ${req.url}`);

  angularApp
    .handle(req)
    .then((response) => {
      const duration = Date.now() - startTime;
      if (response) {
        console.log(`[SSR] Angular rendering completed in ${duration}ms for: ${req.url}`);
        writeResponseToNodeResponse(response, res);
      } else {
        console.log(`[SSR] No Angular response, passing to next middleware: ${req.url}`);
        next();
      }
    })
    .catch((error) => {
      const duration = Date.now() - startTime;
      console.error(`[SSR] Angular rendering failed after ${duration}ms for: ${req.url}`, error);
      next(error);
    });
});

/**
 * Start the server if this module is the main entry point.
 * The server listens on the port defined by the `PORT` environment variable, or defaults to 4000.
 */
if (isMainModule(import.meta.url)) {
  const port = process.env['PORT'] || 4000;
  app.listen(port, (error) => {
    if (error) {
      throw error;
    }

    console.log(`Node Express server listening on http://localhost:${port}`);
  });
}

/**
 * Request handler used by the Angular CLI (for dev-server and during build) or Firebase Cloud Functions.
 */
export const reqHandler = createNodeRequestHandler(app);
