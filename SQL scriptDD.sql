IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'abfss://raw@dlsg2a_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [abfss://raw@dlsg2a_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://raw@dlsg2a.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[dim_date]
WITH (
    LOCATION = 'dim_date_1',
    DATA_SOURCE = abfss://raw@dlsg2a_dfs_core_windows_net,
    FILE_FORMAT = SynapseDelimitedTextFormat
)
AS
WITH unified_dates AS (
    SELECT TRY_CAST(start_at AS DATE) AS date_column FROM [dbo].[fact_trip]
    UNION
    SELECT TRY_CAST(ended_at AS DATE) FROM [dbo].[fact_trip]
    UNION
    SELECT TRY_CAST(date AS DATE) FROM [dbo].[fact_payment]
    UNION
    SELECT TRY_CAST(account_start_date AS DATE) FROM [dbo].[dim_rider]
    UNION
    SELECT TRY_CAST(account_end_date AS DATE) FROM [dbo].[dim_rider]
)
SELECT
    FORMAT(date_column, 'yyyyMMdd') AS date_id,
    YEAR(date_column) AS year,
    MONTH(date_column) AS month,
    DAY(date_column) AS day,
    DATENAME(WEEKDAY, date_column) AS weekday,
    CASE 
        WHEN DATENAME(WEEKDAY, date_column) IN ('Saturday', 'Sunday') THEN 1 
        ELSE 0 
    END AS is_weekend
FROM unified_dates
WHERE date_column IS NOT NULL;


