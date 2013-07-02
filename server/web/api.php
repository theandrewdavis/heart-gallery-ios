<?php

# Mysql connection info
$host = 'localhost';
$database = 'hg';
$username = 'hguser';
$password = 'i25iyOnACVax5y3NQAn';

# Connect to mysql database
$connection = mysql_connect($host, $username, $password);
mysql_select_db($database);
mysql_set_charset("UTF8");

# Query the database and create an array from the result
$resource = mysql_query('SELECT name, description, image_large, image_small FROM children');
$children = array();
while ($row = mysql_fetch_assoc($resource)) {
  array_push($children, $row);
}

# Close mysql connection
mysql_close($connection);

# Create a JSON string from the result.
$json = array();
$json['children'] = $children;
$json_string = json_encode($json);

# Return HTTP response
header('Content-Type: application/json');
echo $json_string;