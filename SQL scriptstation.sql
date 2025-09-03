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

CREATE EXTERNAL TABLE [dbo].[dim_station]
WITH (
    LOCATION = 'dim_station',
    DATA_SOURCE = abfss://raw@dlsg2a_dfs_core_windows_net,
    FILE_FORMAT = SynapseDelimitedTextFormat
)
AS
SELECT
    s.station_id,
    s.name,
    s.latitude,
    s.longitude
FROM [dbo].[station_table] s;



