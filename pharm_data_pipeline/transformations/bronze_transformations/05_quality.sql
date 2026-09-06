CREATE OR REFRESH STREAMING TABLE quality_events
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/05_quality/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'quality_events.csv'
);