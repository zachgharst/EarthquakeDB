<?php

$title = "Earthquakes";
$content = <<<TABLE

        <table>
            <tr><th>Earthquake</th><th>Date</th><th>Time</th><th>City</th><th>Population</th><th>Magnitude</th><th>Damage</th><th>Fatalities</th></tr>

TABLE;

for($i = 1; $i < 51; $i++) {
    $content .= "            <tr><td>Earthquake $i</td><td>2020-10-20</td><td>12:17 PM</td><td>Kansas City</td><td>1,000,000</td><td>3.0</td><td>$";
    $content .= rand(0, 1000000);
    $content .= "</td><td>";
    $content .= rand(0, 100);
    $content .= "</td></tr>\n";
}

$content .= <<<TABLE2
            <tr><td colspan="8" class="last">50 rows returned.</td></tr>
        </table>

TABLE2;

include('includes/template.php');

?>