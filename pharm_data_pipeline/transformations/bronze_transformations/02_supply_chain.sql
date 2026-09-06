CREATE OR REFRESH STREAMING TABLE critical_supplier_dependencies
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'critical_supplier_dependencies.csv'
);


CREATE OR REFRESH STREAMING TABLE inventory_monthly
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'inventory_monthly_*.csv'
);


CREATE OR REFRESH STREAMING TABLE purchase_orders
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'purchase_orders_*.csv'
);


CREATE OR REFRESH STREAMING TABLE shipments
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'shipments.csv'
);


CREATE OR REFRESH STREAMING TABLE supplier_performance_monthly
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'supplier_performance_monthly.csv'
);


CREATE OR REFRESH STREAMING TABLE supplier_risk_events
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'supplier_risk_events.csv'
);


CREATE OR REFRESH STREAMING TABLE supply_network_edges
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/02_supply_chain/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'supply_network_edges.csv'
);