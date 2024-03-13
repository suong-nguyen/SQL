use ghibli
-- show to test data
select* from Ghibli

---1. Gender distribuition
	SELECT gender, 
		   AVG(age) AS average_age,
		   (COUNT(*) * 100.0 / total.total_count) AS percentage
	FROM Ghibli
	CROSS JOIN (
		SELECT COUNT(*) AS total_count
		FROM Ghibli
	) AS total
	GROUP BY gender, total.total_count
	ORDER BY average_age DESC;

	select* from Ghibli

-- 2. Height
	--- top 3
	WITH ranked_heights AS (
		SELECT 
			character_name,
			[country _or_place_of_residence],
			height_cm,
			RANK() OVER (PARTITION BY [country _or_place_of_residence] ORDER BY height_cm DESC) AS height_rank
		FROM Ghibli
		WHERE height_cm > (SELECT AVG(height_cm) FROM ghibli)
	)

	SELECT TOP 3 character_name,[country _or_place_of_residence], height_cm
	FROM ranked_heights
	WHERE height_rank = 1
	ORDER BY height_cm DESC;

	-- individual
	SELECT character_name, 
		   height_cm AS Height,
		  RANK() OVER(ORDER BY height_cm DESC) AS height_rank
	FROM Ghibli
	ORDER BY 2 DESC;


-- 3. Power
	WITH SplitPowers AS (
		SELECT 
			character_name,
			LTRIM(RTRIM(power.value('.', 'VARCHAR(MAX)'))) AS power
		FROM 
			Ghibli
		CROSS APPLY (
			SELECT CAST('<power>' + REPLACE(REPLACE(special_powers, ' ', ''), ',', '</power><power>') + '</power>' AS XML) AS powers_xml
		) AS data
		CROSS APPLY 
			powers_xml.nodes('/power') AS powers(power)
		WHERE 
			special_powers IS NOT NULL
			AND special_powers <> 'None'
	)
	SELECT 
		power,
		COUNT(*) AS frequency
	FROM 
		SplitPowers
	GROUP BY 
		power
	ORDER BY 
		frequency DESC;

-- 4. Species
	SELECT species,
		   COUNT(*) AS total_number_of_characters,
		   (COUNT(*) * 100.0 / total.total_count) AS percentage
	FROM Ghibli
	CROSS JOIN (
		SELECT COUNT(*) AS total_count
		FROM Ghibli
	) AS total
	GROUP BY species, total_count
	ORDER BY 2 DESC;

-- 5. Time-traveling
	SELECT character_name, 
		   gh.movie,
		   height_cm,
		   release_date
	FROM Ghibli AS gh
	JOIN (
		 SELECT movie,
				AVG(height_cm) AS Average_height
		 FROM ghibli
		 GROUP BY movie
	) AS avg_ht ON gh.movie = avg_ht.movie
	WHERE release_date > '2000' AND gh.height_cm > avg_ht.Average_height;





