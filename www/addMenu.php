<?php
require_once("back/db_connect.php");
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST" && isTraitor($_GET['id'])) {
    $product = <<<'SQL'
        INSERT INTO produit (prix, libellé, idtraiteur)
            VALUES (:prix, :libelle, :idtraiteur)
            RETURNING id;
    SQL;

    global $connection;
    $sth = $connection->prepare($product);
    $sth->bindParam('prix', $_POST['prix'], PDO::PARAM_STR);
    $sth->bindParam('libelle', $_POST['libellé'], PDO::PARAM_STR);
    $sth->bindParam('idtraiteur', $_GET['id'], PDO::PARAM_INT);
    $sth->execute();
    $idProduct = $sth->fetch()[0];

    $menu = <<<'SQL'
        INSERT INTO menu (idproduit, nombrepersonnes)
            VALUES (:idproduit, :nombrepersonnes);
    SQL;

    $sth = $connection->prepare($menu);
    $sth->bindParam('idproduit', $idProduct, PDO::PARAM_INT);
    $sth->bindParam('nombrepersonnes', $_POST['nombrepersonnes'], PDO::PARAM_INT);
    $sth->execute();
    // $idMenu = $sth->fetch()[0];

    // Entrée
    $plat = <<<'SQL'
        INSERT INTO menu_plat (idmenu, idplat)
            VALUES (:idmenu, :idplat);
    SQL;

    $sth = $connection->prepare($plat);
    $sth->bindParam('idmenu',$idProduct , PDO::PARAM_INT);
    $sth->bindParam('idplat', $_POST['entree'], PDO::PARAM_INT);
    $sth->execute();

    // Plat
    $plat = <<<'SQL'
        INSERT INTO menu_plat (idmenu, idplat)
            VALUES (:idmenu, :idplat);
    SQL;

    $sth = $connection->prepare($plat);
    $sth->bindParam('idmenu',$idProduct , PDO::PARAM_INT);
    $sth->bindParam('idplat', $_POST['plat'], PDO::PARAM_INT);
    $sth->execute();

    // Dessert
    $plat = <<<'SQL'
        INSERT INTO menu_plat (idmenu, idplat)
            VALUES (:idmenu, :idplat);
    SQL;

    $sth = $connection->prepare($plat);
    $sth->bindParam('idmenu',$idProduct , PDO::PARAM_INT);
    $sth->bindParam('idplat', $_POST['dessert'], PDO::PARAM_INT);
    $sth->execute();
}

header("Location: account.php?id=".$_GET['id'], true, 301);