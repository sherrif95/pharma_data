CREATE OR REFRESH MATERIALIZED VIEW prod_global.gold_layer.clinical_safety
AS
SELECT
    cp.ProgramID,
    cp.ProductID,
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
    ae.EventTerm,
    ae.SeriousFlag,
    ae.Outcome,
    ae.PatientAge,
    ae.PatientSex

FROM prod_global.silver_layer.clinical_programs cp

LEFT JOIN prod_global.silver_layer.clinical_trials ct
    ON cp.ProgramID = ct.ProgramID

LEFT JOIN prod_global.silver_layer.adverse_events ae
    ON cp.ProductID = ae.ProductID;