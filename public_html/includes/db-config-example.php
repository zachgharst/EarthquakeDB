<?php

/* Fill in the 4 following variables, then rename this to db-config.php */

$host = "";
$username = "";
$password = "";
$database = "";

$connection = new mysqli($host, $username, $password, $database) or die("Connection failed: %s\n" . $connection->error);

?>