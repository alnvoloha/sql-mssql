# Office Expenses (Mini‑project)

A small SQL Server database that models office purchases and monthly expense limits.

## What this demonstrates
- Relational modeling (tables, keys, constraints)
- Realistic sample data
- Temporal tables (system‑versioned history) and time‑travel queries

## Files
- `office_expenses_schema_and_seed.sql`  
  Creates the core schema and inserts sample rows.

- `temporal/01_create_temporal_schema_and_changes.sql`  
  Creates system‑versioned (temporal) tables and performs changes (INSERT/UPDATE/DELETE) to generate history.

- `temporal/02_time_travel_queries.sql`  
  Examples of reading historical states with `FOR SYSTEM_TIME AS OF ...`.

## Running
Open in SSMS and execute in order:
1. schema + seed
2. temporal setup + changes
3. time‑travel queries
