/* ============================================================
   4. Is Construction Flag
   ------------------------------------------------------------
   Combines NAICS code and Registration Vocation
   ============================================================ */
 SELECT
    *,
    CASE
        WHEN NAICSCode LIKE '23%' THEN 1
        WHEN RegVoc LIKE '%construct%' THEN 1
        WHEN RegVoc LIKE '%concrete%' THEN 1
        WHEN RegVoc LIKE '%excavat%' THEN 1
        WHEN RegVoc LIKE '%paving%' THEN 1
        WHEN RegVoc LIKE '%grading%' THEN 1
        WHEN RegVoc LIKE '%contract%' THEN 1
        ELSE 0
    END AS IsConstruction
FROM customer_summary;
