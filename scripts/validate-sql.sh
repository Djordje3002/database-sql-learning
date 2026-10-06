#!/usr/bin/env bash

# Validates every SQLite-first lesson against a freshly seeded database.
# This is intentionally small and dependency-free so learners can run it locally.

set -euo pipefail

foundation_database="$(mktemp "${TMPDIR:-/tmp}/database-sql-foundation.XXXXXX.db")"
advanced_database="$(mktemp "${TMPDIR:-/tmp}/database-sql-advanced.XXXXXX.db")"
practice_database="$(mktemp "${TMPDIR:-/tmp}/database-sql-practice.XXXXXX.db")"
trap 'rm -f "$foundation_database" "$advanced_database" "$practice_database"' EXIT

sqlite3 "$foundation_database" < sql/00-priprema-baze.sql

for lesson in sql/[0-9][0-9]-*.sql; do
  if [[ "$lesson" == "sql/00-priprema-baze.sql" ]]; then
    continue
  fi

  sqlite3 "$foundation_database" < "$lesson" > /dev/null
  printf '✓ %s\n' "$lesson"
done

sqlite3 "$advanced_database" < advanced/sql/00-advanced-setup.sql

for lesson in advanced/sql/[0-9][0-9]-*.sql; do
  if [[ "$lesson" == "advanced/sql/00-advanced-setup.sql" ]]; then
    continue
  fi

  sqlite3 "$advanced_database" < "$lesson" > /dev/null
  printf '✓ %s\n' "$lesson"
done

for project in 01-biblioteka-operacije 02-prodaja-izvestavanje 03-analitika-kvalitet; do
  sqlite3 "$practice_database" < sql/00-priprema-baze.sql

  if [[ -f "practice/$project/seed.sql" ]]; then
    sqlite3 "$practice_database" < "practice/$project/seed.sql"
  fi

  sqlite3 "$practice_database" < "practice/$project/solution.sql" > /dev/null
  sqlite3 "$practice_database" < "practice/$project/verify.sql" > /dev/null
  printf '✓ practice/%s reference solution\n' "$project"
done

printf 'All SQLite-first foundation, advanced, and practice examples passed.\n'
