USE earthquake_data;

CREATE TABLE earthquake(
id INT NOT NULL AUTO_INCREMENT,
time DATETIME NOT NULL,
latitude FLOAT,
longitude FLOAT,
PRIMARY KEY(id)
);

ALTER TABLE earthquake
	ADD mag float;

-- Matt: 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/eqdata.csv'
-- Zach: '/var/lib/mysql/cs470_earthquakes/eqdata.csv'
USE earthquake_data;
LOAD DATA LOCAL INFILE '/var/lib/mysql/cs470_earthquakes/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(time, latitude, longitude, mag);

CREATE TABLE city(
id INT NOT NULL AUTO_INCREMENT,
name varchar(50) NOT NULL,
latitude FLOAT,
longitude FLOAT,
country varchar(50),
population INT DEFAULT NULL,
PRIMARY KEY(id)
);

DROP TABLE city;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/worldcities2.csv'
INTO TABLE city
-- CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * FROM city
WHERE population >1000000
AND country='United States';

-- SELECT id, name, SQRT((latitude - 40.69) + (longitude + 73.92)) as distance FROM city ORDER BY distance;

SELECT id, name, SQRT((latitude - 40.69)*(latitude - 40.69) + (longitude + 73.92)*(longitude + 73.92)) as distance FROM city ORDER BY distance;

SELECT id, mag, SQRT((latitude - 40.69)*(latitude - 40.69) + (longitude + 73.92)*(longitude + 73.92)) as distance FROM earthquake ORDER BY distance;

(SELECT latitude AS targ_lat, longitude AS targ_long FROM city
WHERE name='Istanbul')

(SELECT id, mag, SQRT((latitude - targ_lat)*(latitude - targ_lat) + (longitude + targ_long)*(longitude + targ_long))
as distance FROM earthquake ORDER BY distance);


SELECT earthquake.id, mag, SQRT((earthquake.latitude - city.latitude)*(earthquake.latitude - city.latitude) + (earthquake.longitude - city.longitude)*(earthquake.longitude - city.longitude)) as distance FROM earthquake 
INNER JOIN city ON name = 'New York' ORDER BY distance;
