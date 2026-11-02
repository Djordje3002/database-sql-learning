# SQL Interview Lab

> **English** · [Srpski](README.sr.md)

This is not a memorization list. Treat each prompt as a short design review: clarify the grain, name edge cases, state the dialect assumption, write the simplest correct query, and explain how you would validate or scale it.

| Resource | Purpose |
| --- | --- |
| [Foundation questions](foundation-questions.md) | joins, aggregates, `NULL`, grouping, and safe DML |
| [Advanced questions](advanced-questions.md) | windows, transactions, indexes, RLS, design, and operations |
| [Challenge starter](sql/interview-challenges.sql) | time-boxed practical SQL prompts |
| [Reference answers](sql/interview-answers.sql) | review after an honest attempt |

## Interview answer framework

1. **Clarify:** What does one output row represent? Which dialect/version and data volume are assumed?
2. **Design:** Explain the join cardinality, filter timing, and treatment of `NULL`/empty inputs.
3. **Write:** Use clear aliases and an explicit order. Avoid `SELECT *`.
4. **Validate:** Give a small counterexample or control total.
5. **Scale:** Name the likely index, query-plan check, lock, or security concern only when it is relevant.

Spend 20–30 minutes on a challenge before reading the answer. A concise, well-reasoned query is better than an elaborate query you cannot defend.
