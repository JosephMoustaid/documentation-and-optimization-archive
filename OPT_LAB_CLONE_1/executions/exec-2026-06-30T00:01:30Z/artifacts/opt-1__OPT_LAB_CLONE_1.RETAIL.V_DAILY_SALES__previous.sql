CREATE OR REPLACE VIEW OPT_LAB_CLONE_1.RETAIL.V_DAILY_SALES AS
SELECT
 d1.order_date,
 SUM(d1.order_total) AS daily_total,
 (SELECT SUM(d2.order_total)
 FROM orders d2
 WHERE d2.order_date <= d1.order_date) AS running_total
FROM orders d1
GROUP BY d1.order_date;