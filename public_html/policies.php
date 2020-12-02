<?php

    require_once('includes/db-config.php');

    $title = "Policy";
    $query = "SELECT policy_name, id, city_id
    FROM policy";

    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_array($result))
    {
            $content .= "Policy Name: $row[policy_name] | Policy ID: $row[id] | City: $row[city_id]";
            $content .= "<br>";
   }

    include('includes/template.php');
    ?>
