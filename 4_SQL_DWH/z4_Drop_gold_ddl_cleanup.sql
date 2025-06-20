CREATE OR ALTER PROCEDURE Gold.cleanup AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();

DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += 'ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
INNER JOIN sys.tables t ON fk.parent_object_id = t.object_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE s.name = 'gold';

EXEC sp_executesql @sql;




drop table if exists gold.Agg_BedOccupancy
drop table if exists gold.Agg_DoctorPerformance
drop table if exists gold.Agg_MonthlyRevenue
drop table if exists gold.Agg_PatientDemographics
drop table if exists gold.Agg_SatisfactionTrend
drop table if exists gold.Agg_TestAnalytics
drop table if exists gold.Dim_Bed
drop table if exists gold.Dim_Date
drop table if exists gold.Dim_Department
drop table if exists gold.Dim_Doctor
drop table if exists gold.Dim_Medicine
drop table if exists gold.Dim_Patient
drop table if exists gold.Dim_PaymentMethod
drop table if exists gold.Dim_Room
drop table if exists gold.Dim_Staff
drop table if exists gold.Dim_Supplier
drop table if exists gold.Dim_Test
drop table if exists gold.Dim_Time
drop table if exists gold.Fact_Admissions
drop table if exists gold.Fact_Appointments
drop table if exists gold.Fact_Billing
drop table if exists gold.Fact_MedicineInventorySnapshot
drop table if exists gold.Fact_MedicinePurchases
drop table if exists gold.Fact_PatientStay
drop table if exists gold.Fact_PatientVitals
drop table if exists gold.Fact_SatisfactionScore
drop table if exists gold.Fact_Tests


END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING gold cleanup'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END