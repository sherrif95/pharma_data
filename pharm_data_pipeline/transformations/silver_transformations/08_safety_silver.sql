CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.adverse_events
AS
SELECT
    TRIM(AdverseEventID) AS AdverseEventID,
    ReportDate,
    TRIM(ProductID) AS ProductID,
    TRIM(CountryCode) AS CountryCode,
    TRIM(EventTerm) AS EventTerm,
    SeriousFlag,
    TRIM(Outcome) AS Outcome,
    PatientAge,
    TRIM(PatientSex) AS PatientSex
FROM prod_global.bronze_layer.adverse_events;