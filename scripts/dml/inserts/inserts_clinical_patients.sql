INSERT INTO clinical.patients (
    first_name, 
    last_name, 
    national_id, 
    date_of_birth, 
    blood_type, 
    tenant_id
)
SELECT 
    'Paciente_' || i,
    'Prueba_' || i,
    (500000000 + i)::VARCHAR, 
    CURRENT_DATE - (random() * 365 * 60)::INT, 
    (ARRAY['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'])[floor(random() * 8 + 1)],
    (floor(random() * 3 + 1))::INT
FROM generate_series(1, 5000) AS i;
