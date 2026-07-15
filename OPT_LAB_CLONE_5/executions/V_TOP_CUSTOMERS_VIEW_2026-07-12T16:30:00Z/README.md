# Optimization Execution Documentation

- **Execution ID:** exec-2026-07-12T16:30:00Z
- **Database:** OPT_LAB_CLONE_5
- **Schema Scope:** ALL
- **Warehouse:** ADF_WH
- **Mode:** APPLY
- **Status:** SUCCESS
- **Object:** OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS
- **Object Type:** VIEW

## Summary of Change
This execution optimized `OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS` by replacing a per-row correlated subquery that counted returned orders with a pre-aggregated derived table joined by customer_id.

Key improvements:
- Avoids executing `COUNT(*)` per result row (correlated subquery)
- Uses a single grouped scan of `OPT_LAB_CLONE_5.RETAIL.ORDERS` filtered to `status = 'RETURNED'`
- Preserves output columns and ordering by `total_spent DESC`

## Executed SQL
```sql
CREATE OR REPLACE VIEW OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS AS
SELECT
    s.customer_id,
    s.first_name,
    s.last_name,
    s.total_spent,
    returned_orders.returned_orders
FROM OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY s
LEFT JOIN (
    /* Pre-aggregate returned orders per customer to avoid per-row correlated subquery */
    SELECT
        o.customer_id,
        COUNT(*) AS returned_orders
    FROM OPT_LAB_CLONE_5.RETAIL.ORDERS o
    WHERE o.status = 'RETURNED'
    GROUP BY o.customer_id
) AS returned_orders
    ON returned_orders.customer_id = s.customer_id
WHERE s.total_spent > 0
ORDER BY s.total_spent DESC;
```

## Files
- `schema.md` — object schema (columns) and notes
- `lineage.md` — table/view-level lineage diagram
- `column-lineage.md` — column-level mapping lineage diagram
- `procedure-flow.md` — execution/optimization flow diagram
