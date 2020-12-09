/* This file contains the queries used on the website. Any value with a 
 * dollar sign (such as $this) is a variable used in PHP. */

/***********************************************
  Earthquakes : earthquakes.php
 **********************************************/

/* The general view for the earthquake table uses variables through the URL 
 * to filter the results from the database. This is the general query used to return
 * the total number of rows.
 * The WHERE clause takes each filterable column, adds a direction (less than, greather
 * than, or equals) and a value. */
SELECT DATE_FORMAT(time, '%M %e, %Y') as formattedDate,
    TIME(time) as formattedTime,
    latitude,
    longitude,
    mag,
    affected_population,
    costs,
    injuries,
    fatalities
    FROM  earthquake LEFT JOIN damage ON id = earthquake_id WHERE 
        mag $mag_direction $mag AND
        (affected_population $affectedpopulation_direction $affected_population) AND
        (injuries $injuries_direction $injuries) AND
        (fatalities $fatalities_direction $fatalities)
        $cluster;

/* This is the query used to actually populate data on the table. It is exactly the 
 * same as the query above, however, it sorts, limits, and offsets based on the page
 * of the results the user is on. */
SELECT DATE_FORMAT(time, '%M %e, %Y') as formattedDate,
    TIME(time) as formattedTime,
    latitude,
    longitude,
    mag,
    affected_population,
    costs,
    injuries,
    fatalities
    FROM  earthquake LEFT JOIN damage ON id = earthquake_id WHERE 
        mag $mag_direction $mag AND
        (affected_population $affectedpopulation_direction $affected_population) AND
        (injuries $injuries_direction $injuries) AND
        (fatalities $fatalities_direction $fatalities)
        $cluster
    ORDER BY $sort $order LIMIT $offset, 200;

/***********************************************
  Clusters : clusters.php
 **********************************************/

/* This query is used to return the cluster as well as the oldest earthquake that
 * belongs to that cluster in order to add some context to the cluster. In the
 * future, this query could be improved by instead filtering by the oldest
 * DATETIME stamp rather than the smallest ID. */
SELECT cluster_id,
    Date_format(time, '%M %e, %Y') AS formattedDate,
    Time(time)                     AS formattedTime,
    latitude,
    longitude,
    mag,
    num_earthquakes
FROM   (SELECT cluster_id,
            Min(earthquake_id) AS most_recent_earthquake,
            Count(*)           AS num_earthquakes
     FROM   cluster
     GROUP  BY cluster_id) AS first_eq_in_cluster
    JOIN earthquake
      ON most_recent_earthquake = id ORDER BY num_earthquakes DESC;

/***********************************************
  Cities : city.php
 **********************************************/

/* This query is the default view of the page without any variables set. It's used to 
 * count all cities in the database for pagination purposes. */
SELECT id, name, latitude, longitude, country, population FROM city ORDER BY population DESC;

/* This is the same query as above, but it considers the pagination (offset & limit). */
SELECT id, name, latitude, longitude, country, population FROM city ORDER BY population DESC  LIMIT $offset, 200;

/* This query is used when the user searches for a city by city name. */
SELECT id, name, latitude, longitude, country, population FROM city WHERE name LIKE '%$cityName%' ORDER BY population DESC;

/* This query is used once a city has been selected to display city information; the
 * only variable needed is the ID. Part 1 of 3 of the Single City Display. */
SELECT name, latitude, longitude, country, population FROM city WHERE id = $id;

/* Once a city has been found, we gather information about the earthquakes that have
 * happened within 50 miles. We also state, as a business constraint, one year.
 * Part 2 of 3 of the Single City Display. */
SELECT DATE_FORMAT(time, '%M %e, %Y') as time1, TIME(time) as time2, mag, earthquake.latitude, earthquake.longitude, ST_Distance_Sphere(
                point(earthquake.longitude, earthquake.latitude),
                point(city.longitude, city.latitude )
            ) * .000621371192 AS distance  
            FROM earthquake INNER JOIN city ON city.id = $id
            HAVING distance < 50
            ORDER BY distance;

/* The last part of the Single City Display is listing out the insurance policies that are
 * available in that city. */
SELECT id, policy_name, companyname FROM policy WHERE city_id = $id;

/***********************************************
  Insurance Policies : policies.php
 **********************************************/

/* The insurance policy view is quite self explanatory. We want to know the policy name,
 * ID, and the city it belongs to (via a join). */
SELECT policy_name as p_name, policy.id as p_id , city.name as c_name
    FROM policy inner join city
    on policy.city_id = city.id;
