DECLARE
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

    v_customerID := &customerID;
    v_name := '&name';
    v_address := '&address';
    v_phone_number := &phone_number;
    v_email := '&email';
    v_driver_license_number := '&driver_license_number';

    INSERT INTO customers (customerID, name, address, phone_number, email, driver_license_number)
    VALUES (v_customerID, v_name, v_address, v_phone_number, v_email, v_driver_license_number);

    DBMS_OUTPUT.PUT_LINE('Új ügyfél hozzáadva: ' || v_name);

    v_vehicleID := &vehicleID;
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

    DBMS_OUTPUT.PUT_LINE('Új jármû hozzáadva rendszámmal: ' || v_license_plate);

    v_inspectionID := &inspectionID;
    v_inspection_date := TO_DATE('&inspection_date', 'YYYY-MM-DD');
    v_inspector_name := '&inspector_name';
    v_result := '&result';
    v_remarks := '&remarks';
    v_expiry_date := TO_DATE('&expiry_date', 'YYYY-MM-DD');

    INSERT INTO inspections (inspectionID, vehicleID, inspection_date, inspector_name, result, remarks, expiry_date)
    VALUES (v_inspectionID, v_vehicleID, v_inspection_date, v_inspector_name, v_result, v_remarks, v_expiry_date);

    DBMS_OUTPUT.PUT_LINE('Új mûszaki vizsga hozzáadva: ' || v_inspectionID);
END;
/
