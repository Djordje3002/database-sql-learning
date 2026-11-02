# Star schema and grain

> **English** · [Srpski](data-model.sr.md)

A star schema places an event-like **fact** at the center and descriptive **dimensions** around it.

```text
dim_customers ──< fact_orders >── dim_products
                      |
                 dim_calendar
```

| Concept | Question it answers | Example |
| --- | --- | --- |
| fact table | What happened, at what measurable grain? | one finalized order and its recognized revenue |
| dimension | How do we describe or group that fact? | customer acquisition channel, order date, product category |
| grain | What does one row mean? | exactly one order, never an order plus every product plus every event |
| surrogate/business key | How do rows remain identifiable over time? | immutable order ID; versioned customer dimension key in a larger warehouse |

## The grain test

Write: “One row in `fact_orders` represents one order, including its final historical revenue.” Then test every join against that promise. A join to order lines changes the grain to one line; a join to web events can multiply each order by every event. Aggregate first when you need to return to order grain.

In a larger warehouse, use a separate fact for each event grain (`fact_order_lines`, `fact_sessions`) and join through conformed dimensions rather than directly joining unrelated facts.
