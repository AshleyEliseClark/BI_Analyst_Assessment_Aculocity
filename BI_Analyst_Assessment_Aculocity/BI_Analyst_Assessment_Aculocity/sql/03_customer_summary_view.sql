CREATE OR REPLACE VIEW customer_summary AS
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spent,
    AVG(order_amount) AS average_order_value,
    MAX(order_date) AS last_order_date
FROM 
    orders
GROUP BY 
    customer_id, customer_name;