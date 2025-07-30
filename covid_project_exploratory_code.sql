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