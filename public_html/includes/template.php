<!DOCTYPE html>
<html lang="eng">
    <head>
        <meta charset ="utf-8">
        <link rel="stylesheet" href="css/main.css">
        <title>EarthquakeDB: <?php print($title); ?></title>
    </head>

    <body>
        <h1><a href="index.php">CS470 MFG Earthquake DB</a></h1>
        <div class="nav_menu">
            <a href="earthquakes.php">Earthquakes</a>
            <a href="clusters.php">Clusters</a>
            <a href="policyname.php">Insurance Policies</a>
            <a href="search.php">Advanced Search</a>
           <form action="city.php" method="get"><input name="cityname" type="text" placeholder="Search by city name..."></form>
        </div>

       <div id="main"> <?php print($content); ?></div>
        </div>
            <footer id="footer"></footer>
</div>
    </body>
</html>
