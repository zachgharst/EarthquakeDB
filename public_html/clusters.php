<?php

    require_once('includes/db-config.php');

    $clustersData = "SELECT cluster_id,
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
      ON most_recent_earthquake = id ORDER BY num_earthquakes DESC";
    $clustersData = mysqli_query($connection, $clustersData);
    $numClusters = mysqli_num_rows($clustersData);

    $title = "Clusters";    
    $content = <<<TABLE
        <table class="right">
            <tr><th class="left">Start Date</th><th>Start Time</th><th>Source Location</th><th>Beginning Magnitude</th><th># of EQs</th></tr>
TABLE;

    while($row = mysqli_fetch_assoc($clustersData)) {
        $content .= "<tr><td class=\"left\"><a href=\"earthquakes.php?cluster=$row[cluster_id]\">$row[formattedDate]</a></td><td>$row[formattedTime]</td><td><a href=\"https://maps.google.com/maps?z=10&q=$row[latitude]+$row[longitude]\">($row[latitude], $row[longitude])</a></td><td>$row[mag]</td><td>$row[num_earthquakes]</td></tr>";
    }

    $content .= <<<TABLE2
            <tr><td colspan="9" class="last">$numClusters clusters found.</td></tr>
        </table>
TABLE2;

    include('includes/template.php');
    ?>
