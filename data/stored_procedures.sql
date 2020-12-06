DROP PROCEDURE IF EXISTS GenerateRandomDamage;

DELIMITER $$

CREATE PROCEDURE GenerateRandomDamage(
	IN e_id INT
)

BEGIN
    DECLARE radius FLOAT DEFAULT 0;
    DECLARE economicDamage INT DEFAULT 0;
    DECLARE injuries INT DEFAULT 0;
    DECLARE fatalities INT DEFAULT 0;
    DECLARE magnitude FLOAT DEFAULT 0;
    DECLARE population INT DEFAULT 0;

    SELECT mag, effected_population
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
            INSERT INTO damage (earthquake_id, costs, injuries, fatalities) VALUES (e_id, economicDamage, injuries, fatalities);
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER ;
