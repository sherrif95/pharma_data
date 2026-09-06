CREATE OR REFRESH STREAMING TABLE adverse_events
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/08_safety/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'adverse_events.csv'
);