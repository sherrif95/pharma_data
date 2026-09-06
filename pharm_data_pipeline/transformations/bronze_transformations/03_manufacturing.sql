CREATE OR REFRESH STREAMING TABLE plant_capacity_monthly
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/03_manufacturing/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'plant_capacity_monthly.csv'
);


CREATE OR REFRESH STREAMING TABLE production_batches
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/03_manufacturing/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'production_batches.csv'
);