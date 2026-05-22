
select * from retail_sales;

SELECT TOP 10 *
FROM retail_sales;

SELECT COUNT(*) AS total_records
FROM retail_sales;

--Check Null Values:

SELECT *
FROM retail_sales
WHERE sales IS NULL
   OR profit IS NULL;

--Check Duplicate Orders:

SELECT 
    order_id,
    COUNT(*) AS duplicate_count
FROM retail_sales
GROUP BY order_id
HAVING COUNT(*) > 1;

--KPI Analysis Queries:

--Total Revenue:

SELECT 
    SUM(sales) AS total_revenue
FROM retail_sales;

--Total Profit:

SELECT 
    SUM(profit) AS total_profit
FROM retail_sales;

--Profit Margin %:

SELECT 
    ROUND(
        SUM(profit) * 100.0 / SUM(sales),
        2
    ) AS profit_margin_percent
FROM retail_sales;

--Top Category by Revenue:

SELECT TOP 1
    category,
    SUM(sales) AS total_sales
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

--Revenue by Region:

SELECT 
    region,
    SUM(sales) AS regional_revenue
FROM retail_sales
GROUP BY region
ORDER BY regional_revenue DESC;

--Monthly Revenue Trend:

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales) AS monthly_sales
FROM retail_sales
GROUP BY 
    YEAR(order_date),
    MONTH(order_date)
ORDER BY 
    order_year,
    order_month;

-- Sales by Region:

SELECT region,
       SUM(sales) AS total_sales
FROM retail_sales
GROUP BY region
ORDER BY total_sales DESC;

-- Insight: West region has highest sales,South generates the least revenue.

-- Top Products(top 10):

SELECT TOP 10 sub_category,
       SUM(sales) AS total_sales
FROM retail_sales
GROUP BY sub_category
ORDER BY total_sales DESC;

-- Advanced SQL:Top 10 Customers(total revenue wise)

SELECT TOP 10 customer_name,
       SUM(sales) AS total_spent,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS rnk
FROM retail_sales
GROUP BY customer_name;


-- ADVANCED SQL CASE STUDY:


-- Loss-Making Products:

SELECT sub_category,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM retail_sales
GROUP BY sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Insights:
-- High sales ≠ profitable
-- Fix pricing or discounts

-- Regional Performance Ranking:

SELECT region,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank
FROM retail_sales
GROUP BY region;

-- Customer Lifetime Value (CLV):
-- Who are your most valuable customers?

SELECT TOP 10 customer_name,
       COUNT(DISTINCT order_id) AS total_orders,
       SUM(sales) AS total_spent,
       AVG(sales) AS avg_order_value
FROM retail_sales
GROUP BY customer_name
ORDER BY total_spent DESC


-- Insight
-- High CLV customers → retention focus:


-- Category Contribution %
-- Which categories drive revenue share?

SELECT category,
       SUM(sales) AS total_sales,
       ROUND(SUM(sales) * 100 / SUM(SUM(sales)) OVER (), 2) AS contribution_pct
FROM retail_sales
GROUP BY category;

-- Insight
-- Technology category drives the most revenue.




-- Top Products per Category:

SELECT *
FROM (
    SELECT category,
           sub_category,
           SUM(sales) AS total_sales,
           RANK() OVER (PARTITION BY category ORDER BY SUM(sales) DESC) AS rnk
    FROM retail_sales
    GROUP BY category, sub_category
) t
WHERE rnk <= 3;

-- Insight
-- Helps inventory & marketing

-- High Discount Impact (Proxy via Profit):

SELECT sub_category,
       AVG(profit / sales) AS avg_margin
FROM retail_sales
GROUP BY sub_category
ORDER BY avg_margin;

-- Insight
-- Low margin = possible heavy discounting

-- Customer Retention (Repeat Buyers):

-- Who are repeat customers?

SELECT customer_name,
       COUNT(DISTINCT order_id) AS orders_count
FROM retail_sales
GROUP BY customer_name
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY orders_count DESC;

-- Insight
-- Repeat customers = loyal segment


-- Running total:

SELECT
    order_date,
    sales,
    SUM(sales) OVER(
        ORDER BY order_date
    ) AS running_total
FROM retail_sales;

-- Regional ranking:

SELECT
    region,
    customer_name,
    sales,
    ROW_NUMBER() OVER(
        PARTITION BY region
        ORDER BY sales DESC
    ) AS regional_rank
FROM retail_sales;

--Create Dashboard View:

CREATE VIEW retail_dashboard_view AS
SELECT 
    region,
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(order_id) AS total_orders
FROM retail_sales
GROUP BY 
    region,
    category;

--Query view:

SELECT *
FROM retail_dashboard_view;














