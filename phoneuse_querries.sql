SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE  table_name = 'phoneuse';

select *
from phoneuse;

SELECT
  'daily_phone_hours' AS variable,

  corr(daily_phone_hours, social_media_hours)        AS social_media,
  corr(daily_phone_hours, work_productivity_score)   AS productivity,
  corr(daily_phone_hours, sleep_hours)               AS sleep,
  corr(daily_phone_hours, stress_level)              AS stress,
  corr(daily_phone_hours, app_usage_count)           AS apps,
  corr(daily_phone_hours, caffeine_intake_cups)      AS caffeine,
  corr(daily_phone_hours, weekend_screen_time_hours) AS weekend

FROM phoneuse

UNION ALL

SELECT
  'social_media_hours',

  corr(social_media_hours, daily_phone_hours),
  corr(social_media_hours, work_productivity_score),
  corr(social_media_hours, sleep_hours),
  corr(social_media_hours, stress_level),
  corr(social_media_hours, app_usage_count),
  corr(social_media_hours, caffeine_intake_cups),
  corr(social_media_hours, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'work_productivity_score',

  corr(work_productivity_score, daily_phone_hours),
  corr(work_productivity_score, social_media_hours),
  corr(work_productivity_score, sleep_hours),
  corr(work_productivity_score, stress_level),
  corr(work_productivity_score, app_usage_count),
  corr(work_productivity_score, caffeine_intake_cups),
  corr(work_productivity_score, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'sleep_hours',

  corr(sleep_hours, daily_phone_hours),
  corr(sleep_hours, social_media_hours),
  corr(sleep_hours, work_productivity_score),
  corr(sleep_hours, stress_level),
  corr(sleep_hours, app_usage_count),
  corr(sleep_hours, caffeine_intake_cups),
  corr(sleep_hours, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'stress_level',

  corr(stress_level, daily_phone_hours),
  corr(stress_level, social_media_hours),
  corr(stress_level, work_productivity_score),
  corr(stress_level, sleep_hours),
  corr(stress_level, app_usage_count),
  corr(stress_level, caffeine_intake_cups),
  corr(stress_level, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'app_usage_count',

  corr(app_usage_count, daily_phone_hours),
  corr(app_usage_count, social_media_hours),
  corr(app_usage_count, work_productivity_score),
  corr(app_usage_count, sleep_hours),
  corr(app_usage_count, stress_level),
  corr(app_usage_count, caffeine_intake_cups),
  corr(app_usage_count, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'caffeine_intake_cups',

  corr(caffeine_intake_cups, daily_phone_hours),
  corr(caffeine_intake_cups, social_media_hours),
  corr(caffeine_intake_cups, work_productivity_score),
  corr(caffeine_intake_cups, sleep_hours),
  corr(caffeine_intake_cups, stress_level),
  corr(caffeine_intake_cups, app_usage_count),
  corr(caffeine_intake_cups, weekend_screen_time_hours)

FROM phoneuse

UNION ALL

SELECT
  'weekend_screen_time_hours',

  corr(weekend_screen_time_hours, daily_phone_hours),
  corr(weekend_screen_time_hours, social_media_hours),
  corr(weekend_screen_time_hours, work_productivity_score),
  corr(weekend_screen_time_hours, sleep_hours),
  corr(weekend_screen_time_hours, stress_level),
  corr(weekend_screen_time_hours, app_usage_count),
  corr(weekend_screen_time_hours, caffeine_intake_cups)

FROM phoneuse;

-- 0. verify count (you said ~50k)
SELECT COUNT(*) AS total_rows FROM phoneuse;

-- 1. quick distributions
SELECT
  COUNT(*) AS n,
  ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_daily_phone_hours,
  ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep_hours,
  ROUND(AVG(work_productivity_score)::numeric,2) AS avg_productivity
FROM phoneuse;

-- 2. phone time buckets
WITH buckets AS (
  SELECT
    CASE
      WHEN daily_phone_hours < 2 THEN '<2'
      WHEN daily_phone_hours < 4 THEN '2-4'
      WHEN daily_phone_hours < 6 THEN '4-6'
      WHEN daily_phone_hours < 8 THEN '6-8'
      ELSE '8+'
    END AS phone_bucket,
    work_productivity_score,
    sleep_hours,
    stress_level
  FROM phoneuse
)
SELECT
  phone_bucket,
  COUNT(*) AS n,
  ROUND(AVG(work_productivity_score)::numeric,2) AS avg_prod,
  ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep,
  ROUND(AVG(stress_level)::numeric,2) AS avg_stress
FROM buckets
GROUP BY phone_bucket
ORDER BY
  CASE phone_bucket WHEN '<2' THEN 1 WHEN '2-4' THEN 2 WHEN '4-6' THEN 3 WHEN '6-8' THEN 4 ELSE 5 END;

-- 3. correlation checks (Postgres aggregate functions)
SELECT
  corr(daily_phone_hours, work_productivity_score)     AS corr_phone_productivity,
  corr(daily_phone_hours, sleep_hours)                 AS corr_phone_sleep,
  corr(daily_phone_hours, stress_level)                AS corr_phone_stress
FROM phoneuse;

-- 4. age groups vs productivity (median-ish using percentile_cont)
WITH age_groups AS (
  SELECT
    CASE WHEN age < 25 THEN '<25'
         WHEN age < 35 THEN '25-34'
         WHEN age < 45 THEN '35-44'
         WHEN age < 55 THEN '45-54'
         ELSE '55+' END AS age_group,
    work_productivity_score::numeric
  FROM phoneuse
)
SELECT
  age_group,
  COUNT(*) AS n,
  percentile_cont(0.5) WITHIN GROUP (ORDER BY work_productivity_score) AS median_productivity,
  ROUND(AVG(work_productivity_score)::numeric,2) AS avg_productivity
FROM age_groups
GROUP BY age_group
ORDER BY age_group;

-- 5. top occupations by average daily phone hours
SELECT occupation, COUNT(*) AS n, ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_hours
FROM phoneuse
GROUP BY occupation
HAVING COUNT(*) > 50
ORDER BY avg_hours DESC
LIMIT 10;

-- 6. interesting cross-tab: device type vs high social use
SELECT device_type,
  SUM(CASE WHEN social_media_hours > 3 THEN 1 ELSE 0 END) AS heavy_social_users,
  COUNT(*) AS total,
  ROUND(100.0 * SUM(CASE WHEN social_media_hours > 3 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),2) AS pct_heavy_social
FROM phoneuse
GROUP BY device_type;

-- 7. find users with high stress + low sleep (possible cohort)
SELECT user_id, age, device_type, sleep_hours, stress_level, daily_phone_hours
FROM phoneuse
WHERE sleep_hours < 5.5 AND stress_level >= 8
ORDER BY stress_level DESC, sleep_hours ASC
LIMIT 20;

-- 8. sample CTE for a mini cohort analysis (avg metrics for 'heavy phone' vs 'light phone')
WITH cohort AS (
  SELECT *,
    CASE WHEN daily_phone_hours >= 6 THEN 'heavy' ELSE 'light' END AS cohort
  FROM phoneuse
)
SELECT
  cohort,
  COUNT(*) AS n,
  ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep,
  ROUND(AVG(work_productivity_score)::numeric,2) AS avg_prod,
  ROUND(AVG(stress_level)::numeric,2) AS avg_stress
FROM cohort
GROUP BY cohort;

-- 9. percentiles of daily phone hours
SELECT
  percentile_cont(0.25) WITHIN GROUP (ORDER BY daily_phone_hours) AS p25,
  percentile_cont(0.5)  WITHIN GROUP (ORDER BY daily_phone_hours) AS median,
  percentile_cont(0.75) WITHIN GROUP (ORDER BY daily_phone_hours) AS p75
FROM phoneuse;

-- 10. sanity check: NULLs & missing data
SELECT
  SUM(CASE WHEN daily_phone_hours IS NULL THEN 1 ELSE 0 END) AS phone_missing,
  SUM(CASE WHEN sleep_hours IS NULL THEN 1 ELSE 0 END) AS sleep_missing,
  SUM(CASE WHEN work_productivity_score IS NULL THEN 1 ELSE 0 END) AS productivity_missing
FROM phoneuse;

WITH flags AS (
SELECT *,
  sleep_hours < 6 AS bad_sleep,
  stress_level >= 7 AS high_stress,
  work_productivity_score <= 4 AS low_productivity
FROM phoneuse
)

SELECT
  ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_phone_hours,
  COUNT(*) AS users,
  ROUND(100.0 * AVG(bad_sleep::int),2) AS pct_bad_sleep,
  ROUND(100.0 * AVG(high_stress::int),2) AS pct_high_stress,
  ROUND(100.0 * AVG(low_productivity::int),2) AS pct_low_productivity
FROM flags;

SELECT
 gender,
 COUNT(*) AS n,
 ROUND(AVG(daily_phone_hours)::numeric,2) AS avg_phone,
 ROUND(AVG(sleep_hours)::numeric,2) AS avg_sleep,
 ROUND(AVG(stress_level)::numeric,2) AS avg_stress,
 ROUND(AVG(work_productivity_score)::numeric,2) AS avg_productivity
FROM phoneuse
GROUP BY gender
ORDER BY gender;


# Sample 5000
SELECT * FROM phoneuse
ORDER BY RANDOM()
LIMIT 5000;