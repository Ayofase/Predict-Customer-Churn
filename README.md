# Reducing Churn: A Comparative Analysis of Streaming and Non-Streaming Subscribers

## Project Overview

This project analyzes customer churn in a telecommunication company using the Telco Customer Churn dataset from Kaggle. The goal is to identify key churn drivers and develop data-driven recommendations for improving customer retention, with a particular emphasis on streaming service subscribers. The analysis involves data cleaning, exploratory data analysis (EDA), and visualization using R and an interactive dashboard using Tableau. A key finding is that Fiber optic customers experience significantly higher churn rates despite it being ideal for streaming, warranting further investigation. 

## Table Of Content
  - [Project Goals](#project-goals)
  - [Data source](#data-source)
  - [Tools](#tools)
  - [Data Cleaning](#data-cleaning)
  - [Exploratory Data Analysis](#exploratory_data_analysis)
  - [Data Analysis and Visualisation](#data_analysis_and_visualisation)
  - [Results](#results)
  - [Recommendation](#recommendation)
  - [Limitations](#limitations)

### Project Goal
Analyze customer behavior and service usage to understand churn drivers and develop data-driven recommendations for improving customer retention, with a focus on streaming service subscribers.

### Data source
This dataset used for the analysis is gotten from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?resource=download), The dataset contains information on customer demographics, services subscribed (including streaming TV and movies), account information (tenure, contract type, payment method, etc.), and churn status.  The raw data contains 7043 rows and 21 columns.

### Tools

* **Excel:** Data cleaning and preparation.
* **SQL Server:** Data validation and exploratory data analysis.
* **R:**  In-depth exploratory data analysis, and visualization.
* **Tableau:** Interactive dashboard creation.

## Data Cleaning and Preparion
Initial data cleaning was performed in Excel:
1. **Data Type Standardization:** Column names were converted from CamelCase to snake_case for consistency with SQL and R.  The `total_charges`, `monthly_charges`, and `tenure` columns were converted to numeric data types.
2. **Missing Value Handling:**  No missing values were found in the dataset after the initial cleaning.
3. **Duplicate Removal:** No duplicate `customer_id` values were found since its the primary key.

The cleaned data was then imported into SQL Server, where additional data quality checks and validation were performed:
* **Data Quality Checks in SQL:**

1 **Row and Column Count:** Verified row and column counts against the cleaned Excel data.

2 **Data Types:** Checked data types for consistency.

4 **Primary Key (customer_id) Null Check:** Confirmed no NULLs in `customer_id`.

5 **Duplicate Check:**  Confirmed no duplicate `customer_id` values.

* **Churn Column Validation:**  Checked distinct values present in the `churn` column.

## Exploratory Data Analysis (EDA)
The following SQL queries were performed to gain initial insights into customer churn, with a particular focus on streaming service subscribers. This exploration helps identify potential churn drivers and inform further analysis in R

**Overall Churn Analysis:**

* What is the overall churn rate for the telecom company?
* How many customers are there in total, how many have churned, and how many have not churned?
   
* What is the distribution of customers across different contract types?
* How much do streaming service subscribers pay on average each month?
* How much do streaming service subscribers pay on average in total?

 ```sql
   SELECT AVG(monthly_charges) AS avg_monthly_charges_streaming,                            
       AVG(total_charges) AS avg_total_charges_streaming                                 
   FROM telco_customer_churn_data
   WHERE streaming_movies = 'Yes' OR streaming_tv = 'Yes';
 ```
* What is the average tenure of a customer?

**Streaming Service Subscriber Analysis:**

* How many customers subscribe to at least one streaming service?
* What are the churn rates for customers with Streaming TV, Streaming Movies, both streaming services and those without streaming services?  Do these churn rates differ significantly from the overall churn rate?
* How does contract type influence churn rate among streaming subscribers? Are there particular combinations of contract type and streaming service usage associated with higher churn?
* Is there a relationship between internet service type and churn rate, especially among streaming subscribers?

 ```sql
   SELECT internet_service,
       COUNT(*) AS total_customers,                                                                           
       COUNT(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,                                 
       CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate           
   FROM telco_customer_churn_data
   GROUP BY internet_service;
```
* How does tenure vary between churned and non-churned streaming subscribers?

## Results and Key Findings

* **Overall Churn Rate:** 26.54% of total customers churned. This serves as a baseline for comparison with specific customer segments.
   
* **Key Customer Metrics:**
    * **Total Customers:** 7043
    * **Churned Customers:** 1869
    * **Non-Churned Customers:** 5174
    * **Streaming Service Subscribers:** 3499
    * **Average Monthly Charges for Streaming Subscribers:** $86.03 
    * **Average Total Charges for Streaming Subscribers:** $3486.83
      
     ```sql
    SELECT COUNT(*) AS total_customers,                                                                            
       SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS total_churned,                                        
       CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS overall_churn_rate,  
       SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) AS total_non_churned                                      
    FROM telco_customer_churn_data;

     ```


**Contract Type Distribution:** Majority of the customers(3875) are on month-to-month contract, indicating customers preference for short time contract. A small porti
**Churn Rate Analysis:**

* **Churn Rate by Streaming Service:** Customers subscribing to streaming TV had a churn rate of 30.07%, while those subscribing to streaming movies had a churn rate of 29.94%. These are very close to the overall churn rate (26.54%), suggesting that subscribing to streaming services *alone* might not be a significant driver of churn. 

* **Churn Rate by Contract Type for Streaming Subscribers:** Combining contract type and streaming service usage reveals that month-to-month contracts have higher churn rates, but the addition of streaming services does not increase the churn rate as it remains similar. This suggests that the primary driver here is the length of contract agreement and not the presence of streaming services. *Provide insights gotten after running your query.

* **Churn Rate by Internet Service Type:**  Fiber optic customers experienced the highest churn rate (41.89%), which is significantly higher than DSL (18.96%) and No internet service (7.40%). Since streaming relies heavily on internet quality, this finding could suggest that fiber optic customers, despite having the fastest internet, might have other issues (e.g., higher prices, technical problems) causing them to churn.

* **Churn Rate for Customers with Both Streaming Movies and TV:** The churn rate for customers subscribing to *both* streaming services was 29.43%, slightly *lower* than the individual streaming service churn rates and very close to the overall churn rate. This is somewhat counterintuitive and could suggest that customers who are more invested in streaming services, by using both movie and TV streaming, which implies they are more satisfied with the services and are therefore less likely to churn.


* **Average Tenure for Churned vs. Non-Churned Streaming Subscribers:** Churned streaming subscribers had an average tenure of 23 months, while non-churned streaming subscribers had a much longer average tenure of 45 months.  This reinforces the idea that longer tenure is associated with lower churn, even within the streaming subscriber segment.
   
## Data Analysis in R

This section presents key visualizations and deeper explorations performed in R, building upon the initial insights gained from the SQL EDA.  The full, well-commented R script is available on GitHub: [Link to your R script].

**(Start with your key visualizations here, each followed by a concise interpretation.  Prioritize visualizations that compare streaming subscribers to other customer segments.)*

*For example:*

* **Churn Rate by Tenure:** [churn_rate_by_tenure.png] Churn rate generally decreases with longer tenure, highlighting the importance of customer retention strategies. *You can show tenure distribution using a histogram for both churned and non-churned customers in a combined plot. This adds aesthetic to your analysis and recruiters love seeing these too.* *Use the grid.arrange function from the gridExtra package.* *Document this and add your interpretations.* This answers one of the EDA questions and gives further insight into churn behaviour.

* **Churn Rate and Average Charges by Streaming Service Subscription:** [Link to a visualization comparing churn rates and average charges for streamers vs. non-streamers].  Streaming subscribers have a slightly higher churn rate (30.01%) compared to the overall churn rate (26.54%), and also have higher average monthly (\$73.02 vs \$[Value]) and total charges (\$2501.73 vs \$[Value]). *Show the r-code and the result in your README.* *This comparison provides further insight to answer another EDA question - How much do streaming service subscribers pay on average each month and total?* This is highly relevant. Targetting these customers with higher charges with exceptional services would be necessary to retain these valuable customer segment. *Interpreting the findings and connecting them with business decision is a very valuable skill to showcase to recruiters.*

* **Churn Rate by Internet Service Type (Streaming Subscribers):** [Link to visualization]. *Interpret this visualisation. State the values calculated and compare them.*  As discussed in the SQL analysis, Fiber optic customers have a significantly higher churn rate, which warrants further investigation.

* **Churn Rate by Contract Type (Streaming Subscribers):** [Link to visualization]. *Focus on what contract type has higher churn and suggest how the company can increase customer retention based on this insight.*


* **Average Tenure for Churned vs. Non-Churned Streaming Subscribers:** [Link to visualization]. *Interpret the result and provide insight based on the result. State the average tenure values for both groups.* This is crucial for the business to evaluate customer behaviour and predict potential churn, informing retention strategies.


*(Optional Statistical Tests): If you perform any statistical tests, briefly mention them and their results here, further validating your findings.*
Use code with caution.    
