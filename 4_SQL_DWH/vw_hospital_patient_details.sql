
CREATE 
   or alter 
VIEW vw_hospital_patient_details AS
SELECT
    -- Patient Info
    p.patient_id AS patient_patient_id,
    p.name AS patient_name,
    p.gender AS patient_gender,
    p.weight AS patient_weight,
    p.age AS patient_age,
    p.blood_group AS patient_blood_group,
    p.email AS patient_email,
    p.admission_date AS patient_admission_date,
    p.discharge_date AS patient_discharge_date,
    p.address AS patient_address,
    p.admission_status AS patient_status,
    CASE 
      WHEN b.bed_id IS NULL THEN 'Discharge' 
      ELSE 'Admitted' 
    END AS patient_admission_status,

    -- Doctor Info
    dr.doctor_id AS doctor_doctor_id,
    dr.name AS doctor_name,
    dr.salary AS doctor_salary,
    dr.specialization AS doctor_specialization,
    dr.department_name AS doctor_department,
    dr.availability AS doctor_availability,
    dr.joining_date AS doctor_joining_date,
    dr.qualification AS doctor_qualification,
    dr.experience_years AS doctor_experience_years,
    dr.email AS doctor_email,
    dr.phone AS doctor_phone,

    -- Bed Info
    b.bed_id AS beds_bed_id,
    b.occupation_start_time AS beds_occupied_from,
    b.occupation_end_time AS beds_occupied_till,
    b.current_status AS beds_status, 

    -- Room Info
    r.room_id AS room_room_id,
    r.floor AS room_floor,
    r.room_type AS room_room_type,
    r.capacity AS room_capacity,
    r.daily_charges AS room_daily_charge,
    r.avg_monthly_maintenance AS room_avgmontlymaintenancecost,
    r.status AS room_status,

    -- Department Info
    dep.department_id AS department_department_id,
    dep.name AS department_name,
    dep.total_staff AS department_total_staff,

    -- Satisfaction Score
    s.satisfaction_id AS satisfaction_satisfaction_id,
    s.rating AS satisfaction_rating,
    s.feedback AS satisfaction_feedback,

    -- Surgery Info
    sur.appointment_id AS surgery_appointment_id,
    sur.appointment_date AS surgery_appointment_date,
    sur.appointment_time AS surgery_appointment_time,
    sur.status AS surgery_status,
    sur.reason AS surgery_reason,
    sur.surgery_notes AS surgery_notes,

    -- Billing Info
    hb.room_charges,
    hb.surgery_charges,
    hb.medicine_charges,
    hb.test_charges,
    hb.doctor_fees,
    hb.other_charges,
    hb.total_amount,
    hb.discount,
    hb.amount_paid,
    hb.payment_method,
    hb.payment_status

FROM bronze.patient p 
LEFT JOIN bronze.satisfactionscore s ON p.patient_id = s.patient_id
LEFT JOIN bronze.surgery sur ON sur.patient_id = p.patient_id
LEFT JOIN bronze.billing hb ON hb.patient_id = p.patient_id
LEFT JOIN bronze.bed b ON b.patient_id = p.patient_id
LEFT JOIN bronze.room r ON r.room_id = b.room_id
LEFT JOIN bronze.department dep ON dep.department_id = r.department_id
LEFT JOIN (
    SELECT DISTINCT patient_id, doctor_id 
    FROM bronze.appointment
) a ON a.patient_id = p.patient_id
LEFT JOIN bronze.doctor dr ON dr.doctor_id = a.doctor_id;