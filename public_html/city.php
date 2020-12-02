<?php

    require_once('includes/db-config.php');
    $title = "Search by City";
    
    if(isset($_GET[id])) {
        $id = $_GET[id];

        $getCityData = "SELECT name, latitude, longitude, country, population FROM city WHERE id = $id";
        $getCityData = mysqli_query($connection, $getCityData);
        $getCityData = mysqli_fetch_array($getCityData);


        if($getCityData) {
            $content .= "<h2>$getCityData[name]</h2>
            <ul>
                <li>Country: $getCityData[country]</li>
                <li>Population: $getCityData[population]</li>
                <li>Location: ($getCityData[latitude], $getCityData[longitude])</li>
            </ul>";
        }

        else {
            $content .= "<p>No such city found.</p>";
        }

/*      $query = "SELECT earthquake.id, mag, ST_Distance_Sphere(
            point(earthquake.longitude, earthquake.latitude),
            point(city.longitude, city.latitude )
        ) * .000621371192 AS distance  
        FROM earthquake INNER JOIN city ON city.id = $id
        WHERE mag > 5.0
        HAVING distance < 500
        ORDER BY distance;";

        $result = mysqli_query($connection, $query);
        $num_rows = mysqli_num_rows($result);

        $content .= "<h2></h2>";
        if($num_rows > 0) {
            $content .= "lol";
        }
        else {
            $content .= "<p>There are no earthquakes found in the city of </p>"
        }

        while ($row = mysqli_fetch_array($result)) {
            
            $content .= "EID: $row[id] | Mag: $row[mag] | Distance: $row[distance]";
            $content .= "<br>";
        } */
    }

    else if(isset($_GET[cityname]) && $_GET[cityname] != "") {
        $cityname = mysqli_real_escape_string($connection, $_GET[cityname]);



        if($content == "") {
            $content = "<p>There are no known earthquakes that have taken place in that city.</p>";
        }
    }

    else {
        $content = "<p>Please type in the name of a city in the top right portion of the website.</p>";
    }

    include('includes/template.php');
    ?>
