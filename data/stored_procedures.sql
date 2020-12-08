/* Build a relationship between an earthquake and the cities it affects. */
DROP PROCEDURE IF EXISTS CreateJunction; 

DELIMITER $$

CREATE PROCEDURE CreateJunction(IN e_id INT)
BEGIN
	DECLARE radius FLOAT DEFAULT 0.0;
    DECLARE local_latitude FLOAT DEFAULT 0.0;
    DECLARE local_longitude FLOAT DEFAULT 0.0;
    
    SELECT 2 * mag * mag, latitude, longitude
    INTO   radius, local_latitude, local_longitude
    FROM   earthquake
    WHERE  id = e_id;

    INSERT INTO earthquake_city
    SELECT      e_id,city.id
    FROM        city
    WHERE       St_distance_sphere(Point(local_longitude, local_latitude), Point(
                    city.longitude, city.latitude)) * .000621371192 < radius;
    
END $$

DELIMITER ;


/* Find the population affected by an earthquake. */
DROP PROCEDURE IF EXISTS FindPopulation; 

DELIMITER $$

CREATE PROCEDURE FindPopulation(IN e_id INT, IN mag FLOAT, IN latitude FLOAT, IN longitude FLOAT, OUT populationInRadius FLOAT)
BEGIN
	DECLARE radius FLOAT DEFAULT 0.0;
    
    SET radius = 2 * mag * mag;
    
    SELECT Sum(population)
    INTO   populationInRadius
    FROM   city
    WHERE  St_distance_sphere(Point(longitude, latitude), Point(
                city.longitude, city.latitude)) * .000621371192 < radius;  
                    
    IF(populationInRadius IS NULL) THEN
        SET populationInRadius = 0;
	END IF;
END $$
    
DELIMITER ;


/* Find earthquakes that have commonalities with other earthquakes. */
DROP PROCEDURE IF EXISTS FindCluster; 

DELIMITER $$

CREATE PROCEDURE FindCluster(IN e_id INT)
BEGIN
    DECLARE radius FLOAT DEFAULT 10.0;
    DECLARE magnitude FLOAT DEFAULT 0.0;
    DECLARE local_latitude FLOAT DEFAULT 0.0;
    DECLARE local_longitude FLOAT DEFAULT 0.0;

    SELECT mag, latitude, longitude
    INTO   magnitude, local_latitude, local_longitude
    FROM   earthquake
    WHERE  id = e_id;

    IF magnitude > 5.0 THEN
        INSERT INTO cluster
        SELECT t1.cluster_id, e_id
        FROM
        (SELECT cluster_id,
        latitude,
        longitude,
        time,
        num_earthquakes
        FROM   (SELECT cluster_id,
                Min(earthquake_id) AS most_recent_earthquake,
                Count(*)           AS num_earthquakes
        FROM   cluster
        GROUP  BY cluster_id) AS first_eq_in_cluster
        JOIN earthquake
            ON most_recent_earthquake = id) t1
            WHERE  St_distance_sphere(Point(local_longitude, local_latitude), Point(
                    t1.longitude, t1.latitude)) * .000621371192 < radius;  
        
    END IF;
END $$
    
DELIMITER ;


/* Generate damage based on the size of the earthquake and where it happens. */
DROP PROCEDURE IF EXISTS GenerateRandomDamage;

DELIMITER $$

CREATE PROCEDURE GenerateRandomDamage(IN e_id INT)
BEGIN
    DECLARE radius FLOAT DEFAULT 0;
    DECLARE economicDamage INT DEFAULT 0;
    DECLARE injuries INT DEFAULT 0;
    DECLARE fatalities INT DEFAULT 0;
    DECLARE magnitude FLOAT DEFAULT 0;
    DECLARE population INT DEFAULT 0;

    SELECT mag, affected_population
    INTO   magnitude, population
    FROM   earthquake
    WHERE  id = e_id;

    /* There is a 75% chance that there is no damage if an earthquake
     * has a magnitude of smaller than 5. */
    IF magnitude >= 5 || RAND() > 0.75 THEN
        


        IF population != 0 THEN
            /* Generate the damage. 5^magnitude * Constant * Population Bias * Skew
            * Generate random number between 1 and 32 and pass through LOG().
            * This results in a left skewed dataset with a low of 0% (log1)
            * and a high of 150% (log32).
            * You can not combine the constants or you will get overflow/rounding problems. */
            SET economicDamage = POWER(5, magnitude) * 10    * population / 1000000 * LOG(10, RAND()*31+1);
            SET injuries = POWER(5, magnitude)       / 1000  * population / 1000000 * LOG(10, RAND()*31+1);
            SET fatalities = POWER(5, magnitude)     / 20000 * population / 1000000 * LOG(10, RAND()*31+1);

            /* Return the values. */
            INSERT INTO damage (earthquake_id, costs, injuries, fatalities)
            VALUES      (e_id, economicDamage, injuries, fatalities);
        END IF;
    END IF;
END$$

DELIMITER ;


/* Calculate the premium of a policy based on the city and type of policy. */
DROP PROCEDURE IF EXISTS CalculatePremium;

DELIMITER $$

CREATE PROCEDURE CalculatePremium (IN p_id INT)
BEGIN
    DECLARE local_city_id INT DEFAULT 0;
    DECLARE count_damages INT DEFAULT 0;
    DECLARE citypricemod INT DEFAULT 0;
    DECLARE typepricemod FLOAT DEFAULT 0;
    DECLARE prem FLOAT DEFAULT 0;
        
    SELECT city_id, price_modifier
    INTO local_city_id, typepricemod
    FROM policy
    JOIN policy_type ON type_id = policy_type.id
    WHERE policy.id = p_id;
        
    SELECT count(*)
    INTO count_damages
    FROM damage
    JOIN earthquake_city ON damage.earthquake_id = earthquake_city.earthquake_id
    WHERE costs > 500 AND earthquake_city.city_id = local_city_id;

    IF(count_damages > 3) THEN
        SET citypricemod = 2;
    END IF;

    IF(count_damages < 3) THEN 
        SET citypricemod = 1;
    END IF;

    SET prem = (500 * typepricemod * citypricemod);

    UPDATE policy
    SET premium = prem
    WHERE id = p_id;
END$$

DELIMITER ;