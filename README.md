# 📊 Marketing Analytics + AI Insight Pipeline

## 🚀 Project Overview

This project simulates a real-world data pipeline used in performance marketing agencies. It transforms raw campaign and sales data into actionable insights using Python, SQL, Power BI, and an AI-powered query tool.

The pipeline ensures a **single source of truth (PostgreSQL)** that feeds both dashboards and AI insights.

---

## 🏗️ Architecture

Raw CSV → Python (Data Cleaning) → PostgreSQL (Data Warehouse) → Power BI Dashboard + AI Insight Tool

---

## 🎯 Objectives

* Clean and validate raw marketing and sales data
* Build a structured SQL data model (star schema)
* Create interactive dashboards for performance tracking
* Develop an AI tool to answer business questions using SQL + LLM

---

## 🧹 Task 1 — Data Cleaning (Python)

* Removed duplicate records
* Standardized date formats
* Handled missing values using business logic
* Recalculated key metrics:

  * CTR = Clicks / Impressions
  * CPC = Spend / Clicks
  * ROI = (Revenue - Spend) / Spend
* Normalized categorical columns (platform, region, channel)

📂 Output:

* Cleaned datasets
* Data quality report

---

## 🗄️ Task 2 — SQL Database (PostgreSQL)

* Designed schema with proper data types

* Implemented **star schema**:

  * Fact Table: Shopify (Sales)
  * Dimension Table: Campaigns
  * Date Dimension Table

* Created indexes for performance optimization:

  * date, platform, region

---

## 📊 Task 3 — Power BI Dashboard

Connected directly to PostgreSQL (no CSV usage)

### Dashboard Pages:

1. **Executive Summary**

   * KPIs: Total Spend, Revenue, ROI
   * Trend analysis (Spend vs Conversions)
   * Top campaigns

2. **Channel Performance**

   * Platform comparison
   * Channel mix
   * Region-wise performance

3. **Audience Insights**

   * Conversion analysis
   * Spend vs performance scatter

### DAX Measures:

* Total Spend
* Total Revenue
* ROI
* CTR
* CPC
* ROAS

---

## 🤖 Task 4 — AI Insight Tool

Built a Python-based tool that:

* Accepts natural language questions
* Converts them into SQL queries
* Fetches data from PostgreSQL
* Sends results to LLM (OpenAI API)
* Returns business insights in plain English

### Example Questions:

* "Which campaign had the highest ROI?"
* "Worst performing campaign in March?"
* "Summarize UK region performance"

---

## ⚙️ Tech Stack

* Python (Pandas, SQLAlchemy)
* PostgreSQL
* Power BI
* OpenAI API
* Streamlit (optional UI)

---

## 📂 Project Structure

```
/data
/python
/sql
/powerbi
/ai_tool
README.md
requirements.txt
```

---

## 📈 Key Insights

* Data quality directly impacts campaign performance metrics
* ROI and CPC vary significantly across platforms
* Region-based performance helps optimize budget allocation

---

## 🧠 Learnings

* Built an end-to-end analytics pipeline
* Improved SQL schema design and query optimization
* Gained hands-on experience in Power BI and DAX
* Implemented LLM-based analytics workflow

---

## 🎥 Video Explanation

(Attach your Loom/Drive link here)

---

## 📌 How to Run

### 1. Setup Database

```bash
Create PostgreSQL DB and run schema.sql
```

### 2. Run Python Cleaning Script

```bash
python cleaning.py
```

### 3. Launch AI Tool

```bash
python app.py
```

---

## 💡 Future Improvements

* Automated data pipeline (ETL)
* Real-time dashboard updates
* Advanced anomaly detection
* Budget optimization model

---

## 👨‍💻 Author

Anurag Sharma
Aspiring Data Analyst | SQL | Power BI | Python
