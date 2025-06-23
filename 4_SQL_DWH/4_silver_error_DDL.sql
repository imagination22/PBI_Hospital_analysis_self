CREATE OR ALTER PROCEDURE Silver_error.create_ddl_error_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();
		--	Silver_error layer DDL  Silver_error.
-- Address Table
/*
CREATE TABLE Silver_error.Address (
    address_id INT  IDENTITY(1,1),
    address NVARCHAR(255),
    city NVARCHAR(100) default Null ,
    state NVARCHAR(100),
    pincode NVARCHAR(20) default Null,
	FOREIGN KEY (address_id) REFERENCES Silver_error.Address(address_id)
)
;*/
--  Patient Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Patient'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Patient Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Patient (
		patient_id VARCHAR(255) 
		,name VARCHAR(255)
		,age INT
		,gender VARCHAR(10)
		,weight DECIMAL(5, 2)
		,blood_group VARCHAR(10)
		,address VARCHAR(max)
		,STATE VARCHAR(255)
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,admission_date DATE
		,discharge_date DATE
		,admission_status VARCHAR(50)
		,image_path VARCHAR(500) DEFAULT NULL
		);
END

--  Department Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Department'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Department Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Department (
		department_id VARCHAR(255) 
		,name VARCHAR(255)
		,floor INT
		,head_doctor_id VARCHAR(255)
		,total_staff INT
		,phone_extension VARCHAR(10)
		,description VARCHAR(max)
		--FOREIGN KEY (head_doctor_id) REFERENCES Doctor(doctor_id)
		);
END


--  Doctor Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Doctor'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Doctor Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Doctor (
		doctor_id VARCHAR(255) 
		,name VARCHAR(255)
		,specialization VARCHAR(100)
		,department_name VARCHAR(255)
		,salary DECIMAL(10, 2)
		,STATUS VARCHAR(50)
		,availability VARCHAR(50)
		,joining_date DATE
		,qualification VARCHAR(255)
		,experience_years INT
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,image_path VARCHAR(500)
	--	,FOREIGN KEY (department_id) REFERENCES Silver_error.Department(department_id)
		);
END

/*
IF NOT EXISTS (
		SELECT 1
		FROM sys.foreign_keys
		WHERE name = 'FK_Department_HeadDoctor'
			AND parent_object_id = OBJECT_ID('Silver_error.Department')
		)
BEGIN
	ALTER TABLE Silver_error.Department ADD CONSTRAINT FK_Department_HeadDoctor FOREIGN KEY (head_doctor_id) REFERENCES Silver_error.Doctor (doctor_id);

	PRINT 'Foreign key FK_Department_HeadDoctor created.';
END
ELSE
BEGIN
	PRINT 'Foreign key FK_Department_HeadDoctor already exists.';
END;
*/
--  Appointment Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Appointment'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Appointment Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Appointment (
		appointment_id VARCHAR(255) 
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,appointment_date DATE
		,appointment_time TIME
		,STATUS VARCHAR(max)
		,reason VARCHAR(max)
		,doctor_notes VARCHAR(max)
		,suggestions VARCHAR(max)
		,fees DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount DECIMAL(5, 2)
		,diagnosis VARCHAR(max)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		--,FOREIGN KEY (doctor_id) REFERENCES Silver_error.Doctor(doctor_id)
		);
END

--  Surgery Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Surgery'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT ' Surgery Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Surgery (
		surgery_id INT identity 
		,appointment_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,appointment_date DATE
		,Appointment_time DATETIME2
		,STATUS VARCHAR(50)
		,reason VARCHAR(255)
		,comments VARCHAR(255)
		,surgery_notes VARCHAR(max)
		,fees DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount DECIMAL(5, 2)
		--,FOREIGN KEY (appointment_id) REFERENCES Silver_error.Appointment(appointment_id)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		--,FOREIGN KEY (doctor_id) REFERENCES Silver_error.Doctor(doctor_id)
		);
END

--  Room Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Room'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Room Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Room (
		room_id VARCHAR(255) 
		,department_id VARCHAR(255)
		,room_type VARCHAR(50)
		,floor INT
		,capacity INT
		,STATUS VARCHAR(50)
		,daily_charges DECIMAL(10, 2)
		,avg_monthly_maintenance DECIMAL(10, 2)
		--,FOREIGN KEY (department_id) REFERENCES Silver_error.Department(department_id)
		);
END

--  Bed Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Bed'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Bed Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Bed (
		bed_id VARCHAR(255) 
		,room_id VARCHAR(255)
		,current_status VARCHAR(50)
		,patient_id VARCHAR(255) NULL
		,occupation_start_time DATETIME
		,occupation_end_time DATETIME
		--,FOREIGN KEY (room_id) REFERENCES Silver_error.Room(room_id)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		);
END

--  Billing Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Billing'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Billing Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Billing (
		bill_id VARCHAR(255) 
		,patient_id VARCHAR(255)
		,admission_date DATE
		,discharge_date DATE
		,room_charges DECIMAL(10, 2)
		,surgery_charges DECIMAL(10, 2)
		,medicine_charges DECIMAL(10, 2)
		,test_charges DECIMAL(10, 2)
		,doctor_fees DECIMAL(10, 2)
		,other_charges DECIMAL(10, 2)
		,total_amount DECIMAL(10, 2)
		,discount DECIMAL(10, 2)
		,amount_paid DECIMAL(10, 2)
		,payment_status VARCHAR(50)
		,payment_method VARCHAR(50)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		);
END

--  Medical Stock Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'MedicalStock'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'MedicalStock Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.MedicalStock (
		medicine_id VARCHAR(255) 
		,name VARCHAR(255)
		,category VARCHAR(100)
		,supplier_id VARCHAR(255)
		,cost_price DECIMAL(10, 2)
		,unit_price DECIMAL(10, 2)
		,stock_quantity INT
		,expiry_date DATE
		,manufacturing_date DATE
		,batch_number VARCHAR(50)
		,reorder_level INT
		--FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id)
		);
END

--  Medical Test Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'MedicalTest'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'MedicalTest Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.MedicalTest (
		test_id VARCHAR(255) 
		,test_name VARCHAR(255)
		,category VARCHAR(100)
		,department_id VARCHAR(255)
		,cost DECIMAL(10, 2)
		,duration INT
		,fasting_required varCHAR(10)
	--	,FOREIGN KEY (department_id) REFERENCES Silver_error.Department(department_id)
		);
END

--  Patient Test Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'PatientTest'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'PatientTest Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.PatientTest (
		patient_test_id VARCHAR(255) 
		,patient_id VARCHAR(255)
		,test_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,test_date DATE
		,result_date DATE
		,STATUS VARCHAR(255)
		,result VARCHAR(255)
		,result_notes VARCHAR(max)
		,amount DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount DECIMAL(10, 2)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		--,FOREIGN KEY (test_id) REFERENCES Silver_error.MedicalTest(test_id)
		--,FOREIGN KEY (doctor_id) REFERENCES Silver_error.Doctor(doctor_id)
		);
END

--  Satisfaction Score Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'SatisfactionScore'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'SatisfactionScore Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.SatisfactionScore (
		satisfaction_id VARCHAR(255) 
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,rating INT
		,feedback VARCHAR(max)
		,DATE DATE
		,department_name VARCHAR(255)
		--,FOREIGN KEY (doctor_id) REFERENCES Silver_error.Doctor(doctor_id)
		--,FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		--,FOREIGN KEY (department_id) REFERENCES Silver_error.Department(department_id)
		);
END

--  Staff Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Staff'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Staff Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Staff (
		staff_id VARCHAR(255) 
		,name VARCHAR(255)
		,department_id VARCHAR(255)
		,ROLE VARCHAR(100)
		,salary DECIMAL(10, 2)
		,joining_date DATE
		,shift VARCHAR(50)
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,address VARCHAR(max)
	--	,FOREIGN KEY (department_id) REFERENCES Silver_error.Department(department_id)
		);
END

--  Supplier Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Supplier'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'Supplier Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.Supplier (
		supplier_id VARCHAR(255) 
		,name VARCHAR(255)
		,contact_person VARCHAR(255)
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,address VARCHAR(max)
		,city VARCHAR(max)
		,landmark VARCHAR(255)
		,pincode INT
		,STATE VARCHAR(255)
		,contract_start DATE
		,contract_end DATE
		);
END

--FK_MedicalStock_Supplier
IF NOT EXISTS (
		SELECT 1
		FROM sys.foreign_keys
		WHERE name = 'FK_MedicalStock_Supplier'
			AND parent_object_id = OBJECT_ID('Silver_error.MedicalStock')
		)
		/*
BEGIN
	ALTER TABLE Silver_error.MedicalStock ADD CONSTRAINT FK_MedicalStock_Supplier FOREIGN KEY (supplier_id) REFERENCES Silver_error.Supplier (supplier_id);

	PRINT 'FK_MedicalStock_Supplier created successfully.';
END
ELSE
BEGIN
	PRINT 'FK_MedicalStock_Supplier already exists.';
END;*/

-- medicine_patient 
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'medicine_patient'
			AND TABLE_SCHEMA = 'Silver_error'
		)
BEGIN
	PRINT 'medicine_patient Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Silver_error.medicine_patient (
		med_patient_id INT identity 
		,patient_id VARCHAR(255)
		,medicine VARCHAR(255)
		,Quantity INT
		,purchase_date DATE
		--FOREIGN KEY (patient_id) REFERENCES Silver_error.Patient(patient_id)
		);
END
END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING DDL Silver ERROR LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END