create or replace view V_DAILY_SALES(
	ORDER_DATE,
	DAILY_TOTAL,
	RUNNING_TOTAL
) as
SELECT
    o.order_date,
    SUM(o.order_total)                                                      AS daily_total,
    SUM(SUM(o.order_total)) OVER (
        ORDER BY o.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                                       AS running_total
FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
GROUP BY
    o.order_date;
