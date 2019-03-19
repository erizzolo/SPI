# Schema Soluzione
Le tracce di seconda prova presentano una struttura generale comune:
## Prima parte
0. Descrizione realtà e ipotesi aggiuntive
1. Progetto database (concettuale, logico e fisico)
2. Codifica in linguaggio SQL (DDL e/o DML)
3. Progetto applicazione WEB
4. Codifica di pagine web significative (HTML,CSS,php,Javascript)
## Seconda parte
* integrazioni alla prima parte
* normalizzazione
* quesiti teorici (associazioni E/R, indici, ...)
## Suggerimenti per lo svolgimento
## Prima parte
### Descrizione realtà e ipotesi aggiuntive
Significa chiarire eventuali ambiguità del testo con ipotesi ragionevoli, non eccessivamente semplificative né (casi di masochismo a parte) complicative, che possano motivare le scelte successive e limitare l'ambito della realtà di riferimento.
Evitare, se possibile, parafrasi del testo.
Se possibile, individuare (motivando o comunque giustificando) le architetture generali.
### Progetto database
#### concettuale
Prodotto di questa parte è uno schema E/R ed eventualmente un dizionario dati (anche solo in parte).
E/R non ha chiavi esterne!!! Ha invece attributi, cardinalità (min, max) e chiavi (primarie).
Non è vietato illustrare le scelte fatte con alcune frasi in linguaggio naturale.
Verificare che le query dei punti successivi siano eseguibili.
#### logico
Deve essere congruente con il modello E/R.
Poichè in qualche caso la traduzione non è unica, si deve motivare la scelta effettuata.
Il prodotto di questa fase è un elenco di relazioni, ovvero tabelle, con attributi e vincoli (di dominio, NULL, PK, FK, UNIQUE, ...).
#### fisico
Motivando, si possono introdurre ottimizzazioni quali chiavi surrogate.
Per i campi calcolati, dire se sono memorizzati (e come sono aggiornati) oppure no (view per il calcolo).
### Codifica in linguaggio SQL (DDL e/o DML)
Se richiesto DDL, presentare casi significativi.
Per le query, identificare i parametri e utilizzare una delle sintassi conosciute: ad es. :dataIniziale, @dataIniziale
Non è fondamentale conoscere tutte le funzioni SQL disponibili.
Attenzione a funzioni di raggruppamento (MIN, MAX, COUNT, AVG, ...) senza clausola GROUP BY.
###  Progetto applicazione WEB
* [ ] continuare...



