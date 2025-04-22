-- |>>| Project 1 - Data Cleaning (START) |<<| --

/*
Steps on which we should be working with this Project, is as following:
>> 1. Removing Duplicates
>> 2. Standardizing the Data
>> 3. Fixing Null & Blank Values (if needed)
>> 4. Removing columns and rows (if needed)
*/

-- |>>| STEP 0 - Creating an alternate table (Means, if there anything mistakely happen with the data-set, we should have available the real one!) |<<| --

## Creating a alternate table of the raw one (i.e. the best practice to deal with the real_world data-sets)!
CREATE TABLE data_staging
LIKE raw_data;

INSERT INTO data_staging
SELECT *
FROM raw_data;

-- |>>| STEP 1 - Removing Duplicates (Means, Removing the rows that are duplicates) |<<| --
-- >> *** START OF THIS STEP *** << --

SELECT *
FROM data_staging;

## Removing duplicates (on the basis of company column)
SELECT *,
ROW_NUMBER()
	OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS `Row_Number`
FROM data_staging; ## Since we can't remove the duplicates like this, we have to add the row_number column permanently!

## For removing duplicates, creating a new table in which we'll add a new column (keeping old ones together)
CREATE TABLE `data_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM data_staging2;

## Inserting values in the newly created table!
INSERT INTO data_staging2
	SELECT *,
	ROW_NUMBER()
		OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS `Row_Number`
	FROM data_staging;

## For now, we are able to filter the data (i.e. Removing Duplicates)
DELETE
FROM data_staging2
WHERE `row_number` > 1;

## Now we have successfully removed the duplicates from the data!
SELECT *
FROM data_staging2;

-- >> *** END OF THIS STEP *** << --
-- |>>| STEP 2 - Standardizing the Data (Means, Fixing the issues present in the data) |<<| --
-- >> *** START OF THIS STEP *** << --

SELECT *
FROM data_staging2;

## (Fix #1) - Removing the leading/trilling whitespaces from the company column!
UPDATE data_staging2
SET company = TRIM(company);

## (Fix #2) - Fixing the industry column, like if there is some issue in writing the name (i.e. Industry name)
UPDATE data_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM data_staging2
ORDER BY industry;

## (Fix #3) - Fixing the country column same as the other ones, like if there any issues in writing something (i.e. Country name)
UPDATE data_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country
FROM data_staging2
ORDER BY 1;

## (Fix #4) - Fixing the date column, like changing the format of it for easy and understandable format! Also it's datatype (i.e. DATETIME)
UPDATE data_staging2
SET date = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE data_staging2
MODIFY COLUMN `date` DATE;

## Now we have successfully standardized the data!
SELECT *
FROM data_staging2;

-- >> *** END OF THIS STEP *** << --
-- |>>| STEP 3 - Fixing Null & Blank Values (Means, Populating or removing the Null & Blank columns) |<<| --
-- >> *** START OF THIS STEP *** << --

SELECT *
FROM data_staging2;

## (Fix #1) - Filling the null values in the industry column!    
UPDATE data_staging2 A
JOIN data_staging2 B
	ON A.company = B.company
    AND A.location = B.location
SET A.industry = B.industry
WHERE
	(A.industry IS NULL)
    AND
    B.industry IS NOT NULL;
    
## (Fix #2) - Removing the rows that are not neccessary for us! (i.e. both null values in Columns: total_laid_off & percentage_laid_off)
DELETE
FROM data_staging2
WHERE
	total_laid_off IS NULL
    AND
    percentage_laid_off IS NULL;

## Now we have successfully dealt or fixed the null and unwanted values!
SELECT *
FROM data_staging2;

-- >> *** END OF THIS STEP *** << --
-- |>>| Final Step - Removing rows and columns (Means, removing that data which we don't need for Analysis) & Updating the Cleaned Data into a separate table |<<| --
-- >> *** START OF THIS STEP *** << --

SELECT *
FROM data_staging2;

## (Fix #1) - Removing the unwanted column from our data! (i.e. row_number)
ALTER TABLE data_staging2
DROP COLUMN `row_number`;

## (Fix #2) - Uploading the successfully cleaned data into a separate table!
CREATE TABLE cleaned_data
LIKE data_staging2;

INSERT INTO cleaned_data
	SELECT *
    FROM data_staging2;

## Now we have successfully cleaned the messy & raw data (i.e. Data is ready for Analysis yet!)
SELECT *
FROM cleaned_data;

-- >> *** END OF THIS STEP *** << --

-- |>>| Project 1 - Data Cleaning (END)  |<<| --