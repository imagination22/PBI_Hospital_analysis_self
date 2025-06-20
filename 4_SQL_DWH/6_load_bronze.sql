/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
Source : 
	C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\
	execute bronze.load_bronze 
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();
/************************************************************************************************************/
		--Bronze.Patient
		
		TRUNCATE TABLE bronze.Patient;
		SET @start_time = GETDATE();
		BULK INSERT bronze.Patient
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\patient.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.Patient: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

 /************************************************************************************************************/
  -- Bronze.Department
 
 		TRUNCATE TABLE Bronze.Department;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Department
	FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Department.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Department: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
/************************************************************************************************************/
		-- Bronze.Doctor
		
		TRUNCATE TABLE  Bronze.Doctor;
		--SET @start_time = GETDATE();
		BULK INSERT  Bronze.Doctor
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Doctor.csv'
		WITH (
			FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    --FIELDQUOTE = '"',
    --CODEPAGE = '65001',
    --MAXERRORS = 100,
    --ERRORFILE = 'C:\Temp\Doctor_Errors.log',
    TABLOCK

		);
		--SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Doctor: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
/************************************************************************************************************/
		--Bronze.Appointment
		
		TRUNCATE TABLE Bronze.Appointment;
		--SET @start_time = GETDATE();
		BULK INSERT Bronze.Appointment
	FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Appointment.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
			

		);
	--	SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Appointment: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
/************************************************************************************************************/
		--Bronze.Surgery
		
		
		TRUNCATE TABLE Bronze.Surgery;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Surgery
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Surgery.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Surgery: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
/************************************************************************************************************/
		--Bronze.Room
		
		TRUNCATE TABLE Bronze.Room;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Room
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Rooms.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Room: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.Bed
		
		TRUNCATE TABLE Bronze.Bed;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Bed
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Beds.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.Bed: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
/************************************************************************************************************/
			TRUNCATE TABLE Bronze.Billing;
			
			--SET @start_time = GETDATE();
			BULK INSERT Bronze.Billing
			FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Hospital_Bills.csv'
			WITH (
				FIRSTROW = 2,
				FIELDTERMINATOR = ',',
				ROWTERMINATOR = '\n',TABLOCK
			);
			 PRINT '>> Load Bronze.Billing: '
		--SET @end_time = GETDATE();
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.MedicalStock
		 
		TRUNCATE TABLE Bronze.MedicalStock;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.MedicalStock
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Medical_Stock.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.MedicalStock: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.MedicalTest
		
		TRUNCATE TABLE Bronze.MedicalTest;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.MedicalTest
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Medical_Tests.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.MedicalTest: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
	/*	--Bronze.MedicalStock
		
		TRUNCATE TABLE Bronze.MedicalStock;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.MedicalStock
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Medical_Stock.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		 PRINT '>> Load Bronze.MedicalStock: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		*/
/************************************************************************************************************/
		--Bronze.PatientTest
		
		TRUNCATE TABLE Bronze.PatientTest;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.PatientTest
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Patient_Tests.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.PatientTest: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.SatisfactionScore
		
		TRUNCATE TABLE Bronze.SatisfactionScore;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.SatisfactionScore
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Satisfaction_Score.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.SatisfactionScore: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.Staff
		
		TRUNCATE TABLE Bronze.Staff;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Staff
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Staff.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.Staff: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		--Bronze.Supplier
		
		TRUNCATE TABLE Bronze.Supplier;
		SET @start_time = GETDATE();
		BULK INSERT Bronze.Supplier
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\Supplier.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Bronze.Supplier: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

/************************************************************************************************************/
		TRUNCATE TABLE Bronze.medicine_patient;
		
		--SET @start_time = GETDATE();
		BULK INSERT Bronze.medicine_patient
		FROM 'C:\Users\Lenovo\OneDrive\Desktop\Repository\Hospital_my_work\PBI_Hospital_analysis_self\2_CSV_source\medicine_patient.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',TABLOCK
		);
		--SET @end_time = GETDATE();
		PRINT '>> Load Bronze.medicine_patient;: '
		--PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';



      



	   
		SET @batch_end_time = GETDATE();
	
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
/*
	   Bronze.Patient
	   Bronze.Department
	   Bronze.Doctor
	   Bronze.Appointment
	   Bronze.Surgery
	   Bronze.Room
	   Bronze.Bed 
	   Bronze.Billing
	   Bronze.MedicalStock
	   Bronze.MedicalTest
	   Bronze.PatientTest
	   Bronze.SatisfactionScore
	   Bronze.Staff
	   Bronze.Supplier
	   Bronze.medicine_patient

	   */