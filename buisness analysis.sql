CREATE DATABASE buisness;
USE buisness;

CREATE TABLE cd (
    row_id INT,
    order_id VARCHAR(50),
    order_date VARCHAR(50),
    year INT,
    month VARCHAR(20),
    ship_date VARCHAR(50),
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    user_name VARCHAR(100),
    segment VARCHAR(50),
    country_region VARCHAR(100),
    city VARCHAR(100),
    state_province VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    service VARCHAR(255),
    revenue DECIMAL(10, 4),
    quantity INT,
    discount DECIMAL(5, 2),
    profit DECIMAL(10, 4),
    revenue_category VARCHAR(50)
);

LOAD DATA LOCAL INFILE 'C:/Users/USER/Desktop/data_analysis(excel)/Project 8/sheet 1.csv'
INTO TABLE cd
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT count(*) FROM cd;

##  Total Revenue Overview
SELECT 
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT order_id) as total_orders,
    COUNT(DISTINCT customer_id) as total_customers,
    ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) as avg_order_value
FROM cd;

## Top Products (What Sells Best?)
SELECT 
    service as product_name,
    category,
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT order_id) as order_count,
    ROUND(SUM(revenue) / SUM(quantity), 2) as revenue_per_unit
FROM cd
GROUP BY service, category
ORDER BY total_revenue DESC
LIMIT 10;

## Sales by Month (Trending)
SELECT 
    year,
    month,
    SUM(revenue) as monthly_revenue,
    COUNT(DISTINCT order_id) as monthly_orders
FROM cd
GROUP BY year, month
ORDER BY year DESC, FIELD(month, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec') DESC;

## Sales by Customer Type (Consumer vs Corporate)
SELECT 
    segment,
    COUNT(DISTINCT customer_id) as customer_count,
    SUM(revenue) as total_revenue,
    ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) as revenue_per_customer
FROM cd
GROUP BY segment
ORDER BY total_revenue DESC;

## Profitability (Are We Making Money?)
SELECT 
    category,
    SUM(revenue) as total_revenue,
    SUM(profit) as total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) as profit_margin_percent,
    ROUND(AVG(discount), 4) as avg_discount
FROM cd
GROUP BY category
ORDER BY total_profit DESC;

## Customer Retention
SELECT 
    user_name,
    COUNT(DISTINCT order_id) as total_purchases,
    SUM(revenue) as customer_total_spent,
    MAX(order_date) as last_purchase_date
FROM cd
GROUP BY user_name
ORDER BY total_purchases DESC
LIMIT 20;

## Sales by Region
SELECT 
    region,
    state_province,
    COUNT(DISTINCT order_id) as order_count,
    SUM(revenue) as total_revenue,
    COUNT(DISTINCT customer_id) as customer_count
FROM cd
GROUP BY region, state_province
ORDER BY total_revenue DESC;

## Discount Impact (Are Discounts Helping?)
SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.1 THEN '1-10% Discount'
        WHEN discount <= 0.2 THEN '11-20% Discount'
        ELSE '20%+ Discount'
    END as discount_level,
    COUNT(DISTINCT order_id) as order_count,
    ROUND(SUM(revenue), 2) as total_revenue,
    ROUND(SUM(profit), 2) as total_profit,
    ROUND(SUM(profit) / SUM(revenue) * 100, 2) as profit_margin
FROM cd
GROUP BY discount_level
ORDER BY discount_level DESC;
