<?php
require_once("back/db_connect.php");
session_start();

if (!isset($_GET['id'])) {
    header("Location: index.php", true, 301);
}


global $connection;
$connection->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

try {

    $connection->beginTransaction();
    

    $order = <<<'SQL'
    INSERT INTO commande (dateheure, adresselivraison, statut, datepaiement, moyenpaiement, idpersonne)
        VALUES (NOW(), :adresse, 'Non validé', NOW(), 'carte bancaire', :id)
        RETURNING nocommande;
    SQL;

    
    $sth = $connection->prepare($order);
    $sth->bindParam('adresse', getPersoInfos($_GET['id'])[0]['adresse'], PDO::PARAM_STR);
    $sth->bindParam('id', $_GET['id'], PDO::PARAM_INT);
    $sth->execute();
    $idOrder = $sth->fetch()[0];


    $arrayCounted = array_count_values($_SESSION["cart"]);
        
    foreach($arrayCounted as $idP=>$nb) {

        $product = <<<'SQL'
            INSERT INTO produit_commande (idproduit, nocommande, quantité)
            VALUES(:idProduit, :noCommande , :nb);
        SQL;

        global $connection;
        $sth = $connection->prepare($product);
        $sth->bindParam('idProduit', $idP, PDO::PARAM_INT);
        $sth->bindParam('noCommande', $idOrder, PDO::PARAM_INT);
        $sth->bindParam('nb', $nb, PDO::PARAM_INT);

        $sth->execute();
    }

    foreach($_SESSION['cart'] as $idP) {
        unset($_SESSION["cart"][array_search($idP, $_SESSION["cart"])]);
    }


    $connection->commit();
    
} catch (PDOException  $e) {
    $connection->rollBack();
} finally {
    header("Location: account.php?id=".$_GET['id'], true, 301);
}


