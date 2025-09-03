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

CREATE EXTERNAL TABLE [dbo].[fact_payment]
WITH (
    LOCATION = 'fact_payment_2',
    DATA_SOURCE = abfss://raw@dlsg2a_dfs_core_windows_net,
    FILE_FORMAT = SynapseDelimitedTextFormat
)
AS
SELECT
    p.payment_id,
    p.rider_id,
    p.amount,
	p.date,
    TRY_CAST(p.date AS DATE) AS payment_date_id
FROM [dbo].[payment_table] p
JOIN [dbo].[rider_table] r ON p.rider_id = r.rider_id;

SELECT TOP 100 * FROM dbo.fact_payment
GO

