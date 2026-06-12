/* =========================================================
   01) DATABASE & RAW DATA
   ========================================================= */

CREATE DATABASE IF NOT EXISTS call_center_performance_analysis;
USE call_center_performance_analysis;

/* RAW TABLE */
DROP TABLE IF EXISTS raw_call_center;

CREATE TABLE raw_call_center (
  call_id INT,
  `date` VARCHAR(20),
  daily_caller INT,
  call_started VARCHAR(20),
  call_answered VARCHAR(20),
  call_ended VARCHAR(20),
  wait_length INT,
  service_length INT,
  meets_standard VARCHAR(10)
);

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/simulated_call_centre.csv'
INTO TABLE raw_call_center
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(call_id, `date`, daily_caller, call_started, call_answered, call_ended,
 wait_length, service_length, meets_standard);


/* =========================================================
   02) CLEANING LAYER
   ========================================================= */

CREATE OR REPLACE VIEW v_call_center_clean AS
SELECT
  call_id,
  STR_TO_DATE(`date`, '%Y-%m-%d') AS call_date,
  daily_caller,

  STR_TO_DATE(call_started, '%h:%i:%s %p') AS call_started_time,
  STR_TO_DATE(call_answered, '%h:%i:%s %p') AS call_answered_time,
  STR_TO_DATE(call_ended, '%h:%i:%s %p') AS call_ended_time,

  wait_length AS original_wait_length,
  service_length AS original_service_length,
  meets_standard AS original_meets_standard,

  TIMESTAMPDIFF(
    SECOND,
    STR_TO_DATE(call_started, '%h:%i:%s %p'),
    STR_TO_DATE(call_answered, '%h:%i:%s %p')
  ) AS wait_seconds_corrected,

  TIMESTAMPDIFF(
    SECOND,
    STR_TO_DATE(call_answered, '%h:%i:%s %p'),
    STR_TO_DATE(call_ended, '%h:%i:%s %p')
  ) AS service_seconds_corrected,

  CASE
    WHEN TIMESTAMPDIFF(
      SECOND,
      STR_TO_DATE(call_started, '%h:%i:%s %p'),
      STR_TO_DATE(call_answered, '%h:%i:%s %p')
    ) <= 60 THEN 1
    ELSE 0
  END AS sla_60_seconds

FROM raw_call_center;


/* =========================================================
   03) KPI & ANALYSIS VIEWS
   ========================================================= */

CREATE OR REPLACE VIEW v_kpi_summary AS
SELECT
  COUNT(*) AS total_calls,
  ROUND(AVG(wait_seconds_corrected), 2) AS avg_wait_seconds,
  ROUND(AVG(service_seconds_corrected), 2) AS avg_service_seconds,
  ROUND(AVG(sla_60_seconds), 4) AS sla_rate,
  MAX(wait_seconds_corrected) AS max_wait_seconds,
  MAX(service_seconds_corrected) AS max_service_seconds
FROM v_call_center_clean;

CREATE OR REPLACE VIEW v_weekday_performance AS
SELECT
  WEEKDAY(call_date) + 1 AS weekday_number,
  DAYNAME(call_date) AS weekday_name,
  COUNT(*) AS total_calls,
  ROUND(AVG(wait_seconds_corrected), 2) AS avg_wait_seconds,
  ROUND(AVG(service_seconds_corrected), 2) AS avg_service_seconds,
  ROUND(AVG(sla_60_seconds), 4) AS sla_rate
FROM v_call_center_clean
GROUP BY
  WEEKDAY(call_date) + 1,
  DAYNAME(call_date)
ORDER BY weekday_number;

CREATE OR REPLACE VIEW v_hourly_performance AS
SELECT
  HOUR(call_started_time) AS call_hour,
  DATE_FORMAT(call_started_time, '%H:00') AS hour_label,
  COUNT(*) AS total_calls,
  ROUND(AVG(wait_seconds_corrected), 2) AS avg_wait_seconds,
  ROUND(AVG(service_seconds_corrected), 2) AS avg_service_seconds,
  ROUND(AVG(sla_60_seconds), 4) AS sla_rate
FROM v_call_center_clean
GROUP BY
  HOUR(call_started_time),
  DATE_FORMAT(call_started_time, '%H:00')
ORDER BY call_hour;

CREATE OR REPLACE VIEW v_daily_performance AS
SELECT
  call_date,
  COUNT(*) AS total_calls,
  ROUND(AVG(wait_seconds_corrected), 2) AS avg_wait_seconds,
  ROUND(AVG(service_seconds_corrected), 2) AS avg_service_seconds,
  ROUND(AVG(sla_60_seconds), 4) AS sla_rate
FROM v_call_center_clean
GROUP BY call_date
ORDER BY call_date;


CREATE OR REPLACE VIEW v_wait_time_distribution AS
SELECT
  CASE
    WHEN wait_seconds_corrected = 0 THEN '0 sec'
    WHEN wait_seconds_corrected BETWEEN 1 AND 60 THEN '1-60 sec'
    WHEN wait_seconds_corrected BETWEEN 61 AND 180 THEN '61-180 sec'
    ELSE '181+ sec'
  END AS wait_bucket,

  CASE
    WHEN wait_seconds_corrected = 0 THEN 1
    WHEN wait_seconds_corrected BETWEEN 1 AND 60 THEN 2
    WHEN wait_seconds_corrected BETWEEN 61 AND 180 THEN 3
    ELSE 4
  END AS bucket_order,

  COUNT(*) AS total_calls,
  ROUND(COUNT(*) / (SELECT COUNT(*) FROM v_call_center_clean), 4) AS call_share

FROM v_call_center_clean
GROUP BY
  wait_bucket,
  bucket_order
ORDER BY bucket_order;


CREATE OR REPLACE VIEW v_workload_vs_service AS
SELECT
  HOUR(call_started_time) AS call_hour,
  DATE_FORMAT(call_started_time, '%H:00') AS hour_label,
  COUNT(*) AS total_calls,
  ROUND(AVG(wait_seconds_corrected), 2) AS avg_wait_seconds,
  ROUND(AVG(service_seconds_corrected), 2) AS avg_service_seconds,
  ROUND(AVG(sla_60_seconds), 4) AS sla_rate
FROM v_call_center_clean
GROUP BY
  HOUR(call_started_time),
  DATE_FORMAT(call_started_time, '%H:00')
ORDER BY call_hour;


/* =========================================================
   04) REPORTING LAYER
   ========================================================= */

CREATE DATABASE IF NOT EXISTS call_center_reporting;
USE call_center_reporting;

CREATE OR REPLACE VIEW v_kpi_summary AS
SELECT * FROM call_center_performance_analysis.v_kpi_summary;

CREATE OR REPLACE VIEW v_weekday_performance AS
SELECT * FROM call_center_performance_analysis.v_weekday_performance;

CREATE OR REPLACE VIEW v_hourly_performance AS
SELECT * FROM call_center_performance_analysis.v_hourly_performance;

CREATE OR REPLACE VIEW v_daily_performance AS
SELECT * FROM call_center_performance_analysis.v_daily_performance;

CREATE OR REPLACE VIEW v_wait_time_distribution AS
SELECT * FROM call_center_performance_analysis.v_wait_time_distribution;

CREATE OR REPLACE VIEW v_workload_vs_service AS
SELECT * FROM call_center_performance_analysis.v_workload_vs_service;
