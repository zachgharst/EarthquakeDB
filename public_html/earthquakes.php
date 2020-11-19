<?php

require_once 'includes/db-config.php';

$title = "Earthquakes";
$content = <<<TABLE

        <table>
            <tr><th>Earthquake</th><th>Datetime</th><th>Latitude</th><th>Longitude</th><th>Magnitude</th></tr>

TABLE;


$query = "SELECT * FROM earthquake;";
$result = mysqli_query($connection, $query);
$row_count = mysqli_num_rows($result);

for($i = 0; $i < $row_count; $i++) {
    $row = mysqli_fetch_assoc($result);

    $content .= "            <tr><td>$row[id]</td><td>$row[time]</td><td>$row[latitude]</td><td>$row[longitude]</td><td>$row[mag]</td>";
}

$content .= <<<TABLE2
            <tr><td colspan="8" class="last">$row_count rows returned.</td></tr>
        </table>

TABLE2;

include('includes/template.php');

?>