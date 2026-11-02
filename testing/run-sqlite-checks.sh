#!/usr/bin/env bash

# Run deterministic database assertions / Pokreni determinističke asercije baze.

set -euo pipefail

database_path="$(mktemp "${TMPDIR:-/tmp}/database-sql-testing.XXXXXX.db")"
trap 'rm -f "$database_path"' EXIT

sqlite3 "$database_path" < sql/00-priprema-baze.sql
failed_assertions="$(sqlite3 -noheader "$database_path" < testing/sql/sqlite-assertions.sql | awk -F'|' '$2 != 1 {print $1}')"

if [[ -n "$failed_assertions" ]]; then
  printf 'Failed database assertions:\n%s\n' "$failed_assertions" >&2
  exit 1
fi

printf 'All database assertions passed.\n'
