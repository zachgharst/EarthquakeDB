USE earthquake_data;

CREATE TABLE earthquake(
id INT NOT NULL AUTO_INCREMENT,
time DATETIME NOT NULL,
latitude FLOAT,
longitude FLOAT,
mag FLOAT,
PRIMARY KEY(id)
);

-- Matt
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(time, latitude, longitude, mag);

-- Zach
/* LOAD DATA LOCAL INFILE '/var/lib/mysql/cs470_earthquakes/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(time, latitude, longitude, mag); */

CREATE TABLE city(
id INT NOT NULL AUTO_INCREMENT,
name varchar(50) NOT NULL,
latitude FLOAT,
longitude FLOAT,
country varchar(50),
population INT DEFAULT NULL,
PRIMARY KEY(id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/worldcities2.csv'
INTO TABLE city
-- CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE damage (
	earthquake_id INT NOT NULL,
	costs INT unsigned DEFAULT NULL,
	injuries INT unsigned DEFAULT NULL,
	fatalities INT unsigned DEFAULT NULL,
	tsunami BOOLEAN DEFAULT NULL,
	FOREIGN KEY (earthquake_id) REFERENCES earthquake(id)
);