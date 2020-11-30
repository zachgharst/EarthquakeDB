<?php

    require_once('includes/db-config.php');

    $title = "Policy";
    $query = "SELECT policy.name, policy.id, policy.cityId
    FROM policy";

    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_array($result))
    {
            $content .= "Policy Name: $row[name] | Policy ID: $row[id] | City: $row[cityId]";
            $content .= "<br>";
   }

    include('includes/template.php');
    ?>
