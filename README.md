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
    * **Average Monthly Charges:** $64.76
    * **Average Total Charges:** $2283.30
      
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
   
## Data Analysis and Visulaisation

This section presents deeper explorations performed in R, building upon the initial insights gained from the SQL EDA. The focus is on comparing streaming subscribers to non-streamers to understand churn drivers.

**Overall Churn Rate by Streaming Status:** Streaming subscribers have a notably higher churn rate (30.32%) compared to non-streaming customers (22.80%). This difference suggests that streaming service usage, or factors related to it, might be contributing to increased churn. Further investigation is needed to understand the specific drivers behind this discrepancy. This finding underscores the importance of focusing on customer retention strategies specifically targeted at streaming subscribers.

**Churn Rate by Contract Type (Streaming Subscribers):**
![churn_rate_by_contract_streaming](https://github.com/user-attachments/assets/f7a1d63c-852b-448c-99da-57900bd2a1b6)

* **Month-to-month:**  Customers with month-to-month contracts have the highest churn rates.  Streamers in this category churn at a significantly higher rate (49.4%) than non-streamers (37.0%).
* **One year:** Churn rates are substantially lower for customers with one-year contracts. However, streamers still churn at a higher rate (17.0%) than non-streamers (4.01%).
* **Two year:**  Customers with two-year contracts have the lowest churn rates overall. Streamers have a slightly higher churn rate (4.29%) compared to non-streamers (1.24%), but both are significantly lower than other contract types.

This analysis reveals the strong influence of contract type on churn, with month-to-month contracts being the most vulnerable to churn, especially among streaming subscribers. Encouraging customers to switch to longer-term contracts, particularly streamers who demonstrate higher churn in month-to-month but low churn in longer term contracts is a key retention strategy.  While the analysis further reveals streaming customers on one-year contracts churn significantly more than non-streamers. Incentives and special offers could be introduced to encourage streamers to upgrade to a two-year contract to benefit from the lower churn rates observed there.  Understanding the motivations of streamers who churn despite having longer contracts is crucial for developing tailored interventions. Investigating specific reasons for churning on one-year contracts among streamers would provide insights into how to improve customer loyalty for different groups.

**Churn Rate by Tenure and Streaming Status:**
![churn_rate_by_tenure_streaming](https://github.com/user-attachments/assets/eef7d1db-fc0d-4953-a0e5-518e33d799d4)

This line graph displays the churn rate across different tenure lengths, comparing streamers and non-streamers. As seen in the SQL EDA, churn rate generally decreases with longer tenure. This visualization further reveals whether this trend differs between streaming and non-streaming customers. The line graph shows that churn rate decreases with longer tenure for both streaming and non-streaming customers.  However, streaming customers consistently exhibit a higher churn rate throughout the tenure period.  Churn is highest in the first month (85% for streamers, 56% for non-streamers) and lowest at 72 months (0% and 2%, respectively).  This indicates that while tenure is a strong predictor of churn for both groups, streaming customers are more likely to churn regardless of how long they've been with the company. This highlights the need to investigate factors specific to streaming services that might be contributing to this elevated churn rate.

**Churn Rate and Average Charges and Streaming Status:** Non-Streaming subscribers have a slightly Non-streaming subscribers unexpectedly churn slightly more (34.4%) than streaming subscribers (30.3%), despite lower average monthly charges ($60.90 vs. 86.00) and average total charges(1417 vs. $3487). This indicates a substantial churn rate even among higher-value streaming customers. Further investigation is needed to understand churn drivers for both groups: Why are non-streamers leaving despite lower costs? What factors beyond streaming impact churn? Targeted discounts or loyalty programs, alongside addressing service quality issues, could improve streamer retention. For non-streamers, understanding their churn reasons is key, especially given their lower revenue contribution.

**Churn Rate by Internet Service Type and Streaming Status:**

![churn_rate_by_internet_streaming](https://github.com/user-attachments/assets/4d470a9f-2464-4ffb-95df-fe23bd0f19ad)

 * **Fiber optic:**  Customers with fiber optic internet have the highest churn rates, with non-streamers churning significantly more (46.6%) than streamers (39.9%).
 * **DSL:**  DSL customers churn less than fiber optic customers, and the difference between streamers (14.2%) and non-streamers (24.5%) is more pronounced. Streamers using DSL churn significantly less.
 * **No internet service:**  As expected, customers with no internet service have the lowest churn rate (7.40%). This group consists entirely of non-streamers, as streaming requires an internet connection.

This analysis reveals a complex relationship between internet service type, streaming status, and churn. The high churn rate for fiber optic customers, regardless of streaming status, suggests potential issues with fiber optic service quality, pricing, or competition.  The lower churn rate among DSL streamers compared to DSL non-streamers indicates that providing a good DSL experience might be an effective retention strategy for this segment. Further investigation should explore the specific reasons driving churn within each internet service and streaming status group to develop targeted retention initiatives.


* **Average Tenure for Churned vs. Non-Churned Streaming Subscribers:** [Link to visualization]. *Interpret the result and provide insight based on the result. State the average tenure values for both groups.* This is crucial for the business to evaluate customer behaviour and predict potential churn, informing retention strategies.


*(Optional Statistical Tests): If you perform any statistical tests, briefly mention them and their results here, further validating your findings.*
Use code with caution.    
