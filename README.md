# SQL / MS SQL Server (T‑SQL)

A curated collection of my SQL scripts for **Microsoft SQL Server**.
This repo is organized by **topic**, so you can quickly see what I can do in T‑SQL.

## What's inside

### 1) Mini‑project: Office Expenses (incl. temporal tables)

A small relational model for office purchases and expense limits, plus a temporal version to track history over time.

- **Schema + sample data:** `projects/office-expenses/office_expenses_schema_and_seed.sql`
- **Temporal schema + changes:** `projects/office-expenses/temporal/01_create_temporal_schema_and_changes.sql`
- **Time‑travel queries:** `projects/office-expenses/temporal/02_time_travel_queries.sql`

### 2) Practice scripts (SQL tasks) by topic

Solutions to classic SQL tasks (filtering, joins, aggregation, CTE/recursion, etc.):

- `practice/sql-ex/by-topic/01-filtering/`
- `practice/sql-ex/by-topic/02-aggregation/`
- `practice/sql-ex/by-topic/03-joins/`
- `practice/sql-ex/by-topic/04-subqueries/`
- `practice/sql-ex/by-topic/05-set-ops/`
- `practice/sql-ex/by-topic/06-cte-recursion/`
- `practice/sql-ex/by-topic/07-date-time/`
- `practice/sql-ex/by-topic/08-strings/`

### 3) Advanced example (AdventureWorks)

A recursive CTE solution for parsing product numbers and computing derived values:

- `advanced/adventureworks/productnumber_digit_sum_recursive_cte.sql`

## Related repo (Graph DB + Power BI)

My **SQL Server Graph** lab and Power BI visualization live in a separate repository:

- `GraphDB_Lab` (tourist graph database, Force‑Directed Graph, assets, PBIX)

## How to run

1. Open scripts in **SSMS** / **Azure Data Studio**
2. Run from top to bottom (scripts are written for SQL Server / T‑SQL)

---

If you want a fast overview: start with the **Office Expenses** mini‑project and then skim the `practice/sql-ex/by-topic` folders.
