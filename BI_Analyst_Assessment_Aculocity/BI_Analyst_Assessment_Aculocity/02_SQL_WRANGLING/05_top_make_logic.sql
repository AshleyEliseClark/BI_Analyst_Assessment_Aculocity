/* ============================================================
   5. Top Make per Unique Business + Address
   ------------------------------------------------------------
   Identifies the most common vehicle make per customer
   ============================================================ */

WITH make_counts AS (
    SELECT
        RegistrationName,
        RegistrationAddress,
        RegCity,
        RegSt,
        Make,
        COUNT(*) AS MakeCount,
        ROW_NUMBER() OVER (
            PARTITION BY RegistrationName, RegistrationAddress, RegCity, RegSt
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM dbo.BI_Analyst_Assessment_Data
    GROUP BY
        RegistrationName, RegistrationAddress, RegCity, RegSt, Make
)
SELECT
    RegistrationName,
    RegistrationAddress,
    RegCity,
    RegSt,
    Make AS TopMake
FROM make_counts
WHERE rn = 1;
