<?php

$title = "Search";
$content = <<<SEARCH
            <form method="get" action="earthquakes.php"><fieldset><h2>Advanced Search</h2>
                <label for="magnitude">Magnitude</label>
                <select name="mag_direction">
                    <option value="gt">&gt;=</option>
                    <option value="lt">&lt;=</option>
                    <option value="eq">=</option>
                </select>
                <input id="magnitude" name="mag" type="number" value="0"><br>

                <!-- <label>Longitude</label>
                <input type="text"><br>

                <label>Latitude</label>
                <input type="text"><br><br> -->

                <label for="injuries">Injuries</label>
                <select name="injuries_direction">
                    <option value="gt">&gt;=</option>
                    <option value="lt">&lt;=</option>
                    <option value="eq">=</option>
                </select>
                <input id="injuries" name="injuries" type="number" value="0"><br>

                <label for="fatalities">Fatalities</label>
                <select name="fatalities_direction">
                    <option value="gt">&gt;=</option>
                    <option value="lt">&lt;=</option>
                    <option value="eq">=</option>
                </select>
                <input id="fatalities" name="fatalities" type="number" value="0"><br>

                <!-- <label for="datemax">Search for dates between </label>
                <input type="date"><br><br>
                <label for="datemin">And</label>
                <input type="date" > <br>

                <label>Apart of Cluster?</label>
                <input type="checkbox"> <br>

                <label>Tsunami risk?</label>
                <input type="checkbox"><br> -->

                <label for="sort">Sort by</label>
                <select id="sort" name="sort">
                    <option value="time">Date</option>
                    <option value="latitude">Latitude</option>
                    <option value="longitude">Longitude</option>
                    <option value="mag">Magnitude</option>
                    <option value="costs">Economic Cost</option>
                    <option value="injuries">Injuries</option>
                    <option value="fatalities">Fatalities</option>
                </select>
                <select name="order">
                    <option value="asc">Asc</option>
                    <option value="desc">Desc</option>
                </select>
                <br>

                <input type="submit" value="Search">
            </fieldset></form>
SEARCH;

include('includes/template.php');

?>