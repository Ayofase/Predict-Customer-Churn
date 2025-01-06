# install packages
install.packages("tidyverse") 
install.packages("RColorBrewer")
install.packages("gridExtra")
install.packages("DBI")
install.packages("odbc")


# loading packages
library(tidyverse)
library(RColorBrewer)
library(gridExtra)
library(DBI)
library(odbc)

# Establishing database connection with SQL server
con <- DBI::dbConnect(odbc::odbc(),
                      Driver       = "ODBC Driver 17 for SQL Server", 
                      Server       = "DESKTOP-T4V4HVU",  
                      Database     = "telecom_data",
                      Trusted_Connection = "yes",
                      Port = 1433)

# Importing data
telco_data <- dbReadTable(con, "telco_customer_churn_data") 

# Close the connection
dbDisconnect(con) 

# Initial Data Inspection
head(telco_data)       # Viewing the first few rows
str(telco_data)        # Checking data types
summary(telco_data)    # Summary statistics

#converting character columns to factor
telco_data <- telco_data %>% mutate_if(is.character, as.factor)

# 1. Overall Churn Analysis

# Calculate overall churn rate
overall_churn_rate <- mean(telco_data$churn == "Yes") * 100

# Print overall churn rate. *Use value gotten from SQL analysis*
print(paste0("Overall churn rate: ", overall_churn_rate, "%"))

# Distribution of Customer by Contract Type.

contract_distribution <- telco_data %>%
  group_by(contract) %>%
  summarize(Customer_Count = n())           # n() calculates the count within each group


# Visualize Customer Distribution by Contract Type
ggplot(contract_distribution, aes(x = contract, y = Customer_Count, fill = contract)) + 
  geom_col() +
  labs(title = "Distribution of Customers by Contract Type", x = "Contract Type", y = "Number of Customers") +
  theme_minimal() +
  theme(legend.position = "none")

ggsave("customer_contract_distribution.png")


# 2. Streaming Service Subscriber Analysis

# Creating streaming indicator variable
telco_data <- telco_data %>%
  mutate(has_streaming = if_else(streaming_movies == "Yes" | streaming_tv == "Yes", "Yes", "No"))

# Filtering for streaming service subscribers
overall_churn_rate_streamers <- telco_data %>%
  filter(has_streaming == "Yes" & internet_service != "No") 

#Filtering for non streaming service subscribers
overall_churn_rate_nonstreamers <- telco_data %>%
  filter(has_streaming == "No")


# Calculating churn rate for streaming subscribers
overall_churn_rate_streamers <- mean(overall_churn_rate_streamers$churn == "Yes") * 100
# Print churn rate for streaming subscribers.
print(paste0("Churn rate for streaming subscribers: ", overall_churn_rate_streamers, "%"))

# Calculating churn rate for non-streaming subscribers
overall_churn_rate_nonstreamers <- mean(overall_churn_rate_nonstreamers$churn == "Yes") * 100
# Print churn rate for streaming subscribers.
print(paste0("Churn rate for streaming subscribers: ", overall_churn_rate_nonstreamers, "%"))

# Calculate churn rate by contract type for streamers and non-streamers
churn_by_contract <- telco_data %>%
  group_by(contract, has_streaming) %>%
  summarize(churn_rate = mean(churn == "Yes")*100, .groups = 'drop')


#Create Plot
ggplot(churn_by_contract, aes(x = contract, y = churn_rate, fill = has_streaming)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Churn Rate by Contract Type and Streaming Status", x = "Contract Type", y = "Churn Rate", fill = "Streaming Service") +
  theme_minimal()
ggsave("churn_rate_by_contract_streaming.png")

# Calculate churn rate by internet services for streamers and non-streamers
churn_by_internet <- telco_data %>%
  group_by(internet_service, has_streaming) %>%
  summarize(churn_rate = mean(churn == "Yes")*100, .groups = 'drop')


#Create Plot
ggplot(churn_by_internet, aes(x = internet_service, y = churn_rate, fill = has_streaming)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Churn Rate by Internet Services and Streaming Status", x = "Internet Services", y = "Churn Rate", fill = "Streaming Service") +
  theme_minimal()
ggsave("churn_rate_by_internet_streaming.png")

#Calculate churn rate by tenure for streamers and non-streamers
churn_by_tenure <- telco_data %>%
  group_by(tenure, has_streaming) %>%
  summarize(churn_rate = mean(churn == "Yes"), .groups = 'drop')

#Create Plot
ggplot(churn_by_tenure, aes(x = tenure, y = churn_rate, color = has_streaming)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 70, by = 10)) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(title = "Churn Rate by Tenure and Streaming Status", x = "Tenure (Months)", y = "Churn Rate", color = "Streaming Service") +
  theme_minimal()
ggsave("churn_rate_by_tenure_streaming.png")

#Churn rate and average charges by streaming service subscription
churn_charges_streaming <- telco_data %>%
  filter(internet_service != "No") %>% 
  group_by(has_streaming) %>% 
  summarize(
    churn_rate = mean(churn == "Yes")*100,
    avg_monthly_charges = mean(monthly_charges),
    avg_total_charges = mean(total_charges, na.rm = TRUE),
    .groups = "drop" 
  )


# Print the results
print("Churn Rate and Average Charges by Streaming Service:")
print(churn_charges_streaming)


# Average tenure for churned vs. non-churned streaming subscribers.
# Calculating average tenure for churned vs. non-churned streaming subscribers.
avg_tenure <- telco_data %>%
  filter(has_streaming == "Yes" & internet_service != "No") %>%
  group_by(churn) %>%
  summarize(avg_tenure = (mean(tenure, na.rm = TRUE)), .groups = "drop")

print(avg_tenure)

#Create Plot
ggplot(avg_tenure, aes(x = churn, y = avg_tenure, fill = churn)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Tenure for Churned vs. Non-Churned Streaming Subscribers", x = "Churn", y = "Average Tenure (months)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Paired")

ggsave("average_tenure_streaming_subscribers.png")


# Churn rate by streaming service (streaming_movies and streaming_tv)
# Creating plots individually
streaming_tv_plot <- ggplot(telco_data, aes(x = streaming_tv, fill = churn)) + # Plot streaming_tv
     geom_bar(position = "dodge") +
     scale_fill_brewer(palette = "Set2") +
     labs(x = "Streaming TV", y = "Count", fill = "Churn", title = "Churn by Streaming TV") +
     theme_minimal()

streaming_movies_plot <- ggplot(telco_data, aes(x = streaming_movies, fill = churn)) + # Plot streaming_movies
     geom_bar(position = "dodge") +
     scale_fill_brewer(palette = "Set2") +
     labs(x = "Streaming Movies", y = "Count", fill = "Churn", title = "Churn by Streaming Movies") +
     theme_minimal()

# Combining both plots together in one visualization
streaming_combined <- grid.arrange(streaming_tv_plot, streaming_movies_plot, ncol = 2)

ggsave("streaming_combined_plot.png", plot = streaming_combined, width = 10, height = 6)

