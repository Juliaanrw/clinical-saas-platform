INSERT INTO finance.invoices (status, total_amount, consultation_id, tenant_id, patient_id)
SELECT 
    -- Cambiamos 'pending' por 'unpaid'
    (ARRAY['paid', 'paid', 'paid', 'paid', 'unpaid'])[floor(random() * 5 + 1)] AS status,
    
    (floor(random() * 30000 + 30000))::NUMERIC(10,2) AS total_amount,
    
    c.id AS consultation_id,
    c.tenant_id,
    a.patient_id 
FROM clinical.consultations c
INNER JOIN clinical.appointments a ON c.appointment_id = a.id;
