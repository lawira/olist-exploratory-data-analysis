-- Generate a Report that shows all key metrics of the business
SELECT
	'Total Sales' measure_name,
	SUM(payment_value) measure_value
FROM gold.fact_payments
UNION ALL
SELECT
	'Total Item Sold' measure_name,
	COUNT(order_key) measure_value
FROM gold.fact_order_items
UNION ALL
SELECT
	'Average Price' measure_name,
	AVG(price) masure_value
FROM gold.fact_order_items
UNION ALL
SELECT
	'Total Orders' measure_name,
	COUNT(order_key) measure_value
FROM gold.fact_orders
UNION ALL
SELECT
	'Total Products' measure_name,
	COUNT(DISTINCT product_key) measure_value
FROM gold.fact_order_items
UNION ALL
SELECT
	'Total Customers' measure_name,
	COUNT(customer_key) measure_value
FROM gold.dim_customers
UNION ALL
SELECT
	'Total Customer Orders' measure_name,
	COUNT(DISTINCT customer_key) measure_value
FROM gold.fact_orders
