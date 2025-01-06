CREATE OR REPLACE VIEW vw_vehicle_owners AS
SELECT 
    v.vehicleid,
    v.license_plate,
    v.brand,
    v.model,
    v.year_of_manifacture,
    v.vin,
    c.customerid,
    c.name AS owner_name,
    c.address AS owner_address,
    c.phone_number AS owner_phone,
    c.email AS owner_email
FROM 
    vehicles v JOIN customers c ON v.owner_id = c.customerid;
    
/
    
CREATE OR REPLACE VIEW vw_active_vehicle_owners AS
SELECT DISTINCT
    c.customerid,
    c.name AS owner_name,
    c.phone_number,
    c.email,
    COUNT(v.vehicleid) AS active_vehicles
FROM 
    customers c
JOIN 
    vehicles v ON c.customerid = v.owner_id
WHERE 
    v.inspection_expiration > SYSDATE
GROUP BY 
    c.customerid, c.name, c.phone_number, c.email;

/

CREATE OR REPLACE VIEW vw_failed_inspections AS
SELECT 
    i.inspectionid,
    v.license_plate,
    v.brand,
    v.model,
    i.inspection_date,
    i.inspector_name,
    i.result,
    i.remarks
FROM 
    inspections i
JOIN 
    vehicles v ON i.vehicleid = v.vehicleid
WHERE 
    UPPER(i.result) = 'FAILED';
    
/

CREATE OR REPLACE VIEW vehicle_ages_view AS
SELECT 
    v.license_plate,
    v.brand,
    v.model,
    (EXTRACT(YEAR FROM SYSDATE) - v.year_of_manifacture) AS vehicle_age
FROM 
    vehicles v;

