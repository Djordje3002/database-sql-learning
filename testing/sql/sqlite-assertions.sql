-- Executable assertion results / Izvršivi rezultati asercija. Each row must end with 1 / Svaki red mora završiti sa 1.

SELECT 'all_books_have_a_publisher' AS assertion_name,
       CASE WHEN NOT EXISTS (
         SELECT 1
         FROM knjige AS k
         LEFT JOIN izdavaci AS i ON i.id = k.id_izdavaca
         WHERE i.id IS NULL
       ) THEN 1 ELSE 0 END AS passed
UNION ALL
SELECT 'no_negative_book_prices',
       CASE WHEN NOT EXISTS (SELECT 1 FROM knjige WHERE cena < 0) THEN 1 ELSE 0 END
UNION ALL
SELECT 'recognized_revenue_matches_fixture',
       CASE WHEN (
         SELECT COALESCE(SUM(sn.kolicina * sn.cena_u_trenutku), 0)
         FROM narudzbine AS n
         JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
         WHERE n.status IN ('placena', 'poslata')
       ) = 4995 THEN 1 ELSE 0 END
UNION ALL
SELECT 'publisher_names_are_unique',
       CASE WHEN NOT EXISTS (
         SELECT naziv FROM izdavaci GROUP BY naziv HAVING COUNT(*) > 1
       ) THEN 1 ELSE 0 END;
