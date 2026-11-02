# Database Testing and Review Track

> **English** · [Srpski](README.sr.md)

Correct-looking SQL is not enough. This track teaches how to prove a schema, migration, query, and recovery workflow deserve trust.

| Resource | Outcome |
| --- | --- |
| [Testing strategy](testing-strategy.md) | choose useful schema, data, query, concurrency, and restore tests |
| [SQL review checklist](sql-review-checklist.md) | review correctness, security, performance, and maintainability systematically |
| [SQLite assertions](sql/sqlite-assertions.sql) | read executable checks against the foundation database |
| [Test runner](run-sqlite-checks.sh) | run assertions locally without a framework |

Run the local checks:

```bash
bash testing/run-sqlite-checks.sh
```

The repository CI runs the same checks. For PostgreSQL/MySQL applications, add integration tests against an isolated database or branch; mocks cannot prove a dialect-specific query plan, constraint, transaction, or RLS policy.
