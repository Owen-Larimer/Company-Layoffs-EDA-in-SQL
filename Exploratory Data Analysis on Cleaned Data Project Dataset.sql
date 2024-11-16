-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging3;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging3;

SELECT *
FROM layoffs_staging3
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

# Which company had the most layoffs?
SELECT company, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging3;
# SO our dataset tracks from the start of covid for about 3 years

# Which industry?
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY industry
ORDER BY 2 DESC;

# Which country?
SELECT country, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY country
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging3;

# Grouping by years
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;
# ISNT VERY RELEVANT


SELECT *
FROM layoffs_staging3;


SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging3
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

# I WANT TO MAKE A ROLLING SUM OF THIS!!!

WITH Rolling_Total AS 
(SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging3
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

#-----------------------------------------------------------
SELECT company, SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
ORDER BY company ASC;

# WHAT IF WE WANT TO RANK WHAT YEARS THESE COMPANIES LET PEOPLE OFF??? 

# Big companies first
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

# Have to do a CTE
 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging3
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS 
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years is NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;




