INSERT INTO human_resources.schedules (day_of_week, start_time, duration, doctor_id, tenant_id)
SELECT 
    (ARRAY['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'])[floor(random() * 5 + 1)],
    ('07:00:00'::TIME + ((floor(random() * 3)) * INTERVAL '1 hour')),
    '8 hours'::INTERVAL,
    
    employee_id AS doctor_id,
    tenant_id
FROM human_resources.doctors;
