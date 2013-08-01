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

# Query the database for all children and media.
$query = 'SELECT children.id, children.name, children.description, children.image_large, children.image_small, media.name AS media_name, media.type AS media_type FROM children LEFT JOIN media ON children.id = media.child_id';
$resource = mysql_query($query);

# Close mysql connection
mysql_close($connection);

# Create an array of children from the database result.
$children = array();
while ($row = mysql_fetch_assoc($resource)) {
  # Add the child attributes if they aren't already present.
  if (!array_key_exists($row['id'], $children)) {
    $child = array();
    $child['id'] = $row['id'];
    $child['name'] = $row['name'];
    $child['description'] = $row['description'];
    $child['media'] = array();
    $children[$row['id']] = $child;
  }

  # Add media attributes to the media array if they exist.
  if (isset($row['media_name']) && isset($row['media_type'])) {
    $media_item = array();
    $media_item['name'] = $row['media_name'];
    $media_item['type'] = $row['media_type'];
    array_push($children[$row['id']]['media'], $media_item);
  }
}

# Place all children objects in an array under 'children'. Create a JSON string.
$json = array('children' => array_values($children));
$json_string = json_encode($json);

# Return 'Not Modified' if ETag matches.
$etag = md5($json_string);
if (isset($_SERVER['HTTP_IF_NONE_MATCH']) && $_SERVER['HTTP_IF_NONE_MATCH'] == $etag) {
  error_log('Found if-none-match: ' . $_SERVER['HTTP_IF_NONE_MATCH']);
  header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
  exit();
}

# Return HTTP response
header('Content-Type: application/json');
header('ETag: ' . $etag);
echo $json_string;

