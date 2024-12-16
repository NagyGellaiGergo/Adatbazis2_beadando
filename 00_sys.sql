----------------------------------
--  Nagy-Gellai Gergõ, F9I34F   --
--                              --
--   Create user, add grants    --
----------------------------------

DECLARE
  CURSOR cur IS
    SELECT 'alter system kill session ''' || sid || ',' || serial# || '''' AS command
      FROM v$session
     WHERE username = 'AUTOSERVICE';
BEGIN
  FOR c IN cur
  LOOP
    EXECUTE IMMEDIATE c.command;
  END LOOP;
END;
/

DECLARE v_count NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO v_count
    FROM dba_users t
   WHERE t.username = 'AUTOSERVICE';
  IF v_count = 1
  THEN
    EXECUTE IMMEDIATE 'DROP USER AUTOSERVICE CASCADE';
  END IF;
END;
/ CREATE USER autoservice identified BY "12345678" DEFAULT tablespace users quota unlimited ON users;

grant CREATE TRIGGER TO autoservice;
grant CREATE session TO autoservice;
grant CREATE TABLE TO autoservice;
grant CREATE view TO autoservice;
grant CREATE sequence TO autoservice;
grant CREATE PROCEDURE TO autoservice;
grant CREATE TYPE TO autoservice;

ALTER session SET current_schema = autoservice;

/

CREATE TABLE vehicles(vehicleid NUMBER primary key,
                      license_plate VARCHAR(10),
                      brand VARCHAR2(50),
                      model VARCHAR2(50),
                      year_of_manifacture NUMBER NOT NULL,
                      vin VARCHAR2(30) NOT NULL,
                      owner_id NUMBER NOT NULL,
                      last_inspection DATE,
                      inspection_expiration DATE) tablespace users;

CREATE TABLE customers(customerid NUMBER primary key,
                       NAME VARCHAR2(100) NOT NULL,
                       address VARCHAR2(200) NOT NULL,
                       phone_number NUMBER NOT NULL,
                       email VARCHAR2(100),
                       driver_license_number VARCHAR2(20)) tablespace users;

CREATE TABLE inspections(inspectionid NUMBER primary key,
                         vehicleid NUMBER,
                         inspection_date DATE NOT NULL,
                         inspector_name VARCHAR2(100),
                         RESULT VARCHAR2(10),
                         remarks VARCHAR2(500),
                         expiry_date DATE NOT NULL) tablespace users;

ALTER TABLE inspections add CONSTRAINT vehicleid_fk foreign key(vehicleid) references vehicles(vehicleid);

ALTER TABLE vehicles add CONSTRAINT ownerid_fk foreign key(owner_id) references customers(customerid);

COMMENT ON column inspections.result IS 'Vizsga eredmenye';
COMMENT ON column inspections.remarks IS 'Megjegyzesek, hibak leirasa';

CREATE TABLE audit_log (
    log_id NUMBER PRIMARY KEY,
    table_name VARCHAR2(50) NOT NULL,
    operation VARCHAR2(10) NOT NULL, 
    modified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_by VARCHAR2(100), 
    old_values CLOB, 
    new_values CLOB 
);


INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (1
  ,'Kovács Péter'
  ,'Budapest, Fõ utca 1.'
  ,36201234567
  ,'peter.kovacs@gmail.com'
  ,'BP123456');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (2
  ,'Nagy Anna'
  ,'Debrecen, Kossuth tér 5.'
  ,36207654321
  ,'anna.nagy@hotmail.com'
  ,'DE654321');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (3
  ,'Tóth László'
  ,'Szeged, Petõfi utca 3.'
  ,36203456789
  ,'laszlo.toth@yahoo.com'
  ,'SZ345678');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (4
  ,'Fekete Márta'
  ,'Miskolc, Jókai utca 9.'
  ,36301234567
  ,NULL
  ,'MI123789');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (5
  ,'Horváth Zoltán'
  ,'Gyõr, Arany János utca 7.'
  ,36209998877
  ,'zoltan.horvath@gmail.com'
  ,'GY987654');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (6
  ,'Molnár Tamás'
  ,'Pécs, Kertváros utca 10.'
  ,36205566789
  ,'tamas.molnar@gmail.com'
  ,'PE345678');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (7
  ,'Kiss Júlia'
  ,'Kecskemét, Hunyadi utca 2.'
  ,36206677889
  ,'julia.kiss@hotmail.com'
  ,'KE123987');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (8
  ,'Németh Balázs'
  ,'Szombathely, Bartók Béla út 8.'
  ,36207788990
  ,'balazs.nemeth@yahoo.com'
  ,'SZ890123');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (9
  ,'Varga Viktória'
  ,'Tatabánya, Rákóczi út 12.'
  ,36201122334
  ,'viktoria.varga@freemail.hu'
  ,'TA567890');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (10
  ,'Lukács Áron'
  ,'Zalaegerszeg, Ady utca 4.'
  ,36208877665
  ,NULL
  ,'ZA432109');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (11
  ,'Török Gábor'
  ,'Budapest, Nagykörút 20.'
  ,36201238977
  ,'gabor.torok@gmail.com'
  ,'BP654987');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (12
  ,'Fehér Emma'
  ,'Miskolc, Táncsics utca 5.'
  ,36207723412
  ,'emma.feher@gmail.com'
  ,'MI908712');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (13
  ,'Fazekas Dániel'
  ,'Eger, Dózsa György tér 3.'
  ,36205577678
  ,NULL
  ,'EG123456');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (14
  ,'Bognár Noémi'
  ,'Salgótarján, Zrínyi utca 6.'
  ,36203455612
  ,'noemi.bognar@outlook.com'
  ,'SA987654');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (15
  ,'Farkas Ádám'
  ,'Sopron, Táncsics utca 10.'
  ,36207899887
  ,'adam.farkas@gmail.com'
  ,'SO321456');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (16
  ,'Szalai Norbert'
  ,'Budapest, Körút utca 5.'
  ,36209876543
  ,'norbert.szalai@gmail.com'
  ,'BU987654');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (17
  ,'Kerekes Zsuzsanna'
  ,'Gyõr, Szent István út 3.'
  ,36207654321
  ,'zsuzsanna.kerekes@gmail.com'
  ,'GY123456');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (18
  ,'Takács Márk'
  ,'Debrecen, Petõfi tér 7.'
  ,36206789123
  ,'mark.takacs@gmail.com'
  ,'DE987123');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (19
  ,'Balogh Anna'
  ,'Miskolc, Bartók Béla út 4.'
  ,36203456789
  ,'anna.balogh@gmail.com'
  ,'MI456789');
INSERT INTO customers
  (customerid
  ,NAME
  ,address
  ,phone_number
  ,email
  ,driver_license_number)
VALUES
  (20
  ,'Hegedûs László'
  ,'Székesfehérvár, Zrínyi utca 10.'
  ,36202345678
  ,'laszlo.hegedus@gmail.com'
  ,'SZ456123');

INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (101
  ,'ABC-123'
  ,'Toyota'
  ,'Corolla'
  ,2010
  ,'JT123456789012345'
  ,1
  ,to_date('2022-06-15', 'YYYY-MM-DD')
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (102
  ,'DEF-456'
  ,'Ford'
  ,'Focus'
  ,2012
  ,'WF123456789012345'
  ,2
  ,to_date('2023-03-10', 'YYYY-MM-DD')
  ,to_date('2025-03-10', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (103
  ,'GHI-789'
  ,'Opel'
  ,'Astra'
  ,2015
  ,'WO123456789012345'
  ,3
  ,to_date('2023-08-25', 'YYYY-MM-DD')
  ,to_date('2025-08-25', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (104
  ,'JKL-012'
  ,'Volkswagen'
  ,'Golf'
  ,2008
  ,'VW123456789012345'
  ,4
  ,to_date('2022-12-01', 'YYYY-MM-DD')
  ,to_date('2022-12-01', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (105
  ,'MNO-345'
  ,'Suzuki'
  ,'Swift'
  ,2020
  ,'SZ123456789012345'
  ,5
  ,to_date('2023-05-20', 'YYYY-MM-DD')
  ,to_date('2025-05-20', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (106
  ,'PRQ-567'
  ,'Hyundai'
  ,'i30'
  ,2018
  ,'HY567890123456789'
  ,6
  ,to_date('2023-04-12', 'YYYY-MM-DD')
  ,to_date('2025-04-12', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (107
  ,'UVW-890'
  ,'Renault'
  ,'Clio'
  ,2017
  ,'RN890123456789012'
  ,7
  ,to_date('2022-11-15', 'YYYY-MM-DD')
  ,to_date('2022-11-15', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (108
  ,'XYZ-123'
  ,'BMW'
  ,'320i'
  ,2020
  ,'BM123456789012345'
  ,8
  ,to_date('2023-09-30', 'YYYY-MM-DD')
  ,to_date('2025-09-30', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (109
  ,'ACE-456'
  ,'Mercedes'
  ,'C-Class'
  ,2015
  ,'MC456789012345678'
  ,9
  ,to_date('2022-10-05', 'YYYY-MM-DD')
  ,to_date('2022-10-05', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (110
  ,'BDF-789'
  ,'Skoda'
  ,'Octavia'
  ,2019
  ,'SK789012345678901'
  ,10
  ,to_date('2023-06-18', 'YYYY-MM-DD')
  ,to_date('2025-06-18', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (111
  ,'GHI-345'
  ,'Honda'
  ,'Civic'
  ,2014
  ,'HC345678901234567'
  ,11
  ,to_date('2022-07-20', 'YYYY-MM-DD')
  ,to_date('2022-07-20', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (112
  ,'JKL-678'
  ,'Mazda'
  ,'CX-5'
  ,2021
  ,'MZ678901234567890'
  ,12
  ,to_date('2023-08-14', 'YYYY-MM-DD')
  ,to_date('2025-08-14', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (113
  ,'LMN-012'
  ,'Peugeot'
  ,'208'
  ,2016
  ,'PG012345678901234'
  ,13
  ,to_date('2022-09-11', 'YYYY-MM-DD')
  ,to_date('2022-09-11', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (114
  ,'OPQ-456'
  ,'Fiat'
  ,'Panda'
  ,2013
  ,'FT456789012345678'
  ,14
  ,to_date('2023-05-23', 'YYYY-MM-DD')
  ,to_date('2025-05-23', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (115
  ,'RST-789'
  ,'Audi'
  ,'A4'
  ,2020
  ,'AU789012345678901'
  ,15
  ,to_date('2023-02-28', 'YYYY-MM-DD')
  ,to_date('2025-02-28', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (116
  ,'UVX-234'
  ,'Volkswagen'
  ,'Passat'
  ,2019
  ,'VW123456789012345'
  ,16
  ,to_date('2023-06-18', 'YYYY-MM-DD')
  ,to_date('2025-06-18', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (117
  ,'YZA-567'
  ,'Toyota'
  ,'Corolla'
  ,2018
  ,'TY789012345678901'
  ,17
  ,to_date('2023-08-14', 'YYYY-MM-DD')
  ,to_date('2025-08-14', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (118
  ,'BCD-890'
  ,'Ford'
  ,'Focus'
  ,2021
  ,'FF012345678901234'
  ,18
  ,to_date('2024-01-05', 'YYYY-MM-DD')
  ,to_date('2026-01-05', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (119
  ,'EFG-123'
  ,'Opel'
  ,'Corsa'
  ,2015
  ,'OC456789012345678'
  ,19
  ,to_date('2023-12-15', 'YYYY-MM-DD')
  ,to_date('2025-12-15', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (120
  ,'HIJ-456'
  ,'Hyundai'
  ,'Tucson'
  ,2020
  ,'HT678901234567890'
  ,20
  ,to_date('2023-12-15', 'YYYY-MM-DD')
  ,to_date('2025-12-15', 'YYYY-MM-DD'));
INSERT INTO vehicles
  (vehicleid
  ,license_plate
  ,brand
  ,model
  ,year_of_manifacture
  ,vin
  ,owner_id
  ,last_inspection
  ,inspection_expiration)
VALUES
  (121
  ,'KLM-678'
  ,'Suzuki'
  ,'Swift'
  ,2017
  ,'SW567890123456789'
  ,16
  ,to_date('2022-12-17', 'YYYY-MM-DD')
  ,to_date('2024-12-17', 'YYYY-MM-DD'));

INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1001
  ,101
  ,to_date('2022-06-15', 'YYYY-MM-DD')
  ,'Juhász István'
  ,'Failed'
  ,'Elsõ fék meghibásodott'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1002
  ,102
  ,to_date('2023-03-10', 'YYYY-MM-DD')
  ,'Kis Lajos'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-03-10', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1003
  ,103
  ,to_date('2023-08-25', 'YYYY-MM-DD')
  ,'Horváth Éva'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-08-25', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1004
  ,104
  ,to_date('2022-12-01', 'YYYY-MM-DD')
  ,'Szabó Tamás'
  ,'Failed'
  ,'Hátsó lámpa hibás'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1005
  ,105
  ,to_date('2023-05-20', 'YYYY-MM-DD')
  ,'Tóth József'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-05-20', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1006
  ,106
  ,to_date('2023-04-12', 'YYYY-MM-DD')
  ,'Kovács András'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-04-12', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1007
  ,107
  ,to_date('2022-11-15', 'YYYY-MM-DD')
  ,'Nagy Katalin'
  ,'Failed'
  ,'Motorhiba'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1008
  ,108
  ,to_date('2023-09-30', 'YYYY-MM-DD')
  ,'Fazekas László'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-09-30', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1009
  ,109
  ,to_date('2022-10-05', 'YYYY-MM-DD')
  ,'Kiss Béla'
  ,'Failed'
  ,'Futómû hiba'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1010
  ,110
  ,to_date('2023-06-18', 'YYYY-MM-DD')
  ,'Varga Péter'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-06-18', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1011
  ,111
  ,to_date('2022-07-20', 'YYYY-MM-DD')
  ,'Szabó Tamás'
  ,'Failed'
  ,'Karosszéria sérült'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1012
  ,112
  ,to_date('2023-08-14', 'YYYY-MM-DD')
  ,'Horváth Éva'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-08-14', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1013
  ,113
  ,to_date('2022-09-11', 'YYYY-MM-DD')
  ,'Németh Gábor'
  ,'Failed'
  ,'Fék meghibásodás'
  ,to_date('2022-06-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1014
  ,114
  ,to_date('2023-05-23', 'YYYY-MM-DD')
  ,'Tóth Sándor'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-05-23', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1015
  ,115
  ,to_date('2023-02-28', 'YYYY-MM-DD')
  ,'Farkas Krisztián'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-02-28', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1016
  ,116
  ,to_date('2023-06-18', 'YYYY-MM-DD')
  ,'Kiss Dénes'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2025-06-18', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1017
  ,117
  ,to_date('2023-08-14', 'YYYY-MM-DD')
  ,'Nagy László'
  ,'Passed'
  ,'Apró karcolások a karosszérián'
  ,to_date('2025-08-14', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1018
  ,118
  ,to_date('2024-01-05', 'YYYY-MM-DD')
  ,'Tóth Judit'
  ,'Passed'
  ,'Tökéletes állapot'
  ,to_date('2026-01-05', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1019
  ,119
  ,to_date('2023-12-15', 'YYYY-MM-DD')
  ,'Balogh Péter'
  ,'Passed'
  ,'Kifogástalan mûszaki állapot'
  ,to_date('2025-12-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1020
  ,120
  ,to_date('2023-12-15', 'YYYY-MM-DD')
  ,'Hegedûs Zoltán'
  ,'Passed'
  ,'Tökéletes fékrendszer'
  ,to_date('2025-12-15', 'YYYY-MM-DD'));
INSERT INTO inspections
  (inspectionid
  ,vehicleid
  ,inspection_date
  ,inspector_name
  ,RESULT
  ,remarks
  ,expiry_date)
VALUES
  (1021
  ,121
  ,to_date('2022-12-17', 'YYYY-MM-DD')
  ,'Szabó Gábor'
  ,'Passed'
  ,'Minden rendben'
  ,to_date('2024-12-17', 'YYYY-MM-DD'));
