# Progettazione Database per Biglietteria Digitale - Caso Studio AST S.p.A.

Questo repository contiene gli artefatti tecnici del project work per la tesi di laurea in Informatica per le Aziende Digitali.

**Autore:** Mario Piazza
**Matricola:** 0312200586

## Descrizione del Progetto

Il progetto consiste nella progettazione e implementazione di uno schema di database relazionale per supportare i servizi di biglietteria digitale di un'azienda di trasporto pubblico locale, con un'analisi specifica applicata al caso di studio di AST S.p.A. (Azienda Siciliana Trasporti).

Il database è stato progettato per gestire in modo efficiente e coerente le anagrafiche di passeggeri, linee, corse, fermate e mezzi, oltre a gestire diverse tipologie di titoli di viaggio come biglietti di corsa semplice e abbonamenti periodici.

## Tecnologie Utilizzate

* **DBMS:** PostgreSQL
* **Linguaggi:** SQL
* **Modellazione:** Diagramma Entità-Relazione (E-R)
* **Controllo di Versione:** Git / GitHub

## Struttura del Repository

Questo repository contiene i seguenti script SQL:

* **`schema.sql`**: Contiene i comandi `CREATE TABLE` per generare l'intera struttura del database, inclusi vincoli, chiavi primarie/esterne e indici.
* **`data.sql`**: Contiene i comandi `INSERT INTO` per popolare il database con un set di dati di esempio realistici, necessari per testare le funzionalità.
* **`queries.sql`**: Contiene 5 query SQL rappresentative che dimostrano la capacità del database di rispondere a domande di business complesse.
* **`erDiagramm oppure Diagramma`**: per la sola visualizzazione in chiaro dello schema entità relazioni del nostro DataBase.


## Come Utilizzare gli Script

Per ricreare e testare il database in un ambiente PostgreSQL locale, eseguire gli script nel seguente ordine:

1.  Eseguire `schema.sql` per creare le tabelle e le relazioni.
2.  Eseguire `data.sql` per popolare le tabelle.
3.  Eseguire `queries.sql` per interrogare i dati.
