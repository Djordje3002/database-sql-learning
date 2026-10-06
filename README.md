# Database SQL Learning

<p align="center">
  <img src="assets/database-learning-hero.png" alt="Abstract relational database tables connected by glowing lines" width="100%" />
</p>

<p align="center">
  A practical, bilingual database curriculum — from your first <code>SELECT</code> query to query plans, transactions, and production-minded design.
</p>

<p align="center">
  <strong>English</strong> · <a href="README.sr.md">Srpski</a>
</p>

## Why this repository exists

This is a long-term, hands-on learning space rather than a loose collection of snippets. Every topic combines concise theory, runnable SQL, and a realistic library-store data model. The sequence is deliberate: learn the question first, then the syntax, then how to make the answer safe and fast.

## Start here

1. Read the [learning path](docs/en/00-learning-path.md).
2. Create the practice database with [00-priprema-baze.sql](sql/00-priprema-baze.sql).
3. Work through lessons in numerical order and run each query yourself.

SQLite is the recommended starting point because it needs no server. The core examples use portable SQL; lessons call out important PostgreSQL, MySQL, and SQLite differences.

```bash
sqlite3 biblioteka.db < sql/00-priprema-baze.sql
sqlite3 biblioteka.db
```

Then paste a query from `sql/` into the SQLite prompt.

## Curriculum

### Foundations

| Module | Topic | Theory | Runnable examples |
| --- | --- | --- | --- |
| 00 | Practice database | [data model](docs/en/01-database-and-model.md) | [setup](sql/00-priprema-baze.sql) |
| 01 | Reading data | [syntax and conventions](docs/en/02-core-rules.md) | [SELECT](sql/01-citanje-podataka.sql) |
| 02 | Conditions and missing values | [operators and NULL](docs/en/03-conditions-and-null.md) | [WHERE](sql/02-uslovi-i-null.sql) |
| 03 | Functions and aggregation | [function guide](docs/en/04-functions-and-aggregation.md) | [functions](sql/03-funkcije-i-agregacije.sql) |
| 04 | Combining tables | [JOIN guide](docs/en/05-joins.md) | [JOIN](sql/04-join.sql) |
| 05 | Expressive queries | [subqueries and CTEs](docs/en/06-subqueries-and-ctes.md) | [subqueries](sql/05-podupiti-i-cte.sql) |
| 06 | Changing data | [DML rules](docs/en/07-changing-data.md) | [DML lab](sql/06-izmena-podataka.sql) |
| 07 | Design and quality | [DDL, keys, and indexes](docs/en/08-design-and-performance.md) | [schema lab](sql/07-dizajn-tabela.sql) |

### Advanced Database Course

The [Advanced Database Course](advanced/en/README.md) turns fundamentals into production-oriented skills: window functions, transactions and isolation, query optimization, views and triggers, data modeling, and security.

### Practice studio

The [practice studio](practice/en/README.md) contains progressively harder briefs that ask you to solve real reporting, data-quality, and analytics problems before reading a solution.

## What you will be able to do

- Write correct, readable queries across multiple related tables.
- Reason about `NULL`, aggregation, duplicates, and cardinality.
- Model relationships using keys and constraints.
- Change data safely with transactions.
- Inspect an execution plan, choose an index deliberately, and avoid common performance traps.
- Build safer application queries using parameters rather than string concatenation.

## Repository map

```text
docs/          Serbian foundation theory
docs/en/       English foundation theory
sql/           Shared, runnable SQLite-first examples
advanced/      Advanced course, theory and labs
practice/      Project briefs, challenges, and solutions
resources/     Reference material and cheat sheets
assets/        Original course visuals
```

## Working principles

- End every statement with `;`.
- Use uppercase keywords and descriptive lowercase names.
- Before an `UPDATE` or `DELETE`, first run the same condition as a `SELECT`.
- In application code, never concatenate user input into SQL; use parameterized queries.
- Treat `SELECT *` as an exploration shortcut, not a production habit.

## Languages

Foundation theory is available in parallel Serbian and English paths. SQL is shared because SQL keywords are universal; its comments are written to stay concise and clear. Each larger course area links to its matching language edition.

## Contributing a lesson

See [CONTRIBUTING.en.md](CONTRIBUTING.en.md) for the naming, translation, testing, and quality conventions used when we add the next lesson, challenge, or project.

---

The course grows one well-explained problem at a time. Send the next task whenever you are ready.
