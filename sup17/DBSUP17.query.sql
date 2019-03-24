USE DBSUP17

SET @STUDENTE = 1;
SELECT data, tipo, IFNULL(ora, 'N/D')
    FROM Assenza
    WHERE studente = @STUDENTE
    ORDER BY data, tipo;

SELECT c.sigla, s.cognome, s.nome, s.nascita
    FROM Studente s JOIN Classe c ON(c.sigla = s.classe)
    WHERE NOT EXISTS ( SELECT 1 FROM Assenza WHERE studente = id )
    ORDER BY c.sigla, s.cognome, s.nome, s.nascita;

SET @LIMITE = 4;
SELECT c.sigla, s.cognome, s.nome, s.nascita, COUNT(*) AS OreAssenza
    FROM Studente s
        JOIN Classe c ON(c.sigla = s.classe)
        JOIN Interesse i ON(c.sigla = i.classe)
        JOIN Attivita l USING (dataOra, responsabile)
        JOIN Assenza a ON(s.id = a.studente)
    WHERE a.data = DATE(l.dataOra) AND
        (a.tipo = 'G' OR
         (a.tipo = 'I' AND TIME(l.dataOra) < a.ora) OR
         (a.tipo = 'U' AND TIME(l.dataOra) >= a.ora))
    GROUP BY s.id
    HAVING COUNT(*) > @LIMITE
    ORDER BY c.sigla, s.cognome, s.nome, s.nascita;
