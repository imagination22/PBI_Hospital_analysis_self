CREATE OR ALTER PROCEDURE gold.insert_dim_date
AS
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
        INSERT INTO GOLD.Dim_Date (
            full_date,
            day,
            week,
            month_index,
            year,
            quarter,
            day_of_week,
            short_day_name,
            month_name,
            short_month_name,
            month_year,
            is_weekend,
            formatted_date,
            day_of_week_index 
        )
        SELECT 
            full_date,
            DAY(full_date) AS day,
            DATEPART(WEEK, full_date) AS week,
            MONTH(full_date) AS month_index,
            YEAR(full_date) AS year,
            DATEPART(QUARTER, full_date) AS quarter,
            DATENAME(WEEKDAY, full_date) AS day_of_week,
            LEFT(DATENAME(WEEKDAY, full_date), 3) AS short_day_name,
            DATENAME(MONTH, full_date) AS month_name,
            LEFT(DATENAME(MONTH, full_date), 3) AS short_month_name,
            FORMAT(full_date, 'MMM-yyyy') AS month_year,
            CASE WHEN DATEPART(WEEKDAY, full_date) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
            FORMAT(full_date, 'dd-MMM-yyyy') AS formatted_date,
          
            CASE DATENAME(WEEKDAY, full_date)
                WHEN 'Monday' THEN 1
                WHEN 'Tuesday' THEN 2
                WHEN 'Wednesday' THEN 3
                WHEN 'Thursday' THEN 4
                WHEN 'Friday' THEN 5
                WHEN 'Saturday' THEN 6
                WHEN 'Sunday' THEN 7
            END AS day_of_week_index
        FROM DateRange
        OPTION (MAXRECURSION 32767);

        SET @batch_end_time = GETDATE();
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING Dim_Date POPULATION';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;