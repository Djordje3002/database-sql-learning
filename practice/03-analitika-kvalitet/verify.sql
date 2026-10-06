-- Control totals / Kontrolni rezultati za projekat 03

SELECT event_type, COUNT(DISTINCT session_id) AS expected_sessions
FROM web_events
GROUP BY event_type
ORDER BY event_type;

-- Expected funnel: 5 visits, 4 searches, 3 add_to_cart, 2 checkouts, 1 purchase.
-- Očekivani funnel: 5 poseta, 4 pretrage, 3 dodavanja, 2 checkout-a, 1 kupovina.
SELECT COUNT(DISTINCT CASE WHEN event_type = 'visit' THEN session_id END) AS visits,
       COUNT(DISTINCT CASE WHEN event_type = 'search' THEN session_id END) AS searches,
       COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN session_id END) AS add_to_cart,
       COUNT(DISTINCT CASE WHEN event_type = 'checkout' THEN session_id END) AS checkouts,
       COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) AS purchases
FROM web_events;
