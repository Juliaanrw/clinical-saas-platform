INSERT INTO clinical.consultations (symptoms, clinical_notes, appointment_id, tenant_id)
SELECT 
    'Paciente acude por: ' || reason AS symptoms,
    (ARRAY[
        'Se revisa al paciente, signos vitales estables. Se indica tratamiento a seguir.',
        'Examen físico sin alteraciones aparentes. Se envían exámenes de laboratorio de rutina.',
        'Paciente presenta mejoría respecto a la evaluación anterior. Continuar tratamiento actual.',
        'Se detecta inflamación leve. Se receta medicación y reposo por 3 días.'
    ])[floor(random() * 4 + 1)] AS clinical_notes,
    id AS appointment_id,
    tenant_id
FROM clinical.appointments
WHERE status = 'completed';
