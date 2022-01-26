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

function getTraitorCourses($id, $category) {
    assert($category == 'Entrée' || $category == 'Plat' || $category == 'Dessert');

    $sql = <<<'SQL'
       SELECT * FROM produit
            INNER JOIN plat 
                ON produit.id = plat.idproduit
            INNER JOIN traiteur
                ON traiteur.idpersonne = produit.idtraiteur
        WHERE traiteur.idpersonne = :id AND plat.catégorie = :category;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);
    $sth->bindParam('category', $category, PDO::PARAM_STR);

    $sth->execute();
    return $sth->fetchAll();
}

function getTraitoMenusInfos($id) {
    $sql = <<<'SQL'
       SELECT *
        FROM Menu
            INNER JOIN Menu_Plat
                ON Menu.idproduit = Menu_Plat.idmenu
            INNER JOIN Produit
                ON Menu.idproduit = Produit.id
        WHERE Produit.idtraiteur = :id;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}

function getCoursesFromMenu($idMenu) {
    $sql = <<<'SQL'
        SELECT Produit.libellé, Plat.catégorie
        FROM Produit
            INNER JOIN Plat
                ON Plat.idproduit = Produit.id
            INNER JOIN Menu_Plat
                ON Plat.idproduit = Menu_Plat.idplat
        WHERE Menu_Plat.idmenu = :idMenu
        ORDER BY catégorie ASC;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('idMenu', $idMenu, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
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

function isMenu($id) {
    $sql = <<<'SQL'
        SELECT COUNT(*)
        FROM Menu
        WHERE idproduit = :id;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetch()[0] == 1;
}

function getOldOrders($id) {
    $sql = <<<'SQL'
        SELECT commande.nocommande, to_char(commande.dateheure, 'DD.MM.YYYY HH24:MI') AS "dateCommande", 
                commande.statut, commande.moyenpaiement, traiteur.idpersonne, 
                SUM(produit.prix * produit_commande.quantité) AS "Prix commande"
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

function getAllStyleCulinaire() {
    $sql = <<<'SQL'
        SELECT *
        FROM styleCulinaire;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);

    $sth->execute();
    return $sth->fetchAll();
}