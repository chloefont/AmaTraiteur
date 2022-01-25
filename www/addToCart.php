<?php
require_once("back/db_connect.php");
session_start();

// print_r($_SESSION["cart"]);

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    array_push($_SESSION["cart"], $_POST['plat-id']);
}

header("Location: traiteur.php?id=".$_GET['id']."&idTraitor=".$_GET['idTraitor'], true, 301);