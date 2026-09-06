CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.inventory_monthly
AS
SELECT
    Month,
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    OnHandUnits,
    SafetyStockUnits,
    InventoryDays,
    TRIM(StockoutRisk) AS StockoutRisk
FROM prod_global.bronze_layer.inventory_monthly;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.purchase_orders
AS
SELECT
    TRIM(PurchaseOrderID) AS PurchaseOrderID,
    OrderDate,
    TRIM(SupplierID) AS SupplierID,
    TRIM(ProductID) AS ProductID,
    OrderedUnits,
    ExpectedReceiptDate,
    ActualReceiptDate,
    UnitCost,
    TRIM(POStatus) AS POStatus
FROM prod_global.bronze_layer.purchase_orders;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.shipments
AS
SELECT
    TRIM(ShipmentID) AS ShipmentID,
    ShipmentDate,
    TRIM(ProductID) AS ProductID,
    TRIM(OriginDCID) AS OriginDCID,
    TRIM(DestinationCountryCode) AS DestinationCountryCode,
    PlannedUnits,
    PlannedTransitDays,
    ActualDelayDays,
    TRIM(TransportMode) AS TransportMode,
    ShippedUnits,
    OnTimeFlag
FROM prod_global.bronze_layer.shipments;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.supplier_performance_monthly
AS
SELECT
    TRIM(SupplierID) AS SupplierID,
    Month,
    OnTimeDeliveryPct,
    QualityAcceptancePct,
    AvgLeadTimeDays,
    DeliveryCount
FROM prod_global.bronze_layer.supplier_performance_monthly;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.supplier_risk_events
AS
SELECT
    TRIM(SupplierRiskEventID) AS SupplierRiskEventID,
    TRIM(SupplierID) AS SupplierID,
    EventDate,
    TRIM(RiskEventType) AS RiskEventType,
    TRIM(Severity) AS Severity,
    TRIM(AffectedMaterial) AS AffectedMaterial,
    TRIM(Status) AS Status,
    EstimatedRecoveryDays
FROM prod_global.bronze_layer.supplier_risk_events;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.critical_supplier_dependencies
AS
SELECT
    TRIM(ProductID) AS ProductID,
    TRIM(SupplierID) AS SupplierID,
    TRIM(MaterialCategory) AS MaterialCategory,
    TRIM(DependencyType) AS DependencyType,
    SupplierCountForCriticalMaterial
FROM prod_global.bronze_layer.critical_supplier_dependencies;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.supply_network_edges
AS
SELECT
    TRIM(EdgeID) AS EdgeID,
    TRIM(RelationshipType) AS RelationshipType,
    TRIM(FromEntityID) AS FromEntityID,
    TRIM(ToEntityID) AS ToEntityID,
    TRIM(MaterialOrProcess) AS MaterialOrProcess,
    ActiveFlag
FROM prod_global.bronze_layer.supply_network_edges;