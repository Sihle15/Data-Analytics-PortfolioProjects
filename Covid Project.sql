use PortfolioProject;

select * from CovidDeaths$
where continent is not null
order by 3,4


--select * from CovidVaccinations$
--order by 3,4

-- Select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2

-- Looking at Total Cases vs total deaths
-- Showing the likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from CovidDeaths$
where location like '%ed stat%'
order by 1,2

-- Looking at the total cases vs population
-- Shows what percentage of population got Covid

select location, date, total_cases, population, ((total_cases/population)*100) as percentagePopulationInfected
from CovidDeaths$
--where location like '%states%'
order by 1,2

-- Looking at countries with Highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)*100) as percentagePopulationInfected
from CovidDeaths$
group by location,population
order by 2 desc,percentagePopulationInfected desc

--Showing countries with highest death coun

select location, Max(cast (total_deaths as int)) as TotalDeaths
from CovidDeaths$
where total_deaths is not null and continent is not null
group by location
order by TotalDeaths desc

-- Showing continents with the highest death count
select location as continents, Max(cast(total_deaths as int)) as TotalDeaths
from CovidDeaths$
where total_deaths is not null and continent is null
group by location
order by TotalDeaths desc

--Global numbers

select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, 
sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercent
from CovidDeaths$
where continent is not null

--Joining tables

select * 
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date

--Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3

-- CTE

with PopulationvsVaccination ( Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3)
)
select *, (RollingPeopleVaccinated/Population)* 100 as Percentage
from PopulationvsVaccination

-- TEMP Table

Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3)

select *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

-- creating view for visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (Partition by dea.location 
order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea
join CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null and vac.new_vaccinations is not null
--order by 2,3)

select * 
from PercentPopulationVaccinated
