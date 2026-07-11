# Optimization Report — exec-2026-07-11T17:15:00Z

## Overview

- **Database:** OPT_LAB_CLONE_3
- **Warehouse:** ADF_WH
- **Mode:** DRY_RUN
- **Status:** FAILED
- **Object:** `RETAIL.SP_RECALC_ORDER_TOTALS` (PROCEDURE)

## Attempted change

A set-based procedure definition was produced that recomputes `orders.order_total` by aggregating `order_items.quantity * order_items.unit_price` per order.

See `optimized.sql`.

## Validation error (DRY_RUN)

> Unable to run the CREATE PROCEDURE command because no database was specified for the RETAIL schema. A fully qualified name (e.g., OPT_LAB_CLONE_3.RETAIL.SP_RECALC_ORDER_TOTALS) or an explicit database context is required.

### Root cause

The procedure DDL used:

```sql
CREATE OR REPLACE PROCEDURE RETAIL.SP_RECALC_ORDER_TOTALS()
```

In DRY_RUN validation, Snowflake requires either:

- a fully qualified name (`<db>.<schema>.<object>`), or
- a session database context set via `USE DATABASE <db>`.

Because no database context was active for schema `RETAIL`, validation failed.

## Remediation

### Option A (recommended): Fully qualify the procedure name

```sql
CREATE OR REPLACE PROCEDURE OPT_LAB_CLONE_3.RETAIL.SP_RECALC_ORDER_TOTALS() ...
```

### Option B: Set database context prior to running

```sql
USE DATABASE OPT_LAB_CLONE_3;
USE SCHEMA RETAIL;
CREATE OR REPLACE PROCEDURE SP_RECALC_ORDER_TOTALS() ...
```

## Notes

- `previous_definition` was not provided in the execution payload, so a diff could not be produced.
- Lineage/diagrams are best-effort from the SQL text because validation stopped before dependency introspection.
