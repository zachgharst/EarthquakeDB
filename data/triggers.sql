  
DROP TRIGGER IF EXISTS ProduceDamage; 

DELIMITER $$

CREATE TRIGGER ProduceDamage
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	CALL GenerateRandomDamage(NEW.id);
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
