# 📊FNB Sales Case Study

## Project Overview

This project analyzes historical sales data to evaluate product performance, pricing strategies, profitability, and customer demand. Using SQL in Databricks, I developed key business metrics and analytical models to identify sales trends, promotional periods, and price elasticity of demand. The findings were then visualized in Looker Studio through an interactive dashboard.

This project demonstrates my ability to transform raw transactional data into meaningful business insights that support pricing, promotional, and operational decision-making.

---

## Business Objectives

The analysis was conducted to answer the following business questions:

* What is the daily sales price per unit?
* What is the average unit sales price?
* What is the daily gross profit percentage?
* What is the daily gross profit per unit?
* Which promotional periods can be identified from the data?
* What is the Price Elasticity of Demand during these promotional periods?
* Does the product perform better when sold at a promotional price?

---

## Tools & Technologies

* **Databricks SQL**
* **Databricks Dashboards**
* **Looker Studio**
* **Microsoft Excel**
* **GitHub**
* **Lovable**
* **Miro**
* **Canva**

---

## SQL Techniques Demonstrated

Throughout this project, I applied a variety of SQL techniques, including:

* Common Table Expressions (CTEs)
* Window Functions
* Aggregate Functions
* Date Functions
* Conditional Logic (CASE Statements)
* KPI Development
* Gross Profit Calculations
* Price Elasticity Analysis
* Promotional Period Detection
* Year-over-Year Performance Analysis

---

## Dashboard Overview

The interactive dashboard was built in Looker Studio to present the key findings in a business-friendly format.

### Dashboard Components

* Executive KPI Scorecards
* Daily Sales Price per Unit
* Daily Gross Profit %
* Gross Profit per Unit
* Average Sales by Day of Week
* Promotional Period Analysis
* Price Elasticity of Demand
* Year-over-Year Performance


---

## Key Performance Indicators

The dashboard includes the following business metrics:

* Total Sales
* Total Units Sold
* Average Unit Sales Price
* Gross Profit
* Gross Profit Margin (%)
* Average Daily Sales

---
## Methodology
Unit economics: derived directly from the raw columns (Sales ÷ Quantity Sold, (Sales − Cost of Sales) ÷ Sales, etc.), with the average unit price calculated as a Rand-weighted average rather than a simple mean of daily prices.
Promo detection: no promo flag exists in the data, so promotional periods were inferred statistically — days priced more than 1 standard deviation below a baseline are flagged, then grouped into runs using a gaps-and-islands technique.
Validation: a second, independent detection method (rolling 14-day z-score, built in PySpark) was used to cross-check the selected periods rather than trusting a single pass. Two of three periods were confirmed directly; the third required manual judgment after the automated method missed it due to an outlier price spike skewing its local baseline — documented as an explicit limitation rather than hidden.
Elasticity: PED = %Δ Quantity ÷ %Δ Price, comparing each promotional window to the 14 trading days immediately preceding it.

----

## Key Findings

The analysis identified several important business insights:

* Daily selling prices remained relatively stable over the analysis period.
* Gross profit margins fluctuated in response to promotional pricing.
* Promotional periods resulted in noticeable increases in units sold.
* Sales performance varied across different days of the week, indicating seasonal buying patterns.
* The calculated Price Elasticity of Demand suggests that customers are responsive to price reductions during promotional periods.

---

## Business Recommendations

Based on the analysis, the following recommendations are proposed:

* Continue implementing targeted promotional campaigns during strategic periods to increase sales volume.
* Monitor Gross Profit Margins during promotions to ensure increased demand remains profitable.
* Use Price Elasticity insights to determine optimal discount levels that maximise revenue while protecting profitability.
* Increase inventory planning before promotional campaigns to meet anticipated demand.
* Continue monitoring sales trends to identify additional opportunities for revenue growth.

---

## Skills Demonstrated

This project showcases the following analytical skills:

* Data Cleaning
* SQL Query Development
* Business Intelligence
* KPI Development
* Exploratory Data Analysis
* Pricing Strategy Analysis
* Dashboard Design
* Data Visualisation
* Business Storytelling
* Decision Support

---

## Project Outcome

This project demonstrates how SQL and Business Intelligence tools can be used together to transform raw sales data into actionable business insights. By combining data analysis, KPI development, and interactive visualisations, the project provides recommendations that support pricing strategy, promotional planning, and overall business performance.

---
## Process
This project followed a structured analysis workflow: framing data-driven questions → analysis planning → data exploration & quality checks → deeper analysis (SQL metrics) → feature engineering (rolling averages, promo flags) → promo detection & elasticity validation → building deliverables (Excel, PySpark, dashboards) → communicating findings. See gantt_chart.png and the notes/ folder for the full breakdown.
Limitations
Promotional periods are inferred statistically, not confirmed by an actual promo flag in the source data
Price elasticity values in this dataset are notably higher than typical real-world retail elasticity — treated as a feature of this simulated dataset
2013 and 2016 are partial years in the dataset; year-over-year comparisons are normalized to a per-trading-day basis to account for this.

-------
## About Me

I am an aspiring Data Analyst with a BCom in Information Management and experience in SQL, Databricks, Power BI, Looker Studio, Generative AI, and Excel. I enjoy transforming data into meaningful insights that help organisations make informed business decisions.


