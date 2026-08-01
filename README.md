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

# FNB Sales Performance & Pricing Analysis

## Project Overview

This project analyses historical retail sales data to evaluate product performance, pricing strategy, profitability, and customer demand. Using SQL in Databricks, I developed key business metrics and analytical models to identify sales trends, promotional periods, and price elasticity of demand. The findings were presented through interactive dashboards created in Databricks and Looker Studio.

The project demonstrates my ability to transform raw transactional data into meaningful business insights that support pricing, promotional planning, and operational decision-making.

---

## Business Objectives

This analysis was designed to answer the following business questions:

- What is the daily sales price per unit?
- What is the average unit sales price?
- What is the daily gross profit percentage?
- What is the gross profit per unit?
- Which promotional periods can be identified from the sales data?
- How price-sensitive are customers during promotional periods?
- Does promotional pricing improve sales performance?

---

## Tools & Technologies

| Tool | Purpose |
|--------|---------|
| Databricks SQL | Data exploration and analysis |
| Databricks Dashboards | KPI dashboard development |
| Looker Studio | Interactive reporting |
| Microsoft Excel | Data validation and calculations |
| GitHub | Version control and portfolio |
| Lovable | Dashboard presentation |
| Miro | Project planning |
| Canva | Documentation and presentation assets |

---

## SQL Techniques Demonstrated

This project applies a range of SQL techniques, including:

- Common Table Expressions (CTEs)
- Window Functions
- Aggregate Functions
- Date Functions
- CASE Statements
- KPI Development
- Gross Profit Calculations
- Rolling Averages
- Promotional Period Detection
- Price Elasticity Analysis
- Year-over-Year Performance Analysis

---

## Dashboard Overview

The interactive dashboards provide business users with a clear view of sales performance and pricing behaviour.

### Dashboard Components

- Executive KPI Scorecards
- Daily Sales Price per Unit
- Daily Gross Profit Margin (%)
- Gross Profit per Unit
- Average Sales by Day of Week
- Promotional Period Analysis
- Price Elasticity of Demand
- Year-over-Year Performance

---

## Key Performance Indicators

The project measures the following business metrics:

- Total Sales
- Total Units Sold
- Average Unit Sales Price
- Gross Profit
- Gross Profit Margin (%)
- Average Daily Sales

---

## Methodology

### Unit Economics

Key financial metrics were derived directly from transactional sales data, including:

- Sales Price per Unit = Sales ÷ Quantity Sold
- Gross Profit = Sales − Cost of Sales
- Gross Profit Margin = Gross Profit ÷ Sales

The Average Unit Sales Price was calculated as a Rand-weighted average rather than a simple arithmetic mean to better reflect actual revenue contribution.

### Promotional Period Detection

The dataset did not contain a promotional flag. Promotional periods were therefore inferred statistically by:

- Identifying prices more than one standard deviation below the baseline average.
- Grouping consecutive qualifying dates using a gaps-and-islands approach.

### Validation

A second independent detection model using a rolling 14-day Z-score (implemented in PySpark) was used to validate the identified promotional periods.

- Two promotional periods were confirmed automatically.
- One required manual review because an extreme price outlier distorted the local baseline.

This limitation is documented rather than concealed.

### Price Elasticity

Price Elasticity of Demand (PED) was calculated as:

**PED = % Change in Quantity Sold ÷ % Change in Price**

Each promotional period was compared against the previous 14 trading days.

---

## Key Findings

The analysis produced several business insights:

- Selling prices remained relatively stable across most of the analysis period.
- Promotional pricing increased unit sales.
- Gross profit margins declined during promotional campaigns.
- Customer purchasing behaviour varied by day of the week.
- Price Elasticity of Demand indicates customers respond positively to price reductions.

---

## Business Recommendations

Based on the findings:

- Continue targeted promotional campaigns during high-opportunity periods.
- Monitor gross profit margins to balance volume growth with profitability.
- Use elasticity insights to determine optimal discount levels.
- Increase inventory ahead of promotional campaigns.
- Continue monitoring pricing trends to optimise future promotions.

---

## Project Workflow

The project followed a structured analytics lifecycle:

1. Business Problem Definition
2. Data Exploration
3. Data Quality Assessment
4. SQL Analysis
5. Feature Engineering
6. Promotional Period Detection
7. Price Elasticity Validation
8. Dashboard Development
9. Business Insights & Recommendations

Supporting documentation, planning artefacts, and the project timeline are included in the repository.

---

## Repository Structure

```
README.md

├── 1. Project Description
│   ├── Business Objectives
│   ├── Project Overview
│   ├── Tools & Technologies
│   ├── Methodology
│   ├── Key Findings
│   ├── Business Recommendations
│   └── Project Outcome
│
├── 2. Project Planning
│   ├── Miro Planning Board
│   ├── Project Workflow
│   └── Gantt Chart
│
├── 3. Data Processing
│   ├── SQL Scripts
│   ├── Databricks Notebooks
│   ├── Data Cleaning
│   ├── Feature Engineering
│   ├── KPI Calculations
│   └── Validation
│
├── 4. Project Presentation & Visualisations
│   ├── Databricks Dashboard
│   ├── Looker Studio Dashboard
│   ├── Excel Analysis
│   ├── Dashboard Screenshots
│   └── Final Presentation
```
---```

## Repository Contents

This repository contains the complete end-to-end analytics project, including:

- Project planning documentation
- SQL scripts and Databricks notebooks
- Data cleaning and feature engineering
- KPI calculations and business metrics
- Dashboard screenshots
- Looker Studio dashboard
- Databricks dashboard
- Final project presentation
- Business recommendations
---


## Limitations

- Promotional periods were inferred statistically because no promotional flag existed in the source data.
- Price Elasticity values are higher than typically observed in retail datasets and should be interpreted as characteristics of the simulated dataset.
- The years 2013 and 2016 contain partial-year data; Year-over-Year comparisons were normalised on a per-trading-day basis.

---


## Skills Demonstrated

This project highlights the following skills:

- SQL Development
- Data Cleaning
- Exploratory Data Analysis (EDA)
- KPI Development
- Business Intelligence
- Dashboard Design
- Data Visualisation
- Pricing Strategy Analysis
- Business Storytelling
- Decision Support
- Statistical Analysis

---

## Project Outcome


This project demonstrates how SQL, business intelligence, and statistical analysis can be combined to transform raw sales data into actionable business insights. The resulting dashboards and recommendations provide practical support for pricing strategy, promotional planning, and overall sales performance.

---


## About Me

I am an aspiring Data Analyst with a BCom in Information Management and hands-on experience in SQL, Databricks, Power BI, Looker Studio, Microsoft Excel, and Generative AI. I enjoy solving business problems with data by building analytical solutions that transform complex information into clear, actionable insights.
