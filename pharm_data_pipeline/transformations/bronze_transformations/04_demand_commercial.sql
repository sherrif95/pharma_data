CREATE OR REFRESH STREAMING TABLE demand_forecast_actual
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/04_demand_commercial/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'demand_forecast_actual.csv'
);


CREATE OR REFRESH STREAMING TABLE sales
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/04_demand_commercial/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'sales.csv'
);