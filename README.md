# phoneuse

SQL data analysis project exploring relationships between smartphone usage, sleep, stress, and productivity using a synthetic PostgreSQL dataset.

**Dataset:** [Screen Time, Sleep & Stress Analysis Dataset](https://www.kaggle.com/datasets/amar5693/screen-time-sleep-and-stress-analysis-dataset) 

**Sample:** This project contains phoneuse_sample.csv file with randomly selected 5000 records from from the original dataset.

---

## Dataset Overview

| Property | Value |
|----------|-------|
| Table name | `phoneuse` |
| Rows | 50,000 |
| Database | PostgreSQL |

**Version Note:** Requires PostgreSQL 9.4+ for percentile_cont(). Tested on PostgreSQL 16.

### Limitations

- Dataset is synthetically generated
- No meaningful relationships were detected between variables
- Findings should not be interpreted as real behavioral conclusions
- Project focuses on SQL analysis methodology rather than domain validity

### Schema

| Column | Type | Description |
|--------|------|-------------|
| `user_id` | varchar | Unique user identifier |
| `age` | integer | User age |
| `gender` | varchar | Gender |
| `occupation` | varchar | Occupation category |
| `device_type` | varchar | Smartphone platform |
| `daily_phone_hours` | real | Average daily phone usage (hours) |
| `social_media_hours` | real | Daily time spent on social media (hours) |
| `work_productivity_score` | integer | Self-reported productivity score (0–10) |
| `sleep_hours` | real | Average nightly sleep (hours) |
| `stress_level` | integer | Stress score (1–10) |
| `app_usage_count` | integer | Number of distinct apps used daily |
| `caffeine_intake_cups` | integer | Daily caffeine intake (cups) |
| `weekend_screen_time_hours` | real | Weekend screen time (hours) |

---

## Research Questions

- Does daily phone usage predict sleep quality, stress, or productivity?
- Do heavy phone users show worse wellbeing outcomes than light users?
- Are there demographic differences (age, gender, occupation) in phone usage patterns?

---

## Skills Used

- PostgreSQL aggregations
- CTEs
- Correlation analysis
- Percentile calculations
- Cohort analysis
- CASE expressions
- Data quality checks
---
 
## Queries

Full SQL available in [`phoneuse_queries.sql`](phoneuse_queries.sql) .

| # | Query | Description |
|---|-------|-------------|
| 1 | Basic distributions | Average phone usage, sleep and productivity across the full dataset |
| 2 | Correlation matrix | Pearson correlation between all numeric variables |
| 3 | Phone usage buckets | Users grouped into 2h ranges, compared by sleep, stress and productivity |
| 4 | Phone hours percentiles | Q1, median and Q3 of daily phone usage |
| 5 | Age groups vs productivity | Median and average productivity score per age cohort |
| 6 | Top occupations by phone usage | Average daily phone hours per occupation group |
| 7 | Device type vs social media use | Proportion of heavy social media users by iOS vs Android |
| 8 | At-risk cohort | Users with low sleep (<5.5h) and high stress (≥8) inspected for phone usage patterns |
| 9 | Heavy vs light users | Cohort split at 6h/day, compared by sleep, productivity and stress |
| 10 | Gender breakdown | Phone usage and wellbeing metrics by gender |

---

## Results
### Basic distributions 
The dataset contains 50,000 records. Average daily phone usage is 6.51 hours, average sleep 6.50 hours, and average productivity score 5.50. All values sit near the midpoint of their respective ranges, which is expected for synthetically generated data.

### Correlation matrix
No meaningful linear relationships were found between any pair of numeric variables (all |r| < 0.01). The matrix confirms complete independence across all columns, consistent with the synthetic nature of the dataset.

### Phone usage buckets 
Users were split into five groups by daily phone hours. Productivity, sleep, and stress levels remained virtually identical across all buckets (productivity 5.49–5.51, sleep 6.49–6.51, stress 5.43–5.58). Heavy phone users (8h+) showed no worse outcomes than light users, and notably made up the largest group (18,462 users). No dose-response relationship was observed.

### Phone hours percentiles 
The distribution of daily phone usage is symmetric: 25th percentile at 3.8h, median at 6.5h, and 75th percentile at 9.2h. The equal spread above and below the median suggests a uniform rather than normal distribution, consistent with random data generation.

### Age groups vs productivity 
Median and average productivity scores were compared across five age groups. All groups returned near-identical averages (5.47–5.53) and a median of either 5 or 6 depending on the group's exact distribution. No age-related productivity trend was observed.

### Top occupations by phone usage 
Four occupation groups were identified (Business Owner, Freelancer, Student, Professional), each with roughly 12,000–12,600 users. Average daily phone hours ranged from 6.49 to 6.54 — a difference of 0.05 hours across all groups, which is not meaningful. No occupation showed distinctly higher or lower phone usage.

### Device type vs heavy social media use 
Users were split almost exactly between iOS (24,920) and Android (25,080). Around 66% of users on both platforms exceeded 3 hours of daily social media use, with no meaningful difference between device types (66.10% vs 66.61%). Device choice appears unrelated to social media consumption patterns.

### At-risk cohort (low sleep + high stress) 
Users with sleep under 5.5 hours and stress level of 8 or above were isolated for inspection. Even within this worst-case group, daily phone hours ranged widely from 1.1 to 11.9 hours, with no clustering around high usage. Compared to the dataset average of 6.51 hours, the at-risk cohort shows no elevated phone consumption — further confirming that phone usage is not predictive of stress or sleep outcomes in this dataset.

### Heavy vs light phone users (cohort analysis) 
Users were split into heavy (≥6h/day, n=27,606) and light (<6h/day, n=22,394) phone users. All three outcome metrics were identical across cohorts: sleep 6.50 vs 6.50, productivity 5.50 vs 5.51, stress 5.50 vs 5.50. No difference whatsoever between the two groups.

### Gender breakdown 
The dataset is evenly split across three gender categories (Female 16,679, Male 16,708, Other 16,613). All groups returned virtually identical averages across every metric — phone usage, sleep, stress, and productivity all within 0.03 of each other. The perfect balance between groups is itself a marker of synthetic generation. While near-equal male/female splits are plausible in real datasets, the almost perfectly balanced three-way distribution including "Other" strongly suggests synthetic generation.

---

## Summary
Across every query — correlation matrix, usage buckets, cohort splits, demographic breakdowns — the results tell a single consistent story: nothing correlates with anything.
Phone usage does not predict sleep quality, stress, or productivity. Age, gender, and occupation make no difference. Heavy users look identical to light users. The at-risk cohort (low sleep, high stress) uses their phones no more than everyone else. Every average converges near 5.50 and every percentage near 40%.
This is not a failure of analysis — it is the expected outcome of a uniformly generated synthetic dataset. The value of the project lies in the queries themselves: the methodology is sound, the questions were the right ones to ask, and the same SQL would produce meaningful results on real-world data where correlations actually exist.


