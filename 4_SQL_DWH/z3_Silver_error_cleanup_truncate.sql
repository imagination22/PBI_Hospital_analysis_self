CREATE OR ALTER PROCEDURE Silver.create_silver_error_cleanup AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();

Truncate table   Silver_error.Appointment
Truncate table   Silver_error.Bed
Truncate table   Silver_error.Billing
Truncate table   Silver_error.Department
Truncate table   Silver_error.Doctor
Truncate table   Silver_error.MedicalStock
Truncate table   Silver_error.MedicalTest
Truncate table   Silver_error.medicine_patient
Truncate table   Silver_error.Patient
Truncate table   Silver_error.PatientTest
Truncate table   Silver_error.Room
Truncate table   Silver_error.SatisfactionScore
Truncate table   Silver_error.Staff
Truncate table   Silver_error.Supplier
Truncate table   Silver_error.Surgery

END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING cleanup  Silver error LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END