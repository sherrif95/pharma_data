CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.dim_product
AS
SELECT
    TRIM(ProductID) AS ProductID,
    TRIM(ProductName) AS ProductName,
    TRIM(TherapeuticArea) AS TherapeuticArea,
    TRIM(DosageForm) AS DosageForm,
    TRIM(ProductType) AS ProductType,
    TRIM(StorageClass) AS StorageClass
FROM prod_global.bronze_layer.dim_product;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.dim_country
AS
SELECT
    TRIM(CountryCode) AS CountryCode,
    TRIM(Country) AS Country,
    TRIM(Region) AS Region
FROM prod_global.bronze_layer.dim_country;

CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.dim_distribution_centre
AS
SELECT
    TRIM(DCID) AS DCID,
    TRIM(DCName) AS DCName,
    TRIM(CountryCode) AS CountryCode,
    StorageCapacityUnits
FROM prod_global.bronze_layer.dim_distribution_centre;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.dim_plant
AS
SELECT
    TRIM(PlantID) AS PlantID,
    TRIM(PlantName) AS PlantName,
    TRIM(CountryCode) AS CountryCode,
    TRIM(PlantType) AS PlantType,
    MonthlyCapacityUnits
FROM prod_global.bronze_layer.dim_plant;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.dim_supplier
AS
SELECT
    TRIM(SupplierID) AS SupplierID,
    TRIM(SupplierName) AS SupplierName,
    TRIM(CountryCode) AS CountryCode,
    TRIM(MaterialCategory) AS MaterialCategory,
    BaseUnitCost,
    NominalLeadTimeDays,
    TRIM(StrategicRisk) AS StrategicRisk
FROM prod_global.bronze_layer.dim_supplier;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.product_market
AS
SELECT
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    TRIM(RegulatoryStatus) AS RegulatoryStatus
FROM prod_global.bronze_layer.product_market;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.product_material
AS
SELECT
    TRIM(ProductID) AS ProductID,
    TRIM(SupplierID) AS SupplierID,
    TRIM(MaterialCategory) AS MaterialCategory,
    UnitsMaterialPerProduct
FROM prod_global.bronze_layer.product_material;