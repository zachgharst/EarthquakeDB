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
    effected_population INT,

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
   companyname VARCHAR(50) NOT NULL,
   premium FLOAT DEFAULT NULL,
    type_id INT NOT NULL,
   city_id INT NOT NULL,
 
   
   PRIMARY KEY(id),
   FOREIGN KEY (city_id) REFERENCES city(id),
   FOREIGN KEY (type_id) REFERENCES policy_type(typeId)
);

/* inserting data into polciy*/

INSERT INTO `policy`
VALUES (1, 'Grade A', 'Blue Sky', 0, 1, 1), (2, 'Quartz', 'State Farm', 0, 1, 1), (3, 'Ruby', 'State Farm', 0, 2, 1), (4, 'Emerald', 'State Farm', 0, 3, 1), 
(5, 'Grade A', 'Blue Sky', 1, 2), (6, 'Grade B', 'Blue Sky', 0, 2, 2), (7, 'Grade C', 'Blue Sky', 0, 3, 2), (8, 'Basic', 'Travelers', 0, 1, 2), (9, 'Bronze', 'Insurify', 0, 1, 3),
(10, 'Plus', 'Insurify', 0, 2, 3), (11, 'Prime', 'Travelers', 0, 3, 3), (12, 'Grade A', 'Blue Sky', 0, 1, 4), (13, 'Grade B', 'Blue Sky', 0, 2, 4), (14, 'Platinum', 'Insurify', 0, 5, 4),
(15, 'Plus', 'Travelers', 0, 3, 4), (16, 'Sapphire', 'State Farm', 0, 4, 4), (17, 'Diamond', 'State Farm', 0, 5, 4), (18, 'Sapphire', 'State Farm', 0, 4, 5), (19, 'Basic', 'Travelers', 0, 1, 5),
(20, 'Prime', 'Travelers', 0, 5, 5), (21, 'Gold', 'Insurify', 0, 4, 6), (22, 'Ruby', 'State Farm', 0, 2, 6), (23, 'Emerald', 'State Farm', 0, 3, 6);

CREATE TABLE policy_type (
   id INT NOT NULL auto_increment,
   type_name VARCHAR(50),
   price_modifier FLOAT NOT NULL,
   
   PRIMARY KEY(id)
);

INSERT INTO `policy_type`
VALUES (1, 'Personal Property Coverage', 1.5), (2, 'Additional Living Expenses (ALE)', 2), (3, 'Dwelling Coverage', 3), (4, 'Bundle Dwelling + ALE', 5), (5, 'Bundle All', 7);
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
