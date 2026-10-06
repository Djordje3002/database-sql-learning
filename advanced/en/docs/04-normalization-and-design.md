# 04 — Normalization and design: one source of truth

> **English** · [Srpski](../../docs/04-normalization-and-design.md)

Normalization keeps a fact in one logical place. If a publisher city is copied into every book row, one correction requires many changes and can leave conflicting values. A separate publisher entity stores the fact once.

| Level | Question | Practical correction |
| --- | --- | --- |
| 1NF | Is every value atomic? | replace a comma-separated author list with a relationship table |
| 2NF | Does an attribute depend on the whole composite key? | keep customer name on `customers`, not on an order item |
| 3NF | Does it depend on another non-key attribute? | keep publisher city on `publishers`, not every book |

Normalization is not a religion. Historical order-item price is intentional duplication: it records what the buyer actually paid even when the current catalog price changes.

Use database constraints to turn business rules into enforceable boundaries: `PRIMARY KEY` for identity, `FOREIGN KEY` for relationships, and `NOT NULL`, `CHECK`, `UNIQUE`, and `DEFAULT` for invariants. In SQLite, enable `PRAGMA foreign_keys = ON` on every connection.

Model many-to-many relationships with a bridge table. It can also hold facts about the relationship itself, such as quantity, author role, or price at purchase time. Denormalize only after evidence of a read bottleneck, and define its source of truth, refresh owner, consistency check, and recovery plan. Run the [normalization lab](../../sql/04-normalization-and-design.sql).
