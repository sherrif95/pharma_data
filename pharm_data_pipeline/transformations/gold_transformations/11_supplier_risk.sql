CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.supplier_risk
AS
SELECT
    s.SupplierID,
    s.SupplierName,
    s.CountryCode,
    c.Country,
    c.Region,
    s.MaterialCategory,
    s.BaseUnitCost,
    s.NominalLeadTimeDays,
    s.StrategicRisk,

    sp.Month,
    sp.OnTimeDeliveryPct,
    sp.QualityAcceptancePct,
    sp.AvgLeadTimeDays,
    sp.DeliveryCount,

    COUNT(DISTINCT re.SupplierRiskEventID) AS RiskEventCount,

    SUM(
        CASE
            WHEN re.Severity = 'High' THEN 1
            ELSE 0
        END
    ) AS HighSeverityRiskEvents,

    MAX(
        CASE
            WHEN re.Status = 'Open' THEN 1
            ELSE 0
        END
    ) AS HasOpenRiskEvent,

    COUNT(DISTINCT cd.ProductID) AS DependentProductCount,

    MAX(cd.SupplierCountForCriticalMaterial) AS SupplierCountForCriticalMaterial

FROM prod_global.silver_layer.dim_supplier s

LEFT JOIN prod_global.silver_layer.dim_country c
    ON s.CountryCode = c.CountryCode

LEFT JOIN prod_global.silver_layer.supplier_performance_monthly sp
    ON s.SupplierID = sp.SupplierID

LEFT JOIN prod_global.silver_layer.supplier_risk_events re
    ON s.SupplierID = re.SupplierID
    AND (
        sp.Month IS NULL
        OR DATE_TRUNC('month', re.EventDate) = sp.Month
    )

LEFT JOIN prod_global.silver_layer.critical_supplier_dependencies cd
    ON s.SupplierID = cd.SupplierID

GROUP BY
    s.SupplierID,
    s.SupplierName,
    s.CountryCode,
    c.Country,
    c.Region,
    s.MaterialCategory,
    s.BaseUnitCost,
    s.NominalLeadTimeDays,
    s.StrategicRisk,
    sp.Month,
    sp.OnTimeDeliveryPct,
    sp.QualityAcceptancePct,
    sp.AvgLeadTimeDays,
    sp.DeliveryCount;