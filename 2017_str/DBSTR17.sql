DROP DATABASE IF EXISTS DBSTR17;
CREATE DATABASE  IF NOT EXISTS DBSTR17;
USE DBSTR17

-- titolo scheda ridotto a 190 per errore:
-- Specified key was too long; max key length is 767 bytes
-- in table Scheda:
-- CONSTRAINT GuessSomethingElse UNIQUE KEY(titolo, candidato),
-- VARCHAR can store up to 4 bytes per char depending on the charset used ...

CREATE TABLE Utente (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated user id",
	nome VARCHAR(30) NOT NULL COMMENT "Nome utente",
	cognome VARCHAR(30) NOT NULL COMMENT "Cognome utente",
	telefono VARCHAR(30) NOT NULL COMMENT "Telefono utente",
	email VARCHAR(50) NOT NULL COMMENT "E-mail utente",
	username VARCHAR(50) NOT NULL COMMENT "Nome login utente",
	password VARCHAR(255) NOT NULL COMMENT "Password hash...",
	-- e.g. SHA2('myPassword',512) but 255 for future expansion
    kind ENUM('C','E','V') NOT NULL COMMENT "Commissario, Espositore/Candidato, Visitatore",
	UNIQUE LoginIdentifier (username), -- no duplicates
	UNIQUE MailIdentifier (email), -- no duplicates
	KEY Alfabetico(cognome, nome),
	PRIMARY KEY(id,kind),
    CONSTRAINT UniqueId UNIQUE(id)
);

CREATE TABLE Area (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated id",
    nome VARCHAR(50) NOT NULL COMMENT "Nome Area",
    capienza INT UNSIGNED NOT NULL COMMENT "Capienza area",
    PRIMARY KEY(id),
    CONSTRAINT NomeArea UNIQUE KEY(nome),
    CONSTRAINT NomeAreaSignificativo CHECK(nome != '')
);

CREATE TABLE Candidato (
	id INT COMMENT "Unique user id",
    kind ENUM('E') NOT NULL COMMENT "Only Espositore/Candidato here",
	cv VARCHAR(50) NOT NULL COMMENT "Link to cv file",
	tipo ENUM('A','E','P') NOT NULL COMMENT "Amatore, Esperto, Professionista",
    area INT NULL COMMENT "Area assegnata iff Espositore",
	PRIMARY KEY(id),
    CONSTRAINT CandidatoIsAUtente FOREIGN KEY (id,kind) REFERENCES Utente(id,kind)
        ON UPDATE CASCADE ON DELETE RESTRICT,   
    CONSTRAINT CandidatoAssegnato FOREIGN KEY (area) REFERENCES Area(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Commissario (
    -- nothing new here, but foreign key will be on this table when needed
	id INT COMMENT "Unique user id",
    kind ENUM('C') NOT NULL COMMENT "Only Commissario here",
	PRIMARY KEY(id),
    CONSTRAINT CommissarioIsAUtente FOREIGN KEY (id,kind) REFERENCES Utente(id,kind)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

SET GLOBAL innodb_large_prefix = 1; -- allows key length up to 3072B
CREATE TABLE Scheda (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated id",
    titolo VARCHAR(255) NOT NULL COMMENT "Titolo scheda",
    candidato INT NOT NULL COMMENT "Candidato compilatore",
    immagine VARCHAR(50) NOT NULL COMMENT "Link to image file",
	sintesi VARCHAR(2000) NOT NULL COMMENT "Sintesi scheda",
    url VARCHAR(255) NOT NULL COMMENT "url to website",
    -- approvata BOOLEAN NULL DEFAULT NULL COMMENT "Approvazione eventuale",
    PRIMARY KEY(id),
    CONSTRAINT GuessSomethingElse UNIQUE KEY(titolo, candidato),
    CONSTRAINT Compilazione FOREIGN KEY (candidato) REFERENCES Candidato(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ROW_FORMAT=DYNAMIC; -- allows GuessSomethingElse with titolo 255

CREATE TABLE Categoria (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated id",
    nome VARCHAR(50) NOT NULL COMMENT "Nome categoria",
    PRIMARY KEY(id),
    CONSTRAINT NomeCategoria UNIQUE KEY(nome),
    CONSTRAINT NomeCategoriaSignificativo CHECK(nome != '')
);

CREATE TABLE Interesse (
	scheda INT COMMENT "Unique scheda id",
	categoria INT COMMENT "Unique categoria id",
	PRIMARY KEY(scheda,categoria),
	CONSTRAINT SchedaInteresse FOREIGN KEY (scheda) REFERENCES Scheda(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT CategoriaInteresse FOREIGN KEY (categoria) REFERENCES Categoria(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Approvazione (
	scheda INT COMMENT "Unique scheda id",
    commissario INT COMMENT "Commissario approvante",
	PRIMARY KEY(scheda, commissario),
	CONSTRAINT SchedaApprovazione FOREIGN KEY (scheda) REFERENCES Scheda(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT CommissarioApprovazione FOREIGN KEY (commissario) REFERENCES Commissario(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
