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

-- CREATE EXTERNAL TABLE [dbo].[dim_rider]
-- WITH (
--     LOCATION = 'dim_rider',
--     DATA_SOURCE = abfss://raw@dlsg2a_dfs_core_windows_net,
--     FILE_FORMAT = SynapseDelimitedTextFormat
-- )
-- AS
-- SELECT
--     r.rider_id,
--     r.first_name,
--     r.last_name,
--     r.birthday,
--     r.is_member,
--     r.address,
-- 	r.account_start_date,
-- 	r.account_end_date
-- FROM [dbo].[rider_table] r;

SELECT TOP 100 * FROM dbo.dim_rider
GO
