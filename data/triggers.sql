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
