/* ============================================================
   3. Customer Segmentation Enhancements
   ------------------------------------------------------------
   Adds:
   - Fleet Size Group
   - Average Fleet Age
   - Vehicles > 10 Years
   - Engine Liter Group
   Ensures one row per customer
   ============================================================ */


;WITH base AS (
    SELECT
        RegistrationName,
        RegistrationAddress,
        RegCity,
        RegSt,
        VIN,
        Make,
        RegVoc,
        YM,
        Wheels,
        Liters,
        Fuel,
        NAICSCode,
        NAICSDescription
    FROM dbo.BI_Analyst_Assessment_Data
),
cust AS (
    SELECT
        RegistrationName,
        RegistrationAddress,
        RegCity,
        RegSt,
        COUNT(DISTINCT VIN) AS FleetSize,
        AVG(CASE WHEN YM IS NOT NULL THEN (YEAR(GETDATE()) - YM) * 1.0 END) AS AvgFleetAge,
        SUM(CASE WHEN YM IS NOT NULL AND (YEAR(GETDATE()) - YM) > 10 THEN 1 ELSE 0 END) AS VehiclesOver10Years,
        SUM(CASE WHEN Liters IS NOT NULL AND Liters > 10 THEN 1 ELSE 0 END) AS VehiclesOver10L,
        CASE
            WHEN COUNT(DISTINCT VIN) BETWEEN 1 AND 20 THEN '1-20'
            WHEN COUNT(DISTINCT VIN) >= 21 THEN '20+'
            ELSE '0'
        END AS FleetSizeGroup,
        CASE
            WHEN SUM(CASE WHEN Liters IS NOT NULL AND Liters > 10 THEN 1 ELSE 0 END) > 0 THEN '>10L present'
            WHEN SUM(CASE WHEN Liters IS NOT NULL AND Liters BETWEEN 5 AND 10 THEN 1 ELSE 0 END) > 0 THEN '5-10L present'
            WHEN SUM(CASE WHEN Liters IS NOT NULL AND Liters < 5 THEN 1 ELSE 0 END) > 0 THEN '<5L present'
            ELSE 'Unknown'
        END AS EngineLiterGroup,
        MAX(NAICSCode) AS NAICSCode,
        MAX(NAICSDescription) AS NAICSDescription,
        MAX(RegVoc) AS RegVoc,
         FROM base
    GROUP BY
        RegistrationName,
        RegistrationAddress,
        RegCity,
        RegSt
)
SELECT *
FROM customer_summary;