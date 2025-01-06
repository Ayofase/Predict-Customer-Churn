CREATE DATABASE telecom_data
USE telecom_data

SELECT *
FROM telco_customer_churn_data
--Data quality test for the two dataset
--cheking the row count
SELECT 
  COUNT (*)                                                                     --number of rows = 7043
FROM 
  telco_customer_churn_data

-- checking column count
SELECT 
 COUNT(*) AS column_count
FROM
 INFORMATION_SCHEMA.COLUMNS                                                      -- number of column = 21
WHERE 
 table_name = 'telco_customer_churn_data';

--checking data type of each column
SELECT 
 COLUMN_NAME,
 DATA_TYPE
FROM
 INFORMATION_SCHEMA.COLUMNS                     
WHERE 
 table_name = 'telco_customer_churn_data';

 --checking for null in the primary key
SELECT COUNT(*)                               
FROM 
  telco_customer_churn_data                          -- no null values
WHERE 
 customer_id IS NULL 
  
--checking for duplicates

SELECT customer_id,
  COUNT (customer_id)  AS duplicates                                 
FROM                                                                               -- no duplicate
  telco_customer_churn_data 
GROUP BY customer_id 
HAVING 
 COUNT (customer_id)> 1;

--checking for invalid values in churn column
SELECT DISTINCT churn
FROM telco_customer_churn_data;


