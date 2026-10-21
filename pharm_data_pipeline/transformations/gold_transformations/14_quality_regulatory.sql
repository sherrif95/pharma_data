CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.quality_regulatory
AS
SELECT
    q.EventDate,
    q.QualityEventID,
    q.ProductID,
    q.PlantID,
    q.SupplierID,

    q.EventType AS QualityEventType,
    q.Severity AS QualitySeverity,
    q.ClosedFlag,
    q.ResolutionDays,

    r.RegulatoryEventID,
    r.EventDate AS RegulatoryEventDate,
    r.CountryCode,
    r.EventType AS RegulatoryEventType,
    r.Status AS RegulatoryStatus,
    r.Priority AS RegulatoryPriority

FROM prod_global.silver_layer.quality_events q

LEFT JOIN prod_global.silver_layer.regulatory_events r
    ON q.ProductID = r.ProductID