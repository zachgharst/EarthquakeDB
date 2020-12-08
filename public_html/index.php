<?php

$title = "Home";
$content = <<<CONTENT
            <h2>UMKC MostFunGroup</h2>
            <h3>Introduction</h3>
            <p>This project is an implementation of an earthquake database created as a team (named MostFunGroup) for COMP-SCI 470 at UMKC.
            COMP-SCI 470 is Introduction to Database Management Systems. We are examining the organization and relationships of earthquake data.</p>
            <p>Authors: Anna Johnson, Zach Gharst, Matt Miller, Ahmed Boukhousse </p>

            <h3>Earthquake DB</h3>
            <p>The database stores various information about earthquakes, such as the date/time, location, magnitude, and if it has created a tsunami.
            An earthquake causes damage, happens in a location, could belong to a cluster, and could affect an insurance policy.</p>
            <p>Our database allows a user to search earthquakes, clusters, and locations. A user may want to view insurance policies as affected by
            earthquakes in the policy area.</p>

            <h3>Team</h3>
            <ul>
                <li>Ahmed Boukhousse: <a href="https://github.com/AhmedBoukhousse">@AhmedBoukhousse</a></li>
                <li>Zach Gharst: <a href="https://github.com/ZDGharst">@ZDGharst</a></li>
                <li>Anna Johnson: <a href="https://github.com/johnsona9726">@johnsona9726</a></li>
                <li>Matt Miller: <a href="https://github.com/MattMiller1989">@MattMiller1989</a></li>
            </ul>

            <h3>Technology Used</h3>
            <p>HTML, CSS, PHP, MySQL across three layers of architecture (Presentation, API, Data). Thanks to the USGS Earthquake DB for their
            pre-existing data.</p>

            <h3>License</h3>
            <p>This project is licensed under the terms of the <a href="https://github.com/ZDGharst/CS470_MostFunGroup/blob/main/docs/LICENSE">MIT license</a>.</p>
CONTENT;
include('includes/template.php');

?>
