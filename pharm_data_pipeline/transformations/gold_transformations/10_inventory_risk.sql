CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.inventory_risk
AS
SELECT
    i.Month,
    i.ProductID,
    i.CountryCode,

    i.OnHandUnits,
    i.SafetyStockUnits,
    i.InventoryDays,
    i.StockoutRisk,

    d.ActualDemandUnits,
    d.ForecastUnits,

    CASE
        WHEN i.OnHandUnits < i.SafetyStockUnits
        THEN TRUE
        ELSE FALSE
    END AS BelowSafetyStockFlag,

    CASE
        WHEN i.InventoryDays < 30 THEN 'Critical'
        WHEN i.InventoryDays < 60 THEN 'Watch'
        ELSE 'Healthy'
    END AS InventoryRiskBand

FROM prod_global.silver_layer.inventory_monthly i


LEFT JOIN prod_global.silver_layer.demand_forecast_actual d
    ON i.Month = d.Month
    AND i.ProductID = d.ProductID
    AND i.CountryCode = d.CountryCode;