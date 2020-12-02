<?php

    require_once('includes/db-config.php');
    $title = "Search by City";
    
    if(isset($_GET[id])) {
        $id = $_GET[id];

        $content = "<p>Get content for the city with the ID of: " . $id . "</p>";
    }

    else if(isset($_GET[cityname]) && $_GET[cityname] != "") {
        $cityname = mysqli_real_escape_string($connection, $_GET[cityname]);

        $query = "SELECT earthquake.id, mag, ST_Distance_Sphere(
            point(earthquake.longitude, earthquake.latitude),
            point(city.longitude, city.latitude )
        ) * .000621371192 AS distance  
        FROM earthquake INNER JOIN city ON name = '$cityname' 
        WHERE mag > 5.0
        HAVING distance < 500
        ORDER BY distance;";

        $result = mysqli_query($connection, $query);

        while ($row = mysqli_fetch_array($result)) {
            $content .= "EID: $row[id] | Mag: $row[mag] | Distance: $row[distance]";
            $content .= "<br>";
        }

        if($content == "") {
            $content = "<p>There are no known earthquakes that have taken place in that city.</p>";
        }
    }

    else {
        $content = "<p>Please type in the name of a city in the top right portion of the website.</p>";
    }

    include('includes/template.php');
    ?>
