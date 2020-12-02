<?php

    require_once('includes/db-config.php');
    $title = "Search by City";
    
    if(isset($_GET[id])) {
        $id = mysqli_real_escape_string($connection, $_GET[id]);

        $cityData = "SELECT name, latitude, longitude, country, population FROM city WHERE id = $id";
        $cityData = mysqli_query($connection, $cityData);
        $cityData = mysqli_fetch_array($cityData);


        if($cityData) {
            $EQData = "SELECT DATE_FORMAT(DATE(time), '%M %e, %Y') as time1, TIME(time) as time2, mag, earthquake.latitude, earthquake.longitude, ST_Distance_Sphere(
                point(earthquake.longitude, earthquake.latitude),
                point(city.longitude, city.latitude )
            ) * .000621371192 AS distance  
            FROM earthquake INNER JOIN city ON city.id = $id
            HAVING distance < 50
            ORDER BY distance;";
            $EQData = mysqli_query($connection, $EQData);
            $numEQ = mysqli_num_rows($EQData);


            $content .= "<h2>$cityData[name]</h2>
            <ul>
                <li>Country: $cityData[country]</li>
                <li>Population: $cityData[population]</li>
                <li>Location: ($cityData[latitude], $cityData[longitude])</li>
                <li>Number of Nearby Earthquakes This Year: $numEQ</li>
            </ul>";

            if($numEQ > 0) {
                $content .= "<table><th>Date</th><th>Time</th><th>Latitude</th><th>Longitude</th><th>Magnitude</th><th>Miles from City Center</th>";
                while($row = mysqli_fetch_array($EQData)) {
                    $row[distance] = round($row[distance], 1);
                    $content .= "<tr class=\"right\"><td class=\"left\">$row[time1]</td><td>$row[time2]</td><td>$row[mag]</td><td>$row[latitude]</td><td>$row[longitude]</td><td>$row[distance]</td></tr>";
                }
                $content .= "</table>";
            }
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
