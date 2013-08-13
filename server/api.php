<?php

require_once dirname(__FILE__) . '/../mobile/lib/Database.php';

# Translate a media type number into a media type name.
function media_type_name($media_type_value) {
	static $media_types = array('0' => 'image', '1' => 'audio', '2' => 'video');
	return array_key_exists($media_type_value, $media_types) ? $media_types[$media_type_value] : 'unknown';
}

# Fetch all children and associated media from the database.
$query = "SELECT child_table.child_id, child_name, child_bio, child_gender, child_birthday, child_image, child_thumbnail, child_video, media_name, media_type " .
	"FROM child_table " .
	"LEFT JOIN media_table ON child_table.child_id = media_table.child_id";
$childRows = Database::toArray(Database::query($query));
Database::close();

# Format the results.
$children = array();
foreach ($childRows as $row) {
	# Add the child attributes if they aren't already present.
	if (!array_key_exists($row['child_id'], $children)) {
		$child = array();
		$child['id'] = $row['child_id'];
		$child['name'] = $row['child_name'];
		$child['description'] = $row['child_bio'];
		$child['gender'] = $row['child_gender'];
		$child['birthday'] = $row['child_birthday'];
		$child['thumbnail'] = $row['child_thumbnail'];
		$child['media'] = array();
		array_push($child['media'], array('name' => $row['child_image'], 'type' => 'image'));
		array_push($child['media'], array('name' => $row['child_video'], 'type' => 'video'));
		$children[$row['child_id']] = $child;
	}

	# Add media attributes to the media array if they exist.
	if (isset($row['media_name']) && isset($row['media_type'])) {
		$media_item = array();
		$media_item['name'] = $row['media_name'];
		$media_item['type'] = media_type_name($row['media_type']);
		array_push($children[$row['child_id']]['media'], $media_item);
	}
}

# Place all children objects in an array under 'children'. Create a JSON string.
$json = array('children' => array_values($children));
$json_string = json_encode($json);

# Return 'Not Modified' if ETag matches.
$etag = md5($json_string);
if (isset($_SERVER['HTTP_IF_NONE_MATCH']) && $_SERVER['HTTP_IF_NONE_MATCH'] == $etag) {
	header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
	exit();
}

# Return HTTP response
header('Content-Type: application/json');
header('ETag: ' . $etag);
echo $json_string;
