CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.dim_product
AS
SELECT
    ProductID,
    ProductName,
    TherapeuticArea,
    DosageForm,
    ProductType,
    StorageClass
FROM prod_global.silver_layer.dim_product;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.dim_country
AS
SELECT
    CountryCode,
    Country,
    Region
FROM prod_global.silver_layer.dim_country;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.dim_supplier
AS
SELECT
    SupplierID,
    SupplierName,
    CountryCode,
    MaterialCategory,
    BaseUnitCost,
    NominalLeadTimeDays,
    StrategicRisk
FROM prod_global.silver_layer.dim_supplier;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.dim_plant
AS
SELECT
    PlantID,
    PlantName,
    CountryCode,
    PlantType,
    MonthlyCapacityUnits
FROM prod_global.silver_layer.dim_plant;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.dim_distribution_centre
AS
SELECT
    DCID,
    DCName,
    CountryCode,
    StorageCapacityUnits
FROM prod_global.silver_layer.dim_distribution_centre;