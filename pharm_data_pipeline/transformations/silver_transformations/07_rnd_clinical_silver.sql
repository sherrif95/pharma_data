CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.clinical_programs
AS
SELECT
    TRIM(ProgramID) AS ProgramID,
    TRIM(ProductID) AS ProductID,
    TRIM(TherapeuticArea) AS TherapeuticArea,
    TRIM(CurrentPhase) AS CurrentPhase
FROM prod_global.bronze_layer.clinical_programs;


CREATE OR REFRESH MATERIALIZED VIEW prod_global.silver_layer.clinical_trials
AS
SELECT
    TRIM(TrialID) AS TrialID,
    TRIM(ProgramID) AS ProgramID,
    StartDate,
    TargetEnrollment,
    ActualEnrollment,
    TRIM(RecruitmentStatus) AS RecruitmentStatus,
    TRIM(TrialType) AS TrialType,
    EnrollmentAchievementPct
FROM prod_global.bronze_layer.clinical_trials;