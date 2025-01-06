CREATE OR REPLACE PACKAGE pkg_service AS

    PROCEDURE show_expired_cars;
    PROCEDURE top_inspection_month;
    PROCEDURE inspections_7_days;
    PROCEDURE customers_not_visited;
    PROCEDURE data_insert;
    PROCEDURE GetInspectionStatus (
    p_license_plate IN VARCHAR2,
    p_status OUT SYS_REFCURSOR
    );
    PROCEDURE DisplayInspectionStatus;

END pkg_service;
/

CREATE OR REPLACE PACKAGE BODY pkg_service AS

    -- Lejárt műszakival rendelkező autók
   PROCEDURE show_expired_cars IS
    CURSOR expired_cars_cursor IS
        SELECT v.license_plate,
               v.brand,
               v.model,
               v.year_of_manifacture,
               c.name AS owner_name,
               c.phone_number,
               i.inspection_date,
               i.remarks
          FROM vehicles v
          JOIN customers c
            ON v.owner_id = c.customerid
          JOIN inspections i
            ON v.vehicleid = i.vehicleid
         WHERE i.expiry_date < SYSDATE;

    expired_car_record expired_cars_cursor%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Lejárt műszakival rendelkező autók listája:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Rendszám | Márka | Modell | Gyártási év | Tulajdonos neve | Telefonszám | Műszaki dátuma | Megjegyzés');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');

    FOR expired_car_record IN expired_cars_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            expired_car_record.license_plate || ' | ' ||
            expired_car_record.brand || ' | ' ||
            expired_car_record.model || ' | ' ||
            expired_car_record.year_of_manifacture || ' | ' ||
            expired_car_record.owner_name || ' | ' ||
            expired_car_record.phone_number || ' | ' ||
            TO_CHAR(expired_car_record.inspection_date, 'YYYY-MM-DD') || ' | ' ||
            expired_car_record.remarks
        );
    END LOOP;
END;


    -- Legtöbb műszaki vizsga a hónapban
  PROCEDURE top_inspection_month IS
  CURSOR inspections_by_month IS
    SELECT to_char(expiry_date, 'YYYY-MM') AS MONTH
          ,COUNT(*) AS total_inspections
      FROM inspections
     WHERE expiry_date >= SYSDATE
     GROUP BY to_char(expiry_date, 'YYYY-MM')
     ORDER BY total_inspections DESC;

  inspection_record inspections_by_month%ROWTYPE;
BEGIN
  dbms_output.put_line('Ebben a hónapban lesz várhatóan a legtöbb műszaki vizsga');
  dbms_output.put_line('-----------------------------');

  FOR inspection_record IN inspections_by_month LOOP
    dbms_output.put_line(inspection_record.month || ' | ' ||
                         inspection_record.total_inspections);
    EXIT; 
  END LOOP;
END;


    -- Következő 7 nap műszaki vizsgái
    PROCEDURE inspections_7_days IS
        CURSOR inspections_due_in_7_days IS
            SELECT vehicleid, to_char(expiry_date, 'YYYY-MM-DD') AS expiry_date
              FROM inspections
             WHERE expiry_date BETWEEN trunc(SYSDATE) AND trunc(SYSDATE) + 7;

        inspection_record inspections_due_in_7_days%ROWTYPE;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Következő autók fognak lejárni 1 héten belül');
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Kocsi ID | Mûszaki vizsga lejárata');
        FOR inspection_record IN inspections_due_in_7_days LOOP
            DBMS_OUTPUT.PUT_LINE(inspection_record.vehicleid || ' | ' || inspection_record.expiry_date);
        END LOOP;
    END inspections_7_days;
    
    --2 éve nem látogatott ügyfelek listája
  PROCEDURE customers_not_visited IS
  CURSOR customers_not_visited IS
    SELECT c.customerid
          ,c.name
          ,MAX(i.inspection_date) AS last_inspection_date
      FROM customers c
      JOIN vehicles v
        ON c.customerid = v.owner_id
      JOIN inspections i
        ON v.vehicleid = i.vehicleid
     GROUP BY c.customerid
             ,c.name
    HAVING MAX(i.inspection_date) IS NULL OR MAX(i.inspection_date) < trunc(SYSDATE) - INTERVAL '2' YEAR;

  customer_record customers_not_visited%ROWTYPE;
BEGIN
  dbms_output.put_line('Ügyfél ID | Ügyfél neve | Utolsó szerviz látogatás dátuma');
  dbms_output.put_line('----------------------------------------------------------');

  FOR customer_record IN customers_not_visited LOOP
    dbms_output.put_line(customer_record.customerid || ' | ' ||
                         customer_record.name || ' | ' ||
                         nvl(to_char(customer_record.last_inspection_date,
                                     'YYYY-MM-DD'),
                             'Soha nem látogatott'));
  END LOOP;
END;

--Adatok beszúrása
PROCEDURE data_insert AS

    v_customerID customers.customerID%TYPE;
    v_name customers.name%TYPE;
    v_address customers.address%TYPE;
    v_phone_number customers.phone_number%TYPE;
    v_email customers.email%TYPE;
    v_driver_license_number customers.driver_license_number%TYPE;

    v_vehicleID vehicles.vehicleID%TYPE;
    v_license_plate vehicles.license_plate%TYPE;
    v_brand vehicles.brand%TYPE;
    v_model vehicles.model%TYPE;
    v_year_of_manifacture vehicles.year_of_manifacture%TYPE;
    v_vin vehicles.vin%TYPE;
    v_owner_id vehicles.owner_id%TYPE;
    v_last_inspection vehicles.last_inspection%TYPE;
    v_inspection_expiration vehicles.inspection_expiration%TYPE;

    v_inspectionID inspections.inspectionID%TYPE;
    v_inspection_date inspections.inspection_date%TYPE;
    v_inspector_name inspections.inspector_name%TYPE;
    v_result inspections.result%TYPE;
    v_remarks inspections.remarks%TYPE;
    v_expiry_date inspections.expiry_date%TYPE;

BEGIN
    
    v_customerID := customer_seq.NEXTVAL;

    
    v_name := '&name';
    v_address := '&address';
    v_phone_number := &phone_number;
    v_email := '&email';
    v_driver_license_number := '&driver_license_number';

    
    INSERT INTO customers (customerID, name, address, phone_number, email, driver_license_number)
    VALUES (v_customerID, v_name, v_address, v_phone_number, v_email, v_driver_license_number);

    DBMS_OUTPUT.PUT_LINE('Ügyfél hozzáadva: ' || v_name || ' (ID: ' || v_customerID || ')');

    v_vehicleID := vehicle_seq.NEXTVAL;
    v_license_plate := '&license_plate';
    v_brand := '&brand';
    v_model := '&model';
    v_year_of_manifacture := &year_of_manifacture;
    v_vin := '&vin';
    v_owner_id := v_customerID;
    v_last_inspection := TO_DATE('&last_inspection', 'YYYY-MM-DD');
    v_inspection_expiration := TO_DATE('&inspection_expiration', 'YYYY-MM-DD');

    INSERT INTO vehicles (vehicleID, license_plate, brand, model, year_of_manifacture, vin, owner_id, last_inspection, inspection_expiration)
    VALUES (v_vehicleID, v_license_plate, v_brand, v_model, v_year_of_manifacture, v_vin, v_owner_id, v_last_inspection, v_inspection_expiration);

    DBMS_OUTPUT.PUT_LINE('Jármű hozzáadva: ' || v_license_plate || ' (ID: ' || v_vehicleID || ')');

    v_inspectionID := inspection_seq.NEXTVAL;
    v_inspection_date := TO_DATE('&inspection_date', 'YYYY-MM-DD');
    v_inspector_name := '&inspector_name';
    v_result := '&result';
    v_remarks := '&remarks';
    v_expiry_date := TO_DATE('&expiry_date', 'YYYY-MM-DD');

    INSERT INTO inspections (inspectionID, vehicleID, inspection_date, inspector_name, result, remarks, expiry_date)
    VALUES (v_inspectionID, v_vehicleID, v_inspection_date, v_inspector_name, v_result, v_remarks, v_expiry_date);

    DBMS_OUTPUT.PUT_LINE('Műszaki vizsga hozzáadva: ' || v_inspectionID);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Hiba történt: ' || SQLERRM);
        ROLLBACK;
END data_insert;

--Rendszám alapján való keresés
 PROCEDURE GetInspectionStatus (
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
    END GetInspectionStatus;

    PROCEDURE DisplayInspectionStatus IS
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
    END DisplayInspectionStatus;

END pkg_service;

