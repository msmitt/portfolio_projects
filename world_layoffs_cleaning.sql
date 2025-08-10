-- Data Exploration & Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Review null and blank values
-- 4. Remove irrelevant columns

-- Create a staging table (preserve the raw data)
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Identify duplicates
SELECT *
FROM layoffs_staging;

-- if row_num is above 1, the below query has found a duplicate
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- create a temporary table returning data with duplicates, "2" in the row_num
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- confirming that these do contain duplicates
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';
-- Casper does have a duplicate entry

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- confirm the table is created, but blank
SELECT *
FROM layoffs_staging2;

-- insert into the table
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- confirm the table loaded data successfully and filter
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- delete duplicates from the staging2 table
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- confirm the row_num > 2 lines were deleted
SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- view whole table
SELECT *
FROM layoffs_staging2;

-- 2. Standardizing data

SELECT DISTINCT(company)
FROM layoffs_staging2;

-- there are additional spacing around some of the companies, I'll TRIM() and compare.
SELECT company, TRIM(company)
FROM layoffs_staging2;

-- UPDATE() this into the table
UPDATE layoffs_staging2
SET company = TRIM(company);

-- viewing the updated table to confirm (success: "Included Health" and other entries have been TRIMmed and UPDATEd)
SELECT company
FROM layoffs_staging2;

-- moving onto industry...
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
-- this query reveals there are null and blank values. Also, "Crypto", "Crypto Currency", and "CryptoCurrency" should be the same industry.

-- Select all Crypto____ columns with the LIKE and % search modifier.
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- view to confirm that only Crypto remains for the three similar columns
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

-- review the main table
SELECT *
FROM layoffs_staging2
ORDER BY 1;

-- moving onto location
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;
-- there are some excess characters in translated city names, however this will not interfere with the clarity of the data exploration

-- moving onto country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- both "United States" and "United States." exist

SELECT *
FROM layoffs_staging2
WHERE country = 'United States.'
ORDER BY company;
-- 4 entries found

-- syntax additions to TRIM with TRAILING to remove the "."
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

-- UPDATE this table
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
-- output confirms 4 entries were changed

-- view to confirm
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
-- there is only one 'United States%' entry now, "United States"

-- review the main table
SELECT *
FROM layoffs_staging2
ORDER BY 1;

-- the "date" column is text string

-- create column with date format
SELECT `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');
-- 2355 rows were changed

-- the column type is still "text", though the data is formatted as a date now
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;
-- the `date` column is now in date format

-- review the main table
SELECT *
FROM layoffs_staging2
ORDER BY 1;

-- view the NULL values in total and percentage laid off
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- view NULL and missing values in industry
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- SET blank industries to NULL value to setup for replacement
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- exploring Airbnb, a company with NULL values
SELECT * 
FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Airbnb does two entries with different data. The March entry is missing an industry and contains a NULL value for percentage_laid_off. 
-- Populating the missing/NULL industries with data from other entries when there is another row with the same company name

SELECT *
FROM layoffs_staging2 AS t1 -- alias to t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
    
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;
-- resused the previous SELECT statement, confirmed the update was made

-- reviewing the missing and NULL values again
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';
-- 1 output, Bally's Interactive has NULL

SELECT * 
FROM layoffs_staging2
WHERE company LIKE 'Bally%';
-- Airbnb, Carvana, and Juul had two layoff lines to replace data. Bally's did not.

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
-- critical data is missing from these entries. for this independent cleaning, the "stakeholder" is satisfied with removing these.

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
