CREATE OR REPLACE PROCEDURE inspections_7_days IS
  CURSOR inspections_due_in_7_days IS
    SELECT vehicleid
          ,to_char(expiry_date, 'YYYY-MM-DD') AS expiry_date
      FROM inspections
     WHERE expiry_date BETWEEN trunc(SYSDATE) AND trunc(SYSDATE) + 7;

  inspection_record inspections_due_in_7_days%ROWTYPE;
BEGIN
  dbms_output.put_line('Kocsi ID | Mûszaki vizsga lejárata');
  dbms_output.put_line('-------------------------------');

  FOR inspection_record IN inspections_due_in_7_days LOOP
    dbms_output.put_line(inspection_record.vehicleid || ' | ' ||
                         inspection_record.expiry_date);
  END LOOP;
END;
