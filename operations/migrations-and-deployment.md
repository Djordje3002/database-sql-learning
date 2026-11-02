# Migrations and safe deployment

> **English** · [Srpski](migrations-and-deployment.sr.md)

## The expand → migrate → contract pattern

Avoid a release that changes application code and breaks the old schema at the same moment.

1. **Expand:** add a nullable column, a new table, or a new index in a backward-compatible migration.
2. **Migrate:** deploy code that writes both representations; backfill in small, observable batches.
3. **Verify:** compare totals, error rates, and query plans; make new reads use the new representation.
4. **Contract:** remove the old column/path only after all active versions and jobs no longer depend on it.

Example: replace `customers.full_name` with `first_name` and `last_name`. Do not rename and deploy in one irreversible step. Add both columns, backfill, dual-write, cut reads over, then remove the old column in a later release.

## PostgreSQL migration practices

- Keep one ordered migration directory in source control; production applies each migration once and records its version.
- `CREATE INDEX CONCURRENTLY` reduces blocking but cannot run inside a transaction block; give it its own migration and a retry-safe plan.
- Add a large-table constraint carefully. Validate existing rows separately where appropriate:

```sql
ALTER TABLE public.orders
  ADD CONSTRAINT orders_total_nonnegative CHECK (total_cents >= 0) NOT VALID;
ALTER TABLE public.orders
  VALIDATE CONSTRAINT orders_total_nonnegative;
```

- PostgreSQL has no `ADD CONSTRAINT IF NOT EXISTS`. If an idempotent migration is truly needed, inspect `pg_constraint` in a `DO` block; otherwise let a versioned migration run exactly once.
- Set timeouts deliberately for migration sessions: `lock_timeout` and `statement_timeout` make failures visible rather than silently blocking production.

## Deployment checklist

- [ ] Migration tested against a production-shaped backup or branch.
- [ ] Compatibility window documented: old app ↔ new schema and new app ↔ old schema.
- [ ] Backup/restore status is green before schema change.
- [ ] Query plan and index impact checked for hot paths.
- [ ] Connection pool limits and role privileges reviewed.
- [ ] Feature flag or rollback plan exists for behavior changes.
- [ ] Alerts cover error rate, latency, saturation, replication/backup health, and migration duration.

Rollback is not always “run the reverse SQL”: destructive data transforms may be irreversible. Prefer forward fixes, preserve source data until verification, and practice the decision path before an incident.
