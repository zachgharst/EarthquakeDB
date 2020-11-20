
-- Returns a list of the closest earthquakes to a given city
SELECT earthquake.id, mag, ST_Distance_Sphere(
    point(earthquake.longitude, earthquake.latitude),
    point(city.longitude, city.latitude )
) * .000621371192 AS distance  
FROM earthquake INNER JOIN city ON name = 'Miami' ORDER BY distance;

-- Returns a list of all the cities with population > X and distance <Y and magnitude >Z 
SELECT city.name, earthquake.id, earthquake.mag, ST_Distance_Sphere(
    point(earthquake.longitude, earthquake.latitude),
    point(city.longitude, city.latitude )
) * .000621371192 AS distance 
FROM earthquake, city 
WHERE mag > 5.5
AND population >100000
HAVING distance <2000.0
ORDER BY mag;
