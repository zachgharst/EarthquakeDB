  
DROP TRIGGER IF EXISTS ProduceDamage; 

DELIMITER $$

CREATE TRIGGER ProduceDamage
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	CALL GenerateRandomDamage(NEW.id);
END $$
    
DELIMITER ;




DROP TRIGGER IF EXISTS CreateJunction; 

DELIMITER $$

CREATE TRIGGER CreateJunction
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN

	DECLARE radius FLOAT DEFAULT 0.0;
  DECLARE populationInRadius FLOAT DEFAULT 0;
    
    SET radius= 2 * NEW.mag * NEW.mag;

	   INSERT INTO earthquake_city
     SELECT NEW.id,city.id
		    FROM   city
        WHERE  St_distance_sphere(Point(NEW.longitude, NEW.latitude), Point(
                    city.longitude, city.latitude)) * .000621371192 < radius;
    
    
END $$
    
    DELIMITER ;


DROP TRIGGER IF EXISTS FindPopulation; 

DELIMITER $$

CREATE TRIGGER FindPopulation
BEFORE INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	DECLARE radius FLOAT DEFAULT 0.0;
    DECLARE populationInRadius FLOAT DEFAULT 0;
    
    SET radius= 2 * NEW.mag * NEW.mag;
    
    SELECT Sum(population)
        INTO   populationInRadius
        FROM   city
        WHERE  St_distance_sphere(Point(NEW.longitude, NEW.latitude), Point(
                    city.longitude, city.latitude)) * .000621371192 < radius;  
                    
    IF(populationInRadius IS NULL) THEN
            SET populationInRadius = 0;
	END IF;
    SET NEW.effected_population=populationInRadius;
    
    
END $$
    
DELIMITER ;
		
  
DROP TRIGGER IF EXISTS FindCluster; 

DELIMITER $$

CREATE TRIGGER FindCluster
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
    DECLARE radius FLOAT DEFAULT 0.0;
    DECLARE magnitude FLOAT DEFAULT 0.0;
    
    SET radius= 10.0;
    SET magnitude= NEW.mag;
    
    IF magnitude > 5.0 THEN
		INSERT INTO cluster
		SELECT t1.cluster_id, NEW.id
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
         WHERE  St_distance_sphere(Point(NEW.longitude, NEW.latitude), Point(
                    t1.longitude, t1.latitude)) * .000621371192 < radius;  
       
   END IF;
END $$
    
DELIMITER ;

