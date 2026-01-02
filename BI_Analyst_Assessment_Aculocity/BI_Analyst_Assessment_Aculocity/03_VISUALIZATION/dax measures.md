1. Vehicles Over 10L (Total)
VehiclesOver10L (Total) =
SUM('vw_customer_summary'[VehiclesOver10L])


Purpose:
Calculates the total number of vehicles per customer with engine displacement greater than 10 liters.
This metric directly aligns with the sales team’s inventory constraint (20 trucks with engines >10L available to sell).

2. Customer Rank (Top 10 Logic)
Customer Rank =
RANKX(
    ALL(
        'vw_customer_summary'[RegistrationName],
        'vw_customer_summary'[RegistrationAddress],
        'vw_customer_summary'[RegCity],
        'vw_customer_summary'[RegSt]
    ),
    [VehiclesOver10L (Total)],
    ,
    DESC,
    DENSE
)

Purpose:
Ranks customers based on the number of vehicles with engines greater than 10L.

Why this approach was used:
Power BI’s built-in Top N filter includes ties by default. A rank-based approach ensures exactly 10 customers are returned, removing ambiguity and providing a deterministic call list.

Used in KPI visuals to show the total number of qualifying vehicles across all customers.