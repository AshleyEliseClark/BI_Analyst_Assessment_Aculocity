SELECT COUNT(*) AS row_count
FROM dbo.BI_Analyst_Assessment_Data;

SELECT TOP 10 *
FROM dbo.BI_Analyst_Assessment_Data;

SELECT
  RegistrationName,
  RegistrationAddress,
  RegCity,
  RegSt,
  COUNT(DISTINCT VIN) AS FleetSize
FROM dbo.BI_Analyst_Assessment_Data
GROUP BY
  RegistrationName,
  RegistrationAddress,
  RegCity,
  RegSt
ORDER BY FleetSize DESC;

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
        CASE
            WHEN MAX(NAICSCode) LIKE '23%' THEN 1
            WHEN MAX(RegVoc) LIKE '%construct%' THEN 1
            WHEN MAX(RegVoc) LIKE '%concrete%' THEN 1
            WHEN MAX(RegVoc) LIKE '%excavat%' THEN 1
            WHEN MAX(RegVoc) LIKE '%paving%' THEN 1
            WHEN MAX(RegVoc) LIKE '%grading%' THEN 1
            ELSE 0
        END AS IsConstruction
    FROM base
    GROUP BY
        RegistrationName, RegistrationAddress, RegCity, RegSt
),
make_counts AS (
    SELECT
        RegistrationName,
        RegistrationAddress,
        RegCity,
        RegSt,
        Make,
        COUNT(*) AS MakeCount,
        ROW_NUMBER() OVER (
            PARTITION BY RegistrationName, RegistrationAddress, RegCity, RegSt
            ORDER BY COUNT(*) DESC, Make
        ) AS rn
    FROM base
    GROUP BY
        RegistrationName, RegistrationAddress, RegCity, RegSt, Make
)
SELECT
    c.*,
    mc.Make AS TopMake
FROM cust c
LEFT JOIN make_counts mc
    ON  c.RegistrationName = mc.RegistrationName
    AND c.RegistrationAddress = mc.RegistrationAddress
    AND c.RegCity = mc.RegCity
    AND c.RegSt = mc.RegSt
    AND mc.rn = 1
ORDER BY c.FleetSize DESC;

SELECT COUNT(*) AS customer_rows
FROM (
    SELECT
        RegistrationName, RegistrationAddress, RegCity, RegSt
    FROM dbo.BI_Analyst_Assessment_Data
    GROUP BY RegistrationName, RegistrationAddress, RegCity, RegSt
) x;

