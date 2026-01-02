/* ============================================================
   2. Fleet Size by Unique Business + Address
   ------------------------------------------------------------
   Calculates total VINs (Fleet Size) per customer location
   ============================================================ */

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
