-- Query 1: Ricerca Itinerari Disponibili
SELECT
    c.id_corsa,
    l.nome_linea,
    c.data_ora_partenza_prevista,
    c.data_ora_arrivo_prevista,
    a.targa AS targa_autobus
FROM Corse c
JOIN Linee l ON c.id_linea = l.id_linea
JOIN Autobus a ON c.targa_autobus = a.targa
WHERE
    -- Filtra per la data richiesta
    DATE(c.data_ora_partenza_prevista AT TIME ZONE 'Europe/Rome') = '2025-06-23'
AND
    -- Sotto-query per trovare le linee che contengono la tratta richiesta nell'ordine corretto
    c.id_linea IN (
        SELECT lf1.id_linea
        FROM Linee_Fermate lf1
        JOIN Linee_Fermate lf2 ON lf1.id_linea = lf2.id_linea
        WHERE
            lf1.id_fermata = 1 -- ID della fermata 'Stazione Centrale', Palermo
            AND lf2.id_fermata = 4 -- ID della fermata 'Porto', Trapani
            AND lf1.ordine < lf2.ordine -- Assicura che la partenza venga prima dell'arrivo
    );

-- Query 2: Storico Viaggi di un Cliente
SELECT
    p.nome,
    p.cognome,
    'Biglietto Corsa Semplice' AS tipo_titolo,
    b.data_acquisto,
    l.nome_linea,
    b.prezzo
FROM Biglietti b
JOIN Passeggeri p ON b.id_passeggero = p.id_passeggero
JOIN Corse c ON b.id_corsa = c.id_corsa
JOIN Linee l ON c.id_linea = l.id_linea
WHERE b.id_passeggero = 1 -- ID di Mario Rossi

UNION ALL

SELECT
    p.nome,
    p.cognome,
    a.tipo AS tipo_titolo,
    a.data_acquisto,
    l.nome_linea,
    NULL AS prezzo -- Gli abbonamenti non hanno un prezzo di corsa singola
FROM Abbonamenti a
JOIN Passeggeri p ON a.id_passeggero = p.id_passeggero
JOIN Linee l ON a.id_linea = l.id_linea
WHERE a.id_passeggero = 1 -- ID di Mario Rossi

ORDER BY data_acquisto DESC;

-- Query 3: Validazione Titolo di Viaggio
WITH CorsaAttuale AS (
    -- Dati della corsa da verificare
    SELECT id_corsa, id_linea FROM Corse WHERE id_corsa = 1
)
SELECT
    CASE
        WHEN EXISTS (
            -- Cerco un biglietto valido per questa corsa
            SELECT 1 FROM Biglietti
            WHERE id_passeggero = 1 AND id_corsa = (SELECT id_corsa FROM CorsaAttuale) AND validato = FALSE
        )
        OR EXISTS (
            -- O cerco un abbonamento valido per la linea di questa corsa e per la data odierna
            SELECT 1 FROM Abbonamenti
            WHERE id_passeggero = 1
              AND id_linea = (SELECT id_linea FROM CorsaAttuale)
              AND CURRENT_DATE BETWEEN data_inizio_validita AND data_fine_validita
        )
        THEN 'AUTORIZZATO'
        ELSE 'NON AUTORIZZATO'
    END AS stato_validazione;

-- Query 4: Dettaglio Percorso Linea
SELECT
    lf.ordine,
    f.nome_fermata,
    f.comune
FROM Linee_Fermate lf
JOIN Fermate f ON lf.id_fermata = f.id_fermata
WHERE lf.id_linea = 1 -- ID della linea Palermo - Trapani
ORDER BY lf.ordine ASC;

-- Query 5: Report Occupazione Corsa
SELECT
    c.id_corsa,
    l.nome_linea,
    a.capacita_posti,
    COUNT(b.id_biglietto) AS biglietti_venduti,
    ROUND((COUNT(b.id_biglietto) * 100.0 / a.capacita_posti), 2) AS percentuale_occupazione
FROM Corse c
JOIN Autobus a ON c.targa_autobus = a.targa
JOIN Linee l ON c.id_linea = l.id_linea
LEFT JOIN Biglietti b ON c.id_corsa = b.id_corsa
WHERE c.id_corsa = 1
GROUP BY c.id_corsa, l.nome_linea, a.capacita_posti;
