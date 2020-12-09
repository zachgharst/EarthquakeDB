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
