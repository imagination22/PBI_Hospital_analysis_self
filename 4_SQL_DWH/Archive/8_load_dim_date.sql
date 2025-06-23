CREATE OR ALTER PROCEDURE gold.insert_dim_date AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
	BEGIN TRY



		SET @batch_start_time = GETDATE();
		
		SET @start_time = GETDATE();

DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2050-12-31';

WITH DateRange AS (
    SELECT @StartDate AS full_date
    UNION ALL
    SELECT DATEADD(DAY, 1, full_date)
    FROM DateRange
    WHERE full_date < @EndDate
)
INSERT INTO GOLD.Dim_Date (full_date, day, month, year, quarter, day_of_week, is_weekend)
SELECT 
    full_date,
    DAY(full_date),
    MONTH(full_date),
    YEAR(full_date),
    DATEPART(QUARTER, full_date),
    DATENAME(WEEKDAY, full_date),
    CASE WHEN DATEPART(WEEKDAY, full_date) IN (1, 7) THEN 1 ELSE 0 END
FROM DateRange
OPTION (MAXRECURSION 32767)



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

/*
;WITH TimeSlots AS (
    SELECT 
        CAST('00:00:00' AS TIME) AS time_value,
        0 AS minute_increment
    UNION ALL
    SELECT 
        CAST(DATEADD(MINUTE, minute_increment, '00:00:00') AS TIME),
        minute_increment + 1
    FROM TimeSlots
    WHERE minute_increment < 1439
)
INSERT INTO GOLD.Dim_Time (time_value, hour, minute, second, time_bucket)
SELECT 
    ts.time_value,
    DATEPART(HOUR, ts.time_value),
    DATEPART(MINUTE, ts.time_value),
    DATEPART(SECOND, ts.time_value),
    CASE 
        WHEN DATEPART(HOUR, ts.time_value) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, ts.time_value) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, ts.time_value) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END
FROM TimeSlots ts
WHERE NOT EXISTS (
    SELECT 1 FROM GOLD.Dim_Time dt WHERE dt.time_value = ts.time_value
)
OPTION (MAXRECURSION 32767);
*/