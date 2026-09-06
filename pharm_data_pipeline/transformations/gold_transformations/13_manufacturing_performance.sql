CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.manufacturing_performance
AS
SELECT
    b.ProductionDate,
    b.BatchID,
    b.ProductID,
    p.ProductName,
    p.TherapeuticArea,
    b.PlantID,
    pl.PlantName,
    pl.CountryCode,

    b.PlannedUnits,
    b.ProducedUnits,
    b.YieldPct,
    b.BatchStatus,

    pc.AvailableCapacityUnits,
    pc.UtilisationPct,
    pc.CapacityStatus,

    CASE
        WHEN b.PlannedUnits = 0 THEN NULL
        ELSE ROUND(
            b.ProducedUnits * 1.0 / b.PlannedUnits,
            2
        )
    END AS ProductionAchievementRatio,

    CASE
        WHEN b.YieldPct >= 95 THEN 'Excellent'
        WHEN b.YieldPct >= 90 THEN 'Acceptable'
        ELSE 'Below Target'
    END AS YieldPerformanceBand

FROM prod_global.silver_layer.production_batches b

LEFT JOIN prod_global.silver_layer.dim_product p
    ON b.ProductID = p.ProductID

LEFT JOIN prod_global.silver_layer.dim_plant pl
    ON b.PlantID = pl.PlantID

LEFT JOIN prod_global.silver_layer.plant_capacity_monthly pc
    ON b.PlantID = pc.PlantID
    AND DATE_TRUNC('month', b.ProductionDate) = pc.Month;