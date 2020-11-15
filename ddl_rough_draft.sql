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

USE earthquake_data;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/eqdata.csv'
INTO TABLE earthquake
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


SELECT * FROM earthquake;
