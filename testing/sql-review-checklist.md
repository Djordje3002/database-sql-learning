# SQL review checklist

> **English** · [Srpski](sql-review-checklist.sr.md)

## Correctness

- [ ] Can the author state one sentence describing the result grain?
- [ ] Are joins keyed by stable identifiers and cardinality understood?
- [ ] Are `NULL`, zero, empty input, ties, and time-zone behavior intentional?
- [ ] Are `WHERE`, `HAVING`, and outer-join filters placed correctly?
- [ ] Does money use historical values and exact representation?

## Safety and security

- [ ] Are all application values bound parameters?
- [ ] Are dynamic identifiers selected from an allow-list?
- [ ] Does DML have a narrow predicate, a preceding `SELECT`, and a transaction plan?
- [ ] Are privileges/RLS policies least-privilege and testable?

## Performance and operations

- [ ] Is the query shape measured before adding an index?
- [ ] Do index columns match equality, range, order, and selected fields deliberately?
- [ ] Are foreign-key indexes considered for joins/cascades?
- [ ] Does a migration preserve compatibility and have a recovery plan?
- [ ] Are data volume, timeouts, locking, and connection pooling relevant to this path?
