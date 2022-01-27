<?php
$connection = new PDO("pgsql:host=db_server;port=5432;dbname=amaTraiteur", $_ENV["DB_USER"], $_ENV["DB_PASSWORD"]);

// test
$users = $connection->query('SELECT * FROM personne')->fetchAll(PDO::FETCH_ASSOC);

function getTenBestRankedTraitors() {
    global $connection;
    return $connection->query('SELECT * FROM personne')->fetchAll(PDO::FETCH_ASSOC);
}

function getTraitorInfo($id) {
    global $connection;
    return $connection->query('
    SELECT * FROM traiteur
        INNER JOIN personne 
        ON personne.id = traiteur.idpersonne
    WHERE personne.id ='.$id.';')->fetchAll(PDO::FETCH_ASSOC);
}

function getPersoInfos($id) {
    global $connection;
    return $connection->query('
    SELECT * FROM personne
    WHERE personne.id ='.$id.';')->fetchAll(PDO::FETCH_ASSOC);
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
// rechercher un traiteur par son nom
function serchWordInTraiteur($word) {
    global $connection;
    return $connection->query('
    SELECT * FROM traiteur
            INNER JOIN personne 
        ON personne.id = traiteur.idpersonne
    WHERE personne.nom ='.$word.';'
    )->fetchAll(PDO::FETCH_ASSOC);
}

// chercher des traiteur par le nom des plat qu'il propose


function serchWordInProduit($word) {
    global $connection;
    return $connection->query('
    SELECT * FROM traiteur
            INNER JOIN produit
        ON produit.id = traiteur.idpersonne
    WHERE produit.nom ='.$word.';'
    )->fetchAll(PDO::FETCH_ASSOC);
}
// chercher un traiteur par le style culinaire des plas qu'il propose 
function serchWordInStyle($word) {
    global $connection;
    return $connection->query('
    SELECT * FROM traiteur
        INNER JOIN produit
         ON produit.id = traiteur.idpersonne
       INNER JOIN plat
         ON plat.idproduit = produit.id
       INNER JOIN styleculinaire
         ON  styleculinaire.id = plat.idstyleculinaire 
    
    
    WHERE styleculinaire.nom ='.$word.';'
    )->fetchAll(PDO::FETCH_ASSOC);
}

