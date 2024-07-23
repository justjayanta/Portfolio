
--Begining

SELECT * 
FROM [Portfolio Project]..['Covid Deaths$']
ORDER BY 3,4

--ALTER TABLE [Portfolio Project]..['Covid Deaths$'] ALTER COLUMN population DECIMAL
--ALTER TABLE [Portfolio Project]..['Covid Deaths$'] ALTER COLUMN total_cases DECIMAL

SELECT 
  location, 
  date, 
  total_cases, 
  new_cases, 
  total_deaths, 
  population
FROM [Portfolio Project]..['Covid Deaths$']
ORDER BY 1,2

--Likelyhood of Death

SELECT 
  location, 
  date, 
  total_cases, 
  new_cases, 
  total_deaths, 
  (total_deaths/total_cases)*100 as Death_Percentage
FROM [Portfolio Project]..['Covid Deaths$']

WHERE location LIKE 'India'
ORDER BY 1,2

--Percentage of population that got covid

SELECT 
  location, 
  population,
  MAX(total_cases) as Highest, 
  MAX(total_cases/population)*100 as Infectedmax
FROM [Portfolio Project]..['Covid Deaths$']
--WHERE location LIKE 'India'
GROUP BY location, population
ORDER BY Infectedmax DESC

--Total Deaths

SELECT 
  Location, 
  MAX(total_deaths) as TotalDeathCount
FROM [dbo].['Covid Deaths$']
WHERE Continent is not null
Group by Location
ORDER BY TotalDeathCount DESC

--Continent with the highest death count or Global numbers

SELECT 
  [location], 
  MAX([total_deaths]) as TotalDeathCountC
FROM [dbo].['Covid Deaths$']
WHERE (Continent is null  AND Location <> 'World' AND Location <> 'High income'  And Location <> 'Upper middle income' And Location <> 'Low income')
GROUP BY [location]
ORDER BY TotalDeathCountC DESC

--total death percentage

SELECT  
  MAX([new_cases]) as Total_cases, 
  MAX([new_deaths]) as Total_deaths, 
  (MAX([new_deaths])/MAX([new_cases]))*100 as Death_Percentage
FROM [dbo].['Covid Deaths$']
WHERE [continent] is null

--Population, New Cases & Vaccinations
-- using CTE

WITH PopvsVac AS (
    SELECT TOP 1000 
        CovidD.new_cases,
        CovidV.new_vaccinations,
        CovidD.continent,
        CovidD.location,
        CovidD.population,
        CovidD.date,
        SUM(CONVERT(INT, CovidV.new_vaccinations)) OVER (PARTITION BY CovidD.location ORDER BY CovidD.date) AS Rolling_Sum
    FROM [Portfolio Project]..['Covid Deaths$'] AS CovidD
    JOIN [Portfolio Project]..['Covid Vaccination$'] AS CovidV
    ON CovidD.location = CovidV.location
    AND CovidD.date = CovidV.date
    WHERE CovidD.continent IS NOT NULL
    AND CovidV.new_vaccinations IS NOT NULL
    AND CovidD.location = 'Albania'
)
SELECT 
   *,
  (Rolling_Sum/population)*100
FROM PopvsVac;







