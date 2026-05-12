-- Which 5 products generate the highest revenue
SELECT TOP 5
	oi.product_key,
	SUM(fp.payment_value) product_revenue
FROM gold.fact_payments fp
LEFT JOIN gold.fact_order_items oi ON fp.order_key = oi.order_key
GROUP BY oi.product_key
ORDER BY product_revenue DESC;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
	oi.product_key,
	SUM(fp.payment_value) product_revenue
FROM gold.fact_payments fp
LEFT JOIN gold.fact_order_items oi ON fp.order_key = oi.order_key
GROUP BY oi.product_key
ORDER BY product_revenue;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
	dc.unique_id,
	SUM(fp.payment_value) customer_spendings
FROM gold.fact_payments fp
LEFT JOIN gold.fact_orders fo ON fp.order_key = fo.order_key
LEFT JOIN gold.dim_customers dc ON fo.customer_key = dc.customer_key
GROUP BY dc.unique_id
ORDER BY customer_spendings DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
	dc.unique_id,
	COUNT(order_id) total_orders
FROM gold.fact_orders fo
LEFT JOIN gold.dim_customers dc ON fo.customer_key = dc.customer_key 
GROUP BY dc.unique_id
ORDER BY total_orders;
