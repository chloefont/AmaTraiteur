<?php
$connection = new PDO("pgsql:host=db_server;port=5432;dbname=amaTraiteur", $_ENV["DB_USER"], $_ENV["DB_PASSWORD"]);

// $cart = array();

// test
$users = $connection->query('SELECT * FROM personne')->fetchAll(PDO::FETCH_ASSOC);

function getTenBestRankedTraitors() {
    global $connection;
    return $connection->query('
        SELECT * FROM personne 
            INNER JOIN traiteur 
                ON personne.id = traiteur.idPersonne')->fetchAll(PDO::FETCH_ASSOC);
}

function getTraitorInfo($id) {
    global $connection;
    return $connection->query('
    SELECT * FROM traiteur
        INNER JOIN personne 
        ON personne.id = traiteur.idpersonne
    WHERE personne.id ='.$id.';')->fetchAll(PDO::FETCH_ASSOC);
}

function getTraitorMain($id) {
    global $connection;
    return $connection->query('
    SELECT * FROM produit
        INNER JOIN plat 
        ON produit.id = plat.idproduit;');
}

function getPersoInfos($id) {
    $sql = <<<'SQL'
        SELECT *
        FROM personne
        WHERE personne.id = :id;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}

function getProduct($id) {
    $sql = <<<'SQL'
        SELECT DISTINCT *
        FROM produit
        WHERE produit.id = :id;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}

function isTraitor($id) {
    global $connection;
    if ($connection->query('
    SELECT * FROM traiteur
        INNER JOIN personne 
        ON personne.id = traiteur.idpersonne
    WHERE personne.id ='.$id.';')->rowCount() == 0) {
        return false;
    } else {
        return true;
    }
}

function getOldOrders($id) {
    $sql = <<<'SQL'
        SELECT commande.nocommande, to_char(commande.dateheure, 'DD.MM.YYYY HH24:MI') AS "dateCommande", 
                commande.statut, commande.moyenpaiement, traiteur.idpersonne, 
                SUM(produit.prix) AS "Prix commande"
        FROM commande
            INNER JOIN produit_commande
                ON commande.nocommande = produit_commande.nocommande
            INNER JOIN produit
                ON produit_commande.idproduit = produit.id
            INNER JOIN personne
                ON commande.idpersonne = personne.id
            LEFT JOIN traiteur
                ON traiteur.idpersonne = produit.idtraiteur
        WHERE personne.id = :id
        GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement,
                traiteur.idpersonne
        ORDER BY commande.dateheure DESC;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}