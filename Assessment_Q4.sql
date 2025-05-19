SELECT 
  users_customuser.id AS customer_id,
  CONCAT(users_customuser.first_name, ' ', users_customuser.last_name) AS name,
  TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()) AS tenure_months,
  COUNT(savings_savingsaccount.id) AS total_transactions,
  ROUND(
    (COUNT(savings_savingsaccount.id) / GREATEST(TIMESTAMPDIFF(MONTH, users_customuser.date_joined, CURDATE()), 1)) 
    * 12 
    * AVG(savings_savingsaccount.amount * 0.001),
    2
  ) AS estimated_clv
FROM users_customuser
JOIN savings_savingsaccount 
  ON users_customuser.id = savings_savingsaccount.owner_id
GROUP BY users_customuser.id, name
ORDER BY estimated_clv DESC;
