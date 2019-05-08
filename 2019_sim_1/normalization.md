# Testo della prova:
Considerata la relazione
````
QUADRO (Cod_Quadro, Cod_Museo, Titolo_Quadro, Nome_Museo, Citta_Museo, Prezzo, DataInizioEsposizione, DataFineEsposizione)
````
si verifichino le proprietà di normalizzazione e si proponga, eventualmente, uno schema equivalente che rispetti la terza forma normale, motivando le scelte effettuate.
## Soluzione
### Ipotesi aggiuntive
Non è chiaro a cosa si riferisca l'attributo *Prezzo*, né se per Esposizione si intenda una mostra temporanea di più quadri tenutasi in un museo (ad es. "Gli impressionisti francesi", "Disegni di Picasso", ...) oppure la presenza del quadro singolo (ad es. "Esposizione della Gioconda alle Gallerie dell'Accademia", ...).  
Per considerare varie possibilità si userà:
* *PrezzoQuadro* prezzo (valore) del quadro
* *PrezzoMuseo* prezzo del biglietto di ingresso al Museo
* *PrezzoMostra* prezzo del biglietto di ingresso alla mostra
* *PrezzoEsposizione* costo dell'esposizione del quadro (ad es. pagato dal museo al possessore privato del quadro)
* *DataInizioEsposizione*, *DataFineEsposizione* periodo dell'esposizione del singolo quadro
* *DataInizioMostra*, *DataFineMostra* periodo della mostra

Per chiarezza si considereranno separatamente le due ipotesi "mostra" ed "esposizione".  
Ovviamente il candidato **dovrebbe** aver esplicitato quale delle due interpretazioni ritiene valida e quindi svolgere solo quella.
### Ipotesi "mostra"
Considereremo la relazione:
````
QUADRO (Cod_Quadro, Cod_Museo, Titolo_Quadro, Nome_Museo, Citta_Museo, PrezzoQuadro, PrezzoMuseo, PrezzoMostra, DataInizioMostra, DataFineMostra)
````
#### Verifica 1NF
La relazione indicata non è in 1NF poiché non vi è chiave primaria.
Una possibile scelta di attributi è la seguente:
Cod_Quadro, Cod_Museo, DataInizioMostra.
#### Dipendenze funzionali
Sono presenti le seguenti dipendenze funzionali:
1. Cod_Quadro -> Titolo_Quadro, Prezzo_Quadro
2. Cod_Museo -> Nome_Museo, Citta_Museo, PrezzoMuseo
3. Cod_Museo, DataInizioMostra -> DataFineMostra, PrezzoMostra
#### Verifica 2NF
La relazione indicata non è in 2NF poiché vi sono dipendenze funzionali parziali (tutte in questo caso).
#### Decomposizione in 2NF
Riconduciamo lo schema a 2NF creando una nuova relazione per ogni dipendenza parziale elencata, con gli attributi determinanti come chiave primaria e gli attributi determinati, eliminando questi ultimi dalla relazione originale.
* QUADRI(**Cod_Quadro**, Titolo_Quadro, Prezzo_Quadro)
* MUSEI(**Cod_Museo**, Nome_Museo, Citta_Museo, PrezzoMuseo)
* MOSTRE(_**Cod_Museo**_, **DataInizioMostra**, DataFineMostra, PrezzoMostra)

La relazione originaria (ridenominata per chiarezza) diviene:  
* QUADRI_IN_MOSTRA(_**Cod_Quadro**_ ,_**Cod_Museo**_, _**DataInizioMostra**_)  ed indica quali quadri sono presenti ad una determinata mostra.  

N.B. - La chiave esterna (_**Cod_Museo**_, _**DataInizioMostra**_) è composta da due attributi e fa riferimento alla chiave primaria di MOSTRE.
#### Verifica 3NF
La relazione indicata è in 3NF poiché non vi sono altre dipendenze funzionali.
### Decomposizione in 3NF
Come sopra.
### Ipotesi "esposizione"
Considereremo la relazione
````
QUADRO (Cod_Quadro, Cod_Museo, Titolo_Quadro, Nome_Museo, Citta_Museo, PrezzoQuadro, PrezzoMuseo, PrezzoEsposizione, DataInizioEsposizione, DataFineEsposizione)
````
#### Verifica 1NF
La relazione indicata non è in 1NF poiché non vi è chiave primaria.
Una possibile scelta di attributi è la seguente:
Cod_Quadro, Cod_Museo, DataInizioEsposizione.  
#### Dipendenze funzionali
Sono presenti le seguenti dipendenze funzionali:
1. Cod_Quadro -> Titolo_Quadro, Prezzo_Quadro
2. Cod_Museo -> Nome_Museo, Citta_Museo, PrezzoMuseo
3. Cod_Museo, Cod_Quadro, DataInizioEsposizione -> DataFineEsposizione, PrezzoEsposizione
#### Verifica 2NF
La relazione indicata non è in 2NF poiché vi sono dipendenze funzionali parziali (tutte in questo caso).
#### Decomposizione in 2NF
Riconduciamo lo schema a 2NF creando una nuova relazione per ogni dipendenza parziale elencata, con gli attributi determinanti come chiave primaria e gli attributi determinati, eliminando questi ultimi dalla relazione originale.
* QUADRI(**Cod_Quadro**, Titolo_Quadro, Prezzo_Quadro)
* MUSEI(**Cod_Museo**, Nome_Museo, Citta_Museo, PrezzoMuseo)
* ESPOSIZIONI(_**Cod_Museo**_,_**Cod_Quadro**_, **DataInizioEsposizione**, DataFineEsposizione, PrezzoEsposizione)

La relazione originaria diviene:  
* QUADRO (Cod_Quadro, Cod_Museo, DataInizioEsposizione)  

ed è quindi ridondante poichè compresa in ESPOSIZIONI.
#### Verifica 3NF
La relazione indicata è in 3NF poiché non vi sono altre dipendenze funzionali.
#### Decomposizione in 3NF
Come sopra.
