BEGIN TRANSACTION;

DELETE FROM
    InEarMonitor USING InEarMonitor_temp
WHERE
    InEarMonitor.model = InEarMonitor_temp.model;

DELETE FROM
    Headphone USING Headphone_temp
WHERE
    Headphone.model = Headphone_temp.model;

INSERT INTO
    InEarMonitor
SELECT
    *
FROM
    InEarMonitor_temp;

INSERT INTO
    Headphone
SELECT
    *
FROM
    Headphone_temp;

END TRANSACTION;

DROP TABLE InEarMonitor_temp;

DROP TABLE Headphone_temp;