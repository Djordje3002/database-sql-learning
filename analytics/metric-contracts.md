# Metric contracts

> **English** · [Srpski](metric-contracts.sr.md)

A metric contract makes a dashboard number reproducible. Store it with the query, semantic layer, or model definition.

| Field | Example: recognized revenue |
| --- | --- |
| Owner | Finance analytics |
| Grain | one order |
| Formula | `SUM(revenue_cents)` |
| Inclusion | statuses `paid` and `shipped` |
| Exclusion | `new`, `cancelled`, refunds unless explicitly modeled |
| Time | order completion date, UTC reporting zone |
| Freshness | data complete through last successful pipeline run |
| Validation | compare daily total to payment settlement and alert on variance |

Avoid labels such as “sales” or “active users” without a definition. Two correct SQL queries can disagree because they encode different business meanings.
