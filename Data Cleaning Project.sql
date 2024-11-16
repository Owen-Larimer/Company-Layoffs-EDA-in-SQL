-- Data Cleaning Project


SELECT *
FROM layoffs; 


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blank values
-- 4. Remove any (unnecessary columns)



CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging; 


INSERT layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';



# CAN'T JUST DELETE LIKE THIS
WITH duplicate_cte AS 
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_staging3` (
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


SELECT *
FROM layoffs_staging3;

INSERT INTO layoffs_staging3
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;


SELECT * 
FROM layoffs_staging3
WHERE row_num > 1;

DELETE
FROM layoffs_staging3
WHERE row_num > 1;

SELECT *
FROM layoffs_staging3
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0; #THIS OVERRIDES SAFE UPDATE MODE FOR THE CURRENT SESSION

SELECT *
FROM layoffs_staging3;


-- STANDARDIZING DATA
#Trim the names so no white space
SELECT company, TRIM(company)
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET company = TRIM(company);


SELECT *
FROM layoffs_staging3
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging3
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

#LOOKING AT COUNTRIES COLUMN
SELECT DISTINCT country
FROM layoffs_staging3
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging3;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging3
ORDER BY 1;  


UPDATE layoffs_staging3
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';



SELECT *
FROM layoffs_staging3;


# LOOKING AT DATE (Turn text column into datetime column)
SELECT `date`
FROM layoffs_staging3;

UPDATE layoffs_staging3
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging3
MODIFY COLUMN `date` DATE;

#Now date column is a date datatype

SELECT *
FROM layoffs_staging3;


# NOW WE ARE LOOKING AT THE NULL AND BLANK VALUES

SELECT *
FROM layoffs_staging3
WHERE total_laid_off is null
AND percentage_laid_off is null; #The double nulls are pretty useless for us

# MAKE THE BLANKS NULLS (WENT BACK AND DID THIS)

UPDATE layoffs_staging3
SET industry = null
WHERE industry = '';

SELECT *
FROM layoffs_staging3
WHERE industry is null
OR industry = '';

SELECT *
FROM layoffs_staging3
WHERE company = 'Airbnb'; #One exists with an industry, so we can populate the blank


#LOOKING AT IT FIRST
SELECT t1.industry, t2.industry
FROM layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry is null or t1.industry = '')
AND t2.industry is not null;

#UPDATE STATEMENT
UPDATE layoffs_staging3 t1
JOIN layoffs_staging3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry is null
AND t2.industry is not null;


SELECT *
FROM layoffs_staging3
WHERE company LIKE 'Bally%';


SELECT *
FROM layoffs_staging3;


SELECT *
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE
FROM layoffs_staging3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging3;

ALTER TABLE layoffs_staging3
DROP COLUMN row_num;

