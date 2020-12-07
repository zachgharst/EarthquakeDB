<?php

    require_once('includes/db-config.php');

    $title = "Policy";
    $query = "SELECT policy_name as p_name, policy.id as p_id , city.name as c_name
    FROM policy inner join city
    on policy.city_id = city.id";

    $result = mysqli_query($connection, $query);

$content .= "<table><tr><th class=\"left\">Policy Name</th><th class=\"left\">Policy Id</th><th class=\"right\">City</th></tr>";
    while ($row = mysqli_fetch_array($result))
    {
           
         $content .= "<tr><td class=\"left\">$row[p_name]</td><td>$row[p_id]</td><td>$row[c_name]</td></tr>";
           
   }

    include('includes/template.php');
    ?>
