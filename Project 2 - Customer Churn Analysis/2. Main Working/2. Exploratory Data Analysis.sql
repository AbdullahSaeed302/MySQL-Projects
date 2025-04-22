-- |>>| Project 2 - Customer Churn Analysis (Exploratory Data Analysis > START <) |<<| --
# ------------------------------------------------------------------------------------- #

## Inspecting the Cleaned Data:
SELECT *
FROM cleaned_data;

/*
Steps on which we should be working with this Project, is as following:
	>> 1. Get Basic Statistics
	>> 2. Churn Analysis by Different Factors
	>> 3. Identify Potential Causes of Churn
*/

-- |>>| STEP 1 - Get Basic Statistics |<<| --

## 1. Looking for the Total Customers Count, helps us understand the dataset size!
SELECT COUNT(*) as total_customers
FROM cleaned_data;


## 2. Looking for the Churn Rate (Percentage of Churned Customers), tells us how many customers left in percentage form!
SELECT
	ROUND(SUM(is_churned) / COUNT(*) * 100, 2) AS churn_rate_percentage
FROM cleaned_data;


## 3. Looking for the minimum & maximum date ranges, helps us to understand the time period size!
SELECT
	MIN(signup_date) AS minimum_date,
    MAX(signup_date) AS maximum_date,
    DATEDIFF(MAX(signup_date), MIN(signup_date)) AS total_days
FROM cleaned_data;

-- |>>| STEP 2 - Churn Analysis by Different Factors |<<| --

## 1. Looking for Churn by Subscription Plan, helps identify which plan has the highest churn!
SELECT
	subscription_plan,
	COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    (COUNT(*) - SUM(is_churned)) AS remaining_customers,
    ROUND(SUM(is_churned) / COUNT(*) * 100, 2) AS churn_rate
FROM cleaned_data
GROUP BY subscription_plan
ORDER BY churn_rate DESC;


## 2. Looking for Churn by Gender, helps determine which gender group is more likely to churn!
SELECT
	gender,
    COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    (COUNT(*) - SUM(is_churned)) AS remaining_customers,
    ROUND((SUM(is_churned) / COUNT(*)) * 100, 2) AS churn_rate
FROM cleaned_data
GROUP BY gender
ORDER BY churn_rate DESC;


## 3. Looking for Churn by Age Group, helps determine which age group is more likely to churn!
SELECT
	CASE
		WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
	END AS age_group,
	COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    (COUNT(*) - SUM(is_churned)) AS remaining_customers,
    ROUND((SUM(is_churned) / COUNT(*)) * 100, 2) AS churn_rate
FROM cleaned_data
GROUP BY age_group
ORDER BY churn_rate DESC;


## 4. Looking for Churned Customers (Year-Wise), helps us determine which year has most churns!
SELECT
	YEAR(signup_date) AS `Year`,
    SUM(is_churned) AS churned_customers
FROM cleaned_data
GROUP BY `Year`
ORDER BY `Year`;


## 5. Looking for the running total along with months, helps us determine which customers are more likely to churn (i.e. old or new)!
WITH CTE AS (
	SELECT
		SUBSTRING(signup_date, 1, 7) AS `Month`,
		SUM(is_churned) AS churned_customers
	FROM cleaned_data
	GROUP BY `Month`
	ORDER BY `Month` ASC
)
SELECT
	`Month`,
    churned_customers,
    SUM(churned_customers) OVER (ORDER BY `Month` ASC) AS Running_Total
FROM CTE;

-- |>>| STEP 3 - Identify Potential Causes of Churn |<<| --

## 1. Looking for Churn by Payment Status, helps see if unpaid customers are more likely to churn!
SELECT
	payment_status,
    COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    ROUND((SUM(is_churned) / COUNT(*)) * 100, 2) AS churn_rate
FROM cleaned_data
GROUP BY payment_status
ORDER BY churn_rate DESC;


## 2. Looking for When They Churned, will show if there’s a pattern — maybe more customers churn at year-end or during specific months.
SELECT
	YEAR(subscription_end) AS `Year`,
    MONTHNAME(subscription_end) AS `Month`,
    COUNT(*) AS churned_customers
FROM cleaned_data
WHERE payment_status = 'Unpaid'
GROUP BY `Year`, `Month`
ORDER BY churned_customers DESC;


## 3. Looking for Does Inactivity Lead to Churn?, shows if inactive users are more likely to churn!
SELECT
	CASE
		WHEN days_since_last_login <= 30 THEN 'Active (≤30 days)'
        WHEN days_since_last_login BETWEEN 31 AND 90 THEN 'Inactive (31-90 Days)'
        ELSE 'Highly Inactive (90+ Days)'
	END AS activity_status,
	COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    ROUND((SUM(is_churned) / COUNT(*)) * 100, 2) AS churn_rate
FROM cleaned_data
GROUP BY activity_status
ORDER BY churn_rate DESC;

# ----------------------------------------------------------------------------------- #
-- |>>| Project 2 - Customer Churn Analysis (Exploratory Data Analysis > END <) |<<| --