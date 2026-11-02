# Foundation interview questions

> **English** · [Srpski](foundation-questions.sr.md)

1. Explain the result difference between `COUNT(*)`, `COUNT(column)`, and `COUNT(DISTINCT column)` after a `LEFT JOIN`.
2. Why does `WHERE right_table.status = 'paid'` after a `LEFT JOIN` often turn it into an inner join? Show two safe alternatives.
3. Return publishers with at least three books, including how `WHERE` and `HAVING` differ in that query.
4. Find books with no author without accidentally hiding them.
5. A revenue query doubles its total after joining authors. What is the grain mistake and how would you fix it?
6. Explain why `email = NULL` is wrong and when an empty string is not equivalent to `NULL`.
7. Write a query to return the second-highest distinct price; explain ties and the no-second-price case.
8. Given a `DELETE`, describe the exact safe workflow before `COMMIT`.
9. Compare `EXISTS`, `IN`, and a `JOIN` for “customers who have an order.” When can a join create duplicates?
10. How would you paginate a large, frequently changing order list? Compare offset and keyset pagination.

For each answer, state your database dialect. Date, string aggregation, pagination, and execution-plan syntax are not identical across engines.
