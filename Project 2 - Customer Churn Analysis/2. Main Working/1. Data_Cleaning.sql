-- |>>| Project 2 - Customer Churn Analysis (Cleaning Data > START <) |<<| --
# ------------------------------------------------------------------------- #

/*
Steps on which we should be working with this Project, is as following:
	>> 1. Inspect the Data
	>> 2. Handle Missing Values
	>> 3. Standardize Date Formats
	>> 4. Ensure Data Integrity
	>> 5. Create New Features for Analysis
	>> 6. Uploading Cleaned Data into Separate Table
*/

-- |>>| STEP 0 - Creating an alternate table (Reason: if there anything mistakely happen with the data-set, we should have available the real one!) |<<| --

CREATE TABLE step1_cleaning
LIKE raw_data;
    
INSERT INTO step1_cleaning
	SELECT *
    FROM raw_data;

-- |>>| STEP 1 - Inspecting the Data |<<| --

SELECT *
FROM step1_cleaning
LIMIT 10;

/*
Observations:
	1. blanks present in location column (i.e. 13 blank rows present)
    2. blanks present in last_login column (i.e. 39 blank rows present)
    3. date columns (signup_date, last_login & subscription_end) are all in the text format
*/

-- |>>| STEP 2 - Handling Missing Values |<<| --

## Since we have blanks in columns like (location & last_login), following step is to fill them!
UPDATE step1_cleaning
SET location = 'Unknown'
WHERE location = '';

UPDATE step1_cleaning
SET last_login = signup_date
WHERE last_login = '';

-- |>>| STEP 3 - Standardizing Date Formats |<<| --

## Since the formats of date columns were in text format, following step is to fix them!
UPDATE step1_cleaning
SET
	signup_date = STR_TO_DATE(signup_date, '%Y-%m-%d'),
	last_login = STR_TO_DATE(last_login, '%Y-%m-%d'),
	subscription_end = STR_TO_DATE(subscription_end, '%Y-%m-%d');
    
ALTER TABLE step1_cleaning
MODIFY COLUMN signup_date DATE;

ALTER TABLE step1_cleaning
MODIFY COLUMN last_login DATE;

ALTER TABLE step1_cleaning
MODIFY COLUMN subscription_end DATE;

-- |>>| STEP 4 - Ensuring Data Integrity |<<| --

## 1. Are there any negative ages?
SELECT *
FROM step1_cleaning
WHERE age < 0;

## 2. Any incorrect gender values?
SELECT DISTINCT gender
FROM step1_cleaning;

## 3. Any subscription_end dates before signup_date?
SELECT *
FROM step1_cleaning
WHERE subscription_end < signup_date;

/* Observation: Everything is Okay! */

-- |>>| STEP 5 - Creating New Features for Analysis |<<| --

## 1. Adding a new column subscription_length, which tells us how many days a customer stayed subscribed before churning.
ALTER TABLE step1_cleaning
ADD COLUMN subscription_length INT;

UPDATE step1_cleaning
SET subscription_length = DATEDIFF(subscription_end, signup_date);

## 2. Adding a new column days_since_last_login, which helps us to identify inactive users!
ALTER TABLE step1_cleaning
ADD COLUMN days_since_last_login INT;

UPDATE step1_cleaning
SET days_since_last_login = 
	CASE
		WHEN last_login <= CURDATE() THEN DATEDIFF(CURDATE(), last_login)
        ELSE NULL
	END;

-- |>>| STEP 6 - Uploading Cleaned Data into Separate Table For Exploratory Data Analysis (EDA) |<<| --

CREATE TABLE cleaned_data
LIKE step1_cleaning;

INSERT INTO cleaned_data
	SELECT *
    FROM step1_cleaning;

# ------------------------------------------------------------------------ #
-- |>>| Project 2 - Customer Churn Analysis (Cleaning Data > END <) |<<| --