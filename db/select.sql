-- moyenne de note des traiteurs
SELECT round(AVG(note), 2) AS moyenne
FROM Evaluation
    INNER JOIN Commande
        ON Evaluation.nocommande = Commande.nocommande
    INNER JOIN Produit_Commande
        ON Commande.nocommande = Produit_Commande.nocommande
    INNER JOIN produit
        ON produit_commande.idproduit = produit.id
WHERE produit.idtraiteur = 1;

-- sélection des 10 meilleurs traiteurs
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

-- Sélection des traiteurs ayant les styles culinaires les plus commandés par le client
SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email,
       round(AVG(note), 2) AS moyenne
FROM traiteur
         INNER JOIN personne
                    ON traiteur.idpersonne = personne.id
         INNER JOIN cours
                    ON traiteur.idcours = cours.id
         INNER JOIN produit
                    ON produit.idtraiteur = traiteur.idpersonne
         INNER JOIN produit_commande
                    ON produit.id = produit_commande.idproduit
         INNER JOIN commande
                    ON produit_commande.nocommande = commande.nocommande
         INNER JOIN evaluation
                    ON commande.nocommande = evaluation.nocommande
         INNER JOIN plat
                    ON produit.id = plat.idproduit
         INNER jOIN styleculinaire
                    ON styleculinaire.id = plat.idstyleculinaire
WHERE traiteur.statut = TRUE AND styleculinaire.id IN (
    SELECT DISTINCT styleculinaire.id
    FROM styleculinaire
             INNER JOIN plat
                        ON styleculinaire.id = plat.idstyleculinaire
             INNER JOIN produit
                        ON produit.id = plat.idproduit
             INNER JOIN produit_commande
                        ON produit.id = produit_commande.idproduit
             INNER JOIN commande
                        ON produit_commande.nocommande = commande.nocommande
             INNER JOIN personne
                        ON commande.idpersonne = personne.id
    WHERE personne.id = :id
)
GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email
ORDER BY moyenne DESC
    LIMIT 10;

-- moteur de recherche
SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email,
       round(AVG(note), 2) AS moyenne
FROM traiteur
         INNER JOIN personne
                    ON traiteur.idpersonne = personne.id
         INNER JOIN cours
                    ON traiteur.idcours = cours.id
         LEFT JOIN produit
                   ON produit.idtraiteur = traiteur.idpersonne
         LEFT JOIN produit_commande
                   ON produit.id = produit_commande.idproduit
         LEFT JOIN plat
                   ON produit.id = plat.idproduit
         LEFT JOIN styleculinaire
                   ON plat.idstyleculinaire = styleculinaire.id
         LEFT JOIN commande
                   ON produit_commande.nocommande = commande.nocommande
         LEFT JOIN evaluation
                   ON commande.nocommande = evaluation.nocommande
WHERE traiteur.statut = true AND (personne.nom ILIKE :mot OR personne.prénom ILIKE :mot
                                            OR personne.adresse ILIKE :mot OR produit.libellé ILIKE :mot
                                            OR styleculinaire.nom ILIKE :mot)
GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, personne.notelephone, personne.email
ORDER BY moyenne DESC;

-- Sélection des infos personnel des traiteurs
SELECT *
FROM traiteur
    INNER JOIN personne
        ON personne.id = traiteur.idpersonne
WHERE personne.id = 5; -- chiffre à remplacer par l'id du traiteur voulu

-- sélection des évaluations d'un traiteur
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
WHERE produit.idtraiteur = 5; -- chiffre à remplacer par l'id du traiteur voulu

-- sélection plats traiteur
SELECT * FROM produit
                  INNER JOIN plat
                             ON produit.id = plat.idproduit
                  INNER JOIN traiteur
                             ON traiteur.idpersonne = produit.idtraiteur
                  LEFT JOIN styleculinaire
                            ON styleculinaire.id = plat.idstyleculinaire
WHERE traiteur.idpersonne = 5 AND plat.catégorie = 'Entrée'; -- Chiffre à remplacer par l'id du traiteur et catégorie
                                                             -- à remplacer par Entrée/Plat/Dessert
-- Sélection des infos des menus d'un traiteur
SELECT idtraiteur, id, libellé, prix, nombrepersonnes, array_to_json(plats) AS plats
FROM Menu_Description
WHERE idtraiteur = 5; -- chiffre à remplacer par l'id du traiteur voulu

-- commandes d'un client
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
WHERE personne.id = 5 -- Chiffre à remplacer par l'id de la personne
GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement,
         traiteur.idpersonne
ORDER BY commande.dateheure DESC;

-- commandes d'un traiteur
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
WHERE traiteur.idpersonne = 5 -- Chiffre à remplacer par l'id du traiteur
GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement, personne.nom, personne.prénom
ORDER BY commande.dateheure DESC;

-- menus d'un traiteur
SELECT idtraiteur, id, libellé, prix, nombrepersonnes, array_to_json(plats) AS plats
FROM Menu_Description
WHERE idtraiteur = 5; -- Chiffre à remplacer par l'id du traiteur