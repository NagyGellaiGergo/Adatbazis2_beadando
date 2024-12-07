----------------------------------
--  Nagy-Gellai Gergõ, F9I34F   --
--                              --
--   Create user, add grants    --
----------------------------------




declare
  cursor cur is
    select 'alter system kill session ''' || sid || ',' || serial# || '''' as command
      from v$session
     where username = 'AUTOSERVICE';
begin
  for c in cur loop
    EXECUTE IMMEDIATE c.command;
  end loop;
end;
/

DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM dba_users t WHERE t.username='AUTOSERVICE';
  IF v_count = 1 THEN 
    EXECUTE IMMEDIATE 'DROP USER AUTOSERVICE CASCADE';
  END IF;
END;
/
CREATE USER AUTOSERVICE 
  IDENTIFIED BY "12345678" 
  DEFAULT TABLESPACE users
  QUOTA UNLIMITED ON users
;

GRANT CREATE TRIGGER to AUTOSERVICE;
GRANT CREATE SESSION TO AUTOSERVICE;
GRANT CREATE TABLE TO AUTOSERVICE;
GRANT CREATE VIEW TO AUTOSERVICE;
GRANT CREATE SEQUENCE TO AUTOSERVICE;
GRANT CREATE PROCEDURE TO AUTOSERVICE;
GRANT CREATE TYPE TO AUTOSERVICE;
