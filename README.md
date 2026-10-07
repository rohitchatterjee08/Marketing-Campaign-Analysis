# Marketing Data Analysis

> A data analytics project analyzing customer marketing behavior, campaign response, product spending, purchasing channels, and customer value using Excel, Python, SQL/PostgreSQL, and Power BI.

## Project Overview

This project analyzes a customer marketing dataset containing **2,240 customer records and 28 original fields**.

The analysis focuses on understanding:

* Marketing campaign response
* Customer characteristics and segmentation
* Product spending
* Purchasing channels
* Online purchasing activity
* Previous campaign engagement
* Customer value
* Enrollment cohorts
* Family composition
* Country-level engagement

The overall workflow follows:

**Excel → Python (Pandas & NumPy) → SQL/PostgreSQL → Power BI → Insights & Recommendations**

The final outcome is a **three-page Power BI dashboard** supported by Python-based data preparation and SQL business analysis. 

---

## Business Problem

The business wants to understand which customers are more responsive to marketing campaigns, what characteristics are associated with higher spending and purchasing activity, which products and channels perform best, and which customers represent higher value.

The analysis can support decisions around:

* Campaign targeting
* Customer segmentation
* Product promotion
* Channel strategy
* Customer engagement
* Cohort-based planning
* Customer retention and value management

The findings describe **historical associations** and should not be interpreted as proof of causation. 

---

## Business Questions

The project addresses 16 business questions:

1. Which marketing campaign generated the highest customer acceptance?
2. What customer characteristics are associated with campaign success?
3. What factors are associated with higher online purchasing activity?
4. Which customer segments are most responsive to marketing campaigns?
5. Which products generate the highest customer spending?
6. Which purchasing channels are performing best?
7. Are marketing campaigns successfully driving additional purchases?
8. Which customers are most valuable based on spending and purchasing behavior?
9. Does discount-driven purchasing indicate an opportunity or dependency?
10. Which countries show the strongest customer engagement?
11. Which customer characteristics should be considered when targeting future campaigns?
12. Does customer tenure affect campaign response?
13. Does family size influence customer spending?
14. Does previous campaign engagement predict future campaign response?
15. Does web conversion rate differ between customer segments?
16. Do newer customers have different purchasing behavior? 

---

## Dataset

| Attribute                 | Details                    |
| ------------------------- | -------------------------- |
| Dataset                   | Customer marketing dataset |
| Original records          | 2,240                      |
| Original columns          | 28                         |
| Duplicate rows            | 0                          |
| Missing income values     | 24                         |
| Education categories      | 5                          |
| Marital-status categories | 8                          |
| Countries                 | 8                          |
| Enrollment period         | 2012–2014                  |
| Date format               | DD-MM-YYYY                 |

### Important Variables

**Customer & Demographics**

* `id`
* `year_birth`
* `education`
* `marital_status`
* `income`
* `country`

**Household & Enrollment**

* `kidhome`
* `teenhome`
* `dt_customer`
* `recency`

**Product Spending**

* `mntwines`
* `mntfruits`
* `mntmeatproducts`
* `mntfishproducts`
* `mntsweetproducts`
* `mntgoldprods`

**Purchasing Channels**

* `numwebpurchases`
* `numcatalogpurchases`
* `numstorepurchases`
* `numdealspurchases`
* `numwebvisitsmonth`

**Campaign & Engagement**

* `acceptedcmp1`–`acceptedcmp5`
* `response`
* `complain`

The original field definitions and data types are documented in the project report. 

---

## Tools & Technologies

| Tool                 | Purpose                                   |
| -------------------- | ----------------------------------------- |
| **Excel**            | Initial data exploration                  |
| **Python**           | Data cleaning, preprocessing and loading  |
| **Pandas**           | Data manipulation and feature engineering |
| **NumPy**            | Numerical calculations                    |
| **SQL / PostgreSQL** | Business analysis                         |
| **Power BI**         | Interactive dashboard and visualization   |

The supplied project package does not contain the Excel workbook, so specific Excel formulas or techniques cannot be independently verified. 

---

# Project Workflow

```text
Raw Dataset
     ↓
Excel
Initial Data Exploration
     ↓
Python
Data Cleaning & Preparation
     ↓
Pandas + NumPy
Feature Engineering & Validation
     ↓
SQL / PostgreSQL
Business Analysis
     ↓
Power BI
Dashboard & Visualization
     ↓
Business Insights
     ↓
Recommendations
```

### 1. Excel

Excel represents the initial exploration stage of the documented workflow.

Because the Excel workbook was not supplied, the specific Excel operations cannot be independently verified.

### 2. Python

Python was used for:

* Dataset loading
* Data inspection
* Missing-value handling
* Date conversion
* Feature engineering
* Validation
* PostgreSQL preparation/loading

### 3. Pandas & NumPy

Pandas was used for DataFrame manipulation and feature creation, while NumPy was used for numerical calculations such as the web conversion-rate calculation.

### 4. SQL / PostgreSQL

The cleaned dataset was loaded into a PostgreSQL table named `marketing`. SQL was then used to answer the project's business questions.

### 5. Power BI

The analysis was transformed into a three-page interactive dashboard containing KPI cards, charts, maps, slicers and analytical views. 

---

# Python – Data Cleaning & Preparation

## Data Inspection

```python
import numpy as np
import pandas as pd

df = pd.read_csv('marketing_data.csv')

df.info()
df.describe()
```

Column names were standardized:

```python
df.columns = df.columns.str.strip()
df.columns = df.columns.str.lower()
```

## Missing Income

There were **24 missing income values**.

The notebook filled them using the median income:

```python
df['income'] = df['income'].fillna(df['income'].median())
```

The median income was **51,381.50**. 

## Date & Age Features

```python
df['dt_customer'] = pd.to_datetime(
    df['dt_customer'],
    format='%d-%m-%Y'
)

df['customer_year'] = df['dt_customer'].dt.year
df['customer_month'] = df['dt_customer'].dt.month
df['age'] = df['customer_year'] - df['year_birth']
```

## Spending & Purchasing Features

```python
spending_cols = [
    'mntwines', 'mntfruits',
    'mntmeatproducts', 'mntfishproducts',
    'mntsweetproducts', 'mntgoldprods'
]

df['total_spend'] = df[spending_cols].sum(axis=1)
```

```python
purchase_cols = [
    'numwebpurchases',
    'numcatalogpurchases',
    'numstorepurchases'
]

df['total_purchase'] = df[purchase_cols].sum(axis=1)
```

Additional features included household children/teenagers, campaign acceptance count, web conversion rate, and a web-visit flag. 

## Validation

The final validation confirmed:

* 2,240 rows
* 28 original columns
* 0 duplicate rows
* 0 missing income values after treatment
* 11 remaining `web_conversion_rate` nulls
* 5 education categories
* 8 marital-status categories
* 8 countries

`year_birth` was subsequently removed after creating the derived `age` field. 

---

# SQL / PostgreSQL Analysis

The prepared dataset was loaded into PostgreSQL as the `marketing` table.

The SQL analysis covered campaign performance, customer segments, product spending, channels, engagement, customer value, offers, markets, tenure and family composition. 

## Campaign Performance

The latest campaign had the highest acceptance:

| Campaign        | Accepted Customers |
| --------------- | -----------------: |
| Latest Campaign |                334 |
| Campaign 4      |                167 |
| Campaign 3      |                163 |
| Campaign 5      |                163 |
| Campaign 1      |                144 |
| Campaign 2      |                 30 |

Campaign 2 is notably weaker than the other campaigns, while the latest campaign is the strongest in the available data. 

## Responders vs Non-Responders

| Metric         | Responders | Non-responders |
| -------------- | ---------: | -------------: |
| Customers      |        334 |          1,906 |
| Avg. Age       |      43.33 |          44.38 |
| Avg. Income    |  60,183.24 |      50,845.68 |
| Avg. Spend     |     987.39 |         538.93 |
| Avg. Purchases |      15.37 |          12.04 |

Responders show higher average income, spending and purchase activity, while average age is relatively similar. 

## Product Spending

| Product | Total Spending |
| ------- | -------------: |
| Wines   |        680,816 |
| Meat    |        373,968 |
| Gold    |         98,609 |
| Fish    |         84,057 |
| Sweets  |         60,621 |
| Fruits  |         58,917 |

Wines generate the highest total spending, followed by meat. 

## Channel Performance

| Channel | Total Purchases |
| ------- | --------------: |
| Store   |          12,970 |
| Web     |           9,150 |
| Catalog |           5,963 |

Store purchases represent the highest purchasing volume in the dataset. 

## Customer Value

Customer value was defined using business-rule thresholds:

* **High Value:** `total_spend >= 2000` and `total_purchase >= 15`
* **Medium Value:** `total_spend >= 1000` and `total_purchase >= 10`
* **Low Value:** all remaining customers

| Segment      | Customers | Avg. Spend | Avg. Purchases |
| ------------ | --------: | ---------: | -------------: |
| High Value   |        48 |   2,169.81 |          20.88 |
| Medium Value |       552 |   1,395.60 |          20.03 |
| Low Value    |     1,640 |     294.19 |           9.77 |

These thresholds are business rules rather than statistically optimized cutoffs. 

---

# Power BI Dashboard

The final Power BI report contains three pages:

### 1. Executive Overview

Includes:

* KPI cards
* Campaign Performance
* Product Spending
* Purchase Channel Performance
* Customer Response by Education
* Campaign Response Rate by Country
* Country slicer
* Age Group slicer
* Customer Year slicer
* Education slicer
* Marital Status slicer

### 2. Customer & Campaign Analysis

Includes:

* Campaign Response Rate by Age Group
* Average Total Spending by Income Group
* Average Spending by Number of Children
* Previous Campaign Engagement vs Latest Response
* Spending & Response by Customer Year

### 3. Product & Channel Analysis

Includes:

* Product Spending
* Channel Performance-related views
* Web Visits vs Average Purchases
* Web Purchases by Campaign Response
* Deals vs Average Total Purchases
* Customer Value Segments

The dashboard uses KPI cards, analytical charts, slicers and a dark visual theme. 

## Dashboard KPIs

| KPI                    |     Value |
| ---------------------- | --------: |
| Total Customers        |     2,240 |
| Total Spending         | 1,356,988 |
| Total Purchases        |    28,083 |
| Campaign Response Rate |    14.91% |
| Web Conversion Rate    |    76.83% |

The dashboard-level web conversion KPI is an aggregate ratio of web purchases to web visits and differs from the customer-level Python feature. 

---

# Key Insights

* The **latest campaign** has the highest acceptance count at **334**.
* Campaign 2 has substantially lower acceptance than the other campaigns.
* Responders have higher average spending and purchasing activity than non-responders.
* **Wines** generate the highest product spending.
* **Store** purchases have the highest channel volume.
* Previous campaign engagement has a strong positive relationship with latest campaign response.
* Customers with four previous campaign acceptances have a **90.91%** latest response rate compared with **8.22%** for customers with none.
* The 2012 enrollment cohort has a higher response rate and average spending than the 2014 cohort.
* Customers without children or teenagers show substantially higher average spending than customers with one or more.
* Deal usage does not show a simple monotonic relationship with spending.
* Small country or demographic groups should be treated cautiously because their response rates can be unstable. 

---

# Business Recommendations

### 1. Prioritize Previously Engaged Customers

Previous campaign acceptance is one of the strongest descriptive signals. Customers with prior engagement show substantially higher response rates.

### 2. Protect High-Value Customers

The High Value segment contains 48 customers with the highest average spending and purchasing activity. These customers can be considered for differentiated retention or loyalty strategies.

### 3. Focus Product Strategy on Leading Categories

Wines and meat represent the strongest product-spending categories and can be considered when planning product-focused campaigns.

### 4. Use Store Activity as a Key Channel Signal

Store purchases lead total purchasing volume, while web activity should be monitored separately.

### 5. Consider Customer Cohort

Enrollment year shows meaningful differences in response and spending. Newer customers may benefit from stronger onboarding and engagement strategies.

### 6. Avoid Over-Reliance on Small Segments

Extremely small demographic or country groups can produce very high or low response rates that may not generalize. Broader segments with adequate sample sizes are more reliable for decision-making. 

---

# Project Highlights

* Data exploration
* Data cleaning
* Missing-value handling
* Date transformation
* Feature engineering
* Pandas DataFrame manipulation
* NumPy numerical operations
* SQL business analysis
* PostgreSQL
* Customer segmentation
* Cohort analysis
* Product and channel analysis
* Power BI dashboard development
* KPI analysis
* Data storytelling
* Business recommendations

---

# Repository Structure

Since the supplied project evidence does not provide a verified final GitHub file structure, the following is a **recommended organization** rather than a claim about existing filenames:

```text
marketing-data-analysis/
│
├── data/
│   └── marketing_data.csv
│
├── python/
│   └── marketing_analysis.ipynb
│
├── sql/
│   └── marketing_analysis.sql
│
├── dashboard/
│   └── powerbi-dashboard.png
│
├── images/
│   ├── excel-exploration.png
│   ├── jupyter-cleaning.png
│   ├── sql-analysis.png
│   └── powerbi-dashboard.png
│
├── documentation/
│   └── Marketing_Data_Analysis_Project_Documentation.pdf
│
└── README.md
```

> **Note:** The Excel workbook and dedicated screenshot files were not included in the supplied evidence package, so their filenames should be replaced with the actual files you add to GitHub.

---

# Skills Demonstrated

**Data Exploration**

* Microsoft Excel

**Data Cleaning & Manipulation**

* Python
* Pandas
* NumPy

**Data Analysis**

* SQL
* PostgreSQL
* Aggregation
* Filtering
* Grouping
* Business Query Development

**Data Visualization**

* Power BI
* Dashboard Design
* KPI Development
* Data Storytelling

**Business Analytics**

* Customer Segmentation
* Campaign Analysis
* Cohort Analysis
* Product Analysis
* Channel Analysis
* Customer Value Analysis

The project documentation specifically confirms the use of Python/Pandas/NumPy, SQL/PostgreSQL and Power BI for the demonstrated workflow. 

---

# Conclusion

This project demonstrates an end-to-end data analytics workflow:

**Excel → Python/Pandas/NumPy → SQL/PostgreSQL → Power BI → Insights → Recommendations**

The raw customer marketing data was cleaned and transformed into analytical features, analyzed through structured SQL business questions, and presented through a three-page Power BI dashboard.

The strongest descriptive signals include higher spending among responders, the relationship between previous campaign engagement and later response, wines leading product spending, stores leading purchase volume, and differences across customer cohorts and household composition. 

Overall, the project demonstrates how raw customer data can be transformed into a structured analytical product that supports campaign targeting, customer segmentation, product strategy, channel planning and business decision-making.
