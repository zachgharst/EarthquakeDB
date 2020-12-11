/* This file contains the SQL to create the database from scratch. You will need to modify the GRANT
   privileges line to include your username/host (if not using root), and you will also need to modify
   the location of the files for the earthquake and city CSVs AFTER loading procedures/triggers. */

CREATE DATABASE earthquake_data;
GRANT ALL PRIVILEGES ON earthquake_data.* TO 'username'@'localhost';
USE earthquake_data;

CREATE TABLE earthquake (
    id                  INT NOT NULL auto_increment,
    time                DATETIME NOT NULL,
    latitude            FLOAT,
    longitude           FLOAT,
    mag                 FLOAT,
    affected_population INT,

    PRIMARY KEY(id)
);

CREATE INDEX index_earthquake
ON earthquake (mag, affected_population);

CREATE TABLE damage (
    earthquake_id INT NOT NULL,
    costs         INT unsigned DEFAULT NULL,
    injuries      INT unsigned DEFAULT NULL,
    fatalities    INT unsigned DEFAULT NULL,
    tsunami       BOOLEAN DEFAULT NULL,

    FOREIGN KEY(earthquake_id) REFERENCES earthquake(id)
);

CREATE TABLE city (
    id         INT NOT NULL auto_increment,
    name       VARCHAR(50) NOT NULL,
    latitude   FLOAT,
    longitude  FLOAT,
    country    VARCHAR(50),
    population INT DEFAULT NULL,

    PRIMARY KEY(id)
);

CREATE TABLE earthquake_city (
	earthquake_id INT NOT NULL,
    city_id       INT NOT NULL,

    FOREIGN KEY(earthquake_id) REFERENCES earthquake(id),
    FOREIGN KEY(city_id)       REFERENCES city(id)
);

CREATE TABLE policy (
   id           INT NOT NULL auto_increment,
   policy_name  VARCHAR(50) NOT NULL,
   company_name VARCHAR(50) NOT NULL,
   premium      FLOAT DEFAULT NULL,
   type_id      INT NOT NULL,
   city_id      INT NOT NULL,
 
   PRIMARY KEY(id),
   FOREIGN KEY(city_id) REFERENCES city(id),
   FOREIGN KEY(type_id) REFERENCES policy_type(id)
);

CREATE TABLE policy_type (
   id INT NOT NULL auto_increment,
   type_name VARCHAR(50),
   price_modifier FLOAT NOT NULL,
   
   PRIMARY KEY(id)
);

/* BEFORE ANY DATA CAN BE LOADED, THE STORED PROCEDURES AND TRIGGERS SHOULD BE CREATED. */

-- Matt
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(time, latitude, longitude, mag);

/* Zach
LOAD DATA LOCAL INFILE '/var/lib/mysql/cs470_earthquakes/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(time, latitude, longitude, mag); */

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/worldcities2.csv'
INTO TABLE city
-- CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

INSERT INTO `policy`
(policy_name, companyname, type_id, city_id)
VALUES
('Grade A', 'Blue Sky', 1, 1),
('Quartz', 'State Farm', 1, 1),
('Ruby', 'State Farm', 2, 1),
('Emerald', 'State Farm', 3, 1), 
('Grade A', 'Blue Sky', 1, 2),
('Grade B', 'Blue Sky', 2, 2),
('Grade C', 'Blue Sky', 3, 2),
('Basic', 'Travelers', 1, 2),
('Bronze', 'Insurify', 1, 3337),
('Plus', 'Insurify', 2, 3337),
('Prime', 'Travelers', 3, 3337),
('Grade A', 'Blue Sky', 1, 28),
('Grade B', 'Blue Sky', 2, 28),
('Platinum', 'Insurify', 5, 28),
('Plus', 'Travelers', 3, 28),
('Sapphire', 'State Farm', 4, 28),
('Diamond', 'State Farm', 5, 28),
('Sapphire', 'State Farm', 4, 207),
('Basic', 'Travelers', 1, 207),
('Prime', 'Travelers', 5, 207),
('Gold', 'Insurify', 4, 109),
('Ruby', 'State Farm', 2, 109),
('Emerald', 'State Farm', 3, 109);

INSERT INTO `policy_type`
(type_name, price_modifier)
VALUES
('Personal Property Coverage', 1.5),
('Additional Living Expenses (ALE)', 2),
('Dwelling Coverage', 3),
('Bundle Dwelling + ALE', 5),
('Bundle All', 7);

/**Ahmed*/
/* Junction table */
CREATE TABLE policies_in_cities
(
    policyID int NOT NULL,
    cityID int NOT NULL,
    CONSTRAINT PK_policies_in_cities PRIMARY KEY
    (
        policyID,
        cityID
    ),
    FOREIGN KEY (policyID) REFERENCES policy(id),
    FOREIGN KEY (cityID) REFERENCES city(id)
);

/*ALTER TABLE policy DROP FOREIGN KEY policy_ibfk_1;*/
ALTER TABLE policy DROP FOREIGN KEY city_id;
INSERT INTO policies_in_cities (policyID, cityID)
SELECT city.id as city_id, policy.id as policy_id 
FROM city CROSS JOIN policy 
WHERE city.population BETWEEN 1 AND 100000000;
