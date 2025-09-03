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

CREATE EXTERNAL TABLE fact_trip
WITH (
    LOCATION = 'fact_trip',
    DATA_SOURCE = abfss://raw@dlsg2a_dfs_core_windows_net,
    FILE_FORMAT = SynapseDelimitedTextFormat
)
AS
SELECT
    t.trip_id,
    t.rideable_type,
    t.start_at,
    t.ended_at,
    t.rider_id,
    t.start_station_id,
    t.end_station_id,
    TRY_CAST(t.start_at AS DATE) AS date_id,
	DATEDIFF(MINUTE, t.start_at, t.ended_at) AS trip_duration,
	DATEDIFF(YEAR, r.birthday, CAST(t.start_at AS DATE))
      - CASE WHEN FORMAT(r.birthday, 'MMdd') > FORMAT(t.start_at, 'MMdd') THEN 1 ELSE 0 END
      AS rider_age_at_trip
FROM
    trip_table t
JOIN rider_table r ON t.rider_id = r.rider_id;

SELECT TOP 100 * FROM dbo.fact_trip
GO

