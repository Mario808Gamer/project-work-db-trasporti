-- =========POPOLAMENTO CON DATI DI ESEMPIO - DATABASE AST S.p.A.=========
-- L'ordine di inserimento è fondamentale per rispettare i vincoli delle chiavi esterne.

-- 1. Popolamento Passeggeri
INSERT INTO Passeggeri (nome, cognome, email, hash_password) VALUES
('Mario', 'Rossi', 'mario.rossi@email.com', 'hashed_password_placeholder_123'),
('Giulia', 'Verdi', 'giulia.verdi@email.com', 'hashed_password_placeholder_456'),
('Luca', 'Bianchi', 'luca.bianchi@email.com', 'hashed_password_placeholder_789'),
('Sofia', 'Neri', 'sofia.neri@email.com', 'hashed_password_placeholder_101');

-- 2. Popolamento Autobus
INSERT INTO Autobus (targa, modello, capacita_posti, anno_immatricolazione) VALUES
('GA123BC', 'Mercedes-Benz Tourismo', 54, 2022),
('FY456WE', 'Iveco Bus Evadys', 56, 2023),
('EX789ZT', 'Setra S 516 HD', 52, 2021);

-- 3. Popolamento Fermate
-- IDs: 1-Palermo, 2-Aeroporto PA, 3-Castellammare, 4-Trapani, 5-Catania, 6-Taormina, 7-Messina
INSERT INTO Fermate (nome_fermata, comune) VALUES
('Stazione Centrale', 'Palermo'),                      -- ID 1
('Aeroporto Falcone Borsellino', 'Cinisi'),           -- ID 2
('Viale Umberto I', 'Castellammare del Golfo'),       -- ID 3
('Porto', 'Trapani'),                                 -- ID 4
('Terminal Bus (Via Archimede)', 'Catania'),          -- ID 5
('Terminal Bus', 'Taormina'),                         -- ID 6
('Piazza della Repubblica (Stazione FS)', 'Messina'); -- ID 7

-- 4. Popolamento Linee
INSERT INTO Linee (codice_linea, nome_linea, descrizione) VALUES
('AST-001', 'Palermo - Trapani Porto', 'Servizio rapido tra Palermo e Trapani con fermata intermedia all''aeroporto.'),
('AST-002', 'Catania - Messina', 'Servizio che collega Catania e Messina con fermata turistica a Taormina.');

-- 5. Popolamento Linee_Fermate (definisce i percorsi)
-- Linea 1: Palermo -> Aeroporto -> Castellammare -> Trapani
INSERT INTO Linee_Fermate (id_linea, id_fermata, ordine) VALUES
(1, 1, 1), -- Palermo
(1, 2, 2), -- Aeroporto
(1, 3, 3), -- Castellammare
(1, 4, 4); -- Trapani

-- Linea 2: Catania -> Taormina -> Messina
INSERT INTO Linee_Fermate (id_linea, id_fermata, ordine) VALUES
(2, 5, 1), -- Catania
(2, 6, 2), -- Taormina
(2, 7, 3); -- Messina

-- 6. Popolamento Corse (viaggi effettivi in date diverse)
-- IDs: 1-Corsa di oggi, 2-Corsa di oggi, 3-Corsa passata, 4-Corsa futura
INSERT INTO Corse (id_linea, targa_autobus, data_ora_partenza_prevista, data_ora_arrivo_prevista) VALUES
(1, 'GA123BC', '2025-06-23 08:30:00+02', '2025-06-23 10:30:00+02'), -- Corsa 1 (oggi)
(2, 'FY456WE', '2025-06-23 09:00:00+02', '2025-06-23 10:45:00+02'), -- Corsa 2 (oggi)
(1, 'GA123BC', '2025-06-20 17:00:00+02', '2025-06-20 19:00:00+02'), -- Corsa 3 (passata)
(2, 'EX789ZT', '2025-06-28 11:00:00+02', '2025-06-28 12:45:00+02'); -- Corsa 4 (futura)

-- 7. Popolamento Abbonamenti
-- Abbonamento valido per Mario Rossi sulla linea Palermo-Trapani per il mese corrente
INSERT INTO Abbonamenti (id_passeggero, id_linea, tipo, data_inizio_validita, data_fine_validita) VALUES
(1, 1, 'Mensile Ordinario', '2025-06-01', '2025-06-30');

-- Abbonamento scaduto per Giulia Verdi
INSERT INTO Abbonamenti (id_passeggero, id_linea, tipo, data_inizio_validita, data_fine_validita) VALUES
(2, 2, 'Mensile Studenti', '2025-05-01', '2025-05-31');

-- 8. Popolamento Biglietti
-- Luca Bianchi acquista un biglietto per la corsa di oggi Palermo-Trapani
INSERT INTO Biglietti (id_corsa, id_passeggero, prezzo, validato, data_validazione) VALUES
(1, 3, 12.50, TRUE, '2025-06-23 08:32:15+02'); -- Già validato

-- Giulia Verdi, con abbonamento scaduto, acquista un biglietto per la corsa Catania-Messina
INSERT INTO Biglietti (id_corsa, id_passeggero, prezzo) VALUES
(2, 2, 8.70); -- Non ancora validato

-- Sofia Neri acquista un biglietto per un viaggio futuro
INSERT INTO Biglietti (id_corsa, id_passeggero, prezzo) VALUES
(4, 4, 8.70); -- Non ancora validato

-- Mario Rossi acquista un biglietto per un viaggio passato (per lo storico)
INSERT INTO Biglietti (id_corsa, id_passeggero, prezzo, validato) VALUES
(3, 1, 12.50, TRUE);

-- Controllo finale: Messaggio di successo
-- Se lo script viene eseguito senza errori, il database è popolato correttamente.