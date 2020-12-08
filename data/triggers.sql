DROP TRIGGER IF EXISTS GenerateEarthquakeData; 

DELIMITER $$

CREATE TRIGGER GenerateEarthquakeData
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
    CALL CreateJunction(NEW.id);
    CALL FindPopulation(NEW.id);
    CALL FindCluster(NEW.id);
    CALL GenerateRandomDamage(NEW.id);
END $$
    
DELIMITER ;