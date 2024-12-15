# Analyzing Customer Churn in a Telecom Company: Insights with a Focus on Streaming Service Subscribers

### Project Goal
Analyze customer behavior and service usage to understand churn drivers and develop data-driven recommendations for improving customer retention, with a focus on streaming service subscribers.

### Data source
This dataset used for the analysis is gotten from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?resource=download), contains detailed information about:
 - Customers who left within the last month – the column is called Churn
 - Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
 - Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges
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
## Data Manipulation
