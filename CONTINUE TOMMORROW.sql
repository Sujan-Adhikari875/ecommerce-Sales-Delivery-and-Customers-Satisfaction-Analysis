--Create the DataBase
CREATE DATABASE E_commerce_Sales
GO;
--Command For DataBase
USE  E_commerce_Sales
GO;
--Select Table
SELECT TOP 2 * FROM  olist_data;
SELECT TOP 2 * FROM olist_geolocation_dataset;
SELECT TOP 2* FROM  olist_order_items_dataset;
SELECT TOP 2* FROM  olist_order_payments_dataset;
SELECT TOP 2* FROM  olist_order_reviews_dataset;
SELECT TOP 2* FROM  olist_orders_dataset;
SELECT TOP 2* FROM  olist_products_dataset;

--Create The new table 
SELECT 
o.order_id,
o.customer_id,
o.order_purchase_timestamp,
o.order_delivered_customer_date,

oi.product_id,
oi.price,

p.payment_value,
p.payment_type,

r.review_score

INTO dbo.e_commerce_master

FROM  olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
join  olist_order_payments_dataset p
ON o.order_id = p.order_id
LEFT JOIN  olist_order_reviews_dataset r
ON o.order_id = r.order_id


--Add New feature 
SELECT 
*,
DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)  AS delivery_Days,
FORMAT(order_purchase_timestamp, 'yyy-MM') AS order_Month
INTO e_commerce_clean
FROM e_commerce_master

--Monthly Revenue Trend
SELECT 
	order_Month,
	ROUND(SUM(COALESCE(payment_value, 0)), 2) AS REVENUE
FROM e_commerce_clean
GROUP BY order_Month
ORDER BY order_month

--Top Products by Revenue
SELECT 
	product_id,
	ROUND(SUM(COALESCE(price, 0)),2) AS total_sales
FROM e_commerce_clean
GROUP BY product_id
ORDER BY total_sales DESC

--Payment Method Analysis
SELECT 
	payment_type,
	COUNT(*) AS Total_orders,
	ROUND(SUM(COALESCE(payment_value, 0)), 2) AS REVENUE
FROM e_commerce_clean

GROUP BY payment_type


--Delivery Performance 
SELECT 
AVG(delivery_Days) AS avg_delivery_days
FROM e_commerce_clean

--Review Score Analysis
SELECT 
	review_score,
	count(*) AS Total_REview
FROM e_commerce_clean
GROUP BY review_score
ORDER BY review_score

--DElay vs Review Score 
SELECT
	review_score,
	AVG(delivery_days) AS avg_delivery
FROM e_commerce_clean
GROUP BY review_score
ORDER BY review_score








