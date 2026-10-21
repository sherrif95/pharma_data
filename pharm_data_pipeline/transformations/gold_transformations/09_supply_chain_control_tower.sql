CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.supply_chain_control_tower
AS
SELECT
    i.Month,
    i.ProductID,
    i.CountryCode,
    i.OnHandUnits,
    i.SafetyStockUnits,
    i.InventoryDays,
    i.StockoutRisk,
    d.ForecastUnits,
    d.ActualDemandUnits,
    d.ForecastBiasUnits,
    d.ForecastErrorPct,

    ROUND(
        CASE
            WHEN d.ActualDemandUnits > 0
            THEN i.OnHandUnits * 1.0 / d.ActualDemandUnits
            ELSE NULL
        END,
        2
    ) AS InventoryCoverageRatio

FROM prod_global.silver_layer.inventory_monthly i
LEFT JOIN prod_global.silver_layer.demand_forecast_actual d
    ON i.Month = d.Month
    AND i.ProductID = d.ProductID
    AND i.CountryCode = d.CountryCode;