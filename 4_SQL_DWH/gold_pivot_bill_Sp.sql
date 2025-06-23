CREATE
	OR

ALTER PROCEDURE Gold.pivot_bill_sp
AS
BEGIN
	DECLARE @start_time DATETIME
		,@end_time DATETIME
		,@batch_start_time DATETIME
		,@batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		SET @start_time = GETDATE();

		SELECT patient_skey
			,'Room Charges' AS charge_type
			,room_charges AS amount
		INTO gold.pivot_bill
		FROM gold.Fact_Billing
		
		UNION ALL
		
		SELECT patient_skey
			,'Surgery Charges'
			,surgery_charges
		FROM gold.Fact_Billing
		
		UNION ALL
		
		SELECT patient_skey
			,'Medicine Charges'
			,medicine_charges
		FROM gold.Fact_Billing
		
		UNION ALL
		
		SELECT patient_skey
			,'Test Charges'
			,test_charges
		FROM gold.Fact_Billing
		
		UNION ALL
		
		SELECT patient_skey
			,'Doctor Fees'
			,doctor_fees
		FROM gold.Fact_Billing
		
		UNION ALL
		
		SELECT patient_skey
			,'Other Charges'
			,other_charges
		FROM gold.Fact_Billing;

		SET @batch_end_time = GETDATE();

		PRINT 'Loading gold Layer is Completed';
		PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	END TRY

	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING insert into gold layer'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
