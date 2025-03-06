create database churn_analysis;
use churn_analysis;

#crating table for data 
CREATE TABLE customer_churn (
    Call_Failure INT,
    Complains INT,
    Subscription_Length INT,
    Charge_Amount FLOAT,
    Seconds_of_Use FLOAT,
    Frequency_of_Use INT,
    Frequency_of_SMS INT,
    Distinct_Called_Numbers INT,
    Age_Group INT,
    Tariff_Plan INT,
    Status INT,
    Age INT,
    Customer_Value FLOAT,
    Churn INT
);

#checking import from python & viewing sample data
select * from customer_churn limit 10;

#checking data
describe customer_churn;

#checking for null values 
SELECT 
    SUM(CASE WHEN Call_Failure IS NULL THEN 1 ELSE 0 END) AS Call_Failure_Null,
    SUM(CASE WHEN Complains IS NULL THEN 1 ELSE 0 END) AS Complains_Null,
    SUM(CASE WHEN Subscription_Length IS NULL THEN 1 ELSE 0 END) AS Subscription_Length_Null,
    SUM(CASE WHEN Charge_Amount IS NULL THEN 1 ELSE 0 END) AS Charge_Amount_Null,
    SUM(CASE WHEN Seconds_of_Use IS NULL THEN 1 ELSE 0 END) AS Seconds_of_Use_Null,
    SUM(CASE WHEN Frequency_of_Use IS NULL THEN 1 ELSE 0 END) AS Frequency_of_Use_Null,
    SUM(CASE WHEN Frequency_of_SMS IS NULL THEN 1 ELSE 0 END) AS Frequency_of_SMS_Null,
    SUM(CASE WHEN Distinct_Called_Numbers IS NULL THEN 1 ELSE 0 END) AS Distinct_Called_Numbers_Null,
    SUM(CASE WHEN Age_Group IS NULL THEN 1 ELSE 0 END) AS Age_Group_Null,
    SUM(CASE WHEN Tariff_Plan IS NULL THEN 1 ELSE 0 END) AS Tariff_Plan_Null,
    SUM(CASE WHEN Status IS NULL THEN 1 ELSE 0 END) AS Status_Null,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Null,
    SUM(CASE WHEN Customer_Value IS NULL THEN 1 ELSE 0 END) AS Customer_Value_Null,
    SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Churn_Null
FROM customer_churn;

#Checking overall Churn Rate 
SELECT 
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    CONCAT(ROUND((SUM(Churn) / COUNT(*)) * 100, 2), '%') AS churn_rate
FROM customer_churn;


#Churn by age group
SELECT Age_Group, 
       COUNT(*) AS total_customers, 
       SUM(Churn) AS churned_customers, 
       (SUM(Churn) * 100.0 / COUNT(*)) AS churn_rate
FROM customer_churn
GROUP BY Age_Group
ORDER BY churn_rate DESC;

#Churn by tarrif plan 
SELECT Tariff_Plan, 
       COUNT(*) AS total_customers, 
       SUM(Churn) AS churned_customers, 
       (SUM(Churn) * 100.0 / COUNT(*)) AS churn_rate
FROM customer_churn
GROUP BY Tariff_Plan
ORDER BY churn_rate DESC;

#Churn Vs Customer Value 

SELECT 
    CASE 
        WHEN Customer_Value < 100 THEN 'Low'
        WHEN Customer_Value BETWEEN 100 AND 500 THEN 'Medium'
        ELSE 'High'
    END AS value_segment,
    COUNT(*) AS total_customers,
    SUM(Churn) AS churned_customers,
    (SUM(Churn) * 100.0 / COUNT(*)) AS churn_rate
FROM customer_churn
GROUP BY value_segment
ORDER BY churn_rate DESC;

#Churn By Call failures 
SELECT Call_Failure, COUNT(*) AS Total_Customers, 
       SUM(Churn) AS Churned_Customers, 
       ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Call_Failure
ORDER BY Call_Failure;

#Churn By Complaints
SELECT Complains, COUNT(*) AS Total_Customers, 
       SUM(Churn) AS Churned_Customers, 
       ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Complains
ORDER BY Complains;

#Churn By frequency of use 
SELECT Frequency_of_Use, COUNT(*) AS Total_Customers, 
       SUM(Churn) AS Churned_Customers, 
       ROUND((SUM(Churn) / COUNT(*)) * 100, 2) AS Churn_Rate
FROM customer_churn
GROUP BY Frequency_of_Use
ORDER BY Frequency_of_Use;
