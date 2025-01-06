# Reducing Churn: A Comparative Analysis of Streaming and Non-Streaming Subscribers

## Project Overview
This project analyzes customer churn in a telecommunication company using the Telco Customer Churn dataset from Kaggle. The goal is to identify key churn drivers and develop data-driven recommendations for improving customer retention, with a particular emphasis on streaming service subscribers. The analysis involves data cleaning, exploratory data analysis (EDA), and visualization using R and an interactive dashboard using Tableau. A key finding is that Fiber optic customers experience significantly higher churn rates despite it being ideal for streaming, suggesting potential issues with service reliability or pricing strategies within this segment. Further investigation will focus on identifying the root causes of this discrepancy.


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

### Project Goals

The primary goal of this project is to analyze customer behavior and service usage patterns to understand the key drivers of churn.  The analysis will focus on identifying specific areas for improvement in customer retention, particularly among subscribers to streaming services. This will involve developing data-driven recommendations such as targeted promotions, optimized pricing strategies, or improvements to service quality.

### Data source
This dataset used for the analysis is gotten from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?resource=download), This dataset contains information on approximately 7,043 customers and includes demographics, subscribed services (including streaming TV and movies), account information (tenure, contract type, payment method, etc.), and churn status.  **Crucially, the dataset also includes information on the type of internet service each customer uses (DSL, Fiber optic, etc.), which is a key factor in analyzing churn among streaming service subscribers.**
### Tools

* **Excel:** Data cleaning and preparation.
* **SQL Server:** Data validation and exploratory data analysis.
* **R:**  In-depth exploratory data analysis, and visualization.
* **Tableau:** Interactive dashboard creation.

## Data Cleaning and Preparion
Initial data cleaning was performed in Excel:
1. **Data Type Standardization:** Column names were converted from CamelCase to snake_case for consistency with SQL and R.  The `total_charges`, `monthly_charges`, and `tenure` columns were converted to numeric data to enable mathematical operations and statistical analysis."types.
2. **Missing Value Handling:**  No missing values were found in the dataset after the initial cleaning.
3. **Duplicate Removal:** The dataset was checked for duplicate customer_id values to ensure data integrity. No duplicates were found.

The cleaned data was then imported into SQL Server, where additional data quality checks and validation were performed:
* **Data Quality Checks in SQL:** Data integrity was verified in SQL Server by checking row and column counts against the cleaned Excel data, confirming consistent data types, and ensuring the customer_id primary key contained no NULL values or duplicates. These checks are essential for maintaining data accuracy and reliability throughout the analysis.

* **Churn Column Validation:**  The churn column, the target variable for this analysis, was validated by checking its distinct values, which were confirmed to be 'Yes' and 'No'.

## Exploratory Data Analysis (EDA)
The following SQL queries were performed to gain initial insights into customer churn, with a particular focus on streaming service subscribers. This exploration helps identify potential churn drivers and inform further analysis in R

**Overall Churn rate:**

* What is the overall churn rate for the telecom company and what are the key customer metrics?
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

**Churn Rate Analysis:**
* **Question:** How does contract type and  internet service influence churn?
* **Churn Rate by Contract Type:** Contract type has a significant impact on churn.  Customers with month-to-month contracts customer(3875) have a dramatically higher churn rate (42.71%) compared to those with one-year (11.27%) or two-year (2.83%) contracts with customers of 1473 and 1675 respectively. This suggests that longer-term contracts are highly effective in retaining customers.  Further analysis will explore whether this relationship holds true for streaming subscribers as well.

* **Churn Rate by Internet Service Type:**  Internet service type significantly influences churn rate.  Fiber optic customers experience the highest churn (41.89%), despite fiber optic internet generally being considered the best option for streaming due to its higher speeds. This unexpected finding suggests that factors other than internet speed are likely contributing to churn among fiber optic customers. Potential explanations include higher prices for fiber optic services, technical issues specific to fiber optic connections, or increased competition in the fiber optic market.  This warrants further investigation to identify the specific drivers of churn within the fiber optic customer segment.  It's also shows that customers with no internet service have a very low churn rate (7.40%), which is expected as they are not using the company's internet services and therefore less likely to churn from them.  DSL customers fall in between, with a churn rate of 18.96%. This reinforces the need to investigate the specific reasons for the high churn rate among fiber optic customers, as it deviates significantly from the other internet service types.

* **Question:** How does streaming service subscription relate to churn?
* **Churn Rate by Streaming Service:** Customers subscribing to streaming TV had a churn rate of 30.07%, while those subscribing to streaming movies had a churn rate of 29.94%. These are very close to the overall churn rate (26.54%), suggesting that subscribing to streaming services alone might not be a significant driver of churn.

* **Question:** Does subscribing to both streaming movie and TV services impact churn differently than subscribing to only one or no streaming services?
* **Churn Rate for Customers with Either Both Streaming Movies or TV and Streaming Movies and TV:** Customers subscribing to both streaming services (29.43%) churn slightly less than those with at least one service (30.32%), but both groups churn more than customers with no streaming services (22.80%). This suggests a complex relationship between streaming service usage and churn.  While subscribing to both services might indicate higher customer satisfaction (leading to slightly lower churn), the fact that any streaming service usage is linked to higher churn than no usage warrants further investigation.  Possible explanations include issues with streaming service quality, higher costs associated with streaming, or other unmeasured factors.  Gathering qualitative data could provide additional insights into customer perceptions and motivations within these segments.

* **Question:** How does customer tenure relate to churn?
* **Average Tenure for Churned vs. Non-Churned:** As expected, there's a strong relationship between tenure and churn.  Churned customers have a significantly shorter average tenure (17.98 months) compared to non-churned customers (37.57 months). This confirms that longer-tenured customers are more likely to stay with the company, while newer customers are more prone to churn. This highlights the importance of focusing on customer retention strategies during the early stages of the customer lifecycle.
   
## Data Analysis in R

This section presents deeper explorations performed in R, building upon the initial insights gained from the SQL EDA. The focus is on comparing streaming subscribers to non-streamers to understand churn drivers.



**1. Churn Rate by Tenure and Streaming Status:**

[churn_rate_by_tenure_streaming.png]

This line graph displays the churn rate across different tenure lengths, comparing streamers and non-streamers. As seen in the SQL EDA, churn rate generally decreases with longer tenure. This visualization further reveals whether this trend differs between streaming and non-streaming customers. *[Add specific observations from the chart here.  Does the churn rate decrease faster for one group? Is there a point where the lines cross?  Provide concrete data points from the chart.  For example: "While both groups exhibit a declining churn rate with increased tenure, the decline is steeper for non-streamers, particularly in the first 12 months."]*.

* **Churn Rate and Average Charges by Streaming Service Subscription:** [Link to a visualization comparing churn rates and average charges for streamers vs. non-streamers].  Streaming subscribers have a slightly higher churn rate (30.01%) compared to the overall churn rate (26.54%), and also have higher average monthly (\$73.02 vs \$[Value]) and total charges (\$2501.73 vs \$[Value]). *Show the r-code and the result in your README.* *This comparison provides further insight to answer another EDA question - How much do streaming service subscribers pay on average each month and total?* This is highly relevant. Targetting these customers with higher charges with exceptional services would be necessary to retain these valuable customer segment. *Interpreting the findings and connecting them with business decision is a very valuable skill to showcase to recruiters.*

* **Churn Rate by Internet Service Type (Streaming Subscribers):** [Link to visualization]. *Interpret this visualisation. State the values calculated and compare them.*  As discussed in the SQL analysis, Fiber optic customers have a significantly higher churn rate, which warrants further investigation.

* **Churn Rate by Contract Type (Streaming Subscribers):** [Link to visualization]. *Focus on what contract type has higher churn and suggest how the company can increase customer retention based on this insight.*


* **Average Tenure for Churned vs. Non-Churned Streaming Subscribers:** [Link to visualization]. *Interpret the result and provide insight based on the result. State the average tenure values for both groups.* This is crucial for the business to evaluate customer behaviour and predict potential churn, informing retention strategies.


*(Optional Statistical Tests): If you perform any statistical tests, briefly mention them and their results here, further validating your findings.*
Use code with caution.    
