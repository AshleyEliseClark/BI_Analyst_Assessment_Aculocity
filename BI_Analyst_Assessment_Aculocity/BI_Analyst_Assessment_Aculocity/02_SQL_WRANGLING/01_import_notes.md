/* ============================================================
   1. DATA WRANGLING
   1.1 Import the dataset into SQL Server
   ------------------------------------------------------------
   NOTE:
   - Data imported using SSMS Import Flat File wizard
   - Source file: BI_Analyst_Assessment.csv
   - Schema adjustments made during import:
       * Wheels stored as NVARCHAR (values like '6 X 4')
       * NAICSCode stored as NVARCHAR (code, not date)
       * Liters allows NULL values
   ============================================================ */
