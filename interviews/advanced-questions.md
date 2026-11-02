# Advanced interview questions

> **English** · [Srpski](advanced-questions.sr.md)

1. Compare `ROW_NUMBER`, `RANK`, and `DENSE_RANK` with a tied sales example.
2. Why should a running total specify `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW`?
3. Design an idempotent payment callback. Which constraint makes retry safe?
4. Explain atomicity and isolation using checkout with inventory. Where should the transaction begin and end?
5. Given `WHERE customer_id = ? AND created_at >= ? ORDER BY created_at DESC`, propose an index and justify its column order.
6. A PostgreSQL plan shows a sequential scan. What evidence do you need before adding an index?
7. When is a partial index better than a full index? What must be true about the query predicate?
8. How do you prevent cross-tenant reads if an application filter is accidentally omitted? Describe RLS and its performance requirements.
9. Design a many-to-many relationship that stores facts about the relationship itself.
10. How would you add a non-nullable column to a large live table without breaking old application versions?
11. Explain backup RPO/RTO and why a successful backup job is insufficient evidence.
12. In a banking ledger, why should corrections be reversing entries rather than updates?

Strong answers identify trade-offs. For example, an index can improve a read path while increasing write cost; an isolation mechanism can raise correctness while changing complexity and throughput.
