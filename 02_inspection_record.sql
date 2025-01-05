CREATE OR REPLACE PROCEDURE top_inspection_month IS
  CURSOR inspections_by_month IS
    SELECT to_char(expiry_date, 'YYYY-MM') AS MONTH
          ,COUNT(*) AS total_inspections
      FROM inspections
     WHERE expiry_date >= SYSDATE
     GROUP BY to_char(expiry_date, 'YYYY-MM')
     ORDER BY total_inspections DESC;

  inspection_record inspections_by_month%ROWTYPE;
BEGIN
  dbms_output.put_line('Ebben a hónapban lesz várhatóan a legtöbb mûszaki vizsga');
  dbms_output.put_line('-----------------------------');

  FOR inspection_record IN inspections_by_month LOOP
    dbms_output.put_line(inspection_record.month || ' | ' ||
                         inspection_record.total_inspections);
    EXIT; 
  END LOOP;
END;
