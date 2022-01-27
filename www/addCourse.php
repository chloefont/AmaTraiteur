<?php
require_once("back/db_connect.php");
session_start();

if (!isset($_GET['id'])) {
    header("Location: index.php", true, 301);
}

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

    $plat = <<<'SQL'
        INSERT INTO plat (idproduit, description, catégorie, idstyleculinaire)
            VALUES (:idproduit, :description, :categorie, :idstyleculinaire)
    SQL;

    $sth = $connection->prepare($plat);
    $sth->bindParam('idproduit',$idProduct , PDO::PARAM_INT);
    $sth->bindParam('description', $_POST['description'], PDO::PARAM_STR);
    $sth->bindParam('categorie',$_POST['catégorie'] , PDO::PARAM_STR);
    $sth->bindParam('idstyleculinaire', $_POST['style-culinaire'], PDO::PARAM_INT);
    $sth->execute();
}

header("Location: account.php?id=".$_GET['id'], true, 301);