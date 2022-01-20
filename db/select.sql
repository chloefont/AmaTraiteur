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
SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, round(AVG(note), 2) AS moyenne
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
WHERE traiteur.idpersonne = 1 AND traiteur
GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse
ORDER BY moyenne DESC
LIMIT 10;

-- moteur de recherche
SELECT traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse, round(AVG(note), 2) AS moyenne
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
WHERE traiteur.statut = true AND (personne.nom ILIKE 'mot' OR personne.prénom ILIKE 'mot'
                                      OR personne.adresse ILIKE 'mot' OR produit.libellé ILIKE 'mot'
                                      OR styleculinaire.nom ILIKE 'mot')
GROUP BY traiteur.idpersonne, personne.nom, personne.prénom, personne.adresse
ORDER BY moyenne DESC;

-- sélection des évaluations d'un traiteur
SELECT evaluation.note, evaluation.dateevaluation, evaluation.dateevaluation
FROM traiteur
    INNER JOIN produit
        ON produit.idtraiteur = traiteur.idpersonne
    INNER JOIN produit_commande
        ON produit.id = produit_commande.idproduit
    INNER JOIN commande
        ON produit_commande.nocommande = commande.nocommande
    INNER JOIN evaluation
        ON commande.nocommande = evaluation.nocommande
WHERE traiteur.idpersonne = 1
ORDER BY evaluation.dateevaluation DESC;

-- sélection plats traiteur
SELECT plat.catégorie, produit.id, produit.libellé, plat.description, produit.prix
FROM traiteur
INNER JOIN produit
        ON produit.idtraiteur = traiteur.idpersonne
    INNER JOIN produit_commande
        ON produit.id = produit_commande.idproduit
    INNER JOIN plat
        ON produit.id = plat.idproduit
    LEFT JOIN styleculinaire
        ON plat.idstyleculinaire = styleculinaire.id
WHERE traiteur.idpersonne = 1;
-- sélection menus traiteur
SELECT produit.id, produit.libellé, produit.prix, menu.nombrepersonnes
FROM traiteur
INNER JOIN produit
        ON produit.idtraiteur = traiteur.idpersonne
    INNER JOIN produit_commande
        ON produit.id = produit_commande.idproduit
    INNER JOIN menu
        ON produit.id = menu.idproduit
WHERE traiteur.idpersonne = 1;
-- trier par type ?

-- commandes d'un client
SELECT commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement,
       SUM(produit) AS "Prix commande"
FROM commande
    INNER JOIN produit_commande
        ON commande.nocommande = produit_commande.nocommande
    INNER JOIN produit
        ON produit_commande.idproduit = produit.id
    INNER JOIN personne
        ON commande.idpersonne = personne.id
WHERE personne.id = 1
GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement
ORDER BY commande.dateheure DESC;

-- commandes d'un traiteur
SELECT commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement,
       SUM(produit.prix) AS "Prix commande",
       COUNT(produit)
FROM commande
    INNER JOIN produit_commande
        ON commande.nocommande = produit_commande.nocommande
    INNER JOIN produit
        ON produit_commande.idproduit = produit.id
    INNER JOIN traiteur
        ON traiteur.idpersonne = produit.idtraiteur
WHERE traiteur.idpersonne = 1
GROUP BY commande.nocommande, commande.dateheure, commande.statut, commande.moyenpaiement
ORDER BY commande.dateheure DESC;