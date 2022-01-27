<?php
require_once("back/db_connect.php");
session_start();

if (!isset($_GET['id'])) {
    header("Location: index.php", true, 301);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    unset($_SESSION["cart"][array_search($_POST['plat-id'], $_SESSION["cart"])]);
} 

header("Location: account.php?id=".$_GET['id'], true, 301);