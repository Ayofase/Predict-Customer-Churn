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
After initial cleaning in Excel, further data quality checks and preparation were performed in SQL Server to ensure data integrity and consistency before analysis.
After data quality checks, SQL queries were used to gain insights into customer churn, focusing on streaming service subscribers.

**Key Customer Metrics:**
   * Calculated counts of total customers, churned customers, non-churned customers, and streaming service subscribers.
   * Determined average monthly charges for streaming subscribers.

**Churn Rate Analysis:**
   * Calculated churn rates by streaming service (StreamingTV, StreamingMovies), contract type, and internet service type to identify potential churn drivers.
   * Calculated churn rate for customer subscribing to both streaming_movies and streaming_tv.

   ```sql
    SELECT (CASE WHEN streaming_tv = 'Yes' and streaming_movies= 'Yes' THEN 'Yes' else 'No' END) AS has_both_services,COUNT(*) AS total_customers,
     SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
      CAST(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS FLOAT) * 100 / COUNT(*) AS churn_rate
    FROM telco_customer_churn_data
    GROUP BY (CASE WHEN streaming_tv = 'Yes' and streaming_movies= 'Yes' THEN 'Yes' else 'No' END);
   ```
    
