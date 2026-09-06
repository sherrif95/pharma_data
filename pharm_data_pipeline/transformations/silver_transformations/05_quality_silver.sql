CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.quality_events
AS
SELECT
    TRIM(QualityEventID) AS QualityEventID,
    EventDate,
    TRIM(ProductID) AS ProductID,
    TRIM(PlantID) AS PlantID,
    TRIM(SupplierID) AS SupplierID,
    TRIM(EventType) AS EventType,
    TRIM(Severity) AS Severity,
    ClosedFlag,
    ResolutionDays
FROM prod_global.bronze_layer.quality_events;