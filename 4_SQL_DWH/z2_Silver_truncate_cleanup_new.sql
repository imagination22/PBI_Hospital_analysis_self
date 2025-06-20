CREATE OR ALTER PROCEDURE Silver.create_silver_cleanup AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();

ALTER TABLE   silver.Appointment      DROP CONSTRAINT    FK_Appointment_doctorID
ALTER TABLE   silver.Appointment      DROP CONSTRAINT    FK_Appointment_patientId
ALTER TABLE   silver.Bed      DROP CONSTRAINT    FK_Bed_patientID
ALTER TABLE   silver.Bed      DROP CONSTRAINT    FK_Bed_roomID
ALTER TABLE   silver.Billing      DROP CONSTRAINT    FK_Billing_patientID
ALTER TABLE   silver.Department      DROP CONSTRAINT    FK_Department_HeadDoctor
ALTER TABLE   silver.Doctor      DROP CONSTRAINT    FK_Doctor_departmentName
ALTER TABLE   silver.MedicalStock      DROP CONSTRAINT    FK_MedicalStock_SupplierId
ALTER TABLE   silver.MedicalTest      DROP CONSTRAINT    FK_MedicalTest_departmentId
ALTER TABLE   silver.medicine_patient      DROP CONSTRAINT    FK_medicinePatient_patientID
ALTER TABLE   silver.PatientTest      DROP CONSTRAINT    FK_PatientTest_doctorID
ALTER TABLE   silver.PatientTest      DROP CONSTRAINT    FK_PatientTest_patientID
ALTER TABLE   silver.PatientTest      DROP CONSTRAINT    FK_PatientTest_testID
ALTER TABLE   silver.Room      DROP CONSTRAINT    FK_Room_departmentID
ALTER TABLE   silver.SatisfactionScore      DROP CONSTRAINT    FK_SatisfactionScore_departmentName
ALTER TABLE   silver.SatisfactionScore      DROP CONSTRAINT    FK_SatisfactionScore_doctorID
ALTER TABLE   silver.SatisfactionScore      DROP CONSTRAINT    FK_SatisfactionScore_patientID
ALTER TABLE   silver.Staff      DROP CONSTRAINT    FK_Staff_departmentID
ALTER TABLE   silver.Surgery      DROP CONSTRAINT    FK_Surgery_appointmentID
ALTER TABLE   silver.Surgery      DROP CONSTRAINT    FK_Surgery_doctorID
ALTER TABLE   silver.Surgery      DROP CONSTRAINT    FK_Surgery_patientID

Truncate table silver.Appointment
Truncate table silver.Bed
Truncate table silver.Billing
Truncate table silver.Department
Truncate table silver.Doctor
Truncate table silver.MedicalStock
Truncate table silver.MedicalTest
Truncate table silver.medicine_patient
Truncate table silver.Patient
Truncate table silver.PatientTest
Truncate table silver.Room
Truncate table silver.SatisfactionScore
Truncate table silver.Staff
Truncate table silver.Supplier
Truncate table silver.Surgery

ALTER TABLE   silver.Appointment      ADD CONSTRAINT    FK_Appointment_doctorID FOREIGN KEY (doctor_id) References silver.Doctor(doctor_id)
ALTER TABLE   silver.Appointment      ADD CONSTRAINT    FK_Appointment_patientId FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.Bed      ADD CONSTRAINT    FK_Bed_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.Bed      ADD CONSTRAINT    FK_Bed_roomID FOREIGN KEY (room_id) References silver.Room(room_id)
ALTER TABLE   silver.Billing      ADD CONSTRAINT    FK_Billing_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.Department      ADD CONSTRAINT    FK_Department_HeadDoctor FOREIGN KEY (head_doctor_id) References silver.Doctor(doctor_id)
ALTER TABLE   silver.Doctor      ADD CONSTRAINT    FK_Doctor_departmentName FOREIGN KEY (department_name) References silver.Department(department_id)
ALTER TABLE   silver.MedicalStock      ADD CONSTRAINT    FK_MedicalStock_SupplierId FOREIGN KEY (supplier_id) References silver.Supplier(supplier_id)
ALTER TABLE   silver.MedicalTest      ADD CONSTRAINT    FK_MedicalTest_departmentId FOREIGN KEY (department_id) References silver.Department(department_id)
ALTER TABLE   silver.medicine_patient      ADD CONSTRAINT    FK_medicinePatient_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.PatientTest      ADD CONSTRAINT    FK_PatientTest_doctorID FOREIGN KEY (doctor_id) References silver.Doctor(doctor_id)
ALTER TABLE   silver.PatientTest      ADD CONSTRAINT    FK_PatientTest_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.PatientTest      ADD CONSTRAINT    FK_PatientTest_testID FOREIGN KEY (test_id) References silver.MedicalTest(test_id)
ALTER TABLE   silver.Room      ADD CONSTRAINT    FK_Room_departmentID FOREIGN KEY (department_id) References silver.Department(department_id)
ALTER TABLE   silver.SatisfactionScore      ADD CONSTRAINT    FK_SatisfactionScore_departmentName FOREIGN KEY (department_name) References silver.Department(name)
ALTER TABLE   silver.SatisfactionScore      ADD CONSTRAINT    FK_SatisfactionScore_doctorID FOREIGN KEY (doctor_id) References silver.Doctor(doctor_id)
ALTER TABLE   silver.SatisfactionScore      ADD CONSTRAINT    FK_SatisfactionScore_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)
ALTER TABLE   silver.Staff      ADD CONSTRAINT    FK_Staff_departmentID FOREIGN KEY (department_id) References silver.Department(department_id)
ALTER TABLE   silver.Surgery      ADD CONSTRAINT    FK_Surgery_appointmentID FOREIGN KEY (appointment_id) References silver.Appointment(appointment_id)
ALTER TABLE   silver.Surgery      ADD CONSTRAINT    FK_Surgery_doctorID FOREIGN KEY (doctor_id) References silver.Doctor(doctor_id)
ALTER TABLE   silver.Surgery      ADD CONSTRAINT    FK_Surgery_patientID FOREIGN KEY (patient_id) References silver.Patient(patient_id)

END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING DDL Silver  LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END