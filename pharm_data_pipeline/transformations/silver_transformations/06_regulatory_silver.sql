CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.regulatory_events
AS
SELECT
    TRIM(RegulatoryEventID) AS RegulatoryEventID,
    EventDate,
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    TRIM(EventType) AS EventType,
    TRIM(Status) AS Status,
    TRIM(Priority) AS Priority
FROM prod_global.bronze_layer.regulatory_events;