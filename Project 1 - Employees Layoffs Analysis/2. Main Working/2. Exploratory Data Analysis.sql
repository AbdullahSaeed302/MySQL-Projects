-- |>>| Project 2 - Exploratory Data Analysis (START) |<<| --

SELECT *
FROM cleaned_data;

-- |>>| BASIC - Exploratory Data Analysis |<<| --

## (EDA #1) - Looking for the maximum of the laid_offs (of a single company)
SELECT MAX(total_laid_off) maximum_laid_off, MAX(percentage_laid_off) maximum_percentage
FROM cleaned_data;

## (EDA #2) - Looking for the fully undered companys (lost all of employees) on the basis of total_laid_off in DESC order
SELECT *
FROM cleaned_data
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

## (EDA #3) - Looking for the fully undered companys (lost all of employees) on the basis of funds_raised_millions in DESC order
SELECT *
FROM cleaned_data
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

## (EDA #4) - Looking for the minimum & maximum date ranges
SELECT MIN(`date`) minimum_date, MAX(`date`) maximum_date
FROM cleaned_data;

## (EDA #5) - Looking for the Sum of total_laid_off on the basis of companys in DESC order
SELECT company, SUM(total_laid_off) total_laid_off
FROM cleaned_data
GROUP BY company
ORDER BY total_laid_off DESC;

## (EDA #6) - Looking for the Sum of total_laid_off on the basis of industrys in DESC order
SELECT industry, SUM(total_laid_off) total_laid_off
FROM cleaned_data
GROUP BY industry
ORDER BY total_laid_off DESC;

## (EDA #7) - Looking for the Sum of total_laid_off on the basis of locations in DESC order
SELECT location, SUM(total_laid_off) total_laid_off
FROM cleaned_data
GROUP BY location
ORDER BY total_laid_off DESC;

## (EDA #8) - Looking for the TOP 10 most affected countrys (most total_laid_offs) in DESC order
SELECT country, SUM(total_laid_off) total_laid_off
FROM cleaned_data
GROUP BY country
ORDER BY total_laid_off DESC
LIMIT 10;

## (EDA #9) - Looking for the total_laid_offs on the basis of years
SELECT YEAR(`date`) year, SUM(total_laid_off) total_laid_off
FROM cleaned_data
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 ASC;

## (EDA #10) - Looking for the total_laid_offs on the basis of stages
SELECT stage, SUM(total_laid_off) total_laid_off
FROM cleaned_data
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY total_laid_off DESC;

-- |>>| ADVANCED - Exploratory Data Analysis |<<| --

## (EDA #11) - Looking for the running total on the basis of months
WITH Running_Total AS (
	SELECT SUBSTRING(`date`, 1, 7) AS `month`, SUM(total_laid_off) AS total_laid_off
	FROM cleaned_data
	WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
	GROUP BY `Month`
	ORDER BY `Month`
)
SELECT `month`, total_laid_off,
	SUM(total_laid_off) OVER (ORDER BY `month` ASC) AS running_total
FROM Running_Total;

## (EDA #12) - Looking for the total_laid_offs (company-wise) on the basis of years
WITH CTE (company, years, total_laid_off) AS (
	SELECT company, YEAR(`date`), SUM(total_laid_off)
	FROM cleaned_data
	GROUP BY company, YEAR(`date`)
),
CTE_2 AS (
	SELECT *,
		DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
	FROM CTE
	WHERE years IS NOT NULL
)
SELECT *
FROM CTE_2
WHERE Ranking <= 5;

-- |>>| Project 2 - Exploratory Data Analysis (END)  |<<| --