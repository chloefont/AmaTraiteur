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