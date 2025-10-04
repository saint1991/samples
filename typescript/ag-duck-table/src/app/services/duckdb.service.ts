import { Injectable } from '@angular/core';
import * as duckdb from '@duckdb/duckdb-wasm';
import { AsyncDuckDB } from '@duckdb/duckdb-wasm';

@Injectable({
  providedIn: 'root'
})
export class DuckDBService {
  private db: AsyncDuckDB | null = null;

  async initialize(): Promise<void> {
    if (this.db) {
      return;
    }

    const JSDELIVR_BUNDLES = duckdb.getJsDelivrBundles();
    const bundle = await duckdb.selectBundle(JSDELIVR_BUNDLES);

    const worker_url = URL.createObjectURL(
      new Blob([`importScripts("${bundle.mainWorker}");`], { type: 'text/javascript' })
    );

    const worker = new Worker(worker_url);
    const logger = new duckdb.ConsoleLogger();
    this.db = new duckdb.AsyncDuckDB(logger, worker);
    await this.db.instantiate(bundle.mainModule, bundle.pthreadWorker);
    URL.revokeObjectURL(worker_url);
  }

  async query<T = any>(sql: string): Promise<T[]> {
    if (!this.db) {
      await this.initialize();
    }

    const conn = await this.db!.connect();
    try {
      const result = await conn.query(sql);
      return result.toArray().map(row => row.toJSON() as T);
    } finally {
      await conn.close();
    }
  }

  async createTableFromData<T extends Record<string, any>>(
    tableName: string,
    data: T[]
  ): Promise<void> {
    if (!this.db) {
      await this.initialize();
    }

    const conn = await this.db!.connect();
    try {
      // Register table from JavaScript array
      await this.db!.registerFileText(`${tableName}.json`, JSON.stringify(data));
      await conn.query(`CREATE TABLE IF NOT EXISTS ${tableName} AS SELECT * FROM read_json('${tableName}.json')`);
    } finally {
      await conn.close();
    }
  }

  async pivot<T = any>(config: {
    tableName: string;
    rowFields: string[];
    columnField: string;
    valueField: string;
    aggregateFunc?: 'SUM' | 'AVG' | 'COUNT' | 'MIN' | 'MAX';
  }): Promise<T[]> {
    const { tableName, rowFields, columnField, valueField, aggregateFunc = 'SUM' } = config;

    // Get unique column values
    const columnValues = await this.query<{ value: string }>(
      `SELECT DISTINCT ${columnField} as value FROM ${tableName} ORDER BY value`
    );

    // Build pivot query
    const pivotColumns = columnValues
      .map(({ value }) =>
        `${aggregateFunc}(CASE WHEN ${columnField} = '${value}' THEN ${valueField} ELSE 0 END) AS "${value}"`
      )
      .join(', ');

    const groupByClause = rowFields.join(', ');
    const sql = `
      SELECT
        ${groupByClause},
        ${pivotColumns}
      FROM ${tableName}
      GROUP BY ${groupByClause}
    `;

    return this.query<T>(sql);
  }
}
