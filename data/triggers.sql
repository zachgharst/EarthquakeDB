DROP TRIGGER IF EXISTS ProduceDamage; 

DELIMITER $$

CREATE TRIGGER ProduceDamage
AFTER INSERT
ON `earthquake` FOR EACH ROW
BEGIN
	CALL GenerateRandomDamage(
		NEW.id,
		NEW.mag,
		NEW.latitude,
		NEW.longitude
	);
END $$

    
DELIMITER ;
