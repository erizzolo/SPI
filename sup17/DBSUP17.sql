DROP DATABASE IF EXISTS DBSUP17;
CREATE DATABASE  IF NOT EXISTS DBSUP17;
USE DBSUP17
CREATE TABLE Classe (
	sigla VARCHAR(6) COMMENT "Unique identifier",
	indirizzo VARCHAR(50) NOT NULL COMMENT "Indirizzo di studi",
	articolazione VARCHAR(50) NULL COMMENT "Articolazione indirizzo",
	opzione VARCHAR(50) NULL COMMENT "Opzione articolazione",
	PRIMARY KEY(sigla)
);
CREATE TABLE Studente (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated user id",
	nome VARCHAR(50) NOT NULL COMMENT "Nome studente",
	cognome VARCHAR(50) NOT NULL COMMENT "Cognome studente",
	nascita DATE NOT NULL COMMENT "Data nascita studente",
	username VARCHAR(50) NOT NULL COMMENT "Nome login studente",
	password VARCHAR(128) NOT NULL COMMENT "Password hash SHA-2 512 bits",
	-- e.g. SHA2('myPassword',512)
    classe VARCHAR(6) NOT NULL COMMENT "Classe di iscrizione",
	UNIQUE LoginIdentifier (username), -- no duplicates
	KEY Alfabetico(cognome, nome),
	PRIMARY KEY(id),
	CONSTRAINT Iscrizione FOREIGN KEY (classe) REFERENCES Classe(sigla)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE Docente (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated user id",
	nome VARCHAR(50) NOT NULL COMMENT "Nome docente",
	cognome VARCHAR(50) NOT NULL COMMENT "Cognome docente",
	nascita DATE NOT NULL COMMENT "Data nascita docente",
	username VARCHAR(50) NOT NULL COMMENT "Nome login docente",
	password VARCHAR(128) NOT NULL COMMENT "Password hash SHA-2 512 bits",
	-- e.g. SHA2('myPassword',512)
	UNIQUE LoginIdentifier (username), -- no duplicates
	KEY Alfabetico(cognome, nome),
	PRIMARY KEY(id)
);
CREATE TABLE Attivita (
    dataOra DATETIME COMMENT "DataOra svolgimento",
    responsabile INT NOT NULL COMMENT "Docente responsabile",
    materia VARCHAR(50) NOT NULL COMMENT "Materia dell'attività",
    PRIMARY KEY(dataOra, responsabile),
    CONSTRAINT Responsabilita FOREIGN KEY (responsabile) REFERENCES Docente(id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE Interesse (
    dataOra DATETIME COMMENT "DataOra svolgimento",
	responsabile INT NOT NULL COMMENT "Docente responsabile",
	classe VARCHAR(6) NOT NULL COMMENT "Classe coinvolta",
	PRIMARY KEY(dataOra, responsabile, classe),
	CONSTRAINT AttivitaInteresse FOREIGN KEY (dataOra, responsabile) REFERENCES Attivita(dataOra, responsabile)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT ClasseInteresse FOREIGN KEY (classe) REFERENCES Classe(sigla)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE CoPresenza (
    dataOra DATETIME COMMENT "DataOra svolgimento",
	responsabile INT NOT NULL COMMENT "Docente responsabile",
	presente INT NOT NULL COMMENT "Docente presente",
	tipo VARCHAR(20) NOT NULL COMMENT "Tipo CoPresenza",
    CONSTRAINT NoSelfies CHECK(presente != responsabile),
	PRIMARY KEY(dataOra, responsabile, presente),
	CONSTRAINT AttivitaCoPresenza FOREIGN KEY (dataOra, responsabile) REFERENCES Attivita(dataOra, responsabile)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT CoPresente FOREIGN KEY (presente) REFERENCES Docente(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE Assenza (
	studente INT NOT NULL COMMENT "Studente Assente",
    data DATE COMMENT "DataOra svolgimento",
    tipo ENUM('G','I','U') COMMENT "Giorno, Ingresso ritardo, Uscita anticipo",
	registrante INT NOT NULL COMMENT "Docente registrante",
    ora TIME NULL DEFAULT NULL COMMENT "Ora se tipo = I/U",
    CONSTRAINT tipologia CHECK(ISNULL(ora) = (tipo = 'G')),
	PRIMARY KEY(studente, data, tipo, registrante),
	CONSTRAINT Registrazione FOREIGN KEY (registrante) REFERENCES Docente(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT Assente FOREIGN KEY (studente) REFERENCES Studente(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
