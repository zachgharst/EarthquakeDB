<?php

$title = "Search";
$content = <<<SEARCH
<form method="get" action="earthquakes.php"><fieldset><h2>Advanced Search</h2>

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

<label>Sort by</label>
<select name="sort">
    <option value="mag">Magnitude</option>
    <option value="costs">Economic Cost</option>
    <option value="injuries">Injuries</option>
    <option value="fatalities">Fatalities</option>
</select>
<select name="order">
    <option value="asc">Asc</option>
    <option value="desc">Desc</option>
</select>
<br>

<input type="submit" value="Search">
</fieldset></form>
SEARCH;

include('includes/template.php');

?>