# Conditions, operators, and NULL

> **English** · [Srpski](../03-uslovi-i-null.md)

`WHERE` selects rows before display or calculation. Conditions can use:

| Purpose | Example |
| --- | --- |
| comparison | `cena >= 1000` |
| multiple conditions | `godina >= 2020 AND cena < 2000` |
| a list of values | `id IN (1, 3, 5)` |
| a range | `cena BETWEEN 500 AND 1500` |
| a pattern | `naziv LIKE 'SQL%'` |
| a missing value | `email IS NULL` |

## Important: `NULL` is not empty or zero

`NULL` means that a value is unknown or not applicable. Therefore `column = NULL` is incorrect — it produces neither true nor false, but unknown. Use `IS NULL` or `IS NOT NULL`.

Use parentheses in complex conditions whenever they make your intent unambiguous:

```sql
WHERE (cena < 1000 OR cena IS NULL)
  AND godina_izdanja >= 2020;
```
