DROP DATABASE IF EXISTS DBBikeRental;
CREATE DATABASE  IF NOT EXISTS DBBikeRental;
USE DBBikeRental
CREATE TABLE Utente (
	id INT AUTO_INCREMENT COMMENT "Unique auto generated user id",
	nome VARCHAR(50) NOT NULL COMMENT "Nome utente",
	cognome VARCHAR(50) NOT NULL COMMENT "Cognome utente",
	email VARCHAR(50) NOT NULL COMMENT "Indirizzo e-mail utente",
	telefono VARCHAR(50) NOT NULL COMMENT "Telefono utente",
	username VARCHAR(50) NOT NULL COMMENT "Nome login utente",
	password VARCHAR(128) NOT NULL COMMENT "Password hash SHA-2 512 bits",
	-- e.g. SHA2('myPassword',512)
	smartcard VARCHAR(10) NOT NULL COMMENT "Smart card code",
	cardType VARCHAR(10) NOT NULL COMMENT "Credit card type",
	cardNumber VARCHAR(20) NOT NULL COMMENT "Credit card number",
	cardExpiry DATE NOT NULL COMMENT "Credit card expiry date",
	reportInterval INT NOT NULL COMMENT "Report interval in days?!",
	reportType INT NOT NULL COMMENT "Report type ...",
	lastReport DATE NULL DEFAULT NULL COMMENT "Last report date",
	UNIQUE Smartcard (smartcard), -- no duplicates
	UNIQUE LoginIdentifier (username), -- no duplicates
	UNIQUE MailIdentifier (email), -- no duplicates
	PRIMARY KEY(id)
);
CREATE TABLE Stazione (
	id INT AUTO_INCREMENT COMMENT "Unique station id",
	indirizzo VARCHAR(100) NOT NULL COMMENT "Indirizzo stazione",
	liberi INT NOT NULL DEFAULT 0 COMMENT "Slot liberi",
	occupati INT NOT NULL DEFAULT 50 COMMENT "Slot occupati",
	totali INT NOT NULL DEFAULT 50 COMMENT "Slot totali",
	PRIMARY KEY(id),
    CONSTRAINT TertiumNonDatur CHECK(liberi + occupati = totali),
	UNIQUE Placement (indirizzo) -- no two stations at the same address
);
CREATE TABLE Bicicletta (
	id INT AUTO_INCREMENT COMMENT "Unique bike id",
	stazione INT NULL COMMENT "Stazione attuale",
	PRIMARY KEY(id),
	CONSTRAINT Position FOREIGN KEY (stazione) REFERENCES Stazione(id)
		ON UPDATE CASCADE ON DELETE RESTRICT
);
CREATE TABLE Noleggio (
	bicicletta INT NOT NULL COMMENT "Bike id",
	utente INT NOT NULL COMMENT "User id",
	stazPrelievo INT NOT NULL COMMENT "Stazione prelievo",
	tempoPrelievo TIMESTAMP NOT NULL COMMENT "Istante prelievo",
	stazRiconsegna INT NULL DEFAULT NULL COMMENT "Stazione riconsegna",
	tempoRiconsegna TIMESTAMP NULL DEFAULT NULL COMMENT "Istante riconsegna",
    costo DECIMAL(6,2) NULL DEFAULT NULL COMMENT "Costo noleggio, dopo riconsegna",
	PRIMARY KEY(bicicletta, utente, tempoPrelievo),
	CONSTRAINT Utilizzo FOREIGN KEY (bicicletta) REFERENCES Bicicletta(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT Prelievo FOREIGN KEY (stazPrelievo) REFERENCES Stazione(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT Riconsegna FOREIGN KEY (stazPrelievo) REFERENCES Stazione(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT Responsabile FOREIGN KEY (ytente) REFERENCES Utente(id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT NoleggioFinito CHECK(ISNULL(stazRiconsegna) = ISNULL(tempoRiconsegna))
);
DELIMITER //
CREATE TRIGGER NuovoNoleggio AFTER INSERT ON Noleggio FOR EACH ROW
  BEGIN
    UPDATE Bicicletta SET stazione = NULL WHERE id = NEW.bicicletta;
    UPDATE Stazione SET liberi = liberi + 1, occupati = occupati - 1
      WHERE id = NEW.stazPrelievo;
  END;
//
CREATE TRIGGER FineNoleggio AFTER UPDATE ON Noleggio FOR EACH ROW
  BEGIN
    UPDATE Bicicletta SET stazione = NEW.stazRiconsegna WHERE id = NEW.bicicletta;
    UPDATE Stazione SET liberi = liberi - 1, occupati = occupati + 1
      WHERE id = NEW.stazRiconsegna;
  END;
//
DELIMITER ;
