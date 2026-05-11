-- Payments
WITH rowCTE AS (
	SELECT
		ROW_NUMBER() OVER(ORDER BY payment_value) row_position,
		payment_value
	FROM gold.fact_payments
),
formulaCTE AS (
	SELECT
		(COUNT(payment_value) + 1) / 2 odd,
		COUNT(payment_value) / 2 even
	FROM rowCTE
),
medianCTE AS (
	SELECT
		CASE
			WHEN COUNT(payment_value) % 2 != 0 THEN (SELECT payment_value FROM rowCTE WHERE row_position = (SELECT odd FROM formulaCTE))
			WHEN COUNT(payment_value) % 2 = 0 THEN ((SELECT payment_value FROM rowCTE WHERE row_position = (SELECT even FROM formulaCTE)) + (SELECT payment_value FROM rowCTE WHERE row_position = (SELECT even FROM formulaCTE) + 1)) / 2
		END median
	FROM rowCTE
)
SELECT
	SUM(payment_value) total_sales,
	MIN(payment_value) lowest_sales,
	MAX(payment_value) highest_sales,
	AVG(payment_value) mean_sales,
	(SELECT median FROM medianCTE) median_sales,
	ROUND(STDEVP(payment_value), 2) standard_deviation,
	CONCAT(((STDEVP(payment_value) / AVG(payment_value)) * 100), '%') coeffecient_of_variation
FROM gold.fact_payments;
