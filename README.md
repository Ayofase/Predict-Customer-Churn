# Analyzing Customer Churn in a Telecom Company: Insights with a Focus on Streaming Service Subscribers


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

1 **Row Count:** Verified row count consistency with the cleaned Excel data.

2 **Column Count:** Validated the expected number of columns.

   ```sql
    SELECT COUNT(*) AS column_count
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE table_name = 'telco_customer_churn_data';
   ```

3 **Data Types:** Checked data types for consistency.

4 **Primary Key (customer_id) Null Check:** Confirmed no NULLs in `customer_id`.

5 **Duplicate Check:**  Confirmed no duplicate `customer_id` values.

   ```sql
    SELECT customer_id, COUNT (customer_id)  AS duplicates
    FROM telco_customer_churn_data
    GROUP BY customer_id
    HAVING COUNT (customer_id)> 1;
   ```
* **Churn Column Validation:**  Checked distinct values present in the `churn` column.

## Exploratory Data Analysis (EDA)
The following SQL queries were performed to gain initial insights into customer churn, with a particular focus on streaming service subscribers. This exploration helps identify potential churn drivers and inform further analysis in R.

**Overall Churn Analysis:**

* **Overall Churn Rate:** 26.54% of total customers churned. This serves as a baseline for comparison with specific customer segments.
    ```sql
    SELECT COUNT(*) AS total_customers,                                                                            
       SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS total_churned,                                        
       CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS overall_churn_rate,  
       SUM(CASE WHEN churn = 'No' THEN 1 ELSE 0 END) AS total_non_churned                                      
    FROM telco_customer_churn_data;

    ```
* **Key Customer Metrics:**
    * **Total Customers:** 7043
    * **Churned Customers:** 1869
    * **Non-Churned Customers:** 5174
    * **Streaming Service Subscribers:** 3499
    * **Average Monthly Charges for Streaming Subscribers:** $86.03 
    * **Average Total Charges for Streaming Subscribers:** $3486.83 
**Churn Rate Analysis:**


* **Churn Rate by Streaming Service:** Customers subscribing to streaming TV had a churn rate of 30.07%, while those subscribing to streaming movies had a churn rate of 29.94%. These are very close to the overall churn rate (26.54%), suggesting that subscribing to streaming services *alone* might not be a significant driver of churn. *(Show one query as an example.)*

* **Churn Rate by Contract Type for Streaming Subscribers:** Combining contract type and streaming service usage reveals that month-to-month contracts have higher churn rates, but the addition of streaming services does not increase the churn rate as it remains similar. This suggests that the primary driver here is the length of contract agreement and not the presence of streaming services. *Provide insights gotten after running your query. This will show the recruiter you can interpret data* *(Show one query as an example.)*

* **Churn Rate by Internet Service Type:**  Fiber optic customers experienced the highest churn rate (41.89%), which is significantly higher than DSL (18.96%) and No internet service (7.40%). Since streaming relies heavily on internet quality, this finding could suggest that fiber optic customers, despite having the fastest internet, might have other issues (e.g., higher prices, technical problems) causing them to churn. *(Show the query)*.

* **Churn Rate for Customers with Both Streaming Movies and TV:** The churn rate for customers subscribing to *both* streaming services was 29.28%, slightly *lower* than the individual streaming service churn rates and very close to the overall churn rate. This is somewhat counterintuitive and could suggest that customers who are more invested in streaming services, by using both movie and TV streaming, which implies they are more satisfied with the services and are therefore less likely to churn. *(Show the query.)*


* **Average Tenure for Churned vs. Non-Churned Streaming Subscribers:** Churned streaming subscribers had an average tenure of 23.1 months, while non-churned streaming subscribers had a much longer average tenure of 38.7 months.  This reinforces the idea that longer tenure is associated with lower churn, even within the streaming subscriber segment. *(Show the query.)*
   ```
    
