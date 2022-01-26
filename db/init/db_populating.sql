-- --- Peuplement de la base de données

--- Personne
INSERT INTO Personne (nom, prénom, adresse, noTelephone, email)
SELECT 'nom ' || num,
       'prénom ' || num,
       'adresse ' || num,
       'téléphone ' || num,
       'personne' || num || '@example.com'
FROM generate_series(1, 90) as num;

-- Administrateur
INSERT INTO Administrateur(idPersonne)
SELECT randomSamplePersonne.id
FROM (SELECT * FROM Personne ORDER BY RANDOM() LIMIT 30) AS randomSamplePersonne;

-- Cours
INSERT INTO Cours(dateCours, idAdmin)
SELECT NOW() + (random() * (NOW()+'100 days' - NOW())) + '20 days',
       randomSampleAdministrateur.idPersonne
FROM (SELECT * FROM Administrateur ORDER BY RANDOM() LIMIT 15) AS randomSampleAdministrateur;

-- Traiteur
WITH idsNotAdmin as (  SELECT Personne.id
                       FROM Personne
                       WHERE Personne.id NOT IN (SELECT * FROM Administrateur)
)
INSERT INTO Traiteur(idPersonne, idCours, statut)
SELECT id,
       random() * 11 + 1, random() > 0.5
FROM idsNotAdmin
ORDER BY random() LIMIT 30;

WITH idsNotAdminNotTraiteur as (
    SELECT Personne.id
    FROM Personne
    WHERE Personne.id NOT IN (SELECT * FROM Administrateur)
      AND Personne.id NOT IN (SELECT Traiteur.idPersonne FROM Traiteur)
)
INSERT INTO Traiteur(idPersonne, idCours, statut)
SELECT id, null, false
FROM idsNotAdminNotTraiteur
ORDER BY random() LIMIT 15;

-- Produit

INSERT INTO Produit(prix, libellé, idTraiteur)
SELECT random() * 150 + 1,
       'Produit ' || num || ' Traiteur ' || Traiteur.idPersonne,
       Traiteur.idPersonne
FROM Traiteur
         CROSS JOIN (SELECT num
                     FROM generate_series(1, 5) as num
) as numeroProduit;

-- Style Culinaire

INSERT INTO StyleCulinaire(nom, régionProvenance)
SELECT 'Style '  num,
       'Région ' || (random() * 10 + 1)::INT
FROM generate_series(1, 15) as num;
-- Plat

INSERT INTO Plat(idProduit, description, catégorie, idStyleCulinaire)
SELECT randomSampleProduits.id,
       'Description Plat ' || randomSampleProduits.id,
       CASE WHEN RANDOM() < 0.5 THEN 'Entrée'::Plat_catégorie
            WHEN RANDOM() > 0.5 THEN 'Plat'::Plat_catégorie
            ELSE 'Dessert'::Plat_catégorie
           END,
       (random() * 14 + 1)::INT
FROM (SELECT * FROM Produit ORDER BY RANDOM() LIMIT 75) as randomSampleProduits;

-- Menu

WITH idsNotPlat as (
    SELECT Produit.id
    FROM Produit
    WHERE Produit.id NOT IN (SELECT Plat.idProduit FROM Plat)
)
INSERT INTO Menu(idProduit, nombrePersonnes)
SELECT idsNotPlat.id,
       RANDOM() * 11 + 1
FROM idsNotPlat;

-- INSERT INTO personne(nom, prénom, adresse, notelephone, email)
-- VALUES ('Gab', 'Vauthey', 'Grand rue', '0778996534', 'gab.vauthey@gmail.com');

-- INSERT INTO traiteur VALUES (31, NULL, TRUE);

-- INSERT INTO personne(nom, prénom, adresse, notelephone, email)
-- VALUES ('Marie', 'Vauthey', 'Grand rue', '0778996535', 'marie.vauthey@gmail.com');

-- INSERT INTO traiteur VALUES (32, NULL, TRUE);