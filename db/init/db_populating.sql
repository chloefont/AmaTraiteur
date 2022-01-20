--- Peuplement de la base de données

--- Personne
INSERT INTO Personne (nom, prénom, adresse, noTelephone, email)
SELECT 'nom ' || num,
       'prénom ' || num,
       'adresse ' || num,
       'téléphone ' || num,
       'personne' || num || '@example.com'
FROM generate_series(1, 30) as num;

-- Administrateur
INSERT INTO Administrateur(idPersonne) -- Les 30 premières personnes sont administrateurs
SELECT Personne.id
FROM Personne TABLESAMPLE SYSTEM(30);

-- Cours
INSERT INTO Cours(dateCours, idAdmin)
SELECT NOW() - (random() * (NOW() + 1000 - NOW())),
       Administrateur.idPersonne
FROM Administrateur TABLESAMPLE SYSTEM(50);

-- Traiteur
WITH idsNotAdmin as (  SELECT Personne.id
                       FROM Personne
                       WHERE Personne.id NOT IN (SELECT * FROM Administrateur)
)
INSERT INTO Traiteur(idPersonne, idCours, statut)  -- Les 31e à 45e personnes sont Traiteurs avec Cours (validé ou non)
SELECT id, random() * 11 + 1, random() > 0.5
FROM idsNotAdmin
ORDER BY random() LIMIT 15;

WITH idsNotAdminNotTraiteur as (
    SELECT Personne.id
    FROM Personne
    WHERE Personne.id NOT IN (SELECT * FROM Administrateur)
      AND Personne.id NOT IN (SELECT Traiteur.idPersonne FROM Traiteur)
)
INSERT INTO Traiteur(idPersonne, idCours, statut)  -- Les 46e à 60e personnes sont Traiteurs sans Cours
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
SELECT 'Style ' || num,
       'Région ' || (random() * 10 + 1)::INT
FROM generate_series(1, 15) as num;

-- Plat

