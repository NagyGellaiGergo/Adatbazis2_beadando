CREATE OR REPLACE TRIGGER trg_customers_audit
AFTER INSERT OR UPDATE OR DELETE ON customers
FOR EACH ROW
DECLARE
    v_old_data CLOB := NULL;
    v_new_data CLOB := NULL;
    v_operation_type VARCHAR2(10);
BEGIN
    
    IF INSERTING THEN
        v_operation_type := 'INSERT';
    ELSIF UPDATING THEN
        v_operation_type := 'UPDATE';
    ELSIF DELETING THEN
        v_operation_type := 'DELETE';
    END IF;

    
    IF DELETING OR UPDATING THEN
        v_old_data := '{' ||
            '"CUSTOMERID": "' || TO_CHAR(:OLD.CUSTOMERID) || '", ' ||
            '"NAME": "' || :OLD.NAME || '", ' ||
            '"ADDRESS": "' || :OLD.ADDRESS || '", ' ||
            '"PHONE_NUMBER": "' || TO_CHAR(:OLD.PHONE_NUMBER) || '", ' ||
            '"EMAIL": "' || NVL(:OLD.EMAIL, 'NULL') || '", ' ||
            '"DRIVER_LICENSE_NUMBER": "' || NVL(:OLD.DRIVER_LICENSE_NUMBER, 'NULL') || '"' ||
        '}';
    END IF;

    
    IF INSERTING OR UPDATING THEN
        v_new_data := '{' ||
            '"CUSTOMERID": "' || TO_CHAR(:NEW.CUSTOMERID) || '", ' ||
            '"NAME": "' || :NEW.NAME || '", ' ||
            '"ADDRESS": "' || :NEW.ADDRESS || '", ' ||
            '"PHONE_NUMBER": "' || TO_CHAR(:NEW.PHONE_NUMBER) || '", ' ||
            '"EMAIL": "' || NVL(:NEW.EMAIL, 'NULL') || '", ' ||
            '"DRIVER_LICENSE_NUMBER": "' || NVL(:NEW.DRIVER_LICENSE_NUMBER, 'NULL') || '"' ||
        '}';
    END IF;

    
    INSERT INTO audit_log (table_name, operation_type, old_data, new_data)
    VALUES (
        'customers',
        v_operation_type,
        v_old_data,
        v_new_data
    );
END;
/
CREATE OR REPLACE TRIGGER trg_vehicles_audit
AFTER INSERT OR UPDATE OR DELETE ON vehicles
FOR EACH ROW
DECLARE
    v_old_data CLOB := NULL;
    v_new_data CLOB := NULL;
    v_operation_type VARCHAR2(10);
BEGIN

    IF INSERTING THEN
        v_operation_type := 'INSERT';
    ELSIF UPDATING THEN
        v_operation_type := 'UPDATE';
    ELSIF DELETING THEN
        v_operation_type := 'DELETE';
    END IF;

    IF DELETING OR UPDATING THEN
        v_old_data := '{' ||
            '"VEHICLEID": "' || TO_CHAR(:OLD.VEHICLEID) || '", ' ||
            '"LICENSE_PLATE": "' || :OLD.LICENSE_PLATE || '", ' ||
            '"BRAND": "' || :OLD.BRAND || '", ' ||
            '"MODEL": "' || :OLD.MODEL || '", ' ||
            '"YEAR_OF_MANIFACTURE": "' || TO_CHAR(:OLD.YEAR_OF_MANIFACTURE) || '", ' ||
            '"VIN": "' || :OLD.VIN || '", ' ||
            '"OWNER_ID": "' || TO_CHAR(:OLD.OWNER_ID) || '", ' ||
            '"LAST_INSPECTION": "' || NVL(TO_CHAR(:OLD.LAST_INSPECTION, 'YYYY-MM-DD'), 'NULL') || '", ' ||
            '"INSPECTION_EXPIRATION": "' || NVL(TO_CHAR(:OLD.INSPECTION_EXPIRATION, 'YYYY-MM-DD'), 'NULL') || '"' ||
        '}';
    END IF;

    IF INSERTING OR UPDATING THEN
        v_new_data := '{' ||
            '"VEHICLEID": "' || TO_CHAR(:NEW.VEHICLEID) || '", ' ||
            '"LICENSE_PLATE": "' || :NEW.LICENSE_PLATE || '", ' ||
            '"BRAND": "' || :NEW.BRAND || '", ' ||
            '"MODEL": "' || :NEW.MODEL || '", ' ||
            '"YEAR_OF_MANIFACTURE": "' || TO_CHAR(:NEW.YEAR_OF_MANIFACTURE) || '", ' ||
            '"VIN": "' || :NEW.VIN || '", ' ||
            '"OWNER_ID": "' || TO_CHAR(:NEW.OWNER_ID) || '", ' ||
            '"LAST_INSPECTION": "' || NVL(TO_CHAR(:NEW.LAST_INSPECTION, 'YYYY-MM-DD'), 'NULL') || '", ' ||
            '"INSPECTION_EXPIRATION": "' || NVL(TO_CHAR(:NEW.INSPECTION_EXPIRATION, 'YYYY-MM-DD'), 'NULL') || '"' ||
        '}';
    END IF;

    INSERT INTO audit_log (table_name, operation_type, old_data, new_data)
    VALUES (
        'vehicles',
        v_operation_type,
        v_old_data,
        v_new_data
    );
END;
/
CREATE OR REPLACE TRIGGER trg_inspections_audit
AFTER INSERT OR UPDATE OR DELETE ON inspections
FOR EACH ROW
DECLARE
    v_old_data CLOB := NULL;
    v_new_data CLOB := NULL;
    v_operation_type VARCHAR2(10);
BEGIN

    IF INSERTING THEN
        v_operation_type := 'INSERT';
    ELSIF UPDATING THEN
        v_operation_type := 'UPDATE';
    ELSIF DELETING THEN
        v_operation_type := 'DELETE';
    END IF;

    IF DELETING OR UPDATING THEN
        v_old_data := '{' ||
            '"INSPECTIONID": "' || TO_CHAR(:OLD.INSPECTIONID) || '", ' ||
            '"VEHICLEID": "' || TO_CHAR(:OLD.VEHICLEID) || '", ' ||
            '"INSPECTION_DATE": "' || TO_CHAR(:OLD.INSPECTION_DATE, 'YYYY-MM-DD') || '", ' ||
            '"INSPECTOR_NAME": "' || :OLD.INSPECTOR_NAME || '", ' ||
            '"RESULT": "' || NVL(:OLD.RESULT, 'NULL') || '", ' ||
            '"REMARKS": "' || NVL(:OLD.REMARKS, 'NULL') || '", ' ||
            '"EXPIRY_DATE": "' || TO_CHAR(:OLD.EXPIRY_DATE, 'YYYY-MM-DD') || '"' ||
        '}';
    END IF;

    IF INSERTING OR UPDATING THEN
        v_new_data := '{' ||
            '"INSPECTIONID": "' || TO_CHAR(:NEW.INSPECTIONID) || '", ' ||
            '"VEHICLEID": "' || TO_CHAR(:NEW.VEHICLEID) || '", ' ||
            '"INSPECTION_DATE": "' || TO_CHAR(:NEW.INSPECTION_DATE, 'YYYY-MM-DD') || '", ' ||
            '"INSPECTOR_NAME": "' || :NEW.INSPECTOR_NAME || '", ' ||
            '"RESULT": "' || NVL(:NEW.RESULT, 'NULL') || '", ' ||
            '"REMARKS": "' || NVL(:NEW.REMARKS, 'NULL') || '", ' ||
            '"EXPIRY_DATE": "' || TO_CHAR(:NEW.EXPIRY_DATE, 'YYYY-MM-DD') || '"' ||
        '}';
    END IF;

    INSERT INTO audit_log (table_name, operation_type, old_data, new_data)
    VALUES (
        'inspections',
        v_operation_type,
        v_old_data,
        v_new_data
    );
END;
/
