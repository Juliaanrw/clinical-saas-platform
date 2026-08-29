INSERT INTO human_resources.doctors (employee_id, medical_license_number, tenant_id) 
SELECT 
id,  
'MED' || (10000 + id)::VARCHAR,
tenant_id
FROM human_resources.employees
WHERE id <= 100;
