# Soluzione esempio seconda prova
## Variante con specializzazione di Noleggio
In questo caso la specializzazione può essere basata sulla avvenuta o meno conclusione del noleggio:
* Entità Noleggio(generica) con attributo tempo inizio, che partecipa alle associazioni Interesse (1:1) con Bicicletta (0:1), Responsabilità (1:1) con Utente (0:N) e Prelievo (1:1) con Stazione (0:N)
* Entità NoleggioInCorso senza altri attributi
* Entità NoleggioConcluso con attributo ulteriore tempo fine, che partecipa all'associazione Riconsegna (1:1) con Stazione (0:N)
Si osservi però che all'associazione Prelievo l'entità Bicicletta partecipa con cardinalità (0:1) se il noleggio è in corso, (0:N) se il noleggio è concluso.
### Progettazione logica
L'osservazione precedente ci permette di tradurre la specializzazione Noleggio in modo *particolare*, e cioè inserendo i dati relativi all'eventuale noleggio in corso nella tabella Bicicletta, e tutti i dati in una tabella NoleggioConcluso separata. Utilizzando per brevità la versione di Stazione con chiave surrogata, si arriva al seguente schema logico:
* Stazione(**id**, indirizzo!, [totali], [liberi], [occupati])
* Utente (**id**, cognome, nome, telefono, email!, username!, password, smartcard!, card type, card number, card expiry, report interval, report type, last report)
* Bicicletta(**id**, *stazione*, *utente*?, tempoPrelievo?)
* NoleggioConcluso(***bicicletta***, ***utente***, *stazionePrelievo*, **tempoPrelievo**, *stazioneRiconsegna*, tempoRiconsegna, costo)

Si noti che l'attributo stazione in Bicicletta assumerà ora due significati (eventualmente distinguibili con campi calcolati e/o view):
* stazione attuale se la bibicletta non è in uso: utente e tempoPrelievo NULL
* stazione di prelievo se la bibicletta è in uso: utente e tempoPrelievo NOT NULL
### Progettazione fisica
Con questa possibilità cambiano ovviamente le operazioni per prelievo e riconsegna, ed i relativi trigger.  
* [ ] E' possibile far corrispondere ciascuna operazione ad un semplice update di Bicicletta e gestire in un unico trigger i diversi casi: prelievo | riconsegna.  

Prelievo della bicicletta con codice @BICI da parte dell'utente con codice @USER:
````sql
UPDATE Bicicletta
  SET utente = @USER, tempoPrelievo = NOW()
  WHERE id = @BICI;
````
Riconsegna della bicicletta con codice @BICI alla stazione codice @STATION [da parte dell'utente con codice @USER]:
````sql
UPDATE Bicicletta
  SET stazione = @STATION, utente = NULL, dataOraPrelievo = NULL
  WHERE id = @BICI;
````
L'aggiornamento sarà legato ad un unico trigger che provvede a mantenere coerenti i dati del db:
````sql

````

Si inserisce il codice per la creazione del database anche se non richiesto dalla traccia:  
[script di creazione schema](DBSIM191noleggio.sql)
## Progettazione pagine web
idem
### a) mappa delle stazioni
idem
### b) biciclette in uso
idem
### Codifica pagine web
idem ma la query diventa più semplice:
Per semplicità si sceglie di codificare la pagina relativa alla richiesta b).
````sql
SELECT *
  FROM Bicicletta b
    JOIN Utente u ON (u.id = b.utente)
    JOIN Stazione s ON (s.id = b.stazione);
````
Sono escluse dal JOIN (INNER) le biciclette non in uso.

Per il resto non cambia quasi nulla.
