-- Project 03 reference solution / Referentno rešenje projekta 03

-- 1. Events and sessions by type / Događaji i sesije po vrsti.
SELECT event_type,
       COUNT(*) AS broj_dogadjaja,
       COUNT(DISTINCT session_id) AS broj_sesija
FROM web_events
GROUP BY event_type
ORDER BY event_type;

-- 2. Funnel at session grain / Funnel na nivou sesije.
WITH funnel AS (
  SELECT COUNT(DISTINCT CASE WHEN event_type = 'visit' THEN session_id END) AS visits,
         COUNT(DISTINCT CASE WHEN event_type = 'search' THEN session_id END) AS searches,
         COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS add_to_cart,
         COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id END) AS checkouts,
         COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) AS purchases
  FROM web_events
)
SELECT visits,
       searches,
       add_to_cart,
       checkouts,
       purchases,
       ROUND(100.0 * searches / NULLIF(visits, 0), 2) AS search_from_visit_pct,
       ROUND(100.0 * purchases / NULLIF(visits, 0), 2) AS purchase_from_visit_pct
FROM funnel;

-- 3. Customer segmentation / Segmentacija kupaca.
WITH recognized_revenue AS (
  SELECT n.id_kupca,
         SUM(sn.kolicina * sn.cena_u_trenutku) AS prihod
  FROM narudzbine AS n
  JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
  WHERE n.status IN ('placena', 'poslata')
  GROUP BY n.id_kupca
)
SELECT k.ime,
       COALESCE(r.prihod, 0) AS prihod,
       CASE
         WHEN COALESCE(r.prihod, 0) = 0 THEN 'bez prihoda'
         WHEN r.prihod >= 3000 THEN 'vip'
         ELSE 'standard'
       END AS segment
FROM kupci AS k
LEFT JOIN recognized_revenue AS r ON r.id_kupca = k.id
ORDER BY prihod DESC, k.ime;

-- 4. Last event and conversion at session grain / Poslednji događaj i konverzija sesije.
WITH ranked_events AS (
  SELECT session_id,
         event_type,
         occurred_at,
         ROW_NUMBER() OVER (
           PARTITION BY session_id
           ORDER BY occurred_at DESC, event_id DESC
         ) AS rn,
         MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) OVER (
           PARTITION BY session_id
         ) AS reached_purchase
  FROM web_events
)
SELECT session_id, event_type AS poslednji_dogadjaj, occurred_at, reached_purchase
FROM ranked_events
WHERE rn = 1
ORDER BY session_id;

-- 5. Data quality report / Izveštaj kvaliteta podataka.
SELECT 'knjiga_bez_autora' AS problem, k.naziv AS entitet
FROM knjige AS k
LEFT JOIN knjige_autori AS ka ON ka.id_knjige = k.id_knjige
WHERE ka.id_knjige IS NULL
UNION ALL
SELECT 'kupac_bez_emaila', ku.ime
FROM kupci AS ku
WHERE ku.email IS NULL
UNION ALL
SELECT 'izdavac_bez_knjiga', i.naziv
FROM izdavaci AS i
LEFT JOIN knjige AS k ON k.id_izdavaca = i.id
WHERE k.id_knjige IS NULL
ORDER BY problem, entitet;

-- 6. Finalized orders missing line items / Finalizovane narudžbine bez stavki.
SELECT n.id, n.datum, n.status
FROM narudzbine AS n
LEFT JOIN stavke_narudzbine AS sn ON sn.id_narudzbine = n.id
WHERE n.status IN ('placena', 'poslata')
  AND sn.id_narudzbine IS NULL;
