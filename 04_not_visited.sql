DECLARE
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

  FOR customer_record IN customers_not_visited
  LOOP
    dbms_output.put_line(customer_record.customerid || ' | ' ||
                         customer_record.name || ' | ' ||
                         nvl(to_char(customer_record.last_inspection_date,
                                     'YYYY-MM-DD'),
                             'Soha nem látogatott'));
  END LOOP;
END;
