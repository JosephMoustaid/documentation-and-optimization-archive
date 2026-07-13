# Lineage

## Overview

`OPT_LAB_CLONE_4.RETAIL.V_NEVER_ORDERED_PRODUCTS` returns products that do **not** appear in `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS`.

## Upstream dependencies

- **Primary source:** `OPT_LAB_CLONE_4.RETAIL.PRODUCTS` (alias `p`)
- **Anti-join filter:** `NOT EXISTS` against `OPT_LAB_CLONE_4.RETAIL.ORDER_ITEMS` (alias `oi`) on `oi.product_id = p.product_id`

## Downstream

Not captured in this execution.

> Note: APPLY failed; lineage is derived from the SQL text and may not reflect a successfully deployed definition.
