CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.production_batches
AS
SELECT
    TRIM(BatchID) AS BatchID,
    ProductionDate,
    TRIM(ProductID) AS ProductID,
    TRIM(PlantID) AS PlantID,
    PlannedUnits,
    YieldPct,
    TRIM(BatchStatus) AS BatchStatus,
    ProducedUnits
FROM prod_global.bronze_layer.production_batches;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.plant_capacity_monthly
AS
SELECT
    Month,
    TRIM(PlantID) AS PlantID,
    AvailableCapacityUnits,
    ProducedUnits,
    UtilisationPct,
    TRIM(CapacityStatus) AS CapacityStatus
FROM prod_global.bronze_layer.plant_capacity_monthly;