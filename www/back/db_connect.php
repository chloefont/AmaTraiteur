<?php
$connection = new PDO("pgsql:host=db_server;port=5432;dbname=amaTraiteur", $_ENV["DB_USER"], $_ENV["DB_PASSWORD"]);

// $cart = array();

// test
$users = $connection->query('SELECT * FROM personne')->fetchAll(PDO::FETCH_ASSOC);

// TODO réussir à mettre null après (quand trié)
function getTenBestRankedTraitors() {
    $sql = <<<'SQL'
        SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email,
                CASE WHEN AVG(note) IS NULL THEN 0 ELSE round(AVG(note), 2) END AS moyenne, COUNT(evaluation.id) AS nbEvaluations
        FROM traiteur
            INNER JOIN personne
                ON traiteur.idpersonne = personne.id
            INNER JOIN cours
                ON traiteur.idcours = cours.id
            INNER JOIN produit
                ON produit.idtraiteur = traiteur.idpersonne
            LEFT JOIN produit_commande
                ON produit.id = produit_commande.idproduit
            LEFT JOIN commande
                ON produit_commande.nocommande = commande.nocommande
            LEFT JOIN evaluation
                ON commande.nocommande = evaluation.nocommande
        WHERE traiteur.statut = TRUE
        GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email
        ORDER BY moyenne DESC, nbEvaluations DESC
        LIMIT 10;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);

    $sth->execute();
    return $sth->fetchAll();
}

function traitorSearchWithWord($word) {
    $sql = <<<'SQL'
        SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email,
        CASE WHEN AVG(note) IS NULL THEN 0 ELSE round(AVG(note), 2) END AS moyenne, COUNT(evaluation.id) AS nbEvaluations
        FROM traiteur
            INNER JOIN personne
                ON traiteur.idpersonne = personne.id
            INNER JOIN cours
                ON traiteur.idcours = cours.id
            INNER JOIN produit
                ON produit.idtraiteur = traiteur.idpersonne
            INNER JOIN produit_commande
                ON produit.id = produit_commande.idproduit
            INNER JOIN plat
                ON produit.id = plat.idproduit
            LEFT JOIN styleculinaire
                ON plat.idstyleculinaire = styleculinaire.id
            INNER JOIN commande
                ON produit_commande.nocommande = commande.nocommande
            INNER JOIN evaluation
                ON commande.nocommande = evaluation.nocommande
        WHERE traiteur.statut = true AND (personne.nom = :mot OR personne.prénom ILIKE :mot
                                            OR personne.adresse ILIKE :mot OR produit.libellé ILIKE :mot
                                            OR styleculinaire.nom ILIKE :mot)
        GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email
        ORDER BY moyenne DESC, nbEvaluations DESC;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $str = '%'.$word.'%';
    $sth->bindParam('mot',$str , PDO::PARAM_STR);

    $sth->execute();
    return $sth->fetchAll();
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
        SELECT idtraiteur, id, libellé, prix, nombrepersonnes, array_to_json(plats) AS plats
        FROM Menu_Description
        WHERE idtraiteur = :id;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}

function getTraitorEvaluations($id, $order) {
    
    $sql = <<<'SQL'
        SELECT evaluation.note, evaluation.commentaire, evaluation.dateevaluation, produit.idtraiteur
        FROM traiteur
            INNER JOIN produit
                ON produit.idtraiteur = traiteur.idpersonne
            INNER JOIN produit_commande
                ON produit.id = produit_commande.idproduit
            INNER JOIN commande
                ON produit_commande.nocommande = commande.nocommande
            INNER JOIN evaluation
                ON commande.nocommande = evaluation.nocommande
        WHERE produit.idtraiteur = :id
    SQL;

    if ($order == 'note') {
        $sql = $sql.' ORDER BY evaluation.note DESC;';
    } else {
        $sql = $sql.' ORDER BY evaluation.dateevaluation DESC;';
    }

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('id', $id, PDO::PARAM_INT);

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

function getGradetraitor($id) {
    $sql = <<<'SQL'
        SELECT CASE WHEN AVG(note) IS NULL THEN 0 ELSE round(AVG(note), 2) END AS moyenne
        FROM Evaluation
            INNER JOIN Commande
                ON Evaluation.nocommande = Commande.nocommande
            INNER JOIN Produit_Commande
                ON Commande.nocommande = Produit_Commande.nocommande
            INNER JOIN produit
                ON produit_commande.idproduit = produit.id
        WHERE produit.idtraiteur = :id;
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

function getTraitorOrders($id) {
    $sql = <<<'SQL'
        SELECT commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement, personne.nom, personne.prénom, 
            SUM(produit.prix * produit_commande.quantité) AS "Prix commande", COUNT(produit)
        FROM commande
            INNER JOIN produit_commande
                ON commande.nocommande = produit_commande.nocommande
            INNER JOIN produit
                ON produit_commande.idproduit = produit.id
            INNER JOIN traiteur
                ON traiteur.idpersonne = produit.idtraiteur
            INNER JOIN personne
                ON personne.id = commande.idpersonne
        WHERE traiteur.idpersonne = :id
        GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement, personne.nom, personne.prénom
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

function idForEmail($email) {
    $sql = <<<'SQL'
        SELECT id
        FROM personne
        WHERE email = :mail;
    SQL;

    global $connection;
    $sth = $connection->prepare($sql);
    $sth->bindParam('mail', $email, PDO::PARAM_STR);

    $sth->execute();
    return $sth->fetchAll();
}

