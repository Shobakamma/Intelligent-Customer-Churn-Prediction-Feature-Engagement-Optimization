# 🏦 Neobank Churn Prediction & Retention Dashboard

An interactive analytics solution designed to detect customer friction, predict churn risk, and simulate product-led retention strategies for a digital neobank.

## 📌 Project Overview

This project combines **Python**, **SQL**, and **Power BI** to transform raw customer behavioral snapshot data into an actionable retention command center. It flags operational friction (authentication issues, pending KYC, support tickets), recalculates mathematical risk profiles, and provides real-time "What-If" business scenario planning.

## 🚀 Key Highlights

* Automated Data Engineering (Python):** Cleanses data, quarantines corrupted user activity logs, and builds vectorized customer friction scoring pipelines.
* Relational Analytics (SQL):** Runs complex subqueries and conditional logic to isolate silent churn indicators and friction-driven balance drops.
* Star Schema Modeling (Power BI):** Decouples transactional data into a high-performance relational model (`Fact_Customers` with Date, Plan, and Demographic dimensions).
* Dynamic Smart Narrative (DAX):** Generates automated natural-language diagnostic reports explaining current cohort statuses and friction root causes.
* "What-If" Retention Simulator:** Features an interactive slider that dynamically recalculates simulated churn reductions and retained asset values in real time.


## 🛠️ Tech Stack

* **Languages:** Python, SQL, DAX
* **Libraries:** `pandas`, `numpy`, `SQLAlchemy`
* **Database:** PostgreSQL / SQL Server
* **BI Tool:** Power BI Desktop
