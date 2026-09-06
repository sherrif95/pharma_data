CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.quality_regulatory
AS
SELECT
    q.EventDate,
    q.QualityEventID,
    q.ProductID,
    p.ProductName,
    p.TherapeuticArea,
    q.PlantID,
    pl.PlantName,
    q.SupplierID,
    s.SupplierName,

    q.EventType AS QualityEventType,
    q.Severity AS QualitySeverity,
    q.ClosedFlag,
    q.ResolutionDays,

    r.RegulatoryEventID,
    r.EventDate AS RegulatoryEventDate,
    r.CountryCode,
    c.Country,
    c.Region,
    r.EventType AS RegulatoryEventType,
    r.Status AS RegulatoryStatus,
    r.Priority AS RegulatoryPriority

FROM prod_global.silver_layer.quality_events q

LEFT JOIN prod_global.silver_layer.dim_product p
    ON q.ProductID = p.ProductID

LEFT JOIN prod_global.silver_layer.dim_plant pl
    ON q.PlantID = pl.PlantID

LEFT JOIN prod_global.silver_layer.dim_supplier s
    ON q.SupplierID = s.SupplierID

LEFT JOIN prod_global.silver_layer.regulatory_events r
    ON q.ProductID = r.ProductID

LEFT JOIN prod_global.silver_layer.dim_country c
    ON r.CountryCode = c.CountryCode;