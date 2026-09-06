CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.clinical_safety
AS
SELECT
    cp.ProgramID,
    cp.ProductID,
    p.ProductName,
    p.TherapeuticArea,

    cp.CurrentPhase,

    ct.TrialID,
    ct.StartDate,
    ct.TargetEnrollment,
    ct.ActualEnrollment,
    ct.RecruitmentStatus,
    ct.TrialType,
    ct.EnrollmentAchievementPct,

    ae.AdverseEventID,
    ae.ReportDate,
    ae.CountryCode,
    c.Country,
    c.Region,
    ae.EventTerm,
    ae.SeriousFlag,
    ae.Outcome,
    ae.PatientAge,
    ae.PatientSex

FROM prod_global.silver_layer.clinical_programs cp

LEFT JOIN prod_global.silver_layer.dim_product p
    ON cp.ProductID = p.ProductID

LEFT JOIN prod_global.silver_layer.clinical_trials ct
    ON cp.ProgramID = ct.ProgramID

LEFT JOIN prod_global.silver_layer.adverse_events ae
    ON cp.ProductID = ae.ProductID

LEFT JOIN prod_global.silver_layer.dim_country c
    ON ae.CountryCode = c.CountryCode;