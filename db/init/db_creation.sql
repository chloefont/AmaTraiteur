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
    commentaire VARCHAR(500),
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

--- Vues
DROP VIEW IF EXISTS Menu_Description CASCADE;
CREATE VIEW Menu_Description
AS
SELECT P_Menu.idtraiteur, P_Menu.id, P_Menu.libellé, P_Menu.prix, Menu.nombrepersonnes,
	array_agg(P_Plat.libellé ORDER BY Plat.catégorie) AS plats
FROM Menu
	INNER JOIN Produit AS P_Menu
		ON P_Menu.id = Menu.idproduit
	INNER JOIN Menu_Plat
		ON Menu_Plat.idmenu = Menu.idproduit
	INNER JOIN Plat
		ON Menu_Plat.idplat = Plat.idproduit
	INNER JOIN Produit AS P_Plat
		ON P_Plat.id = Plat.idproduit
GROUP BY P_Menu.idtraiteur, P_Menu.id, P_Menu.libellé, P_Menu.prix, Menu.nombrepersonnes;

-- Triggers vérifiant l'héritage disjoint de Traiteur et Administrateur (Une personne ne peut être traiteur ET administrateur)

-- Check lors d'insertion dans la table Administrateur

CREATE OR REPLACE FUNCTION function_check_administrateur()
	RETURNS TRIGGER AS $$
BEGIN
	IF NEW.idPersonne IN (SELECT idPersonne FROM Traiteur) THEN
		RAISE EXCEPTION 'No Admninistrateur invalide --> %', NEW.idPersonne
		USING HINT = 'L''heritage sur Personne est disjoint. '
		             'Une personne ne peut appartenir a plusieurs sous-types.';
ELSE
		RETURN NEW;
END IF;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER check_administrateur
    BEFORE INSERT ON Administrateur
    FOR EACH ROW
    EXECUTE FUNCTION function_check_administrateur();

-- Check lors de l'insertion dans la table Traiteur

CREATE OR REPLACE FUNCTION function_check_traiteur()
	RETURNS TRIGGER AS $$
BEGIN
	IF NEW.idPersonne IN (SELECT idPersonne FROM Administrateur) THEN
		RAISE EXCEPTION 'No Traiteur invalide --> %', NEW.idPersonne
		USING HINT = 'L''heritage sur Personne est disjoint. '
		             'Une personne ne peut appartenir a plusieurs sous-types.';
ELSE
		RETURN NEW;
END IF;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER check_traiteur
    BEFORE INSERT ON Traiteur
    FOR EACH ROW
    EXECUTE FUNCTION function_check_traiteur();

-- Trigger vérifiant l'héritage disjoint de Produit

-- Check lors d'insertion dans Plat

CREATE OR REPLACE FUNCTION function_check_plat()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.idProduit IN (SELECT idProduit FROM Menu) THEN
        RAISE EXCEPTION 'No Plat invalide --> %', NEW.idProduit
            USING HINT = 'L''heritage sur Produit est disjoint.'
                'Un produit ne peut appartenir a plusieurs sous-types.';
    ELSE
        RETURN NEW;
    END IF;
END; $$
    LANGUAGE plpgsql;

CREATE TRIGGER check_plat
    BEFORE INSERT ON Plat
    FOR EACH ROW
EXECUTE FUNCTION function_check_plat();

-- Check lors d'insertion dans menu

CREATE OR REPLACE FUNCTION function_check_menu()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.idProduit IN (SELECT idProduit FROM Plat) THEN
        RAISE EXCEPTION 'No Menu invalide --> %', NEW.idProduit
            USING HINT = 'L''heritage sur Produit est disjoint.'
                'Un produit ne peut appartenir a plusieurs sous-types.';
    ELSE
        RETURN NEW;
    END IF;
END; $$
    LANGUAGE plpgsql;

CREATE TRIGGER check_menu
    BEFORE INSERT ON Menu
    FOR EACH ROW
EXECUTE FUNCTION function_check_menu();

-- Trigger vérifiant qu'un menu soit composé de plats venant du même traiteur

CREATE OR REPLACE FUNCTION function_check_multi_menu()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT Produit.idTraiteur FROM Produit WHERE Produit.id = NEW.idPlat) NOT IN
    (SELECT Produit.idTraiteur FROM Produit WHERE Produit.id = NEW.idMenu) THEN
            RAISE EXCEPTION 'Plat % invalide pour Menu %', NEW.idPlat, NEW.idMenu
            USING HINT = 'Un traiteur ne peut ajouter des plats à son menu que si ce sont ses propres plats';
ELSE
             RETURN NEW;
END IF;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER check_multi_menu
    BEFORE INSERT ON Menu_Plat
    FOR EACH ROW
    EXECUTE FUNCTION function_check_multi_menu();

-- Trigger empechant les traiteur de se commander des plats à eux-même

CREATE OR REPLACE FUNCTION function_check_auto_commande()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT Produit.idTraiteur FROM Produit WHERE Produit.id = NEW.idProduit) IN
       (SELECT Commande.idPersonne FROM Commande WHERE Commande.noCommande = NEW.noCommande) THEN
            RAISE EXCEPTION 'Produit % invalide pour commande no%', NEW.idProduit, NEW.noCommande
            USING HINT = 'Un traiteur ne peut pas se commander des plats à lui-même';
    ELSE
            RETURN NEW;
    END IF;
END; $$
LANGUAGE plpgsql;

CREATE TRIGGER check_auto_commande
    BEFORE INSERT ON Produit_Commande
    FOR EACH ROW
    EXECUTE FUNCTION function_check_auto_commande();

-- Trigger empechant les commandes de produits venant de différents traiteurs

CREATE OR REPLACE FUNCTION function_check_multi_commande()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.noCommande IN (SELECT Produit_Commande.noCommande FROM Produit_Commande) AND
       (SELECT Produit.idTraiteur FROM Produit WHERE Produit.id = NEW.idProduit) NOT IN
        (SELECT DISTINCT Produit.idTraiteur
         FROM Produit_Commande
                INNER JOIN Produit ON Produit_Commande.idProduit = Produit.id
         WHERE Produit_Commande.noCommande = NEW.noCommande) THEN
            RAISE EXCEPTION 'Produit % invalide pour commande no%', NEW.idProduit, NEW.noCommande
            USING HINT = 'Une commande ne peut pas concerner des produits de différents traiteurs';
    ELSE
        RETURN NEW;
    END IF;
END; $$
    LANGUAGE plpgsql;

CREATE TRIGGER check_multi_commande
    BEFORE INSERT ON Produit_Commande
    FOR EACH ROW
EXECUTE FUNCTION function_check_multi_commande();

--- Peuplement de la base de données

--- Personne
INSERT INTO Personne (nom, prénom, adresse, noTelephone, email)
VALUES('Neymar', 'Jean', 'Route de la Boustifaille 12', '012 412 1832', 'JeanNeym@gmail.com'),
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
      ('Andry', 'Alex', 'Chemin Alexandra 91', '093 439 3249', 'claude.francois@caramail.com'),
      ('Calc', 'Sandra', 'Route de Poudereux 31', '924 321 3255', 'sandra.callc@gmail.com'),
      ('Martinez', 'Martin', 'Chemin Vuchardaz 23', '034 321 9843', 'martin.ez@hotmail.com'),
      ('Umene', 'Cixi', 'Avenue Ducheumain 10', '043 329 8140', 'cixi.umene@bluewin.ch'),
      ('Grajet', 'Patrick', 'Avenu Minet 66', '034 324 9841', 'pat.g@gmail.com'),
      ('Boquet', 'Cybille', 'Route Dejouey 4', '043 075 9832', 'bilboquet@gmail.com');

-- Administrateur -- Les 10 premières personnes sont Administrateurs
INSERT INTO Administrateur(idPersonne)
SELECT num
FROM generate_series(1, 10) AS num;

-- Cours
INSERT INTO Cours(dateCours, idAdmin)
SELECT NOW() + (random() * (NOW()+'100 days' - NOW())) + '20 days',
       num
FROM generate_series(1, 5) AS num;

-- Traiteur -- Les personnes 11 à 30 sont des traiteurs et les 5 derniers n'ont pas suivi de cours METTRE PLUS DE TRAITEURS

INSERT INTO Traiteur(idPersonne, idCours, statut)
SELECT num,
       CASE WHEN num < 26 THEN (RANDOM() * 4 + 1)::INT
            ELSE NULL
       END,
       CASE WHEN num < 26 THEN random() > 0.4
            ELSE false
       END
FROM generate_series(11, 30) AS num;

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


       (4.50, 'Papa a la huancaina', 16),
       (11.25, 'Arroz con pollo', 16),
       (2, 'Alfajores', 16), -- 26

       (10.30, 'Pudding', 17), -- Le traiteur (id = 17) ne propose pas de plat
       (10, 'Bacon et Pancakes', 17),
       (12.80, 'Oeufs brouillés et flageolets', 17), -- 29

       (8.95, 'Mercimek Çorbası', 18),
       (16.70, 'Menemen', 18),
       (25.50, 'Kumpir', 18), -- 32

       (15.95, 'Lahmacun', 19),
       (1.50, 'Rouleaux de printemps au cerveau de mouton', 19),
       (42.10, 'Penne encre de Seiche', 19),
       (9.95, 'Crême glacée parfum épinards', 19),
       (87.30, 'Menu Sanssence', 19), -- 37

       (15.60, 'Röstis', 20),
       (23.55, 'Fondue au gruyère', 20),
       (8.95, 'Part de gâteau de payerne', 20), -- 40

       (32.20, 'Coupe de soupe aux choux et aux fraise', 21),
       (29.35, 'Grâtins aux olives et au sirop caramel', 21),
       (12.80, 'Samosa aux marshamallow et au nutella', 21), -- 43

       (14.25, 'Balık Ekmek', 22), -- Le traiteur (id = 22) ne propose pas de dessert
       (8.65, 'Älplermagronen', 22),
       (15.20, 'Lomo saltado', 22), -- 46

       (4.85, 'Crème anglaise', 23),
       (17.75, 'Rondelles de Courges au Rhum', 23),
       (30, 'Assortiment de sushis fruits', 23), -- 49

       (12.7, 'Sandwich au jambon', 24), -- Le traiteur (id = 24) ne propose que des plats
       (19.35, 'Sandwich au lardons', 24),
       (8.95, 'Sandwich au caviar', 24), -- 52

       (5.20, 'Entrée surprise', 25),
       (12.95, 'Plat surprise', 25),
       (23.50, 'Plat surprise surprenant', 25),
       (11, 'Dessert surprise', 25),
       (27.75, 'Menu surprise', 25), -- 57

       -- Produits associés aux traiteurs n'ayant pas suivi de cours

       (10, 'Anon', 26),
       (100, 'Anon', 26),
       (1, 'Anon', 26),

       (100, 'Anon', 27),
       (1, 'Anon', 27),
       (10, 'Anon', 27),

       (15, 'Anon', 28),
       (150, 'Anon', 28),
       (1, 'Anon', 28),

       (10, 'Anon', 29),
       (30, 'Anon', 29),
       (12, 'Anon', 29),

       (16, 'Anon', 30),
       (12, 'Anon', 30),
       (6, 'Anon', 30),
       (130, 'Anon', 30);



-- Style Culinaire

INSERT INTO StyleCulinaire(nom, régionProvenance)
VALUES ('Asiatique', 'Asie'), -- 1
       ('Cuisine Indienne', 'Asie'), -- 2
       ('Cuisine Deuchénou', 'Europe'), -- 3
       ('Ok, ça doit pas être bon...', 'Autre'), -- 4
       ('Cuisine Canadienne', 'Amérique'), -- 5
       ('Cuisine Péruvienne', 'Amérique Latine'), -- 6
       ('Cuisine Anglaise', 'Europe'), -- 7
       ('Spécialités turques', 'Asie'), -- 8
       ('Plats Suisses', 'Europe'), -- 9
       ('Ma passion: les sandwichs !', 'Océanie'), -- 10
       ('Inconnu', 'Inconnu'); -- 11


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

       (24, 'Pomme de terres cuites accompagné de sauce à base de biscuits et piments', 'Entrée'::Plat_catégorie, 6),
       (25, 'Riz sauté au poulet accompagné de sauce aux oignons', 'Plat'::Plat_catégorie, 6),
       (26, 'Biscuit au dulce de leche', 'Dessert'::Plat_catégorie, 6),

       (27, 'Personne ne sait vraiment ce que contient notre Pudding...', 'Dessert'::Plat_catégorie, 7),
       (28, 'Tranches de bacon accompagnés de pancakes enseveli de sirop d erable', 'Entrée'::Plat_catégorie, 7),
       (29, 'Oeufs brouillé à la poêle accompagné de délicieux flagolets rouges', 'Entrée'::Plat_catégorie, 7),

       (30, 'Soupe de lentille assaisonnée', 'Entrée'::Plat_catégorie, 8),
       (31, 'Omelette de poivrons, oignons, tomates et saucisses turques', 'Plat'::Plat_catégorie, 8),
       (32, 'Patate farcie au fromages et ingrédients à choix cuite au four', 'Plat'::Plat_catégorie, 8),

       (33, 'Pâte farcie aux épices à laquelle est ajouté du jus de citron des oignons et du persil', 'Entrée'::Plat_catégorie, 8),
       (34, 'Rouleaux de printemps farci avec du cerveau de mouton et des légumes', 'Entrée'::Plat_catégorie, 4),
       (35, 'Penne al dente à la délicieuse encre de Seiche (je les chasse moi-même)', 'Plat'::Plat_catégorie, 4),
       (36, 'Crême glacée au bon parfum épinards avec éclats de carottes', 'Dessert'::Plat_catégorie, 4),

       (38, 'Pomme de terre rappée, puis cuite et croûtée à la poêle', 'Entrée'::Plat_catégorie, 9),
       (39, 'Fondu au gruyère (exclusivement) accompagnée de pain et pommes de terre', 'Plat'::Plat_catégorie, 9),
       (40, 'Gâteau fondant aux noisettes', 'Dessert'::Plat_catégorie, 9),

       (41, 'Petit coupe de soupe au choux avec une fine couche de lamelles de fraises', 'Entrée'::Plat_catégorie, 4),
       (42, 'Olives grâtiné avec Emmental et assaisonné de sirop caramel', 'Plat'::Plat_catégorie, 4),
       (43, 'Petites poches de pâtes farcie avec des marshmallow et du nutella', 'Dessert'::Plat_catégorie, 4),

       (44, 'Sandwich au poisson', 'Entrée'::Plat_catégorie, 10),
       (45, 'Grâtin de pâtes suisse', 'Plat'::Plat_catégorie, 9),
       (46, 'Riz sauté au boeuf accompagnés de frites et oignons', 'Plat'::Plat_catégorie, 1),

       (47, 'Crème britannique ;)', 'Entrée'::Plat_catégorie, 7),
       (48, 'Courge coupée en rondelle, puis cuite avec du Rhum puis sopoudré de cannelle', 'Plat'::Plat_catégorie, 4),
       (49, 'Sushi aux fruits (banane, fraise, ananas, et autres...)', 'Dessert'::Plat_catégorie, 4),

       (50, 'Tranche de jambon entre deux tranches de pain...', 'Plat'::Plat_catégorie, 10),
       (51, 'Lardons entre deux tranches de pain...', 'Plat'::Plat_catégorie, 10),
       (52, 'Caviar entre deux tranches de pain...', 'Plat'::Plat_catégorie, 10),

       (53, 'Ce qui se trouve dans ce plat ? Surprise...', 'Entrée'::Plat_catégorie, 11),
       (54, 'Je ne vous dirais pas ce que contient ce plat, sinon la surprise disparaît', 'Plat'::Plat_catégorie, 11),
       (55, 'Si le plat surprise vous a surpris, attendez de voir celui-ci', 'Plat'::Plat_catégorie, 11),
       (56, 'Dessert mystérieux', 'Dessert'::Plat_catégorie, 11);


-- Menu

INSERT INTO Menu(idProduit, nombrePersonnes)
VALUES (8, 2),
       (14, 1),
       (23, 8),
       (37, 2),
       (57, 1);

-- Menu_Plat

INSERT INTO Menu_Plat(idMenu, idPlat)
VALUES(8, 5),
      (8, 6),
      (8, 7),

      (14, 10),
      (14, 12),
      (14, 13),

      (23, 19),
      (23, 20),
      (23, 21),
      (23, 22),

       (37, 34),
       (37, 35),
       (37, 36),

       (57, 53),
       (57, 54),
       (57, 55),
       (57, 56);

-- Commande

INSERT INTO Commande(dateheure, adresselivraison, statut, datepaiement, moyenpaiement, idpersonne)
VALUES (timestamp '2021-11-01 19:27:02', 'Route de la Patience 404', 'En cours de livraison'::Commande_statut,
        timestamp '2021-11-01 19:27:05', 'twint'::Commande_moyenPaiement, 8),
       (timestamp '2022-01-16 12:01:48', 'Route de Lausanne 89', 'validé'::Commande_statut,
        timestamp '2022-01-16 15:58:12', 'carte bancaire'::Commande_moyenPaiement, 16),
       (timestamp '2019-04-24 11:46:09', 'Chemin DesChamps 61', 'livré'::Commande_statut,
        timestamp '2019-04-24 09:33:00', 'espèce'::Commande_moyenPaiement, 24),
       (timestamp '2020-04-24 18:22:11', 'Avenue Perducelcpar 63', 'Non validé'::Commande_statut,
        timestamp '2020-04-24 18:25:25', 'paypal'::Commande_moyenPaiement, 11),
       (timestamp '2016-06-01 16:20:28', 'Avenue Publiss-Iter 23', 'livré'::Commande_statut,
        timestamp '2016-06-01 16:21:56', 'carte bancaire'::Commande_moyenPaiement, 25),
       (timestamp '2018-12-25 18:22:11', 'Chemin Statik 0b', 'En cours de livraison'::Commande_statut,
        timestamp '2019-01-01 00:01:10', 'espèce'::Commande_moyenPaiement, 9),
       (timestamp '2022-01-01 14:45:34', 'Chemin du Preaujay-Bédéhère 7', 'validé'::Commande_statut,
        timestamp '2022-01-01 14:48:19', 'paypal'::Commande_moyenPaiement, 3),
       (timestamp '2012-12-12 00:00:01', 'Chemin Alexandra 91', 'Non validé'::Commande_statut,
        timestamp '2012-12-12 00:00:01', 'twint'::Commande_moyenPaiement, 30),
       (timestamp '2021-05-13 13:01:59', 'Chemin Seney Point-Monadraice 9', 'En cours de livraison'::Commande_statut,
        timestamp '2021-05-13 13:25:13', 'espèce'::Commande_moyenPaiement, 26),
       (timestamp '2017-07-16 10:49:42', 'Ruelle Unotradraice 12', 'validé'::Commande_statut,
        timestamp '2017-03-09 17:01:39', 'twint'::Commande_moyenPaiement, 20),
       (timestamp '2019-01-04 04:20:10', 'Route de la Boustifaille 12', 'validé'::Commande_statut,
        timestamp '2019-01-04 12:31:00', 'carte bancaire'::Commande_moyenPaiement, 1),
       (timestamp '2022-04-17 11:06:37', 'Chemin de Wabit-Noparan 19', 'livré'::Commande_statut,
        timestamp '2022-04-18 07:41:12', 'espèce'::Commande_moyenPaiement, 1),
       (timestamp '2002-08-11 12:34:19', 'Route de Moralise 23', 'Non validé'::Commande_statut,
        timestamp '2016-11-11 13:03:42', 'paypal'::Commande_moyenPaiement, 29),
       (timestamp '2021-12-29 12:34:19', 'Route de Moralise 23', 'En cours de livraison'::Commande_statut,
        timestamp '2021-12-29 12:35:07', 'twint'::Commande_moyenPaiement, 29),
       (timestamp '2022-01-08 21:55:32', 'Avenue Dayeure 22', 'validé'::Commande_statut,
        timestamp '2022-01-08 23:01:16', 'twint'::Commande_moyenPaiement, 29);

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
       (12, 10, 2),
       (26, 11, 12),
       (31, 12, 3),
       (57, 13, 2),
       (38, 14, 1),
       (12, 15, 1);

-- Evaluation

INSERT INTO Evaluation(dateevaluation, note, commentaire, nocommande)
VALUES (timestamp '2021-11-04 05:21:14', 5, 'Super traiteur, je recommande.', 1),
       (timestamp '2019-04-24 11:48:10', 1, 'La pire expérience de ma vie. Le patron a refusé de reprendre mon plat car les frites étaient froides. J ai hésité à
		appeler la police quand il a menacé de m étrangler avec des saucissons. Je déconseille !', 3),
       (timestamp '2016-06-01 16:20:46', 3, 'Bon mais pas ouff', 5),
       (timestamp '2022-01-05 10:30:02', 4, 'MIAM !', 7),
       (timestamp '2012-12-12 00:01:32', 2, 'Bof... Trop cher pour ce que c est', 8),
       (timestamp '2017-08-21 23:56:42', 3, 'Bien mais je connais un bon italien dans ma rue. Il s appelle Senza una donna non c è zucchero.', 10),
       (timestamp '2002-08-11 13:13:06', 4, 'SUPER ! MEILLEUR RESTO DE MA VIE. Le serveur était charmant, je veux bien son 07.', 13),
       (timestamp '2022-01-08 21:55:35', 2, 'De la nourriture pour chat...', 15);

-- Insertion de Test pour les triggers

-- Test heritage disjoint sur Produit
--INSERT INTO Menu VALUES(1, 3);
INSERT INTO Plat VALUES(8, 'coucou', 'Entrée'::Plat_catégorie, 1);

-- Tests Commande de produits venant de différents traiteurs

INSERT INTO Produit_Commande VALUES (3, 1, 1); -- Devrait marcher
INSERT INTO Produit_Commande VALUES (20, 5, 2); -- Devrait marcher
INSERT INTO Produit_Commande VALUES (32, 13, 1); -- Devrait lever une exception
INSERT INTO Produit_Commande VALUES (16, 1, 1); -- Devrait lever une exception

-- Tests Commande d'un traiteur à lui-même

INSERT INTO Commande(dateHeure, adresseLivraison, statut, datePaiement, moyenPaiement, idPersonne) VALUES(timestamp '2021-11-01 19:27:02', 'Route de la Patience 404', 'En cours de livraison'::Commande_statut, -- Commande du traiteur 1 (idPersonne = 11) à lui-même
                            timestamp '2021-11-01 19:27:05', 'twint'::Commande_moyenPaiement, 11);
INSERT INTO Produit_Commande VALUES(1, 16, 1);

-- Test composition de menu avec des plats d'un autre traiteur

INSERT INTO Menu_Plat VALUES(14, 9); -- Devrait marcher
INSERT INTO Menu_Plat VALUES(14, 52); -- Devrait lever une exception

-- Test Héritage disjoint sur Personne

INSERT INTO Traiteur VALUES(1); -- Devrait lever une exception
INSERT INTO Administrateur VALUES(11); -- Devrait lever une exception