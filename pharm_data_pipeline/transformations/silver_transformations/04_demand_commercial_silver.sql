CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.demand_forecast_actual
AS
SELECT
    Month,
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    ForecastUnits,
    ActualDemandUnits,
    ForecastBiasUnits,
    ForecastErrorPct
FROM prod_global.bronze_layer.demand_forecast_actual;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.sales
AS
SELECT
    TRIM(SalesID) AS SalesID,
    SaleDate,
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    UnitsSold,
    UnitPrice,
    TRIM(Channel) AS Channel,
    NetSales
FROM prod_global.bronze_layer.sales;