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
drop table if exists  gold.pbi_appointment
drop table if exists  gold.pbi_rating
drop table if exists  GOLD.PBI_BILL
drop table if exists  GOLD.pivot_bill
drop table if exists  GOLD.pbi_ageinfo
drop table if exists  GOLD.pbi_room_status
drop table if exists  GOLD.dim_surgery
drop table if exists  GOLD.pbi_avg_stay
drop table if exists  gold.pbi_tests
drop table if exists  gold.pbi_batch_dristribution
drop table if exists  gold.pbi_stock_value
drop table if exists  gold.pbi_Reorder_Alert
drop table if exists  gold.pbi_Medicines_Nearing_Expiry
drop table if exists  gold.pbi_stock_health_overview
drop table if exists  gold.pbi_department_revenue
drop table if exists gold.pbi_department_sub_revenue
drop table if exists gold.pbi_billing_effciency
drop table if exists gold.pbi_doctor_per_department
drop table if exists gold.pbi_dept_avg_bill_per_patient
drop table if exists gold.pbi_top_diagnosis_per_dept
drop table if exists gold.pbi_surgery_vs_no_surgery
drop table if exists  gold.pbi_reorder_risk_analysis
drop table if exists  GOLD.pbi_reorder_risk_analysis
drop table if exists  gold.pbi_customer_purchase_trend
drop table if exists  GOLD.PBI_STOCK_ANALYSIS
DROP TABLE IF EXISTS  GOLD.pbi_paymentmethod
DROP TABLE IF EXISTS gold.pbi_department_UNPIVOT_revenue
DROP TABLE IF EXISTS gold.fact_medicine_purchase
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