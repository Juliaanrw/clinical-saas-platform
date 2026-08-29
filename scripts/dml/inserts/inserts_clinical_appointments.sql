INSERT INTO clinical.appointments (appointment_date, appointment_time, reason, status, patient_id, doctor_id, tenant_id)
VALUES 
    -- Citas del Doctor 1 (Inquilino 1)
    ('2026-08-25', '08:00:00', 'Chequeo anual de rutina', 'completed', 10, 1, 1),
    ('2026-08-25', '09:00:00', 'Dolor de cabeza crónico', 'completed', 22, 1, 1),
    ('2026-08-25', '10:00:00', 'Resultados de laboratorio', 'completed', 35, 1, 1),
    ('2026-08-25', '11:00:00', 'Fatiga y mareos', 'no_show', 41, 1, 1),
    ('2026-08-25', '13:00:00', 'Control de presión arterial', 'completed', 50, 1, 1),
    ('2026-08-26', '08:00:00', 'Dolor lumbar', 'completed', 62, 1, 1),
    ('2026-08-26', '09:30:00', 'Renovación de recetas', 'completed', 73, 1, 1),
    ('2026-08-26', '14:00:00', 'Molestia gastrointestinal', 'cancelled', 88, 1, 1),
    ('2026-08-27', '08:00:00', 'Examen físico general', 'scheduled', 91, 1, 1),
    ('2026-08-27', '10:00:00', 'Dificultad para respirar', 'scheduled', 105, 1, 1),

    -- Citas del Doctor 2 (Inquilino 1)
    ('2026-08-25', '08:30:00', 'Revisión dermatológica', 'completed', 12, 2, 1),
    ('2026-08-25', '09:30:00', 'Alergia estacional', 'completed', 25, 2, 1),
    ('2026-08-25', '11:30:00', 'Control de peso', 'completed', 38, 2, 1),
    ('2026-08-26', '13:00:00', 'Dolor en articulaciones', 'completed', 45, 2, 1),
    ('2026-08-26', '14:30:00', 'Consulta de seguimiento', 'completed', 52, 2, 1),
    ('2026-08-26', '15:30:00', 'Infección leve', 'completed', 68, 2, 1),
    ('2026-08-27', '09:00:00', 'Problemas de sueño', 'scheduled', 79, 2, 1),
    ('2026-08-27', '11:00:00', 'Chequeo preventivo', 'scheduled', 84, 2, 1),
    ('2026-08-27', '13:30:00', 'Asesoría nutricional', 'scheduled', 95, 2, 1),
    ('2026-08-27', '15:00:00', 'Dolor muscular', 'scheduled', 110, 2, 1),

    -- Citas del Doctor 3 (Inquilino 2 - Otra clínica)
    ('2026-08-25', '07:00:00', 'Dolor abdominal agudo', 'completed', 15, 3, 2),
    ('2026-08-25', '08:00:00', 'Fiebre alta', 'completed', 28, 3, 2),
    ('2026-08-25', '09:00:00', 'Control de diabetes', 'completed', 33, 3, 2),
    ('2026-08-25', '10:00:00', 'Tos persistente', 'no_show', 44, 3, 2),
    ('2026-08-26', '07:30:00', 'Revisión de tiroides', 'completed', 55, 3, 2),
    ('2026-08-26', '08:30:00', 'Migraña', 'completed', 66, 3, 2),
    ('2026-08-26', '10:30:00', 'Evaluación preoperatoria', 'completed', 77, 3, 2),
    ('2026-08-27', '07:00:00', 'Consulta general', 'scheduled', 89, 3, 2),
    ('2026-08-27', '08:30:00', 'Seguimiento de tratamiento', 'scheduled', 99, 3, 2),
    ('2026-08-27', '11:00:00', 'Dolor de garganta', 'scheduled', 120, 3, 2);
