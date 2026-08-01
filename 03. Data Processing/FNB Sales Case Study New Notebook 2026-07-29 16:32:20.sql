-- Databricks notebook source
-- ==========================================================
-- FNB Sales Case Study
-- Data Cleaning & Transformation
-- Author: Charlotte Turya
-- ==========================================================




Select * --------Checking dataset
from bright.sales.sales_case_study_;


SELECT COUNT(*) AS total_rows-----Checkecking number of rows
FROM bright.sales.sales_case_study_;


-- ----------------------------------------------------------------------------
-- 0. BASE VIEW — 
--    Reused by every query below so the metric logic lives in exactly one place.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_sales_metrics AS
SELECT
    Date,
    Sales,
    `Cost Of Sales`,
    `Quantity Sold`,
    Sales / `Quantity Sold`                          AS price_per_unit,      
    -- Q1: daily sales price per unit
    `Cost Of Sales` / `Quantity Sold`                   AS cost_per_unit,
    (Sales - `Cost Of Sales`)                          AS gross_profit,
    (Sales - `Cost Of Sales`) / Sales                  AS gross_profit_pct,  
    -- Q3: daily % gross profit
    (Sales - `Cost Of Sales`) / `Quantity Sold`          AS gross_profit_per_unit,
    -- Q4: daily % gross profit per unit.
    -- Note: this simplifies to (Sales-`Cost Of Sales`)/Sales, i.e. identical to
    -- gross_profit_pct above, since the `Quantity Sold` term cancels out. Kept
    -- as its own column to answer the brief literally.
    ((Sales - `Cost Of Sales`) / `Quantity Sold`) / (Sales / `Quantity Sold`) AS gross_profit_pct_per_unit
FROM bright.sales.sales_case_study_;

DESCRIBE bright.sales.sales_case_study_;





 
-- ----------------------------------------------------------------------------
-- Q1. DAILY SALES PRICE PER UNIT
-- ----------------------------------------------------------------------------
SELECT `date`, ROUND(price_per_unit, 2) AS price_per_unit
FROM vw_sales_metrics
ORDER BY `date`;
 
 
-- ----------------------------------------------------------------------------
-- Q2. AVERAGE UNIT SALES PRICE OF THE PRODUCT (Rand-weighted)
-- ----------------------------------------------------------------------------
SELECT
    ROUND(SUM(Sales) / SUM(`Quantity Sold`), 2) AS avg_unit_sales_price,
    ROUND(AVG(price_per_unit), 2)             AS avg_of_daily_prices_unweighted
FROM vw_sales_metrics;
 
 
-- ----------------------------------------------------------------------------
-- Q3 & Q4. DAILY % GROSS PROFIT AND DAILY % GROSS PROFIT PER UNIT
-- ----------------------------------------------------------------------------
SELECT `date`, 
    ROUND(gross_profit, 2) AS gross_profit, 
    ROUND(gross_profit_pct, 2) AS gross_profit_pct, 
    ROUND(gross_profit_per_unit, 2) AS gross_profit_per_unit, 
    ROUND(gross_profit_pct_per_unit, 2) AS gross_profit_pct_per_unit
FROM vw_sales_metrics
ORDER BY `date`;
 
 
-- ============================================================================
-- Q5. PROMOTIONAL PERIODS & PRICE ELASTICITY OF DEMAND
-- ============================================================================
 
CREATE OR REPLACE VIEW vw_price_stats AS
SELECT
    AVG(price_per_unit) AS mean_price,
    STDDEV(price_per_unit) AS sd_price
FROM vw_sales_metrics;
 
CREATE OR REPLACE VIEW vw_low_price_days AS
SELECT m.`date`, m.price_per_unit, m.`Quantity Sold`
FROM vw_sales_metrics m
CROSS JOIN vw_price_stats s
WHERE m.price_per_unit < s.mean_price - s.sd_price;
 
CREATE OR REPLACE VIEW vw_promo_clusters AS
WITH ranked AS (
    SELECT
        `date`,
        price_per_unit,
        `Quantity Sold`,
        ROW_NUMBER() OVER (ORDER BY `date`) AS rn
    FROM vw_low_price_days
),
grouped AS (
    SELECT
        *,
        DATE_SUB(`date`, rn) AS grp
    FROM ranked
)
SELECT
    grp,
    MIN(`date`)              AS promo_start,
    MAX(`date`)              AS promo_end,
    COUNT(*)                 AS promo_days,
    AVG(price_per_unit)      AS promo_avg_price,
    AVG(`Quantity Sold`)     AS promo_avg_qty
FROM grouped
GROUP BY grp
ORDER BY promo_start;
 
-- Inspect candidate clusters before picking the 3 you want to use below:
SELECT 
    grp,
    promo_start,
    promo_end,
    promo_days,
    ROUND(promo_avg_price, 2) AS promo_avg_price,
    ROUND(promo_avg_qty, 2) AS promo_avg_qty
FROM vw_promo_clusters 
ORDER BY promo_days DESC;
 
 
-- 5a. PRICE ELASTICITY OF DEMAND for 3 selected periods
--     (dates below match the ones used in the Excel/PPT deliverables —
--      update them if you pick different clusters from the query above)
WITH periods AS (
    SELECT 1 AS period_num, DATE'2014-09-24' AS promo_start, DATE'2014-10-06' AS promo_end,
           DATE'2014-09-10' AS base_start,  DATE'2014-09-23' AS base_end
    UNION ALL
    SELECT 2, DATE'2015-09-23', DATE'2015-10-06', DATE'2015-09-09', DATE'2015-09-22'
    UNION ALL
    SELECT 3, DATE'2016-06-23', DATE'2016-07-06', DATE'2016-06-09', DATE'2016-06-22'
),
baseline AS (
    SELECT p.period_num,
           AVG(m.price_per_unit) AS base_avg_price,
           AVG(m.`Quantity Sold`)  AS base_avg_qty
    FROM periods p
    JOIN vw_sales_metrics m
      ON m.`date` BETWEEN p.base_start AND p.base_end
    GROUP BY p.period_num
),
promo AS (
    SELECT p.period_num,
           AVG(m.price_per_unit) AS promo_avg_price,
           AVG(m.`Quantity Sold`)  AS promo_avg_qty,
           SUM(m.gross_profit)   AS promo_total_gp
    FROM periods p
    JOIN vw_sales_metrics m
      ON m.`date` BETWEEN p.promo_start AND p.promo_end
    GROUP BY p.period_num
)
SELECT
    p.period_num,
    p.promo_start, p.promo_end,
    ROUND(b.base_avg_price, 2) AS base_avg_price,
    ROUND(b.base_avg_qty, 2) AS base_avg_qty,
    ROUND(pr.promo_avg_price, 2) AS promo_avg_price,
    ROUND(pr.promo_avg_qty, 2) AS promo_avg_qty,
    ROUND((pr.promo_avg_price - b.base_avg_price) / b.base_avg_price, 2) AS pct_change_price,
    ROUND((pr.promo_avg_qty  - b.base_avg_qty)  / b.base_avg_qty, 2) AS pct_change_qty,
    ROUND(((pr.promo_avg_qty - b.base_avg_qty) / b.base_avg_qty)
      / ((pr.promo_avg_price - b.base_avg_price) / b.base_avg_price), 2) AS price_elasticity_of_demand,
    ROUND(pr.promo_total_gp, 2) AS promo_total_gp
FROM periods p
JOIN baseline b ON b.period_num = p.period_num
JOIN promo pr    ON pr.period_num = p.period_num
ORDER BY p.period_num;
 
 
-- ============================================================================
-- Q6. OTHER INSIGHTS
-- ============================================================================
 
-- 6a. Overall profitability check
SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(`Cost Of Sales`), 2) AS total_cost_of_sales,
    ROUND(SUM(Sales) - SUM(`Cost Of Sales`), 2) AS total_gross_profit,
    ROUND((SUM(Sales) - SUM(`Cost Of Sales`)) / SUM(Sales), 2) AS overall_gross_profit_pct
FROM vw_sales_metrics;
 
-- 6b. Monthly trend
SELECT
    DATE_TRUNC('month', `date`) AS month,
    ROUND(SUM(Sales), 2) AS monthly_sales,
    ROUND(SUM(`Quantity Sold`), 2) AS monthly_qty,
    ROUND(SUM(gross_profit), 2) AS monthly_gross_profit,
    ROUND(SUM(gross_profit) / SUM(Sales), 2) AS monthly_gp_pct
FROM vw_sales_metrics
GROUP BY DATE_TRUNC('month', `date`)
ORDER BY month;
 
-- 6c. Day-of-week seasonality
SELECT
    DATE_FORMAT(`date`, 'EEEE') AS day_of_week,
    ROUND(AVG(`Quantity Sold`), 0) AS avg_qty,
    ROUND(AVG(price_per_unit), 2) AS avg_price_per_unit
FROM vw_sales_metrics
GROUP BY DATE_FORMAT(`date`, 'EEEE')
ORDER BY avg_qty DESC;
 
-- 6d. Most extreme gross-profit-% days (outlier / data-quality check)
SELECT `date`, 
    ROUND(Sales, 2) AS sales, 
    ROUND(`Cost Of Sales`, 2) AS cost_of_sales, 
    ROUND(`Quantity Sold`, 2) AS quantity_sold, 
    ROUND(gross_profit_pct, 2) AS gross_profit_pct
FROM vw_sales_metrics
ORDER BY gross_profit_pct ASC
LIMIT 10;




-- ============================================
-- COMPREHENSIVE BUSINESS SUMMARY - ONE TABLE
-- ============================================

WITH overall_metrics AS (
    SELECT
        ROUND(SUM(Sales), 2) AS total_sales,
        SUM(`Quantity Sold`) AS total_units_sold,
        ROUND(SUM(Sales - `Cost Of Sales`), 2) AS total_gross_profit,
        ROUND((SUM(Sales - `Cost Of Sales`) / NULLIF(SUM(Sales), 0)) * 100, 2) AS overall_gp_margin_pct,
        COUNT(DISTINCT `Date`) AS trading_days,
        ROUND(SUM(Sales) / COUNT(DISTINCT `Date`), 2) AS avg_daily_sales,
        ROUND(SUM(`Quantity Sold`) / COUNT(DISTINCT `Date`), 2) AS avg_daily_quantity,
        ROUND(SUM(Sales) / NULLIF(SUM(`Quantity Sold`), 0), 2) AS avg_unit_price
    FROM bright.sales.sales_case_study_
),
yearly_sales AS (
    SELECT
        YEAR(`Date`) AS year,
        ROUND(SUM(Sales), 0) AS yearly_sales
    FROM bright.sales.sales_case_study_
    GROUP BY YEAR(`Date`)
),
yearly_perf AS (
    SELECT
        MAX(CASE WHEN year = 2014 THEN yearly_sales END) AS sales_2014,
        MAX(CASE WHEN year = 2015 THEN yearly_sales END) AS sales_2015,
        MAX(CASE WHEN year = 2016 THEN yearly_sales END) AS sales_2016
    FROM yearly_sales
),
day_of_week_agg AS (
    SELECT
        DATE_FORMAT(`Date`, 'EEEE') AS day_name,
        ROUND(AVG(`Quantity Sold`), 0) AS avg_qty
    FROM bright.sales.sales_case_study_
    GROUP BY DATE_FORMAT(`Date`, 'EEEE')
),
day_of_week_best AS (
    SELECT
        day_name AS best_day_of_week,
        avg_qty AS best_day_avg_qty
    FROM day_of_week_agg
    ORDER BY avg_qty DESC
    LIMIT 1
),
price_stats AS (
    SELECT
        AVG(Sales / NULLIF(`Quantity Sold`, 0)) AS avg_price,
        STDDEV(Sales / NULLIF(`Quantity Sold`, 0)) AS std_price
    FROM bright.sales.sales_case_study_
),
promo_summary AS (
    SELECT
        COUNT(DISTINCT CASE 
            WHEN Sales / NULLIF(`Quantity Sold`, 0) < (ps.avg_price - ps.std_price)
            THEN `Date` 
        END) AS promo_days_detected,
        ROUND(MIN(Sales / NULLIF(`Quantity Sold`, 0)), 2) AS lowest_price_per_unit,
        ROUND(MAX(Sales / NULLIF(`Quantity Sold`, 0)), 2) AS highest_price_per_unit
    FROM bright.sales.sales_case_study_
    CROSS JOIN price_stats ps
)
SELECT
    -- Overall Business Metrics
    om.total_sales,
    om.total_units_sold,
    om.total_gross_profit,
    om.overall_gp_margin_pct,
    om.trading_days,
    om.avg_daily_sales,
    om.avg_daily_quantity,
    om.avg_unit_price,
    
    -- Yearly Performance
    yp.sales_2014,
    yp.sales_2015,
    yp.sales_2016,
    ROUND((yp.sales_2015 - yp.sales_2014) / NULLIF(yp.sales_2014, 0) * 100, 2) AS yoy_growth_2014_2015_pct,
    ROUND((yp.sales_2016 - yp.sales_2015) / NULLIF(yp.sales_2015, 0) * 100, 2) AS yoy_growth_2015_2016_pct,
    
    -- Day of Week Performance
    dow.best_day_of_week,
    dow.best_day_avg_qty,
    
    -- Promotional Insights
    ps.promo_days_detected,
    ps.lowest_price_per_unit,
    ps.highest_price_per_unit,
    ROUND((ps.highest_price_per_unit - ps.lowest_price_per_unit) / NULLIF(ps.lowest_price_per_unit, 0) * 100, 2) AS price_range_pct
    
FROM overall_metrics om
CROSS JOIN yearly_perf yp
CROSS JOIN day_of_week_best dow
CROSS JOIN promo_summary ps;


-- ============================================
-- DETAILED INDIVIDUAL SALES TABLE
-- One row per date with all metrics
-- ============================================

WITH price_threshold AS (
    SELECT
        AVG(Sales / NULLIF(`Quantity Sold`, 0)) - STDDEV(Sales / NULLIF(`Quantity Sold`, 0)) AS promo_threshold
    FROM bright.sales.sales_case_study_
)
SELECT
    -- Date Information
    `Date`,
    YEAR(`Date`) AS Year,
    DATE_FORMAT(`Date`, 'MMMM') AS Month,
    DATE_FORMAT(`Date`, 'EEEE') AS DayOfWeek,
    DAYOFWEEK(`Date`) AS DayNumber,
    
    -- Sales Metrics
    ROUND(Sales, 2) AS Sales,
    ROUND(`Cost Of Sales`, 2) AS CostOfSales,
    `Quantity Sold` AS QuantitySold,
    ROUND(Sales / NULLIF(`Quantity Sold`, 0), 2) AS PricePerUnit,
    
    -- Profitability Metrics
    ROUND(Sales - `Cost Of Sales`, 2) AS GrossProfit,
    ROUND((Sales - `Cost Of Sales`) / NULLIF(Sales, 0) * 100, 2) AS GrossProfitMarginPct,
    ROUND((Sales - `Cost Of Sales`) / NULLIF(`Quantity Sold`, 0), 2) AS GrossProfitPerUnit,
    
    -- Promotional Flag
    CASE 
        WHEN Sales / NULLIF(`Quantity Sold`, 0) < (SELECT promo_threshold FROM price_threshold)
        THEN 'Yes'
        ELSE 'No'
    END AS IsPromotionalDay,
    
    -- Performance Category
    CASE
        WHEN Sales > 200000 THEN 'High Performance'
        WHEN Sales > 100000 THEN 'Medium Performance'
        ELSE 'Low Performance'
    END AS PerformanceCategory
    
FROM bright.sales.sales_case_study_
ORDER BY `Date`;


 