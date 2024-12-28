
Wallmart Sales EDA

Walmart Sales Data Analysis 📊
Overview
This project analyzes Walmart Sales Data to uncover insights about product performance, customer behavior, and sales trends. Using SQL, we explore the dataset to answer key business questions and derive actionable insights to optimize operations, enhance customer experience, and boost profitability.

Table of Contents
Dataset Schema
Feature Engineering
Key Queries
Generic Insights
Product Analysis
Sales Analysis
Customer Insights
Temporal Trends
Advanced Analytics
Key Takeaways
Conclusion
Dataset Schema
The sales table was designed to capture all essential sales data attributes:

Column Name	Data Type	Description
invoice_id	VARCHAR(30)	Unique identifier for each transaction.
branch	VARCHAR(5)	Branch code of the store.
city	VARCHAR(30)	City where the branch is located.
customer_type	VARCHAR(30)	Type of customer (e.g., Member, Non-member).
gender	VARCHAR(10)	Gender of the customer.
product_line	VARCHAR(100)	Category of products sold.
unit_price	DECIMAL(10, 2)	Price per unit of the product.
quantity	INT	Quantity of the product sold.
VAT	FLOAT(6, 4)	Tax percentage applied.
total	DECIMAL(12, 4)	Total amount paid for the transaction.
date	DATETIME	Date of the transaction.
time	TIME	Time of the transaction.
payment_method	VARCHAR(15)	Payment method used (e.g., Cash, Credit Card).
cogs	DECIMAL(10, 2)	Cost of goods sold.
gross_margin_pct	FLOAT(11, 9)	Gross margin percentage.
gross_income	DECIMAL(12, 4)	Gross income generated.
rating	FLOAT(2, 1)	Customer rating for the transaction.
time_of_day	VARCHAR(20)	Engineered feature: "Morning", "Afternoon", or "Evening" based on time.
day_name	VARCHAR(10)	Engineered feature: Day of the week of the transaction.
month_name	VARCHAR(10)	Engineered feature: Month of the transaction.
Feature Engineering
To enrich the dataset, the following features were added:

time_of_day: Categorizes transactions into Morning, Afternoon, or Evening.
day_name: Extracts the name of the weekday (e.g., Monday, Tuesday).
month_name: Extracts the name of the month (e.g., January, February).
These features enable a deeper analysis of temporal patterns in sales.

Key Queries
Generic Insights
Number of Unique Cities: SELECT DISTINCT city FROM sales;
Branches and Cities: SELECT DISTINCT city, branch FROM sales;
Product Analysis
Unique Product Lines: SELECT COUNT(DISTINCT product_line) FROM sales;
Most Popular Product Line: SELECT product_line, COUNT(product_line) AS cnt FROM sales GROUP BY product_line ORDER BY 2 DESC;
Revenue by Product Line: SELECT product_line, ROUND(SUM(total),2) AS Total_Revenue FROM sales GROUP BY product_line ORDER BY 2 DESC;
Categorizing Product Lines: Products labeled as "Good" or "Bad" based on their sales relative to the average.
Sales Analysis
Sales by Time of Day: Compare weekday vs. weekend sales across time periods (Morning, Afternoon, Evening).
Revenue by Customer Type: SELECT customer_type, ROUND(SUM(total), 2) AS Revenue FROM sales GROUP BY customer_type ORDER BY 2 DESC LIMIT 1;
Branch with Above-Average Sales: SELECT branch, SUM(quantity) AS qty FROM sales GROUP BY branch HAVING qty > (SELECT AVG(quantity) FROM sales);
Customer Insights
Customer Type Distribution: Analyze customer types and their contribution to revenue and VAT.
Gender Distribution by Branch: Percentage of male and female customers per branch.
Most Common Payment Method: SELECT payment_method, COUNT(payment_method) AS cnt FROM sales GROUP BY payment_method ORDER BY 2 DESC;
Temporal Trends
Revenue by Month: SELECT month_name, ROUND(SUM(total),2) AS Total_Revenue FROM sales GROUP BY month_name ORDER BY 2 DESC;
COGS by Month: SELECT month_name, ROUND(SUM(cogs),2) AS Total_COGS FROM sales GROUP BY month_name ORDER BY 2 DESC;
Advanced Analytics
Time and Day Ratings by Branch: Identifies when branches receive the most customer ratings.
City with Largest VAT Contribution: SELECT city, ROUND(AVG(VAT), 2) AS vat FROM sales GROUP BY city ORDER BY 2 DESC LIMIT 1;
Key Takeaways
Product Performance:

Identified high-performing product lines contributing the most revenue and VAT.
Categorized products as "Good" or "Bad" based on sales performance.
Customer Behavior:

Gained insights into the gender distribution and most common payment methods.
Analyzed revenue contributions by customer type.
Branch Insights:

Highlighted top-performing branches and their peak customer engagement times.
Temporal Trends:

Identified peak sales months and days for strategic planning.
Highlighted weekday vs. weekend sales patterns.
Conclusion
This project demonstrates a comprehensive SQL-based approach to uncover actionable insights from Walmart's sales data. By leveraging advanced SQL queries, feature engineering, and exploratory data analysis, we answered key business questions that can drive strategic decision-making.

Feel free to use this project as a reference for similar SQL-based analytics tasks. If you find this helpful, give the repository a ⭐!

License
This project is licensed under the MIT License.

