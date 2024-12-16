CREATE OR REPLACE PACKAGE audit_pkg IS
    PROCEDURE log_customers_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    );

    PROCEDURE log_vehicles_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    );

    PROCEDURE log_inspections_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    );
END audit_pkg;
/
CREATE OR REPLACE PACKAGE BODY audit_pkg IS
    PROCEDURE log_change(
        p_table_name IN VARCHAR2,
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    )
    IS
    BEGIN
        INSERT INTO audit_log (table_name, operation, old_values, new_values)
        VALUES (p_table_name, p_operation, p_old_values, p_new_values);
    END log_change;

    PROCEDURE log_customers_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    )
    IS
    BEGIN
        log_change('customers', p_operation, p_old_values, p_new_values);
    END log_customers_change;

    PROCEDURE log_vehicles_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    )
    IS
    BEGIN
        log_change('vehicles', p_operation, p_old_values, p_new_values);
    END log_vehicles_change;

    PROCEDURE log_inspections_change(
        p_operation IN VARCHAR2,
        p_old_values IN CLOB,
        p_new_values IN CLOB
    )
    IS
    BEGIN
        log_change('inspections', p_operation, p_old_values, p_new_values);
    END log_inspections_change;
END audit_pkg;
/
