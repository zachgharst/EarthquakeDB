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

CREATE TABLE policy (
   id INT NOT NULL auto_increment,
   policy_name VARCHAR(50) NOT NULL,
    type_id INT NOT NULL,
   company_name VARCHAR(50),
   city_id INT NOT NULL,
 
   
   PRIMARY KEY(id),
   FOREIGN KEY (city_id) REFERENCES city(id),
   FOREIGN KEY (type_id) REFERENCES policy_type(id)
);

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
