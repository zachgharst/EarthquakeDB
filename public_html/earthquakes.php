<?php

    require_once 'includes/db-config.php';

    /* Get cluster view only if cluster ID is set. */
    $cluster = "";
    if(isset($_GET[cluster]) && is_numeric($_GET[cluster])) {
        $cluster = "AND
        (id IN (SELECT earthquake_id FROM cluster WHERE cluster_id = $_GET[cluster]))";
    }

    /* Sanitize input for query. */
    $mag = is_numeric($_GET[mag]) ? $_GET[mag] : 0;
    if($_GET[mag_direction] == "lt") $mag_direction = "<=";
    elseif($_GET[mag_direction] == "eq") $mag_direction = "=";
    else $mag_direction = ">=";

    $effected_population = is_numeric($_GET[effectedpopulation]) && $_GET[effectedpopulation] != 0 ? $_GET[effectedpopulation] : "0 OR effected_population IS NULL";
    if($_GET[effectedpopulation_direction] == "lt") $effectedpopulation_direction = "<=";
    elseif($_GET[effectedpopulation_direction] == "eq") $effectedpopulation_direction = "=";
    else $effectedpopulation_direction = ">=";

    $injuries = is_numeric($_GET[injuries]) && $_GET[injuries] != 0 ? $_GET[injuries] : "0 OR injuries IS NULL";
    if($_GET[injuries_direction] == "lt") $injuries_direction = "<=";
    elseif($_GET[injuries_direction] == "eq") $injuries_direction = "=";
    else $injuries_direction = ">=";

    $fatalities = is_numeric($_GET[fatalities]) && $_GET[fatalities] != 0 ? $_GET[fatalities] : "0 OR fatalities IS NULL";
    if($_GET[fatalities_direction] == "lt") $fatalities_direction = "<=";
    elseif($_GET[fatalities_direction] == "eq") $fatalities_direction = "=";
    else $fatalities_direction = ">=";

    $sortOptions = ["id", "time", "latitude", "longitude", "mag", "effected_population", "costs", "injuries", "fatalities"];
    $sort = in_array($_GET[sort], $sortOptions) ? $_GET[sort] : "id";
    $order = $_GET[order] == "asc" ? "asc" : "desc";

    /* Gather the total number of rows possible based on the filter. */
    $query_no_limit = <<<query
    SELECT DATE_FORMAT(time, '%M %e, %Y') as formattedDate,
    TIME(time) as formattedTime,
    latitude,
    longitude,
    mag,
    effected_population,
    costs,
    injuries,
    fatalities
    FROM  earthquake LEFT JOIN damage ON id = earthquake_id WHERE 
        mag $mag_direction $mag AND
        (effected_population $effectedpopulation_direction $effected_population) AND
        (injuries $injuries_direction $injuries) AND
        (fatalities $fatalities_direction $fatalities)
        $cluster
query;

    $total_rows = mysqli_query($connection, $query_no_limit);
    $total_rows = mysqli_num_rows($total_rows);
    $total_pages = ceil($total_rows / 200);

    /* Calculate which page the user is on and deliver the data for that page. */
    if($_GET[page] >= 1 && $_GET[page] <= $total_pages) $page = $_GET[page];
    else $page = 1;
    $offset = ($page - 1) * 200;

    /* Gather the 200 rows based on the current page. */
    $query_concat_limit = "ORDER BY $sort $order LIMIT $offset, 200";
    $query = $query_no_limit . $query_concat_limit;

    /* Generate paging. */
    $first_page = http_build_query(array_merge($_GET,array('page' => 1)));
    $prev_page = http_build_query(array_merge($_GET,array('page' => $page - 1)));
    $next_page = http_build_query(array_merge($_GET,array('page' => $page + 1)));
    $last_page = http_build_query(array_merge($_GET,array('page' => $total_pages)));

    $paging_choices = "";
    if($page != 1) $paging_choices .= "<a href=\"?$first_page\">First</a> | <a href=\"?$prev_page\">Previous</a> | ";
    else $paging_choices .= "First | Previous | ";
    $paging_choices .= "Page $page of $total_pages | ";
    $paging_choices .= $page != $total_pages ? "<a href=\"?$next_page\">Next</a> | <a href=\"?$last_page\">Last</a>" : "Next | Last";

    $result = mysqli_query($connection, $query);
    $row_count = mysqli_num_rows($result);

    /* Start generating content. */
    $title = "Earthquakes";
    $content = <<<TABLE

        <table class="right">
            <tr><td colspan="9" class="first">$paging_choices</td></tr>
            <tr><th class="left">Date</th><th>Time</th><th>Location</th><th>Magnitude</th><th>Effected Population</th><th>Economic Cost</th><th>Injuries</th><th>Fatalities</th></tr>

TABLE;

    for($i = 0; $i < $row_count; $i++) {
        $row = mysqli_fetch_assoc($result);
        if($row[costs] != NULL) $row[costs] = "\$" . $row[costs];

        $content .= "            <tr><td class=\"left\">$row[formattedDate]</td><td>$row[formattedTime]</td><td><a href=\"https://maps.google.com/maps?z=10&q=$row[latitude]+$row[longitude]\">($row[latitude], $row[longitude])</a></td><td>$row[mag]</td><td>$row[effected_population]</td><td>$row[costs]</td><td>$row[injuries]</td><td>$row[fatalities]</td></tr>";
    }

    $content .= <<<TABLE2
            <tr><td colspan="9" class="last">$row_count rows returned of $total_rows.<br>$paging_choices</td></tr>
        </table>
TABLE2;

    if($row_count == 0) {
        $content = "<p class=\"error\">We couldn't find any earthquakes with that search criteria.</p>";
    }

    include('includes/template.php');

?>
