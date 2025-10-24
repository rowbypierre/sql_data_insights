# Crime Data Analysis (2020–Present)

## Overview
This project analyzes **Los Angeles Police Department crime data from 2020 to the present**, obtained from the [Data.gov Crime Dataset](https://catalog.data.gov/dataset/crime-data-from-2020-to-present#sec-dates). The purpose is to explore, clean, and query large-scale public crime records using multiple data processing tools.

---

## Data Source
- **Dataset:** Los Angeles Police Department Crime Data from 2020 to Present  
- **Provider:** Data.gov  
- **Format:** CSV  
- **Scope:** Includes crime type, date, location, and report details.

---

## Project Workflow

### 1. Data Cleaning (Pandas)
- Environment: **Jupyter Lab**
- Tool: **Python (Pandas)**
- Steps:
  - Removed missing or invalid entries  
  - Standardized column names and data types  
  - Filtered date range and irrelevant fields  
  - Exported cleaned dataset for SQL and PySpark use  

Output: `data-clean-pandas.csv`

---

### 2. SQL Analysis (SQL Server)
- Imported cleaned dataset into **SQL Server**
- Wrote and executed multiple **SQL queries** for:
  - Crime counts by year, month, and category  
  - Location-based trends  
  - Aggregations and comparisons  

Extracts: `./extracts/sql/*`

---

### 3. PySpark Analysis
- Environment: **PySpark**
- Loaded same cleaned dataset into Spark DataFrame
- Reproduced the same queries used in SQL using PySpark syntax  
- Compared performance and results  

Extracts: `./extracts/pyspark/*`

---

## Files
| File | Description |
|------|--------------|
| `./data/data-clean-pandas.csv` | Cleaned dataset after preprocessing |
| `./extracts/sql/*` | Output from SQL Server queries |
| `./extracts/pyspark/*` | Output from equivalent PySpark queries |
| `./notebooks/data-cleaning-pandas.ipynb` | Jupyter notebook with Pandas cleaning code |
| `./notebooks/data-query-pyspark.ipynb` | Jupyter notebook with Pyspark querying code |
| `./sql/create-load-tables.sql` | SQL script with table creation and loading code |
| `./sql/queries.sql` | SQL script with querying code |
| `README.md` | Project overview and documentation |

---

## Tools & Technologies
- **Python (Pandas, PySpark)**
- **SQL Server**
- **Jupyter Lab**
- **Data.gov Open Data API**

---

## Purpose
This project demonstrates:
- Data cleaning with Pandas  
- SQL query design and execution  
- PySpark for distributed data processing  
- Consistency checks between SQL and PySpark outputs  
