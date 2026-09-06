CREATE OR REFRESH STREAMING TABLE regulatory_events
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/06_regulatory/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'regulatory_events.csv'
);