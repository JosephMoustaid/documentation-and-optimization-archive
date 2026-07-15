CREATE OR REPLACE PROCEDURE RETAIL.SP_RECALC_ORDER_TOTALS()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    v_rows_processed NUMBER := 0;
BEGIN
    MERGE INTO orders o
    USING (
        SELECT
            oi.order_id,
            COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS order_total
        FROM order_items oi
        GROUP BY oi.order_id
    ) s
    ON o.order_id = s.order_id
    WHEN MATCHED THEN
        UPDATE SET o.order_total = s.order_total;

    v_rows_processed := SQLROWCOUNT;

    RETURN 'Recalculated ' || v_rows_processed || ' order totals (the slow way).';
END;
$$