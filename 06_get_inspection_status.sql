 CREATE OR REPLACE PROCEDURE GetInspectionStatus (
    p_license_plate IN VARCHAR2,
    p_status OUT SYS_REFCURSOR
)
AS
BEGIN
    OPEN p_status FOR
        SELECT 
            v.license_plate AS rendszam,
            i.inspection_date AS vizsgalat_datum,
            i.result AS eredmeny,
            i.remarks AS megjegyzes,
            i.expiry_date AS lejarati_datum
        FROM 
            vehicles v
        INNER JOIN 
            inspections i ON v.vehicleID = i.vehicleID
        WHERE 
            v.license_plate = p_license_plate;
END;
/

DECLARE
    cur SYS_REFCURSOR;
    rendszam VARCHAR2(10);
    vizsgalat_datum DATE;
    eredmeny VARCHAR2(10);
    megjegyzes VARCHAR2(500);
    lejarati_datum DATE;
BEGIN
    rendszam := '&rendszam'; 

    GetInspectionStatus(rendszam, cur);
    
    LOOP
        FETCH cur INTO rendszam, vizsgalat_datum, eredmeny, megjegyzes, lejarati_datum;
        EXIT WHEN cur%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Rendszám: ' || rendszam);
        DBMS_OUTPUT.PUT_LINE('Vizsgálat dátuma: ' || TO_CHAR(vizsgalat_datum, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('Eredmény: ' || eredmeny);
        DBMS_OUTPUT.PUT_LINE('Megjegyzés: ' || megjegyzes);
        DBMS_OUTPUT.PUT_LINE('Lejárati dátum: ' || TO_CHAR(lejarati_datum, 'YYYY-MM-DD'));
        DBMS_OUTPUT.PUT_LINE('--------------------------');
    END LOOP;

    CLOSE cur;
END;
/
