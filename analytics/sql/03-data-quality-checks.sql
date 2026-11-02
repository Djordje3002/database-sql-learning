-- Data-quality checks / Provere kvaliteta podataka. Run after 00 / Posle 00.

-- Duplicate event IDs are a pipeline concern / Dupli ID događaja je problem pipeline-a.
SELECT event_id, COUNT(*) AS row_count
FROM staging_events
GROUP BY event_id
HAVING COUNT(*) > 1;

-- Required analytical fields / Obavezna analitička polja.
SELECT event_id, session_id, event_type, occurred_at
FROM staging_events
WHERE session_id IS NULL
   OR event_type IS NULL
   OR occurred_at IS NULL;

-- A finance reconciliation: fact revenue agrees with the defined subset / Finansijsko usaglašavanje: fact prihod odgovara definisanom skupu.
SELECT SUM(revenue_cents) AS recognized_revenue_cents,
       COUNT(*) AS recognized_orders
FROM fact_orders
WHERE status IN ('paid', 'shipped');

-- Freshness check example: replace the literal with your SLA / Primer provere svežine: literal zameni SLA pravilom.
SELECT MAX(ordered_at) AS latest_loaded_order_at
FROM fact_orders;
