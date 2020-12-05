/* This file contains the SQL to create the database from scratch. You will need to modify the GRANT
   privileges line to include your username/host (if not using root), and you will also need to modify
   the location of the files for the earthquake and city CSVs AFTER loading procedures/triggers. */

CREATE DATABASE earthquake_data;
GRANT ALL PRIVILEGES ON earthquake_data.* TO 'username'@'localhost';
USE earthquake_data;

CREATE TABLE earthquake (
    id        INT NOT NULL auto_increment,
    time      DATETIME NOT NULL,
    latitude  FLOAT,
    longitude FLOAT,
    mag       FLOAT,

    PRIMARY KEY(id)
);

CREATE TABLE damage (
    earthquake_id INT NOT NULL,
    costs INT unsigned DEFAULT NULL,
    injuries INT unsigned DEFAULT NULL,
    fatalities INT unsigned DEFAULT NULL,
    tsunami BOOLEAN DEFAULT NULL,

    FOREIGN KEY (earthquake_id) REFERENCES earthquake(id)
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

CREATE TABLE earthquake_city(
	earthquake_id INT NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY(earthquake_id) REFERENCES earthquake(id),
    FOREIGN KEY(city_id) REFERENCES city(id)
);

CREATE TABLE policy (
   id INT NOT NULL auto_increment,
   policy_name VARCHAR(50) NOT NULL,
    type_id INT NOT NULL,
   company_name VARCHAR(50),
   city_id INT NOT NULL,
 
   
   PRIMARY KEY(id),
   FOREIGN KEY (city_id) REFERENCES city(id),
   FOREIGN KEY (type_id) REFERENCES policy_type(typeId)
);

/* inserting data into polciy*/

INSERT INTO `policy`
VALUES (1, 'GradeA',1, 'BlueSky', 2), (2, 'GradeB', 3,'Travelers', 1),(3, 'Grade C', 2,'Hippo', 1),(4, 'Grade A',9, 'Insurify', 3),(5, 'Grade B', 8,'Hippo', 4),(6, 'Grade C',5, 'Blue Sky', 5),
(7, 'Grade C', 8,'Travelers', 6),(8, 'Grade B',6, 'Travelers', 7),(9, 'Grade A',4,'Hippo', 8),(10, 'Grade B',5, 'Hippo', 8),(11,'Grade B', 3,'Blue Sky', 9),
(12, 'Grade C', 6,'Hippo', 10),(13,'Grade A',4, 'Blue Sky', 11),(14, 'Grade B',8, 'Hippo', 12),(15, 'Grade C',7, 'Travelers', 13),(16,'Grade A', 7,'Hippo', 14)
,(17, 'Grade A',5, 'Blue Sky', 15),(18, 'Grade C', 8,'Hippo', 16),(19, 'Grade B', 9, 'Blue Sky', 17),(20, 'Grade A', 10,'Hippo', 18),(21,'Grade B',10,'Travelers', 19)
,(22,'Grade A',6, 'Travelers', 20),(23,'Grade C', 5,'Hippo', 22),(24,'Grade A',5, 'Travelers', 23),(25, 'Grade B',4,'Blue Sky',24),
(26, 'Grade A', 7,'Travelers', 24),(27, 'Grade C', 7,'Blue Sky', 25),(28, 'Grade D', 10,'Smart Financial', 26),(29, 'Grade D', 7,'Smart Financial', 27),(30,'Grade B', 9, 'Smart Financial', 28),
(31, 'Grade D', 3,'Blue Sky', 29),(32, 'Grade D', 2,'Hippo', 30),(33, 'Grade C',2, 'Travelers', 31),(34, 'Grade D',3, 'Blue Sky', 32),(35,'Grade D', 3,'Smart Financial', 33),
(36, 'Grade C', 4,'Smart Financial', 34),(37, 'Grade C',1, 'Hippo', 35),(38, 'Grade D', 2,'Travelers', 36),(39, 'Grade C', 2,'Blue Sky', 37)
,(40, 'Grade D', 1, 'Blue Sky', 38),(41, 'Grade D', 1,'Smart Financial', 39);

CREATE TABLE policy_type (
   id INT NOT NULL auto_increment,
   type_name VARCHAR(50),
   price_modifier FLOAT DEFAULT NULL,
   
   PRIMARY KEY(id)
);

INSERT INTO `policy_type`
VALUES (1,'Prime',0.5), (2, 'FullCoverage', 1.0), (3, 'Basic', 0.1), (4, 'Prime', 0.7), (5, 'Basic', 0.3), (6, 'Prime', 0.8), (7, 'FullCoverage', 1.5), 
(8, 'Prime', 0.9), (9, 'Basic', 0.4), (10, 'Prime', 1.3);
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
