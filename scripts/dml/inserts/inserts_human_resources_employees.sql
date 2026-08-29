INSERT INTO human_resources.employees (
    first_name, 
    last_name, 
    national_id, 
    hire_date, 
    email, 
    is_active, 
    tenant_id
)
SELECT 
    'Empleado_' || i,
    'Prueba_' || i,
    (200000000 + i)::VARCHAR, 
    CURRENT_DATE - (random() * 365 * 5)::INT, 
    'empleado' || i || '@clinica' || (floor(random() * 3 + 1))::INT || '.com',
    TRUE,
    (floor(random() * 3 + 1))::INT 
FROM generate_series(1, 300) AS i;
