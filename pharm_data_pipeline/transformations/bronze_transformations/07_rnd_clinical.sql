CREATE OR REFRESH STREAMING TABLE clinical_programs
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/07_rnd_clinical/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'clinical_programs.csv'
);


CREATE OR REFRESH STREAMING TABLE clinical_trials
AS
SELECT *
FROM STREAM read_files(
    's3://my-projects-data-sherrif/07_rnd_clinical/',
    format => 'csv',
    header => true,
    pathGlobFilter => 'clinical_trials.csv'
);