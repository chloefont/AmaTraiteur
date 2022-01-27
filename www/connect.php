<?php
require_once("back/db_connect.php");

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = idForEmail($_POST['email']);
    if (count($id) == 1) {
        header("Location: home.php?id=".$id[0]['id'], true, 301);
    } else {
        header("Location: index.php", true, 301);
    }
} else {
    header("Location: index.php", true, 301);
}

