<?php

    require_once('includes/db-config.php');

    $title = "Policy";
    $query = "SELECT policy_name, id, city.name
    FROM policy inner join city
    on policy.id = city.id;

    $result = mysqli_query($connection, $query);

    while ($row = mysqli_fetch_array($result))
    {
            $content .= "Policy Name: $row[policy_name] | Policy ID: $row[id] | City: $row[name]";
            $content .= "<br>";
   }

    include('includes/template.php');
    ?>
