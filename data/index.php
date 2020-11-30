<?php
    $con= new mysqli("localhost","","","");
    $cityname = $_post['search'];
    $query = "SELECT earthquake.id, mag, ST_Distance_Sphere(
    point(earthquake.longitude, earthquake.latitude),
    point(city.longitude, city.latitude )
) * .000621371192 AS distance  
FROM earthquake INNER JOIN city ON name = '$cityname' ORDER BY distance;
";

    // Check connection
    if (mysqli_connect_errno())
      {
      echo "Failed to connect to MySQL: " . mysqli_connect_error();
      }

$result = mysqli_query($con, "SELECT earthquake.id, mag, ST_Distance_Sphere(
    point(earthquake.longitude, earthquake.latitude),
    point(city.longitude, city.latitude )
) * .000621371192 AS distance  
FROM earthquake INNER JOIN city ON name = '$cityname' ORDER BY distance;
");

while ($row = mysqli_fetch_array($result))
{
        echo $row['cityname'] . " " . $row[''];
        echo "<br>";
}
    mysqli_close($con);
    ?>