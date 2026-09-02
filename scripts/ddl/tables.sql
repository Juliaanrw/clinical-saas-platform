CREATE TABLE main.tenants (
id INT GENERATED ALWAYS AS IDENTITY,
clinic_name VARCHAR(50) NOT NULL,
contact_phone VARCHAR(50) NOT NULL,
subscription_status TEXT NOT NULL,
created_at TIMESTAMPTZ DEFAULT NOW(),
email VARCHAR(40) NOT NULL,
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
CONSTRAINT pk_tenant_id PRIMARY KEY (id),
CONSTRAINT unq_tenant_email UNIQUE (email),
CONSTRAINT chk_tenant_subscription_status CHECK (subscription_status IN 
('active', 'suspended', 'cancelled'))
);

CREATE TABLE human_resources.employees (
id INT GENERATED ALWAYS AS IDENTITY,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
national_id VARCHAR(20) NOT NULL,
hire_date DATE DEFAULT CURRENT_DATE,
email VARCHAR(50) NOT NULL,
is_active BOOLEAN DEFAULT TRUE,
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
tenant_id INT NOT NULL,
CONSTRAINT pk_employee_id PRIMARY KEY (id),
CONSTRAINT unq_tenant_national_id UNIQUE (tenant_id, national_id),
CONSTRAINT unq_tenant_employee_email UNIQUE (tenant_id, email),
CONSTRAINT chk_numeric_national_id CHECK (national_id ~ '^[0-9]{8,15}$'),
CONSTRAINT fk_employee_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id)
);


CREATE TABLE human_resources.doctors (
employee_id INT NOT NULL,
medical_license_number VARCHAR(30) NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT fk_doctor_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT pk_doctor_id PRIMARY KEY (employee_id),
CONSTRAINT fk_doctor_employee FOREIGN KEY (employee_id) REFERENCES human_resources.employees (id),
CONSTRAINT uq_tenant_doctor_license UNIQUE (tenant_id, medical_license_number)
);



CREATE TABLE human_resources.specialties (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
specialty_name VARCHAR(100) NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_specialty_id PRIMARY KEY (id),
CONSTRAINT fk_specialty_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id) 
);



CREATE TABLE human_resources.doctor_specialties (
doctor_id INT NOT NULL,
specialty_id INT NOT NULL,
assigned_date TIMESTAMPTZ DEFAULT NOW(),
CONSTRAINT pk_doctor_specialties PRIMARY KEY (doctor_id, specialty_id),
CONSTRAINT fk_docspec_doctor FOREIGN KEY (doctor_id) REFERENCES human_resources.doctors (employee_id),
CONSTRAINT fk_docspec_specialty FOREIGN KEY (specialty_id) REFERENCES human_resources.specialties (id)
);





CREATE TABLE human_resources.schedules (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
start_time TIME NOT NULL,
day_of_week VARCHAR(15) NOT NULL,
duration INTERVAL NOT NULL,
doctor_id INT NOT  NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_schedules_id  PRIMARY KEY (id),
CONSTRAINT fk_schedule_doctor FOREIGN KEY (doctor_id) REFERENCES human_resources.doctors (employee_id),
CONSTRAINT fk_schedule_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT chk_schedule_duration CHECK (duration > '0 hours'::INTERVAL AND duration <= '24 hours'::INTERVAL),
CONSTRAINT chk_schedule_day_of_week CHECK (
    day_of_week IN (
        'Monday', 
        'Tuesday', 
        'Wednesday', 
        'Thursday', 
        'Friday', 
        'Saturday', 
        'Sunday'
    )
)
);


CREATE TABLE clinical.patients (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
national_id VARCHAR(20) NOT NULL,
date_of_birth DATE NOT NULL,
blood_type VARCHAR(5),
created_at TIMESTAMPTZ DEFAULT NOW(),
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
tenant_id INT NOT NULL,
CONSTRAINT pk_patients_id PRIMARY KEY (id),
CONSTRAINT fk_patient_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT uq_patient_nationalid_tenantid UNIQUE (national_id, tenant_id),
CONSTRAINT chk_patient_numeric_nationalid CHECK (national_id ~ '^[0-9]{8,15}$'),
CONSTRAINT chk_patient_dateofbirth CHECK (date_of_birth <= CURRENT_DATE)
);




CREATE TABLE clinical.appointments (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
appointment_date DATE NOT NULL,
appointment_time TIME NOT NULL,
reason VARCHAR(255) NOT NULL,
status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
created_at TIMESTAMPTZ DEFAULT NOW(),
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
patient_id INT NOT NULL,
doctor_id INT NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_appointment_id PRIMARY KEY (id),
CONSTRAINT fk_appointment_patient FOREIGN KEY(patient_id) REFERENCES clinical.patients (id),
CONSTRAINT fk_appointment_doctor FOREIGN KEY (doctor_id) REFERENCES human_resources.doctors (employee_id),
CONSTRAINT fk_appointment_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT chk_appointment_status CHECK (status IN ('scheduled', 'confirmed', 'completed', 'cancelled', 'no_show')),
CONSTRAINT unq_tenant_doctor_schedule_slot UNIQUE (tenant_id, doctor_id, appointment_date, appointment_time)
);


CREATE TABLE clinical.icd10_diagnoses (
code VARCHAR(10) NOT NULL,
description TEXT NOT NULL,
CONSTRAINT pk_icd10_code PRIMARY KEY (code)
);





 CREATE TABLE clinical.consultations (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
symptoms TEXT NOT NULL,
clinical_notes TEXT NOT NULL,
created_at TIMESTAMPTZ DEFAULT NOW(),
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
appointment_id INT NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_consultation_id PRIMARY KEY (id),
CONSTRAINT fk_consultation_appointment FOREIGN KEY (appointment_id) REFERENCES clinical.appointments (id),
CONSTRAINT fk_consultation_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT unq_consultation_appointment UNIQUE (appointment_id)
); 




CREATE TABLE clinical.consultation_diagnoses (
consultation_id INT NOT NULL,
diagnosis_code VARCHAR(10) NOT NULL,
diagnosis_type VARCHAR(20) NOT NULL DEFAULT 'primary',
CONSTRAINT pk_consultation_diagnoses PRIMARY KEY (consultation_id, diagnosis_code),
CONSTRAINT fk_cdiag_consultation FOREIGN KEY (consultation_id) REFERENCES clinical.consultations (id),
CONSTRAINT fk_cdiag_code FOREIGN KEY (diagnosis_code) REFERENCES clinical.icd10_diagnoses (code),
CONSTRAINT chk_diagnosis_type CHECK (diagnosis_type IN ('primary', 'secondary', 'presumptive', 'confirmed'))
);

CREATE TABLE clinical.prescriptions (
id INT GENERATED ALWAYS AS IDENTITY,
medication_name VARCHAR(100) NOT NULL,
dosage VARCHAR(100) NOT NULL,
instructions TEXT NOT NULL,
consultation_id INT NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_prescription_id PRIMARY KEY (id),
CONSTRAINT fk_prescription_consultation FOREIGN KEY (consultation_id) REFERENCES clinical.consultations (id),
CONSTRAINT fk_prescription_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id)
);





CREATE TABLE finance.insurance_providers (
id INT GENERATED ALWAYS AS IDENTITY,
provider_name VARCHAR(100) NOT NULL,
tenant_id INT NOT NULL,
CONSTRAINT pk_provider_insurance_id PRIMARY KEY (id),
CONSTRAINT fk_insprov_tenant FOREIGN KEY (tenant_id) REFERENCES  main.tenants (id),
CONSTRAINT unq_tenant_provider_name UNIQUE (tenant_id, provider_name)
);




CREATE TABLE finance.provider_phones (
    id INT GENERATED ALWAYS AS IDENTITY,
    phone_number VARCHAR(20) NOT NULL,
    provider_id INT NOT NULL,
    CONSTRAINT pk_provider_phone_id PRIMARY KEY (id),
    CONSTRAINT fk_phone_provider FOREIGN KEY (provider_id) REFERENCES finance.insurance_providers (id) ON DELETE CASCADE,
    CONSTRAINT chk_numeric_phone CHECK (phone_number ~ '^[0-9+ -]{7,20}$')
);





CREATE TABLE finance.patient_insurance (
patient_id INT NOT NULL,
insurance_provider_id INT NOT NULL,
policy_number VARCHAR(50) NOT NULL,
is_primary BOOLEAN DEFAULT FALSE,
CONSTRAINT pk_patient_insurance PRIMARY KEY (patient_id, insurance_provider_id),
CONSTRAINT fk_patins_patient FOREIGN KEY (patient_id) REFERENCES clinical.patients (id),
CONSTRAINT fk_patins_insprovider FOREIGN KEY (insurance_provider_id) REFERENCES finance.insurance_providers (id)
);






CREATE TABLE finance.invoices (
id INT GENERATED ALWAYS AS IDENTITY NOT NULL,
status VARCHAR(20) NOT NULL DEFAULT 'unpaid',
issued_at TIMESTAMPTZ DEFAULT NOW(),
total_amount NUMERIC(10,2) NOT NULL,
public_id UUID UNIQUE DEFAULT gen_random_uuid(),
consultation_id INT NOT NULL,
tenant_id INT NOT NULL,
patient_id INT NOT NULL,
CONSTRAINT pk_invoice_id PRIMARY KEY (id),
CONSTRAINT fk_invoice_consultation FOREIGN KEY (consultation_id) REFERENCES clinical.consultations (id),
CONSTRAINT fk_invoice_tenant FOREIGN KEY (tenant_id) REFERENCES main.tenants (id),
CONSTRAINT fk_invoice_patient FOREIGN KEY (patient_id) REFERENCES clinical.patients (id),
CONSTRAINT chk_invoice_status CHECK(status IN ('draft', 'unpaid', 'paid', 'cancelled', 'refunded')),
CONSTRAINT chk_invoice_positive_amount CHECK (total_amount >= 0 )
);
