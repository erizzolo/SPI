USE DBSUP17
-- suppose an empty db
INSERT INTO Classe VALUES
    ('5AIN', 'Istituto tecnico', 'Informatica', 'Informatica'),
    ('5BIN', 'Istituto tecnico', 'Informatica', 'Informatica'),
    ('5CIN', 'Istituto tecnico', 'Informatica', 'Informatica'),
    ('4CIN', 'Istituto tecnico', 'Informatica', 'Informatica');

INSERT INTO Studente VALUES
    (1,'Agnoletto','Matteo','2000-01-01','am',SHA2('am',512),'5CIN'),
    (2,'Beda','Mattia','2000-01-01','bm',SHA2('am',512),'5CIN'),
    (3,'Bolgan','Marco','2000-01-01','bm2',SHA2('am',512),'4CIN'),
    (4,'Bonaventura','Matteo','2000-01-01','bm3',SHA2('am',512),'5CIN'),
    (5,'Studente','Modello','2000-01-01','sm',SHA2('am',512),'5CIN');

INSERT INTO Docente VALUES
    (1,'Rizzolo','Emanuele','2000-01-01','er',SHA2('am',512)),
    (2,'Gobbo','Paolo','2000-01-01','pg',SHA2('am',512));

INSERT INTO Attivita VALUES
    ('2018-01-01 08:00:00',1,'fuffa'),
    ('2018-01-01 09:00:00',1,'more fuffa'),
    ('2018-01-01 10:00:00',1,'even more fuffa'),
    ('2018-01-01 11:00:00',1,'other fuffa'),
    ('2018-01-01 12:00:00',1,'end of fuffa'),

    ('2018-01-02 08:00:00',1,'fuffa'),
    ('2018-01-02 09:00:00',1,'more fuffa'),
    ('2018-01-02 10:00:00',1,'even more fuffa'),
    ('2018-01-02 11:00:00',1,'other fuffa'),
    ('2018-01-02 12:00:00',1,'end of fuffa'),

    ('2018-01-03 08:00:00',1,'fuffa'),
    ('2018-01-03 09:00:00',1,'more fuffa'),
    ('2018-01-03 10:00:00',1,'even more fuffa'),
    ('2018-01-03 11:00:00',1,'other fuffa'),
    ('2018-01-03 12:00:00',1,'end of fuffa');

INSERT INTO Interesse
    SELECT dataOra, responsabile, '5CIN'
        FROM Attivita;

INSERT INTO Interesse
    SELECT dataOra, responsabile, '4CIN'
        FROM Attivita
        WHERE DATE(dataOra) != '2018-01-01';

INSERT INTO CoPresenza
    SELECT dataOra, responsabile, 2, 'help'
        FROM Attivita;

-- 1 sempre assente
INSERT INTO Assenza
    SELECT DISTINCT 1, DATE(dataOra), 'G', NULL, NULL, 1, NULL
        FROM Attivita;

-- 2 entra sempre alla 3 ora
INSERT INTO Assenza
    SELECT DISTINCT 2, DATE(dataOra), 'I', NULL, NULL, 1, '10:00:00'
        FROM Attivita;

-- 3 esce sempre alla 4 ora
INSERT INTO Assenza
    SELECT DISTINCT 3, DATE(dataOra), 'U', NULL, NULL, 1, '11:00:00'
        FROM Attivita;

-- 4 entra sempre alla 2 ora ed esce sempre alla 4 ora
INSERT INTO Assenza
    SELECT DISTINCT 4, DATE(dataOra), 'I', NULL, NULL, 1, '10:00:00'
        FROM Attivita;
INSERT INTO Assenza
    SELECT DISTINCT 4, DATE(dataOra), 'U', NULL, NULL, 1, '11:00:00'
        FROM Attivita;
