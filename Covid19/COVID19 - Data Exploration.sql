
-----------------------------------
---- Covid 19 Data Exploration 
---- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
-------------------------------------------


/* Check data */

	Select * from Deaths
	Select * from Vaccination


/* Select data needed */
	Select	location,
			population,
			date,
			total_cases,
			new_cases, 
			total_deaths,
			population
	From Deaths
	Order by 1,2



/* GERMANY */

--- Total case vs. total deaths vs.population in Germany
--- Percentage of population got Covid by year
	Select	location,
			year(date) as year,
			month(date) as month,
			max(population) as population, 
			max(total_cases) as cases_count,
			max(total_deaths) as death_count, 
			round(max((total_cases/population)*100),2) as PercenatagePopulationInfected,
			round(max((total_deaths/total_cases)*100),2) as PercentageInfectedDeath
	From Deaths
	Where location = 'Germany'
	Group by location, year(date), month(date)
	Order by 1,2 Desc,3 Desc




/*GLOBAL NUMBER OVER THE TIME*/

---- Total number of cases and death developing over the year
	Select  location,
			year(date) as year,
			max(total_cases) as cases_count,
			max(total_deaths) as death_count,
			round(max(total_cases)/max(population)*100,2) as PercenatagePopulationInfected,
			round(max(total_deaths)/max(total_cases)*100,2) as PercenatageInfectedDeath
	From Deaths
	Where location like 'world'
	Group by location, year(date)
	Order by 2 desc,3 desc


---- Death percentage of new infected cases
	Select  location,
			year(date) as year,
			month(date) as month,
			sum(new_cases) as new_cases_count,
			sum(new_deaths) as new_death_count,
			round(sum(new_deaths)/sum(new_cases)*100,2) as Percenatage_New_Infected_Death
	From Deaths
	Where location like 'world'
	Group by location, year(date),month(date)
	Order by 2 desc,3 desc


--- Seasonal detect
	WITH RankedMonths AS (
		SELECT 
			location,
			YEAR(date) AS year,
			MONTH(date) AS month,
			new_cases,
			ROW_NUMBER() OVER (PARTITION BY YEAR(date) ORDER BY new_cases DESC) AS rank
		FROM 
			Deaths
		WHERE 
			location LIKE 'world'
	)
	SELECT 
		location,
		year,
		month,
		new_cases
	FROM 
		RankedMonths
	WHERE 
		rank <= 3
	ORDER BY 
		2 DESC, 4 DESC;




/*CONTINENT*/
	
--- By location 
	Select location,
			population,
			max(total_cases) as cases_count,
			max(total_deaths) as death_count,
			round(max(total_cases)/max(population)*100,2) as PercenatagePopulationInfected,
			round(max(total_deaths)/max(total_cases)*100,2) as PercenatageInfectedDeath
	From Deaths
	Where location in ('World','North America', 'South America','Asia','Africa','Europe','Oceania')
	Group by location, population
	Order by 2 desc


--- By income group
	Select location,
			population,
			max(total_cases) as cases_count,
			max(total_deaths) as death_count,
			round(max(total_cases)/max(population)*100,2) as PercenatagePopulationInfected,
			round(max(total_deaths)/max(total_cases)*100,2) as PercenatageInfectedDeath
	From Deaths
	Where location like '%income'
	Group by location, population
	Order by 6 




/*TOP COUNTRY OVERVIEW*/

--- Countries with highest infection rate compared to population
	Select	top 50 
			location,
			population,
			max(total_cases) as cases_count,
			round(max(total_cases)/max(population)*100,2) as PercenatagePopulationInfected
	From Deaths
	Where location not like '%income' and location not in ('World','North America', 'South America','Asia','Africa','Europe','European Union','Oceania')
	Group by location, population
	Order by 4 desc


--- Countries with highest death count per population
	Select	top 50 
			location,
			population,
			max(total_deaths) as death_count,
			round(max(total_deaths)/max(total_cases)*100,2) as PercenatageInfectedDeath
	From Deaths
	Where location not like '%income' and location not in ('World','North America', 'South America','Asia','Africa','Europe','European Union','Oceania')
	Group by location, population
	Order by 4 desc



/* JOIN WITH VACINATION TABLE*/


--- Total Vaccinations vs Population
---- Use CTE

	WITH PopvsVac (continent, location, date, population, New_vaccinations, RollingPeopleVaccinated) AS
	(
		SELECT  d.continent,
				d.location,
				YEAR(d.date),
				d.population,
				v.new_vaccinations,
				SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
				/*(RollingPeopleVaccincated/d.population)*100*/
		FROM Deaths d
		JOIN Vaccination v 
			ON d.location = v.location
		WHERE d.location NOT LIKE '%income' 
			AND d.location NOT IN ('World', 'North America', 'South America', 'Asia', 'Africa', 'Europe', 'European Union', 'Oceania')
	)
	SELECT *, (RollingPeopleVaccinated/population)*100
	FROM PopvsVac
	ORDER BY 1, 2;


---- TEMP TABLE

	IF OBJECT_ID('tempdb..#Percentage_Population_Vaccinated') IS NOT NULL
	BEGIN
		EXEC('DROP TABLE #Percentage_Population_Vaccinated;');
	END

	Create Table #Percentage_Population_Vaccinated (
		location nvarchar(25),
		date datetime, 
		population numeric,  
		New_vaccinations numeric, 
		RollingPeopleVaccinated numeric
	)
	
	Insert into #Percentage_Population_Vaccinated
		SELECT  d.location,
				YEAR(d.date),
				d.population,
				v.new_vaccinations,
				SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
				/*(RollingPeopleVaccincated/d.population)*100*/
		FROM Deaths d
		JOIN Vaccination v 
			ON d.location = v.location
		WHERE d.location NOT LIKE '%income' 
			AND d.location NOT IN ('World', 'North America', 'South America', 'Asia', 'Africa', 'Europe', 'European Union', 'Oceania')


		SELECT *, (RollingPeopleVaccinated/population)*100
		Select * from #Percentage_Population_Vaccinated
		ORDER BY 1, 2;


--- Create view to store data for later dataviz
	Create View Percentage_Population_Vaccinated as
		SELECT  d.location,
				YEAR(d.date),
				d.population,
				v.new_vaccinations,
				SUM(v.new_vaccinations) OVER (PARTITION BY d.location ORDER BY d.location, d.date) AS RollingPeopleVaccinated
				/*(RollingPeopleVaccincated/d.population)*100*/
		FROM Deaths d
		JOIN Vaccination v 
			ON d.location = v.location
		WHERE d.location NOT LIKE '%income' 
			AND d.location NOT IN ('World', 'North America', 'South America', 'Asia', 'Africa', 'Europe', 'European Union', 'Oceania')