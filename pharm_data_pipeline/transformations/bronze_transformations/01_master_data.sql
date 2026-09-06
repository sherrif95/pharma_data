CREATE OR REFRESH STREAMING TABLE dim_product
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'dim_product.csv'
);


CREATE OR REFRESH STREAMING TABLE dim_country
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'dim_country.csv'
);


CREATE OR REFRESH STREAMING TABLE dim_distribution_centre
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'dim_distribution_centre.csv'
);


CREATE OR REFRESH STREAMING TABLE dim_plant
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'dim_plant.csv'
);


CREATE OR REFRESH STREAMING TABLE dim_supplier
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'dim_supplier.csv'
);


CREATE OR REFRESH STREAMING TABLE product_market
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'product_market.csv'
);


CREATE OR REFRESH STREAMING TABLE product_material
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/01_master_data/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'product_material.csv'
);