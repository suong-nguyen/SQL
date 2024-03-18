/* PROJECT WALK THOUGH */

--Step 1: Create a database called 'Car_Accident'
--Step 2: Import the CVS files to this database as tables, namely 'accident' and 'vehicle'
--Step 3: Answer to 8 questions as DEA
	--Question 1: How many accidents have occurred in urban areas versus rural areas?
	--Question 2: Which day of the week has the highest number of accidents?
	--Question 3: What is the average age of vehicles involved in accidents based on their type?
	--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
	--Question 5: Are there any specific weather conditions that contribute to severe accidents?
	--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
	--Question 7: Are there any relationships between journey purposes and the severity of accidents?
	--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:

------------------------------------------------------------------------------------


--Step 1: Create a database
	Create database Car_Accident
	Use Car_Accident


--Step 3: Answer to 8 questions as DEA


--Question 1: How many accidents have occurred in urban areas versus rural areas?
	
	SELECT	Area,
			COUNT(AccidentIndex) AS total_accident,
			round((COUNT(AccidentIndex) / (SELECT CAST(COUNT(AccidentIndex) AS FLOAT) FROM accident)),2) * 100 AS pct
	FROM accident
	GROUP BY Area;



--Question 2: Which day of the week has the highest number of accidents?
	
	SELECT	Day, 
			COUNT(AccidentIndex) as total_accident
	FROM accident
	GROUP BY Day
	ORDER BY total_accident desc



--Question 3: What is the average age of vehicles involved in accidents based on their type?
	
	SELECT	VehicleType, 
			COUNT(AccidentIndex) AS total_accident, 
			round(AVG(AgeVehicle),2) AS average_age
	FROM vehicle
	WHERE AgeVehicle IS NOT NULL
	GROUP BY VehicleType
	ORDER BY total_accident DESC;



--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
	
	SELECT	AgeGroup,
			COUNT(AccidentIndex) AS total_accident,
			round(AVG(AgeVehicle),2) AS average_year
	FROM (
		SELECT	AccidentIndex,
				AgeVehicle,
		CASE
			WHEN (AgeVehicle) BETWEEN 0 AND 5 THEN 'New'
			WHEN (AgeVehicle) BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
			END AS AgeGroup
		FROM vehicle
	) AS SubQuery
	GROUP BY AgeGroup;




--Question 5: Are there any specific weather conditions that contribute to severe accidents?
	
	SELECT	Severity,
			WeatherConditions,
			COUNT(Severity) AS total_accident
	FROM accident
	GROUP BY Severity, WeatherConditions
	ORDER BY Severity, total_accident DESC;





--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
	
	SELECT	LeftHand, 
			COUNT(AccidentIndex) AS total_accident,
			round((COUNT(AccidentIndex) / (SELECT CAST(COUNT(AccidentIndex) AS FLOAT) FROM vehicle)),2) * 100 AS pct
	FROM vehicle
	GROUP BY LeftHand
	HAVING LeftHand IS NOT NULL
	Order By 3 desc




--Question 7: Are there any relationships between journey purposes and the severity of accidents?
	
	SELECT	v.JourneyPurpose, 
			COUNT(a.Severity) AS total_accident,
		CASE 
			WHEN COUNT(a.Severity) BETWEEN 0 AND 1000 THEN 'Low'
			WHEN COUNT(a.Severity) BETWEEN 1001 AND 3000 THEN 'Moderate'
			ELSE 'High'
		END AS 'Level'
	FROM accident a
	JOIN vehicle v ON a.AccidentIndex = v.AccidentIndex
	Group by v.JourneyPurpose
	ORDER BY total_accident DESC;




--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
	
	DECLARE @Impact varchar(100)
	DECLARE @Light varchar(100)
	SET @Impact = 'Offside' --Did not impact, Nearside, Front, Offside, Back
	SET @Light = 'Darkness' --Daylight, Darkness

	SELECT	a.LightConditions, 
			v.PointImpact, 
			Round(AVG(v.AgeVehicle),2) AS average_year
	FROM accident a
	JOIN vehicle v ON a.AccidentIndex = v.AccidentIndex
	GROUP BY a.LightConditions, v.PointImpact 
	HAVING  v.PointImpact = @Impact AND a.LightConditions = @Light