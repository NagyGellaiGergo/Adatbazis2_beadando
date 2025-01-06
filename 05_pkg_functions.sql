CREATE OR REPLACE PACKAGE pkg_functions IS

    FUNCTION calculate_pass_rate RETURN NUMBER;

    PROCEDURE print_pass_rate;
    
    PROCEDURE update_vehicle_owner(p_vehicleid NUMBER, p_new_owner_id NUMBER);
    PROCEDURE update_customer_info(p_customerid NUMBER, p_new_name VARCHAR2, p_new_address VARCHAR2, p_new_phone NUMBER, p_new_email VARCHAR2);
    PROCEDURE update_inspection_result(p_inspectionid NUMBER, p_new_result VARCHAR2, p_new_remarks VARCHAR2);

    PROCEDURE delete_vehicle(p_vehicleid NUMBER);
    PROCEDURE delete_customer(p_customerid NUMBER);
    PROCEDURE delete_inspections(p_date_threshold DATE);
    
END pkg_functions;
/
CREATE OR REPLACE PACKAGE BODY pkg_functions IS

  FUNCTION calculate_pass_rate RETURN NUMBER IS
        v_total_inspections NUMBER := 0;
        v_passed_inspections NUMBER := 0;
        v_pass_rate NUMBER;
    BEGIN

        SELECT COUNT(*)
        INTO v_total_inspections
        FROM inspections;

        SELECT COUNT(*)
        INTO v_passed_inspections
        FROM inspections
        WHERE result = 'Passed';

        IF v_total_inspections = 0 THEN
            RETURN NULL; 
        ELSE
           
            v_pass_rate := (v_passed_inspections / v_total_inspections) * 100;
        END IF;

        RETURN v_pass_rate;
    END calculate_pass_rate;

    
    PROCEDURE print_pass_rate IS
        v_pass_rate NUMBER;
    BEGIN
        
        v_pass_rate := calculate_pass_rate;

        
        IF v_pass_rate IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE('Átlagos sikerességi arány: ' || TO_CHAR(v_pass_rate, '90.00') || '%');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nincs elérhetõ adat a statisztikához.');
        END IF;
    END print_pass_rate;
    
    PROCEDURE update_vehicle_owner(p_vehicleid NUMBER, p_new_owner_id NUMBER) IS
    BEGIN
        UPDATE vehicles
        SET owner_id = p_new_owner_id
        WHERE vehicleid = p_vehicleid;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'A megadott jármû azonosító nem létezik.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Jármû tulajdonosának frissítése sikeres.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt a jármû tulajdonosának frissítése során: ' || SQLERRM);
    END update_vehicle_owner;

    PROCEDURE update_customer_info(p_customerid NUMBER, p_new_name VARCHAR2, p_new_address VARCHAR2, p_new_phone NUMBER, p_new_email VARCHAR2) IS
    BEGIN
        UPDATE customers
        SET name = p_new_name,
            address = p_new_address,
            phone_number = p_new_phone,
            email = p_new_email
        WHERE customerid = p_customerid;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'A megadott ügyfél azonosító nem létezik.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Ügyfél adatainak frissítése sikeres.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt az ügyfél adatainak frissítése során: ' || SQLERRM);
    END update_customer_info;

    PROCEDURE update_inspection_result(p_inspectionid NUMBER, p_new_result VARCHAR2, p_new_remarks VARCHAR2) IS
    BEGIN
        UPDATE inspections
        SET result = p_new_result,
            remarks = p_new_remarks
        WHERE inspectionid = p_inspectionid;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'A megadott vizsgálat azonosító nem létezik.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Mûszaki vizsgálat eredményének frissítése sikeres.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt a vizsgálat eredményének frissítése során: ' || SQLERRM);
    END update_inspection_result;

    PROCEDURE delete_vehicle(p_vehicleid NUMBER) IS
    BEGIN
        DELETE FROM vehicles
        WHERE vehicleid = p_vehicleid;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'A megadott jármû azonosító nem létezik.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Jármû törlése sikeres.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt a jármû törlése során: ' || SQLERRM);
    END delete_vehicle;

    PROCEDURE delete_customer(p_customerid NUMBER) IS
    BEGIN
        DELETE FROM customers
        WHERE customerid = p_customerid;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20005, 'A megadott ügyfél azonosító nem létezik.');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Ügyfél törlése sikeres.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt az ügyfél törlése során: ' || SQLERRM);
    END delete_customer;

    PROCEDURE delete_inspections(p_date_threshold DATE) IS
    BEGIN
        DELETE FROM inspections
        WHERE expiry_date < p_date_threshold;

        DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' lejárt vizsgálat törölve.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Hiba történt a lejárt vizsgálatok törlése során: ' || SQLERRM);
    END delete_inspections;


END pkg_functions;
/
