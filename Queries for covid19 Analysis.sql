# COVID19-SQL-Analysis
 COVID-19 SQL Analysis: This project explores COVID-19 trends using PostgreSQL. It analyzes confirmed cases, deaths, and recoveries across regions, identifying key insights like monthly trends, country-wise impact, and statistical measures. Includes SQL queries for data exploration and visualization.

-- Backup queries from PGADMIN 4. NOTE: Table name is Covi, not Coro.

-- Creating the Covi table
CREATE TABLE Covi (
    Province TEXT,
    Country TEXT, 
    Latitude VARCHAR(255),
    Longitude VARCHAR(255),
    Date DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT
);

-- Select all records from Covi
SELECT * FROM Covi;

-- Question 1: Check for null values in each column
SELECT 'Province' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Province IS NULL UNION ALL
SELECT 'Country' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Country IS NULL UNION ALL
SELECT 'Latitude' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Latitude IS NULL UNION ALL
SELECT 'Longitude' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Longitude IS NULL UNION ALL
SELECT 'Date' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Date IS NULL UNION ALL
SELECT 'Confirmed' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Confirmed IS NULL UNION ALL
SELECT 'Deaths' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Deaths IS NULL UNION ALL
SELECT 'Recovered' AS column_name, COUNT(*) AS null_count FROM Covi WHERE Recovered IS NULL;

-- Question 2: If NULL values are present, update them with zeros for all columns (No NULLs allowed)
UPDATE Covi
SET Province = COALESCE(Province, '0'),
    Country = COALESCE(Country, '0'),
    Latitude = COALESCE(Latitude, '0'),
    Longitude = COALESCE(Longitude, '0'),
    Date = COALESCE(Date, '0'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Question 3: Check total number of rows in the table
SELECT COUNT(*) AS total_rows FROM Covi;

-- Check total number of columns in the table
SELECT COUNT(column_name) AS total_columns
FROM information_schema.columns
WHERE table_name = 'Covi';

-- Question 4: Check start and end date
SELECT MIN(Date) AS start_date, MAX(Date) AS end_date FROM Covi;

-- Question 5: Number of distinct months present in the dataset
SELECT COUNT(DISTINCT EXTRACT(MONTH FROM Date)) AS num_months_present FROM Covi;

-- Question 6: Find monthly averages for Confirmed, Deaths, and Recovered
SELECT EXTRACT(MONTH FROM Date) AS month, 
       AVG(Confirmed) AS avg_confirmed, 
       AVG(Deaths) AS avg_deaths, 
       AVG(Recovered) AS avg_recovered
FROM Covi
GROUP BY EXTRACT(MONTH FROM Date)
ORDER BY month;

-- Question 7: Find the most frequent value for Confirmed, Deaths, and Recovered each month
SELECT EXTRACT(MONTH FROM Date) AS month, 
       MAX(Confirmed) AS max_confirmed, 
       MAX(Deaths) AS max_deaths, 
       MAX(Recovered) AS max_recovered
FROM Covi
GROUP BY EXTRACT(MONTH FROM Date);

-- Question 8: Find minimum values for Confirmed, Deaths, and Recovered per year
SELECT EXTRACT(YEAR FROM Date) AS year,
       MIN(Confirmed) AS min_confirmed, 
       MIN(Deaths) AS min_deaths, 
       MIN(Recovered) AS min_recovered
FROM Covi
GROUP BY EXTRACT(YEAR FROM Date);

-- Question 9: Find maximum values for Confirmed, Deaths, and Recovered per year
SELECT EXTRACT(YEAR FROM Date) AS year,
       MAX(Confirmed) AS max_confirmed, 
       MAX(Deaths) AS max_deaths, 
       MAX(Recovered) AS max_recovered
FROM Covi
GROUP BY EXTRACT(YEAR FROM Date);

-- Question 10: The total number of cases of Confirmed, Deaths, and Recovered each month
SELECT EXTRACT(MONTH FROM Date) AS month,
       SUM(Confirmed) AS total_confirmed, 
       SUM(Deaths) AS total_deaths, 
       SUM(Recovered) AS total_recovered
FROM Covi
GROUP BY EXTRACT(MONTH FROM Date)
ORDER BY month;

-- Rename the table (if necessary)
RENAME TABLE Coro TO Covi;

-- Question 11: Check how COVID-19 spread with respect to confirmed cases (e.g., total, average, variance, and standard deviation)
SELECT 'Total Death Cases' AS Statistic, SUM(Deaths) AS Value FROM Covi
UNION ALL
SELECT 'Average Death Cases' AS Statistic, AVG(Deaths) AS Value FROM Covi
UNION ALL
SELECT 'Variance of Death Cases' AS Statistic, VARIANCE(Deaths) AS Value FROM Covi
UNION ALL
SELECT 'Standard Deviation of Death Cases' AS Statistic, STDDEV(Deaths) AS Value FROM Covi
UNION ALL
SELECT 'Total Confirmed Cases' AS Statistic, SUM(Confirmed) AS Value FROM Covi
UNION ALL
SELECT 'Average Confirmed Cases' AS Statistic, AVG(Confirmed) AS Value FROM Covi
UNION ALL
SELECT 'Variance of Confirmed Cases' AS Statistic, VARIANCE(Confirmed) AS Value FROM Covi
UNION ALL
SELECT 'Standard Deviation of Confirmed Cases' AS Statistic, STDDEV(Confirmed) AS Value FROM Covi
UNION ALL
SELECT 'Total Recovered Cases' AS Statistic, SUM(Recovered) AS Value FROM Covi
UNION ALL
SELECT 'Average Recovered Cases' AS Statistic, AVG(Recovered) AS Value FROM Covi
UNION ALL
SELECT 'Variance of Recovered Cases' AS Statistic, VARIANCE(Recovered) AS Value FROM Covi
UNION ALL
SELECT 'Standard Deviation of Recovered Cases' AS Statistic, STDDEV(Recovered) AS Value FROM Covi;

-- Question 12: Check how COVID-19 spread with respect to Death Cases per month (e.g., total, average, variance, and standard deviation)
SELECT EXTRACT(MONTH FROM Date) AS Month,
       SUM(Deaths) AS total_death_cases,
       AVG(Deaths) AS average_death_cases,
       VARIANCE(Deaths) AS variance_death_cases,
       STDDEV(Deaths) AS stdev_death_cases
FROM Covi
GROUP BY Month
ORDER BY Month;

-- Question 13: Check how COVID-19 spread with respect to Recovered Cases per month
SELECT EXTRACT(MONTH FROM Date) AS Month,
       SUM(Recovered) AS total_recovered_cases,
       AVG(Recovered) AS average_recovered_cases,
       VARIANCE(Recovered) AS variance_recovered_cases,
       STDDEV(Recovered) AS stdev_recovered_cases
FROM Covi
GROUP BY Month
ORDER BY Month;

-- Question 14: Find the country with the highest number of confirmed cases
SELECT Country AS Highest_Confirmed, Confirmed AS Count_Confirmed
FROM Covi
WHERE Confirmed = (SELECT MAX(Confirmed) FROM Covi);

-- Question 15: Find the country with the lowest number of death cases
SELECT DISTINCT Country AS Lowest_Country, Deaths AS Death_Count
FROM Covi
WHERE Deaths = (SELECT MIN(Deaths) FROM Covi);

-- Question 16: Find the top 5 countries with the highest number of recovered cases
SELECT Country AS Top, Recovered
FROM Covi
ORDER BY Recovered DESC
LIMIT 5;
