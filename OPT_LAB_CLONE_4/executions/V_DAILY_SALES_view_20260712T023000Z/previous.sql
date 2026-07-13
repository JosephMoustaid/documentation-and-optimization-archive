create or replace view V_DAILY_SALES(
	ORDER_DATE,
	DAILY_TOTAL,
	RUNNING_TOTAL
) as
SELECT
    ds.order_date,
    ds.daily_total,
    SUM(ds.daily_total) OVER (
        ORDER BY ds.order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM (
    SELECT
        o.order_date,
        SUM(o.order_total) AS daily_total
    FROM OPT_LAB_CLONE_4.RETAIL.orders AS o
    GROUP BY
        o.order_date
) AS ds;