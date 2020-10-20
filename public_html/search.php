<?php

$title = "Search";
$content = <<<SEARCH
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
SEARCH;

include('includes/template.php');

?>