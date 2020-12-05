DROP TRIGGER IF EXISTS ProduceDamage; 

DELIMITER $$

CREATE TRIGGER ProduceDamage
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	CALL GenerateRandomDamage(NEW.id);
END $$
    
DELIMITER ;


CREATE TRIGGER CreateEarthquakeCity
BEFORE INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	DECLARE radius FLOAT DEFAULT 0.0;
   
    SET radius= 2 * NEW.mag * NEW.mag;
    
    INSERT INTO earthquake_city (earthquake_id, city_id)
    SELECT NEW.id, city.id
        FROM   city INNER JOIN earthquake ON city.id=NEW.id
        WHERE  St_distance_sphere(Point(NEW.longitude, NEW.latitude), Point(
                    city.longitude, city.latitude)) * .000621371192 < radius;  
   
    
    SET NEW.effected_population=populationInRadius;
END $$
    
DELIMITER ;
