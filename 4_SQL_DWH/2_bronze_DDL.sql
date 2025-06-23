CREATE OR ALTER PROCEDURE bronze.create_ddl_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();


IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Patient'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Patient Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Patient (
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
		,admission_date VARCHAR(12)
		,discharge_date VARCHAR(12)
		,admission_status VARCHAR(50)
		,image_path VARCHAR(500) DEFAULT NULL
		);
END

--  Department Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Department'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Department Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Department (
		department_id VARCHAR(255)
		,name VARCHAR(255)
		,floor INT
		,head_doctor_id VARCHAR(255)
		,total_staff INT
		,phone_extension VARCHAR(10)
		,description VARCHAR(max)
		);
END

--  Doctor Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Doctor'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Doctor Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Doctor (
		doctor_id VARCHAR(255)
		,name VARCHAR(255)
		,specialization VARCHAR(100)
		,department_name VARCHAR(255)
		,salary DECIMAL(10, 2)
		,STATUS VARCHAR(50)
		,availability VARCHAR(50)
		,joining_date VARCHAR(12)
		,qualification VARCHAR(255)
		,experience_years INT
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,image_path VARCHAR(500)
		);
END

--  Appointment Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Appointment'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Appointment Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
		
END
ELSE
BEGIN
	CREATE TABLE Bronze.Appointment (
		appointment_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,appointment_date VARCHAR(12)
		,appointment_time  VARCHAR(20)
		,STATUS VARCHAR(max)
		,reason VARCHAR(max)
		,doctor_notes VARCHAR(max)
		,suggestions VARCHAR(max) NULL
		,fees DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount DECIMAL(5, 2)
		,diagnosis VARCHAR(max)
		);
END

--  Surgery Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Surgery'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Surgery Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Surgery (
		--surgery_id VARCHAR(255) ,
		appointment_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,appointment_date VARCHAR(12)
		,Appointment_time VARCHAR(20)
		,STATUS VARCHAR(50)
		,reason VARCHAR(255)
		,comments VARCHAR(255)
		,surgery_notes VARCHAR(max)
		,fees DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount DECIMAL(5, 2)
		);
END

--  Room Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Room'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Room Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Room (
		room_id VARCHAR(255)
		,department_id VARCHAR(255)
		,room_type VARCHAR(50)
		,floor INT
		,capacity INT
		,STATUS VARCHAR(50)
		,daily_charges DECIMAL(10, 2)
		,avg_monthly_maintenance DECIMAL(10, 2)
		);
END

--  Bed Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Bed'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Bed Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Bed (
		bed_id VARCHAR(255)
		,room_id VARCHAR(255)
		,current_status VARCHAR(50)
		,patient_id VARCHAR(255) NULL
		,occupation_start_time VARCHAR(255)
		,occupation_end_time VARCHAR(255)
		);
END

--  Billing Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Billing'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Billing Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Billing (
		bill_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,admission_date VARCHAR(12)
		,discharge_date VARCHAR(12)
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
		);
END

--drop table  Bronze.Billing
--  Medical Stock Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'MedicalStock'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'MedicalStock Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.MedicalStock (
		medicine_id VARCHAR(255)
		,name VARCHAR(255)
		,category VARCHAR(100)
		,supplier_id VARCHAR(255)
		,cost_price DECIMAL(10, 2)
		,unit_price DECIMAL(10, 2)
		,stock_quantity INT
		,expiry_date VARCHAR(12)
		,manufacturing_date VARCHAR(12)
		,batch_number VARCHAR(50)
		,reorder_level INT
		);
END

--  Medical Test Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'MedicalTest'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'MedicalTest Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.MedicalTest (
		test_id VARCHAR(255)
		,test_name VARCHAR(255)
		,category VARCHAR(100)
		,department_id VARCHAR(255)
		,cost DECIMAL(10, 2)
		,duration INT
		,fasting_required VARCHAR(10)
		);
END

--  Patient Test Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'PatientTest'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'PatientTest Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.PatientTest (
		patient_test_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,test_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,test_date VARCHAR(12)
		,result_date VARCHAR(12)
		,STATUS VARCHAR(255)
		,result VARCHAR(255)
		,result_notes VARCHAR(max)
		,amount DECIMAL(10, 2)
		,payment_method VARCHAR(50)
		,discount VARCHAR(50)
		);
END

--  Satisfaction Score Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'SatisfactionScore'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'SatisfactionScore Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.SatisfactionScore (
		satisfaction_id VARCHAR(255)
		,patient_id VARCHAR(255)
		,doctor_id VARCHAR(255)
		,rating INT
		,feedback VARCHAR(max)
		,DATE VARCHAR(12)
		,department_name VARCHAR(255)
		);
END

--  Staff Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Staff'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Staff Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Staff (
		staff_id VARCHAR(255)
		,name VARCHAR(255)
		,department_id VARCHAR(255)
		,ROLE VARCHAR(100)
		,salary DECIMAL(10, 2)
		,joining_date VARCHAR(12)
		,shift VARCHAR(50)
		,phone VARCHAR(20)
		,email VARCHAR(255)
		,address VARCHAR(max)
		);
END

--  Supplier Table
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'Supplier'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'Supplier Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.Supplier (
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
		,contract_start VARCHAR(255)
		,contract_end VARCHAR(255)
		);
END

-- medicine_patient 
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_NAME = 'medicine_patient'
			AND TABLE_SCHEMA = 'Bronze'
		)
BEGIN
	PRINT 'medicine_patient Table exists';
		-- You can add other operations here (e.g., SELECT, INSERT)
END
ELSE
BEGIN
	CREATE TABLE Bronze.medicine_patient (
		patient_id VARCHAR(255)
		,medicine VARCHAR(255)
		,Quantity INT
		,purchase_date VARCHAR(12)
		);
END

		SET @batch_end_time = GETDATE();
	
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING DDL BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END