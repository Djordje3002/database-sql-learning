# 05 — Views and triggers: clear abstraction, careful automation

> **English** · [Srpski](../../docs/05-views-and-triggers.md)

A `VIEW` is a saved query that behaves like a virtual table. A `TRIGGER` is database code that runs on a change. Both can reduce repetition; both can hide complexity if they are used without discipline.

Use a view when a shared business concept deserves one reviewed definition, when several screens reuse the same readable query, or when a smaller safe column set should be exposed. A normal view is not automatically faster: it usually runs its query again. PostgreSQL offers materialized views; SQLite does not have a built-in equivalent.

Use triggers for small, database-wide rules such as an audit record for a status change. Keep the effect local and predictable. Do not create a hidden application inside the database or make network calls from a trigger. `OLD` and `NEW` refer to the row before and after a change; the trigger action belongs to the same transaction and rolls back with it.

Every trigger needs a success test and a rollback/rejection test. Name it precisely, document the effect, and manage dependencies in migrations. Run the [view and trigger lab](../../sql/05-views-and-triggers.sql).
