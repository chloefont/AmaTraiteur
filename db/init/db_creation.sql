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