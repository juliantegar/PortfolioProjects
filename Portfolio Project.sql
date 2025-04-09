select *
from PortfolioProjectt..CovidDeaths
where continent is not null
order by 3,4


Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjectt..CovidDeaths
order by 1,2

--total cases vs total deaths WORLD
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/total_cases)*100 as death_percentage
from PortfolioProjectt..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs population WORLD
Select location, date, population,total_cases,  (cast(total_cases as float)/population)*100 as infected_percentage
from PortfolioProjectt..CovidDeaths
where continent is not null
order by 1,2

--total cases vs total deaths indo
Select location, date, total_cases, total_deaths, (cast(total_deaths as float)/total_cases)*100 as death_percentage
from PortfolioProjectt..CovidDeaths
where location like 'indonesia'
order by 1,2

--looking at total cases vs population indo
Select location, date, population,total_cases,  (cast(total_cases as float)/population)*100 as infected_percentage
from PortfolioProjectt..CovidDeaths
where location like 'indonesia'
order by 2

--looking at countries with highest infection rate compared to population
Select location, population, Max(total_cases) as HighestInfectionCount,  max(cast(total_cases as float)/population)*100 as PopulationInfectedRate
from PortfolioProjectt..CovidDeaths
where continent is not null
group by location, population
order by PopulationInfectedRate desc

--showing countries with highest death count per population
Select location, Max(total_deaths) as HighestDeathCount
from PortfolioProjectt..CovidDeaths
where continent is not null
group by location
order by HighestDeathCount desc

--BREAK THINGS DOWN BY CONTINENT
--Showing continents with highest death count
Select continent, Max(total_deaths) as HighestDeathCount
from PortfolioProjectt..CovidDeaths
where continent is not null
group by continent
order by HighestDeathCount desc

--GLOBAL NUMBERS
Select  sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(cast(new_deaths as float))/sum(new_cases))*100 as DeathRate
from PortfolioProjectt..CovidDeaths
where continent is not null
--group by date
order by 1,2


--looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as CummulativePeopleVaccinated
--, (CummulativePeopleVaccinated/population)*100
from PortfolioProjectt..CovidDeaths dea
join PortfolioProjectt..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date date,
Population numeric,
New_vaccinations numeric,
CummulativePeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as CummulativePeopleVaccinated
--, (CummulativePeopleVaccinated/population)*100
from PortfolioProjectt..CovidDeaths dea
join PortfolioProjectt..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select*, (CummulativePeopleVaccinated/Population)*100 as CummulativePeopleVaccinatedRate
from #PercentPopulationVaccinated


-- Creating view to store data for later visualizations
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location,
dea.date) as CummulativePeopleVaccinated
--, (CummulativePeopleVaccinated/population)*100
from PortfolioProjectt..CovidDeaths dea
join PortfolioProjectt..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--rder by 2,3

select * from PercentPopulationVaccinated