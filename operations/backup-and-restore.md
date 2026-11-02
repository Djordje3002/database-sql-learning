# Backup, restore, and recovery

> **English** · [Srpski](backup-and-restore.sr.md)

## The recovery objective

Define two numbers before choosing a tool:

- **RPO** (Recovery Point Objective): how much recent data may be lost.
- **RTO** (Recovery Time Objective): how long the service may be unavailable.

These turn “we need backups” into an operational requirement. A daily logical dump cannot meet a five-minute RPO; a backup that takes six hours to restore cannot meet a one-hour RTO.

## PostgreSQL: logical backup and restore drill

```bash
# Back up one database in a restorable custom format.
pg_dump --format=custom --file=app-2026-11-02.dump --dbname="$DATABASE_URL"

# Restore only into a new, disposable target database.
createdb app_restore_test
pg_restore --dbname=app_restore_test --verbose app-2026-11-02.dump

# Verify schema and a meaningful business total after restore.
psql -d app_restore_test -c '\dt'
psql -d app_restore_test -c 'SELECT COUNT(*) FROM public.orders;'
```

Do not use `pg_restore --clean` unless the exact target database is confirmed; it drops objects. At larger scale, pair logical exports with platform-native physical backups and point-in-time recovery, then rehearse both.

## MySQL: consistent InnoDB dump and restore drill

```bash
mysqldump --single-transaction --routines --triggers --databases app_db > app-2026-11-02.sql
mysql -e 'CREATE DATABASE app_restore_test'
mysql app_restore_test < app-2026-11-02.sql
mysql app_restore_test -e 'SELECT COUNT(*) FROM orders;'
```

`--single-transaction` gives a consistent snapshot for transactional InnoDB tables, but does not make non-transactional tables consistent. Know the engine and provider behavior you actually run.

## Recovery checklist

- Encrypt backups in transit and at rest; restrict who can read them.
- Keep copies in a separate failure domain from the primary database.
- Record backup completion, size, duration, and checksum; alert on missed or abnormal jobs.
- Restore on a schedule into an isolated environment and verify both schema and business-level counts.
- Document the exact owner, command, target, and time of every emergency restore.
- Do not rehearse with production credentials in a developer laptop shell history.
