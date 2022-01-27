<?php
require_once("back/db_connect.php");
session_start();


global $connection;
$connection->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION );

try {


    $connection->beginTransaction();
    

    $personne = <<<'SQL'
    INSERT INTO personne (nom, prénom, adresse, notelephone, email)
        VALUES (:nom, :prenom, :adresse, :notelephone, :email)
        RETURNING id;
    SQL;

    
    
    $sth = $connection->prepare($personne);
    $sth->bindParam('nom', $_POST['nom'], PDO::PARAM_STR);
    $sth->bindParam('prenom', $_POST['prénom'], PDO::PARAM_STR);
    $sth->bindParam('adresse', $_POST['adresse'], PDO::PARAM_STR);
    $sth->bindParam('notelephone', $_POST['notel'], PDO::PARAM_STR);
    $sth->bindParam('email', $_POST['email'], PDO::PARAM_STR);
    $sth->execute();
    $id = $sth->fetch()[0];
        
    if($_POST['type'] == "traiteur") {

        $traiteur = <<<'SQL'
            INSERT INTO traiteur (idpersonne, idcours, statut)
            VALUES(:idpersonne, null , false);
        SQL;

        global $connection;
        $sth = $connection->prepare($traiteur);
        $sth->bindParam('idpersonne', $id, PDO::PARAM_INT);

        $sth->execute();
    }


    $connection->commit();

    header("Location: home.php?id=".$id, true, 301);
    
} catch (PDOException  $e) {
    $connection->rollBack();
    header("Location: index.php", true, 301);
}


