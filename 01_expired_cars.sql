CREATE OR REPLACE PROCEDURE show_expired_cars IS
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
    DBMS_OUTPUT.PUT_LINE('Lej�rt m�szakival rendelkez� aut�k list�ja:');
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Rendsz�m | M�rka | Modell | Gy�rt�si �v | Tulajdonos neve | Telefonsz�m | M�szaki d�tuma | Megjegyz�s');
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
