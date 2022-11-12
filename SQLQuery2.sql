SELECT * 
FROM PortfolioProject1..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4

--SELECT * 
--FROM PortfolioProject1..CovidVaccinations
--ORDER BY 3, 4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject1..CovidDeaths
ORDER BY 1, 2


-- Total Cases VS Total Deaths in US?
-- How likely are you to die if contractiong COVID in the US?

SELECT Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject1..CovidDeaths
WHERE LOCATION like '%states%'
ORDER BY 1, 2

--Total Cases VS Population
-- What % of the population contracted COVID?

SELECT Location, date, total_cases, population,(total_cases/population)*100 as InfectionPercentage
FROM PortfolioProject1..CovidDeaths
WHERE LOCATION like '%states%'
ORDER BY 1, 2

-- What countries had the highest rate of infection VS population?

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX(total_deaths/total_cases)*100 as PopulationInfectionPercentage
FROM PortfolioProject1..CovidDeaths
--WHERE LOCATION like '%states%'
GROUP BY Location, Population
ORDER BY PopulationInfectionPercentage desc

--Countries with highest death count VS population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject1..CovidDeaths
--WHERE LOCATION like '%states%'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeaths desc

--By Continent W/Null

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeaths
FROM PortfolioProject1..CovidDeaths
--WHERE LOCATION like '%states%'
WHERE continent is null
GROUP BY Location
ORDER BY TotalDeaths desc


-- Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Join Tables

Select deaths.continent, deaths.location, deaths.date, deaths.population, vacs.new_vaccinations
From PortfolioProject1..CovidDeaths deaths
Join PortfolioProject1..CovidVaccinations vacs
   On deaths.location = vacs.location
   and deaths.date = vacs.date
   WHERE deaths.continent is not null
ORDER by 1,2,3


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- View

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject1..CovidDeaths dea
Join PortfolioProject1..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
