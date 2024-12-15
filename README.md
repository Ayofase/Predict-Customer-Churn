# Analyzing Customer Churn in a Telecom Company with Streaming Services

### Project Goal
Analyze customer behavior and service usage to understand churn drivers and develop data-driven recommendations for improving customer retention, with a focus on streaming service subscribers.

### Data source
This dataset used for the analysis is gotten from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn?resource=download), contains detailed information 
 - Customers who left within the last month – the column is called Churn
 - Services that each customer has signed up for – phone, multiple lines, internet, online security, online backup, device protection, tech support, and streaming TV and movies
 - Customer account information – how long they’ve been a customer, contract, payment method, paperless billing, monthly charges, and total charges
 - Demographic info about customers – gender, age range, and if they have partners and dependents.
 - The raw data contains 7043 rows (customers) and 21 columns (features).

### Tools
- Excel
- SQL Server
- R 
- Tableau

## Data Cleaning and Exploration
Data cleaning process with the use of Excel to critical ensure good data quality and consistency before analysis. Below are the steps used for cleaning and preparing the dataset

#### 1. **Standardize Data Types**
 - - Replace column name from CamelCase to snake_case and changing all column title to lower case since SQL and R.
   - Date column standardise to date format.
   - Remove commas from numeric column (eg. Streaming_revenue and hours_viewed) in the revenue and engagement dataset for consistency
   - Standardise all column title to text.
   
#### 2. **Handling Missing Values**
   - Using Conditional Formatting in Microsoft Excel to highlight missing values. 9,836 missing release date data where found for both tv show and movies data with a total row number of 16,163
   - **TMDb API Integration:**
Missing release dates for movies and tv shows were retrieved using the TMDb API. [R](#netflix_tv_movie_tmdb.R) was implemented to perform this integration using the `httr` package for making API requests and the `jsonlite` package for parsing JSON responses from the TMDb API. If no matches were found for a title the corresponding release date field for that title was set to NA. 
#### 3. **Remove Duplicates in the primary id column, date in revenue data and title in engagement data**
   - No duplicate fund in the primary id column.
#### 4. **Replacing NA**
   - Replace NA in the release_date column in the revenue data which was as a result of unmatched titles from TMDb API integration process.
#### 5. **Flitering out irrelevant data**
   - Remove irrelevant data in the release date (any year below 2019) column and availability columns in engagement dataset
