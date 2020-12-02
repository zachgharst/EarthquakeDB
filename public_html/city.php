<?php

    require_once('includes/db-config.php');
    
    if(isset($_GET[cityname])) {
    
    $cityname = mysqli_real_escape_string($connection, $_GET[cityname]);

    $title = "Cities";
    $query = "SELECT earthquake.id, mag, ST_Distance_Sphere(
        point(earthquake.longitude, earthquake.latitude),
        point(city.longitude, city.latitude )
    ) * .000621371192 AS distance  
    FROM earthquake INNER JOIN city ON name = '$cityname' 
    WHERE mag > 5.0
    HAVING distance < 500
    ORDER BY distance;";

    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_array($result))
    {
            $content .= "EID: $row[id] | Mag: $row[mag] | Distance: $row[distance]";
            $content .= "<br>";
   }
   }
   else {
   $content = "Search please!";
   }

    include('includes/template.php');
    ?>
