--select * from Portfolio_project..CovidDeaths

--select * from Portfolio_project..CovidVaccinations

--select data we will use
select location,date,continent,total_deaths,population,total_cases
from Portfolio_project..CovidDeaths
order by 1,2

-- total cases vs total deaths
--shows likelihood of dying if you contract covid in your country
select location,date,total_cases,new_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from Portfolio_project..CovidDeaths
where location='India'
order by 1,2

--looking at total cases vs population
select location,date,total_cases,population,(total_cases/population)*100 as Infectedpercentage
from Portfolio_project..CovidDeaths
where location='India'
order by 1,2

-- looking at which country have highest infected rate
select location,max(total_cases/population)*100 as infectedrate
from Portfolio_project..CovidDeaths
group by location
order by infectedrate desc

--looking at which country have hghest mortality rate
select location,max(total_deaths/population)*100 as death_rate
from Portfolio_project..CovidDeaths
group by location
order by death_rate desc

-- lets break things down by continent
select continent,max(total_deaths/population)*100 as deathrate,max(total_deaths)
from Portfolio_project..CovidDeaths
where continent is not null 
group by continent
order by deathrate desc

--  global numbers
select max(total_deaths) as death,max(total_cases) as infected,location
from Portfolio_project..CovidDeaths
where continent is  null
group by location


select total_cases
from Portfolio_project..CovidDeaths
where location='Europe'

-- showing continents with the highest death count per population
select continent,sum(cast (total_deaths as int))/sum(population)
from Portfolio_project..CovidDeaths
where continent is not Null
group by continent

select distinct(continent) 
from Portfolio_project..CovidDeaths

select location,max(cast(total_deaths as int)) as death_count ,max(cast(total_deaths as int))/sum(population) as death_rate, max(cast(total_cases as int)) as infected_count,max(cast(total_cases as int))/sum(population) as infected_rate
from Portfolio_project..CovidDeaths
where continent is null and location not in ('World','European Union','International')
group by location

-- looking at vaccination table
select continent,location,sum(case when total_vaccinations is not null then cast(total_vaccinations as bigint) else null end)
from Portfolio_project..CovidVaccinations
where continent is not null and location='India'
group by continent,location

--joining
select *
from Portfolio_project..CovidDeaths as dea
join 
Portfolio_project..CovidVaccinations as vac
on dea.location=vac.location and dea.date=vac.date

-- cases in entire world over days
select max(population),sum(total_cases),date
from Portfolio_project..CovidDeaths
where continent is Null
group by date
order by date

--looking at total vaccination vs population
select max(dea.population),sum(case when vac.total_vaccinations is not null then cast(vac.total_vaccinations as bigint ) else null end),dea.location,dea.continent
from Portfolio_project..CovidDeaths as dea
join 
Portfolio_project..CovidVaccinations as vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is Not null and vac.continent is not null
group by dea.continent,dea.location
order by dea.continent desc ,dea.location desc


--creating view for later visulaization
create view  PercentPopulation_Vaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,
dea.Date) as RollingPeopleVaccinated
from Portfolio_project..CovidDeaths dea
join portfolio_project..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

CREATE VIEW 
Percent_Population_Vaccinated AS
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    -- Rolling sum of vaccinated people for each location ordered by date
    SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
FROM 
    Portfolio_project..CovidDeaths dea
JOIN 
    Portfolio_project..CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;


select * from Percent_Population_Vaccinated












