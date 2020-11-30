<?php

    require_once('includes/db-config.php');

    $title = "Cities";
    $query = "SELECT earthquake.id, mag, ST_Distance_Sphere(
        point(earthquake.longitude, earthquake.latitude),
        point(city.longitude, city.latitude )
    ) * .000621371192 AS distance  
    FROM earthquake INNER JOIN city ON name = '$_GET[cityname]' 
    WHERE mag > 5.0
    HAVING distance < 500
    ORDER BY distance;";

    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_array($result))
    {
            $content .= "EID: $row[id] | Mag: $row[mag] | Distance: $row[distance]";
            $content .= "<br>";
   }

    include('includes/template.php');
    ?>