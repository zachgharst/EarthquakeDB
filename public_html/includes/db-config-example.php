<?php

/* Fill in the 4 following variables, then rename this to db-config.php */

$host = "";
$username = "";
$password = "";
$database = "";


$connection = mysqli_connect($host, $username, $password, $database);
 
if (!$connection)
   die("Unable to connect to MySQL: " . mysqli_connect_errno());


?>

