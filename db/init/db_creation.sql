CREATE DATABASE zizi;

----------------------- Enum
DROP TYPE IF EXISTS Plat_catégorie CASCADE;
CREATE TYPE Plat_catégorie AS ENUM ('Entrée', 'Plat', 'Dessert');

DROP TYPE IF EXISTS Commande_statut CASCADE;
CREATE TYPE Commande_statut AS ENUM ('Non validé', 'validé', 'En cours de livraison', 'livré');

DROP TYPE IF EXISTS Commande_moyenPaiement CASCADE;
CREATE TYPE Commande_moyenPaiement AS ENUM ('carte bancaire', 'twint', 'espèce', 'paypal');

----------------------- Création tables
DROP TABLE IF EXISTS Personne CASCADE;
CREATE TABLE Personne (
    id SERIAL,
    nom VARCHAR(25) NOT NULL,
    prénom VARCHAR(25) NOT NULL,
    adresse VARCHAR(50) NOT NULL,
    noTelephone VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Personne PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Administrateur CASCADE;
CREATE TABLE Administrateur (
    idPersonne INTEGER,
    CONSTRAINT PK_Administrateur PRIMARY KEY (idPersonne)
);

DROP TABLE IF EXISTS Traiteur CASCADE;
CREATE TABLE Traiteur (
    idPersonne INTEGER,
    idCours INTEGER,
    statut BOOLEAN NOT NULL DEFAULT false,
    CONSTRAINT PK_Traiteur PRIMARY KEY (idPersonne)
);

DROP TABLE IF EXISTS Cours CASCADE;
CREATE TABLE Cours (
    id SERIAL,
    dateCours DATE NOT NULL,
    idAdmin INTEGER NOT NULL,
    CONSTRAINT PK_Cours PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Produit CASCADE;
CREATE TABLE Produit (
    id SERIAL,
    prix NUMERIC(5, 2) NOT NULL,
    libellé VARCHAR(50) NOT NULL,
    idTraiteur INTEGER NOT NULL,
    CONSTRAINT PK_Produit PRIMARY KEY (id),
    CONSTRAINT CHK_Produit_prix CHECK ( prix > 0 )
);

DROP TABLE IF EXISTS Menu CASCADE;
CREATE TABLE Menu (
      idProduit INTEGER,
      nombrePersonnes INTEGER NOT NULL DEFAULT 1,
      CONSTRAINT PK_Menu PRIMARY KEY (idProduit),
      CONSTRAINT CHK_Menu_nombrePersonnes CHECK ( nombrePersonnes > 0 )
);

DROP TABLE IF EXISTS Plat CASCADE;
CREATE TABLE Plat (
    idProduit INTEGER,
    description VARCHAR(200),
    catégorie Plat_catégorie NOT NULL,
    idStyleCulinaire INTEGER,
    CONSTRAINT PK_Plat PRIMARY KEY (idProduit)
);

DROP TABLE IF EXISTS Menu_Plat CASCADE;
CREATE TABLE Menu_Plat (
    idMenu INTEGER,
    idPlat INTEGER,
    CONSTRAINT PK_Menu_Plat PRIMARY KEY (idMenu, idPlat)
);

DROP TABLE IF EXISTS StyleCulinaire CASCADE;
CREATE TABLE StyleCulinaire (
    id SERIAL,
    nom VARCHAR(30) NOT NULL,
    régionProvenance VARCHAR(50) NOT NULL,
    CONSTRAINT PK_StyleCulinaire PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Commande CASCADE;
CREATE TABLE Commande (
    noCommande SERIAL,
    dateHeure TIMESTAMP NOT NULL,
    adresseLivraison VARCHAR(100) NOT NULL,
    statut Commande_statut NOT NULL,
    noPaiement SERIAL,
    datePaiement DATE NOT NULL,
    moyenPaiement Commande_moyenPaiement NOT NULL,
    idPersonne INTEGER NOT NULL,
    CONSTRAINT PK_Commande PRIMARY KEY (noCommande)
);

DROP TABLE IF EXISTS Produit_Commande CASCADE;
CREATE TABLE Produit_Commande (
    idProduit INTEGER,
    noCommande INTEGER,
    quantité INTEGER NOT NULL,
    CONSTRAINT PK_Produit_Commande PRIMARY KEY (idProduit, noCommande),
    CONSTRAINT CHK_Produit_Commande_quantite CHECK ( quantité > 0 )
);

DROP TABLE IF EXISTS Evaluation CASCADE;
CREATE TABLE Evaluation (
    id SERIAL,
    dateEvaluation DATE NOT NULL,
    note INTEGER NOT NULL,
    noCommande INTEGER NOT NULL UNIQUE,
    CONSTRAINT PK_Evaluation PRIMARY KEY (id),
    CONSTRAINT CHK_Evaluation_note CHECK ( note > 0 AND note < 6)
);

----------------------- Index
DROP INDEX IF EXISTS IDX_FK_AdminPlateforme_idPersonne;
CREATE INDEX IDX_FK_AdminPlateforme_idPersonne ON Administrateur (idPersonne);

DROP INDEX IF EXISTS IDX_FK_Traiteur_idPersonne;
CREATE INDEX IDX_FK_Traiteur_idPersonne ON Traiteur(idPersonne);

DROP INDEX IF EXISTS IDX_FK_Traiteur_idCours;
CREATE INDEX IDX_FK_Traiteur_idCours ON Traiteur(idCours);

DROP INDEX IF EXISTS IDX_FK_Cours_idAdmin;
CREATE INDEX IDX_FK_Cours_idAdmin ON Cours(idAdmin);

DROP INDEX IF EXISTS IDX_FK_Produit_idTraiteur;
CREATE INDEX IDX_FK_Produit_idTraiteur ON Produit(idTraiteur);

DROP INDEX IF EXISTS IDX_FK_Menu_idProduit;
CREATE INDEX IDX_FK_Menu_idProduit ON Menu(idProduit);

DROP INDEX IF EXISTS IDX_FK_Plat_idProduit;
CREATE INDEX IDX_FK_Plat_idProduit ON Plat(idProduit);

DROP INDEX IF EXISTS IDX_FK_Plat_idStyleCulinaire;
CREATE INDEX IDX_FK_Plat_idStyleCulinaire ON Plat(idStyleCulinaire);

DROP INDEX IF EXISTS IDX_FK_Menu_Plat_idMenu;
CREATE INDEX IDX_FK_Menu_Plat_idMenu ON Menu_Plat(idMenu);

DROP INDEX IF EXISTS IDX_FK_Menu_Plat_idPlat;
CREATE INDEX IDX_FK_Menu_Plat_idPlat ON Menu_Plat(idPlat);

DROP INDEX IF EXISTS IDX_FK_Commande_idPersonne;
CREATE INDEX IDX_FK_Commande_idPersonne ON Commande(idPersonne);

DROP INDEX IF EXISTS IDX_FK_Produit_Commande_idProduit;
CREATE INDEX IDX_FK_Produit_Commande_idProduit ON Produit_Commande(idProduit);

DROP INDEX IF EXISTS IDX_FK_Produit_Commande_noCommande;
CREATE INDEX IDX_FK_Produit_Commande_noCommande ON Produit_Commande(noCommande);

DROP INDEX IF EXISTS IDX_FK_Evaluation_noCommande;
CREATE INDEX IDX_FK_Evaluation_noCommande ON Evaluation(noCommande);

----------------------- Contraintes de clés étrangères
--- Administrateur
ALTER TABLE Administrateur
    ADD CONSTRAINT FK_AdminPlateforme_idPersonne
        FOREIGN KEY (idPersonne)
            REFERENCES Personne(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Traiteur
ALTER TABLE Traiteur
    ADD CONSTRAINT FK_Administrateur_idPersonne
        FOREIGN KEY (idPersonne)
            REFERENCES Personne(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Traiteur
    ADD CONSTRAINT FK_Traiteur_idCours
        FOREIGN KEY (idCours)
            REFERENCES Cours(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

--- Cours
ALTER TABLE Cours
    ADD CONSTRAINT FK_Cours_idAdmin
        FOREIGN KEY (idAdmin)
            REFERENCES Administrateur (idPersonne)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Produit
ALTER TABLE Produit
    ADD CONSTRAINT FK_Produit_idTraiteur
        FOREIGN KEY (idTraiteur)
            REFERENCES Traiteur(idPersonne)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Menu
ALTER TABLE Menu
    ADD CONSTRAINT FK_Menu_id
        FOREIGN KEY (idProduit)
            REFERENCES Produit(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Plat
ALTER TABLE Plat
    ADD CONSTRAINT FK_Plat_id
        FOREIGN KEY (idProduit)
            REFERENCES Produit(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Plat
    ADD CONSTRAINT FK_Plat_idStyleCulinaire
        FOREIGN KEY (idStyleCulinaire)
            REFERENCES StyleCulinaire(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

--- Menu_Plat
ALTER TABLE Menu_Plat
    ADD CONSTRAINT FK_idMenu
        FOREIGN KEY (idMenu)
            REFERENCES Menu(idProduit)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Menu_Plat
    ADD CONSTRAINT FK_idPlat
        FOREIGN KEY (idPlat)
            REFERENCES Plat(idProduit)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Commande
ALTER TABLE Commande
    ADD CONSTRAINT FK_idPersonne
        FOREIGN KEY (idPersonne)
            REFERENCES Personne(id)
ON DELETE SET NULL
ON UPDATE CASCADE;

--- Produit_Commande
ALTER TABLE Produit_Commande
    ADD CONSTRAINT FK_idProduit
        FOREIGN KEY (idProduit)
            REFERENCES Produit(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Produit_Commande
    ADD CONSTRAINT FK_noCommande
        FOREIGN KEY (noCommande)
            REFERENCES Commande(noCommande)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Evaluation
ALTER TABLE Evaluation
    ADD CONSTRAINT FK_noCommande
        FOREIGN KEY (noCommande)
            REFERENCES Commande(noCommande)
ON DELETE CASCADE
ON UPDATE CASCADE;

--- Peuplement de la base de données

--- Personne
INSERT INTO Personne (nom, prénom, adresse, noTelephone, email)
VALUES ('Neymar', 'Jean', 'Route de la Boustifaille 12', '012 412 1832', 'JeanNeym@gmail.com'),
      ('Debonlyvre', 'Julie', 'Route de Jésuy-Père-Du 31', '031 532 2135', 'LaJulie@hotmail.com'),
      ('Peausy-Scion', 'Paul', 'Chemin du Preaujay-Bédéhère 7', '021 423 1245', 'jaimelesvoiture@bluewin.ch'),
      ('Aideufoi', 'Marie', 'Avenue des Cordet 92', '021 422 2314', 'asdfmail@mail.com'),
      ('Toilla', 'Aline', 'Ruelle Kifeyp-Eurlanuy 666', '921 124 5233', 'aline.toilla@heig-vd.ch'),
      ('Ydeufrensse', 'Marc', 'Rue Lafaillette 2', '923 214 3437', 'roi2france@hotmail.com'),
      ('Bonhalaille', 'Jean', 'Chemin du Plezyr 68', '079 123 8952', 'jean.b@gmail.com'),
      ('Maidutan', 'Jim', 'Route de la Patience 404', '023 453 1236', 'jim.attend@mail.com'),
      ('Surplasse', 'Chloé', 'Chemin Statik 0b', '923 433 2168', 'chl.sur@gmail.com'),
      ('Melto', 'Luca', 'Route de la Débauche 7', '021 622 3490', 'unautreemail@random.nu'),
      ('Jaillet', 'Casimir', 'Avenue Perducelcpar 63', '021 214 9832', 'cas.jaillet@mail.ch'),
      ('Sirupa', 'Esmeralda', 'Ruelle Sombre 12', '083 352 4937', 'sirupa.esmeralda@gmail.com'),
      ('Jachet', 'Henri', 'Chemin Falardy 213', '982 094 1244', 'henri.jachet@gmail.com'),
      ('Verser', 'Annie', 'Chemin Inspiration 0', '213 653 9834', 'annie.verser@gmail.com'),
      ('Ciboulo', 'Einstein', 'Route Jepludidey 71', '984 432 0861', 'lemaileinstein@hotmail.com'),
      ('Lutti', 'Stéphane', 'Route de Lausanne 89', '832 093 2167', 'steph.lutti@mail.ch'),
      ('Nondeufamy', 'Alain', 'Avenue Sanzinspy 92', '832 023 1255', 'alain.nond@bluewin.ch'),
      ('Lynne', 'Rita', 'Chemin de la Pharmacie 6', '089 513 9734', 'medoc.jeudemots@mail.com'),
      ('Istur', 'Travis', 'Route de Marieule 42', '093 081 9742', 'travistur@gmail.com'),
      ('Orak', 'Anne', 'Avenue Polère 9', '042 842 9832', 'sasageod@mail.in'),
      ('Barre', 'Laurent', 'Chemin Detunes 23', '083 928 6454', 'laurent.barre@gmail.com'),
      ('Maillet', 'Christine', 'Route Adenue 9', '924 083 3432', 'christine.maillet@hotmail.com'),
      ('Vasquez', 'Valentin', 'Ruelle de la Tour 2', '843 202 9872', 'valentin.vas@gmail.com'),
      ('Auchan', 'Ethan', 'Chemin DesChamps 61', '092 534 2198', 'mailoriginal@mail.original'),
      ('La', 'Rico', 'Avenue Publiss-Iter 23', '089 234 8897', 'rico.la@gmail.com'),
      ('Santi', 'Hildegarde', 'Chemin Des Champions 21', '983 093 3467', 'la.meilleure@mail.com'),
      ('Alière', 'Céline', 'Route du Désespoir 5', '083 213 2165', 'celine.aliere@hotmail.com'),
      ('Colin', 'Nathan', 'Avenue Duseine 43', '083 209 3285', 'nathan.colin@gmail.com'),
      ('Ploira', 'Dylan', 'Route de Moralise 23', '094 235 9853', 'dylan.ploira@mail.com'),
      ('Andry', 'Alex', 'Chemin Alexandra 91', '093 439 3249', 'claude.francois@caramail.com');

-- Administrateur -- Les 10 premières personnes sont Administrateurs
INSERT INTO Administrateur(idPersonne)
SELECT num
FROM generate_series(1, 10) AS num;

-- Cours
INSERT INTO Cours(dateCours, idAdmin)
SELECT NOW() + (random() * (NOW()+'100 days' - NOW())) + '20 days',
       num
FROM generate_series(1, 5) AS num;

-- Traiteur -- Les personnes 11 à 20 sont des traiteurs et les 5 derniers n'ont pas suivi de cours METTRE PLUS DE TRAITEURS

INSERT INTO Traiteur(idPersonne, idCours, statut)
SELECT num,
       CASE WHEN num < 16 THEN num - 10
            ELSE NULL
       END,
       CASE WHEN num < 16 THEN random() > 0.4
            ELSE false
       END
FROM generate_series(11, 20) AS num;

-- Produit

INSERT INTO Produit(prix, libellé, idTraiteur)
VALUES (12.75, 'Nouilles crues aux petits pois', 11), -- Le traiteur (id = 11) ne propose pas de menu
       (12.60, 'Spaghettis sautés au camembert', 11),
       (7.45, 'Pommes de terre aux four', 11),
       (6.65, 'Sorbet Amande', 11), -- 4

       (9.95, 'Salade grecque au fond déshydraté de veau', 12),
       (18.30, 'Pot-au-feu', 12),
       (11.25, 'Sundae à la papaye', 12),
       (29.70, 'Menu Kiphé-Anville', 12), -- 8

       (10, 'Choux rouge en croûte', 13),
       (6.55, 'Salade Avocats et Crevettes à la sauce Cocktail', 13),
       (13.30, 'Poulet impérial', 13),
       (16.25, 'Porc Aigre-doux', 13),
       (3.50, 'Biscuit chinois', 13),
       (35.50, 'Menu Tinoa', 13), -- 14

       (9, 'Soupe au Potimarron', 14), -- Le traiteur (id = 14) ne propose pas d'entrée
       (8.50, 'Poutine', 14),
       (16.40, 'Hamburger de Furet', 14),
       (14.85, 'Coupe Danemark', 14), -- 18

       (6.90, 'Pain indien chapati', 15),
       (21.55, 'Poulet Tandoori', 15),
       (32.30, 'Aloo Bombay', 15),
       (12, 'Gulab jamun', 15),
       (125.95, 'Menu Pourseup Aitay Leubid', 15), -- 23

       -- Produits associés aux traiteurs n'ayant pas suivi de cours
       (1, 'Anon', 16),
       (10, 'Anon', 16),
       (100, 'Anon', 16), -- 26

       (10, 'Anon', 17),
       (10, 'Anon', 17),
       (100, 'Anon', 17), -- 29

       (10, 'Anon', 18),
       (10, 'Anon', 18),
       (100, 'Anon', 18), -- 32

       (100, 'Anon', 19),
       (10, 'Anon', 19),
       (10, 'Anon', 19), -- 35

       (10, 'Anon', 20),
       (100, 'Anon', 20),
       (1, 'Anon', 20); -- 38

-- Style Culinaire

INSERT INTO StyleCulinaire(nom, régionProvenance)
VALUES ('Asiatique', 'Asie'),
       ('Cuisine Indienne', 'Asie'),
       ('Cuisine Deuchénou', 'Europe'),
       ('Ok, ça doit pas être bon...', 'Autre'),
       ('Cuisine Canadienne', 'Amérique');


-- Plat

INSERT INTO Plat(idProduit, description, catégorie, idStyleCulinaire)
VALUES (1, 'Eh bien, ce sont des nouilles... Malheureusement non cuites, mais au moins on a mis des petits pois avec !',
        'Plat'::Plat_catégorie, 4),
       (2, 'Spaghettis japonais cuits (cette fois-ci), puis sautés avec un délicieux camembert aux truffes',
        'Plat'::Plat_catégorie, 3),
       (3, 'Pommes de terre fraîches sautées aux oignons et au Cognac', 'Entrée'::Plat_catégorie, 3),
       (4, 'Sorbet amande accompagné de crème chantilly et de miel', 'Dessert'::Plat_catégorie, 1),

       (5, 'On voulait voir si une salade grecque mélangée à du fond de veau donnait...', 'Entrée'::Plat_catégorie, 4),
       (6, 'Pot-au-feu avec frites et sauces', 'Plat'::Plat_catégorie, 3),
       (7, 'Sundae saveur papaye accompagné de petits pois', 'Dessert'::Plat_catégorie, 4),

       (9, 'Choux mis en croûte avec du beurre et des pousses de bambous', 'Entrée'::Plat_catégorie, 4),
       (10, 'Avocats coupés en cubes accompagné de petites crevettes mis en sauce cocktail', 'Entrée'::Plat_catégorie, 2),
       (11, 'Poulet sauté épicé accompagnés de cacahuètes, divers légumes et piment', 'Plat'::Plat_catégorie, 2),
       (12, 'Entre nous, je dois vraiment vous expliquer  ?', 'Plat'::Plat_catégorie, 2),
       (13, 'Petit Biscuit Chinois (attentions il y a un papier dedans, ne pas avaler)', 'Dessert'::Plat_catégorie, 1),

       (15, 'Soupe à la courge potimarron. Essayez, ça a un goût délicieux :)', 'Plat'::Plat_catégorie, 5),
       (16, 'Frites couvertes de fromage et de sauce brune', 'Plat'::Plat_catégorie, 5),
       (17, 'Hamburger fait avec la viande fraîche venant tout droite de la ville de Furet', 'Plat'::Plat_catégorie, 5),
       (18, 'Glace à la vanille arrosée de chocolat noir fondu', 'Dessert'::Plat_catégorie, 3),

       (19, 'Petites crêpes à base de farine de bise, sel et eau', 'Entrée'::Plat_catégorie, 2),
       (20, 'Poulet cuit sur un four de pierre en feu', 'Plat'::Plat_catégorie, 2),
       (21, 'pommes de terre coupées en cubes, étuvées puis frites et assaisonnées avec cumin, curry, ail, le garam' ||
            'masala, curcuma, graines de moutarde, chili en poudre, sel et poivre', 'Plat'::Plat_catégorie, 2),
       (22, 'Boulettes de pâtes frites et servies avec du sirop parfum cardamome', 'Dessert'::Plat_catégorie, 2),

       (24, 'NoDescr', 'Entrée'::Plat_catégorie, 1),
       (25, 'NoDescr', 'Dessert'::Plat_catégorie, 2),
       (26, 'NoDescr', 'Entrée'::Plat_catégorie, 1),
       (27, 'NoDescr', 'Plat'::Plat_catégorie, 3),
       (28, 'NoDescr', 'Entrée'::Plat_catégorie, 4),
       (29, 'NoDescr', 'Dessert'::Plat_catégorie, 1),
       (30, 'NoDescr', 'Plat'::Plat_catégorie, 2),
       (31, 'NoDescr', 'Entrée'::Plat_catégorie, 5),
       (32, 'NoDescr', 'Dessert'::Plat_catégorie, 1),
       (33, 'NoDescr', 'Entrée'::Plat_catégorie, 3),
       (34, 'NoDescr', 'Dessert'::Plat_catégorie, 1),
       (35, 'NoDescr', 'Plat'::Plat_catégorie, 5),
       (36, 'NoDescr', 'Plat'::Plat_catégorie, 4),
       (37, 'NoDescr', 'Entrée'::Plat_catégorie, 1),
       (38, 'NoDescr', 'Plat'::Plat_catégorie, 2);


-- Menu

INSERT INTO Menu(idProduit, nombrePersonnes)
VALUES (8, 2),
      (14, 1),
      (23, 8);

-- Menu_Plat

INSERT INTO Menu_Plat(idMenu, idPlat)
VALUES (8, 5),
      (8, 6),
      (8, 7),

      (14, 10),
      (14, 12),
      (14, 13),

      (23, 19),
      (23, 20),
      (23, 21),
      (23, 22);

-- Commande

INSERT INTO Commande(dateheure, adresselivraison, statut, datepaiement, moyenpaiement, idpersonne)
VALUES (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Route de la Patience 404', 'En cours de livraison'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'twint'::Commande_moyenPaiement, 8),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Route de Lausanne 89', 'validé'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'carte bancaire'::Commande_moyenPaiement, 16),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Chemin DesChamps 61', 'livré'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'espèce'::Commande_moyenPaiement, 24),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Avenue Perducelcpar 63', 'Non validé'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'paypal'::Commande_moyenPaiement, 11),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Avenue Publiss-Iter 23', 'livré'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'carte bancaire'::Commande_moyenPaiement, 25),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Chemin Statik 0b', 'En cours de livraison'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'espèce'::Commande_moyenPaiement, 9),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Chemin du Preaujay-Bédéhère 7', 'validé'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'paypal'::Commande_moyenPaiement, 3),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Chemin Alexandra 91', 'Non validé'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'twint'::Commande_moyenPaiement, 30),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Chemin Seney Point-Monadraice 9', 'En cours de livraison'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'espèce'::Commande_moyenPaiement, 26),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'Ruelle Unotradraice 12', 'validé'::Commande_statut,
        timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 'twint'::Commande_moyenPaiement, 20);

-- Produit_Commande

INSERT INTO Produit_Commande(idProduit, noCommande, quantité)
VALUES (4, 1, 2),
       (8, 2, 1),
       (9, 3, 1),
       (22, 4, 4),
       (23, 5, 2),
       (1, 6, 5),
       (5, 7, 1),
       (3, 8, 2),
       (4, 9, 2),
       (12, 10, 2);

-- Evaluation

INSERT INTO Evaluation(dateevaluation, note, nocommande)
VALUES (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 5, 1),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 2, 3),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 1, 5),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 4, 7),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 2, 8),
       (timestamp '2022-01-01 20:00:00' -
        random() * (timestamp '2022-01-20 20:00:00' - timestamp '2022-01-10 20:00:00'), 3, 10);

