CREATE
	OR

ALTER PROCEDURE Gold.create_ddl_gold
AS
BEGIN
	DECLARE @start_time DATETIME
		,@end_time DATETIME
		,@batch_start_time DATETIME
		,@batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		SET @start_time = GETDATE();

		CREATE TABLE GOLD.Dim_Patient (
			patient_skey INT PRIMARY KEY identity
			,patient_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,gender VARCHAR(10)
			,age INT
			,blood_group VARCHAR(10)
			,STATE VARCHAR(50)
			,admission_status VARCHAR(50)
			,image_path VARCHAR(500) NULL
			);

		CREATE TABLE GOLD.Dim_Doctor (
			doctor_skey INT PRIMARY KEY identity
			,doctor_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,specialization VARCHAR(100)
			,experience_years INT
			,availability VARCHAR(50)
			);

		CREATE TABLE GOLD.Dim_PaymentMethod (
			payment_method_skey INT PRIMARY KEY identity
			,method_name VARCHAR(50) UNIQUE -- Cash, Credit Card, Insurance, Online, etc.
			);

		/*
	CREATE TABLE GOLD.Dim_Department (
		department_skey INT PRIMARY KEY identity,
		department_id VARCHAR(255) UNIQUE,
		name VARCHAR(255),
		total_staff INT
);*/
		CREATE TABLE GOLD.Dim_Department (
			department_skey INT PRIMARY KEY IDENTITY(1, 1)
			,department_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,floor INT
			,head_doctor_id VARCHAR(255)
			,total_staff INT
			,phone_extension VARCHAR(10)
			,description VARCHAR(max)
			);

		/*
CREATE TABLE GOLD.Dim_Room (
    room_skey INT PRIMARY KEY IDENTITY(1,1),
    room_id VARCHAR(255) UNIQUE,
    room_type VARCHAR(50),
    capacity INT,
    daily_charges DECIMAL(10,2)
);

*/
		CREATE TABLE GOLD.Dim_Room (
			room_skey INT PRIMARY KEY IDENTITY(1, 1)
			,room_id VARCHAR(255) UNIQUE
			,room_type VARCHAR(50)
			,floor INT
			,capacity INT
			,STATUS VARCHAR(50)
			,daily_charges DECIMAL(10, 2)
			,avg_monthly_maintenance DECIMAL(10, 2)
			);

		CREATE TABLE GOLD.Dim_Test (
			test_skey INT PRIMARY KEY identity
			,test_id VARCHAR(255) UNIQUE
			,test_name VARCHAR(255)
			,category VARCHAR(100)
			,cost DECIMAL(10, 2)
		,department_id	VARCHAR(255)
,duration INT
		,fasting_required varCHAR(10)
			);

		CREATE TABLE GOLD.Dim_Medicine (
			medicine_skey INT PRIMARY KEY identity
			,medicine_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,category VARCHAR(100)
			,cost_price DECIMAL(10, 2)
			,unit_price DECIMAL(10, 2)
			,expiry_date DATE
			);

		CREATE TABLE GOLD.Dim_Supplier (
			supplier_skey INT PRIMARY KEY identity
			,supplier_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,contact_person VARCHAR(255)
			,city VARCHAR(50)
			,STATE VARCHAR(50)
			);
			CREATE TABLE GOLD.Dim_Date (
    date_skey INT PRIMARY KEY IDENTITY(1, 1),
    full_date DATE UNIQUE,                      -- Full date (e.g., 2024-01-01)
    day INT,                                    -- Day of month
    week INT,                                   -- Week number of year
    month_index INT,                            -- 1 = January, 12 = December
    year INT,                                   -- Year (e.g., 2025)
    quarter INT,                                -- Quarter (1–4)
    day_of_week VARCHAR(20),                    -- Full name (e.g., Monday)
    short_day_name CHAR(3),                     -- Short name (e.g., Mon)
    day_of_week_index INT,                      -- 1 = Monday, ..., 7 = Sunday
    month_name VARCHAR(20),                     -- Full month name (e.g., January)
    short_month_name CHAR(3),                   -- Short month name (e.g., Jan)
    month_year VARCHAR(20),                     -- Month and year (e.g., Jan-2025)
    is_weekend BIT,                             -- 1 = Saturday/Sunday, 0 = Weekday
    formatted_date VARCHAR(15)                  -- e.g., 21-Jun-2025
);
/*
		CREATE TABLE GOLD.Dim_Date (
			date_skey INT PRIMARY KEY IDENTITY(1, 1)
			,full_date DATE UNIQUE
			,day INT
			,month INT
			,year INT
			,quarter INT
			,day_of_week VARCHAR(20)
			,is_weekend BIT
			);
			*/
	/*
			CREATE TABLE GOLD.Dim_Date (
    date_skey INT PRIMARY KEY IDENTITY(1, 1),
    full_date DATE UNIQUE,                      -- e.g., 2024-01-01
    day INT,                                    -- e.g., 1
    day_of_week VARCHAR(20),                    -- e.g., Monday
    short_day_name CHAR(3),                     -- e.g., Mon
    month_index INT,                            -- Renamed from "month", e.g., 1 for January
    month_name VARCHAR(20),                     -- e.g., January
    month CHAR(3),                   -- e.g., Jan
    year INT, 
	week int , -- e.g., 2024
    quarter INT,                                -- e.g., 1
    month_year VARCHAR(20),                     -- e.g., Jan-2024 or January 2024
    is_weekend BIT,                             -- 0 = Weekday, 1 = Weekend
    formatted_date VARCHAR(15)                  -- e.g., 01-Jan-2024
);*/

/*
		CREATE TABLE GOLD.Dim_Time (
			time_skey INT PRIMARY KEY IDENTITY(1, 1)
			,time_value TIME UNIQUE
			,hour INT
			,minute INT
			,second INT
			,time_bucket VARCHAR(20) -- e.g., Morning, Afternoon, etc.
			);
			*/
		CREATE TABLE GOLD.Dim_Bed (
			bed_skey INT PRIMARY KEY IDENTITY(1, 1)
			,bed_id VARCHAR(255) UNIQUE
			,room_skey INT
			,--  Define this column before using it in a FK constraint
			STATUS VARCHAR(50)
			,-- Available, Occupied, Maintenance
			occupation_start_time DATETIME NULL
			,occupation_end_time DATETIME NULL
			,FOREIGN KEY (room_skey) REFERENCES GOLD.Dim_Room(room_skey)
			);

		CREATE TABLE GOLD.Fact_Appointments (
			appointment_id VARCHAR(255) PRIMARY KEY
			,patient_skey INT
			,doctor_skey INT
			,department_skey INT
			,date_skey INT
			,reason VARCHAR(max)
			,diagnosis VARCHAR(max)
			,payment_method_skey INT
			,discount DECIMAL(5, 2)
			,fees DECIMAL(10, 2)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (doctor_skey) REFERENCES GOLD.Dim_Doctor(doctor_skey)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			,FOREIGN KEY (date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			,FOREIGN KEY (payment_method_skey) REFERENCES GOLD.Dim_PaymentMethod(payment_method_skey)
			);

		CREATE TABLE GOLD.Fact_Billing (
			bill_id VARCHAR(255) PRIMARY KEY
			,patient_skey INT
			,admission_date_skey INT
			,discharge_date_skey INT
			,room_charges DECIMAL(10, 2)
			,surgery_charges DECIMAL(10, 2)
			,medicine_charges DECIMAL(10, 2)
			,test_charges DECIMAL(10, 2)
			,doctor_fees DECIMAL(10, 2)
			,total_amount DECIMAL(10, 2)
			,discount DECIMAL(10, 2)
			,amount_paid DECIMAL(10, 2)
			,balance_due DECIMAL(10, 2)
			,payment_status VARCHAR(50)
			,payment_method_skey INT
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (admission_date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			,FOREIGN KEY (discharge_date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			,FOREIGN KEY (payment_method_skey) REFERENCES GOLD.Dim_PaymentMethod(payment_method_skey)
			);

		/*
CREATE TABLE GOLD.Fact_PatientStay (
    stay_id VARCHAR(255) PRIMARY KEY ,
    patient_skey INT,
    room_skey INT,
    bed_skey INT,
    department_skey INT,
    days_admitted INT,
    daily_charge DECIMAL(10,2),
    total_room_cost DECIMAL(10,2),
    surgery_cost DECIMAL(10,2),
    FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey),
    FOREIGN KEY (room_skey) REFERENCES GOLD.Dim_Room(room_skey),
    FOREIGN KEY (bed_skey) REFERENCES GOLD.Dim_Bed(bed_skey),
    FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
);*/
		CREATE TABLE GOLD.Fact_PatientStay (
			stay_skey INT identity PRIMARY KEY
			,stay_id VARCHAR(255)
			,patient_skey INT
			,room_skey INT
			,bed_skey INT
			,department_skey INT
			,admission_date DATE
			,discharge_date DATE
			,days_admitted INT
			,admission_status VARCHAR(50)
			,image_path VARCHAR(500)
			,daily_charge DECIMAL(10, 2)
			,total_room_cost DECIMAL(10, 2)
			,surgery_cost DECIMAL(10, 2)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (room_skey) REFERENCES GOLD.Dim_Room(room_skey)
			,FOREIGN KEY (bed_skey) REFERENCES GOLD.Dim_Bed(bed_skey)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);

		CREATE TABLE GOLD.Fact_Tests (
			patient_test_id VARCHAR(255) PRIMARY KEY
			,test_skey INT
			,patient_skey INT
			,doctor_skey INT
			,test_date_skey INT
			,result_date_skey INT
			,test_cost DECIMAL(10, 2)
			,discount DECIMAL(5, 2)
			,result_status VARCHAR(50)
			,FOREIGN KEY (test_skey) REFERENCES GOLD.Dim_Test(test_skey)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (doctor_skey) REFERENCES GOLD.Dim_Doctor(doctor_skey)
			,FOREIGN KEY (test_date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			,FOREIGN KEY (result_date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			);

		CREATE TABLE GOLD.Fact_MedicinePurchases (
			purchase_id VARCHAR(255) PRIMARY KEY
			,patient_skey INT
			,medicine_skey INT
			,supplier_skey INT
			,date_skey INT
			,quantity_purchased INT
			,total_cost DECIMAL(10, 2)
			,discount_applied DECIMAL(5, 2)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (medicine_skey) REFERENCES GOLD.Dim_Medicine(medicine_skey)
			,FOREIGN KEY (supplier_skey) REFERENCES GOLD.Dim_Supplier(supplier_skey)
			,FOREIGN KEY (date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			);

		/*
		CREATE TABLE GOLD.Agg_MonthlyRevenue (
			month_skey INT PRIMARY KEY identity
			,department_skey INT
			,total_revenue DECIMAL(15, 2)
			,test_revenue DECIMAL(15, 2)
			,medicine_revenue DECIMAL(15, 2)
			,surgery_revenue DECIMAL(15, 2)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);

		CREATE TABLE GOLD.Agg_DoctorPerformance (
			month_skey INT PRIMARY KEY identity
			,doctor_skey INT
			,total_appointments INT
			,avg_rating DECIMAL(5, 2)
			,total_fees DECIMAL(15, 2)
			,FOREIGN KEY (doctor_skey) REFERENCES GOLD.Dim_Doctor(doctor_skey)
			);

		CREATE TABLE GOLD.Agg_BedOccupancy (
			date_skey INT PRIMARY KEY identity
			,department_skey INT
			,total_beds INT
			,occupied_beds INT
			,occupancy_rate DECIMAL(5, 2)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);
*/
		CREATE TABLE GOLD.Fact_PatientVitals (
			vitals_id INT PRIMARY KEY IDENTITY(1, 1)
			,patient_skey INT
			,record_date DATE
			,weight DECIMAL(5, 2)
			,
			-- You can expand with height, BMI, etc.
			FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			);

		CREATE TABLE GOLD.Fact_Admissions (
			admission_id INT PRIMARY KEY IDENTITY(1, 1)
			,patient_skey INT
			,admission_date DATE
			,discharge_date DATE
			,admission_status VARCHAR(50)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			);

		ALTER TABLE GOLD.Dim_Patient ADD address VARCHAR(MAX)
			,email VARCHAR(255)
			,phone VARCHAR(20);

		ALTER TABLE GOLD.Fact_Billing ADD other_charges DECIMAL(10, 2);

		ALTER TABLE GOLD.Dim_Doctor ADD department_skey INT FOREIGN KEY REFERENCES GOLD.Dim_Department (department_skey)
			,STATUS VARCHAR(50)
			,joining_date DATE
			,qualification VARCHAR(255)
			,phone VARCHAR(20)
			,email VARCHAR(255)
			,image_path VARCHAR(500);

		ALTER TABLE GOLD.Fact_Appointments ADD time_skey INT FOREIGN KEY REFERENCES GOLD.Dim_Time (time_skey)
			,STATUS VARCHAR(50)
			,doctor_notes VARCHAR(MAX)
			,suggestions VARCHAR(MAX);

		ALTER TABLE GOLD.Fact_Tests ADD test_result VARCHAR(255)
			,result_notes VARCHAR(MAX)
			,payment_method_skey INT FOREIGN KEY REFERENCES GOLD.Dim_PaymentMethod (payment_method_skey);

		ALTER TABLE GOLD.Dim_Medicine ADD manufacturing_date DATE
			,batch_number VARCHAR(50)
			,reorder_level INT;

		ALTER TABLE GOLD.Fact_MedicinePurchases ADD batch_number VARCHAR(50) NULL
			,time_skey INT NULL FOREIGN KEY REFERENCES GOLD.Dim_Time (time_skey);

		CREATE TABLE GOLD.Fact_MedicineInventorySnapshot (
			snapshot_date_skey INT FOREIGN KEY REFERENCES GOLD.Dim_Date(date_skey)
			,medicine_skey INT FOREIGN KEY REFERENCES GOLD.Dim_Medicine(medicine_skey)
			,stock_quantity INT
			,reorder_level INT
			);

		ALTER TABLE GOLD.Dim_Supplier ADD phone VARCHAR(20)
			,email VARCHAR(255)
			,address VARCHAR(MAX)
			,landmark VARCHAR(255)
			,pincode INT
			,contract_start DATE
			,contract_end DATE;

		CREATE TABLE GOLD.Dim_Staff (
			staff_skey INT PRIMARY KEY IDENTITY(1, 1)
			,staff_id VARCHAR(255) UNIQUE
			,name VARCHAR(255)
			,department_skey INT
			,ROLE VARCHAR(100)
			,salary DECIMAL(10, 2)
			,joining_date DATE
			,shift VARCHAR(50)
			,phone VARCHAR(20)
			,email VARCHAR(255)
			,address VARCHAR(MAX)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);

		CREATE TABLE GOLD.Fact_SatisfactionScore (
			satisfaction_id VARCHAR(255) PRIMARY KEY
			,patient_skey INT
			,doctor_skey INT
			,department_skey INT
			,date_skey INT
			,rating INT
			,feedback VARCHAR(MAX)
			,FOREIGN KEY (patient_skey) REFERENCES GOLD.Dim_Patient(patient_skey)
			,FOREIGN KEY (doctor_skey) REFERENCES GOLD.Dim_Doctor(doctor_skey)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			,FOREIGN KEY (date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			);

		-- Example of refined structure
		CREATE TABLE GOLD.Agg_MonthlyRevenue (
			month_skey INT
			,department_skey INT
			,total_revenue DECIMAL(15, 2)
			,test_revenue DECIMAL(15, 2)
			,medicine_revenue DECIMAL(15, 2)
			,surgery_revenue DECIMAL(15, 2)
			,other_revenue AS (total_revenue - test_revenue - medicine_revenue - surgery_revenue) PERSISTED
			,num_patients INT
			,num_bills INT
			,PRIMARY KEY (
				month_skey
				,department_skey
				)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);

		CREATE TABLE GOLD.Agg_DoctorPerformance (
			month_skey INT
			,doctor_skey INT
			,total_appointments INT
			,avg_rating DECIMAL(5, 2)
			,rating_stddev DECIMAL(5, 2)
			,total_fees DECIMAL(15, 2)
			,avg_fees_per_appointment AS (
				CASE 
					WHEN total_appointments = 0
						THEN 0
					ELSE total_fees / total_appointments
					END
				) PERSISTED
			,num_feedbacks INT
			,PRIMARY KEY (
				month_skey
				,doctor_skey
				)
			,FOREIGN KEY (doctor_skey) REFERENCES GOLD.Dim_Doctor(doctor_skey)
			);

		CREATE TABLE GOLD.Agg_BedOccupancy (
			date_skey INT
			,
			--  department_skey INT,
			total_beds INT
			,occupied_beds INT
			,occupancy_rate DECIMAL(5, 2)
			,avg_stay_duration DECIMAL(5, 2)
			,num_admissions INT
			,turnover_rate DECIMAL(5, 2)
			,-- admissions / total_beds
			PRIMARY KEY (date_skey) --, department_skey),
			--  FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey),
			,FOREIGN KEY (date_skey) REFERENCES GOLD.Dim_Date(date_skey)
			);

		CREATE TABLE GOLD.Agg_TestAnalytics (
			test_skey INT
			,month_skey INT
			,num_tests INT
			,abnormal_results INT
			,avg_test_cost DECIMAL(10, 2)
			,FOREIGN KEY (test_skey) REFERENCES GOLD.Dim_Test(test_skey)
			,FOREIGN KEY (month_skey) REFERENCES GOLD.Dim_Date(date_skey)
			,PRIMARY KEY (
				test_skey
				,month_skey
				)
			);

		CREATE TABLE GOLD.Agg_PatientDemographics (
			month_skey INT
			,gender VARCHAR(10)
			,age_group VARCHAR(20)
			,region VARCHAR(50)
			,num_patients INT
			,avg_visits INT
			,PRIMARY KEY (
				month_skey
				,gender
				,age_group
				,region
				)
			,FOREIGN KEY (month_skey) REFERENCES GOLD.Dim_Date(date_skey)
			);

		CREATE TABLE GOLD.Agg_SatisfactionTrend (
			month_skey INT
			,department_skey INT
			,avg_rating DECIMAL(5, 2)
			,rating_stddev DECIMAL(5, 2)
			,num_responses INT
			,PRIMARY KEY (
				month_skey
				,department_skey
				)
			,FOREIGN KEY (department_skey) REFERENCES GOLD.Dim_Department(department_skey)
			);
	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING DDL GOLD LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
