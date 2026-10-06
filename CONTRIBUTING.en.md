# How to add new course material

[Srpski](CONTRIBUTING.md) | [English](CONTRIBUTING.en.md)

This repository is a long-term collection of SQL knowledge. Every addition should be small, runnable, connected to the existing material, and easy to revisit in six months—not merely useful today.

For quick syntax recall, use the [SQL Cheat Sheet](resources/en/cheat-sheet.md). For the course order, use the current [learning path](docs/en/00-learning-path.md).

## 1. Find the right place first

Before creating a file, review the current [learning path](docs/en/00-learning-path.md), `docs/en/`, and `sql/`.

| If you are adding… | It belongs in |
| --- | --- |
| an English explanation of one concept and why to use it | `docs/en/` |
| a short sequence of runnable examples for a lesson | `sql/` |
| a concise reminder used across several lessons | `resources/` |
| an exercise for independent practice | the established `practice/` format, when present |
| a more complex topic or project | the established `advanced/` format, when present |

Do not add a new lesson when the same topic is already covered. Instead:

1. add an example to the existing SQL file only when it truly deepens the topic;
2. add a separate exercise when the goal is practice rather than new theory;
3. create a new numbered lesson only when it introduces a new skill from the plan.

When `advanced/` or `practice/` has its own `README` or local guidance, that guidance takes priority for content in those folders. Keep Serbian and English explanations as complete parallel documents; do not mix both languages inside one lesson.

## 2. Naming convention for core-course lessons

The core course uses a pair of files with the same number and slug:

```text
docs/en/NN-topic-name.md
sql/NN-topic-name.sql
```

Naming rules:

- `NN` is the next unused two-digit number and must match in both files;
- use lowercase ASCII letters and hyphens (`window-functions`, not spaces or special characters);
- name the skill, not an incidental example (`aggregates`, not `books-3`);
- do not renumber existing lessons: links and the learning sequence must remain stable.

One lesson should teach one clear idea. If a topic contains several independent learning goals, split it into smaller lessons or move it to the advanced part of the course.

## 3. Minimum content for a new lesson

A file in `docs/en/` should briefly answer:

```markdown
# NN — Topic name

## What you will learn

## When to use it

## Rules and common mistakes

## Next step
```

Its companion file in `sql/` should contain:

```sql
-- NN — Topic name
-- Goal: one sentence describing the outcome the learner should get.

-- Example 1: the simplest correct case.

-- Example 2: a realistic case or common mistake.

-- An exercise to attempt independently (without the solution immediately below).
```

Do not put the full theory into SQL comments or copy the same SQL examples from older files. The document explains the decision; the SQL file is a short, runnable demonstration of that decision.

## 4. Rules for exercises and solutions

A well-formed exercise has four parts:

1. **Context** — which tables and columns the learner may use.
2. **Goal** — which information to obtain, without giving away the solution.
3. **Constraints** — for example: “use `LEFT JOIN`,” “without a subquery,” or “return only publishers with at least three books.”
4. **Expected result shape** — column names, ordering, and, where useful, a small sample result.

Keep the solution separate from the exercise text or behind a clearly marked “Solution” section so the learner can try first. A solution should include a brief explanation of the choice (`JOIN`, `WHERE`, `HAVING`, and so on), not just the final SQL.

If an exercise modifies data, state whether it is safe to repeat and how to restore state. Prefer `SELECT` for non-mutating practice; for DML, use a transaction, dedicated test rows, or a reset database.

## 5. Runnable and safe content

Before treating an addition as complete, verify that:

- it uses only tables and columns that exist in [the database setup](sql/00-priprema-baze.sql), or it includes a clearly documented migration/setup step;
- each example runs on a clean practice database, or it clearly states what it depends on;
- every `UPDATE` and `DELETE` has an intentional, limited `WHERE` and a preceding verification `SELECT`;
- examples require no secrets, personal data, or external services;
- dialect differences (SQLite / PostgreSQL / MySQL) are marked wherever syntax or results differ;
- SQL is formatted over multiple lines when it has several clauses, with meaningful table aliases.

## 6. Definition-of-done checklist

- [ ] The topic does not duplicate an existing lesson or exercise.
- [ ] The file name, number, and location follow the existing convention.
- [ ] Every new link resolves to an existing file and is relative to the document.
- [ ] SQL has been run against the practice database, or it clearly says why it cannot run independently.
- [ ] At least one common mistake or boundary of the concept is explained.
- [ ] The exercise does not reveal its solution before an attempt.
- [ ] Data changes are repeatable, isolated, or reversible.
- [ ] The new material adds genuine value rather than another version of the same syntax.

## 7. What to send with a new exercise

The fastest way to place a new exercise well in the course is to send:

```text
Topic: JOIN / aggregates / indexes / …
Level: beginner / intermediate / advanced
Goal: what I want to learn or test
Constraints: what must or must not be used
```

If you do not have all of those details, an ordinary SQL query or a description of the problem is enough. We can decide together whether it belongs in an existing lesson, a new exercise, or a new course topic.
