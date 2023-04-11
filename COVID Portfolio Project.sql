SELECT *
FROM [Portfolio Project ]..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project ]..CovidVax
--ORDER BY 3,4

--Select data we are going to use

SELECT Location, date, total_cases,new_cases,total_deaths, population
FROM [Portfolio Project ]..CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths
-- Mortality rate for those infected

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portfolio Project ]..CovidDeaths
WHERE location like '%states%'
order by 1,2

-- Total Cases vs Population
-- % of population that contracted COVID-19 in the U.S.

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentInfected
FROM [Portfolio Project ]..CovidDeaths
WHERE location like '%states%'
order by 1,2

-- Countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentInfected
FROM [Portfolio Project ]..CovidDeaths
--WHERE location like '%states%'
GROUP BY Location, Population
order by PercentInfected DESC

-- Countries with highest death rate

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project ]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY Location
order by TotalDeathCount DESC

-- Breakdown by Continent

-- Highest Death count

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project ]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is null
GROUP BY location
order by TotalDeathCount DESC



-- Global numbers

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths AS int)) as total_deaths, SUM(cast(new_deaths AS int)) / SUM(New_cases)*100 AS DeathPercentage
FROM [Portfolio Project ]..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
order by 1,2

--Total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(CAST(vax.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project ]..CovidDeaths dea
JOIN [Portfolio Project ]..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
ORDER BY 2,3

--USE CTE

WITH PopvsVax (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(CAST(vax.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project ]..CovidDeaths dea
JOIN [Portfolio Project ]..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100
From PopvsVax

-- Temp table

DROP TABLE IF EXISTS #PercentPopulationVaxxed
CREATE TABLE #PercentPopulationVaxxed
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaxxed
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(CAST(vax.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project ]..CovidDeaths dea
JOIN [Portfolio Project ]..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaxxed

-- Create View to store for visualization

CREATE VIEW PercentPopulationVaxxed AS
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations, SUM(CAST(vax.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
From [Portfolio Project ]..CovidDeaths dea
JOIN [Portfolio Project ]..CovidVax vax
	ON dea.location = vax.location
	and dea.date = vax.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaxxed