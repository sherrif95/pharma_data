CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.demand_performance
AS
SELECT
    d.Month,
    d.ProductID,
    p.ProductName,
    p.TherapeuticArea,
    d.CountryCode,
    c.Country,
    c.Region,

    d.ForecastUnits,
    d.ActualDemandUnits,
    d.ForecastBiasUnits,
    d.ForecastErrorPct,

    CASE
        WHEN d.ActualDemandUnits = 0 THEN NULL
        ELSE ROUND(
            d.ForecastUnits * 1.0 / d.ActualDemandUnits,
            2
        )
    END AS ForecastToActualRatio,

    CASE
        WHEN ABS(d.ForecastErrorPct) < 5 THEN 'Accurate'
        WHEN ABS(d.ForecastErrorPct) < 15 THEN 'Watch'
        ELSE 'High Error'
    END AS ForecastAccuracyBand

FROM prod_global.silver_layer.demand_forecast_actual d

LEFT JOIN prod_global.silver_layer.dim_product p
    ON d.ProductID = p.ProductID

LEFT JOIN prod_global.silver_layer.dim_country c
    ON d.CountryCode = c.CountryCode;