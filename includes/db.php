<?php
// Database connection shared by every page. XAMPP default login: root, no password.
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$db = new mysqli('localhost', 'root', '', 'novel_portal');
$db->set_charset('utf8mb4');

// Run a prepared statement and return the result (SELECT) or the statement (INSERT/UPDATE/DELETE).
// $types follows bind_param, e.g. "is" for an int then a string.
function db_query($sql, $types = '', $params = [])
{
    global $db;
    $stmt = $db->prepare($sql);
    if ($types !== '') {
        $stmt->bind_param($types, ...$params);
    }
    $stmt->execute();
    $result = $stmt->get_result();
    return $result === false ? $stmt : $result;
}

// First row of a SELECT as an associative array, or null
function db_row($sql, $types = '', $params = [])
{
    $row = db_query($sql, $types, $params)->fetch_assoc();
    return $row === null ? null : $row;
}

// All rows of a SELECT
function db_all($sql, $types = '', $params = [])
{
    return db_query($sql, $types, $params)->fetch_all(MYSQLI_ASSOC);
}
