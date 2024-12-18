# Analyzing Customer Churn in a Telecom Company: Insights with a Focus on Streaming Service Subscribers

### Project Goal
Analyze customer behavior and service usage to understand churn drivers and develop data-driven recommendations for improving customer retention, with a focus on streaming service subscribers.

### Data source
This dataset used for the analysis is gotten from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?resource=download), contains detailed information about:
 - Customers who left within the last month – the column is called Churn
 - Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
 - Customer account information – Tenure (how long they’ve been a customer), contract, payment method, paperless billing, monthly charges, and total charges
 - Demographic info about customers – gender, age range, and if they have partners and dependents.
 - The raw data contains 7043 rows (customers) and 21 columns (features).

### Tools
 - Excel - Data Cleaning
 - SQL Server
 - R 
 - Tableau

## Data Cleaning and Exploration
Data cleaning process with the use of Excel to critical ensure good data quality and consistency before analysis. Below are the steps used for cleaning and preparing the dataset
#### 1. **Standardize Data Types**
 - Renamed columns from CamelCase to snake_case (e.g., 'CustomerID' to 'customer_id') to ensure compatibility with SQL and R.
 - tenure, monthly_charges, total_charges column standardise to numeric format.   
#### 2. **Handling Missing Values**
   - Checked for missing values using conditional formatting. No missing values found especially in the primary key customer_id
#### 3. **Remove Duplicates in the primary id column, customer_id**
   - No duplicate fund in the primary id column.
## Data quality checks and Data Manipulation

After initial cleaning in Excel, further data quality checks and preparation were performed in SQL Server to ensure data integrity and consistency before analysis.

**1. Database and Table Creation:**

* Created a dedicated database named `telecom_data` in SQL Server.
* Created a table named `telco_customer_churn_data` within the database to store the cleaned dataset.

**2. Data Quality Checks:**

* **Row Count Verification:** Confirmed that the imported table contained the expected number of rows (7043), matching the cleaned Excel dataset.  This ensures no data loss during import.

* **Column Count Verification:**  Validated the column count (21) to ensure all columns were imported correctly.
    ```sql
    SELECT COUNT(*) AS column_count FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'telco_customer_churn_data';
    ```

* **Data Type Validation:** Checked data types of all columns to ensure they matched the expected types from the cleaned Excel dataset, preventing potential type-related issues during analysis(e.g.,  `customer_id` (NVARCHAR), `tenure` (TINYINT)).

* **Primary Key (customerID) Null Check:**  Confirmed the absence of NULL values in the `customer_id` column, ensuring the integrity of the primary key.
* **Duplicate Check:** Verified the absence of duplicate `customerID` values, further ensuring data integrity.
    ```sql
    SELECT customer_id, COUNT(customer_id) AS duplicates FROM telco_customer_churn_data GROUP BY customer_id HAVING COUNT(customer_id) > 1;
    ```
* **Churn Column Validation:** Checked for Invalid values in the Churn column to ensure only distinct values of 'Yes' and 'No' where present in the churn column.
    ```sql
    SELECT DISTINCT churn FROM telco_customer_churn_data;
    ```
