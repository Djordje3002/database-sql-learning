# 06 — Database security: parameters, least privilege, healthy boundaries

> **English** · [Srpski](../../docs/06-security-and-parameters.md)

Never make a value part of SQL text. This is unsafe:

```text
"SELECT * FROM customers WHERE email = '" + email + "'"
```

Use a prepared statement and bind the value separately instead. A placeholder represents a value, not an identifier such as a column or table name. For dynamic sorting or identifiers, choose only from a strict allow-list in application code, then continue to bind data values normally.

Least privilege matters too: a catalog service gets read access to public catalog data; an order service gets only the writes it needs; migrations use separate, temporary broader access; analytics should prefer views that mask personal data. SQLite has no in-file user and `GRANT` model, so file permissions and application architecture are part of the boundary. PostgreSQL and MySQL permissions should be managed as infrastructure.

Do not log secrets or complete private parameters. Protect backups, rotate credentials, minimize personal-data collection, and prove that a backup can be restored. The [safe-pattern lab](../../sql/06-security-and-parameters.sql) demonstrates bind-value simulation, an allow-list-shaped sort, and masked output.
