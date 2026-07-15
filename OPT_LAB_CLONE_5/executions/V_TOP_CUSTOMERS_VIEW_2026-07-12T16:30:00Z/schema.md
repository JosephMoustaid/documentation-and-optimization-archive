# Schema — OPT_LAB_CLONE_5.RETAIL.V_TOP_CUSTOMERS

- **Object Type:** VIEW
- **Database:** OPT_LAB_CLONE_5
- **Schema:** RETAIL
- **Object:** V_TOP_CUSTOMERS
- **Execution:** exec-2026-07-12T16:30:00Z

## Columns (as defined by SELECT list)
| Ordinal | Column | Expression | Notes |
|---:|---|---|---|
| 1 | customer_id | `s.customer_id` | From `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| 2 | first_name | `s.first_name` | From `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| 3 | last_name | `s.last_name` | From `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| 4 | total_spent | `s.total_spent` | From `OPT_LAB_CLONE_5.RETAIL.V_CUSTOMER_ORDER_SUMMARY` |
| 5 | returned_orders | `returned_orders.returned_orders` | Derived: `COUNT(*)` of `ORDERS` rows where `status = 'RETURNED'` grouped by `customer_id`; `LEFT JOIN` means may be NULL when none |

## Filters / Ordering
- **Filter:** `s.total_spent > 0`
- **Ordering:** `s.total_spent DESC`

## Definition (applied)
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
