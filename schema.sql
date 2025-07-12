-- =========SCHEMA PER LA GESTIONE DELLA BIGLIETTERIA DIGITALE - CASO AST S.p.A.=========

-- Elimina le tabelle se esistono già, per permettere una riesecuzione pulita dello script.
-- L'ordine è inverso a quello di creazione per rispettare i vincoli di FK.
DROP TABLE IF EXISTS Linee_Fermate;
DROP TABLE IF EXISTS Biglietti;
DROP TABLE IF EXISTS Abbonamenti;
DROP TABLE IF EXISTS Corse;
DROP TABLE IF EXISTS Passeggeri;
DROP TABLE IF EXISTS Linee;
DROP TABLE IF EXISTS Fermate;
DROP TABLE IF EXISTS Autobus;


-- -----------------------------------------------------
-- Tabella: Passeggeri
-- Contiene i dati anagrafici dei clienti registrati.
-- -----------------------------------------------------
CREATE TABLE Passeggeri (
  id_passeggero SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cognome VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  hash_password TEXT NOT NULL, -- In un sistema reale, non salvare mai password in chiaro.
  data_registrazione TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Tabella: Autobus
-- Anagrafica dei mezzi di trasporto dell'azienda.
-- -----------------------------------------------------
CREATE TABLE Autobus (
  targa VARCHAR(10) PRIMARY KEY, -- La targa è una chiave primaria naturale.
  modello VARCHAR(100),
  capacita_posti INT NOT NULL CHECK (capacita_posti > 0),
  anno_immatricolazione INT
);

-- -----------------------------------------------------
-- Tabella: Fermate
-- Anagrafica di tutte le fermate servite dalla compagnia.
-- -----------------------------------------------------
CREATE TABLE Fermate (
  id_fermata SERIAL PRIMARY KEY,
  nome_fermata VARCHAR(255) NOT NULL,
  comune VARCHAR(100) NOT NULL,
  indirizzo VARCHAR(255),
  coordinate GEOGRAPHY(POINT, 4326) -- Opzionale: per future funzionalità di geolocalizzazione.
);

-- -----------------------------------------------------
-- Tabella: Linee
-- Definisce i percorsi astratti (es. Palermo-Catania).
-- -----------------------------------------------------
CREATE TABLE Linee (
  id_linea SERIAL PRIMARY KEY,
  codice_linea VARCHAR(20) NOT NULL UNIQUE,
  nome_linea VARCHAR(255) NOT NULL,
  descrizione TEXT
);

-- -----------------------------------------------------
-- Tabella: Linee_Fermate (Tabella Associativa)
-- Mappa la sequenza ordinata delle fermate per ogni linea.
-- -----------------------------------------------------
CREATE TABLE Linee_Fermate (
  id_linea INT NOT NULL REFERENCES Linee(id_linea) ON DELETE CASCADE,
  id_fermata INT NOT NULL REFERENCES Fermate(id_fermata) ON DELETE RESTRICT,
  ordine INT NOT NULL CHECK (ordine > 0), -- Posizione della fermata nel percorso (1, 2, 3...)
  PRIMARY KEY (id_linea, id_fermata) -- La chiave primaria è la coppia linea-fermata.
);

-- -----------------------------------------------------
-- Tabella: Abbonamenti
-- Titoli di viaggio periodici acquistati dai passeggeri.
-- -----------------------------------------------------
CREATE TABLE Abbonamenti (
  id_abbonamento SERIAL PRIMARY KEY,
  id_passeggero INT NOT NULL REFERENCES Passeggeri(id_passeggero) ON DELETE RESTRICT,
  id_linea INT NOT NULL REFERENCES Linee(id_linea) ON DELETE RESTRICT,
  tipo VARCHAR(50) NOT NULL, -- Es. 'Settimanale', 'Mensile Studenti'
  data_inizio_validita DATE NOT NULL,
  data_fine_validita DATE NOT NULL,
  data_acquisto TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- Tabella: Corse
-- Esecuzione di una linea in un dato giorno e ora con un dato autobus.
-- -----------------------------------------------------
CREATE TABLE Corse (
  id_corsa SERIAL PRIMARY KEY,
  id_linea INT NOT NULL REFERENCES Linee(id_linea) ON DELETE RESTRICT,
  targa_autobus VARCHAR(10) NOT NULL REFERENCES Autobus(targa) ON DELETE RESTRICT,
  data_ora_partenza_prevista TIMESTAMPTZ NOT NULL,
  data_ora_arrivo_prevista TIMESTAMPTZ NOT NULL
);

-- -----------------------------------------------------
-- Tabella: Biglietti
-- Titoli di viaggio per una singola corsa.
-- -----------------------------------------------------
CREATE TABLE Biglietti (
  id_biglietto SERIAL PRIMARY KEY,
  id_corsa INT NOT NULL REFERENCES Corse(id_corsa) ON DELETE RESTRICT,
  id_passeggero INT NOT NULL REFERENCES Passeggeri(id_passeggero) ON DELETE RESTRICT,
  prezzo DECIMAL(6, 2) NOT NULL CHECK (prezzo >= 0),
  data_acquisto TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_validazione TIMESTAMPTZ, -- NULL se non ancora validato.
  validato BOOLEAN NOT NULL DEFAULT FALSE
);

-- Creazione di indici per ottimizzare le performance delle query più comuni.
CREATE INDEX idx_corse_data_partenza ON Corse(data_ora_partenza_prevista);
CREATE INDEX idx_passeggeri_email ON Passeggeri(email);
CREATE INDEX idx_abbonamenti_passeggero ON Abbonamenti(id_passeggero);
CREATE INDEX idx_biglietti_passeggero ON Biglietti(id_passeggero);