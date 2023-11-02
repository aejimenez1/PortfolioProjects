--SELECT *
--FROM PortfolioProjects..CovidDeaths$
--ORDER BY 3,4

--SELECT *
--FROM PortfolioProjects..CovidVaccinations$
--ORDER BY 3,4

SELECT LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS, POPULATION
FROM PortfolioProjects..CovidDeaths$
ORDER BY 1,2

--Looking at Total cases vs Total Deaths
-- Shows how likely you will dye if you get covid
Select location, date, total_cases,total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProjects..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Population 

Select location, date, total_cases, population,
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 as DeathPercentage
From PortfolioProjects..CovidDeaths$
Where location like '%states%'
order by 1,2

--Looking at countries with Highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount, 
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100) as PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
--Where location like '%states%'
Group by location, Population
order by PercentPopulationInfected desc


--Showing the countries with the highest death count per population

Select location, MAX(cast(total_deaths as float)) as TotalDeathCount
From PortfolioProjects..CovidDeaths$
Where continent is not NULL
Group by location
Order by TotalDeathCount desc


-- Lest break things down by continent


Select location, MAX(cast(total_deaths as float)) as TotalDeathCount
From PortfolioProjects..CovidDeaths$
Where continent is NULL
Group by location
Order by TotalDeathCount desc


--Showing the continents with the highest death count

Select continent, MAX(cast(total_deaths as float)) as TotalDeathCount
From PortfolioProjects..CovidDeaths$
Where continent is not NULL
Group by continent
Order by TotalDeathCount desc



--GLOBAL NUMBERS


Select date, SUM(CAST(new_cases AS float)) AS CASES, SUM(cast(new_deaths as float)) as DEATHS
--(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
from PortfolioProjects..CovidDeaths$
Where continent is not NULL 
Group by date
order by 1



-- Looking at Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
Where dea.continent is not Null
order by 2,3


--USE CTE

With PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProjects..CovidDeaths$ dea
join PortfolioProjects..CovidVaccinations$ vac
on dea.location = vac.location 
and dea.date = vac.date
Where dea.continent is not Null 
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
