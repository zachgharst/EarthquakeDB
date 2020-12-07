DROP PROCEDURE IF EXISTS GenerateRandomDamage;

DELIMITER $$

CREATE PROCEDURE GenerateRandomDamage(
	IN e_id INT
)

BEGIN
    DECLARE radius FLOAT DEFAULT 0;
    DECLARE populationInRadius INT DEFAULT 0;
    DECLARE economicDamage INT DEFAULT 0;
    DECLARE injuries INT DEFAULT 0;
    DECLARE fatalities INT DEFAULT 0;
    DECLARE magnitude FLOAT DEFAULT 0;
    DECLARE earthquakeLatitude FLOAT DEFAULT 0;
    DECLARE earthquakeLongitude FLOAT DEFAULT 0;

    SELECT mag, latitude, longitude
    INTO   magnitude, earthquakeLatitude, earthquakeLongitude
    FROM   earthquake
    WHERE  id = e_id;

    /* There is a 75% chance that there is no damage if an earthquake
     * has a magnitude of smaller than 5. */
    IF magnitude >= 5 || RAND() > 0.75 THEN
        /* Calculate the radius of the earthquake. */
        SET radius = 2 * magnitude * magnitude;

        /* Find the total population within the radius generated. Earthquakes in
         * areas with a lot of people means more injuries, bigger buildings, etc. */
        SELECT Sum(population)
        INTO   populationInRadius
        FROM   city
        WHERE  St_distance_sphere(Point(earthquakeLongitude, earthquakeLatitude), Point(
                    longitude, latitude)) * .000621371192 < radius;  

        IF(populationInRadius IS NULL) THEN
            SET populationInRadius = 0;
        END IF;

        IF populationInRadius != 0 THEN
            /* Generate the damage. 5^magnitude * Constant * Population Bias * Skew
            * Generate random number between 1 and 32 and pass through LOG().
            * This results in a left skewed dataset with a low of 0% (log1)
            * and a high of 150% (log32).
            * You can not combine the constants or you will get overflow/rounding problems. */
            SET economicDamage = POWER(5, magnitude) * 10    * populationInRadius / 1000000 * LOG(10, RAND()*31+1);
            SET injuries = POWER(5, magnitude)       / 1000  * populationInRadius / 1000000 * LOG(10, RAND()*31+1);
            SET fatalities = POWER(5, magnitude)     / 20000 * populationInRadius / 1000000 * LOG(10, RAND()*31+1);

            /* Return the values. */
            INSERT INTO damage (earthquake_id, costs, injuries, fatalities) VALUES (e_id, economicDamage, injuries, fatalities);
        END IF;
    END IF;
END$$

DELIMITER ;
		
DROP PROCEDURE IF EXISTS CalculatePremium;

DELIMITER $$

CREATE PROCEDURE CalculatePremium (p_id INT)

BEGIN
	DECLARE city_id INT DEFAULT 0;
	DECLARE count_damages INT DEFAULT 0;
	DECLARE citypricemod INT DEFAULT 0;
	DECLARE type_id INT DEFAULT 0;
	DECLARE typepricemod INT DEFAULT 0;
	DECLARE price FLOAT DEFAULT 0;
		
	SELECT cityid, typeid
	INTO city_id, type_id
	FROM policy
	WHERE p_id = policy.id;
	
	SELECT pricemodifier
	INTO typepricemod
	FROM type_policy
	WHERE type_id = typeid;
		
	SELECT count(*)
	INTO count_damages
	FROM damages JOIN earthquake ON earthquake_id = earthquake.id
	WHERE earthquake.cityid = city_id
	HAVING costs > 500;
	
	IF(count_damages > 3) THEN
		citypricemod = 2;
	IF(count_damages < 3) THEN 
		citypricemod = 1;
		
	prem = (500 * typepricemod * citypricemod);
	INSERT INTO policy (premium) VALUES (prem);
		
END$$
		
DELIMITER;

		
		
