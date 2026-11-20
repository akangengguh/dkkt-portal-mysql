import "dotenv/config";

import mariadb from "mariadb";
import { randomUUID } from "node:crypto";
import { Temporal } from "temporal-polyfill/full";

import { DB_MODELS, type DbModelName } from "./db-schema";

type QueryExecutor = {
  query: (sql: string, values?: any[]) => Promise<any>;
};
type DatabaseApi = {
  orm: { public: any };
  transaction: <T>(callback: (tx: DatabaseApi) => Promise<T>) => Promise<T>;
  close: () => Promise<void>;
  healthCheck: () => Promise<Record<string, unknown> | null>;
};

type Filter = Record<string, unknown>;
type ModelMetadata = {
  table: string;
  columns: readonly string[];
  primaryKey: readonly string[];
  booleanColumns: readonly string[];
  dateTimeColumns: readonly string[];
};

function getDatabaseConfig() {
  const urlValue = process.env.DATABASE_URL;
  const hasCompleteDiscreteConfig = Boolean(
    process.env.DB_HOST &&
    process.env.DB_PORT &&
    process.env.DB_USER &&
    process.env.DB_PASSWORD !== undefined &&
    process.env.DB_NAME,
  );
  const url = urlValue && !hasCompleteDiscreteConfig ? new URL(urlValue) : null;

  const host = process.env.DB_HOST || url?.hostname || "127.0.0.1";
  const port = Number(process.env.DB_PORT || url?.port || 3306);
  const user = process.env.DB_USER || (url ? decodeURIComponent(url.username) : "");
  const password = process.env.DB_PASSWORD || (url ? decodeURIComponent(url.password) : "");
  const database = process.env.DB_NAME || (url ? decodeURIComponent(url.pathname.replace(/^\//, "")) : "");

  if (!user || !database) {
    throw new Error(
      "Konfigurasi database belum lengkap. Isi DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, DB_NAME, atau DATABASE_URL.",
    );
  }

  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error("DB_PORT tidak valid. Gunakan port database yang benar, biasanya 3306.");
  }

  const connectionLimit = Number(process.env.DB_CONNECTION_LIMIT || 5);
  if (!Number.isInteger(connectionLimit) || connectionLimit < 1) {
    throw new Error("DB_CONNECTION_LIMIT harus berupa bilangan bulat minimal 1.");
  }

  return {
    host,
    port,
    user,
    password,
    database,
    connectionLimit,
    acquireTimeout: 10_000,
    connectTimeout: 10_000,
    timezone: "Z" as const,
    charset: "utf8mb4",
    bigIntAsNumber: true,
  };
}

function normalizeValue(value: unknown): unknown {
  if (value instanceof Date) return value;
  if (Array.isArray(value)) return value.map(normalizeValue);

  if (value && typeof value === "object") {
    const temporalValue = value as { epochMilliseconds?: unknown };
    if (typeof temporalValue.epochMilliseconds === "number") {
      return new Date(temporalValue.epochMilliseconds);
    }

    if (Object.getPrototypeOf(value) === Object.prototype) {
      return Object.fromEntries(
        Object.entries(value).map(([key, nestedValue]) => [key, normalizeValue(nestedValue)]),
      );
    }
  }

  return value;
}

function normalizeRow(row: Record<string, unknown>, metadata: ModelMetadata) {
  for (const field of metadata.booleanColumns) {
    if (row[field] !== null && row[field] !== undefined) {
      row[field] = Boolean(row[field]);
    }
  }
  for (const field of metadata.dateTimeColumns) {
    if (row[field] instanceof Date) {
      row[field] = Temporal.Instant.fromEpochMilliseconds((row[field] as Date).getTime());
    }
  }
  return row;
}

function predicateToFilter(predicate: (row: any) => unknown): Filter {
  const row = new Proxy(
    {},
    {
      get(_target, property) {
        if (typeof property !== "string") return undefined;
        return {
          in: (values: unknown[]) => ({ [property]: { in: values } }),
          notIn: (values: unknown[]) => ({ [property]: { notIn: values } }),
          equals: (value: unknown) => ({ [property]: value }),
          gt: (value: unknown) => ({ [property]: { gt: value } }),
          gte: (value: unknown) => ({ [property]: { gte: value } }),
          lt: (value: unknown) => ({ [property]: { lt: value } }),
          lte: (value: unknown) => ({ [property]: { lte: value } }),
          contains: (value: string) => ({ [property]: { contains: value } }),
          startsWith: (value: string) => ({ [property]: { startsWith: value } }),
          endsWith: (value: string) => ({ [property]: { endsWith: value } }),
        };
      },
    },
  );

  const result = predicate(row);
  if (!result || typeof result !== "object" || Array.isArray(result)) {
    throw new Error("Filter callback harus menghasilkan kondisi database yang valid.");
  }
  return result as Filter;
}

function compileWhere(metadata: ModelMetadata, filters: Filter[]) {
  const clauses: string[] = [];
  const values: unknown[] = [];

  for (const filter of filters) {
    for (const [field, rawValue] of Object.entries(filter)) {
      if (rawValue === undefined) continue;
      if (!metadata.columns.includes(field)) {
        throw new Error(`Kolom '${field}' tidak dikenal pada model database.`);
      }

      const column = `\`${field}\``;

      if (rawValue === null) {
        clauses.push(`${column} IS NULL`);
        continue;
      }

      if (Array.isArray(rawValue)) {
        if (rawValue.length === 0) {
          clauses.push("1 = 0");
        } else {
          clauses.push(`${column} IN (${rawValue.map(() => "?").join(", ")})`);
          values.push(...rawValue.map(normalizeValue));
        }
        continue;
      }

      if (typeof rawValue === "object" && !(rawValue instanceof Date)) {
        const operators = rawValue as Record<string, unknown>;
        for (const [operator, value] of Object.entries(operators)) {
          if (value === undefined) continue;
          if (operator === "in" || operator === "notIn") {
            const list = Array.isArray(value) ? value : [];
            if (list.length === 0) {
              clauses.push(operator === "in" ? "1 = 0" : "1 = 1");
            } else {
              const not = operator === "notIn" ? "NOT " : "";
              clauses.push(`${column} ${not}IN (${list.map(() => "?").join(", ")})`);
              values.push(...list.map(normalizeValue));
            }
            continue;
          }

          const sqlOperator = {
            equals: "=",
            gt: ">",
            gte: ">=",
            lt: "<",
            lte: "<=",
          }[operator];

          if (sqlOperator) {
            if (value === null && operator === "equals") {
              clauses.push(`${column} IS NULL`);
            } else {
              clauses.push(`${column} ${sqlOperator} ?`);
              values.push(normalizeValue(value));
            }
            continue;
          }

          if (operator === "contains" || operator === "startsWith" || operator === "endsWith") {
            const stringValue = String(value);
            const likeValue = operator === "contains"
              ? `%${stringValue}%`
              : operator === "startsWith"
                ? `${stringValue}%`
                : `%${stringValue}`;
            clauses.push(`${column} LIKE ?`);
            values.push(likeValue);
            continue;
          }

          throw new Error(`Operator filter '${operator}' belum didukung.`);
        }
        continue;
      }

      clauses.push(`${column} = ?`);
      values.push(normalizeValue(rawValue));
    }
  }

  return {
    sql: clauses.length ? ` WHERE ${clauses.join(" AND ")}` : "",
    values,
  };
}

function assertColumns(metadata: ModelMetadata, fields: string[]) {
  for (const field of fields) {
    if (!metadata.columns.includes(field)) {
      throw new Error(`Kolom '${field}' tidak dikenal pada model database.`);
    }
  }
}

function createModelApi(executor: QueryExecutor, modelName: DbModelName) {
  const metadata = DB_MODELS[modelName] as unknown as ModelMetadata;

  const buildQuery = (filters: Filter[] = [], selectedFields?: string[]) => {
    const normalizedFilters = filters.map((filter) => filter);

    const where = (condition: Filter | ((row: any) => unknown)) => {
      const filter = typeof condition === "function"
        ? predicateToFilter(condition)
        : condition;
      return buildQuery([...normalizedFilters, filter], selectedFields);
    };

    const select = (...fields: string[]) => {
      assertColumns(metadata, fields);
      return buildQuery(normalizedFilters, fields);
    };

    const all = async () => {
      const selection = selectedFields?.length ? selectedFields : [...metadata.columns];
      assertColumns(metadata, selection);
      const compiled = compileWhere(metadata, normalizedFilters);
      const rows = await executor.query(
        `SELECT ${selection.map((field) => `\`${field}\``).join(", ")} FROM \`${metadata.table}\`${compiled.sql}`,
        compiled.values,
      );
      return (rows as Record<string, unknown>[]).map((row) => normalizeRow(row, metadata));
    };

    const first = async (condition?: Filter | ((row: any) => unknown)) => {
      const filtersWithCondition = condition === undefined
        ? normalizedFilters
        : [
            ...normalizedFilters,
            typeof condition === "function" ? predicateToFilter(condition) : condition,
          ];
      const compiled = compileWhere(metadata, filtersWithCondition);
      const selection = selectedFields?.length ? selectedFields : [...metadata.columns];
      assertColumns(metadata, selection);
      const rows = await executor.query(
        `SELECT ${selection.map((field) => `\`${field}\``).join(", ")} FROM \`${metadata.table}\`${compiled.sql} LIMIT 1`,
        compiled.values,
      );
      const row = (rows as Record<string, unknown>[])[0];
      return row ? normalizeRow(row, metadata) : null;
    };

    const create = async (input: Record<string, unknown>) => {
      const data = normalizeValue(input) as Record<string, unknown>;
      if (metadata.columns.includes("id") && !data.id) {
        data.id = randomUUID();
      }
      const entries = Object.entries(data).filter(([field, value]) => {
        if (!metadata.columns.includes(field)) {
          throw new Error(`Kolom '${field}' tidak dikenal pada model database.`);
        }
        return value !== undefined;
      });

      const columns = entries.map(([field]) => `\`${field}\``);
      const placeholders = entries.map(() => "?");
      const values = entries.map(([, value]) => value);
      const insertSql = columns.length
        ? `INSERT INTO \`${metadata.table}\` (${columns.join(", ")}) VALUES (${placeholders.join(", ")})`
        : `INSERT INTO \`${metadata.table}\` () VALUES ()`;

      await executor.query(insertSql, values);

      const primaryFilter: Filter = {};
      for (const field of metadata.primaryKey) {
        if (data[field] === undefined) {
          throw new Error(`Primary key '${field}' tidak tersedia setelah membuat ${modelName}.`);
        }
        primaryFilter[field] = data[field];
      }

      return first(primaryFilter);
    };

    const update = async (input: Record<string, unknown>) => {
      if (normalizedFilters.length === 0) {
        throw new Error(`Update ${modelName} ditolak karena tidak memiliki kondisi WHERE.`);
      }

      const data = normalizeValue(input) as Record<string, unknown>;
      const entries = Object.entries(data).filter(([field, value]) => {
        if (!metadata.columns.includes(field)) {
          throw new Error(`Kolom '${field}' tidak dikenal pada model database.`);
        }
        return value !== undefined;
      });
      if (entries.length === 0) return first();

      const compiled = compileWhere(metadata, normalizedFilters);
      await executor.query(
        `UPDATE \`${metadata.table}\` SET ${entries.map(([field]) => `\`${field}\` = ?`).join(", ")}${compiled.sql}`,
        [...entries.map(([, value]) => value), ...compiled.values],
      );
      return first();
    };

    const remove = async () => {
      if (normalizedFilters.length === 0) {
        throw new Error(`Delete ${modelName} ditolak karena tidak memiliki kondisi WHERE.`);
      }
      const compiled = compileWhere(metadata, normalizedFilters);
      return executor.query(`DELETE FROM \`${metadata.table}\`${compiled.sql}`, compiled.values);
    };

    return { where, select, all, first, create, update, delete: remove };
  };

  return buildQuery();
}

function createDatabase(executor: QueryExecutor, pool?: ReturnType<typeof mariadb.createPool>): DatabaseApi {
  const publicApi = new Proxy(
    {},
    {
      get(_target, property) {
        if (typeof property !== "string" || !(property in DB_MODELS)) return undefined;
        return createModelApi(executor, property as DbModelName);
      },
    },
  );

  return {
    orm: { public: publicApi },
    transaction: async <T>(callback: (tx: DatabaseApi) => Promise<T>) => {
      if (!pool) throw new Error("Nested transaction tidak didukung.");
      const connection = await pool.getConnection();
      let transactionStarted = false;
      try {
        await connection.beginTransaction();
        transactionStarted = true;
        const result = await callback(createDatabase(connection));
        await connection.commit();
        transactionStarted = false;
        return result;
      } catch (error) {
        if (transactionStarted) {
          try {
            await connection.rollback();
          } catch (rollbackError) {
            console.error("MariaDB transaction rollback failed:", rollbackError);
          }
        }
        throw error;
      } finally {
        connection.release();
      }
    },
    close: async () => {
      if (pool) await pool.end();
    },
    healthCheck: async () => {
      const rows = await executor.query("SELECT VERSION() AS version, DATABASE() AS databaseName");
      return (rows as Record<string, unknown>[])[0] ?? null;
    },
  };
}

const globalForDb = globalThis as typeof globalThis & {
  __dkktMariaDbPool?: ReturnType<typeof mariadb.createPool>;
};

const pool = globalForDb.__dkktMariaDbPool ?? mariadb.createPool(getDatabaseConfig());

if (process.env.NODE_ENV !== "production") {
  globalForDb.__dkktMariaDbPool = pool;
}

export const db = createDatabase(pool, pool);
