USE telecom_data

-- Overall Churn Analysis
SELECT COUNT(*) AS total_customers,                                                                            -- Total number of customers = 7043
       SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS total_churned,                                        -- Total churned customers = 1869
       CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS overall_churn_rate,   -- Overall churn rate = 26.54%
       SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) AS total_non_churned                                      -- Total non-churned customers = 5174
FROM telco_customer_churn_data;


-- Average Monthly and Total Charges
SELECT AVG(monthly_charges) AS avg_monthly_charges_streaming,                                                 -- Average monthly charges = 64.76
       AVG(total_charges) AS avg_total_charges_streaming                                                     -- Average total charges  = 2283.30
FROM telco_customer_churn_data;

-- Streaming Service Subscribers
SELECT COUNT(*) AS streaming_subscribers
FROM telco_customer_churn_data
WHERE (streaming_movies = 'Yes' OR streaming_tv = 'Yes') AND internet_service != 'No';              -- no of streaming service subscribers = 3499


-- Churn Rate for customers by Streaming Service
--calculating churn rate for customers with and without streaming_tv
SELECT streaming_tv, 
       COUNT(*) AS total_customers,                                                               -- No internet service = 7.40
       COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,                            -- Yes = 30.07
       CAST(COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate    -- No = 33.52
FROM telco_customer_churn_data
GROUP BY streaming_tv;

--calculating churn rate for customers with and without streaming_movies
SELECT streaming_movies, 
	COUNT(*) AS total_customers,                                                                        --No internet service = 7.40
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,                                -- Yes = 29.94
	CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate        -- No = 33.68
FROM telco_customer_churn_data
GROUP BY streaming_movies;

--calculating churn rate for both streaming_movies and streaming_tv
SELECT (CASE WHEN streaming_tv = 'Yes'AND streaming_movies= 'Yes' THEN 'Yes' else 'No' END) AS has_both_services,COUNT(*) AS total_customers, 
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate
FROM telco_customer_churn_data
GROUP BY (CASE WHEN streaming_tv = 'Yes' AND streaming_movies= 'Yes' THEN 'Yes' else 'No' END); 

--calculating churn rate for customer with streaming services (streaming_movies or streaming_tv
SELECT (CASE WHEN streaming_tv = 'Yes' OR streaming_movies= 'Yes' THEN 'Yes' else 'No' END) AS has_one_services,COUNT(*) AS total_customers, 
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate
FROM telco_customer_churn_data
GROUP BY (CASE WHEN streaming_tv = 'Yes' OR streaming_movies= 'Yes' THEN 'Yes' else 'No' END); 

--calculating churn rate of customer by contract type
SELECT contract,                                                                                               --month to month = 3875
	COUNT(*) AS customer_count,
	COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
       CAST(COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate                 --one year = 1473
FROM telco_customer_churn_data                                                                                 --Two year = 1695
GROUP BY contract;

--calculating churn rate for customers with and without streaming_tv by contract
SELECT contract, streaming_tv, 
       COUNT(*) AS total_customers,
       COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
       CAST(COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate
FROM telco_customer_churn_data
GROUP BY contract, streaming_tv
ORDER BY contract;

--calculating churn rate for customers with and without streaming_movies by contract
SELECT contract, streaming_movies,
       COUNT(*) AS total_customers,
       COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS churned_customers,
       CAST(COUNT(CASE WHEN churn = 'Yes' THEN 1 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate
FROM telco_customer_churn_data
GROUP BY contract, streaming_movies 
ORDER BY contract;


-- Churn Rate by Internet Service Type (DSL, Fiber optic, No)
SELECT internet_service,
       COUNT(*) AS total_customers,                                                                           --Fiber Optic = 41.89
       COUNT(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,                                 --DSL = 18.96
       CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate           --No = 7.40
FROM telco_customer_churn_data
GROUP BY internet_service;

--calculating average tenure of churned vs non churned
SELECT churn, AVG(CAST(tenure AS FLOAT)) AS avg_tenure                                 --Yes =17.98
FROM telco_customer_churn_data                                                          -- No = 37.57
GROUP BY churn;