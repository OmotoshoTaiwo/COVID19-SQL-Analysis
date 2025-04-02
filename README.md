# COVID19-SQL-Analysis

COVID-19 SQL Analysis: This project explores COVID-19 trends using PostgreSQL. It analyzes confirmed cases, deaths, and recoveries across regions, identifying key insights like monthly trends, country-wise impact, and statistical measures. It includes SQL queries for data exploration and visualization.

## Database Structure

```sql
-- Create table structure for COVID-19 data
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

-- Select all data from the Covi table
SELECT * FROM covi;

-- Count the number of provinces in the dataset
SELECT COUNT(*) AS province FROM covi;

-- Question 1: Check if there are null values in any of the columns
SELECT 'Province' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Province IS NULL
UNION ALL
SELECT 'Country' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Country IS NULL
UNION ALL
SELECT 'Latitude' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Latitude IS NULL
UNION ALL
SELECT 'Longitude' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Longitude IS NULL
UNION ALL
SELECT 'Date' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Date IS NULL
UNION ALL
SELECT 'Confirmed' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Confirmed IS NULL
UNION ALL
SELECT 'Deaths' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Deaths IS NULL
UNION ALL
SELECT 'Recovered' AS column_name, COUNT(*) AS Null_count FROM covi WHERE Recovered IS NULL;

-- Question 2: If NULL Values are Present, Update Them with Zeros for All Columns
UPDATE covi
SET Province = COALESCE(Province, 'Unknown'),
    Country = COALESCE(Country, 'Unknown'),
    Latitude = COALESCE(Latitude, '0'),
    Longitude = COALESCE(Longitude, '0'),
    Date = COALESCE(Date, '2000-01-01'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Question 3: Check Total Number of Rows
SELECT COUNT(*) AS Total_row FROM covi;

-- Question 4: What is the Start Date and End Date in the dataset?
SELECT MIN(Date) AS start_date, MAX(Date) AS end_date
FROM covi;

-- Question 5: Number of Months Present in the Dataset
SELECT COUNT(DISTINCT EXTRACT(MONTH FROM Date)) AS num_months_present
FROM covi;

-- Question 6: Find Monthly Average for Confirmed, Deaths, Recovered
SELECT 
    EXTRACT(MONTH FROM Date) AS Month, 
    AVG(Confirmed) AS Average_Confirmed,
    AVG(Deaths) AS Average_Deaths,
    AVG(Recovered) AS Average_Recovered
FROM covi
GROUP BY EXTRACT(MONTH FROM Date)
ORDER BY EXTRACT(MONTH FROM Date);

-- Question 7: Find Most Frequent Value for Confirmed, Deaths, Recovered Each Month
SELECT 
    EXTRACT(MONTH FROM Date) AS Month, 
    MAX(Confirmed) AS Max_Confirmed,
    MAX(Deaths) AS Max_Deaths,
    MAX(Recovered) AS Max_Recovered
FROM covi
GROUP BY EXTRACT(MONTH FROM Date);
