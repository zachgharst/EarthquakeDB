<!DOCTYPE html>
<html lang="eng">
    <head>
        <meta charset ="utf-8">
        <link rel="stylesheet" href="css/main.css">
        <title>CS470 MFG Earthquake DB</title>
    </head>

    <body>
        <h1><a href="index.html">CS470 MFG Earthquake DB</a></h1>
        <div class="nav_menu">
            <a href="earthquakes.html">Earthquakes</a>
            <a href="">Tsunamis</a>
            <a href="">Clusters</a>
            <a href="">Insurance Policies</a>
            <a href="search.html">Search</a>
           <input type="text" placeholder="Search by city name...">
        </div>

        <form><fieldset><h2>Advanced Search</h2>

            <label>Magnitude</label>
            <select>
                <option>&gt;=</option>
                <option>&lt;=</option>
                <option>=</option>
            </select>
            <input type="number" value="0"><br>

            <label>Longitude</label>
            <input type="text"><br>

            <label>Latitude</label>
            <input type="text"><br><br>

            <label>Fatalities</label>
            <select>
                <option>&gt;=</option>
                <option>&lt;=</option>
                <option>=</option>
            </select>
            <input type="number" value="0"><br>

            <label for="datemax">Search for dates between </label>
            <input type="date"><br><br>
            <label for="datemin">And</label>
            <input type="date" > <br>

            <label>Apart of Cluster?</label>
            <input type="checkbox"> <br>
            
            <label>Tsunami risk?</label>
            <input type="checkbox"><br>
            
             

            <input type="submit" value="Search">
        </fieldset></form>
    </body>
</html>