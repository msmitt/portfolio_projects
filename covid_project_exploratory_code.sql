-- Shows what percentage of population contracted COVID-19 in the United States
SELECT
  location, date, total_cases, population, total_deaths,
   (total_cases / population)*100 AS InfectionPercentage --aliasing a percentage of infection
   
FROM
  `project-practice-trees20.covid_project.covid_deaths` 

WHERE
 location = "United States"

ORDER BY
 InfectionPercentage DESC

-- shows the likeihood of dying if you contract COVID-19 in the United States
SELECT
  location, date, total_cases, new_cases, total_deaths,
   (total_deaths / total_cases)*100 AS DeathPercentage --aliasing a percentage of deaths

FROM
  `project-practice-trees20.covid_project.covid_deaths` 

WHERE
 location = "United States"

ORDER BY
 date DESC
 
-- Show countries with highest death count per population
SELECT
  location,
  MAX(Total_deaths) as TotalDeathCount
FROM
  `project-practice-trees20.covid_project.covid_deaths`
WHERE
  continent != "Null" -- exclude the separate regional aggregate counts
GROUP BY
  location -- Group by location to get aggregate values per location
ORDER BY
  TotalDeathCount DESC
  
-- Show continents with highest death count
SELECT
  continent,
  MAX(Total_deaths) as TotalDeathCount
FROM
  `project-practice-trees20.covid_project.covid_deaths`
WHERE
  continent != "Null" -- exclude the separate regional counts
GROUP BY
  continent -- Group by continent to get aggregate values per location
ORDER BY
  TotalDeathCount DESC

-- Explore global data
SELECT
  SUM(new_cases) AS total_cases,
  SUM(new_deaths) AS total_deaths,
  SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage -- convert to percentage and alias
FROM
  `project-practice-trees20.covid_project.covid_deaths` 

WHERE
  continent != "Null"
ORDER BY
 DeathPercentage DESC

-- What countries have the highest infection rate compared to Population
SELECT
  location,
  MAX(population) AS Population, -- Use MAX(population) to get the population for the location
  MAX(total_cases) AS HighestInfectionCount,
  MAX(total_cases/population)*100 AS PopulationInfectedPercent --covert to percentage and alias
FROM
  `project-practice-trees20.covid_project.covid_deaths`
GROUP BY
  location -- Group by location to get aggregate values per location
ORDER BY
  PopulationInfectedPercent DESC, HighestInfectionCount DESC

-- Temp Table
WITH PercentPopulationVaccinated AS (
    SELECT
        dea.continent,
        dea.location,
        dea.date,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS RollingPeopleVaccinated
    FROM
        `project-practice-trees20.covid_project.covid_deaths` AS dea -- Replace with your actual project and dataset if different
    JOIN
        `project-practice-trees20.covid_project.covid_vaccinations`  AS vac -- Replace with your actual project and dataset if different
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE
        dea.continent IS NOT NULL
)
SELECT
    *,
    (RollingPeopleVaccinated / Population) * 100 AS PercentVaccinated
FROM
    PercentPopulationVaccinated
ORDER BY
    location,
    date;

-- note: this is a personal, explaratory project
