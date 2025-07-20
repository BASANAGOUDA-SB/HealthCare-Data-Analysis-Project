# 🏥 HealthCare Data Analysis Project

An advanced real-world **Business Intelligence (BI)** project using **SQL Server** and **Power BI**, designed to analyze over **20 million rows** of clinical data. The project focuses on **automated data profiling**, **SharePoint-style replication**, and interactive, multi-page dashboards for actionable healthcare insights.

---

## 📌 Project Summary

This project simulates an enterprise-scale data pipeline from raw structured tables to polished business dashboards.

It covers:
- 🔄 **Dynamic SQL Scripting** for column-wise profiling
- 📁 **Data replication** inspired by SharePoint logic (using hash tables)
- 📊 **Multi-page Power BI dashboards** with drill-downs
- ☁️ **Power BI Service deployment** with scheduled refresh

---

## 🛠️ Tools & Technologies Used

| Tool               | Purpose                            |
|--------------------|-------------------------------------|
| SQL Server         | Data preparation, dynamic scripting |
| Power BI Desktop   | Data modeling & dashboard creation  |
| Power BI Service   | Publishing and report automation    |
| DAX                | Measures & calculations             |
| SharePoint Logic   | Simulated using hash tables         |

---

## 🔍 Key Features

### 🧠 Dynamic SQL Profiling Engine
- Fully automated profiling script to:
  - Calculate **Median**, **Mode**, **Distinct Count**, **NULLs**, **Min/Max**
  - Loop through columns dynamically
  - Handle various data types without hardcoding

### 📁 SharePoint-style Data Replication
- Custom script to simulate SharePoint schema replication
- Uses hash tables and CTEs for flexible table structure analysis

### 📊 Power BI Reports (Multiple Pages)
- **Page 1: Hospital-Level Summary**
  - Infections, Admissions, Readmissions, Deaths
- **Page 2: Year-Wise Trend Analysis**
  - Trend comparison from 2024 to 2030
- Responsive design with slicers, tooltips, and healthcare-themed visuals

---

## 🖼️ Sample Dashboards

### 🔹 Hospital-Level KPI Summary
<img src="./ss%20for%20git.png" alt="Clinical Data Dashboard" width="100%" />

> Visualizes total inspections, admissions, readmissions, and deaths by hospital.

*More screenshots can be added in the `Screenshots` folder if needed.*

---

## 📂 Folder Structure

```bash
📁 HealthCare-Data-Analysis/
├── 📊 PBIX File                # Power BI Dashboard
├── 📜 SQL Scripts              # Dynamic profiling & replication scripts
├── 🖼️ Screenshots              # Dashboard visuals
└── README.md                   # Project documentation
