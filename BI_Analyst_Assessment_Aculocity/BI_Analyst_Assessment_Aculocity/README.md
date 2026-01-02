# Aculocity BI Analyst Technical Assessment

## Overview

This project was completed as part of the Aculocity BI Analyst technical assessment. The objective was to analyze a dataset of businesses operating heavy-duty Class 8 trucks in Alabama and identify high-priority sales opportunities for Autocar Manufacturing as it expands into the construction market.

The focus of this project is not only technical execution, but also business reasoning, clarity of assumptions, and actionable insights.

## Business Question

Which construction-related businesses in Alabama should the sales team prioritize if they have 20 trucks with engines greater than 10 liters available to sell?

## Data Wrangling (SQL Server)

### Data Ingestion

Source data was imported into SQL Server using SSMS (Import Flat File).

Schema adjustments were made during ingestion to preserve data integrity:

- VIN and NAICS codes stored as text
- Wheels stored as descriptive text (e.g., “6 x 4”)
- Engine liters allowed NULL values

### Customer Grain

All analysis is performed at the customer-location level, defined as:

- Registration Name
- Registration Address
- City
- State

This ensures each row represents a single business location.

### SQL Transformations

A production-ready SQL view (`vw_customer_summary`) was created to consolidate all required logic into a single, clean output.

The view includes:

- Fleet Size (distinct VIN count)
- Fleet Size Group (1–20, 20+)
- Average Fleet Age
- Vehicles Older Than 10 Years
- Vehicles with Engines >10L
- Engine Liter Group
- Construction flag (NAICS + vocation logic)
- Top vehicle make per customer

All SQL scripts are organized in the `sql/` directory and map directly to the assessment instructions.

## Visualization (Power BI)

Power BI was used to build an interactive dashboard focused on sales decision-making, not exploratory analysis.

### Key Elements

- Customer-level summary table
- Top 10 prioritized customer call list
- KPI cards highlighting large-engine availability
- Bar charts showing fleet size and top makes
- Slicers for customer segmentation (kept minimal and intentional)

Non-informative filters (e.g., state, where all data = Alabama) were intentionally excluded.

## Top 10 Customer Call List

Customers were prioritized using the following rule:

1. At least 20 vehicles with engines greater than 10L
2. Ranked by number of qualifying vehicles

Tie-handling resolved using a DAX rank measure to return exactly 10 customers.

This list represents the highest immediate sales opportunity given current inventory constraints.

## Key Insight for Sales

Customers with larger fleets and a high concentration of >10L engines represent the most efficient use of sales outreach. By focusing on these accounts first, the sales team maximizes the likelihood of near-term conversions while aligning inventory with operational needs.
