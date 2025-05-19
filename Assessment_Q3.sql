SELECT 
    plans_plan.id AS plan_id,
    plans_plan.owner_id,
    CASE 
        WHEN is_a_fund = 0 THEN 'Savings'
        WHEN is_regular_savings = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    DATE(MAX(transaction_date)) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
FROM plans_plan
 JOIN savings_savingsaccount
    ON plans_plan.id = savings_savingsaccount.id 

WHERE   is_regular_savings  = 1 
  AND (savings_savingsaccount.id IS NOT NULL OR plans_plan.id IS NOT NULL)
GROUP BY plans_plan.id, plans_plan.owner_id, type
HAVING MAX(transaction_date) IS NULL 
   OR DATEDIFF(CURDATE(), MAX(transaction_date)) > 365;
