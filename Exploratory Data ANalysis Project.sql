-- Exploratory Data ANalysis Project

-- View all data in the layoffs_staging2 table
SELECT *
FROM layoffs_staging2;

-- Get the maximum number of total layoffs and highest percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Retrieve all records where the entire company was laid off (100%)
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Get the total layoffs per company, ordered from highest to lowest
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
-- Find the earliest and latest layoff dates in the dataset
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2 ;

-- Get total layoffs by industry, ordered by the highest layoffs
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Get total layoffs by country, ordered by the highest layoffs
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Get yearly total layoffs, sorted from most recent to oldest year
SELECT YEAR( `date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR( `date`)
ORDER BY 1 DESC;

-- Get total layoffs by month (using month extracted from date)
SELECT substring(`date`, 6,2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

-- Calculate rolling total layoffs by month
WITH ROLLING_Total AS
(SELECT substring(`date`, 6,2) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total  ;   

-- Total layoffs per company, ordered by the highest
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Get total layoffs per company per year, sorted alphabetically by company
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY COMPANY ASC;

-- Create a Common Table Expression (CTE) named Company_Year that aggregates total layoffs by company and year

WITH Company_Year(company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
),
-- Create another CTE to rank companies by total layoffs for each year
Company_Year_Rank AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS RANKING
FROM Company_Year
WHERE years IS NOT NULL
)
-- Final query to select only the top 5 companies with the most layoffs each year
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;











