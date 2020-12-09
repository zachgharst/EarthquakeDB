DROP TRIGGER IF EXISTS GenerateEarthquakeDataBefore; 

DELIMITER $$

CREATE TRIGGER GenerateEarthquakeDataBefore
BEFORE INSERT
ON `earthquake` FOR EACH ROW
BEGIN
    DECLARE affected_pop INT DEFAULT 0;
    CALL FindPopulation(NEW.id, NEW.mag, NEW.latitude, NEW.longitude, affected_pop); 
    SET NEW.affected_population = affected_pop;
END $$
    
DELIMITER ;



DROP TRIGGER IF EXISTS GenerateEarthquakeDataAfter; 

DELIMITER $$

CREATE TRIGGER GenerateEarthquakeDataAfter
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
    CALL CreateJunction(NEW.id);
    CALL FindCluster(NEW.id);
    CALL GenerateRandomDamage(NEW.id); 
END $$
    
DELIMITER ;