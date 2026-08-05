CREATE DATABASE IF NOT EXISTS Customer_Churn_Prediction_db;

USE Customer_Churn_Prediction_db;

Select * from neobank_customer_churn
limit 10;

#Query 1: The "Silent Churn" Detector

Select Plan_Type, KYC_Status, COUNT(*) AS Total_Customers,
sum(Monthly_Deposits) as total_monthly_deposits, 
sum(Account_Balance) as Total_Account_Balance,
ROUND(AVG(Account_Balance), 2) AS Avg_Account_Balance,
sum(Case when Failed_Logins>0 or Support_Tickets>0 then 1 else 0 end) as Friction_Event_Count,
ROUND(SUM(Monthly_Deposits) * 100.0 / NULLIF(SUM(Account_Balance), 0), 2) AS Deposit_Coverage_Pct,
    ROUND(SUM(CASE WHEN Failed_Logins > 0 OR Support_Tickets > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Friction_Pct
FROM neobank_customer_churn
GROUP BY Plan_Type, KYC_Status
HAVING SUM(Monthly_Deposits) < (0.30 * SUM(Account_Balance))
   AND (SUM(CASE WHEN Failed_Logins > 0 OR Support_Tickets > 0 THEN 1 ELSE 0 END) * 1.0 / COUNT(*)) > 0.30;

     
#Query 2: The "Friction Spike" Vulnerability Finder
SELECT 
    c1.Customer_ID,
    c1.Signup_Date,
    c1.Plan_Type,
    c1.Support_Tickets,
    c1.Account_Balance,
    c1.Monthly_Deposits,
    (
        SELECT ROUND(AVG(c2.Support_Tickets), 2)
        FROM neobank_customer_churn c2
        WHERE c2.Plan_Type = c1.Plan_Type
    ) AS Plan_Avg_Support_Tickets,
    (
        SELECT ROUND(AVG(c3.Account_Balance), 2)
        FROM neobank_customer_churn c3
        WHERE c3.Plan_Type = c1.Plan_Type
    ) AS Plan_Avg_Account_Balance
FROM neobank_customer_churn c1
WHERE c1.Support_Tickets > (
        SELECT AVG(c2.Support_Tickets)
        FROM neobank_customer_churn c2
        WHERE c2.Plan_Type = c1.Plan_Type
    )
  AND c1.Account_Balance < (
        SELECT 0.50 * AVG(c3.Account_Balance)
        FROM neobank_customer_churn c3
        WHERE c3.Plan_Type = c1.Plan_Type
    )
ORDER BY c1.Support_Tickets DESC, c1.Account_Balance ASC; 
   
  #Query 2: The "Friction Spike" Vulnerability Finder
   
   SELECT 
    c1.Customer_ID,
    c1.Signup_Date,
    c1.Plan_Type,
    c1.Support_Tickets,
    c1.Account_Balance,
    c1.Monthly_Deposits,
    ROUND(plan_stats.Plan_Avg_Support_Tickets, 2) AS Plan_Avg_Support_Tickets,
    ROUND(plan_stats.Plan_Avg_Account_Balance, 2) AS Plan_Avg_Account_Balance
FROM neobank_customer_churn c1
JOIN (
    SELECT 
        Plan_Type,
        AVG(Support_Tickets) AS Plan_Avg_Support_Tickets,
        AVG(Account_Balance) AS Plan_Avg_Account_Balance
    FROM neobank_customer_churn
    GROUP BY Plan_Type
) plan_stats ON c1.Plan_Type = plan_stats.Plan_Type
WHERE c1.Support_Tickets > plan_stats.Plan_Avg_Support_Tickets
  AND c1.Account_Balance < (0.50 * plan_stats.Plan_Avg_Account_Balance)
ORDER BY c1.Support_Tickets DESC, c1.Account_Balance ASC;
   
   
   
   #Query 3: Plan Feature Engagement Stress Test

SELECT 
    Plan_Type, 
    ROUND(AVG(CASE WHEN KYC_Status = 'Completed' THEN Core_Feature_Score END), 2) AS Avg_Score_Completed,
    ROUND(AVG(CASE WHEN KYC_Status = 'Pending' THEN Core_Feature_Score END), 2) AS Avg_Score_Pending,
    ROUND(
        AVG(CASE WHEN KYC_Status = 'Completed' THEN Core_Feature_Score END) -
        AVG(CASE WHEN KYC_Status = 'Pending' THEN Core_Feature_Score END), 2
    ) AS Score_Drop
FROM neobank_customer_churn
GROUP BY Plan_Type
ORDER BY Score_Drop DESC;
    
    #Query 4: The "False Churn Alarm" Audit
    SELECT 
    Plan_Type,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN AI_Risk_Band = 'High' THEN 1 ELSE 0 END) AS Total_High_Risk_Flagged,
    SUM(CASE WHEN AI_Risk_Band = 'High' AND Core_Feature_Score >= 80 THEN 1 ELSE 0 END) AS False_Positive_Count,
    CAST(
        ROUND(
            SUM(CASE WHEN AI_Risk_Band = 'High' AND Core_Feature_Score >= 80 THEN 1.0 ELSE 0 END) * 100.0 / 
            NULLIF(SUM(CASE WHEN AI_Risk_Band = 'High' THEN 1 ELSE 0 END), 0),
            2
        ) AS DECIMAL(10,2)
    ) AS False_Positive_Pct
FROM neobank_customer_churn
GROUP BY Plan_Type
ORDER BY Plan_Type;
    
SELECT * from neobank_customer_churn;