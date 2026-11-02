# Analytics and Data Engineering Track

> **English** · [Srpski](README.sr.md)

This track teaches the database side of trustworthy reporting: define a metric before calculating it, preserve the grain of facts, build a small star schema, measure cohorts, and catch data-quality failures before a dashboard makes them look authoritative.

## Start locally

```bash
sqlite3 analytics.db < sql/00-analytics-setup.sql
sqlite3 analytics.db < sql/01-kpis-and-windows.sql
sqlite3 analytics.db < sql/02-cohorts-and-retention.sql
sqlite3 analytics.db < sql/03-data-quality-checks.sql
```

The scripts are SQLite-first and safe to run against a disposable database. They use a self-contained analytics model rather than modifying the bookstore practice database.

## Modules

| # | Topic | Outcome | SQL |
| --- | --- | --- | --- |
| 00 | Fact and dimension model | understand grain, dimensions, facts, and durable monetary values | [setup](sql/00-analytics-setup.sql) |
| 01 | KPIs and windows | calculate revenue, AOV, active customers, and rolling revenue | [KPI lab](sql/01-kpis-and-windows.sql) |
| 02 | Cohorts and retention | calculate first-purchase cohorts and subsequent active periods | [cohort lab](sql/02-cohorts-and-retention.sql) |
| 03 | Data quality | detect duplicate events, invalid records, and reconciliation breaks | [quality lab](sql/03-data-quality-checks.sql) |

Read [star-schema and grain](data-model.md) before the setup, then [metric contracts](metric-contracts.md) before building a dashboard.

## Rules that prevent misleading analytics

- Define the **grain** in one sentence before you join or aggregate: one order, one line item, one session, or one customer-month.
- Keep fact tables append-oriented. Historical revenue belongs to the time of purchase, not to a changing product price today.
- A metric needs a name, numerator, denominator, status/date filter, time zone, owner, and edge-case policy.
- Never join two detail-level fact tables without a bridge or prior aggregation; that silently multiplies measures.
- Data-quality checks are first-class outputs. A dashboard that does not report its freshness and failed checks is incomplete.

For production warehouses, carry these ideas into an orchestrator, versioned transformations, access controls, incremental loads, and monitored data contracts.
