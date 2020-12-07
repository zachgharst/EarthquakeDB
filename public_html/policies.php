<?php

    require_once('includes/db-config.php');

    $title = "Policy";
    $query = "SELECT policy_name as p_name, policy.id as p_id , city.name as c_name
    FROM policy inner join city
    on policy.city_id = city.id";

    $result = mysqli_query($connection, $query);

$content .= "<table><tr><th>Policy Name</th><th>Policy Id</th><th>City</th></tr>";
    while ($row = mysqli_fetch_array($result))
    {
           
         $content .= "<tr><td>$row[p_name]</td><td>$row[p_id]</td><td>$row[c_name]</td></tr>";
           
   }

    include('includes/template.php');
    ?>
