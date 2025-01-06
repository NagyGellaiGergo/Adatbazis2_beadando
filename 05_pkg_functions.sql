CREATE OR REPLACE PACKAGE pkg_functions IS

    FUNCTION calculate_pass_rate RETURN NUMBER;

    PROCEDURE print_pass_rate;
    
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
            DBMS_OUTPUT.PUT_LINE('�tlagos sikeress�gi ar�ny: ' || TO_CHAR(v_pass_rate, '90.00') || '%');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nincs el�rhet� adat a statisztik�hoz.');
        END IF;
    END print_pass_rate;


END pkg_functions;
/
