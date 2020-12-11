<?php

    require_once('includes/db-config.php');

    $title = "Policy";

    if(isset($_GET[id]) && is_numeric($_GET[id])) {
        $query = "SELECT policy_name, company_name, premium, type_name FROM policy JOIN policy_type ON policy.type_id = policy_type.id WHERE policy.id = $_GET[id]";
        $result = mysqli_query($connection, $query);
        $result = mysqli_fetch_array($result);

        $queryCities = "SELECT name FROM policies_in_cities JOIN city ON policies_in_cities.cityID = city.id WHERE policyID = $_GET[id]";
        $queryCities = mysqli_query($connection, $queryCities);

        $content .= "<h2>Looking for a policy?</h2><p>Protect YOUR property with the $result[policy_name] Seismic Activity Insurance Policy from $result[company_name], now only \$$result[premium] a year! Coverage level: $result[type_name]<input type=\"button\" value=\"Buy now!\"></p>
        <p>Maybe you already have this policy, and you're thinking on moving! This policy is also available in the following cities:</p>
        <ul>";

        while($row = mysqli_fetch_array($queryCities)) {
            $content .= "<li>$row[name]</li>";
        }


        $content .= "</ul>";

    }
    else {
        $query = "SELECT policy.id, policy_name, company_name, premium, type_name FROM policy JOIN policy_type ON policy.type_id = policy_type.id ORDER BY policy.id ASC;";

        $result = mysqli_query($connection, $query);

        $content .= "<table><tr><th>Policy</th><th>Company</th><th>Premium</th><th>Coverage Level</th></tr>";
        while ($row = mysqli_fetch_array($result))
        {
            
            $content .= "<tr><td><a href=\"?id=$row[id]\">$row[policy_name]</a></td><td>$row[company_name]</td><td>$row[premium]</td><td>$row[type_name]</td></tr>";
            
        }
    }

    include('includes/template.php');
    ?>
